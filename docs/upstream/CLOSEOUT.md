# Phase 0 closeout and release gates

Updated 2026-10-07. No later-phase implementation is authorized here.

## Closed

- Audit and neutral-name test fixes published to origin/dev.
- Full local default/all-feature tests, clippy and formatting pass.
- Clean-LF launcher contracts pass; the original Flatpak mismatch claim is superseded.
- New read-only `.github/workflows/phase0.yml` registered successfully. Both its
  push and manual runs passed. Existing CI is now registered and dispatchable.
- Stable main remains at the immutable upstream baseline. No upstream merge.

Closeout documents are on `audit/phase0-closeout`, based on published dev. This
focused branch lets evidence be published without interrupting dev CI.

## Validated CI

Full matrix run: https://github.com/DaisyCatTs/SpotiDaisy/actions/runs/37685448644
at `4c326af0d3ae85bd8b3c0039c3b6a26880ec0607`. All seven jobs passed. Main required context names exactly match those jobs.
Results, steps and test summaries are retained in evidence/ci-closeout.json,
required-checks.json and ci-test-summaries.json. CI is validated, not merely
registered. See VALIDATION.md for platform runtime limits.
Two earlier full runs were cancelled during duplicate-dispatch/concurrency cleanup.
No release workflows, publishing steps or stable-main commits were triggered.

A further ten-minute observation of the user's installed authenticated process
recorded 300 samples: mean CPU 0.04000%, working set 108.109-113.176 MiB,
private commit 414.961 to 415.879 MiB. It records RAM/CPU without controlling playback. Its state is not confirmed for this
sample, so it must not be labelled an active-playback or paused-idle benchmark.

## Security triage

| Priority / boundary | Evidence | Next bounded action / validation |
| --- | --- | --- |
| Before shipping: general TLS | rustls 0.23.43, RUSTSEC-2026-0285; scan requires >=0.23.45 | Focused lockfile update, record old/new dependency tree, test HTTP/proxy/auth paths and platform matrix; no wholesale supplier update |
| Supplier tracking: XML | quick-xml 0.38.4, RUSTSEC-2026-0194/0195 | Review and upgrade in the librespot fork; keep the advisory visible until a validated fix or reviewed applicability decision |
| Supplier tracking: RSA | rsa 0.9.10, RUSTSEC-2023-0071, no patched version in scan | Retain upstream tracking; re-review if private-key operations are introduced |
| Supplier tracking: font parser | ttf-parser 0.25.1 unmaintained via Wayland dependencies | Coordinate winit/egui supplier changes and Linux rendering checks |
| Before Daisy self-update distribution | Updater still targets crmne/spotifast, publisher key unset | Design identity/migration and signing policy before enabling Daisy release updates |

Additional source evidence at pinned librespot `23fc42c`:

- `core/src/session.rs:812-845` parses ProductInfo using a plain `quick_xml::Reader`,
  Start/End/Text events and `xml_content()`. No attribute iteration or NsReader was
  found at this call site. The advisories identify attribute duplicate checking
  and namespace resolution respectively. This narrows applicability; it does not
  certify all XML parsing as safe or suppress either advisory.
- `core/src/connection/handshake.rs:75-92` uses a fixed server public key and
  `RsaPublicKey::verify(Pkcs1v15Sign, ...)`. Searches of app and pinned librespot
  source found no RSA private-key/decryption use. The advisory concerns timing
  leakage of private keys. This observed usage does not expose a private key;
  dependency presence remains recorded and future use must be reviewed.

Primary advisories:
[XML CPU](https://rustsec.org/advisories/RUSTSEC-2026-0194.html),
[XML memory](https://rustsec.org/advisories/RUSTSEC-2026-0195.html),
[RSA](https://rustsec.org/advisories/RUSTSEC-2023-0071.html).
No scanner ignores or dependency upgrades were added during this closeout.

## Attribution and static MilkDrop distribution

Default release builds statically link projectM. The dependency metadata declares
LGPL-3.0-or-later while README/license texts indicate LGPL 2.1. Resolve the intended
licensing with the supplier before choosing the exact compliance route.

Current archive/install recipes generally copy only the root MIT LICENSE/README:
release workflow archive and macOS staging, Windows .iss, both Flatpak manifests,
native-packages.yaml and Arch recipes. The app's GitHub tag source archive does
not contain the pinned Cargo git dependency source trees or relinkable objects.
Flathub cargo-sources generation helps source builds fetch dependencies but does
not establish complete installed notices.

An actual upstream v0.12.0 Windows portable archive was downloaded read-only and
its SHA-256 matched checksums.txt: 6b6c31d069c93feb1750f1083ff6273457add972296d772a28ea7ecb5f032a51.
Its complete file payload is LICENSE, README.md, spotifast-portable.txt and
spotifast.exe. No projectM license, dependency source or relinkable objects are
bundled. See evidence/release-attribution.json for names, sizes and hashes. The
binary was not executed or installed; other package formats remain recipe-only.

Before broad binary distribution, produce and validate:

1. Third-party notices and applicable license texts, including projectM,
   projectm-rs, projectm-eval, hlslparser, icons and fonts.
2. Exact dependency/native source material plus build instructions and the
   source/relinking mechanism required by the confirmed license strategy.
3. Artifact checks for Windows portable/installer, macOS bundle/DMG, Flatpak,
   DEB/RPM/AppImage, Arch and source archives. Root LICENSE existence is insufficient.
4. A maintained license/advisory policy. Default cargo-deny license failures are
   not a reviewed allowlist; do not hide copyleft or vulnerability findings.

MilkDrop remains enabled. No linking strategy, product feature or licensing
exception has been silently changed. This audit identifies missing material,
not a completed distribution-compliance certification.

## Measurement limits

The authenticated installed binary exactly matches the executable in the published
upstream v0.12.0 Windows x64 portable archive (payload SHA-256 verified). The
release tag points at ed9cb550d1514b5e7edfcf44d58d04406a3d5c5b, eleven commits
before our checkout. This establishes published-artifact identity, not an embedded
commit or signed build attestation; do not equate it with the checkout.
Fresh-profile/window-handle startup is a repeatable proxy, not reboot-cold/first
paint. A real cold-start run requires a controlled restart/cache condition and
user-compatible scheduling. Exact-build authenticated testing was subsequently
authorized by the user, who exited installed Spotifast before the production
build was launched. The application restored its existing profile normally;
no grants were copied or inspected. Warm main-window readiness was 65.08 ms.
Two-minute playback sampling averaged 0.04146% CPU and 227.137-227.348 MiB
working set. See VALIDATION.md for executable hash and evidence.
User-confirmed paused/minimized sampling then averaged 0.00163% CPU,
231.418-257.008 MiB working set and 426.098 to 400.301 MiB private commit.
The application remains open; no credential migration or settings change was
performed for this measurement. On 2026-10-07 Daisy explicitly waived the
reboot-cold startup test. The validated performance row is complete within that
scope; the skipped cold test is recorded as `[-]`, never as a successful measurement.
Short samples cannot establish multi-hour cache bounds.

Extended installed session: a further 20-minute/600-sample observation completed.
Mean CPU 0.04041%; resident RAM 79.492-135.262 MiB; private commit
416.000 to 419.969 MiB. The two session observations total 30 sampled minutes;
unknown workload and a short interval preclude a leak/plateau conclusion.
