# Security, privacy, dependency, and license baseline

Date: 2026-10-07

Scope: Phase 0 evidence for DaisySpoti. This document records the security, privacy, dependency, license, and attribution findings from repository inspection and dependency scans. It does not change application behavior.

Primary evidence sources:

- `Cargo.toml` and `Cargo.lock`
- `docs/upstream/evidence/advisories.txt`
- Generic cargo-deny results summarized below; multi-megabyte fallback-policy output was not retained.
- `src/auth.rs`, `src/credentials.rs`, `src/settings.rs`, `src/paths.rs`, `src/http.rs`, `src/updates.rs`, `src/lyrics.rs`, `src/milkdrop.rs`, `src/zeroconf.rs`, `src/api/client.rs`
- `docs/_reference/how-it-connects.md`, `docs/_reference/settings-and-files.md`, `docs/_reference/privacy.md`, `docs/_reference/what-spotify-allows.md`
- cached projectM checkout at `C:\Users\Daisy\.cargo\git\checkouts\projectm-rs-3f6f91abd1608807\1ef6df1`

## Dependency baseline

The application is a Rust desktop client. The package is currently `spotifast` version `0.12.0`, edition `2024`, minimum Rust `1.98`, and declares `MIT` as the package license in `Cargo.toml`.

Important direct dependency boundaries:

| Area | Dependency evidence | Notes |
| --- | --- | --- |
| Spotify playback/session | `librespot`, `librespot-connect`, `librespot-core`, `librespot-discovery`, `librespot-metadata`, `librespot-oauth`, `librespot-playback`, `librespot-protocol` | All are patched to the maintainer fork `crmne/librespot` at commit `23fc42cff37848e51f0d8eaefad1a93941b71e59`. Playback capabilities and Spotify Connect behavior are owned by this boundary. |
| Spotify Web API and external HTTP | `reqwest` with `rustls-tls-native-roots`, `system-proxy`, and `socks` features | Used by the app HTTP client, OAuth, update checks, LRCLIB, and selected helper paths. |
| Native UI/windowing | `eframe`/`egui` family and `winit` | Patched to maintainer forks. Local AGENTS instructions require moving all egui and winit fork crates together. |
| Update checks | `fastframe-update` from `crmne/fastframe` tag `v0.4.1` | App runtime currently configures update verification with checksums only. See update security notes below. |
| Credential storage | `keyring-core`, plus platform-specific native stores | macOS uses `apple-native-keyring-store`, Windows uses `windows-native-keyring-store`, Linux uses `zbus-secret-service-keyring-store`. |
| MilkDrop/projectM | `projectm` and `projectm-sys`, optional feature | DaisySpoti enables `projectm-sys/static` through the MilkDrop feature. Static linking has license/redistribution implications. |
| Local cryptographic helpers | `aes`, `ctr`, `hmac`, `pbkdf2`, plus librespot crypto dependencies | Repository use includes Spotify Connect credential handoff encryption and Spotify/librespot protocols. |

Pinned git/fork dependencies visible in `Cargo.toml` and `Cargo.lock`:

| Dependency family | Source | Pinned revision/tag |
| --- | --- | --- |
| `egui`, `eframe`, `egui-winit`, `egui_glow`, etc. | `https://github.com/crmne/egui.git` branch `apps-0.36` | `ba6790fe7cf46e58e8d27ce1524cbfdee745e938` |
| `winit`, `dpi` | `https://github.com/crmne/winit.git` branch `apps-0.30` | `ed7caa9023f10b397f5b6ec8284a840cbd8a6f65` |
| `projectm`, `projectm-sys` | `https://github.com/crmne/projectm-rs.git` branch `build-fixes` | `1ef6df1c20247a3a5800c625e46262330f93bbd6` |
| `hyper-proxy2` | `https://github.com/crmne/hyper-proxy2.git` branch `http10` | `efca4811371ddae81c06be168de54194938d70b1` |
| `librespot-*` | `https://github.com/crmne/librespot.git` branch `apps` | `23fc42cff37848e51f0d8eaefad1a93941b71e59` |
| `fastframe-*` | `https://github.com/crmne/fastframe.git` tag `v0.4.1` | lockfile resolves to `23d87e048185ef317f272e2a67416f516b2f2b04` |

These fork pins are not incidental. They are part of the upstream integration risk surface: egui and winit carry app-specific fixes, librespot gates Spotify playback behavior, hyper-proxy2 controls proxy handling for librespot HTTP CONNECT, and projectM controls MilkDrop build/link behavior.

## Dependency advisory scan results

`docs/upstream/evidence/advisories.txt` was produced with `cargo deny check advisories`. It failed with four vulnerability advisories and one unmaintained advisory.

| Package | Advisory | Path into DaisySpoti | Scan result | Practical note |
| --- | --- | --- | --- | --- |
| `quick-xml 0.38.4` | RUSTSEC-2026-0194 | `quick-xml -> librespot-core -> librespot-* -> spotifast` | Vulnerability | CPU denial of service in duplicate attribute checking. Upgrade target is `quick-xml >= 0.41.0`. DaisySpoti does not depend on `quick-xml` directly, so remediation likely belongs in the pinned librespot fork or upstream librespot. |
| `quick-xml 0.38.4` | RUSTSEC-2026-0195 | `quick-xml -> librespot-core -> librespot-* -> spotifast` | Vulnerability | Memory exhaustion in `NsReader`. Upgrade target is `quick-xml >= 0.41.0`. Same librespot boundary as above. |
| `rsa 0.9.10` | RUSTSEC-2023-0071 | `rsa -> librespot-core -> librespot-* -> spotifast` | Vulnerability | Marvin timing side-channel. The advisory reports no safe upgrade. Reachability depends on how librespot uses RSA. Treat as an upstream/librespot cryptography risk until verified or mitigated there. |
| `rustls 0.23.43` | RUSTSEC-2026-0285 | `rustls -> reqwest/hyper-rustls/tokio-rustls/tungstenite/hyper-proxy2/librespot-core -> spotifast` | Vulnerability | TLS 1.3 encryption-level boundary acceptance issue. Upgrade target is `rustls >= 0.23.45`. This affects the general HTTPS stack and should be updated promptly if compatible. |
| `ttf-parser 0.25.1` | RUSTSEC-2026-0192 | `ttf-parser -> owned_ttf_parser -> ab_glyph -> sctk-adwaita -> winit -> egui/eframe/spotifast` | Unmaintained | No safe upgrade is reported by the advisory. Remediation likely requires movement in `sctk-adwaita`, `winit`, or the maintainer `winit` fork. |

The scan output also states that no cargo-deny config was found and cargo-deny used its default config. That means advisory failures are real, but license/source policy failures need interpretation against a repository policy that does not yet exist.

`docs/upstream/evidence/cargo-deny.txt` ended with `advisories FAILED, bans ok, licenses FAILED, sources ok`. The license failures are dominated by default-policy denials because there is no explicit allow-list. They should be treated as a missing policy baseline, not as proof that every denied permissive license is unacceptable.

Recommended follow-up:

1. Add a repository-owned `deny.toml` or equivalent policy with explicit allowed licenses, accepted copyleft exceptions, advisory ignores with rationale, and allowed git sources.
2. Add dependency/advisory scanning to CI after the policy exists.
3. Update `rustls` to `>=0.23.45` if the lockfile can move without breaking pinned forks.
4. Update or patch the librespot fork for `quick-xml >=0.41.0`, or document why the affected parser paths are unreachable.
5. Track the `rsa` advisory at the librespot boundary because there is no patched upstream version available in the advisory output.
6. Track `ttf-parser` through the `winit`/`sctk-adwaita` path and avoid pretending it is solved by a direct DaisySpoti patch.

## License and attribution baseline

Verified repository license evidence:

- The root `LICENSE` is MIT and names Carmine Paolino as copyright holder.
- `Cargo.toml` declares package license `MIT`.
- `assets/icons/LICENSE.txt` records Lucide icons under ISC and Feather-derived icons under MIT.

Verified cargo metadata license evidence:

- No dependency in cargo metadata lacked a license field during this audit.
- Most dependencies are permissive (`MIT`, `Apache-2.0`, `BSD-*`, `ISC`, `Unicode-*`, `Zlib`, `MPL-2.0` combinations, and similar).
- Non-permissive or review-sensitive expressions appeared in the dependency graph, including `LGPL-3.0-or-later`, `LGPL-3.0-or-later OR MPL-2.0`, `MIT OR Apache-2.0 OR LGPL-2.1-or-later`, and `Apache-2.0 OR GPL-2.0-only`.

Git dependency license evidence:

| Git dependency | Declared license evidence |
| --- | --- |
| `crmne/egui` crates | Mostly `MIT OR Apache-2.0`; `epaint_default_fonts` includes font licenses `OFL-1.1` and `Ubuntu-font-1.0`. |
| `crmne/winit` crates | `Apache-2.0`. |
| `crmne/fastframe` crates | Mostly `MIT`; `fastframe-fonts` includes `OFL-1.1`; `fastframe-icons` includes `ISC`. |
| `crmne/librespot` crates | `MIT`. |
| `crmne/hyper-proxy2` | `MIT`. |
| `dennisgr7/projectm-rs` crates | `LGPL-3.0-or-later` in crate metadata. |

projectM specific uncertainty:

- The cached `projectm` crate declares `LGPL-3.0-or-later` in `Cargo.toml`.
- The cached `projectm-sys` crate declares `LGPL-3.0-or-later` in `Cargo.toml`.
- The cached `projectm-sys\LICENSE` and bundled `libprojectM\LICENSE.txt` contain LGPL 2.1 text.
- The bundled `projectm-eval` vendor license is MIT.
- DaisySpoti enables the `projectm-sys/static` feature through the MilkDrop feature.

This combination needs maintainer/legal review before distribution decisions are considered settled. Static linking of LGPL-covered native code can create additional source/object relinking obligations compared with dynamic linking. This audit records the risk and evidence, but it is not legal advice.

Attribution gaps:

- There is no observed generated third-party notice file covering all dependency licenses.
- There is no observed cargo-deny license policy in the repository.
- There is no observed release/package checklist entry proving LGPL/projectM source and relinking obligations are satisfied for every distribution format.

Recommended follow-up:

1. Create a reviewed third-party notices process for crates, native projectM code, icon packs, fonts, and packaging formats.
2. Decide and document the projectM linking/distribution strategy before broad DaisySpoti redistribution.
3. Keep MilkDrop/projectM attribution bundled with the app and release artifacts.
4. Treat license policy as a CI gate only after the allow-list and exceptions are explicit.

## Authentication and token storage

OAuth flow evidence:

- `src/auth.rs` implements OAuth PKCE for Spotify grants.
- The playback grant uses Spotify app client ID `65b708073fc0480ea92a077233ca87bd` and scope `streaming`.
- The shared Web API grant uses client ID `69307a1633c94792bc1bc1cc0c5fb31b`.
- The optional personal Web API grant uses the user-provided client ID and includes broader personal-library and playlist scopes.
- The local redirect listener binds to `127.0.0.1` and the documented redirect path is `/login`.
- Token exchange error handling is intentionally redacted. The test `token_errors_never_include_authorization_response_contents` verifies that OAuth response bodies containing token-like fields are not surfaced in user-visible error strings.

Credential storage evidence:

- `src/credentials.rs` stores grants and proxy passwords through `keyring-core` providers.
- The keyring service name is `rocks.spotifast.Spotifast`.
- Platform-specific providers are compiled by target: Apple native keyring, Windows native keyring, and Linux Secret Service through zbus.
- `Grant` and `ProxyPassword` intentionally avoid `Debug` derivation.
- Native provider errors are collapsed into safe categories because the comments note that provider errors can include secret values.
- Credential work is isolated to a worker thread with request/response channels.
- Profile identity is derived from the state path hash unless `credential-profile` is configured.
- Legacy JSON token files remain only for migration, then are removed after protected-store save and readback validation.
- Sign-out writes revocation markers so stale legacy files are not silently reused.

Settings and persistence evidence:

- `src/settings.rs` intentionally keeps settings as readable JSON.
- Proxy passwords are kept out of serialized settings with `skip_serializing` and stored separately through credentials storage.
- Settings writes are atomic through a temporary file and replace operation.
- Tests verify proxy passwords are omitted from JSON, proxy credential URLs are not serialized, failed proxy migration does not destroy the original secret, and saving other settings does not leak proxy draft passwords.

High-level assessment:

- The repository has strong secret-handling patterns: redacted OAuth errors, OS-protected credential storage, no `Debug` for sensitive credential structs, separate proxy password storage, and regression tests for several leak-prone paths.
- The main residual risk is migration and platform-provider behavior. Legacy plaintext files may exist from older installs until migrated or revoked. Native keyring availability and deletion semantics differ by platform, so tests and docs need to remain explicit.
- Do not reintroduce OAuth grants, proxy passwords, or authorization responses into JSON settings, logs, crash reports, diagnostics, screenshots, or issue templates.

## Network and privacy boundaries

Verified outbound or local network surfaces:

| Surface | Evidence | Privacy/security note |
| --- | --- | --- |
| Spotify Web API | `src/api/client.rs`, docs reference pages | Uses bearer tokens. Request logging records source/method/status/duration and avoids logging Authorization headers. |
| Spotify playback/librespot | `src/player.rs`, `src/backend.rs`, librespot dependencies | Playback/session behavior is delegated to librespot. Do not implement DRM circumvention or fake lossless. |
| OAuth local callback | `src/auth.rs` | Binds loopback `127.0.0.1`. Threat model should preserve strict loopback binding and redacted callback/token errors. |
| LRCLIB lyrics lookup | `src/lyrics.rs` | Sends track artist/title/album/duration when lyrics are requested and Spotify does not provide lyrics. Cache keys are SHA1 over metadata. |
| GitHub update checks | `src/updates.rs`, `docs/_reference/how-it-connects.md` | Checks GitHub release metadata about once per day according to docs. Does not use Spotify credentials. Runtime currently has no publisher key. |
| MilkDrop preset pack downloads | `src/milkdrop.rs` | Downloads curated preset packs through configured HTTP client/proxy. Zip extraction flattens to `.milk` base filenames, reducing path traversal risk. |
| Spotify Connect receiver discovery | `src/zeroconf.rs` | mDNS discovery and encrypted credential handoff to selected local receivers. Discovery is credential-free; credentials are sent only during add-user flow. |
| Proxy support | `src/http.rs`, `src/settings.rs` | Invalid configured proxy fails closed instead of falling back directly. SOCKS uses `socks5h` for remote DNS. Proxy credentials are applied outside proxy URLs. |

Update security observation:

- `src/updates.rs` configures `publisher_key: None` and comments that releases are verified against `checksums.txt` alone until signed updates are enabled.
- `.github/workflows/release.yml` signs checksums when `SPOTIFAST_UPDATE_SIGNING_KEY` is available, but the runtime configuration inspected here does not enforce a publisher key.
- This is an integrity gap for future DaisySpoti distribution. It should be resolved before relying on in-app update installation as a trusted channel.

Telemetry/privacy observation:

- The reference privacy documentation says Spotifast has no telemetry, analytics account, or hosted Spotifast server.
- No telemetry SDK or hosted backend dependency was observed in the dependency audit.
- Preserve this as a DaisySpoti invariant unless the product plan explicitly changes it and documents consent and retention.

## CI and quality gate baseline for dependencies/security

Observed CI workflow coverage:

- Formatting and clippy checks are present.
- Tests run across Linux, macOS, Windows, and Windows ARM variants.
- Native credential store dummy round-trip checks are present on Windows and macOS CI.
- Nix build coverage is present.

Observed gap:

- No repository-owned `cargo-deny` policy was found.
- No dependency advisory/license scanning CI gate was found before the Phase 0 evidence commands.
- No Dependabot/Renovate-style policy was observed in the searched repository evidence.

Recommended CI additions after policy decisions:

1. `cargo deny check advisories bans licenses sources` with a checked-in policy file.
2. A scheduled advisory job so security updates are detected even when app code is not changing.
3. A license/notice generation or verification step tied to release packaging.
4. A clear exception mechanism for advisory ignores, each with owner, expiry/review date, and upstream tracking link.

## Ownership and invariants to preserve

Security and dependency invariants already inherent in the repository:

- Spotify grants belong in OS-protected credential storage, not readable JSON.
- OAuth and token-exchange failures must not print authorization responses or token fields.
- Proxy passwords must not be serialized into settings or logs.
- Invalid configured proxies must not silently fall back to direct traffic.
- SOCKS proxy handling should preserve remote DNS behavior where currently tested.
- Playback and Spotify Connect behavior should remain behind librespot boundaries unless there is a deliberate upstream-compatible reason to change it.
- MilkDrop/projectM must be preserved, but its LGPL/static-linking obligations need explicit packaging decisions.
- Native Rust/no browser-engine architecture should be preserved.
- No telemetry by default.
- No DRM circumvention and no fake Spotify Lossless claims.
- egui and winit fork revisions should move together as required by project instructions.

## Risks to upstream integration

- Security fixes in `quick-xml`, `rsa`, and related Spotify protocol dependencies may require updating or carrying patches in the pinned librespot fork. Blindly replacing librespot could alter playback behavior, auth behavior, or Connect compatibility.
- `rustls` is shared across general HTTP, OAuth, update checks, websocket/TLS paths, and librespot. A lockfile-only update may be enough, but it should be verified across login, Web API, updates, lyrics, proxy, and playback.
- `ttf-parser` reaches the app through the patched winit/Wayland path. Fixing it may require coordinated movement of winit, egui, and platform UI dependencies.
- projectM static linking is both a build feature and a licensing/distribution concern. Changing it affects MilkDrop availability, native packaging, and attribution obligations.
- Adding cargo-deny without a tuned policy would create noisy failures because the default fallback rejected common permissive licenses in the current graph.

## Recommended Phase 1 starting points from this slice

1. Establish dependency governance first: checked-in cargo-deny policy, advisory triage list, accepted license list, and third-party notice process.
2. Fix the high-confidence advisory first: move `rustls` to `>=0.23.45` if compatible.
3. Open or update upstream/fork work for librespot `quick-xml >=0.41.0` and document `rsa` risk until upstream has a safe answer.
4. Resolve projectM LGPL/static-linking packaging obligations before increasing distribution scope.
5. Add runtime update signature enforcement if DaisySpoti will ship self-updates.

## Remaining unknowns

- Exact runtime reachability of the vulnerable `quick-xml` and `rsa` paths inside librespot was not proven in this slice. The dependency path is verified; exploitability for DaisySpoti depends on librespot protocol usage.
- Exact legal obligations for the projectM static-linking configuration need maintainer/legal review.
- The full release artifact contents were not audited here, so attribution files actually shipped by installers/packages need a packaging-specific pass.
- Linux native credential store behavior depends on Secret Service availability and desktop environment configuration; source and tests cover fallbacks, but real-desktop behavior varies.

## Phase 0 closeout

See [CLOSEOUT.md](CLOSEOUT.md) for source-level advisory applicability, concrete
attribution/package release gates and CI activation follow-up. No advisory is
suppressed and the baseline dependency graph remains unchanged.
