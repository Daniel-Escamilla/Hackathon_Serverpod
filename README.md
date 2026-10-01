# Hackathon Serverpod

Full-stack app built with [Serverpod](https://serverpod.dev) (Dart backend) and Flutter, for the
**Build Something Real** hackathon, 2026-09-15 to 2026-10-14.

A household-chores app where the group agrees on every task and pays for it in coins: someone
proposes a task and its price, the group votes on it, anyone does it, the group confirms it was
done, and the coins go to a wallet spent in a shop the group sets up. What it does and how it was
built, including the use of AI tooling: [`docs/SUBMISSION.md`](docs/SUBMISSION.md).

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

`hackathon_serverpod/.fvmrc` pins the same Flutter for [fvm](https://fvm.app): with it
installed, `fvm flutter …` inside the workspace runs 3.44.4 whatever else is on your PATH.

`pubspec.lock` is committed on purpose. `flutter pub get` honours it, so everyone resolves the
same dependencies. Don't run `flutter pub upgrade` without agreeing it with the team — it
rewrites the lock for everybody.

## Branches

Work goes on **`develop`**; **`main`** is production and only gets what already works on `develop`.

```sh
git switch develop
```

When `develop` is tested and the team agrees, someone merges it into `main`. The rest is in
[`AGENTS.md`](AGENTS.md#branches).

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
`dart test` — both on `hackathon_serverpod_server` only. CI (`.github/workflows/`) runs those
again, and the same three checks on the Flutter app, on every push and pull request.

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

It runs in staging mode, where the email verification codes are sent through Serverpod Cloud, so
they never show up locally. To register accounts on your machine, use `serverpod start` below.

### Backend, natively with hot reload

Needs the Serverpod CLI. It starts the server, applies pending migrations, watches for changes and
launches the Flutter app alongside it:

```sh
cd hackathon_serverpod/hackathon_serverpod_server
serverpod start
```

It manages its own embedded PostgreSQL (`database.dataPath` in `config/development.yaml`), so no
container is required. Do not run it at the same time as the Docker backend — both bind 8080-8082.

Registration and password-reset codes are printed in this console. In this mode each vote stays
open for two minutes instead of 24 hours; set `TASK_VOTE_WINDOW_SECONDS` to change it, e.g.
`TASK_VOTE_WINDOW_SECONDS=600 serverpod start`.

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

Brings up the Docker backend, checks `adb`, Flutter and the connected device, then asks before
building and installing the debug APK. Prompts are in Spanish and take `s` for yes.

With the Serverpod CLI installed it first offers to finish with `serverpod start` instead of the
Docker server: it stops the Docker server, installs the app and then runs `serverpod start` in the
same terminal, opening the app on the phone once the server answers. That mode is the one that
prints the email verification codes; the Docker server runs in staging mode, which sends them
through Serverpod Cloud instead.

It builds with `fvm flutter` when fvm is installed. Without it, it uses the `flutter` on your
PATH and asks before going on if that is not 3.44.4: another version rewrites `pubspec.lock` on
its implicit `pub get`.

The APK is built against this computer's LAN address, which the script detects and lets you
correct, so the phone has to be on the same Wi-Fi. To point it somewhere else, set it up front:
`SERVER_URL=https://<host>/ ./hackathon_serverpod/scripts/run_on_phone.sh`.

### Sign in with Google

The code is in the repo; the one secret it needs is not. Without it the server still boots and
everything else works; only "Entrar con Google" fails.

1. **Get the secret privately** from whoever holds it (Daniel): the `googleClientSecret` block,
   through a password manager or a one-time link. Never through git, an issue or the team chat.
2. **Paste it** into your `hackathon_serverpod_server/config/passwords.yaml`, under
   `development:`, indented two spaces like the other keys:

   ```yaml
   development:
     # ...the keys already there...
     googleClientSecret: |
       {
         "web": {
           "client_id": "266308220325-jvpioj5f1pldrqqj7ika3ujqrfmb22n5.apps.googleusercontent.com",
           "client_secret": "<the secret>",
           "redirect_uris": ["http://localhost:8082/auth/callback"],
           ...
         }
       }
   ```

   For the Docker backend, which runs in staging mode, the same JSON goes in `.env` as
   `SERVERPOD_PASSWORD_googleClientSecret`.
3. **On the web, open the app from the server, not from `flutter run`.** Google only accepts the
   origin registered in Google Cloud Console, `http://localhost:8082`:

   ```sh
   cd hackathon_serverpod/hackathon_serverpod_flutter
   flutter build web --base-href / --output ../hackathon_serverpod_server/web/app
   ```

   Then (re)start `serverpod start` and open <http://localhost:8082>. Rebuild after changing the
   app.
4. **On Android**, send Daniel your debug SHA-1 so it is registered in Google Cloud Console for
   the package `com.example.hackathon_serverpod_flutter`:

   ```sh
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android | grep SHA1
   ```

While the Google consent screen is in *Testing* mode, only the Google accounts listed as test
users can sign in: ask to be added.

### The judges' demo accounts

A task needs two people and a judge opens the app alone, so the submission hands over two accounts
of a couple, **Ana** (`ana.demo@example.com`) and **Leo** (`leo.demo@example.com`), already in a
group with some history, two tasks to claim and the shop. `scripts/sembrar_demo.sh` builds it on a
running server, wiping whatever the two accounts had, so it can be run again any time:

```sh
cd hackathon_serverpod/scripts
./sembrar_demo.sh                                   # the local server
./sembrar_demo.sh https://<api host>/               # a deployed one
```

The server has to have two entries in its `config/passwords.yaml`, under the run mode it uses
(`development` locally); without them it refuses every call:

```yaml
  demoSeedSecret: '<any long random string>'      # what the script asks for
  demoAccountPassword: '<the password the judges get>'
```

No vote is left open in the demo: it would close by itself after the vote window and fine
whoever had not voted. The judges start every vote themselves.

## Tests

No Docker needed — the test config manages its own embedded PostgreSQL.

```sh
cd hackathon_serverpod/hackathon_serverpod_server
dart test                                                 # everything
dart test test/integration/wallet_endpoint_test.dart      # one file
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
- [`docs/PRODUCT.md`](docs/PRODUCT.md) — what we are building: the profiles, the task cycle and its
  voting rules, the shop, the architecture and the agreed scope. In Spanish, the team's working
  language. Written 2026-09-17.
- [`docs/PLAN.md`](docs/PLAN.md) — when and who: the MVP cut, the video script that defines it, the
  four weeks task by task and the dates that do not move. In Spanish. Written 2026-09-18.
- [`docs/SUBMISSION.md`](docs/SUBMISSION.md) — the submission's text description: features, how it
  was built and the use of AI tooling. In English, as the rules require.
- [`docs/DESIGN.md`](docs/DESIGN.md) — the design standard, Playful UI: the rules for a new screen,
  the `lib/ui/` components, colour and type tokens, the press bounce, and the five UI sounds and what
  each one means. In Spanish.
- [`docs/FEEDBACK.md`](docs/FEEDBACK.md) — Serverpod friction as we hit it, for the Most Valuable
  Feedback prize. In English, because that is what goes into the form.
- [`CHANGELOG.md`](CHANGELOG.md) — what each version adds and fixes. A version is what reaches
  `main`, tagged `v<version>`.
- [`TEAM.md`](TEAM.md) — who we are, who represents the team, how a prize is shared.
- [`AGENTS.md`](AGENTS.md) — the entry point for any coding agent (Codex, Claude Code, Gemini CLI,
  Cursor…): what to read first, the rules that hold everywhere and the commands with and without MCP.
  Plain Markdown, no tool-specific format; `CLAUDE.md` just points at it.
- [`hackathon_serverpod/AGENTS.md`](hackathon_serverpod/AGENTS.md) — working notes: architecture,
  conventions, the hackathon's judging criteria and submission requirements. Also loaded as
  `CLAUDE.md`.
- [`docs/hackathon-rules.pdf`](docs/hackathon-rules.pdf) — the official rules, with a greppable
  text copy in [`docs/hackathon-rules.md`](docs/hackathon-rules.md).

## Status

Working end to end against the real backend: accounts (sign-up with a verification code, sign-in,
password reset), groups (create, join by code, admin settings, expelling), the whole task cycle
(propose, vote, counter-offer, claim, validate, fines, votes that expire), the shop (templates,
proposals and their vote, buying, the provider's answer, delivery), the wallet and its history, and
live updates between phones. Family mode, recurring tasks and the weekly ranking screen are out of
scope for now; see [`docs/PLAN.md`](docs/PLAN.md).
