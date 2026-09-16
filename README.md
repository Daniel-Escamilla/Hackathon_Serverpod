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

Four people on three operating systems work on this, so what gets pinned is the versions, not
the platform. Check yours with `flutter --version` and `serverpod --version`.

| Tool | Version | Why this one |
|---|---|---|
| Flutter | **3.44.4** | What CI runs; `pubspec.yaml` requires `^3.44.4` |
| Dart | **3.12.2** | Ships with that Flutter; the server Dockerfile builds on `dart:3.12.2` |
| Serverpod CLI | **4.0.0** | Same as the `serverpod` package. `dart install serverpod_cli 4.0.0` — it prints where it put the binary and warns if that directory is not on your PATH |
| Docker | any recent | Optional, only for the containerised backend below |

`pubspec.lock` is committed on purpose. `flutter pub get` honours it, so everyone resolves the
same dependencies. Don't run `flutter pub upgrade` without agreeing it with the team — it
rewrites the lock for everybody.

## Run it

Once, after cloning — fetch dependencies from the workspace root, then generate your local
secrets:

```sh
cd hackathon_serverpod
flutter pub get
cd hackathon_serverpod_server
dart run tool/init_local_secrets.dart
```

The script creates `config/passwords.yaml` (for `serverpod start` and `dart test`) and `.env`
(for Docker) with random values. Both are git-ignored and personal: never commit them, never share
them. It never overwrites an existing file, so running it again is safe.

Then, from the repo root, enable the git hooks (one-time, per clone):

```sh
git config core.hooksPath .githooks
```

`.githooks/pre-commit` runs `dart format`/`dart analyze --fatal-infos`, `.githooks/pre-push` runs
`dart test` — both scoped to `hackathon_serverpod_server`, the same checks CI
(`.github/workflows/`) runs again server-side either way.

**Windows:** if the clone fails with `Filename too long`, run
`git config --global core.longpaths true` and clone again — the Android sources are nested deep
enough to cross the 260-character path limit in a long base folder.

**Ports:** the backend needs 8080-8082 free (and 8090 for the Docker database). If another
project's containers hold them, stop those first; nothing here will start while they are taken.

### Backend, in Docker

Runs the same on Linux, macOS and Windows. It needs the `.env` created by
`tool/init_local_secrets.dart` above (without Dart, `scripts/run_on_phone.sh` generates one too,
or copy `.env.example` and fill it in).

```sh
cd hackathon_serverpod/hackathon_serverpod_server
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

- [Serverpod documentation](https://docs.serverpod.dev) — this project targets Serverpod **4.0**; much
  older material online covers 2.x and 3.x.
- [`TEAM.md`](TEAM.md) — who we are, who represents the team, how a prize is shared.
- [`hackathon_serverpod/AGENTS.md`](hackathon_serverpod/AGENTS.md) — working notes: architecture,
  conventions, the hackathon's judging criteria and submission requirements. Also loaded as
  `CLAUDE.md`.
- [`docs/hackathon-rules.pdf`](docs/hackathon-rules.pdf) — the official rules, with a greppable
  text copy in [`docs/hackathon-rules.md`](docs/hackathon-rules.md).

## Status

Serverpod scaffold plus a Flutter shell: two swipeable tabs, "Grupo" and "Tareas", and a coin
balance in the app bar. Auth (email identity provider, JWT) is configured server-side. The screens
are still local placeholders — no custom endpoints or data models yet.
