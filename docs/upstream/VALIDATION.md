# Phase 0 validation and performance evidence

Audit date: 2026-10-07. No runtime source or dependency versions changed.
This records successes, resolved failures and remaining validation gaps. The
final seven-job CI run passed; advisory findings and measurement limits remain.

## Environment and build setup

Windows 11 Pro 25H2, x86_64; Ryzen 7 9850X3D (8 cores / 16 logical processors),
approximately 32 GB RAM, Radeon RX 9070 XT, AMD OpenGL 3.3 driver
`26.9.1.260826`. Two 2560x1440 displays at 240/180 Hz were present. C: had
approximately 28 GiB free initially; cold Cargo builds materially reduced that.
No compiler flags were varied from repository profiles/configuration.

The pinned Rust 1.98.0 toolchain was initially missing and rustup installed it.
Plain Cargo was used because mise/mbx were not installed. Target output stayed
in this checkout's target directory; no shared target and no cargo clean.

Native prerequisites: Visual Studio Community 2026 18.9.2, its x64 developer
environment, bundled CMake/Ninja, `CMAKE_GENERATOR=Ninja`,
`VCPKG_INSTALLATION_ROOT=C:/dev/vcpkg`, `glew:x64-windows-static` installed with
vcpkg, and temporary libclang 18.1.1 from the Python libclang wheel. The initial
VS shell setup emitted a missing-vswhere warning; subsequent setup added the
Installer directory to PATH. It did not change repository compiler settings.

Python launcher `py` selects Python 3.14.6; `python.exe` on PATH is a Windows
Store alias. Linux packaging/docs checks additionally used Ubuntu WSL with Ruby,
Ruby development headers and build tools installed. Bundler/Jekyll dependencies
were staged under `.cache/phase0`, not added to application dependencies.
Bundler added a checksum to Gemfile.lock during setup; the original bytes/content
were restored and that incidental lockfile change is not part of Phase 0.

## Executed checks

| Command / scope | Outcome | Evidence |
| --- | --- | --- |
| `cargo fmt --all --check` | Pass | `evidence/fmt.txt` (empty successful output) |
| Initial `cargo test --locked --all-targets` | Exit 101, missing VCPKG_INSTALLATION_ROOT | `evidence/test-default.txt` |
| Configured `cargo test --locked --all-targets` | Exit 101; library 939 passed, 1 ignored; bin 12, branding 3, localization 1 passed; updater test executable cannot launch (740) | `evidence/test-default-configured.txt` |
| `cargo test --locked --all-targets --all-features` | Exit 101; library 962 passed, 1 ignored; bin 13, branding 3, localization 1 passed; same updater launch failure | `evidence/test-all.txt` |
| `cargo test --locked --all-features --doc` | Pass, zero doc tests | `evidence/test-doc.txt` |
| `cargo clippy --locked --all-targets -- -D warnings` | Pass | `evidence/clippy-default.txt` |
| `cargo clippy --locked --all-targets --all-features -- -D warnings` | Pass | `evidence/clippy-all.txt` |
| `RUSTDOCFLAGS=-D warnings cargo doc --locked --all-features --no-deps` | Pass | `evidence/rustdoc.txt` |
| `cargo build --locked --all-features` | Pass, development demo and MilkDrop | `evidence/build-demo.txt` |
| `cargo build --locked --release --features demo` | Pass, optimized demo and MilkDrop, 3m23s cold build | `evidence/build-release-demo.txt` |
| `cargo build --locked --release` | Pass, production app without demo | `evidence/build-release.txt` |
| Final format and branding tests | Pass, 3 branding tests | `evidence/fmt-final.txt`, `evidence/branding-final.txt` |
| Final `cargo test --locked --all-targets` | Pass: 939 library tests, unchanged launch-contract tests and all targets | `evidence/test-default-final.txt` |
| Final `cargo test --locked --all-targets --all-features` | Pass: 962 library tests and all targets | `evidence/test-all-final.txt` |
| Final all-feature clippy, warnings denied | Pass | `evidence/clippy-final.txt` |
| Clean LF launcher tests in WSL | Pass, 4 tests | `evidence/launchers-clean-lf.txt` |
| Native Credential Manager dummy round-trip, exact ignored test | Pass, 1 test | `evidence/native-store.txt` |
| Updater default test executable copied to neutral `phase0-check.exe` | Both tests pass; diagnostic experiment only | `evidence/update-launch-renamed.txt` |
| `py packaging/flatpak/test-metainfo.py` | Pass, 4 tests | `evidence/metainfo.txt` |
| `py packaging/test-release-names.py` | Pass, 4 tests | `evidence/release-names.txt` |
| `py packaging/test-launchers.py` on Windows | Fail: missing Unix true/Ruby and path semantics | `evidence/launchers-windows.txt` |
| Launcher tests under WSL, checkout and Git archive | Fail: CRLF conversion, including desktop payload | `evidence/launchers-wsl-configured.txt`, `evidence/launchers-lf-baseline.txt` |
| Launcher tests under WSL after normalizing only scratch shell files | Fail: desktop payload still CRLF; diagnosis superseded below | `evidence/launchers-normalized-scratch.txt` |
| `bundle exec jekyll build` under WSL | Pass; final audit docs also build, 5.142s | `evidence/jekyll.txt`, `evidence/jekyll-final.txt`, `evidence/jekyll-closeout.txt`, `evidence/jekyll-closeout-final.txt` |
| `cargo deny check advisories` | Fail: 4 vulnerabilities, 1 unmaintained warning/error | `evidence/advisories.txt` |
| `cargo deny check` without a repository policy | Fail: advisories and default license policy rejects common licenses; bans/sources checks completed with warnings | See SECURITY_AND_DEPENDENCIES.md; generic output not retained as a multi-megabyte artifact |

Some integration targets ran zero tests on Windows due to platform cfgs. The
ignored native-store test was run separately and passed. No tests were deleted,
skipped or weakened. The test target and developer inspection example were
renamed to neutral executable names to avoid Windows installer-name heuristics;
their source contents and assertions are identical.

The neutral-name experiment supports Windows installer-name heuristics as the
cause of error 740. It is not a passing result for the documented Cargo command.
The earlier claim of an inherited Flatpak mismatch was incorrect: the desktop
payload also had CRLF, so the sed end-of-line match could not apply. A fresh
`git -c core.autocrlf=false archive` export passes all four launcher tests under
WSL without modifying packaging source. See `evidence/launchers-clean-lf.txt`.

Follow-up: `tests/update_launch.rs` is now `tests/launch_contract.rs` and
`examples/updater-inspect.rs` is now `examples/release-inspect.rs`. Both names
triggered error 740 on this machine. Neither contains changed Rust code. The
example invocation is now `cargo run --example release-inspect -- <app-path>`.
The original failure evidence is retained separately from final passing runs.


## Native runtime and visual baseline

Ran the built app in isolated demo profiles, without restoring Spotify grants.
Demo uses simulated Spotify data but downloads placeholder artwork from Picsum.
It is not a fully network-free run or a real audio decode test.

- Matched 1280x800 and 760x800 dark/light playlist-with-queue captures.
- Built-in Winamp capture, inspected as rendered.
- MilkDrop host capture and a real separate projectM child process confirmed.
  Captured the child's 640x480 OpenGL window using PrintWindow and inspected the
  rendered visualization. This verifies native rendering/process startup, not
  audio synchronization under authenticated playback or preset stress.
- AMD renderer initialization and successful captures recorded in demo logs.

See [the screenshot index](screenshots.html). At 760x800, the open queue leaves
the workspace extremely narrow; header/rows truncate and filter/play controls
overlap. Navigation/search controls crowd together. This is an existing defect
or design limitation, not fixed in Phase 0. Desktop 1280x800 and Winamp render.
No claim of exhaustive accessibility, all interaction states or all sizes.

## Performance method

### Exact-checkout production measurement follow-up

The user explicitly authorized temporarily switching from installed Spotifast to
the built production application, and exited the installed tray process. The
existing profile restored authentication through the application's normal path;
no grants were copied or inspected. Production executable SHA-256:
`9859B5BD13B4EE8927CD144DE73B203A622D9E85613BC62BC03987FF286176D4`.
`measure-production-startup.ps1` recorded warm main-window readiness of 65.08 ms.
It records boot age and refuses to start while any Spotifast process exists.
Its syntax check and refusal path passed; the successful production launch
validated its readiness/evidence path. It leaves the application open.

The user confirmed a normal song playing after being asked to choose this
computer. Two minutes / 60 samples averaged 0.04146% total-machine CPU,
maximum 0.1463%; working set 227.137-227.348 MiB and private commit
369.902 to 369.371 MiB. See `evidence/checkout-playing.json` and CSV.
This is a different song/session from the installed-release sample, so the
difference is not evidence of a performance improvement. Locality relies on
the requested user setup, not an instrumented audio-output probe.

The user then confirmed playback paused and the application minimized.
Two minutes / 60 samples averaged 0.00163% total-machine CPU, maximum
0.0488%; working set 231.418-257.008 MiB and private commit 426.098 to
400.301 MiB. See `evidence/checkout-paused-minimized.json` and CSV.
This is minimized idle, not visible-window idle. Transient memory changes
between intervals are not a leak or plateau conclusion. Both samples completed
with the same executable hash and process. The application was left open.

For a first launch following a user-scheduled restart, run the startup script
with `-Condition FirstLaunchAfterRestart` before opening Spotifast. The script
does not reboot, clear OS caches, or certify cold caches from boot age alone.
Main-window readiness remains distinct from first paint or authenticated readiness.

### Earlier demo and installed-release measurements

`measure-baseline.ps1` launches the optimized **demo** four times using an
isolated profile. Time is process launch to a nonzero native main-window handle,
not first paint or interactive readiness. Run zero uses a fresh profile, but OS
filesystem/GPU caches are uncontrolled; it must not be called reboot-cold.
The last run samples simulated paused local UI every five seconds for ten
minutes after a ten-second settling period. It does not run librespot audio.
CPU is normalized to all 16 logical processors, like total-machine CPU, and
both working set and private committed memory are recorded.

`measure-process.ps1` samples the user's already-running installed Spotifast
without changing settings, login or playback. The user confirmed playback and
then paused it on request. Each sample lasts approximately two minutes.
Installed binary reports 0.12.0 and hash
`E4867B8EB54021732126B6F0C906702B31D2FFC7A6E725E3DCB121B2F478FE01`.
Version alone does not prove its commit. Follow-up archive verification found
the installed executable exactly matches upstream v0.12.0 Windows portable
payload, whose release tag is eleven commits before the checkout. This proves
published-artifact identity, not a signed source-build attestation. See
`evidence/release-attribution.json`; do not equate it with the post-release
checkout baseline. No credentials, logs or track metadata from
the installed app were read. Playback-locality relies on the requested user
setup, not an instrumented output-device probe.

The installed playback CSV retains the initial label
`installed-session-unconfirmed`; playback was subsequently confirmed by the
user during that sample. Its mean CPU was 0.24556%, maximum 0.7319%, working
set 244.789-249.625 MiB; private commit grew 379.676 to 385.582 MiB. This brief
growth is not evidence of a leak or a plateau.

Installed paused sample: mean CPU 0.01871%, maximum 0.1953%, working set
241.188-244.910 MiB, private commit 377.391 to 378.254 MiB. The user confirmed
the paused state. See `evidence/installed-paused.json` and its CSV. Demo metrics
are recorded in performance.json. Fresh-profile window readiness was 157.33 ms;
warm runs were 45.45, 36.00 and 47.66 ms. Ten-minute demo mean CPU was
0.01676%, working set 179.043-200.164 MiB, private commit 293.648 to
288.570 MiB. These are proxy measurements under the limitations above.

Production dumpbin imports contain no VCRUNTIME, MSVCP or api-ms-win-crt DLL
imports, consistent with the configured static CRT. This is not installer QA.
Evidence text paths were sanitized to placeholders; measurements and hashes
were preserved.

## CI and platform limits

Initially the fork API had Actions enabled but zero registered workflows/runs.
Explicit ci.yml dispatch returned 404 despite a confirmed workflow file. After
adding `.github/workflows/phase0.yml` and pushing dev, both that workflow and the
existing CI registered. Registration was initially asynchronous; the specific
server-side cause of the earlier empty registry is not established.

The read-only Daisy baseline push and manual runs passed, including formatting,
manifest and four launcher contracts. Full native CI run 37685448644 completed successfully:
https://github.com/DaisyCatTs/SpotiDaisy/actions/runs/37685448644 .
All seven required jobs passed: quality, Linux, macOS, Windows x64, Windows ARM,
Nix package and docs. Main required context names were read back and exactly
match those successful jobs. See evidence/ci-closeout.json, required-checks.json
and ci-test-summaries.json. No source/runtime/Cargo differences exist between
the tested dev SHA and the focused closeout branch.
Two earlier full runs were cancelled during duplicate/concurrency cleanup.

One initial gh workflow run implicitly resolved upstream and was denied 403;
no upstream workflow started. All closeout commands explicitly target Daisy.
Main remains unchanged. No release/deployment/publishing workflow was triggered.

Windows x64 was built and run locally. WSL tested packaging/docs. GitHub CI
built/tested Linux, macOS, Windows x64 and Windows ARM, built Nix, verified
Windows static runtime/machine architecture and Inno installer syntax, and
validated macOS bundle/helper startup. Windows/macOS native dummy credential
round trips passed. Linux native credential-store probing is intentionally
skipped by the inherited CI condition and remains unvalidated on a real desktop.
Real GUI/audio/device behavior outside this Windows machine, actual package
installation, signing/notarization and other release artifacts remain untested.
One published upstream Windows portable archive was checksum-verified and
inspected for attribution material; its binary was not executed.

## Remaining measurement gaps

True cold startup (reboot or controlled cache state), authenticated readiness
timing beyond the native-window proxy, and multi-hour/day browsing/playback soak
remain unvalidated. Exact-build warm window startup and authenticated playback
have now been measured above. A ten-minute static
demo cannot prove cache bounds, 10k/100k library behavior or memory leak absence.
MilkDrop/EQ/device reconnect/gaplessness under real audio load also need dedicated
later validation. These gaps must remain visible in the master checklist.

Disposable QA scratch remains ignored under .cache/phase0 because automatic
approval review rejected the recursive cleanup command. It is not committed.

## Further installed-session observation

A second ten-minute observation recorded 300 samples of the same installed binary
hash/version without controlling playback or reading credentials. Mean CPU was
0.04000%, maximum 0.2926%; working set 108.109-113.176 MiB and private commit
414.961 to 415.879 MiB. Playback/window state was not confirmed for this interval,
so these are session-observation metrics, not a new playing/paused benchmark.
Working set can be trimmed by the OS and is not interchangeable with private
commit. The +0.918 MiB short-interval change does not prove a leak or long-term
stability. See evidence/installed-observed-session.json and its 300-row CSV.

CI emitted an informational runner warning: ubuntu-latest begins migration to
Ubuntu 26 on October 19, 2026. Track native/package compatibility when that moves;
this run passed. Dev intentionally allows direct work without required-status
gates; stable main enforces all seven.

## Extended memory observation

The same installed process was observed for another twenty minutes (600 samples):
mean machine CPU 0.04041%, maximum 0.878%; working set 79.492-135.262 MiB;
private commit 416.000 to 419.969 MiB (+3.969 MiB). Combined with the separate
10-minute observation, this provides 30 minutes of sampled session behavior.
The process remained alive throughout. Playback/window/workload state was not
controlled, so the samples do not prove a leak, a steady plateau or exact-build
performance. See evidence/installed-long-session.json and its CSV.
