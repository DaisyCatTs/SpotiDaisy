# ADR 0001: Upstream baseline and safe branch strategy

Status: Accepted. Date: 2026-10-07.

## Context

DaisySpoti starts with exactly Spotifast commit
`995c768dcba4da7f93302bf2107af6b7ec3df02b`. The inherited maintainer workflow
uses main directly. The canonical Daisy master plan requires stable main,
development work on dev/focused branches, and deliberate upstream integrations.

## Decision

Origin is DaisyCatTs/SpotiDaisy. Upstream is crmne/spotifast. Preserve the exact
baseline under a local immutable tag and in docs. Fetch freely, never merge
upstream/main wholesale. Review and port individual changes on branches based
on dev, recording accepted/rejected decisions and evidence. Main is stable and
requires reviewed integration; dev is the normal development line.

## Alternatives

Direct main work and wholesale upstream merges follow the inherited workflow
but contradict the explicit Daisy requirement. A disconnected rewrite loses
supplier fixes and existing tested behavior. Neither is selected.

## Consequences and validation

Git refs/tree comparisons prove no intake divergence. Dev was created/published
at the baseline; main remains unchanged. Main/dev protections were read back
from GitHub. Required status names are configured on main, but independent fork
CI and the check-name wiring must still be validated. The baseline tag is also
published to origin; it is not an independent backup. Supplier
dependencies and large state-owner files require careful conflict review.
