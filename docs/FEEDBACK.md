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

---

## 2. `inSet` on a nullable `id` column fails at runtime with an inline set literal

**Date:** 2026-09-21 · **Area:** ORM, `serverpod_database` column expressions

**What happened.** Every generated table has `id` as a nullable column. Passing a set literal
straight into `inSet` compiles, and then fails at runtime:

```dart
// Compiles. Throws when the query runs.
final items = await RewardItem.db.find(
  session,
  where: (t) => t.id.inSet({for (final p in purchases) p.itemId}),
);
```

```
type '_Set<int?>' is not a subtype of type 'Set<int>' of 'values'
package:serverpod_database/src/concepts/columns.dart 681:27  _NullableColumnDefaultOperations.inSet
```

`p.itemId` is a non-nullable `int`, but the literal takes its element type from the context:
`inSet`'s parameter on a nullable column, so Dart builds a `Set<int?>`. Serverpod then needs a
`Set<int>` further in. The same set, built first as a variable, works — which makes it look
arbitrary: of three `inSet` calls in the same function, only the inline one broke.

**Workaround.** Type the set explicitly before passing it: `final ids = <int>{...};`.

**Suggested fix.** Either accept `Set<T?>` all the way down on nullable columns and drop the
nulls, or type `inSet`'s parameter so the inline literal is inferred as `Set<int>`. A compile error
would also beat a runtime one here — this only surfaced because a test happened to reach it.

**Environment.** Serverpod 4.0.0, `serverpod_database` 4.0.0, Dart 3.12.2.

## 3. Google sign-in on the web opens a full tab and never notices it closing

**Date:** 2026-09-30 · **Area:** `serverpod_auth_idp_flutter`, Google web sign-in (OAuth2 PKCE)

**What happened.** On the web, `GoogleAuthController.signIn()` goes through
`GoogleWebSignInService` → `OAuth2PkceUtil.authorize()`, which calls
`FlutterWebAuth2.authenticate(options: FlutterWebAuth2Options(useWebview: useWebview))`. On the
web that becomes `launchUrl` with no window features, so the Google page opens as a **new tab**,
not the small account-picker window people expect from "Sign in with Google". Worse, nothing
watches that tab: if the person closes it, the future only fails after `flutter_web_auth_2`'s
default five-minute timeout, and the sign-in button stays busy the whole time.

**Workaround.** We skipped the controller on the web and wrote the same PKCE request ourselves
(`lib/data/google_popup_web.dart`): `window.open` with `popup,width=480,height=640`, the answer
read from the `postMessage` / localStorage that Serverpod's `FlutterWebAuth2CallbackRoute` page
already sends, the window polled for `closed`, and `client.googleIdp.loginWithCode` called with
the result. About 120 lines that re-implement what the package does, only to change how the
window opens.

**Suggested fix.** Let `OAuth2PkceUtil` (or `initializeGoogleSignIn`) take the
`FlutterWebAuth2Options` — at least `windowName` and the popup features — and on the web open a
sized popup by default. Watching `popup.closed` and throwing `OAuth2PkceUserCancelledException`
would let `GoogleAuthController` go back to idle, which it already handles.

**Environment.** Serverpod 4.0.0, `serverpod_auth_idp_flutter` 4.0.0, `flutter_web_auth_2` 5.1.0,
Firefox and Chrome on Linux.

## 4. `withServerpod` leaves `AuthServices` unset, so server code that uses it cannot be tested as is

**Date:** 2026-10-01 · **Area:** `serverpod_test`, `serverpod_auth_core_server`

**What happened.** Our demo seeder creates email accounts on the server with
`AuthServices.instance.authUsers.create` and `AuthServices.instance.emailIdp.admin
.createEmailAuthentication`. Under `withServerpod` every call failed with
`StateError: AuthServices is not set. Call AuthServices.set() to initialize it`. The test server
does not run `server.dart`, so `pod.initializeAuthServices(...)` never happens, and nothing in the
generated `serverpod_test_tools.dart` or the testing docs says so. It is easy to miss, because the
generated auth endpoints still answer the paths that do not reach `AuthServices.instance`.

**Workaround.** A `setUpAll` in the test file that repeats a minimal configuration by hand:
`AuthServices.set(tokenManagerBuilders: [ServerSideSessionsConfig(...)],
identityProviderBuilders: [EmailIdpConfig(secretHashPepper: ...)])`. That is a second copy of
`server.dart`'s auth setup, which can drift from the real one.

**Suggested fix.** Let `withServerpod` take the same auth configuration `server.dart` uses (or
call a project hook), or have the generated test tools set a test `AuthServices` by default. At
least, the testing docs could say that `AuthServices` is unset in tests and show the `set` call.

**Environment.** Serverpod 4.0.0, `serverpod_test` 4.0.0, `serverpod_auth_idp_server` 4.0.0.

## 5. The email `login` endpoint cannot be called from a test in the default rollback mode

**Date:** 2026-10-01 · **Area:** `serverpod_test`, `serverpod_auth_idp_server` email login

**What happened.** In a `withServerpod` test with the default `RollbackDatabase.afterEach`,
`endpoints.emailIdp.login(...)` throws *"Concurrent calls to transaction are not supported when
database rollbacks are enabled"*. The test tools wrap the call in a transaction, and
`EmailIdpAuthenticationUtil.authenticate` opens another one inside it through
`DatabaseRateLimiter.tryRecordAttempt`. So the most ordinary auth test, "can this account sign
in", needs either rollback disabled for the whole file — and its own cleanup — or a detour.

**Workaround.** We call `AuthServices.instance.emailIdp.utils.authentication.authenticate(...)`
directly with `transaction: null`, which checks the password without going through the endpoint.

**Suggested fix.** Have the rate limiter join the caller's transaction (or use a savepoint, as
`DatabaseUtil.runInTransactionOrSavepoint` already does elsewhere in the same package) instead of
opening a new one, so the endpoint works under rollback like the rest.

**Environment.** Serverpod 4.0.0, `serverpod_test` 4.0.0, `serverpod_auth_idp_server` 4.0.0.
