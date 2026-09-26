# Flutter & Serverpod project

This project is a Flutter app (frontend) backed by a Serverpod server (backend). Always build the app's backend with Serverpod.
Build for multiple users, use Serverpod's built-in authentication, which is already set up in `lib/server.dart`.

The user starts the server and Flutter app with `serverpod start`. There is no need to check if the server is running: make the changes and call the `serverpod` MCP tools as needed. If the server is not running, an informative error message will be received from the MCP server. Then STOP and ask the user to start it. NEVER start the server yourself. The Flutter app is started along with it, or can be launched from the MCP tool `spawn_flutter_app`.

While running, `serverpod start` watches for file changes to run incremental code generation and hot reload both the server and the Flutter app.

Calling `serverpod generate` directly is not needed, but might be useful to troubleshoot when an incremental generation fails.

ALWAYS use the MCP server instead of the command line. Use the MCP server to:

- `create_migration` and `apply_migrations` for database (after you change data models).
- `create_repair_migration` if the database has drifted out of sync with the migrations.
- `tail_server_logs` to read logs from the server.
- `tail_flutter_logs` to read the raw stdout/stderr of the Flutter app.
- `hot_reload` / `hot_restart` to reload or restart the server and the Flutter app. ALWAYS call `hot_restart` after doing changes in the Flutter app that may not work with normal hot reload (which is automatically applied).
- `spawn_flutter_app` to start a Flutter app declared under `serverpod: flutter_apps:` in the server `pubspec.yaml`.
- `get_flutter_app_dtd` (Dart tooling daemon) for connecting to the app through the `dart` MCP.

NEVER edit generated code. The server's `lib/src/generated/` directory and the whole `hackathon_serverpod_client` package are rewritten by the code generator. Change the `.spy.yaml` models, the endpoints, or `lib/server.dart` instead.

Migrations are a narrow exception: the `migration.sql` of a generated migration MAY be edited by hand when the generated SQL would lose data — to add a data transformation, or to reach a destructive change through non-destructive steps. Never touch the other files in the migration directory, and keep the schema the SQL ends up with identical to `definition.sql` — new databases are created from that file and never run `migration.sql`.

Tests need no Docker. `config/test.yaml` sets `database.dataPath`, so Serverpod starts and manages the test database (an embedded PostgreSQL) itself, and the project's `docker-compose.yaml` is not used for it. Just run `dart test` in the server package.

Checklist after doing changes, in this order:

- `dart analyze` (CLI)
- `dart format` (CLI)
- `create_migration` and `apply_migrations` (MCP - only if necessary)
- Do `serverpod` MCP `hot_restart` if required (hot reload is done automatically). Will also hot restart Flutter app
- Run tests, if applicable (`dart test` in the server package)
- Check `serverpod` MCP `tail_server_logs` and `tail_flutter_logs` for any issues.

If the user asks you to test the app:

1. Use `get_flutter_app_dtd` (`serverpod` MCP) to get the Flutter app's DTD
2. Pass the DTD to `connect_dart_tooling_daemon` (`dart` MCP) to connect to the app
3. Use `flutter_driver` (`dart` MCP) to navigate through the app

The app is launched from `hackathon_serverpod_flutter/lib/driver.dart`, which starts the Flutter driver extension with text entry emulation turned off so the app stays usable by hand. To let the driver type, set `enableTextEntryEmulation: true` there and `hot_restart` the app.

## Packages

The root `pubspec.yaml` (`name: _`) is a Dart workspace, so a single `flutter pub get` at the root resolves all three packages together against one shared lockfile.

That `pubspec.lock` is **committed on purpose** — four people on Linux, macOS and Windows need identical dependency versions, and the server `Dockerfile` does `COPY pubspec.lock .` and fails without it. Never add it back to `.gitignore`, and never run `flutter pub upgrade` as a side effect of another task: it rewrites the lock for the whole team. Pinned toolchain: Flutter 3.44.4, Dart 3.12.2, Serverpod CLI 4.0.0 (see the README).

- `hackathon_serverpod_server` — the backend. A feature is a directory under `lib/src/`: the `.spy.yaml` model(s) and the `<name>_endpoint.dart` sit next to each other (see `lib/src/groups/`). The auth endpoints in `lib/src/auth/` are one-line subclasses of the `serverpod_auth_idp_server` base endpoints; what they actually expose is configured in `lib/server.dart` (`initializeAuthServices`).
- `hackathon_serverpod_client` — 100% generated from the server. Never hand-edit; the Flutter app depends on it by path.
- `hackathon_serverpod_flutter` — the app. `lib/client.dart` owns the global `client` (a deliberate global, not DI), `lib/main.dart` boots `prototype_app.dart` (now just the `MaterialApp` shell, wired to the real `AuthGate`), and screens live under `lib/features/<feature>/`.

## Commands

On a fresh clone, `dart run tool/init_local_secrets.dart` in the server package creates the git-ignored `config/passwords.yaml` and `.env`; without them neither `serverpod start` nor `dart test` can start. It never overwrites, and nobody should delete an existing `passwords.yaml` — the local embedded database was initialised with that password.

There are two layers enforcing this:
- **Git hooks** (`.githooks/pre-commit`, `.githooks/pre-push`) run `dart format`/`dart analyze --fatal-infos` before a commit and `dart test` before a push — **on the server package only**. They only run once enabled per clone with `git config core.hooksPath .githooks`; run the format/analyze/test commands yourself regardless of whether that's set, rather than relying on the hook to catch it.
- **CI** (`.github/workflows/{format,analyze,tests}.yml`, at the repo root) checks **both packages**, server and app, on every push to `main` or `develop` and on every pull request, so a bypassed or unconfigured hook still gets caught. Each workflow checks the server first and the app second, and runs the app step even when the server one fails, so one PR shows every broken package at once. These are the checks `main`'s protection requires, so the app is held to them too.

Commits go on `develop`; `main` is production. The branch flow is in the [root `AGENTS.md`](../AGENTS.md#branches).

Run each check from the package it covers — these are exactly what CI runs, so passing them locally means passing CI:

```sh
cd hackathon_serverpod_server
dart analyze --fatal-infos          # CI setting; unawaited_futures and avoid_print are on here
dart format --set-exit-if-changed .
dart test                                                    # whole suite
dart test test/integration/wallet_endpoint_test.dart         # one file
dart test -n 'a fine can take the balance negative'          # one test by name
dart test -t integration                                     # the only declared tag (dart_test.yaml)

cd ../hackathon_serverpod_flutter
flutter analyze --fatal-infos
dart format --set-exit-if-changed .
flutter test
```

## Ports and databases

| Port | What |
|---|---|
| 8080 / 8081 / 8082 | API server / Insights / web server (same in every run mode) |
| 8090 / 8091 | compose `postgres` / `redis` |
| 9090 / 9091 | compose `postgres_test` / `redis_test` |

`config/development.yaml` and `config/test.yaml` both set `database.dataPath`, so native `serverpod start` and `dart test` each boot their own embedded PostgreSQL under `.serverpod/`. The compose database services are there for the Docker backend path and for CI. Redis is disabled in every run mode.

## How the app reaches the server

`lib/client.dart` builds the client from `getServerUrl()`, which prefers `--dart-define=SERVER_URL=...`, then falls back to `assets/config.json`, then to `http://localhost:8080/`. The server serves a *runtime* version of that file — `server.dart` mounts `AppConfigRoute` at `/assets/assets/config.json`, filled from the API URL in `config/<mode>.yaml` — so a Flutter **web** build served by the server always gets the right URL, whatever host it runs on.

A build installed on a device never goes through that route: it reads the checked-in `hackathon_serverpod_flutter/assets/config.json`, which pins `http://localhost:8080` — i.e. the phone itself. Any device build that needs the backend has to pass `--dart-define=SERVER_URL=http://<LAN-IP>:8080/`. `scripts/run_on_phone.sh` does: it detects this computer's LAN address, lets whoever runs it correct it, and takes a `SERVER_URL` from the environment instead when one is set.

## Serving the Flutter app from the server

`serverpod: scripts: flutter_build` in the server `pubspec.yaml` builds the Flutter web app into `hackathon_serverpod_server/web/app` (Windows needs `xcopy` because Flutter's `--output` is broken there; both branches `flutter clean` and retry once on failure). `server.dart` mounts that directory at `/` when it exists and otherwise falls back to the `web/pages/build_flutter_app.html` placeholder — so a bare-looking site on port 8082 usually just means the web app has not been built.

## Flutter conventions

Agreed 2026-09-21. They cover the app under `hackathon_serverpod_flutter/lib`.

**The design standard is Playful UI, and it lives in the components.** Read [`docs/DESIGN.md`](../docs/DESIGN.md) before building or changing a screen. The rules that matter most, because they are easy to get wrong:

- **Every button is an `AppButton`** (`lib/ui/app_button.dart`). Never put a `FilledButton`, `OutlinedButton` or `TextButton` in a screen — the press bounce, the haptic and the sound live inside `AppButton`, and a raw Material button silently loses all three. Pick the kind by what the button is for: `primary` (one per screen at most), `secondary`, `quiet` (low-stakes, silent) or `danger` (destructive, always behind `confirmAction`). Add `onBrand` on a violet surface and `compact` in a row.
- **Anything else tappable** — a task card, a reward tile — goes in a `Pressable`, so it bounces and sounds like a button.
- **Five sounds, one meaning each** (`AppSound`): `tap` for a button, `success` when something the user did went through, `coin` when coins come in, `fine` when a fine takes them, `error` when something failed. Never reuse one for something else; never add a sound to a quiet action. They are generated by `tool/generate_ui_sounds.dart` — change a sound there, not by dropping in a downloaded file, which the video rules would then have to clear.
- **Colours, fonts and radii come from `lib/app_theme.dart`.** No `Color(0x…)` literal in a screen.

**No literal anybody reads.** Every string lives in `lib/l10n/app_es.arb` with a `@key` description and reaches the widget through `AppLocalizations.of(context)`. Spanish is the template, English is generated from it later (PLAN.md §8). A hard-coded string in a widget is a bug, not a shortcut — retrofitting them is what makes translation a rewrite instead of a translation.

**Layers, and what each may import:**

| Layer | Where | May import |
|---|---|---|
| Data | `lib/data/` | The generated client. No Flutter widgets, no display text |
| Pieces | `lib/ui/` | Flutter, the l10n, the theme |
| Screens | `lib/features/<feature>/` | Everything above |

- **Only `lib/data/` imports `client`.** A screen calling `client.something` is exactly what this rule prevents: error handling scattered across widgets, and no way to test a screen without a server running.
- Repositories throw `AppException`, never a raw server error. The translation lives in `data/app_failure.dart`, in one function.
- Which sentence a failure shows is decided in the UI, from the ARB (`ui/failure_messages.dart`). The data layer never holds display text.

**State with `provider`** (`ChangeNotifier`, no code generation). Each feature has a `<Feature>Controller extends ChangeNotifier` that owns its `load()` call and any mutations; `HomeShell` builds one instance per controller and exposes them through a `MultiProvider`, so a screen reads its data with `context.watch<TasksController>()` and calls its data-changing methods with `context.read<TasksController>()`. A controller that changes data another screen also shows (e.g. a task vote moving coins) calls its own `load()` again rather than reaching into another controller. Form state stays in the widget: a whole controller for a text field is ceremony, not architecture.

**Reusable before repeated.** A widget wanted by a second screen moves to `lib/ui/`. `CoinAmount` is the first: every amount in the app goes through it, so a balance, a reward's price and a line of history all read the same, with tabular figures so columns line up. Messages and confirmations go through `ui/feedback.dart` (`showMessage`, `confirmAction`) — anything that cannot be undone asks first, and its button names the action, not "Sí".

**One thing per file**, named after it: screens end in `Screen`, repositories in `Repository`. Private helpers stay in the file that uses them until a second file wants one.

**Size.** Past roughly 300 lines, split the file. `prototype_app.dart` used to be the 2555-line counterexample — Mayte's design reference — and has since been broken up into `lib/features/`; it is now a 20-line `MaterialApp` shell pointed at the real `AuthGate`.

## Why this project exists

"Build Something Real", the Serverpod hackathon. Sponsor Serverpod AB, administered by BuilderBase. One full-stack app, any domain, no tracks, on the condition that Serverpod is the backend. The official rules live in the repo: `docs/hackathon-rules.pdf`, with a greppable text extraction beside it at `docs/hackathon-rules.md` (source <https://tinyurl.com/SP-rules>, copied 2026-09-16). They prevail over anything the event site says, and section 11 allows them to be amended mid-event, so re-check the source before relying on a detail close to the deadline. What follows is a working summary, not a substitute.

| When (CEST) | What |
|---|---|
| 2026-09-15 17:30 | Submission Period opens; registration stays open throughout |
| **2026-10-14 23:59** | **Submissions close. The rules say "No extensions"** |
| 2026-10-15 09:00 → 10-20 17:00 | Judging. The Submission is frozen, though the repo may keep moving |
| 2026-10-22 18:00 | Winners announced at the Full Stack Flutter conference |

The first commit here is 2026-09-15 19:46 CEST, inside the window, so the "new projects only" requirement is satisfied.

Judging runs in two stages. **Stage One** is a pass/fail screen: does the Project fit the theme and make reasonable use of the Serverpod stack. A default scaffold behind a UI that never calls it is what fails at this gate. **Stage Two** scores:

| Weight | Criterion | What the Judges look for |
|---|---|---|
| 30% | Does it work | It runs, the core flow completes, **nothing critical is faked** |
| 25% | Use of the Serverpod stack | Doing real work, not sitting behind a static page |
| 25% | Craft and technical creativity | Rough is fine, careless is not |
| 20% | Usefulness | A clear user with a clear problem, and this helps |

Ties are broken on "Does it work" first, then down the list in order.

**The Judges are not required to run the Project.** They may score from the text description, images and video alone, so the demo has to show the core flow actually completing. Presentation quality is explicitly not scored, so the effort goes into the flow, not the edit.

What follows from that:

- Small and finished beats large and broken. Teams reliably finish about a quarter of what they plan, so scope to one user, one problem, one flow, and make that flow real.
- Placeholders in the UI are precisely what the first two criteria penalise. The three the scaffold shipped with — the hardcoded `_members`, the in-memory `_items` and `_coins = 0` — are gone, replaced by real endpoints; keep it that way. A screen with nothing to show says so, it does not invent data.
- Prefer deepening one flow over adding a third tab.
- Serverpod Cloud is the intended deploy target and `lib/server.dart` is already wired for it (`ServerpodCloudEmailIdpConfig`, `ServerpodCloudProvider`); in development, email verification codes are printed to the server console, so sign-in is testable without any mail setup. Outside Serverpod Cloud those emails are not sent unless the provider is switched to `EmailIdpConfigFromPasswords` with a real mail sender — self-hosting without doing that leaves judges stuck at sign-up.
- Hosting: registrants get **one month of free Serverpod Cloud hosting** (welcome pack); the Starter plan is $5/month after that. The deployment has to stay reachable until judging ends on **2026-10-20 17:00**, so a free month that starts counting before about 21 September runs out mid-judging — budget the extra days rather than let it lapse. Deploy with `serverpod cloud launch` (docs: <https://docs.serverpod.dev/cloud>). Deploying creates a live, billable service: it is the team's decision, never a side effect of another task.
- Two side prizes reward things that are cheap to do while building, and both stack with an overall prize. *Most Valuable Feedback* needs a registered Entrant, an eligible Submission **and** a separate feedback form filed before the deadline, containing actionable material — bug reports, UI improvements, suggested integrations for the Serverpod SDKs, App Studio or the docs. One per Entrant. So Serverpod friction is worth noting as it is hit, not reconstructed on 14 October. *Best Hackathon Post* is a public post, published in the same window, that clearly identifies the Hackathon (the organisers use the hashtag `#buildsomethingreal`); only the best one counts.
- Support comes from the Serverpod team on Discord (see Links below), which is also where Serverpod friction and bugs are best raised before they go into the feedback form.

## Links

| What | Where |
|---|---|
| Serverpod documentation | <https://docs.serverpod.dev> |
| Serverpod Cloud docs (deploying) | <https://docs.serverpod.dev/cloud> |
| Serverpod Cloud (plans, free month) | <https://serverpod.dev/cloud> |
| App Studio — the all-in-one install; **no Windows build**, so on Windows use the CLI as in the README | <https://serverpod.dev/appstudio> |
| Serverpod Discord — support from the Serverpod team | <https://discord.gg/wJ4pQeHhVc> |
| Hackathon page — registration, team, submission form | <https://builderbase.com/event/build-something-real-the-serverpod-hackathon> |
| Official rules (local copy in `docs/`) | <https://tinyurl.com/SP-rules> |

For Serverpod-specific questions, prefer the documentation (or the local `serverpod-*` agent skills, when present) over memory: Serverpod 4 is new, and much of what is written about Serverpod online describes 2.x and 3.x.

## What the submission has to contain

Graded deliverables beyond the code, all of it in English or with an English translation — the UI being in Spanish is fine, the submission materials are not:

- **A repo URL** with all source, assets and instructions needed to make the Project work. A private repo that is not the one created under Serverpod's GitHub org has to be shared with `viktor@`, `alexander@` and `isak@serverpod.dev`.
- **Build and run instructions.** A requirement, not a nicety. `scripts/run_on_phone.sh` and the Docker path are most of the answer already; the root `README.md` is the natural home for them and is currently stale.
- **A text description** of the features and how it was built, which **must disclose the use of AI and agentic tooling**. Using it is expressly encouraged; failing to disclose it is a rules breach.
- **A demo video under 2 minutes**, publicly visible on YouTube or Vimeo, showing the Project running on its target device, free of third-party marks and music.
- **Working access for testing** — a link, a demo or a test build — free and unrestricted until judging ends, with credentials included if anything is gated.

Third-party SDKs, APIs and data need to be licensed for this use; open-source components are allowed provided the Project builds on top of them rather than merely repackaging them.

## About this app

A household-chores app where the group agrees on every task and pays for it in coins (see
`docs/PRODUCT.md`). The look is Mayte's: Fredoka and Nunito Sans, violet on cream, held in
`lib/app_theme.dart`. `prototype_app.dart` started as her 2555-line static design reference and is
now the app's real `MaterialApp` shell — `main.dart` runs it, and it points at `AuthGate`.

What runs today, all against the server: email sign-in, creating a group or joining one by code,
the group screen (members, invite code, and for the admin, expelling a member and replacing the
code), the wallet with its history, proposing/voting/counter-offering/validating tasks, and
browsing/proposing/voting/buying shop rewards, and signing out. The backend has groups, wallet,
shop and the whole task cycle; `docs/PLAN.md` says what is left and when. Endpoints the app does
not call yet: `listPurchases`, `respondToPurchase`, `markDelivered`, `requestWish`,
`approveChildPurchase`, `transferAdmin` and `getWeeklyRanking`.

User-facing strings and the scripts are in Spanish; `run_on_phone.sh`
prompts take `s`/`si` as yes. Commit messages follow Conventional Commits
(`feat:`, `docs:`, `chore:`, `style:`).

`scripts/run_on_phone.sh` first brings up the backend with Docker (checks
docker is installed/running, generates `hackathon_serverpod_server/.env`
with dev secrets if missing, `docker compose up --build`) so it runs the
same on Linux/Windows/Mac without installing Dart — see
`hackathon_serverpod_server/docker-compose.yaml` (the `server` service runs
in the repurposed "staging" mode, `config/staging.yaml`, since `--mode` only
accepts development/staging/production/test). It then detects a connected
Android phone over adb, checks that `adb`/`flutter` are installed and the
device is authorized, and asks for confirmation before building+installing
the debug APK and again before opening the app.

For local hot-reload development instead (the MCP workflow above), keep
using native `serverpod start` — don't run it at the same time as the
Docker backend, both bind ports 8080-8082.
