# Quality, CI, Packaging, Platform, and Branding Baseline

Phase: 0 - Baseline and Safety

Scope: CI/build quality, packaging and release automation, platform integration,
branding surface area, and verification coverage. This file records repository
evidence only. It does not claim any check passed unless a separate Phase 0
evidence file records the actual command result.

## Current repository facts

- Current package identity is still Spotifast: `Cargo.toml` declares package
  name `spotifast`, default binary `spotifast`, version `0.12.0`, MIT license,
  description `A native Spotify client`, and upstream repository
  `https://github.com/crmne/spotifast` (`Cargo.toml:1-20`).
- The application binary entry point is `src/spotifast.rs`, which calls
  `entrypoint::run()` (`src/spotifast.rs:1-9`).
- Windows resources still embed the Spotifast icon and product name
  (`build.rs:47-56`).
- The self-update configuration still points at upstream Spotifast release
  infrastructure: bundle id `rocks.spotifast.Spotifast`, executable
  `Spotifast`, repository `crmne/spotifast`, product name `Spotifast`, and slug
  `spotifast` (`src/updates.rs:15-31`).
- Protected credential storage still uses service name
  `rocks.spotifast.Spotifast` (`src/credentials.rs:22`). The native backends
  are Linux Secret Service, macOS Keychain, and Windows Credential Manager
  (`src/credentials.rs:181-195`).
- Application directories still use the project name `spotifast` under
  organization `me/paolino` (`src/paths.rs:19-24`).
- The single-instance protocol name is still `spotifast`
  (`src/single_instance.rs:27-30`).

## CI baseline

The CI workflow is `.github/workflows/ci.yml`.

- It was originally configured for pushes to `main`, pull requests,
  merge groups, and manual dispatch (`.github/workflows/ci.yml:3-8`).
- Parent Phase 0 work added a `dev` push trigger after this audit began. Treat
  the file as the source of truth if line numbers have shifted.
- Quality job coverage includes formatting, Flatpak metadata tests, Linux
  launcher packaging tests, release-name tests, clippy with default features,
  clippy with all features, and rustdoc with `-D warnings`
  (`.github/workflows/ci.yml:44-59`).
- Test matrix coverage is Ubuntu, macOS, Windows x64, and Windows ARM
  (`.github/workflows/ci.yml:61-75`).
- CI installs Linux GUI dependencies for tests (`.github/workflows/ci.yml:78-83`).
- CI installs Windows GLEW through vcpkg for libprojectM/MilkDrop
  (`.github/workflows/ci.yml:84-100`).
- CI runs default-feature tests, all-feature tests, native credential store
  round-trip tests on Windows/macOS, and doc tests
  (`.github/workflows/ci.yml:106-115`).
- CI verifies Windows binaries do not import the dynamic MSVC runtime and match
  runner architecture (`.github/workflows/ci.yml:116-128`).
- CI validates Windows installer syntax with Inno Setup
  (`.github/workflows/ci.yml:130-139`).
- CI validates macOS bundle identity and helper startup
  (`.github/workflows/ci.yml:141-157`).
- CI builds the Nix package and can publish the Nix closure only on successful
  `main` pushes when cache variables/secrets are configured
  (`.github/workflows/ci.yml:159-191`).
- CI builds the docs site with Jekyll (`.github/workflows/ci.yml:193-211`).

No local CI execution result is recorded in this file.

## Branch protection baseline

Reported by parent Phase 0 work after this audit began:

- Original fork state had no fork workflow runs and no branch protection.
- `main` is now protected with 1 approval required, linear history, no force
  pushes, no deletion, and administrator enforcement.
- `dev` is now protected with linear history, no force pushes, no deletion, and
  administrator enforcement.
- Main now requires strict checks for quality, all four platform test jobs,
  Nix package and docs. These names have not yet been validated by a fork run.
- Remote dev was created at the baseline, then advanced by the focused
  policy/CI commit `a073de4f3e7367c021294c65e0b6293167608613`.
- Actions permissions report enabled, but the workflow registry and run list
  remain empty. Explicit fork dispatch returns 404 despite the workflow file
  existing in the contents API. See VALIDATION.md for the unresolved gate.

These are repository-hosting settings, not facts derived from local source
files.

## Release and packaging baseline

Release and packaging are still wired to Spotifast.

- Release workflow triggers on `v*` tags and has `contents: write`
  (`.github/workflows/release.yml:3-10`).
- Release builds Linux x64/ARM64 and Windows x64/ARM64 artifacts
  (`.github/workflows/release.yml:14-142`).
- Release builds a macOS universal app and can sign/notarize when Apple secrets
  are present (`.github/workflows/release.yml:143-198`).
- Release builds a Flatpak bundle from the Linux binary
  (`.github/workflows/release.yml:200-230`).
- Release publishes GitHub release assets, signs checksums with
  `SPOTIFAST_UPDATE_SIGNING_KEY`, and uses release notes from
  `packaging/release-notes/${tag}.md`
  (`.github/workflows/release.yml:232-285`).
- Stable tag releases call the packaging workflow with inherited secrets
  (`.github/workflows/release.yml:286-293`).
- The packaging workflow calls `crmne/native-packages` at a pinned v0.8.1
  commit (`.github/workflows/packaging.yml:41-51`).
- Packaging tests install and remove the generated macOS Homebrew cask,
  validate AppImage startup, and test Linux package installation in clean
  containers (`.github/workflows/packaging.yml:53-138`).
- `native-packages.yaml` names package `spotifast`, maintainer Carmine Paolino,
  homepage `https://github.com/crmne/spotifast`, and description
  `A native Spotify client` (`native-packages.yaml:13-18`).
- `native-packages.yaml` release repository is `crmne/spotifast`
  (`native-packages.yaml:129-132`).
- `native-packages.yaml` downstream publish destinations are upstream AUR repos
  and `crmne/homebrew-tap` (`native-packages.yaml:154-198`).
- Windows installer identity is `Spotifast`, publisher `Carmine Paolino`,
  upstream support/update URLs, fixed AppId, and Spotifast setup filename
  (`packaging/windows/spotifast.iss:30-55`).
- Windows installer registers the shared `spotify:` scheme plus a
  `Spotifast.spotify` ProgID (`packaging/windows/spotifast.iss:84-101`).
- macOS bundle script uses executable `Spotifast` and identifier
  `rocks.spotifast.Spotifast` (`packaging/macos/bundle.sh:21-31`).
- macOS Info.plist names Spotifast, registers Spotify URL handling, and carries
  upstream copyright/not-affiliated text (`packaging/macos/Info.plist:5-34`).
- Flatpak app id is `rocks.spotifast.Spotifast`, command `spotifast`, MPRIS
  name `org.mpris.MediaPlayer2.spotifast`, and Secret Service access is
  granted (`packaging/flatpak/rocks.spotifast.Spotifast.yml:12-38`).
- Native Linux desktop entry is `spotifast.desktop`, `Name=Spotifast`,
  `Exec=spotifast %u`, `Icon=spotifast`, and
  `StartupWMClass=spotifast` (`packaging/applications/spotifast.desktop:1-14`).
- Homebrew cask template points at `crmne/spotifast` release downloads and
  installs `Spotifast.app` (`packaging/homebrew/spotifast.rb.in:1-20`).
- Arch binary package template points at `crmne/spotifast`, provides and
  conflicts with `spotifast`, and installs `/usr/bin/spotifast`
  (`packaging/arch/spotifast-bin/PKGBUILD.in:1-45`).
- Nix package still names `spotifast`, installs Linux desktop/icon assets,
  builds `Spotifast.app` on macOS, uses identifier `rocks.spotifast.Spotifast`,
  and sets homepage `https://spotifast.rocks` (`flake.nix:91-221`).

Publishing from this fork is unsafe until release, update, package, downstream,
and app identity ownership are deliberately reworked.

## Platform integration inventory

- Windows standalone behavior depends on static CRT flags in
  `.cargo/config.toml:1-7` and CI dumpbin validation.
- Windows installer URL registration touches per-user registry keys under
  `Software\Classes\spotify`, `Software\Classes\Spotifast.spotify`,
  `Software\Spotifast\Capabilities`, and `Software\RegisteredApplications`
  (`packaging/windows/spotifast.iss:84-101`).
- Windows taskbar thumbnail controls are implemented in `src/thumbbar/win.rs`.
  The hook is installed into the window procedure and must detach safely when
  windows are destroyed (`src/thumbbar/win.rs:95-121`, `163-299`).
- macOS app bundle identity and URL scheme registration are in
  `packaging/macos/Info.plist:5-34`.
- macOS platform integrations include menu/Dock code in `src/mac_menu.rs`, link
  handling in `src/mac_links.rs`, notch support in `src/mac_notch.rs`, and
  Touch Bar crash guard code in `src/mac_touchbar_crash_guard.rs`.
- Linux desktop identity is the desktop entry name, Flatpak app id, and MPRIS
  bus name (`packaging/applications/spotifast.desktop:1-14`;
  `packaging/flatpak/rocks.spotifast.Spotifast.yml:30-38`).
- Linux startup gives librespot PulseAudio streams user-visible metadata
  `Spotifast` and `Spotify playback` before other threads start
  (`src/entrypoint.rs:260-285`).
- Linux/X11 mini-player taskbar hiding is handled directly through X11 atoms
  when the backend is Xlib/Xcb (`src/window.rs:126-217`).
- MilkDrop runs as a separate child process with its own winit event loop and
  OpenGL context (`src/milkdrop/child.rs:1-6`, `916-990`).

## Verification surfaces

- Documented local checks are in `CONTRIBUTING.md:126-183`.
- Packaging launcher regression coverage is in `packaging/test-launchers.py`.
  It validates AUR, Flatpak, native desktop entries, icons, and executable
  names (`packaging/test-launchers.py:43-119`).
- Release naming coverage is in `packaging/test-release-names.py:15-48`.
- Flatpak metainfo release/app-id coverage is in
  `packaging/flatpak/test-metainfo.py:22-69`.
- Linux clean-container install coverage is in `packaging/test-install.sh:25-77`.
- GUI runtime library probing is in `packaging/check-runtime-libs.c:1-28`.
- Update launch compatibility tests are in `tests/launch_contract.rs:1-63`.
- Startup diagnostics test is Linux/demo-gated in `tests/startup_diagnostics.rs:1-35`.
- Linux tray behavior test is in `tests/tray.rs:1-74`.
- Branding tests are in `tests/branding.rs:23-114` and Linux command forwarding
  coverage continues at `tests/branding.rs:116-240`.
- Demo/screenshot CLI support is defined in `src/entrypoint.rs:28-83` and
  documented in `docs/_reference/settings-and-files.md:298-349`.

## Licensing and attribution evidence

- Repository license is MIT (`LICENSE:1-19`; `Cargo.toml:7`).
- README attributes librespot, egui, Inter, and Lucide, and states the project
  is not affiliated with Spotify (`README.md:137-144`).
- Lucide icons carry ISC plus Feather MIT notices in
  `assets/icons/LICENSE.txt:1-39`.
- Font license files are present at `assets/fonts/Inter-LICENSE.txt` and
  `assets/fonts/NotoEmoji-LICENSE.txt`.
- Flatpak metainfo declares metadata license `CC0-1.0` and project license
  `MIT` (`packaging/flatpak/rocks.spotifast.Spotifast.metainfo.xml:9-10`).
- Spotifast release notes and public docs include additional author and upstream
  attribution. Daisy branding work should preserve legally necessary upstream,
  dependency, and Spotify trademark disclaimers while replacing product-owned
  identity.

## Branding replacement plan

Branding is not a single rename. It crosses runtime identity, persisted data,
OS registrations, release updates, docs, tests, and package ecosystems.

Recommended order for future work:

1. Define Daisy-owned canonical identifiers before editing code:
   product name, crate/bin name, macOS bundle id, Flatpak app id, MPRIS id,
   Windows AppUserModelID/AppId/ProgID, credential service name, package names,
   update repository, website domain, executable name, docs title, and logo/icon
   assets.
2. Decide migration policy separately from rename mechanics:
   whether Daisy imports Spotifast settings, cache, skins, MilkDrop presets,
   credentials, update state, and single-instance state; which names remain
   legacy aliases; and which secrets must not be copied automatically.
3. Re-own release/update infrastructure before enabling public releases:
   `.github/workflows/release.yml`, `src/updates.rs`, `native-packages.yaml`,
   `packaging/release-names.py`, updater signing keys, release notes,
   Homebrew/AUR destinations, Flatpak app id, and docs download pages.
4. Re-own platform packaging:
   Windows installer AppId and registry names, macOS bundle identifiers and
   signing/notarization names, Linux desktop entry/icon/window class/MPRIS,
   Flatpak manifest and metainfo, Nix package/app, Homebrew cask, AUR packages,
   DEB/RPM/AppImage names, Omarchy assets, and portable archive names.
5. Re-own user-visible docs and assets:
   README, docs site config, screenshots, release notes policy, issue templates,
   funding/sponsor links, docs URLs, footer ownership, and trademark disclaimers.
6. Re-own test expectations at the same time:
   `tests/branding.rs`, packaging tests, Flatpak metainfo tests, release-name
   tests, startup diagnostics, update launch tests, docs tests, and translation
   catalogs.

Do not change all branding in one broad unverified pass. The safer boundary is
one migration-focused series with explicit tests for identity, persistence,
package installation, update compatibility, and user data handling.

## Hazards for upstream integration

- Upstream fixes may touch the same CI, packaging, update, docs, and identity
  files that Daisy must own. These files should be treated as Daisy-owned once
  rebranded, even when logic fixes are ported from upstream.
- `src/updates.rs`, `native-packages.yaml`, release workflows, Flatpak
  manifests, and OS package templates are high-risk because they can publish,
  update, or install under the wrong product identity.
- `src/credentials.rs`, `src/paths.rs`, and `src/single_instance.rs` are
  high-risk because naive renames can strand user data, copy secrets into the
  wrong namespace, or make Spotifast and Daisy instances conflict.
- `tests/branding.rs` currently asserts Spotifast identity details in some
  places and also contains a broad old-name scanner. It is useful as a future
  migration guard, but expected strings must be reviewed before relying on it.
- Docs and release notes include historical Spotifast references. Some should
  remain as attribution/history, while product identity and active links should
  become Daisy-owned.

## Open items

- Main requires seven strict status contexts; no fork workflow result yet
  validates those names or satisfies the gate.
- No package publish destinations are Daisy-owned yet.
- No Daisy app id, bundle id, credential service, package name, update
  repository, website domain, or signing identity is documented in the repo yet.
- No local result is recorded here for CI, clippy, tests, packaging tests, Nix,
  docs build, or release workflow dry runs.

## Phase 0 CI closeout

A read-only Daisy baseline workflow is now registered and passing. The full
inherited CI matrix is registered and running on dev. See CLOSEOUT.md and
VALIDATION.md for run identifiers and final observed coverage. Earlier statements
about an empty fork registry describe the intake state and are superseded.
