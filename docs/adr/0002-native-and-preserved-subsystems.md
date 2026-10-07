# ADR 0002: Preserve the native foundation and personality subsystems

Status: Accepted. Date: 2026-10-07.

## Context

Current implementation uses Rust/egui/eframe/glow, Tokio workers, librespot and
a custom audio sink. Winamp skins/playlist/EQ and projectM MilkDrop already
exist and are explicit product requirements. Future redesign does not authorize
removing them or modifying playback semantics in Phase 0.

## Decision

Retain this native foundation. Views emit Actions, App applies them after draw,
backend/player perform network/audio work outside the UI thread. Retain Winamp
and MilkDrop, their signal-tap contract (post-EQ/pre-volume), platform isolation,
queue occurrence identity and optimistic stale-answer protection. No browser
engine, DRM bypass or unsupported Spotify lossless claims.

## Alternatives

A webview replacement or broad subsystem rewrite lacks measurement and violates
the current brief. Removing Winamp/MilkDrop conflicts with explicit preservation.

## Consequences and validation

The architecture audit traces current code and test surfaces. It does not prove
real-time guarantees, gaplessness under stress or all-platform behavior. Future
changes must preserve invariants with focused regression tests and native runtime
checks. Keep dependency fork groups coherent. No new architecture implemented.
