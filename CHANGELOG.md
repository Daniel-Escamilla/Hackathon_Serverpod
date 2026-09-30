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

- **Sign in with Google** from the welcome screen. The server enables it only when
  `googleClientSecret` is in `passwords.yaml`; on the web it works with the app served by Serverpod
  on port 8082. The welcome screen now scrolls on short screens instead of overflowing.

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
