# Hackathon Serverpod

Full-stack app built with [Serverpod](https://serverpod.dev) (Dart backend) and Flutter, for the
**Build Something Real** hackathon, 2026-09-15 to 2026-10-14.

The Dart workspace lives in [`hackathon_serverpod/`](hackathon_serverpod) and holds three packages:

| Package | What it is |
|---|---|
| `hackathon_serverpod_server` | The Serverpod backend: endpoints, models, migrations, run-mode config |
| `hackathon_serverpod_client` | Generated client. Never edited by hand |
| `hackathon_serverpod_flutter` | The Flutter app |

## Requirements

- Flutter **3.44.4** and the Dart SDK it ships (`^3.12.2`)
- The Serverpod CLI, for the hot-reload workflow: `dart install serverpod_cli 4.0.0`
- Docker, only for the containerised backend below

## Run it

Fetch dependencies once, from the workspace root — it resolves all three packages together:

```sh
cd hackathon_serverpod
flutter pub get
```

### Backend, in Docker

Runs the same on Linux, macOS and Windows and needs no Dart toolchain. It expects a `.env` with
dev secrets next to the compose file; `scripts/run_on_phone.sh` generates one automatically, or
copy `.env.example` and fill it in.

```sh
cd hackathon_serverpod/hackathon_serverpod_server
cp .env.example .env    # then replace the changeme values
docker compose up --build server
```

The API is then on `http://localhost:8080`, Insights on `8081`, the web server on `8082`.

### Backend, natively with hot reload

Needs the Serverpod CLI. It starts the server, applies pending migrations, watches for changes and
launches the Flutter app alongside it:

```sh
cd hackathon_serverpod/hackathon_serverpod_server
serverpod start
```

It manages its own embedded PostgreSQL (`database.dataPath` in `config/development.yaml`), so no
container is required. Do not run it at the same time as the Docker backend — both bind 8080-8082.

### The Flutter app on its own

```sh
cd hackathon_serverpod/hackathon_serverpod_flutter
flutter run
```

A build running on a **physical device** cannot reach the server over `localhost`, so point it at
the host machine explicitly:

```sh
flutter run --dart-define=SERVER_URL=http://<your-LAN-IP>:8080/
```

### On an Android phone, end to end

```sh
./hackathon_serverpod/scripts/run_on_phone.sh
```

Brings up the Docker backend, checks `adb`/`flutter` and the connected device, then asks before
building and installing the debug APK. Prompts are in Spanish and take `s` for yes.

## Tests

No Docker needed — the test config manages its own embedded PostgreSQL.

```sh
cd hackathon_serverpod/hackathon_serverpod_server
dart test                                                 # everything
dart test test/integration/greeting_endpoint_test.dart    # one file
dart analyze --fatal-infos
dart format --set-exit-if-changed .
```

## After changing a model or an endpoint

The client and the generated server code are produced from the `.spy.yaml` models and the endpoint
classes. `serverpod start` regenerates incrementally while it runs; otherwise:

```sh
cd hackathon_serverpod/hackathon_serverpod_server
serverpod generate
serverpod create-migration     # only when a model with a `table` changed
```

## Docs

- [`hackathon_serverpod/AGENTS.md`](hackathon_serverpod/AGENTS.md) — working notes: architecture,
  conventions, the hackathon's judging criteria and submission requirements. Also loaded as
  `CLAUDE.md`.
- [`docs/hackathon-rules.pdf`](docs/hackathon-rules.pdf) — the official rules, with a greppable
  text copy in [`docs/hackathon-rules.md`](docs/hackathon-rules.md).

## Status

Serverpod scaffold plus a Flutter shell: two swipeable tabs, "Grupo" and "Tareas", and a coin
balance in the app bar. Auth (email identity provider, JWT) is configured server-side. The screens
are still local placeholders — no custom endpoints or data models yet.
