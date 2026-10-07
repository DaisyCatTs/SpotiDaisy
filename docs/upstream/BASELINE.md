# DaisySpoti upstream baseline

Audit date: 2026-10-07. Scope: Phase 0 only. Runtime source remains inherited.

## Repository and immutable references

| Item | Verified value |
| --- | --- |
| Checkout | `C:\Users\Daisy\Desktop\SpotiDaisy` |
| Original branch | `main`, clean, tracking `origin/main` |
| Original HEAD / origin main | `995c768dcba4da7f93302bf2107af6b7ec3df02b` |
| Upstream fetched main | `995c768dcba4da7f93302bf2107af6b7ec3df02b` |
| Merge base | `995c768dcba4da7f93302bf2107af6b7ec3df02b` |
| Ahead / behind at intake | `0 / 0` |
| Source/tree difference at intake | None |
| History | Complete, not shallow; 800 commits at baseline |
| Origin | `https://github.com/DaisyCatTs/SpotiDaisy` |
| Upstream | `https://github.com/crmne/spotifast.git` |
| Upstream push URL | `no_push://crmne/spotifast` (inert guard) |
| Local and origin baseline tag | `daisy-baseline/spotifast-995c768` |
| Release v0.12.0 annotated tag object | `f4e3b7c55cd86ba1af292fe077571c572e3f00ba` |
| Release v0.12.0 peeled commit | `ed9cb550d1514b5e7edfcf44d58d04406a3d5c5b` |
| Namespaced local release tag | `upstream-v0.12.0` |

The application manifest reports 0.12.0, but the checkout is **11 commits after**
the release commit. See [the exact list](evidence/since-v0.12.0.txt).
Do not use the release tag or the package version as a substitute for the baseline SHA.

## Safe branch migration

Created local `dev` from the unchanged baseline and published **only that baseline
ref** as `origin/dev` initially. The focused Phase 0 policy/CI commit
`a073de4f3e7367c021294c65e0b6293167608613` was subsequently pushed to dev.
No upstream merge, rebase, reset, stable-main change, or
history rewrite occurred. Added upstream and fetched main with `--no-tags`;
fetched v0.12.0 explicitly into a namespaced local tag.

GitHub initially reported no main protection, no rulesets, and no fork Actions
runs. The requested safety setup now enforces linear history, prevents force
pushes/deletion, and applies to administrators on both main and dev. Main also
requires one PR approval and dismisses stale approvals. Dev permits direct
focused work. Main requires strict status checks named `quality`, the four
platform `test (...)` jobs, `Nix package`, and `docs`. Their names come from the
workflow; no fork run has validated them yet. Protection alone is not a complete
release gate. The baseline tag was also published to origin without using a
release-triggering `v*` tag.
Snapshots: [main](evidence/main-protection.json), [dev](evidence/dev-protection.json).

Normal work uses dev or focused branches. The master plan and the user's explicit
instructions supersede the inherited direct-to-main policy in AGENTS.md and
CONTRIBUTING.md. Main is stable; no later phase is authorized by this audit.
The local gh default was explicitly set to DaisyCatTs/SpotiDaisy to avoid its
automatic fork-to-parent resolution. Still use explicit `--repo` for mutations.

## Audit index

- [Divergence and integration procedure](DIVERGENCE.md)
- [Architecture, features, coupling and refactor boundaries](ARCHITECTURE.md)
- [Security, persistence, dependencies and licensing](SECURITY_AND_DEPENDENCIES.md)
- [CI, platforms, packaging and branding replacement plan](QUALITY_AND_BRANDING.md)
- [Executed checks and runtime measurements](VALIDATION.md)
- [Accepted upstream changes](ACCEPTED_UPSTREAM.md)
- [Rejected upstream changes](REJECTED_UPSTREAM.md)
- [Recorded decisions](../adr/README.md)

## Recovering and reviewing upstream

Use `git show daisy-baseline/spotifast-995c768` to inspect the reference and
`git diff daisy-baseline/spotifast-995c768 -- src Cargo.toml Cargo.lock` to isolate
runtime changes. Never reset a working branch to recover the baseline. Create a
separate inspection checkout if needed, giving any build its own target directory.

Fetch upstream before each audit, record its SHA and compare
`git log daisy-baseline/spotifast-995c768..upstream/main` plus the relevant diffs.
Prepare focused ports on `integration/upstream-*` based on dev. Record source
SHA, rationale, Daisy commit, tests and any preserved differences in the ledgers.
Do not merge upstream main wholesale or move the baseline tag to a later commit.

The origin tag is a remote recovery anchor, not an independently backed-up or
signed archive. Baseline reproducibility depends on retained Git history and access to the
commit-pinned fork dependencies. This audit does not guarantee those external
repositories will remain available indefinitely.
