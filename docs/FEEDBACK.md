# Serverpod feedback log

Friction hit while building, written down as it happens rather than reconstructed on 14 October. This
feeds the hackathon's *Most Valuable Feedback* form, which is a separate prize and stacks with the
overall one. Actionable material only: bugs, UI improvements, SDK/docs suggestions.

In English, because that is what goes into the form. One entry per problem, newest last.

---

## 1. The scaffold's GitHub Actions workflows never run, and `tests.yml` fails when they do

**Date:** 2026-09-17 · **Area:** `serverpod create` project template, CI

**What happened.** Our project has `analyze.yml`, `format.yml` and `tests.yml`, added in the commit
that scaffolded the Serverpod project. They sat in `<project>/.github/workflows/`. GitHub Actions only
reads `.github/workflows/` at the **root of the repository**, so when the Serverpod project is a
subdirectory — a monorepo, or just `serverpod create` run inside an existing repo — none of the three
workflows ever run. Ours had never run once in two days of commits, while the repo's git hooks told
everyone that "CI re-checks the same things server-side".

**Second problem, found after moving them to the root.** `tests.yml` installs the CLI with
`dart install serverpod_cli $VERSION` and then calls `serverpod generate` in a later step. It fails:

```
serverpod: command not found
Process completed with exit code 127.
```

The install step itself succeeds, and prints:

```
Warning: Dart installs executables into $HOME/.local/state/Dart/install/bin,
which is not on your path.
```

Every GitHub Actions step runs in a fresh shell, so the directory has to be published through
`$GITHUB_PATH` to be visible to the steps after it. Note the location is **not** `$PUB_CACHE/bin`,
which is what the older `dart pub global activate` used and what most CI examples still assume.

**Suggested fix.** In the template's `tests.yml`:

```yaml
- name: Install Serverpod CLI
  run: |
    dart install serverpod_cli $VERSION
    echo "$HOME/.local/state/Dart/install/bin" >> "$GITHUB_PATH"
```

And either generate the workflows at the repository root, or say in the docs that they have to be
moved there when the project is not the repository root.

**Environment.** Serverpod CLI 4.0.0, Flutter 3.44.4, Dart 3.12.2, `ubuntu-latest`,
`subosito/flutter-action@v2`.

**Before filing:** confirm the two files come from the template by running `serverpod create` on a
clean machine. We only know for certain that they arrived with our scaffold commit.
