#!/usr/bin/env bash
# Rebuilds the judges' demo couple on a running server (PRODUCT.md §14):
# two accounts, Ana and Leo, in one couple group with some history, two
# tasks to claim and the shop. Anything the demo accounts had is wiped first,
# so it can be run again whenever someone leaves the demo in a mess.
#
#   ./sembrar_demo.sh                                    # local server
#   ./sembrar_demo.sh https://api.serverpod.youxinlab.com/
#
# The server only answers if its passwords.yaml has `demoSeedSecret` and
# `demoAccountPassword`. The secret is read from DEMO_SEED_SECRET or asked
# for here, without echo; it never goes on the command line.
set -euo pipefail

api_url="${1:-http://localhost:8080/}"
api_url="${api_url%/}/"

secret="${DEMO_SEED_SECRET:-}"
if [ -z "$secret" ]; then
  read -rsp "Secreto de la demo (demoSeedSecret): " secret
  echo
fi
if [ -z "$secret" ]; then
  echo "Sin secreto no se puede sembrar." >&2
  exit 1
fi

# JSON string: escape backslashes and double quotes.
escaped=$(printf '%s' "$secret" | sed 's/\\/\\\\/g; s/"/\\"/g')

echo "Sembrando la demo en $api_url ..."
response=$(curl -sS --fail-with-body -X POST "${api_url}demo/reseed" \
  -H 'Content-Type: application/json' \
  --data-binary @- <<<"{\"secret\":\"$escaped\"}") || {
  echo "El servidor ha fallado: $response" >&2
  exit 1
}

if [ "$response" = "null" ]; then
  echo "Rechazado: el secreto no coincide, o el servidor no tiene demoSeedSecret y demoAccountPassword." >&2
  exit 1
fi

code=${response//\"/}
cat <<EOF
Listo. Grupo «Casa de Ana y Leo», código de invitación $code.
  Ana: ana.demo@example.com
  Leo: leo.demo@example.com
La contraseña de las dos es la demoAccountPassword del servidor.
EOF
