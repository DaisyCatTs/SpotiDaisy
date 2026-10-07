# DaisySpoti — Codex Handoff Prompt

You are implementing **DaisySpoti**, a long-term fork of `crmne/spotifast`.

The canonical product and engineering specification is:

`DaisySpoti_MASTER_PLAN.md`

## Your role

You are the implementation engineer. Do **not** redesign the product or silently change the roadmap.

Before coding:

1. Read the entire master plan.
2. Inspect the repository and current branch/remotes.
3. Inspect the existing Spotifast architecture and current Daisy modifications.
4. Run the test suite/demo/build.
5. Establish an exact upstream baseline.
6. Create/update the upstream divergence documentation.
7. Report any conflict between existing code and the plan before changing semantics.

## Git rules

- `origin` = DaisySpoti.
- `upstream` = `crmne/spotifast`.
- Stable work must not be overwritten by upstream.
- Never merge `upstream/main` directly into Daisy branches.
- Upstream changes are reviewed and ported/cherry-picked deliberately.
- Normal work targets `dev` or a focused `feature/*` branch.
- Do not merge to `main` until a release gate explicitly permits it.

## Product rules

- Preserve native Rust performance.
- No Chromium/webview replacement.
- No DRM circumvention.
- Never fake Lossless/Hi-Res/bit-perfect states.
- Never silently enable processing.
- Reference audio mode is the default.
- Local full-control playback and remote Spotify Connect must expose capability differences.
- Pure Shuffle must be deterministic, inspectable and no-repeat-until-cycle-complete.
- Queue semantics must be explicit.
- Local metadata belongs to Daisy’s local DB.
- MilkDrop and Winamp are first-class features, not legacy clutter.
- Daisy UI must come from the Daisy design system/Figma direction, not ad-hoc Spotifast styling.

## First execution phase

Begin with **Phase 0 — Baseline & Safety** only.

Deliver:

- repository architecture map;
- exact upstream baseline SHA;
- remotes/branch report;
- test/build status;
- performance baseline;
- current-feature inventory;
- current UI/module inventory;
- dependency inventory;
- `docs/upstream/BASELINE.md`;
- `docs/upstream/DIVERGENCE.md`;
- `docs/upstream/ACCEPTED_UPSTREAM.md`;
- `docs/upstream/REJECTED_UPSTREAM.md`;
- initial ADR index;
- recommended safe refactor boundaries.

Do not begin a broad UI rewrite or audio-engine rewrite before the baseline is documented.

When the phase is complete, update `DaisySpoti_MASTER_PLAN.md` checkboxes only for tasks that were actually validated.
