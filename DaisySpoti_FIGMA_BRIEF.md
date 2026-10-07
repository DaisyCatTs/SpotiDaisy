# DaisySpoti — Design/Figma Brief

This file is the concise Figma-facing companion to `DaisySpoti_MASTER_PLAN.md`.

## Design goal

Create a desktop music application that feels:

- native;
- premium;
- fast;
- music-first;
- serious enough for audiophiles;
- beautiful enough for normal listeners;
- dense enough for large libraries;
- distinctive without becoming neon/cyberpunk or generic SaaS.

## Signature surfaces

1. **Home Builder**
2. **Full Library Workspace**
3. **Pure Shuffle / Shuffle Lab**
4. **Queue 2.0**
5. **Releases**
6. **Local Music**
7. **Signal Path**
8. **EQ & Daisy Sound**
9. **Modern Player**
10. **Mini**
11. **Winamp**
12. **MilkDrop**
13. **Ambient**
14. **Capability states**
15. **Rate-limit/offline states**

## Shell

Left = navigation/pins/folders/sessions  
Center = real workspace  
Right = optional inspector  
Bottom = persistent player

The right inspector must be fully closable. Queue/Lyrics/Signal Path can also become center pages.

## Look

- neutral graphite
- optional artwork-driven accent
- high-quality dark/light/OLED modes
- modest radii
- real data tables
- restrained shadow
- small, precise motion
- Geist candidate typography; Inter fallback
- monochrome/technical treatment for Signal Path where useful
- no Spotify-green dependency
- no excessive glass
- no huge mobile cards

## Desktop behavior to visualize

- compact/default/comfortable density
- keyboard focus
- multi-select
- drag/drop
- context menu
- resizable columns/panels
- hover/pressed/focus/selected states
- cached/stale/rate-limited states

## Audio UI principle

The audio experience should feel closer to a premium hardware/control application than a generic streaming-settings page.

Signal Path must answer:

- What source am I hearing?
- Is it Spotify or local?
- What codec/bitrate/bit depth/sample rate?
- Was it normalized?
- What EQ/DSP is active?
- Is it being resampled?
- Which output/device/mode?
- Is the chain Reference, Enhanced, High Quality, or genuinely Bit-Perfect?

## Figma page inventory

Use the page inventory in section 37 of the Master Plan exactly.

## Prototype priority

First prototype:
Home → Library → Playlist → Pure Shuffle → Queue → Signal Path → EQ → device transfer → Winamp → MilkDrop.

Second:
Local file linking → local lossless playback → remote Spotify fallback.

Third:
Home customization → Releases → Session Capsule.
