# Submission description

The text description the rules ask for (§ "Include a text description explaining the features and
functionality of the Project and how it was built"), in English. The app's interface is in
Spanish; everything here describes it in English.

> **Before submitting:** the app has no final name yet ([`docs/PLAN.md`](PLAN.md) §9), and the
> [AI disclosure](#use-of-ai-and-agentic-tooling) needs every member to confirm the tools they
> used. Both are marked **TO CONFIRM** below.

## What it is

A household-chores app where nothing is decided by one person. Someone proposes a task and what it
is worth; **the group agrees to the deal before the task exists**; anyone does it and claims the
reward; **the group confirms it is done** before the coins are paid. Coins build up in a wallet and
are spent in a shop whose rewards the group sets for itself.

It is built for people who share a home: flatmates and couples. A family mode with parental control
is designed ([`docs/PRODUCT.md`](PRODUCT.md) §8) but out of scope for this submission.

## Features

**Accounts and groups**

- Sign up with email and a verification code, sign in, and reset a forgotten password.
- Create a group (shared flat or couple) or join one with its invite code. One group per person.
- The group's admin renames it, sets the fine percentage, replaces the invite code when it leaks,
  and expels members. Someone expelled with the app open is sent back to the create-or-join screen.

**The task cycle**

- **Propose** a task with a title, a description and a price in coins.
- **Vote** on it. A proposal passes with half of the other members; each vote stays open for
  24 hours and closes early as soon as the result cannot change. A vote that expires counts as
  rejected.
- **Counter-offer** a different price. The first counter-offer freezes the vote until the proposer
  accepts the new price or withdraws the task.
- **Claim** an open task by marking it done: whoever presses first gets it, and the other phone is
  told someone got there first.
- **Validate**: the rest of the group confirms the task was really done. Only then are the coins
  paid.
- **Fines**: a percentage of the task's price, 20 % by default and set per group, paid by whoever
  proposed a rejected task, claimed a task whose validation is denied, or let a vote expire without
  voting. Balances can go negative.

**Shop and wallet**

- Each group starts with a shop of reward templates for its profile; members propose more, and the
  group votes on them.
- Buy a reward and choose which other member fulfils it. They accept it and later mark it
  delivered, or refuse it, paying a fine and refunding the buyer. Nothing can be bought with a
  negative balance.
- The wallet shows the balance and every movement with what it was for, and plays a sound for
  coins earned or fines paid since it was last opened.

**Live updates**

- Proposals, votes, counter-offers, claims, validations, purchases and expulsions reach every
  member's phone as they happen, without refreshing.

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
| Email identity provider + JWT | Registration, sign-in and password reset |
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
