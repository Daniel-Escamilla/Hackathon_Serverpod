#!/usr/bin/env bash
# Run from this computer once the DNS records exist. Adds the two Serverpod
# sites to the VPS's Caddy, keeping a backup, and only reloads if the result
# validates. Nothing else Caddy serves is touched.
set -euo pipefail

host=ubuntu@51.254.219.217
ip=51.254.219.217

for name in serverpod.youxinlab.com api.serverpod.youxinlab.com; do
  if [ "$(dig +short "$name" | tail -1)" != "$ip" ]; then
    echo "$name todavía no apunta a $ip. Crea el registro A en Cloudflare (nube gris) y espera un minuto."
    exit 1
  fi
done
echo "DNS correcto."

ssh -t "$host" '
  set -e
  if grep -q "serverpod.youxinlab.com" /etc/caddy/Caddyfile; then
    echo "Caddy ya tiene los sitios de Serverpod; no se añade nada."
  else
    sudo cp /etc/caddy/Caddyfile /etc/caddy/Caddyfile.antes-serverpod
    sudo sh -c "cat ~ubuntu/hackathon-serverpod/Caddyfile.serverpod >> /etc/caddy/Caddyfile"
  fi
  if sudo caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile >/dev/null 2>&1; then
    sudo systemctl reload caddy
    echo "Caddy recargado."
  else
    echo "El Caddyfile no valida: se restaura la copia y no se recarga nada."
    sudo cp /etc/caddy/Caddyfile.antes-serverpod /etc/caddy/Caddyfile
    exit 1
  fi
'

echo "Esperando a los certificados..."
for i in $(seq 1 30); do
  web=$(curl -s -o /dev/null -w '%{http_code}' https://serverpod.youxinlab.com/ || true)
  api=$(curl -s -o /dev/null -w '%{http_code}' https://api.serverpod.youxinlab.com/ || true)
  if [ "$web" = 200 ] && [ "$api" = 200 ]; then
    echo "Listo: https://serverpod.youxinlab.com"
    exit 0
  fi
  sleep 2
done
echo "Aún no responde por HTTPS (web=$web api=$api). Mira: ssh $host 'sudo journalctl -u caddy -n 30'"
exit 1
