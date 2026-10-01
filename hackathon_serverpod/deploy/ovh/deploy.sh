#!/usr/bin/env bash
# Builds the backend with the web app inside and publishes it on the OVH VPS,
# at https://serverpod.youxinlab.com. With --apk it also builds the Android
# app against that server and serves it at https://serverpod.youxinlab.com/app.apk.
#
#   ./deploy.sh                         # what is on origin/develop
#   ./deploy.sh --apk                   # the same, plus the APK
#   ./deploy.sh fix/foo feat/bar        # develop with those branches merged in,
#                                       # to try them before their pull requests merge
#
# Builds from a clean checkout in a temporary folder, so uncommitted changes
# here are never published. The database and .env on the VPS are left as
# they are; migrations apply on boot.
set -euo pipefail

host=ubuntu@51.254.219.217
remote_dir=hackathon-serverpod
api_url=https://api.serverpod.youxinlab.com/
web_url=https://serverpod.youxinlab.com

apk=false
branches=()
for arg in "$@"; do
  case "$arg" in
    --apk) apk=true ;;
    -h|--help) sed -n 2,14p "$0"; exit 0 ;;
    *) branches+=("$arg") ;;
  esac
done

# The pinned toolchain when fvm has it, as everywhere else in the repo.
if [ -x "$HOME/fvm/versions/3.44.4/bin/flutter" ]; then
  export PATH="$HOME/fvm/versions/3.44.4/bin:$PATH"
fi

repo="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"
work="$(mktemp -d)"
cleanup() { git -C "$repo" worktree remove --force "$work" >/dev/null 2>&1 || rm -rf "$work"; }
trap cleanup EXIT

echo "==> Checkout de origin/develop${branches[*]:+ + ${branches[*]}}"
git -C "$repo" fetch -q origin
git -C "$repo" worktree add -q --detach "$work" origin/develop
for branch in "${branches[@]}"; do
  git -C "$work" -c user.name=deploy -c user.email=deploy@local \
    merge -q --no-edit "origin/$branch"
done
echo "    $(git -C "$work" log --oneline -1)"

cd "$work/hackathon_serverpod"
flutter pub get >/dev/null

echo "==> Web"
(cd hackathon_serverpod_flutter &&
  flutter build web --base-href / --output ../hackathon_serverpod_server/web/app >/dev/null)

if $apk; then
  echo "==> APK (contra $api_url)"
  (cd hackathon_serverpod_flutter &&
    flutter build apk --release --dart-define=SERVER_URL="$api_url" >/dev/null)
  cp hackathon_serverpod_flutter/build/app/outputs/flutter-apk/app-release.apk \
    hackathon_serverpod_server/web/app/app.apk
fi

echo "==> Imagen Docker"
docker build -q -f hackathon_serverpod_server/Dockerfile -t hackathon-serverpod:ovh . >/dev/null

echo "==> Subiendo al VPS"
docker save hackathon-serverpod:ovh | gzip | ssh "$host" 'gunzip | sudo docker load' >/dev/null
ssh "$host" "cd ~/$remote_dir && sudo docker compose up -d" 2>&1 | grep -v "Running$" || true

echo "==> Comprobando"
# Straight to the VPS, so a stale DNS cache on this network cannot fool it.
ip=${host#*@}
pin=(--resolve "serverpod.youxinlab.com:443:$ip" --resolve "api.serverpod.youxinlab.com:443:$ip")
for _ in $(seq 1 30); do
  if [ "$(curl -s "${pin[@]}" -o /dev/null -w '%{http_code}' "$web_url/")" = 200 ] &&
     [ "$(curl -s "${pin[@]}" -o /dev/null -w '%{http_code}' "$api_url")" = 200 ]; then
    echo "Publicado: $web_url"
    $apk && echo "APK: $web_url/app.apk"
    exit 0
  fi
  sleep 2
done
echo "No responde tras 60 s. Logs: ssh $host 'sudo docker logs --tail 50 hackathon-serverpod-server-1'"
exit 1
