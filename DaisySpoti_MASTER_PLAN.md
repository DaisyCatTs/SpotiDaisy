# DaisySpoti — Master Product, UX, Audio & Engineering Plan

**Status:** Canonical execution specification  
**Audience:** Daisy, Codex, coding agents, designers, reviewers  
**Product codename:** DaisySpoti  
**Baseline:** Fork of `crmne/spotifast`  
**Upstream version reviewed:** Spotifast v0.12.0 (released 2026-10-03)  
**Primary target:** Desktop, with Windows treated as a first-class audiophile platform and macOS/Linux retained as serious supported platforms  
**North star:** Build the best desktop music client for people who care about sound quality, deterministic playback, their library, speed, customization, and control.

---

# 0. HOW TO USE THIS FILE

This file is the product and implementation source of truth.

Codex/agents should update the checklist in the repository as work progresses.

Checkbox semantics:

- `[ ]` not started
- `[~]` in progress
- `[x]` completed **and validated**
- `[!]` blocked
- `[-]` rejected/superseded

A task is **not** complete because code exists. It becomes `[x]` only when:

1. implementation exists,
2. tests/acceptance criteria pass,
3. UX matches the agreed design,
4. no known regression violates a non-negotiable principle.

Agents must not make silent product decisions. If a decision materially changes product behavior, architecture, privacy, audio behavior, or UX, write an ADR under `docs/adr/`.

---

# 1. EXECUTIVE PRODUCT DEFINITION

> ## DaisySpoti
> **Your music. Your player. Your rules.**

DaisySpoti is **not** “Spotify with a different skin”.

It is a native desktop music player whose first streaming provider is Spotify and whose second major source is the user’s own local music.

It combines:

- Spotify catalogue/account/Connect convenience.
- Spotifast’s Rust-native performance and playback foundation.
- A serious local music library.
- Deterministic, inspectable playback behavior.
- Audiophile-grade output and signal-path transparency.
- Optional consumer DSP inspired by lessons learned from Sapphire Audio Processor, without importing broadcast loudness-war processing.
- Winamp and MilkDrop personality.
- A fully new desktop-first UI and design system.
- A fork strategy that lets DaisySpoti benefit from upstream fixes without ever surrendering Daisy-owned product work.

---

# 2. NON-NEGOTIABLE PRODUCT PRINCIPLES

- [x] **Control over cleverness.** “Smart” behavior must never silently replace explicit user intent.
- [x] **Truthful audio.** Never call lossy audio lossless, never call upsampling Hi-Res, never call a modified chain bit-perfect.
- [x] **Desktop-native interaction.** Keyboard, multi-select, copy/paste, drag/drop, right click, focus, accessibility and media-key behavior matter.
- [x] **Music-first by default.** Podcasts/video/audiobooks are allowed surfaces, never forced Home-page content.
- [x] **Local-first ownership.** Daisy-only metadata stays local unless the user explicitly enables a synchronization mechanism later.
- [x] **Large-library design.** 10k–100k-item collections are planned-for workloads.
- [x] **Audio thread wins.** Rendering, network, indexing and visualizers can never starve playback.
- [x] **Capability honesty.** Local Daisy playback and remote Spotify Connect playback must show different capability states when they differ.
- [x] **Beautiful default, deep power layer.** Normal users get an elegant player; power users can reveal serious controls.
- [x] **Upstream is a supplier, not the product owner.**
- [x] **No DRM circumvention.**
- [x] **No Chromium/browser-engine regression.**
- [x] **No forced telemetry.**
- [x] **No design-by-accumulation.** Every surface must use Daisy’s design system.

---

# 3. RESEARCH-DRIVEN PRODUCT POSITION

## 3.1 Spotify — preserve what is world-class

- [ ] Spotify account/library integration.
- [ ] Spotify catalogue.
- [ ] Spotify Connect.
- [ ] playlist interoperability.
- [ ] save/like/follow state where available.
- [ ] radio/recommendation contexts where available.
- [ ] cross-device playback transfer.

## 3.2 Spotify — explicitly outperform these areas

- [ ] deterministic true shuffle.
- [ ] transparent shuffle modes.
- [ ] proper Play Next / Play Later.
- [ ] large-queue editing.
- [ ] customizable Home.
- [ ] music-only Home preset.
- [ ] full-width Library workspace.
- [ ] serious release tracking.
- [ ] user-controlled recommendation intent.
- [ ] track/artist blocking.
- [ ] notes/ratings/tags.
- [ ] signal-path transparency.
- [ ] desktop keyboard power.
- [ ] optional panel layout rather than permanent horizontal-space theft.

## 3.3 Spotifast — preserve these strengths

- [ ] Rust/native architecture.
- [ ] egui/eframe unless measurement proves a different approach is necessary.
- [ ] librespot local playback.
- [ ] current Spotify Connect integration.
- [ ] protected credential storage.
- [ ] system media integration.
- [ ] fast startup.
- [ ] low idle overhead.
- [ ] existing queue correctness where it is already strong.
- [ ] Winamp `.wsz` support.
- [ ] MilkDrop/projectM.
- [ ] no browser engine.

## 3.4 Spotifast — replace/rebuild these product areas

- [ ] modern app shell.
- [ ] information architecture.
- [ ] Home.
- [ ] Library UI.
- [ ] Queue UI.
- [ ] settings IA.
- [ ] search UX.
- [ ] audio settings UX.
- [ ] loading/empty/error/rate-limit states.
- [ ] reusable UI component system.
- [ ] visual identity.

## 3.5 Spotifast — extend/fix

- [ ] rate-limit resilience.
- [ ] large-library memory behavior.
- [ ] bounded caches.
- [ ] local music.
- [ ] folders.
- [ ] command palette.
- [ ] advanced/user EQ presets.
- [ ] output-device hot switching.
- [ ] full keyboard editing.
- [ ] queue multi-select.
- [ ] ambient/fullscreen modes.
- [ ] Unicode robustness in Winamp.
- [ ] playback-context visibility.

---

# 4. COMPETITOR LESSONS

## Roon

Steal:
- [ ] one-click signal path.
- [ ] honest processing/quality states.
- [ ] DSP transparency.
- [ ] device/output visibility.
- [ ] rich library metadata philosophy.

Do not copy:
- [ ] mandatory server/Core mental model for basic listening.
- [ ] default complexity that intimidates normal users.

## Plexamp

Steal:
- [ ] gapless playback discipline.
- [ ] Sweet Fades philosophy.
- [ ] advanced pre-caching.
- [ ] home customization.
- [ ] smart playlists/stations.
- [ ] sample-rate matching.
- [ ] strong visualizers.
- [ ] sonic-similarity ideas.

Do not copy:
- [ ] server dependency as the center of the product.

## foobar2000

Steal:
- [ ] ReplayGain depth.
- [ ] advanced tagging.
- [ ] customizable shortcuts.
- [ ] extensible DSP.
- [ ] plugin architecture philosophy.
- [ ] AB testing mindset.
- [ ] no-telemetry culture.

Do not copy:
- [ ] configuration-heavy first-run experience.
- [ ] dated/default technical UI.

## MusicBee

Steal:
- [ ] serious local-library management.
- [ ] tagging and batch editing.
- [ ] skins/visualizers.
- [ ] advanced playlist/AutoDJ thinking.

Do not copy:
- [ ] legacy settings density.
- [ ] Windows-only assumptions in core architecture.

## Qobuz / TIDAL

Steal:
- [ ] visible quality information.
- [ ] audiophile-first playback modes.
- [ ] WASAPI-exclusive thinking.
- [ ] DAC/output awareness.
- [ ] music-first presentation.

Do not copy:
- [ ] weak desktop power workflows.
- [ ] fragile/buggy interaction patterns.
- [ ] poor queue/library ergonomics.

## Apple Music

Steal:
- [ ] proper library mental model.
- [ ] album-first presentation.
- [ ] local-library integration philosophy.
- [ ] immersive Now Playing.

Do not copy:
- [ ] Windows-client instability.
- [ ] ecosystem lock-in assumptions.

## Deezer

Steal:
- [ ] explicit recommendation control / Flow-Tuner philosophy.

Do not copy:
- [ ] opaque “smartness” without explanations.

---

# 5. HARD PROVIDER CONSTRAINTS

## 5.1 Spotify Lossless

DaisySpoti must be architecturally ready but must not bypass Spotify DRM.

Current practical state:

- Spotifast/librespot Spotify catalogue playback currently reaches lossy quality up to ~320 kbps.
- Spotify Lossless exists in some markets/accounts.
- The user’s Turkey-region account may currently expose Premium quality only up to the lossy “Very High” tier.
- Lossless availability is therefore a **provider/account/market capability**, not something DaisySpoti should assume merely from “Premium Family”.

Tasks:

- [x] Design audio path for 24-bit/lossless sources.
- [ ] Add provider capability model: `lossless_eligible`, `offline_eligible`, etc.
- [ ] Monitor librespot for lawful Lossless support.
- [ ] If lawful support arrives, integrate it as another source format.
- [ ] Never label 320 kbps Spotify as “Lossless”.
- [ ] Never bypass PlayPlay or other DRM.

## 5.2 Spotify offline downloads

- [x] No DRM circumvention.
- [ ] Build excellent **local offline music** instead.
- [ ] Cache metadata/artwork aggressively within lawful/provider limits.
- [ ] Clearly distinguish “metadata cached” from “Spotify audio available offline”.

## 5.3 Private Spotify features

Do not promise direct parity for:

- Jam
- Blend internals
- Spotify private pins
- private friend activity
- private play-count endpoints
- Smart Shuffle internals
- Canvas/video internals if unavailable

Where Daisy creates an equivalent, make it clearly Daisy-owned.

---

# 6. ARCHITECTURE TARGET

The exact repository layout may be adapted after auditing the fork; separation of concerns is mandatory.

```text
src/
  app/
    lifecycle/
    commands/
    state/

  providers/
    spotify/
      api/
      librespot/
      connect/
      capabilities/
    local/
      scan/
      metadata/
      matching/
    provider.rs

  playback/
    engine/
    context/
    queue/
    shuffle/
    transitions/
    recovery/
    prefetch/

  audio/
    graph/
    output/
      windows/
      macos/
      linux/
    dsp/
      normalize/
      replaygain/
      eq/
      convolution/
      crossfeed/
      bass/
      transient/
      stereo/
      dynamics/
      guard/
    meters/
    signal_path/

  library/
    db/
    index/
    identity/
    collections/
    smart_rules/
    history/
    ratings/
    tags/
    source_linking/

  discovery/
    profiles/
    lenses/
    exclusions/
    radios/

  visualizers/
    milkdrop/
    spectrum/
    waveform/
    spectrogram/
    phase/

  ui/
    tokens/
    primitives/
    components/
    shell/
    pages/
    panels/
    overlays/
    player_modes/
    accessibility/

  integrations/
    lastfm/
    listenbrainz/
    discord/

  platform/
    windows/
    macos/
    linux/
```

Architecture checklist:

- [ ] map current Spotifast dependency graph.
- [ ] identify upstream-sensitive files/modules.
- [ ] introduce provider capability interface.
- [ ] introduce logical-track vs physical-source distinction.
- [ ] decouple Daisy UI state from Spotify protocol state.
- [ ] decouple local metadata from provider metadata.
- [ ] separate audio realtime path from UI/network/database workers.
- [ ] define optional heavy-feature gates.
- [ ] ADR: provider abstraction.
- [ ] ADR: playback/source abstraction.
- [ ] ADR: local DB.
- [ ] ADR: audio graph.
- [ ] ADR: upstream strategy.
- [ ] ADR: plugin/extensibility boundary.

---

# 7. DAISY LIBRARY OVERLAY — CORE PRODUCT LAYER

Create a local database that overlays Daisy-owned metadata on top of provider tracks and local files.

## Identity

- [ ] stable `TrackIdentity`.
- [ ] provider aliases.
- [ ] artist identity.
- [ ] album identity.
- [ ] playlist identity.
- [ ] file identity.
- [ ] alternate-version relationship.
- [ ] source-match confidence.

## Daisy-owned metadata

- [ ] 1–5 star rating.
- [ ] favorite.
- [ ] tags.
- [ ] notes.
- [ ] color/label.
- [ ] blocked track.
- [ ] blocked artist.
- [ ] exclude from Pure/Fresh shuffle.
- [ ] exclude from Daisy Discovery.
- [ ] preferred source.
- [ ] local play count.
- [ ] skip count.
- [ ] date added.
- [ ] last played.
- [ ] listening time.

## Source Linking — major differentiator

Allow a logical Spotify track to be linked to a local higher-quality file.

Example:

```text
Logical track:
Chase & Status — Example Track

Spotify source:
Ogg Vorbis ~320 kbps

Local source:
24-bit / 96 kHz FLAC

Policy:
Prefer Local
```

Tasks:

- [ ] manual source linking.
- [ ] high-confidence automatic suggestions.
- [ ] never silently create low-confidence links.
- [ ] Auto / Prefer Local / Prefer Spotify policies.
- [ ] playback source badge.
- [ ] local fallback to Spotify if local drive/file unavailable.
- [ ] remote Connect automatically uses Spotify source.
- [ ] history stores logical track and physical source separately.
- [ ] playlist remains Spotify-compatible even when Daisy locally substitutes a linked file.

This feature lets Daisy preserve Spotify discovery/playlists while locally playing a better master when the user owns one.

---

# 8. LOCAL MUSIC — P0

Decode targets:

- [ ] FLAC
- [ ] ALAC
- [ ] WAV
- [ ] AIFF
- [ ] Opus
- [ ] Vorbis
- [ ] AAC/M4A
- [ ] MP3

Library behavior:

- [ ] watched folders.
- [ ] add folder/files.
- [ ] incremental background scan.
- [ ] filesystem watcher.
- [ ] embedded artwork.
- [ ] sidecar artwork.
- [ ] metadata read.
- [ ] ReplayGain read.
- [ ] duplicate detection.
- [ ] moved-file relinker.
- [ ] missing-file state.
- [ ] metadata editor.
- [ ] batch metadata editing.
- [ ] local playlists.
- [ ] mixed Daisy Collections.
- [ ] local full-text index.
- [ ] optional waveform cache.
- [ ] optional BPM/key/energy analysis.
- [ ] scan throttling.
- [ ] battery-aware scanning.

Acceptance:

- [ ] 100k-track library remains usable.
- [ ] startup loads DB/index instead of rescanning.
- [ ] missing/removable drive does not delete metadata.
- [ ] listing rows never requires loading entire audio files.
- [ ] scanning never blocks audio/UI.

---

# 9. SHUFFLE ENGINE — SIGNATURE FEATURE

## Pure Shuffle

Definition: a uniformly randomized permutation of **track occurrences**.

- [ ] unbiased permutation.
- [ ] duplicate occurrences remain duplicate occurrences.
- [ ] no repeat until current cycle ends.
- [ ] persistent seed.
- [ ] persistent cursor.
- [ ] persistent source revision.
- [ ] exact resume after restart.
- [ ] Reshuffle Remaining.
- [ ] Start New Cycle.
- [ ] Keep Current Track.
- [ ] View Upcoming Order.
- [ ] progress display.

Example:

> Pure Shuffle · 1,894 / 5,247 played · 3,353 tracks before a repeat

Tests:

- [ ] uniformity/statistical sanity.
- [ ] no-repeat invariant.
- [ ] duplicate occurrence invariant.
- [ ] restart persistence.
- [ ] source mutation behavior.
- [ ] 100k-track benchmark.

## Fresh Shuffle

User-configurable:

- [ ] artist spacing.
- [ ] album spacing.
- [ ] recent-play avoidance.
- [ ] skip-history penalty.
- [ ] optional full-cycle protection.
- [ ] transparent rule summary.

## Album Shuffle

- [ ] randomize album order.
- [ ] preserve tracks inside each album.
- [ ] optional singles/EP policy.

## Discovery Shuffle

- [ ] known/discovery ratio.
- [ ] recommendation tracks visibly marked.
- [ ] block/exclusion rules obeyed.
- [ ] never pretend recommendations were original playlist members.

## Shuffle Lab

- [ ] seed.
- [ ] active rules.
- [ ] excluded count.
- [ ] cycle status.
- [ ] preview next N.
- [ ] restart/reshuffle controls.
- [ ] diagnostics/export seed where meaningful.

---

# 10. QUEUE 2.0

Sections:

1. Now Playing
2. Play Next
3. Your Queue
4. Playing From
5. Autoplay / Daisy Discovery

Actions:

- [ ] Play Next.
- [ ] Play Later.
- [ ] Add to Queue.
- [ ] Replace Queue.
- [ ] Pin Next.
- [ ] move top/bottom.
- [ ] drag reorder.
- [ ] multi-select block drag.
- [ ] remove selected.
- [ ] clear manual queue.
- [ ] preserve context queue.
- [ ] undo/redo.
- [ ] save queue as playlist.
- [ ] save queue as Session Capsule.
- [ ] shuffle selected subsection.
- [ ] “Start Here” without destroying everything after it.
- [ ] search huge queue.

Desktop behavior:

- [ ] Ctrl/Cmd+A
- [ ] Ctrl/Cmd+C
- [ ] Ctrl/Cmd+X
- [ ] Ctrl/Cmd+V
- [ ] Shift range select
- [ ] Ctrl/Cmd toggle select
- [ ] keyboard reorder

Remote capability UX:

- [ ] “Local Full Control” state.
- [ ] “Remote Compatibility” state.
- [ ] no fake queue operations that the provider cannot guarantee.

---

# 11. SESSION CAPSULES — BOLD DIFFERENTIATOR

A Session Capsule stores a listening workspace:

- source/context
- current logical track
- physical source
- position
- queue
- shuffle mode
- seed/cursor
- repeat
- output profile
- DSP profile
- discovery lens
- optional player mode

Features:

- [ ] Save Session.
- [ ] autosave recent sessions.
- [ ] crash recovery.
- [ ] duplicate session.
- [ ] pin session.
- [ ] rename session.
- [ ] restore gracefully if devices/files no longer exist.
- [ ] local-only by default.

Examples:

- “DNB coding”
- “Late-night reggae”
- “Hardstyle gym”
- “Reference listening”

---

# 12. SMART QUEUE RULES — POST-V1 POWER LAYER

Example rules:

```text
artist_repeat_distance >= 3
blocked = false
last_played > 7d
rating >= 4 preferred
after 60m add 20% discovery
BPM within ±12 when Workout lens is active
```

- [ ] rule model.
- [ ] visual rule builder.
- [ ] deterministic evaluator.
- [ ] conflict priority.
- [ ] preview before activation.
- [ ] “Why is this next?” explanation.
- [ ] easy reset to normal queue.

---

# 13. AUDIO ENGINE

## Core requirements

- [ ] Reference mode is default.
- [ ] all DSP opt-in.
- [ ] gain-changing stages account for headroom.
- [ ] no rendering/network/database on audio callback.
- [ ] no blocking locks in realtime callback.
- [ ] smooth parameter interpolation.
- [ ] robust device reconnect.
- [ ] explicit resampling only when necessary.
- [ ] signal path reports every known transformation.

Target flow:

```text
Provider Source
  ↓
Decoder
  ↓
Normalization / ReplayGain
  ↓
Headroom
  ↓
PEQ / AutoEQ
  ↓
Daisy Sound (optional)
  ↓
Crossfeed / Convolution (optional)
  ↓
True-Peak Guard (if required)
  ↓
Format conversion
  ↓
Output
```

---

# 14. OUTPUT ENGINE

## Windows

- [ ] WASAPI Shared.
- [ ] WASAPI Exclusive.
- [ ] event-driven output.
- [ ] hotplug/default-device notification.
- [ ] exact format probing.
- [ ] optional future ASIO adapter — do not block v1.

## macOS

- [ ] CoreAudio.
- [ ] route changes.
- [ ] sample-rate control where appropriate.

## Linux

- [ ] PipeWire first.
- [ ] PulseAudio compatibility.
- [ ] evaluate JACK as optional advanced backend.

## Sample rate modes

- [ ] System.
- [ ] Fixed.
- [ ] Match Source.
- [ ] Match Family (44.1/88.2/176.4 vs 48/96/192) if repeated switching is undesirable.
- [ ] actual output rate visible.
- [ ] switching debounce.

---

# 15. BIT-PERFECT MODE

Requirements:

- [ ] DSP bypass.
- [ ] normalization off.
- [ ] software volume unity.
- [ ] direct/exclusive output where platform allows.
- [ ] no sample-rate conversion.
- [ ] compatible source/output format.
- [ ] status explains every failed condition.

Never show “Bit-Perfect” simply because the source file is FLAC.

---

# 16. SIGNAL PATH / AUDIO INSPECTOR — SIGNATURE UI

One click from the player’s quality badge.

Example:

```text
SOURCE
Spotify
Ogg Vorbis · 320 kbps · 44.1 kHz

NORMALIZATION
Album · -3.4 dB

EQ
HD 490 PRO AutoEQ
Headroom -5.2 dB

DAISY SOUND
DNB · Punch 18% · Bass 22%

OUTPUT
MOTU M4
WASAPI Exclusive
24-bit · 44.1 kHz

RESAMPLING
None

QUALITY STATE
Enhanced
```

Local:

```text
SOURCE
Local FLAC
24-bit · 96 kHz · 2,841 kbps

PROCESSING
Bypassed

OUTPUT
MOTU M4
24-bit · 96 kHz

QUALITY STATE
Bit-perfect
```

Tasks:

- [ ] source node.
- [ ] normalization node.
- [ ] DSP nodes.
- [ ] resampler node.
- [ ] converter node.
- [ ] device node.
- [ ] technical detail expansion.
- [ ] copy diagnostics.
- [ ] quality-state algorithm.
- [ ] no misleading badges.

---

# 17. NORMALIZATION / REPLAYGAIN

Spotify:

- [ ] preserve provider normalization behavior correctly.
- [ ] Off / Track / Album where available.

Local:

- [ ] ReplayGain Track.
- [ ] ReplayGain Album.
- [ ] optional EBU-R128 analysis.
- [ ] true-peak-aware headroom.
- [ ] background analysis.
- [ ] never rewrite audio/metadata unless explicitly requested.

Unified UX:

- [ ] clearly distinguish Spotify normalization from ReplayGain.
- [ ] display gain.
- [ ] preserve album dynamics mode.

---

# 18. EQ / AUTOEQ / CONVOLUTION

## Basic EQ

- [ ] 10-band.
- [ ] preamp.
- [ ] presets.
- [ ] save/duplicate/delete user preset.
- [ ] per-output profile assignment.

## Parametric EQ

Filter types:

- [ ] Peak
- [ ] Low Shelf
- [ ] High Shelf
- [ ] Low Pass
- [ ] High Pass
- [ ] Notch optional
- [ ] Band Pass optional

Controls:

- [ ] Frequency.
- [ ] Gain.
- [ ] Q.
- [ ] Enable/bypass band.
- [ ] reorder.
- [ ] response graph.
- [ ] headroom prediction.

## AutoEQ

- [ ] import common AutoEQ text profile formats.
- [ ] headphone profile manager.
- [ ] auto assignment by output/profile.
- [ ] editable correction layer.
- [ ] source/profile metadata.

## Convolution — P2

- [ ] FIR impulse-response loader.
- [ ] room/headphone correction.
- [ ] latency reporting.
- [ ] safe realtime implementation.
- [ ] bypass comparison.

---

# 19. DAISY SOUND — SAP-INSPIRED, NOT SAP

Purpose: optional consumer processing for enjoyable listening. Borrow DSP discipline from Sapphire/SAP without using broadcast AGC/clipping/loudness-maximization as an everyday player chain.

Profiles:

- [ ] Reference.
- [ ] Headphones.
- [ ] Punch & Sub.
- [ ] DNB.
- [ ] Hardstyle.
- [ ] Reggae.
- [ ] R&B.
- [ ] Late Night.
- [ ] Custom.

## Bass Foundation

- [ ] Sub Weight.
- [ ] Bass Body.
- [ ] crossover strategy.
- [ ] mono protection.
- [ ] headroom safety.
- [ ] prevent detached kick/sub behavior.

## Punch

- [ ] subtle transient shaping.
- [ ] preserve snares/claps.
- [ ] no phasey/splashy artifacts.
- [ ] safe timing ranges.

## Width

- [ ] frequency-dependent width.
- [ ] bass mono protection.
- [ ] correlation guard.
- [ ] transient image protection.
- [ ] mono compatibility indicator.

## Glue

- [ ] subtle low-depth dynamics.
- [ ] loudness-compensated audition.
- [ ] not broadcast loudness processing.

## True-Peak Guard

- [ ] transparent ceiling.
- [ ] intersample awareness.
- [ ] only active when processing requires protection.

UX:

- [ ] master Amount control.
- [ ] advanced sub-controls hidden by default.
- [ ] instant Reference bypass.
- [ ] loudness-matched A/B.
- [ ] no automatic genre processing unless the user creates an explicit rule.

---

# 20. LOUDNESS-MATCHED A/B / ABX

Because louder often sounds “better” even when processing is worse:

- [ ] A/B snapshot.
- [ ] short-term loudness compensation.
- [ ] instant switch.
- [ ] blind A/B.
- [ ] ABX tool later.
- [ ] clearly label compensation as audition-only.

---

# 21. TRANSITIONS

## P0

- [ ] sample-accurate gapless where format/context permits.

## P1

- [ ] Crossfade.
- [ ] per-profile duration.
- [ ] curve selection.
- [ ] exclude gapless albums.
- [ ] disable automatically where strict bit-perfect behavior conflicts.

## P2 — Daisy Transitions

Intelligent but optional.

Analysis:

- [ ] intro/outro energy.
- [ ] BPM.
- [ ] beat confidence.
- [ ] silence.
- [ ] spectral density.
- [ ] optional key.

Behavior:

- [ ] choose a musically sensible transition point.
- [ ] aggressiveness control.
- [ ] album-aware behavior.
- [ ] no modification when disabled.
- [ ] explain skipped transitions.
- [ ] cache analysis.

---

# 22. FULL LIBRARY WORKSPACE

Sections:

- [ ] Overview.
- [ ] Tracks.
- [ ] Albums.
- [ ] Artists.
- [ ] Playlists.
- [ ] Folders.
- [ ] Local Music.
- [ ] Podcasts.
- [ ] Smart Collections.
- [ ] History.

Views:

- [ ] Compact Table.
- [ ] Default Table.
- [ ] Comfortable Table.
- [ ] Grid.
- [ ] Album-focused.
- [ ] Artist-focused.

Columns:

- [ ] Title.
- [ ] Artist.
- [ ] Album.
- [ ] Release.
- [ ] Added.
- [ ] Last Played.
- [ ] Daisy Plays.
- [ ] Duration.
- [ ] Rating.
- [ ] Quality.
- [ ] Source.
- [ ] Tags.

Desktop features:

- [ ] resize/reorder columns.
- [ ] hide/show columns.
- [ ] remember layout.
- [ ] Shift/Ctrl selection.
- [ ] keyboard row navigation.
- [ ] drag/drop.
- [ ] batch edit.
- [ ] context menus.
- [ ] virtualization.

---

# 23. SMART COLLECTIONS

Rule examples:

```text
tag:DNB AND rating>=4 AND last_played>30d
source:local AND codec:flac AND bit_depth>=24
artist:"Pendulum" OR artist:"Chase & Status"
```

Predicates:

- [ ] provider/source.
- [ ] artist.
- [ ] album.
- [ ] tag/genre.
- [ ] year.
- [ ] added date.
- [ ] last played.
- [ ] plays.
- [ ] skips.
- [ ] rating.
- [ ] quality.
- [ ] duration.
- [ ] BPM/key/energy.
- [ ] explicit.
- [ ] blocked/excluded.
- [ ] saved/liked.

Behavior:

- [ ] live updates.
- [ ] custom sort.
- [ ] result limit.
- [ ] random sample.
- [ ] pin to Home/sidebar.
- [ ] use as shuffle source.

---

# 24. HOME BUILDER

Presets:

- [ ] Music Only.
- [ ] Minimal.
- [ ] Discovery.
- [ ] Library.
- [ ] Custom.

Modules:

- [ ] Continue Listening.
- [ ] Recently Played.
- [ ] Pinned.
- [ ] Playlists.
- [ ] Favorite Albums.
- [ ] New Releases.
- [ ] Followed Artists.
- [ ] Liked Songs.
- [ ] Local Music.
- [ ] Smart Collections.
- [ ] Session Capsules.
- [ ] Radios/Discovery.
- [ ] Podcasts.
- [ ] Shows.
- [ ] History summary.

Customization:

- [ ] hide/show.
- [ ] reorder.
- [ ] resize where meaningful.
- [ ] per-module settings.
- [ ] reset preset.
- [ ] no forced category.

---

# 25. RELEASES

Sources:

- [ ] followed artists.
- [ ] artists from saved albums.
- [ ] artists from liked tracks.
- [ ] manually watched artists.

Time:

- [ ] Today.
- [ ] This Week.
- [ ] This Month.
- [ ] custom.

Types:

- [ ] Albums.
- [ ] EPs.
- [ ] Singles.
- [ ] Compilations.

Filters:

- [ ] unheard.
- [ ] saved.
- [ ] explicit.
- [ ] source group.
- [ ] tag/genre where inferable.

Actions:

- [ ] play.
- [ ] queue.
- [ ] save.
- [ ] watch artist.
- [ ] hide release.
- [ ] local OS notification if enabled.

---

# 26. DISCOVERY CONTROL

Actions:

- [ ] More Like This.
- [ ] Less Like This.
- [ ] Never This Track.
- [ ] Never This Artist.
- [ ] Snooze Artist.
- [ ] Do Not Learn From This Play.
- [ ] Exclude Playlist/Session From Daisy Taste.
- [ ] temporary taste session.

## Listening Lenses — innovation

Examples:

- DNB
- Hardstyle
- Reggae
- R&B
- Focus
- New Music
- Deep Cuts
- Familiar Only

Lens behavior:

- changes Daisy Discovery weighting.
- may influence Smart Queue rules.
- does not silently alter permanent taste.

- [ ] create/edit Lens.
- [ ] temporary Lens.
- [ ] saved Lens.
- [ ] active Lens indicator.
- [ ] reset instantly.
- [ ] explain effect.

---

# 27. SEARCH

Unified local/provider search.

Scopes:

- [ ] All.
- [ ] Spotify.
- [ ] Local.
- [ ] Library.
- [ ] Playlists.
- [ ] Artists.
- [ ] Albums.
- [ ] Lyrics where lawful.

Advanced syntax:

```text
artist:"Chase & Status"
year:2025
liked:true
local:true
quality:flac
rating:>=4
tag:dnb
played:<30d
```

- [ ] parser.
- [ ] syntax help.
- [ ] recent searches.
- [ ] instant local results.
- [ ] remote progressive results.
- [ ] cache-aware behavior.
- [ ] typo tolerance where practical.

---

# 28. COMMAND PALETTE

Shortcut: Ctrl/Cmd+K

Commands:

- [ ] page navigation.
- [ ] playback.
- [ ] player mode.
- [ ] queue actions.
- [ ] device/output.
- [ ] DSP.
- [ ] visualizer.
- [ ] create playlist/collection.
- [ ] panel toggles.
- [ ] theme/density.
- [ ] settings.
- [ ] diagnostics in developer mode.

Quality:

- [ ] fuzzy match.
- [ ] keyboard only.
- [ ] command aliases.
- [ ] recent/frequent.
- [ ] destructive actions confirmed.

---

# 29. HISTORY & LISTENING STATS

Local persistence:

- [ ] timestamp.
- [ ] logical track.
- [ ] provider/source.
- [ ] physical source.
- [ ] context.
- [ ] time listened.
- [ ] completed/skipped.
- [ ] active profile.
- [ ] output optional.
- [ ] private-session flag.

Views:

- [ ] Today.
- [ ] Yesterday.
- [ ] Week.
- [ ] Month.
- [ ] searchable timeline.
- [ ] artist/album summaries.
- [ ] minutes.
- [ ] source distribution.
- [ ] quality distribution.

Privacy:

- [ ] disable history.
- [ ] delete date range.
- [ ] clear all.
- [ ] private-session behavior.

---

# 30. PLAYER MODES

## Modern

- [ ] full Daisy shell.
- [ ] persistent player bar.
- [ ] optional inspector.

## Mini

- [ ] resizable modern mini player.
- [ ] always-on-top.
- [ ] multiple density layouts.

## Winamp

- [ ] retain `.wsz`.
- [ ] retain playlist.
- [ ] retain EQ.
- [ ] retain classic displays.
- [ ] Unicode fallback.
- [ ] Daisy Extensions toggle.
- [ ] optional Like.
- [ ] optional device/quality info.
- [ ] strict classic mode.

## MilkDrop

- [ ] preserve projectM.
- [ ] >10k preset support.
- [ ] preset browser.
- [ ] search.
- [ ] favorites.
- [ ] blacklist.
- [ ] collections.
- [ ] next/previous/random.
- [ ] lock preset.
- [ ] interval.
- [ ] fullscreen.
- [ ] second monitor.
- [ ] FPS cap.
- [ ] Eco/Balanced/Unlimited.
- [ ] analysis source: Pre-DSP / Post-DSP / Output.

## Ambient

- [ ] large artwork.
- [ ] minimal track metadata.
- [ ] OLED.
- [ ] artwork-derived backdrop.
- [ ] optional lyrics.
- [ ] optional MilkDrop behind artwork.
- [ ] full screen.
- [ ] low CPU when static.

---

# 31. ADDITIONAL VISUALIZERS

- [ ] Spectrum.
- [ ] Waveform.
- [ ] Phase scope.
- [ ] Goniometer.
- [ ] Spectrogram.
- [ ] VU.
- [ ] Loudness.
- [ ] Peak/true-peak.
- [ ] None.

Requirements:

- [ ] FPS cap.
- [ ] battery-aware.
- [ ] audio-thread isolation.
- [ ] reduced-motion handling.
- [ ] theme integration.

---

# 32. LYRICS

- [ ] synced lyrics where available.
- [ ] static fallback where lawful.
- [ ] right-panel mode.
- [ ] center-workspace mode.
- [ ] fullscreen/karaoke.
- [ ] click line to seek.
- [ ] typography controls.
- [ ] focus mode.
- [ ] artwork backgrounds.
- [ ] accessibility.
- [ ] later optional translation/romanization via a lawful configurable provider.

---

# 33. PLAYLISTS & FOLDERS

Spotify:

- [ ] display rootlist/folder structure when readable.
- [ ] collapsible groups.
- [ ] persist collapse state.
- [ ] clearly identify unsupported server-side folder edits.

Daisy:

- [ ] editable Daisy folders/collections.
- [ ] mixed local/Spotify references.
- [ ] nested organization.
- [ ] drag/drop.
- [ ] batch move.
- [ ] local ordering.
- [ ] smart collections pinnable like playlists.

---

# 34. UI INFORMATION ARCHITECTURE

```text
┌─────────────────────────────────────────────────────────────────┐
│ Back Forward       Search / Command                      Profile │
├──────────────┬────────────────────────────────┬─────────────────┤
│ Home         │                                │ Inspector       │
│ Search       │                                │                 │
│ Library      │          WORKSPACE             │ Queue           │
│ Releases     │                                │ Lyrics          │
│ History      │                                │ Track Info      │
│              │                                │ Signal Path     │
│ Pins         │                                │ Device          │
│ Folders      │                                │                 │
│ Sessions     │                                │                 │
├──────────────┴────────────────────────────────┴─────────────────┤
│ Artwork · Track/Artist       Playback / Timeline         Output │
└─────────────────────────────────────────────────────────────────┘
```

Rules:

- [ ] sidebar is navigation, not the entire library.
- [ ] workspace gets priority.
- [ ] inspector optional.
- [ ] inspector can close completely.
- [ ] Queue/Lyrics/Signal Path can open as center pages.
- [ ] collapsible icon rail.
- [ ] user-resizable panels.
- [ ] persisted layout.
- [ ] excellent single-monitor use.
- [ ] 1440p high-refresh considered primary.
- [ ] ultrawide does not stretch content meaninglessly.
- [ ] minimum-window behavior designed, not accidental.

---

# 35. VISUAL DIRECTION

Use:

- [ ] neutral graphite foundation.
- [ ] artwork-derived optional accents.
- [ ] crisp density.
- [ ] restrained depth.
- [ ] excellent typography.
- [ ] small purposeful motion.
- [ ] excellent focus/selection.
- [ ] real tables.
- [ ] modern desktop menus.
- [ ] Mica/vibrancy only where appropriate.

Avoid:

- [x] huge SaaS pill cards.
- [x] glass everywhere.
- [x] neon default.
- [x] random gradients.
- [x] mobile UI stretched onto desktop.
- [x] giant empty spaces that reduce information density.
- [x] hidden hover-only critical controls.
- [x] dependency on Spotify green.

Typography target:

- [ ] Geist if rendering/metrics validate well.
- [ ] Inter fallback.
- [ ] monospace for signal path/technical values.
- [ ] skin/pixel type in Winamp with Unicode fallback.

Theme modes:

- [ ] Dark.
- [ ] Light.
- [ ] OLED.
- [ ] System.
- [ ] Mica/Vibrancy.
- [ ] custom accent.
- [ ] advanced custom theme.

Density:

- [ ] Compact.
- [ ] Default.
- [ ] Comfortable.

---

# 36. DESIGN TOKENS

Finalize exact values through Figma validation.

Spacing:

- [ ] 4 px base.
- [ ] 8 px primary rhythm.
- [ ] named spacing variables.

Radius:

- [ ] small 6–8.
- [ ] default ~10.
- [ ] large 12–16.
- [ ] pills use full radius only when conceptually pill-shaped.

Motion:

- [ ] Fast ~100–140 ms.
- [ ] Standard ~160–220 ms.
- [ ] Large ~240–320 ms.
- [ ] reduced-motion mode.

Track rows:

- [ ] Compact ~36–40.
- [ ] Default ~44–48.
- [ ] Comfortable ~52–56.

Accessibility:

- [ ] WCAG contrast audit.
- [ ] clear keyboard focus.
- [ ] high-contrast mode.
- [ ] no color-only status.

---

# 37. FIGMA FILE STRUCTURE

Canonical Figma target:

**DaisySpoti — Product & UX System**

Required pages:

- [ ] `00 — Cover`
- [ ] `01 — Product Principles`
- [ ] `02 — Research`
- [ ] `03 — Competitor Audit`
- [ ] `04 — Information Architecture`
- [ ] `05 — User Flows`
- [ ] `10 — Foundations`
- [ ] `11 — Tokens`
- [ ] `12 — Typography`
- [ ] `13 — Iconography`
- [ ] `14 — Motion`
- [ ] `20 — Components`
- [ ] `21 — Navigation`
- [ ] `22 — Media`
- [ ] `23 — Tables`
- [ ] `24 — Inputs`
- [ ] `25 — Menus & Overlays`
- [ ] `26 — Player Controls`
- [ ] `27 — Queue`
- [ ] `28 — Audio Controls`
- [ ] `30 — App Shell`
- [ ] `31 — Home`
- [ ] `32 — Search`
- [ ] `33 — Library`
- [ ] `34 — Playlist`
- [ ] `35 — Album`
- [ ] `36 — Artist`
- [ ] `37 — Releases`
- [ ] `38 — History`
- [ ] `39 — Local Music`
- [ ] `40 — Queue`
- [ ] `41 — Lyrics`
- [ ] `42 — Now Playing`
- [ ] `43 — Devices`
- [ ] `44 — Signal Path`
- [ ] `45 — EQ & Daisy Sound`
- [ ] `46 — Settings`
- [ ] `50 — Mini Player`
- [ ] `51 — Winamp`
- [ ] `52 — MilkDrop`
- [ ] `53 — Ambient`
- [ ] `54 — Fullscreen`
- [ ] `60 — Loading`
- [ ] `61 — Empty`
- [ ] `62 — Errors`
- [ ] `63 — Offline & Rate Limit`
- [ ] `64 — Capability States`
- [ ] `70 — Dark`
- [ ] `71 — Light`
- [ ] `72 — OLED`
- [ ] `73 — Glass`
- [ ] `80 — Prototypes`
- [ ] `90 — Accessibility`
- [ ] `99 — Dev Handoff`

---

# 38. FIGMA COMPONENT INVENTORY

## Primitives

- [ ] Text.
- [ ] Icon.
- [ ] Divider.
- [ ] Focus Ring.
- [ ] Scrollbar.
- [ ] Tooltip.

## Controls

- [ ] Button.
- [ ] Icon Button.
- [ ] Toggle.
- [ ] Checkbox.
- [ ] Radio.
- [ ] Slider.
- [ ] Range Slider.
- [ ] Segmented Control.
- [ ] Tabs.
- [ ] Input.
- [ ] Search Input.
- [ ] Select.
- [ ] Chip.
- [ ] Badge.
- [ ] Menu Item.
- [ ] Context Menu.
- [ ] Toast.
- [ ] Banner.
- [ ] Dialog.
- [ ] Panel/Sheet.

## Music

- [ ] Artwork.
- [ ] Media Card.
- [ ] Album Card.
- [ ] Artist Card.
- [ ] Playlist Card.
- [ ] Track Row.
- [ ] Table Header.
- [ ] Quality Badge.
- [ ] Source Badge.
- [ ] Explicit Badge.
- [ ] Rating.
- [ ] Timeline.
- [ ] Player Bar.
- [ ] Playback Controls.
- [ ] Shuffle Selector.
- [ ] Repeat Selector.
- [ ] Device Selector.
- [ ] Volume.
- [ ] Queue Row.
- [ ] Queue Section Header.

## Audio

- [ ] Signal Path Node.
- [ ] Signal Path Connector.
- [ ] Meter.
- [ ] EQ Band.
- [ ] EQ Response Graph.
- [ ] DSP Module.
- [ ] Preset Picker.
- [ ] Output Card.
- [ ] Bit-Perfect Status.
- [ ] Headroom Warning.

## Shell

- [ ] App Shell.
- [ ] Top Bar.
- [ ] Nav Rail.
- [ ] Nav Item.
- [ ] Sidebar Group.
- [ ] Inspector.
- [ ] Page Header.
- [ ] Filter Bar.
- [ ] Empty State.
- [ ] Skeleton.
- [ ] Offline State.
- [ ] Rate-Limit State.

State variants:

- [ ] Default.
- [ ] Hover.
- [ ] Pressed.
- [ ] Focused.
- [ ] Selected.
- [ ] Disabled.
- [ ] Loading.
- [ ] Destructive where applicable.
- [ ] Compact/Default/Comfortable where applicable.

---

# 39. FIGMA GOLDEN PROTOTYPE FLOWS

The design is not “done” until these flows are coherent:

- [ ] 5,000-track Liked Songs → Pure Shuffle → inspect cycle → reshuffle remaining.
- [ ] Track → Play Next → queue updates.
- [ ] multi-select tracks → drag as block.
- [ ] Home → remove podcasts → move Releases first.
- [ ] Releases → followed artists → save EP.
- [ ] link Spotify track to local FLAC.
- [ ] local linked playback → Signal Path shows physical local source.
- [ ] transfer to remote Connect → source/capability UI changes.
- [ ] Ctrl+K → switch to Winamp.
- [ ] Winamp → MilkDrop → fullscreen.
- [ ] EQ → AutoEQ → Signal Path updates.
- [ ] Bit-Perfect enabled → incompatible DSP disables/explains why.
- [ ] Spotify 429 → cached Library remains usable.
- [ ] local drive disappears → linked source falls back cleanly.
- [ ] save/restore Session Capsule.

---

# 40. SETTINGS IA

- [ ] Account & Providers
- [ ] Playback
- [ ] Audio Output
- [ ] Audio Quality
- [ ] EQ & DSP
- [ ] Daisy Sound
- [ ] Queue & Shuffle
- [ ] Library
- [ ] Local Music
- [ ] Discovery
- [ ] Home
- [ ] Appearance
- [ ] Player Modes
- [ ] MilkDrop
- [ ] Winamp
- [ ] Lyrics
- [ ] Integrations
- [ ] Shortcuts
- [ ] Privacy
- [ ] Cache & Storage
- [ ] Advanced
- [ ] Diagnostics
- [ ] About

Settings Search:

- [ ] index all settings.
- [ ] synonym support.
- [ ] jump-to-control.
- [ ] highlighted result.
- [ ] keyboard accessible.

---

# 41. ACCESSIBILITY

- [ ] AccessKit audit.
- [ ] semantic control names.
- [ ] full keyboard operation.
- [ ] logical focus order.
- [ ] focus restoration.
- [ ] visible focus.
- [ ] high contrast.
- [ ] reduced motion.
- [ ] scalable text.
- [ ] color-blind-safe state.
- [ ] RTL readiness.
- [ ] Unicode everywhere.
- [ ] minimum usable hit targets.
- [ ] no hover-only critical actions.

---

# 42. RATE-LIMIT / NETWORK RESILIENCE

Priority classes:

```text
P0 Playback critical
P1 Explicit user action
P2 Visible page
P3 Prefetch
P4 Background sync
```

- [ ] central request scheduler.
- [ ] deduplication.
- [ ] request coalescing.
- [ ] Retry-After compliance.
- [ ] jitter.
- [ ] TTLs.
- [ ] stale-while-revalidate.
- [ ] negative cache where safe.
- [ ] cancellation.
- [ ] visibility-aware prefetch.
- [ ] provider quota awareness.

UI:

- [ ] keep cached page visible.
- [ ] stale marker.
- [ ] retry countdown.
- [ ] playback remains usable.
- [ ] never replace usable data with full-page spinner.

---

# 43. LOCAL DB / CACHE

Initial recommendation: evaluate SQLite with a minimal Rust abstraction.

Persist:

- [ ] library overlay.
- [ ] history.
- [ ] smart collections.
- [ ] local index.
- [ ] analysis metadata.
- [ ] cache metadata.
- [ ] source links.
- [ ] sessions.

Budgets:

- [ ] metadata budget.
- [ ] decoded texture budget.
- [ ] artwork disk budget.
- [ ] provider-page LRU.
- [ ] track-object sharing/dedup.
- [ ] waveform budget.
- [ ] sonic-analysis budget.

Migrations:

- [ ] versioned.
- [ ] transactional.
- [ ] backup/recovery.
- [ ] migration tests for every supported old schema.

---

# 44. PERFORMANCE BUDGETS

Startup:

- [ ] target cold startup < 1 second on reasonable modern SSD hardware.
- [ ] never block startup on full remote sync.

Idle:

- [ ] paused local player ~0% CPU.
- [ ] minimized/hidden UI lowers refresh.
- [ ] no visualizer cost when disabled.

Memory:

- [ ] baseline upstream.
- [ ] memory plateaus after long browsing.
- [ ] no unbounded page/track caches.
- [ ] no giant cloning for virtualized rows.

Library:

- [ ] 10k rows smooth.
- [ ] 100k local tracks practical.
- [ ] sorting/filtering avoids pathological allocation.

High-refresh UI:

- [ ] 120/144/165/240Hz friendly.
- [ ] avoid recomputing entire UI for inactive regions.
- [ ] measured input latency.

Audio:

- [ ] zero underruns under normal UI stress.
- [ ] MilkDrop cannot starve playback.
- [ ] network stalls cannot starve buffered audio.

---

# 45. SECURITY / PRIVACY

- [ ] tokens only in OS-protected credential store.
- [ ] no OAuth grants in ordinary JSON.
- [ ] redact logs.
- [ ] integrations opt-in.
- [ ] no telemetry default.
- [ ] crash reporting opt-in.
- [ ] history opt-out.
- [ ] clear data by category.
- [ ] signed/checksummed updates.
- [ ] dependency vulnerability scanning.
- [ ] auth callback threat model.
- [ ] security review before public stable release.

---

# 46. EXTENSIBILITY — DESIGN NOW, SHIP LATER

Internal extension boundaries:

- [ ] provider interface.
- [ ] visualizer interface.
- [ ] DSP-node interface.
- [ ] discovery-source interface.
- [ ] integration interface.
- [ ] command registration interface.

Future third-party ecosystem:

- [ ] evaluate WASM sandbox.
- [ ] permission manifest.
- [ ] no arbitrary filesystem/network by default.
- [ ] versioned API.
- [ ] crash isolation.
- [ ] signed/verified plugin strategy.

VST3/AU:

- [ ] research only.
- [ ] advanced opt-in.
- [ ] consider out-of-process hosting to protect player stability.
- [ ] never make VST support a prerequisite for core audio quality.

---

# 47. UPSTREAM PROTECTION

Remotes:

```text
origin    DaisySpoti
upstream  crmne/spotifast
```

Branches:

```text
main
dev
feature/*
fix/*
integration/upstream-*
```

Rules:

- [ ] protect `main`.
- [ ] normal PRs target `dev` until RC.
- [ ] never merge upstream main directly into Daisy branches.
- [ ] baseline upstream commit tagged.
- [ ] upstream tracking ref kept pristine.

Required docs:

```text
docs/upstream/
  BASELINE.md
  DIVERGENCE.md
  ACCEPTED_UPSTREAM.md
  REJECTED_UPSTREAM.md
```

Track:

- [ ] baseline SHA.
- [ ] Daisy-owned UI.
- [ ] Daisy-owned shuffle/queue changes.
- [ ] inherited MilkDrop.
- [ ] inherited Winamp.
- [ ] librespot fork/patch state.
- [ ] fastframe dependencies.

---

# 48. UPSTREAM AUDIT AGENT

Cadence:

- [ ] weekly lightweight audit.
- [ ] every Spotifast release.
- [ ] immediate on relevant librespot/security changes.

Monitor:

- [ ] `crmne/spotifast`.
- [ ] `librespot-org/librespot`.
- [ ] relevant fastframe changes.
- [ ] projectM.
- [ ] audio backends.

Classify:

- [ ] security.
- [ ] auth/API.
- [ ] librespot compatibility.
- [ ] playback stability.
- [ ] queue fixes.
- [ ] performance.
- [ ] platform integration.
- [ ] packaging.
- [ ] MilkDrop.
- [ ] Winamp.
- [ ] UI.
- [ ] branding.
- [ ] feature overlap.

Policy:

- security → urgent
- auth/API → urgent
- playback stability → high
- platform fixes → high
- performance → benchmark
- MilkDrop/Winamp compatibility → usually port
- UI → logic may be ported, Daisy visuals should not be overwritten
- branding → reject
- duplicate Daisy feature → compare, do not replace blindly

Output:

- [ ] audit report.
- [ ] focused integration PR(s).
- [ ] tests.
- [ ] accepted/rejected log update.

---

# 49. TEST STRATEGY

Unit:

- [ ] shuffle invariants.
- [ ] queue semantics.
- [ ] rule engine.
- [ ] query parser.
- [ ] identity/matching.
- [ ] cache policies.
- [ ] DSP math.
- [ ] migrations.

Property tests:

- [ ] shuffle permutations.
- [ ] duplicate queue occurrences.
- [ ] source fallback.
- [ ] smart collection rules.

Integration:

- [ ] provider mock.
- [ ] librespot mock where practical.
- [ ] local scan.
- [ ] output reconnect.
- [ ] cache refresh.
- [ ] rate limit.
- [ ] session restore.

Audio:

- [ ] gapless boundary.
- [ ] EQ response.
- [ ] headroom.
- [ ] true peak.
- [ ] channel map.
- [ ] sample-rate conversion.
- [ ] bit-exact fixture where appropriate.
- [ ] dropout stress.

Performance:

- [ ] startup.
- [ ] 10k/100k library.
- [ ] long-session memory.
- [ ] high-refresh UI.
- [ ] MilkDrop stress.
- [ ] DSP CPU.

---

# 50. DIAGNOSTICS

Local-only by default.

- [ ] diagnostics page.
- [ ] audio underrun counter.
- [ ] actual output format.
- [ ] queue state.
- [ ] provider cooldowns.
- [ ] cache sizes.
- [ ] DB stats.
- [ ] visualizer FPS.
- [ ] audio callback load.
- [ ] memory budgets.
- [ ] redacted report export.

---

# 51. DISTRIBUTION

Windows:

- [ ] signed installer.
- [ ] portable package if sensible.
- [ ] auto-update.
- [ ] clean uninstall.
- [ ] taskbar/media integration.

macOS:

- [ ] signing/notarization.
- [ ] universal builds where practical.
- [ ] native media integration.
- [ ] Homebrew cask later.

Linux:

- [ ] Flatpak.
- [ ] AppImage.
- [ ] AUR/distro packages where maintainable.
- [ ] Wayland/X11.
- [ ] MPRIS.

Release:

- [ ] checksums.
- [ ] signed metadata.
- [ ] stable/beta/nightly model later.
- [ ] release notes linked to feature flags/migrations.

---

# 52. MASTER PHASES

## Phase 0 — Baseline & Safety

- [x] inventory fork.
- [x] record upstream SHA.
- [x] configure remotes.
- [x] protect branches.
- [x] create `dev`.
- [x] create upstream docs.
- [x] baseline tests.
- [x] baseline CPU/RAM/startup (validated warm startup and authenticated playback/paused measurements).
- [-] reboot-cold startup measurement (explicitly waived by Daisy on 2026-10-07).
- [x] baseline screenshots.
- [x] dependency audit.
- [x] architecture map.
- [x] licensing audit.
- [x] branding replacement plan.
- [x] CI.

**Exit:** Daisy can always identify/recover upstream changes safely.

## Phase 1 — Figma / Design System / Shell

- [ ] Figma foundations.
- [ ] tokens.
- [ ] components.
- [ ] shell.
- [ ] nav.
- [ ] player bar.
- [ ] inspector.
- [ ] themes.
- [ ] density.
- [ ] loading/error states.
- [ ] accessibility foundation.

**Exit:** New Daisy UI can drive existing backend.

## Phase 2 — Core Control

- [ ] Pure Shuffle.
- [ ] Fresh Shuffle.
- [ ] Queue 2.0.
- [ ] Play Next.
- [ ] Play Later.
- [ ] multiselect.
- [ ] shortcuts.
- [ ] Ctrl+K.
- [ ] capability model.
- [ ] Session Capsules.

**Exit:** Daisy beats Spotify on deterministic playback control.

## Phase 3 — Library Overlay / Local Music

- [ ] local DB.
- [ ] Daisy metadata.
- [ ] scanner.
- [ ] local playback.
- [ ] source linking.
- [ ] smart collections.
- [ ] full Library.
- [ ] history.
- [ ] folders.

**Exit:** Daisy is a real music player, not just a provider frontend.

## Phase 4 — Audio Foundation

- [ ] output abstraction.
- [ ] device switching.
- [ ] actual format reporting.
- [ ] Reference mode.
- [ ] ReplayGain.
- [ ] basic EQ.
- [ ] Signal Path.
- [ ] gapless validation.
- [ ] benchmarks.

**Exit:** Audio is stable, transparent and credible.

## Phase 5 — Audiophile Expansion

- [ ] WASAPI Exclusive.
- [ ] sample-rate matching.
- [ ] Bit-Perfect state.
- [ ] PEQ.
- [ ] AutoEQ.
- [ ] per-device profiles.
- [ ] crossfeed.
- [ ] true-peak/headroom.
- [ ] loudness-matched A/B.

**Exit:** Daisy can replace extra utility software for everyday audiophile listening.

## Phase 6 — Daisy Sound

- [ ] Bass Foundation.
- [ ] Punch.
- [ ] Width.
- [ ] Glue.
- [ ] Guard.
- [ ] DNB.
- [ ] Hardstyle.
- [ ] Reggae.
- [ ] R&B.
- [ ] Late Night.
- [ ] objective + listening validation.

**Exit:** Optional SAP-inspired quality without broadcast bloat.

## Phase 7 — Personality

- [ ] Mini.
- [ ] Winamp polish.
- [ ] MilkDrop browser.
- [ ] Ambient.
- [ ] extra visualizers.
- [ ] fullscreen.
- [ ] artwork viewer.

**Exit:** Daisy has identity mainstream streaming clients do not.

## Phase 8 — Discovery / Home / Releases

- [ ] Home Builder.
- [ ] Releases.
- [ ] Discovery Controls.
- [ ] Listening Lenses.
- [ ] block/snooze.
- [ ] optional sonic analysis.

**Exit:** Recommendations become user-steerable.

## Phase 9 — Smart Playback

- [ ] Crossfade.
- [ ] Daisy Transitions.
- [ ] Smart Queue Rules.
- [ ] BPM/key/energy.
- [ ] Why Next explanations.

**Exit:** Intelligent automation remains transparent and optional.

## Phase 10 — Hardening

- [ ] rate-limit scheduler.
- [ ] bounded caches.
- [ ] memory optimization.
- [ ] security audit.
- [ ] accessibility audit.
- [ ] multi-day playback soak.
- [ ] crash recovery.
- [ ] packaging.
- [ ] migrations.
- [ ] update system.

**Exit:** stable release candidate.

---

# 53. FEATURE PRIORITY MATRIX

## P0 — Daisy identity

- [ ] full new UI/design system.
- [ ] native performance.
- [ ] Spotify integration.
- [ ] Connect.
- [ ] Pure Shuffle.
- [ ] Fresh Shuffle.
- [ ] Queue 2.0.
- [ ] Play Next / Play Later.
- [ ] multiselect.
- [ ] keyboard desktop workflow.
- [ ] command palette.
- [ ] full Library.
- [ ] Home Builder.
- [ ] Releases.
- [ ] History.
- [ ] local DB.
- [ ] local music.
- [ ] source linking.
- [ ] smart collections.
- [ ] rate-limit resilience.
- [ ] Reference audio.
- [ ] truthful quality badge.
- [ ] basic EQ.
- [ ] device selector.
- [ ] basic Signal Path.
- [ ] Winamp retained.
- [ ] MilkDrop retained.
- [ ] Mini.
- [ ] Ambient.
- [ ] Lyrics.
- [ ] dark/light/OLED.
- [ ] accessibility foundation.
- [ ] upstream protection.

## P1 — Power / audiophile

- [ ] WASAPI Exclusive.
- [ ] sample-rate matching.
- [ ] Bit-Perfect state.
- [ ] PEQ.
- [ ] AutoEQ.
- [ ] per-device profiles.
- [ ] crossfeed.
- [ ] true-peak/headroom.
- [ ] crossfade.
- [ ] Daisy Sound.
- [ ] block/snooze.
- [ ] Listening Lenses.
- [ ] advanced history/stats.
- [ ] Last.fm.
- [ ] ListenBrainz.
- [ ] advanced MilkDrop browser.
- [ ] spectrum/waveform/phase tools.

## P2 — bold expansion

- [ ] Daisy Transitions.
- [ ] sonic similarity.
- [ ] BPM/key/energy analysis.
- [ ] smart queue rules.
- [ ] convolution.
- [ ] advanced plugin SDK.
- [ ] optional VST3/AU research.
- [ ] advanced session automation.
- [ ] visualizer SDK.
- [ ] remote-control/headless mode if it fits product direction later.

## Waiting on provider/upstream

- [ ] Spotify Lossless through lawful supported playback path.
- [ ] features depending on unavailable Spotify private APIs.

## Explicitly rejected

- [x] DRM circumvention.
- [x] fake lossless/upscaled Hi-Res labels.
- [x] full SAP broadcast chain.
- [x] default broadcast clipping/AGC.
- [x] forced podcasts/video.
- [x] browser-engine UI.
- [x] telemetry-first product.
- [x] opaque recommendation changes.
- [x] blindly merging upstream.

---

# 54. RELEASE GATES

No stable v1 until all relevant gates pass.

## UX

- [ ] all P0 golden flows validated.
- [ ] keyboard-only critical-path pass.
- [ ] no obvious layout clipping at supported sizes.
- [ ] no critical hover-only control.
- [ ] dark/light/OLED pass.

## Audio

- [ ] no known audio-thread blocking.
- [ ] gapless tested.
- [ ] device reconnect tested.
- [ ] Signal Path truthful.
- [ ] no clipping introduced by default Reference path.
- [ ] DSP bypass truly bypasses DSP.

## Performance

- [ ] startup budget.
- [ ] memory soak.
- [ ] 10k/100k library tests.
- [ ] 240Hz UI stress.
- [ ] MilkDrop stress.

## Reliability

- [ ] crash recovery.
- [ ] DB migration.
- [ ] 429 handling.
- [ ] network outage.
- [ ] unavailable local drive.
- [ ] remote device handoff.

## Security

- [ ] secrets audit.
- [ ] log redaction.
- [ ] dependency audit.
- [ ] updater checks.

---

# 55. CODEX RULES

Codex MUST:

1. Read this file before starting a phase.
2. Read `docs/upstream/*`.
3. Inspect existing code before proposing rewrites.
4. Preserve useful Spotifast behavior unless Daisy explicitly replaces it.
5. Work on `dev`/feature branches, never directly on stable `main`.
6. Keep PRs scoped.
7. Add tests with every behavioral change.
8. Benchmark performance-sensitive changes.
9. Update this checklist.
10. Update ADR/upstream logs when required.
11. Never silently alter product semantics.
12. Never bypass DRM.
13. Never call lossy playback lossless.
14. Never merge upstream wholesale.
15. Never redesign UI ad hoc outside the Figma/design-system direction.

---

# 56. FIRST CODEX EXECUTION ORDER

Start here, in this exact order:

### Task A — repository audit

- [x] identify current fork repository root.
- [x] identify current branch/remotes.
- [x] record exact fork-base/upstream relationship.
- [x] generate architecture map.
- [x] enumerate current Spotifast functionality.
- [x] identify Daisy modifications already present.
- [x] run tests.
- [x] run demo.
- [x] benchmark startup/RAM/idle CPU (warm startup; authenticated playback and paused/minimized idle).
- [x] inspect UI screenshots.
- [x] create `docs/upstream/*`.
- [x] create `docs/adr/`.

### Task B — safe branch structure

- [x] ensure `origin`.
- [x] add `upstream` if absent.
- [x] fetch upstream.
- [x] create/protect `dev`.
- [x] never merge upstream.
- [x] record upstream baseline SHA.

### Task C — design implementation foundation

Wait for approved Figma/tokens before broad visual implementation.

- [ ] introduce Daisy token layer.
- [ ] component primitives.
- [ ] shell.
- [ ] new navigation.
- [ ] new player bar.
- [ ] inspector.
- [ ] preserve existing backend behavior.

### Task D — capability model

Before feature explosion:

- [ ] local vs remote playback capability matrix.
- [ ] Spotify vs local source capability matrix.
- [ ] UI API for feature availability/explanations.

### Task E — Pure Shuffle

Implement signature control feature first after shell/capability foundation.

---

# 57. RESEARCH ANCHORS USED FOR THIS PLAN

Research conclusions were cross-checked against:

- current Spotifast repository/readme/docs/issues.
- current librespot Lossless discussion and playback constraints.
- Spotify’s current Turkish audio-quality documentation.
- Spotify Community true-shuffle requests in 2026.
- Spotify Community Play Next requests in 2026.
- Spotify Community/Desktop complaints about sidebar/panel space.
- 2026 Spotify user discussions requesting user-built/music-only Home.
- Spotify removal/changes to What’s New and resulting release-tracking complaints.
- Roon Signal Path documentation.
- Plexamp feature set: Sweet Fades, loudness leveling, pre-caching, visualizers, sample-rate matching, home customization, sonic features.
- foobar2000: ReplayGain, DSP, tagging, shortcuts, extension architecture.
- Qobuz WASAPI/ASIO recommendations.
- TIDAL Hi-Res FLAC positioning.
- Deezer Flow Tuner user-control philosophy.

This research informs direction; Daisy must still benchmark and validate all implementation choices.

---

# 58. FINAL PRODUCT TEST

Before calling DaisySpoti “best”, ask:

### Control
Can I know exactly why and what plays next?

### Library
Can I manage 50,000 tracks better than Spotify?

### Audio
Can I see exactly what is happening between source and device?

### Quality
Can I choose Reference, AutoEQ, Daisy Sound or Bit-Perfect without lies?

### Performance
Does it feel like a native app even after hours of use?

### Personality
Can I use a beautiful modern player, Winamp, MilkDrop or Ambient without installing separate software?

### Resilience
Does Spotify rate limiting break the whole experience, or just the data that truly needs Spotify?

### Ownership
Can upstream fix bugs without overwriting Daisy’s product?

### Innovation
Does Daisy do things Spotify, Spotifast and traditional local players do not — while remaining understandable?

If any answer is “no”, the roadmap is not finished.
