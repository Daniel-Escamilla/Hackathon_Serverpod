# Submission description

The text description the rules ask for (§ "Include a text description explaining the features and
functionality of the Project and how it was built"), in English. The app's interface is in
Spanish; everything here describes it in English.

> **Before submitting:** the [AI disclosure](#use-of-ai-and-agentic-tooling) needs every member to
> confirm the tools they used. It is marked **TO CONFIRM** below.

## What it is

**KarmaHome** is a household-chores app where nothing is decided by one person. Someone proposes a task and what it
is worth; **the home agrees to the deal before the task exists**; anyone does it and claims the
reward; **the home confirms it is done** before the coins — *karmas* — are paid. Karmas build up in
a wallet and are spent in a shop whose rewards the home sets for itself. Its line: «Lo que haces en
casa, vuelve» — what you do at home comes back.

It is built for people who share a home: flatmates and couples. A family mode with parental control
is designed ([`docs/PRODUCT.md`](PRODUCT.md) §8) but out of scope for this submission.

## Try it

- **Web:** <https://karmahome.serverpod.space/>, the Flutter web app served by Serverpod Cloud.
- **Android:** <https://karmahome.serverpod.space/download.html>, a download page for the APK.
- **Demo accounts**, a couple already living in a home with some history, two tasks to claim and a
  purchase on its way: `ana.demo@example.com` and `leo.demo@example.com`, password
  `KarmaHome2026` for both. Sign in as each in two browsers (or a browser and a phone) to see the live
  updates. Anyone can also sign up with their own email and start a home.

The interface is in Spanish by default; English can be picked in *Mis ajustes → Idioma*.

## Features

**Accounts and groups**

- Sign up with email and a verification code, or with **Google**; sign in, and reset a forgotten
  password. Each member picks a name and one of eight house characters drawn for the app.
- Create a home (shared flat or couple) or join one with its invite code. One home per person.
- The home's admin renames it, sets the fine percentage, replaces the invite code when it leaks,
  and expels members. Someone expelled with the app open is sent back to the create-or-join screen.
- Anyone can leave; if the admin leaves, the role goes to whoever has been there longest.
- **This week's ranking**: karmas earned minus fines since Monday, best first.
- **A home of one works too**: with nobody else to vote, proposals open and claims are paid at
  once. When someone joins, everything is voted again.

**The task cycle**

- **Propose** a task with a title, an optional description, a price in karmas and an icon — or
  tap one of ten typical chores («Limpiar el baño · 25») to fill it in.
- **Schedule** a task on set weekdays («take the rubbish out» on Tuesdays and Thursdays): the home
  votes on it once, and on each of its days it appears on the board by itself, to be claimed and
  validated like any other. A panel shows the home's week day by day.
- **Vote** on it. A proposal passes with half of the other members; each vote stays open for
  24 hours and closes early as soon as the result cannot change. A vote that expires counts as
  rejected.
- **Counter-offer** a different price. The first counter-offer freezes the vote until the proposer
  accepts the new price or withdraws the task.
- **Withdraw** a proposal made by mistake while it is being voted on, with no fine: whoever made it,
  or the admin, bins it from its card.
- **Claim** an open task by marking it done: whoever presses first gets it, and the other phone is
  told someone got there first.
- **Validate**: the rest of the group confirms the task was really done. Only then are the coins
  paid.
- The tasks tab is ordered by whose turn it is: what is waiting for your vote first, then what is
  available, your own claims in validation, and the rest still being voted, each with the time
  left. Every task shows who has voted and how.
- **Fines**: a percentage of the task's price, 20 % by default and set per group, paid by whoever
  proposed a rejected task, claimed a task whose validation is denied, or let a vote expire without
  voting. Balances can go negative.

**Shop and wallet**

- Each home starts with a shop of rewards for its profile, each with its icon; members propose
  more, with an icon of their own, and the home votes on them.
- Buy a reward and choose which other member fulfils it. They accept it and later mark it
  delivered, or refuse it, paying a fine and refunding the buyer. Nothing can be bought with a
  negative balance.
- The wallet shows the balance and every movement with what it was for, and plays a sound for
  coins earned or fines paid since it was last opened.

**Live updates**

- Proposals, votes, counter-offers, claims, validations, expulsions, profile changes and every
  step of the shop — a reward proposed or voted, a purchase made, answered or delivered — reach
  every member's phone as they happen, without refreshing. Each one shows as a notice with its
  sound, says who did it, and is listed in the Activity screen behind the bell for the session.

**Look and feel**

- Spanish and English, following the phone or picked in the settings.
- A light theme and a dark one in soft grey, readable at 4.5:1 or better.
- Every button bounces and plays one of five sounds, which can be muted; Lottie animations mark
  karmas coming in, a fine, a result and a delivery.

## How it was built

**Serverpod 4** is the whole backend; **Flutter** is the app. Both live in one Dart workspace,
[`hackathon_serverpod/`](../hackathon_serverpod).

| Serverpod feature | What it does here |
|---|---|
| Endpoints | `GroupEndpoint`, `TaskEndpoint`, `ShopEndpoint`, `WalletEndpoint`, `EventEndpoint` — every screen calls one of them |
| Models (`.spy.yaml`) with tables and migrations | Groups, members, tasks and their votes, rewards, purchases and the coin ledger in PostgreSQL |
| Serialisable exceptions | `GroupException`, `TaskException`, `ShopException` carry a reason enum to the app, which picks the sentence to show; the server never sends display text |
| Transactions with row locks | Two members claiming the same task at once, or two deciding votes arriving together, resolve to one winner and one fine |
| Future calls | `TaskVoteFutureCall` closes each vote when its window runs out, even if nobody opens the app |
| Streaming endpoint + `session.messages` | `EventEndpoint.watchGroup` pushes each group event to every member's phone |
| Email and Google identity providers + JWT | Registration, sign-in with email or Google, and password reset |
| Web server: static and custom routes | Serves the Flutter web app, the APK download page, the OAuth callback and a runtime `config.json` with the API URL |
| Serverpod Cloud | Hosts the server, PostgreSQL, the web app and the APK; sends the verification emails; keeps the secrets |
| `serverpod_test` with an embedded PostgreSQL | The server's integration tests need neither Docker nor a running server |

**The Flutter app** keeps server access in one layer: only `lib/data/` talks to the generated
client, through repositories that turn every server error into an app-level failure. One
`ChangeNotifier` controller per tab (`provider`) holds the state; screens show the failure's
sentence from the Spanish ARB. The design follows a "Playful UI" standard of our own
([`docs/DESIGN.md`](DESIGN.md)): shared components, colour and type tokens, a press bounce and
five UI sounds.

**Quality checks.** GitHub Actions runs `dart analyze --fatal-infos`, `dart format` and the tests
of both the server (integration tests) and the app (widget and unit tests, against fakes) on
every pull request. `main` only receives what already passed on `develop`.

**Demo data.** A `demo.reseed` endpoint, dead unless the server has its secret, rebuilds the
demo couple with real calls to the same services the app uses, so the history it leaves is one the
app could have produced.

**Build and run:** see the [README](../README.md#run-it). The short version for an Android phone is
`./hackathon_serverpod/scripts/run_on_phone.sh`.

## Use of AI and agentic tooling

The rules encourage AI coding assistants and require disclosing them. We used them throughout.

- **Claude Code** (Anthropic), an agentic coding tool, was used to write code, tests and
  documentation from issues the team wrote, and to open the corresponding pull requests.
- The repository is set up for coding agents on purpose: [`AGENTS.md`](../AGENTS.md) and
  [`hackathon_serverpod/AGENTS.md`](../hackathon_serverpod/AGENTS.md) give any agent the
  product rules, the architecture, the conventions and the checks to run, in plain Markdown so
  Codex, Claude Code, Gemini CLI or Cursor read the same instructions.
- People stayed in charge of the product and of what got merged: the product rules
  ([`docs/PRODUCT.md`](PRODUCT.md)), the plan, the design and the issues were decided by the team,
  and every change reached `develop` through a pull request with CI.
- **TO CONFIRM by each member:** the AI tools each of us used (for code, design mockups, the video
  or text) and for what, to be listed here before submitting.

**TO CONFIRM:** whether any asset in the app (icons, sounds, images), the design mockups or the
video was generated with AI, and that the licence of each tool used allows it (rules §
"AI and agentic tools").
