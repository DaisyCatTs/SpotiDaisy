# DaisySpoti Phase 0 Architecture Baseline

This document records the current Spotifast-derived architecture observed in
the repository during Phase 0. It is a read-only architecture and feature
inventory for future DaisySpoti work. It does not propose or implement Phase 1
changes.

## Scope and Sources

Evidence here comes from direct repository inspection of the current source
tree, especially:

- `AGENTS.md` and `CONTRIBUTING.md`, which define project constraints and
  verification expectations.
- `docs/_reference/how-it-connects.md`, `docs/_reference/queue.md`, and
  `docs/_reference/what-spotify-allows.md`, which define Spotify, queue,
  auth, playback, and capability boundaries.
- `Cargo.toml`, which documents dependency choices and fork pins.
- `src/spotifast.rs`, `src/entrypoint.rs`, `src/app.rs`, `src/model.rs`,
  `src/backend.rs`, `src/player.rs`, `src/vis.rs`, `src/sink.rs`,
  `src/milkdrop*`, `src/winamp.rs`, `src/ui/*`, `src/credentials.rs`,
  `src/paths.rs`, `src/images.rs`, `src/liked.rs`, and `src/lyrics.rs`.

Line references are intentionally concrete so future changes can check whether
the invariant still holds.

## Product Boundaries to Preserve

The current product is a native Rust Spotify client. The repository policy says
to keep it native and small, avoid browser engines, telemetry, hosted backend
services, alternate Spotify audio sources, Spotify DRM circumvention, and
unimplemented or unsupported playback claims.

Specific current boundaries:

- Spotify catalogue playback comes from librespot. Lossless, DRM bypass,
  local Spotify file playback, Smart Shuffle, Jam, Blend, Canvas, video
  podcasts, friend activity, play counts, Cast discovery/startup, offline
  downloads, and free-account playback are explicitly unavailable through the
  supported surfaces.
- MilkDrop and Winamp are first-class existing functionality and are not
  optional future ideas.
- The interface is optimistic. User actions update visible state immediately,
  and stale Spotify answers must not roll back those visible changes.
- Every visualizer, including spectrum, oscilloscope, Winamp visualizers, and
  MilkDrop, receives post-equalizer and pre-volume audio. Zero volume must
  still animate visualizers.
- Network and playback work must not block the UI thread.
- Durable Spotify grants must not be copied into normal JSON state. Protected
  platform stores are used for grants and proxy secrets.

## Entry Points and Runtime Flow

The binary entry point is intentionally small:

- `src/spotifast.rs:7-8` calls `entrypoint::run()`.
- `src/entrypoint.rs:6-84` defines command-line flags, including demo/screenshot
  flags behind the `demo` feature.
- `src/entrypoint.rs:86-140` defines remote-control subcommands such as
  play/pause, next, seek, volume, shuffle, repeat, like, play URI, devices, and
  transfer.
- `src/entrypoint.rs:483` constructs `app::App`.
- `src/entrypoint.rs:504-528` optionally populates demo state and demo update
  behavior.
- `src/entrypoint.rs:1217` implements `eframe::App` for the shell.

Frame ownership is split between the native shell and app state:

- `src/entrypoint.rs:1238-1303` drains native menu and Windows thumbbar commands
  into `app.actions`.
- `src/entrypoint.rs:1312-1314` calls `app.frame_ui(ui)`.
- `src/app.rs:9675-9694` runs background per-frame work, including backend event
  handling, MilkDrop sync, and action application.
- `src/app.rs:9830-9877` draws the main UI and applies queued actions after
  drawing.
- `src/app.rs:8199-8210` drains actions until no nested actions remain.

This means most UI files should push `model::Action` values and should not
directly mutate backend or playback state.

## High-Level Module Map

### Application State

- `src/app.rs` is the central state owner. `App` contains settings, backend
  handle, auth state, local/remote playback state, devices, queue state,
  library/home/search/page data, caches, Winamp/MilkDrop state, media controls,
  tray state, update state, and platform window state. Evidence:
  `src/app.rs:224-360`.
- `src/model.rs` owns UI data models, page identifiers, list state, row
  contexts, drag payloads, queue tabs, dialogs, and the `Action` enum. Evidence:
  `src/model.rs:1-80`, `src/model.rs:568-705`, `src/model.rs:805-860`,
  `src/model.rs:921-1191`.
- `src/settings.rs` owns persisted settings and session structures. It has load
  and save entry points at `src/settings.rs:568` and `src/settings.rs:586`, plus
  tests for compatibility and secret-safety.
- `src/paths.rs` owns file and directory layout. Evidence: `src/paths.rs:12-131`.

### UI

- `src/ui/mod.rs` is the main UI router. It handles keys and dropped skins,
  chooses login versus signed-in surfaces, draws player bar, sidebar, queue
  panel, lyrics panel, central page, device popup, dialogs, update popup,
  drag ghost, toasts, and window controls. Evidence: `src/ui/mod.rs:34-88`.
- Page and surface modules:
  - `src/ui/home.rs`
  - `src/ui/search.rs`
  - `src/ui/library.rs`
  - `src/ui/collection.rs`
  - `src/ui/artist.rs`
  - `src/ui/show.rs`
  - `src/ui/radio.rs`
  - `src/ui/queue.rs`
  - `src/ui/lyrics.rs`
  - `src/ui/devices.rs`
  - `src/ui/settings.rs`
  - `src/ui/sidebar.rs`
  - `src/ui/topbar.rs`
  - `src/ui/player_bar.rs`
  - `src/ui/dialogs.rs`
  - `src/ui/widgets.rs`
  - `src/ui/keys.rs`
  - `src/ui/winamp/*`
- `src/ui/queue.rs:15-35` draws the full queue page.
- `src/ui/queue.rs:37-136` draws the queue side panel.
- `src/ui/player_bar.rs:47` draws the main player bar.

### Backend and Spotify Web API

- `src/backend.rs` owns the async runtime and command/event bridge. `Backend` is
  defined at `src/backend.rs:876-903`; spawning builds a two-thread Tokio
  runtime at `src/backend.rs:905-930`.
- `src/backend.rs:108-318` defines `ApiRequest`.
- `src/backend.rs:338-542` defines `ApiResponse`.
- `src/backend.rs:564-730` defines backend commands.
- `src/backend.rs:749-855` defines backend events.
- `src/backend.rs:1038-1121` sends API requests into the backend command loop.
- `src/backend.rs:3261` dispatches requests.
- `src/backend.rs:3329-3396` maps requests to operation categories for routing.
- `src/backend.rs:3459-3868` converts `ApiRequest` values into Web API client
  calls and `ApiResponse` values.
- `src/backend.rs:3890-3975` lets selected playlist reads use the active
  librespot session and fall back to Web API on timeout or unsupported failure.

API surface modules:

- `src/api/client.rs` contains Web API endpoint methods, including playback
  state, queue, add-to-queue, playlist, library, catalog, and search calls.
- `src/api/gateway.rs` owns shared/personal/session routing state and tests.
- `src/api/models.rs` owns Spotify model structs and conversion helpers.

### Auth, Credentials, and Proxy

- `src/auth.rs` defines OAuth grants and scopes. Playback auth is separate from
  Web API auth.
- `src/credentials.rs:28-55` defines credential slots and stored grant kinds:
  shared Web API, personal Web API, playback, and proxy.
- `src/credentials.rs:112-188` defines credential-storage errors and native
  keyring store selection.
- `src/credentials.rs:371-448` covers legacy credential paths and migration.
- `src/credentials.rs:527-628` covers load, save, and delete behavior.
- `src/backend.rs:2034-2044` restores sessions and Spotify grants.
- `src/backend.rs:2446` deletes stored grants.
- `src/backend.rs:2491-2837` handles playback authorization and engine connect.
- `src/http.rs` owns proxy-aware HTTP client construction and tests.

Protected storage is platform-specific:

- Secret Service on Linux.
- Keychain on macOS.
- Credential Manager on Windows.

Legacy unencrypted files are still readable for migration and cleanup. That
compatibility is important for upstream and DaisySpoti upgrades.

### Playback Engine

- `src/player.rs:46-65` defines `EngineConfig`.
- `src/player.rs:104-190` defines playback state and `LocalState`.
- `src/player.rs:240-254` defines `LoadSpec`.
- `src/player.rs:256-262` defines playback resume modes.
- `src/player.rs:280-300` defines `PlayerCommand`.
- `src/player.rs:323-432` connects the librespot session, player, mixer, sink,
  event channel, and Spirc Connect controller.
- `src/player.rs:453-587` exposes interrupted/resume state and shutdown.
- `src/player.rs:589-632` maps `PlayerCommand` values to Spirc operations.
- `src/player.rs:662-668` decides which commands interrupt queued audio.
- `src/player.rs:670-760` chooses sink backend and wraps output with the audio
  tap.
- `src/player.rs:842-930` folds librespot player events into `LocalState`.

Playback capabilities include local Spotify Connect playback, queue append and
clear via patched librespot, transfer, shuffle, repeat, seek, volume,
gapless-capable local sink behavior, engine reconnect/resume, Spotify lyrics
via session, rootlist/folder reads, album EP metadata, and radio/autoplay
resolution.

### Audio, EQ, Limiter, Visualizers

- `src/eq.rs` owns equalizer, preamp, balance, and mono processing.
- `src/limiter.rs` owns final limiting after EQ/preamp.
- `src/sink.rs` owns the custom audio output device stream and buffering.
- `src/vis.rs` owns `AudioTap`, `Tapped`, FFT spectrum analysis,
  oscilloscope/waveform calculations, and player-bar visualizer helpers.
- `src/player.rs:714-756` states that volume is applied after the tap, so
  visualizers are independent of volume.
- `src/vis.rs:1-7` states that visualizers receive post-EQ and pre-volume audio,
  with stereo samples for MilkDrop and mono samples for spectrum/scope.
- `src/vis.rs:218-222` states that the tap sees post-EQ, pre-volume,
  pre-normalisation audio.

This path is highly sensitive. EQ, limiter, volume, normalization, and
visualization are deliberately interleaved.

### MilkDrop

- `src/milkdrop.rs:1-9` states MilkDrop is implemented through libprojectM,
  reading `.milk` presets, rendering OpenGL, and running as this binary with
  `--milkdrop-child` because winit permits one event loop per process.
- `src/milkdrop.rs:17-27` exports child, engine, host, overlay, and shared-memory
  modules.
- `src/milkdrop/host.rs` is the parent-process side, spawning and polling the
  child and attaching the `AudioTap` to shared memory.
- `src/milkdrop/child.rs` is the child process with its own window, OpenGL
  context, event loop, stdin commands, and stdout events.
- `src/milkdrop/engine.rs` owns projectM rendering.
- `src/milkdrop/shm.rs` owns the shared-memory audio ring.
- `src/app.rs:2896-2954` syncs MilkDrop window open/close, size, position,
  fullscreen, FPS, preset timing, song overlay metadata, and child events.
- `src/app.rs:2974-2990` maps MilkDrop child commands to app actions.
- `Cargo.toml:95-106` and `Cargo.toml:208-215` define the `milkdrop` feature
  and projectM/winit/glutin dependencies.

Side effects:

- The child process is the same executable with special flags.
- A shared-memory ring file lives under the temporary directory.
- Preset packs can be downloaded from projectM GitHub URLs into the config
  directory.

### Winamp

- `src/winamp.rs` owns Winamp window, skin, playlist/equalizer/window state, and
  display state. Drawing lives in `src/ui/winamp`.
- `src/winamp.rs:69` defines `WinampState`.
- `src/winamp.rs:95-96` stores the audio tap used by Winamp visualizers.
- `src/winamp.rs:110` stores MilkDrop preset list/download state.
- `src/winamp.rs:114-145` constructs Winamp state and scaling behavior.
- `src/ui/winamp/mod.rs` draws the Winamp main window, controls, visualizer,
  menus, volume/balance, shade mode, and transport actions.
- `src/ui/winamp/equalizer.rs` draws Winamp equalizer controls and pushes EQ,
  preamp, band, balance, and volume actions.
- `src/ui/winamp/playlist.rs` draws the Winamp-style playlist/queue window.
- `src/skin/*` parses Winamp skin configuration, fonts, layout, sprites, and
  zip files.

Winamp is tightly coupled to playback state, queue state, skin parsing,
visualizers, settings, and app action handling. It should be treated as an
owned product surface, not decorative code.

### Queue

The queue is intentionally not isolated in one file:

- `docs/_reference/queue.md` is the queue behavior contract.
- `src/ui/queue.rs` draws the queue page and side panel.
- `src/model.rs:194-210` defines queue tabs.
- `src/model.rs:814-836` defines row playback contexts, including
  `RowContext::Queue`.
- `src/model.rs:972-994` defines queue actions.
- `src/app.rs:325-338` stores queue, queue sequence, stale-retry, clear,
  shuffle-pending, and reorder-pending state.
- `src/app.rs:4207-4227` requests queue refreshes with sequence numbers.
- `src/app.rs:4234-4327` handles playing queue rows and local reorderability.
- `src/app.rs:4335-4383` clears only manual queued rows.
- `src/app.rs:4430-4460` optimistically pops the queue head on Next.
- `src/app.rs:4484-4515` starts stale queue detection.
- `src/app.rs:7434-7684` queues songs and albums optimistically and routes
  local versus remote queue writes.
- `src/app.rs:7686-7724` inserts optimistic queue rows and sends batched queue
  writes.
- `src/player.rs:604-632` sends local queue commands through patched librespot
  Spirc methods.
- `src/backend.rs:3492-3499` reads playback/queue state through Web API routing.
- `src/backend.rs:3845-3868` writes queue additions through Web API routing.

Queue invariants verified by code and tests:

- Manual rows appear under "Playing next" before context rows under "Next up".
- Add to queue inserts after prior manual rows and before context rows.
- Duplicate manual queue occurrences are preserved.
- Playing a queue row consumes it and rows above it.
- Next pops the queue head optimistically.
- Clear queue removes manual rows only and preserves context rows.
- Local queue reordering works only when the local player is active.
- Local reordering rewrites the live local queue by clear and re-add.
- Stale Spotify queue answers are bounded, retried, and ignored while they
  conflict with local optimistic state.

Important tests live at:

- `src/app.rs:12483-14447`, covering next, skip, queue row play, clear, album
  queueing, duplicates, stale answers, shuffle, local reorder, and bounded
  fallback.
- `src/api/client.rs:1220`, covering queue batch ordering, duplicates, and
  failure stopping.

### Library, Pages, Search, and Collection Loading

Current library/page behavior is stateful and cache-aware:

- `src/model.rs:568-578` defines library shelf state.
- `src/model.rs:580-602` defines Home state, including podcasts.
- `src/model.rs:643-657` defines search state and split search pending flags.
- `src/model.rs:660-703` defines playlist page state, including generation,
  cache state, optimistic snapshot, pending writes, and snapshot rechecks.
- `src/ui/collection.rs` owns collection page tables, finite scrolling,
  row selection, playlist edits, table caches, and visible row actions.
- `src/app.rs:6860-7091` handles playlist cache receipt and checkpointing.
- `src/backend.rs:4020-4450` owns playlist cache formats, manifest/data files,
  locking, incremental append, and atomic publication.
- `src/liked.rs` owns Liked Songs cache state, optimistic save/unsave changes,
  checkpointing, read/write, and validity checks.

Generations and optimistic snapshots are essential. Later page redesigns must
not discard the stale-response and pending-write protections.

### Caching and Persistence

Paths:

- Settings: `src/paths.rs:45`
- Session: `src/paths.rs:60`
- History: `src/paths.rs:66`
- Legacy credentials dir: `src/paths.rs:92`
- Proxy legacy secret file: `src/paths.rs:97`
- Audio cache: `src/paths.rs:105`
- Art cache: `src/paths.rs:109`
- Lyrics cache: `src/paths.rs:113`
- Playlist cache: `src/paths.rs:117`
- Account playlist cache: `src/paths.rs:121`
- Liked Songs cache: `src/paths.rs:125`

Cache owners:

- `src/images.rs` owns artwork memory and disk cache. It writes via `.part`
  then rename at `src/images.rs:273-278`.
- `src/lyrics.rs` owns LRCLIB and Spotify lyrics cache, including "none"
  results.
- `src/liked.rs` owns Liked Songs cache and account validation.
- `src/backend.rs:4020-4450` owns playlist cache file formats.
- `src/history.rs` owns local play history.
- librespot owns audio cache data through the cache opened by
  `EngineConfig::open_cache` at `src/player.rs:74-83`, but credentials are kept
  in memory via `Cache::with_memory_credentials`.

Persistence and cache code has backward-compatibility requirements. Avoid broad
file format churn without staged migration.

### Platform Integration

Observed platform surfaces:

- Tray: fastframe-tray, app tray state in `src/app.rs`.
- Media controls: fastframe-now-playing, media sync in `src/app.rs`, Windows
  thumbbar in `src/thumbbar.rs` and `src/thumbbar/win.rs`.
- Single instance and remote control: `src/single_instance.rs`,
  `src/entrypoint.rs`, `App` control queues.
- macOS: `src/mac_links.rs`, `src/mac_menu.rs`, `src/mac_notch.rs`,
  `src/mac_touchbar_crash_guard.rs`.
- Windows: `src/thumbbar/win.rs`, Windows native keyring dependency, Windows
  window/taskbar behavior.
- Linux: Secret Service credential store, zbus appearance integration, X11
  taskbar hiding, MPRIS through fastframe-now-playing.
- Local receivers: `src/zeroconf.rs` handles `_spotify-connect._tcp`
  receivers and encrypted credential handoff.
- File opening and folders: `src/opener.rs`; folder-opening calls in app
  settings/actions.

Target-specific modules and `cfg` blocks must remain isolated so changes for
one platform keep other targets compiling.

## Current Feature Inventory

Application shell and operation:

- Native egui/eframe desktop app.
- Demo mode and screenshot automation under the `demo` feature.
- Single-instance command forwarding.
- CLI remote-control commands.
- Custom titlebar support.
- Tray behavior and hide/show/quit flow.
- Desktop media controls.
- Windows taskbar thumbnail controls.
- macOS menus, links, notch, and touchbar crash guard.
- Light/dark/system/custom themes.
- Localization through compiled PO catalogs.
- Update check, download, staging, install, and recovery behavior through
  fastframe-update and local update modules.

Spotify auth and account:

- Shared Web API app.
- Optional personal Web API app.
- Separate local playback auth.
- Account verification across grants.
- Protected native credential storage.
- Legacy credential migration and cleanup.
- Sign-in/sign-out flows.
- Premium detection and user-visible Premium notice.

Spotify browsing and library:

- Home shelves: recently played, top artists, top tracks, recommendations,
  Discover-style playlist searches, podcasts shelf.
- Search for songs, artists, albums, playlists, podcasts, episodes, with split
  personal/shared routing when applicable.
- Library shelves: playlists, albums, artists, podcasts, episodes, Liked Songs.
- Playlist folders/order read through librespot rootlist.
- Playlist permissions from owned/collaborative/rootlist invitation data.
- Playlist open/read, finite scrolling, distant page reads, cache adoption.
- Playlist create, update details, follow/unfollow, add/remove/reorder items.
- Playlist cover upload with native file picker and image processing.
- Album pages and track pagination.
- Artist pages, top tracks, releases, related artists.
- Show/podcast pages and episode resume positions.
- Radio pages resolved through librespot session.
- Liked Songs optimistic save/unsave and cache.
- Local play history combined with Spotify recents.

Playback and queue:

- Local Spotify Connect playback through librespot.
- Remote Spotify Connect device control through Web API.
- Transfer to local and remote devices.
- Play context, play URIs, play row, play episode from resume point.
- Shuffle, repeat, seek, previous, next, volume, mute.
- Pending play/optimistic current track handling.
- Local playback reconnect/resume behavior.
- Queue page and side panel.
- Queue save as playlist.
- Add track/episode to queue.
- Add album/single/EP to queue after resolving tracks.
- Local manual queue clear.
- Local manual queue reorder and drag insert.
- Queue stale-response rejection and bounded retries.

Audio and visuals:

- Custom audio sink with output buffering.
- Equalizer, preamp, balance, mono.
- Limiter after EQ/preamp.
- Post-EQ, pre-volume audio tap.
- Player bar spectrum/waveform visualizers.
- Winamp spectrum/oscilloscope visualizers.
- MilkDrop/projectM visualizer in child process.
- MilkDrop preset download/listing.

Winamp:

- Winamp mini-player window.
- Built-in and installed Winamp skins.
- Random skin option.
- Winamp playlist window.
- Winamp equalizer window.
- Shade modes.
- On-top/taskbar settings.
- Winamp-styled transport controls, volume, balance, repeat, shuffle, playlist
  menus, queue saving, and visualizer selection.

Network, proxy, and integrations:

- Proxy modes: Off, System, HTTP, SOCKS5 for app HTTP traffic.
- Limited librespot HTTP proxy support.
- Artwork download/cache.
- Lyrics from Spotify session first and LRCLIB fallback.
- GitHub update checks/downloads.
- MilkDrop preset downloads.
- Local receiver discovery and credential handoff over zeroconf.

## Important Dependency and Fork Inventory

The dependency graph is unusually well annotated in `Cargo.toml`.

Core runtime and UI:

- Rust package is `spotifast`, version `0.12.0`, edition `2024`, license MIT.
- `eframe`, `egui`, and `egui_extras` provide native immediate-mode UI.
- fastframe crates provide text, fonts, icons, theme, emoji, i18n, log, tray,
  shell, macOS helpers, update, audio, scroll, single instance, and now-playing.

Spotify and playback:

- `librespot-core`, `librespot-playback`, `librespot-connect`,
  `librespot-metadata`, and `librespot-protocol` are version `0.8` crates, with
  all actual crates patched to `https://github.com/crmne/librespot` rev
  `23fc42cff37848e51f0d8eaefad1a93941b71e59`.
- The comment at `Cargo.toml:276-293` says the fork carries queue controls,
  normalisation-factor reporting for visualizers, audio-key rejection events,
  bounded socket setup with DNS fallback, in-memory credential cache, playback
  recovery, Windows ARM signature, and inactive-device volume behavior.

Graphics and windowing:

- All egui crates are patched to `https://github.com/crmne/egui` rev
  `ba6790fe7cf46e58e8d27ce1524cbfdee745e938`.
- `winit` is patched to `https://github.com/crmne/winit` rev
  `ed7caa9023f10b397f5b6ec8284a840cbd8a6f65`.
- Project guidance says egui and winit fork revisions must move together with
  related apps and no independent Wayland vsync decision should be added.

MilkDrop:

- `projectm-sys` is optional under feature `milkdrop`, patched to
  `https://github.com/dennisgr7/projectm-rs` rev
  `1ef6df1c20247a3a5800c625e46262330f93bbd6`.
- `winit`, `glutin`, and `glutin-winit` are optional for the MilkDrop child
  process.

HTTP and proxy:

- `reqwest` uses rustls, json, gzip, http2, blocking, socks, and system-proxy.
- `hyper-proxy2` is patched to
  `https://github.com/crmne/hyper-proxy2` rev
  `efca4811371ddae81c06be168de54194938d70b1`.

Credential stores:

- `keyring-core` plus platform-native stores:
  - `zbus-secret-service-keyring-store` on Linux.
  - `apple-native-keyring-store` on macOS.
  - `windows-native-keyring-store` on Windows.

## Tests and Verification Surfaces

`rg` found 1101 test markers across `src` and `tests`.

High-signal test areas:

- Queue behavior: `src/app.rs:12483-14447`.
- Playlist cache, optimistic writes, and page generation behavior:
  `src/app.rs:17550+`, `src/backend.rs:4578+`.
- Backend auth, grant restore, sign-out races, playback auth, and session reads:
  `src/backend.rs:5360+`, `src/backend.rs:6033+`.
- API gateway/client routing and queue write behavior:
  `src/api/gateway.rs:340+`, `src/api/client.rs:1175+`.
- Credentials and native store round trip:
  `src/credentials.rs:740+`, including ignored native-store test at
  `src/credentials.rs:920`.
- Audio engine, sink, visualization, limiter, resampling:
  `src/player.rs:1129+`, `src/sink.rs:862+`, `src/vis.rs:661+`,
  `src/limiter.rs`, `src/resample.rs:114+`.
- MilkDrop and Winamp:
  `src/milkdrop.rs:396+`, `src/milkdrop/child.rs:998+`,
  `src/milkdrop/host.rs:336+`, `src/milkdrop/shm.rs:127+`,
  `src/winamp.rs:397+`, `src/ui/winamp/*`.
- UI behavior:
  `src/ui/collection.rs:2036+`, `src/ui/widgets.rs:3143+`,
  `src/ui/keys.rs:311+`, `src/ui/player_bar.rs:939+`.
- Integration-style tests:
  `tests/branding.rs`, `tests/localization.rs`, `tests/omarchy.rs`,
  `tests/startup_diagnostics.rs`, `tests/tray.rs`, `tests/launch_contract.rs`.

The full CONTRIBUTING check suite is larger than this architecture audit and
belongs in the overall Phase 0 verification report.

## DaisySpoti Ownership and Refactor Boundaries

These are evidence-based boundaries for future work. They are not approval to
start Phase 1 changes.

Likely Daisy-owned product surfaces:

- UI layout and product workflow in `src/ui/*`.
- App-level product state in `src/app.rs`, with caution because it is a central
  convergence point.
- Theme, custom themes, i18n presentation, and user settings in
  `src/theme.rs`, `src/settings.rs`, and related UI.
- Winamp and MilkDrop presentation and settings, while preserving behavior.
- Feature documentation under `docs/`.

Upstream-coupled or high-risk surfaces:

- `src/backend.rs`, `src/api/*`, `src/auth.rs`, `src/credentials.rs`, and
  `src/session_reads.rs` because they encode Spotify routing, grant handling,
  protected storage, rate limits, session/Web API fallbacks, and sign-out race
  protections.
- `src/player.rs`, `src/sink.rs`, `src/vis.rs`, `src/eq.rs`, and
  `src/limiter.rs` because they couple librespot, custom sink behavior, EQ,
  limiting, normalization, volume, and visualizer semantics.
- `src/app.rs` queue sections because queue behavior depends on optimistic UI,
  local engine state, Web API answers, sequence counters, retry budgets,
  manual queue state, and session persistence.
- `Cargo.toml` patches for egui, winit, librespot, projectm-sys, and
  hyper-proxy2. These are intentional and documented; upstream integration
  needs careful diffing rather than blind upgrades.

Refactor candidates that should be approached incrementally:

- Split `App` responsibilities only after tests cover the exact behavior being
  moved. The current monolith is a risk, but it also centralizes sequencing
  guarantees.
- Queue state could eventually become an explicit domain module, but current
  behavior spans UI, app state, backend, and player engine. Extracting it before
  preserving tests would be dangerous.
- Playlist cache and optimistic write logic could be documented further before
  being moved.
- Winamp/MilkDrop state is separable enough to document as owned subsystems,
  but not separable enough to rewrite during baseline work.
- Platform integrations should remain behind target-specific modules and `cfg`
  gates.

## Known Architecture Risks

- `src/app.rs` is very large and central. It owns UI state, side effects,
  backend event folding, queue rules, cache coordination, updates, platform
  surfaces, Winamp, MilkDrop, and settings persistence.
- Queue behavior depends on many subtle counters and pending-state structures.
  Losing a sequence/generation/stale check can produce user-visible rollback.
- Audio behavior depends on exact placement of EQ, limiter, tap, normalization,
  and volume.
- The patched librespot fork is not an incidental dependency. It supplies
  features current app behavior depends on.
- egui and winit forks are shared with other apps and have coordinated patch
  requirements.
- Protected credential storage has legacy migration behavior and sign-out race
  protections that future auth work must preserve.
- Playlist and Liked Songs caches are account-scoped and generation/snapshot
  aware. They should not be simplified into plain caches.
- MilkDrop uses a child process and shared memory. Process lifecycle and temp
  file cleanup are part of the feature, not implementation detail.

## Remaining Unknowns

This architecture baseline did not run builds, tests, performance measurement,
or a live app demo. It also does not establish Git divergence or upstream
baseline commit. Those belong to the broader Phase 0 report.

The main architecture unknown is product ownership, not current behavior:
DaisySpoti still needs a reviewed decision on which modules should remain close
to Spotifast upstream and which should become Daisy-owned long-term surfaces.
