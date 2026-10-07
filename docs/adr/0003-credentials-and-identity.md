# ADR 0003: Protected credentials and deferred identity migration

Status: Accepted. Date: 2026-10-07.

## Context

Spotifast uses OS-protected grants, legacy migration, generation guards and
atomic readable state. App IDs, credential service, paths, instance channel,
updater and packages still carry upstream identity. Renaming these piecemeal can
lose state, collide with Spotifast, or install upstream over Daisy.

## Decision

Preserve current credential and persistence contracts in Phase 0. Do not copy
real secrets into audit logs or inspect the user's grants. Record the existing
identity and updater hazards. Design a coordinated, reversible Daisy identity
migration before distribution, covering credentials, settings/cache/state,
instances, URL handlers, media identity, packages and updater ownership.

## Alternatives

Immediate search-and-replace risks data and compatibility. New plaintext storage
weakens security. Neither is selected. A local DB and provider/source model are
future decisions, not inferred from the roadmap recommendation.

## Consequences and validation

Phase 0 demos use isolated data directories and skip credential restoration.
Source inspection verifies protected stores, migration readback, secret omission
and OAuth redaction test coverage. This is a high-level audit, not a penetration
test or proof all logs are secret-free. Production publishing remains unsafe
until updater/package ownership and licensing obligations are resolved.
