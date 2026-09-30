#!/usr/bin/env bash
# Prints the .env for the VPS: fresh random secrets, plus the Google client
# secret taken from this machine's config/passwords.yaml. Pipe it straight to
# the server so it is never shown or saved locally:
#   ./make_env.sh | ssh ubuntu@51.254.219.217 'umask 077; cat > ~/hackathon-serverpod/.env'
set -euo pipefail

cd "$(dirname "$0")/../../hackathon_serverpod_server"

rand() { openssl rand -hex 32; }

google=$(python3 - <<'PY'
import json, sys, yaml
dev = yaml.safe_load(open('config/passwords.yaml'))['development']
secret = dev.get('googleClientSecret')
if secret:
    # One line, so it fits in an env file.
    print(json.dumps(json.loads(secret), separators=(',', ':')))
PY
)

echo "SERVERPOD_DATABASE_PASSWORD=$(rand)"
echo "SERVERPOD_SERVICE_SECRET=$(rand)"
echo "SERVERPOD_PASSWORD_emailSecretHashPepper=$(rand)"
echo "SERVERPOD_PASSWORD_jwtHmacSha512PrivateKey=$(rand)$(rand)"
echo "SERVERPOD_PASSWORD_jwtRefreshTokenHashPepper=$(rand)"
if [ -n "$google" ]; then
  # Single quotes keep the JSON's double quotes as they are.
  echo "SERVERPOD_PASSWORD_googleClientSecret='$google'"
else
  echo "googleClientSecret missing from passwords.yaml: Google sign-in stays off" >&2
fi
