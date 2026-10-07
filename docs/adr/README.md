# DaisySpoti architecture decision records

Record decisions that materially affect product semantics, privacy, persistence,
audio, dependency ownership or UX. Accepted means a decision is established,
not that a future feature has been implemented or validated.

| ADR | Status | Decision |
| --- | --- | --- |
| [0001](0001-upstream-and-branches.md) | Accepted | Frozen supplier baseline, selective ports, stable main and development branch |
| [0002](0002-native-and-preserved-subsystems.md) | Accepted | Preserve native Rust, Winamp, MilkDrop and existing action/runtime boundaries |
| [0003](0003-credentials-and-identity.md) | Accepted | Preserve protected grants and defer identity migration until explicitly designed |

No provider abstraction, database choice, new audio graph, plugin SDK, Pure
Shuffle design or new UI architecture is decided by Phase 0. Write those ADRs
when their phase has evidence and authorization.

New records use a numbered filename and include status/date, context, decision,
alternatives, consequences and validation. Supersede records explicitly rather
than rewriting the history of a materially different decision.
