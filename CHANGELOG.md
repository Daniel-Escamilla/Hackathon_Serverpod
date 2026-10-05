# Changelog

What changes from one version to the next, for the team and for the judges. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and versions follow
[Semantic Versioning](https://semver.org/): `0.x` while the MVP is being built, `1.0.0` for the
submission on 14 October.

A version is what reaches `main`. Until then, changes pile up under **Unreleased**; when `develop`
is promoted, that section gets the new number and the date, the app's `version` in
`hackathon_serverpod_flutter/pubspec.yaml` moves with it, and the merge on `main` is tagged
`v<version>`.

## [Unreleased]

### Added

- **The app is KarmaHome.** Its name in the app, the Android launcher, the web page and the
  server's emails; a new logo, a home in two halves that fit together, on every icon and in the
  link preview; and a voice to go with it: «Lo que haces en casa, vuelve». Coins are now
  **karmas**, the Wallet tab is **Karma**, and the welcome screen and empty lists speak it.
- **A download page for the Android app**, `descargar.html`, to share instead of `app.apk`: it
  carries the logo and link preview that WhatsApp and the like cannot show for a bare APK.
- **Sign in with Google** from the welcome screen. The server enables it only when
  `googleClientSecret` is in `passwords.yaml`; on the web it works with the app served by Serverpod
  on port 8082. The welcome screen now scrolls on short screens instead of overflowing.
- **A member's new name or avatar reaches the rest of the group live.** `updateMyProfile`
  publishes `memberUpdated` on the group's stream; the other phones reload the member list and
  show it in Activity (#140).
- **Demo accounts for the judges.** `scripts/sembrar_demo.sh` builds a couple, Ana and Leo, with
  some history, two tasks to claim and the shop, through a `demo.reseed` endpoint that only answers
  with the server's `demoSeedSecret`. It wipes the previous demo first, so it can be run again.
- **House characters instead of emoji avatars.** Eight characters drawn for the app (a mug, a
  plant, a sock, a sponge, a teapot, a toast, a bucket and a light bulb) on the member's colour.
  An emoji picked before them is still shown.
- **Lottie animations** for coins coming in, a fine, a result, a purchase delivered (confetti),
  the live notice, empty lists, choosing a home and loading. Nine, picked by the team from
  LottieFiles; who made each one is in `assets/animations/CREDITS.md`.

### Fixed

- **A fine from the task cycle now sounds in the wallet.** Only shop fines played the fine sound;
  a denied proposal, a denied validation and an expired vote are fines too.

- **The shop no longer sells what the balance cannot pay.** The server refuses a purchase whose
  price is above the buyer's balance, checked on the locked row so two purchases at once cannot
  spend the same coins; only fines take a balance below zero (#137).

## [0.1.0] - 2026-09-28

The first version with the whole task cycle, the shop and the wallet working against the real
backend, between phones and in real time.

### Added

- **Accounts.** Sign up with email and a verification code, sign in, reset a forgotten password,
  and sign out (#90, #113, #115). The password fields have an eye to show what is typed (#113).
- **Groups.** Create a shared-flat or couple group, or join one with its invite code (#88, #91).
  The group screen lists the members and the code; the admin renames the group, sets the fine
  percentage, replaces a leaked code and expels members (#93, #94, #106).
- **The task cycle.** Propose a task with its price, vote on it, counter-offer another price,
  claim it as done, and have the group validate it before the coins are paid (#96, #113). Votes
  close after a configurable window, 24 hours by default, or earlier once the result cannot
  change, through a scheduled `FutureCall` (#99, #111).
- **Fines** for a rejected proposal, a denied validation and a vote left to expire (#96, #100).
- **The tasks tab by whose turn it is**: what is waiting for your vote first, then what is
  available, your claims in validation, and the rest still being voted, with the time left. Each
  task shows who has voted and how (#120).
- **Shop.** A template of rewards per profile; propose rewards and vote on them; buy one choosing
  who fulfils it, who then accepts it and marks it delivered, or refuses it paying a fine and
  refunding the buyer (#84, #86, #103, #114).
- **Wallet.** The balance and every movement with the task or reward behind it, computed on the
  server (#85, #92, #93).
- **Live updates.** One stream per group: proposals, votes, counter-offers, claims, validations,
  expulsions and every step of the shop reach the other phones without refreshing (#113, #120,
  #132, #135).
- **Playful UI**, the design standard: every button bounces and plays one of five sounds, each
  with a single meaning (#95), and the green coin with a leaf (#112).
- Refusals from the server reach the app with their reason, so the screen can say why (#131).
- `run_on_phone.sh` builds the Android APK against this computer's address with the pinned
  Flutter, and can finish by starting the server (#119, #128).

### Fixed

- Every screen opened from a tab could not reach its controllers, so voting, claiming, proposing
  and buying did nothing when tapped (#113).
- Whoever sent a counter-offer landed on the proposer's decision buttons (#120).
- Race conditions: two votes landing at once, two claims on the same task, and a double tap on a
  purchase response no longer count twice (#100, #104).
- A user without a group gets the create-or-join screen again (#118), and a member expelled with
  the app open leaves the group screens (#132).
- Foreign-key columns are indexed (#87).

### Changed

- Controllers reach the server through repositories in `lib/data/`, so screens can be tested
  without a server (#129, #133).
- The `Greeting` scaffold is gone (#130).

### Known gaps

- Not yet deployed to Serverpod Cloud (#68).
- Out of scope for now, as `docs/PLAN.md` §1 says: family mode, recurring tasks, the weekly
  ranking screen and handing over the admin role (their endpoints exist, the app does not call
  them).

[Unreleased]: https://github.com/Daniel-Escamilla/Hackathon_Serverpod/compare/v0.1.0...develop
[0.1.0]: https://github.com/Daniel-Escamilla/Hackathon_Serverpod/releases/tag/v0.1.0
