# DaisySpoti divergence ledger

Baseline: `995c768dcba4da7f93302bf2107af6b7ec3df02b`.

## Intake divergence

None. The entire tracked tree and history matched fetched crmne/spotifast main
at intake. No Daisy UI, shuffle, local music, audio graph, branding or protocol
modifications existed. MilkDrop, Winamp, patched librespot, fastframe, auth,
caches and optimistic queue logic are inherited upstream functionality.

## Phase 0 divergence

| Surface | Ownership / change | Validation |
| --- | --- | --- |
| Master plan, handoff, Figma brief | Daisy specification, copied verbatim from attachments except validated master checklist updates | Compared before checklist changes; later phases untouched |
| `docs/upstream/*` | Daisy baseline evidence, ledgers and audit | Git/source references and executed commands in validation report |
| `docs/adr/*` | Daisy decisions already mandated by the brief or inherited implementation | Checked against current source and explicit requirements |
| `.github/workflows/ci.yml` | Push CI also runs on dev | One-line trigger change; no runtime or test changes |
| `AGENTS.md`, `CONTRIBUTING.md` | Explicit Daisy policy override, inherited implementation rules preserved | Removes future direct-to-main policy ambiguity |
| Test/developer executable names | `launch_contract` and `release-inspect`, same contents | Full Cargo checks recorded in VALIDATION.md; avoids Windows error 740 |
| Git configuration/refs | Added upstream; published baseline tag and local namespaced release tag; local/remote dev | Exact ref checks in baseline |
| GitHub protection | Stable-main review gate and linear/no-force/no-delete safeguards | Read-back snapshots in evidence |

No Cargo manifest, lockfile, runtime source, audio, queue or visual behavior was
changed in Phase 0. Documentation and CI are the first Daisy-owned work.

The policy/CI change is committed as
`a073de4f3e7367c021294c65e0b6293167608613` on dev. Main remains at the baseline.

## Future ownership boundaries (recommendation, not implemented)

Daisy owns product semantics, design system, UI, capabilities and its future
library overlay. Spotify protocol compatibility, protected credential mechanisms,
native output/platform fixes, Winamp/MilkDrop compatibility and upstream bug fixes
remain supplier-sensitive. An ownership label does not authorize removing useful
upstream behavior.

Highest conflict exposure: app.rs action/event fold; backend.rs auth/request
routing; model/settings persistence types; player/sink/vis signal path; queue
recovery and occurrence identity; shared egui/winit/fastframe/librespot revisions;
branding/app IDs/credential namespaces/updater/package names.

Before each port, compare behavior, persistence, network policy, queue invariants,
platform cfgs and dependency revisions. Port logic separately from upstream
appearance. Update docs, tests and ledgers together. Keep SHA-pinned patch groups
coherent; a compiling partial dependency update can still break native integration.
