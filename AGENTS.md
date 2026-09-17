# AGENTS.md

Shared instructions for any coding agent working in this repository — Codex, Claude Code, Gemini CLI,
Cursor or whatever comes next. Everything is plain Markdown on purpose, with no tool-specific format.

`CLAUDE.md` files here are one-line pointers to the `AGENTS.md` beside them; there is nothing in them
that this file does not say. If your tool looks for another filename, read these `AGENTS.md` files
anyway — they are the instructions.

## Where things are

| File | What it is | Read it when |
|---|---|---|
| [`docs/PRODUCT.md`](docs/PRODUCT.md) | **What we are building**: profiles, the task cycle and its voting rules, fines, shop, architecture, agreed scope and what is still open. In Spanish | Before designing, planning or implementing any feature |
| [`hackathon_serverpod/AGENTS.md`](hackathon_serverpod/AGENTS.md) | **How to work in the code**: packages, commands, ports, conventions, the MCP workflow and the hackathon's judging criteria | Before touching code |
| [`README.md`](README.md) | Required tool versions and how to run the backend, the app and the tests | Setting up, or running anything |
| [`TEAM.md`](TEAM.md) | Members, representative, ownership and prize split | Anything about authorship or the submission |
| [`docs/hackathon-rules.md`](docs/hackathon-rules.md) | The official rules, a text copy of the PDF beside it | A deadline or eligibility question |

The code lives in the Dart workspace [`hackathon_serverpod/`](hackathon_serverpod): the Serverpod
server, the generated client and the Flutter app.

## Rules that hold everywhere

- **Serverpod is the backend and Flutter the frontend.** That is a condition of the hackathon, not a
  preference.
- **Never edit generated code**: the server's `lib/src/generated/` and the whole
  `hackathon_serverpod_client` package are rewritten by the generator. Change the `.spy.yaml` models,
  the endpoints or `lib/server.dart` and regenerate.
- **Never start the server yourself.** Ask whoever is at the keyboard to run `serverpod start` in
  `hackathon_serverpod/hackathon_serverpod_server`.
- **Never run `flutter pub upgrade`** as a side effect of another task: `pubspec.lock` is committed and
  shared by four people on three operating systems.
- Pinned toolchain: **Flutter 3.44.4, Dart 3.12.2, Serverpod CLI 4.0.0**.
- User-facing strings and the shell scripts are in **Spanish**; code, identifiers and the English docs
  stay in English.
- Commit messages follow **Conventional Commits** (`feat:`, `fix:`, `docs:`, `chore:`, `style:`) and
  **never** carry a `Co-Authored-By:` line.
- **Deploying to Serverpod Cloud is the team's decision**, never a side effect of another task: it
  creates a live, billable service.
- Serverpod 4 is new. Prefer the documentation at <https://docs.serverpod.dev> over memory — most of
  what is written online describes 2.x and 3.x.

## Branches

Two long-lived branches. `develop` is where the work goes; `main` is production.

| Branch | What it is | How it moves |
|---|---|---|
| `develop` | **Integration.** Everything lands here first — features, fixes, docs. Branch from it and open pull requests against it | Commits and merged pull requests |
| `main` | **Production.** Only what has already been tested on `develop`. It is what a judge, a clone or a deploy reads, so it should always be in a state we would show | Only a deliberate merge from `develop` |

- **Commit to `develop`, never straight to `main`.** If you are unsure where you are,
  `git branch --show-current` before committing.
- Anything big enough to break the others gets its own branch off `develop` (`feat/…`, `fix/…`) and
  comes back through a pull request.
- **Promoting to production is the team's decision**, like deploying to Serverpod Cloud: once
  `develop` has been tested, someone merges it on purpose, never as a side effect of another task.

  ```sh
  git switch main && git merge --no-ff develop && git push origin main
  ```

CI (`.github/workflows/`) runs `analyze`, `format` and `tests` on push and pull request for both
branches, so `develop` is checked before anything reaches `main`.

## Commands, with and without MCP

Some tools connect to the `serverpod` and `dart` MCP servers declared in `.mcp.json`; Claude Code does.
**If yours does not, nothing is lost** — everything has a command-line equivalent. Run these from
`hackathon_serverpod/hackathon_serverpod_server` unless it says otherwise.

| Task | With MCP | Without MCP |
|---|---|---|
| Regenerate client and server code | happens on save under `serverpod start` | `serverpod generate` |
| Create a migration (a model with a `table` changed) | `create_migration` | `serverpod create-migration` |
| Apply migrations | `apply_migrations` | `serverpod start` applies pending ones on boot |
| Repair a drifted database | `create_repair_migration` | `serverpod create-repair-migration` |
| Reload after changes | `hot_reload` / `hot_restart` | `serverpod start` reloads on save |
| Read server logs | `tail_server_logs` | the console where `serverpod start` runs |
| Read the app's logs | `tail_flutter_logs` | the console where `flutter run` runs |

Checks, in this order, after making changes:

```sh
dart analyze --fatal-infos          # the CI setting; stricter than the default
dart format --set-exit-if-changed .
dart test                           # no Docker needed: the test config boots its own database
cd ../hackathon_serverpod_flutter && flutter analyze && flutter test
```

## Working with the product spec

`docs/PRODUCT.md` is the source of truth for behaviour: majorities, the 24-hour window, fines, roles
and what is in scope. If the code and that document disagree, the document wins — or the document is
out of date and should be updated in the same change. Decisions that are still open are listed at its
end; do not invent an answer for them, ask.
