#!/usr/bin/env bash
# Detects a connected Android phone, checks that adb/flutter are installed
# and the device is ready, then asks for confirmation before installing and
# before opening the app.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLUTTER_PROJECT_DIR="$SCRIPT_DIR/../hackathon_serverpod_flutter"
APP_ID="com.example.hackathon_serverpod_flutter"
MIN_SDK=21

FRAMES="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
GREEN='\033[32m'
RED='\033[31m'
YELLOW='\033[33m'
RESET='\033[0m'

ok() { printf "\r  ${GREEN}✓${RESET} %-40s\n" "$1"; }
fail() { printf "\r  ${RED}✗${RESET} %-40s\n" "$1"; }

# Cosmetic spinner, then runs the check command and reports the result.
# Usage: check "label" "shell command" ; check-exit-status is returned.
check() {
  local label="$1"
  local cmd="$2"
  local frames_len=${#FRAMES}
  local i=0
  while [ $i -lt 6 ]; do
    printf "\r  %s %s" "${FRAMES:$((i % frames_len)):1}" "$label"
    sleep 0.02
    i=$((i + 1))
  done
  if eval "$cmd" >/dev/null 2>&1; then
    ok "$label"
    return 0
  else
    fail "$label"
    return 1
  fi
}

# Animated spinner tied to an actual background command (for slow steps).
# Usage: run_with_spinner "label" command args...
run_with_spinner() {
  local label="$1"
  shift
  local log
  log="$(mktemp)"
  ("$@") </dev/null >"$log" 2>&1 &
  local pid=$!
  local frames_len=${#FRAMES}
  local i=0
  while kill -0 "$pid" 2>/dev/null; do
    printf "\r  %s %s" "${FRAMES:$((i % frames_len)):1}" "$label"
    sleep 0.08
    i=$((i + 1))
  done
  wait "$pid"
  local status=$?
  if [ $status -eq 0 ]; then
    ok "$label"
  else
    fail "$label"
    cat "$log"
  fi
  rm -f "$log"
  return $status
}

confirm() {
  local reply
  read -r -p "$1 [s/N] " reply
  case "$reply" in
    [sSyY]|[sS][iI]) return 0 ;;
    *) return 1 ;;
  esac
}

echo "Comprobando requisitos..."
echo

MISSING_TOOLS=()
check "adb en PATH"     "command -v adb"     || MISSING_TOOLS+=("adb")
check "flutter en PATH" "command -v flutter" || MISSING_TOOLS+=("flutter")

if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
  echo
  echo -e "${YELLOW}Faltan herramientas necesarias.${RESET}"
  for tool in "${MISSING_TOOLS[@]}"; do
    case "$tool" in
      adb)
        if confirm "adb no está instalado. ¿Instalarlo ahora (apt: android-sdk-platform-tools)?"; then
          run_with_spinner "Instalando adb" sudo apt-get install -y android-sdk-platform-tools \
            || { echo "No se pudo instalar adb. Instálalo manualmente y vuelve a lanzar el script."; exit 1; }
        else
          echo "No se puede continuar sin adb."; exit 1
        fi
        ;;
      flutter)
        if confirm "flutter no está instalado. ¿Instalarlo ahora (snap --classic)?"; then
          run_with_spinner "Instalando Flutter" sudo snap install flutter --classic \
            || { echo "No se pudo instalar Flutter. Instálalo manualmente y vuelve a lanzar el script."; exit 1; }
        else
          echo "No se puede continuar sin flutter."; exit 1
        fi
        ;;
    esac
  done
  echo
fi

echo "Buscando dispositivo Android por USB..."
echo

DEVICE_ID=""
DEVICE_STATE=""
i=0
frames_len=${#FRAMES}
while [ $i -lt 150 ]; do
  line=$(adb devices | tail -n +2 | grep -v '^$' | head -n1)
  if [ -n "$line" ]; then
    DEVICE_ID=$(echo "$line" | awk '{print $1}')
    DEVICE_STATE=$(echo "$line" | awk '{print $2}')
    break
  fi
  printf "\r  %s Esperando móvil conectado por USB..." "${FRAMES:$((i % frames_len)):1}"
  sleep 0.2
  i=$((i + 1))
done

if [ -z "$DEVICE_ID" ]; then
  fail "Ningún dispositivo detectado"
  echo "Conecta el móvil por USB con la depuración USB activada y vuelve a lanzar el script."
  exit 1
fi
ok "Dispositivo detectado: $DEVICE_ID"

if [ "$DEVICE_STATE" != "device" ]; then
  fail "Dispositivo no autorizado (estado: $DEVICE_STATE)"
  echo "Acepta el diálogo \"¿Confiar en este equipo?\" en la pantalla del móvil y vuelve a lanzar el script."
  exit 1
fi
ok "Dispositivo autorizado"

SDK_VERSION=$(adb -s "$DEVICE_ID" shell getprop ro.build.version.sdk </dev/null 2>/dev/null | tr -d '\r')
if [ -z "$SDK_VERSION" ] || [ "$SDK_VERSION" -lt "$MIN_SDK" ] 2>/dev/null; then
  fail "Versión de Android insuficiente (API $SDK_VERSION, se necesita >= $MIN_SDK)"
  exit 1
fi
ok "Versión de Android compatible (API $SDK_VERSION)"

echo
if ! confirm "¿Instalar la app en $DEVICE_ID?"; then
  echo "Cancelado."
  exit 0
fi

build_apk() {
  cd "$FLUTTER_PROJECT_DIR" && flutter build apk --debug --target=lib/main.dart
}
run_with_spinner "Compilando APK debug" build_apk || exit 1

APK_PATH="$FLUTTER_PROJECT_DIR/build/app/outputs/flutter-apk/app-debug.apk"
run_with_spinner "Instalando en $DEVICE_ID" adb -s "$DEVICE_ID" install -r "$APK_PATH" \
  || exit 1

echo
if confirm "¿Abrir la app ahora?"; then
  run_with_spinner "Abriendo app" adb -s "$DEVICE_ID" shell monkey -p "$APP_ID" \
    -c android.intent.category.LAUNCHER 1
else
  echo "App instalada, no se ha abierto."
fi
