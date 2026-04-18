---
name: geno-media
description: >-
  Media creation toolkit — audiobooks with Kokoro TTS, animated videos with Manim,
  podcast videos, TTS/STT configuration, and audio uploads.
  Use when user says /gt-media-audiobook-create, /gt-media-video-create,
  /gt-media-podcast-create, /gt-media-tts-config, /gt-media-stt-config,
  /gt-media-audio-upload, or /gt-media-audiobook-recursive.
license: MIT
metadata:
  author: 42euge
  version: "0.2.0"
---

# geno-media

Media creation skills for Claude Code. Audiobook generation (Kokoro TTS), animated
video creation (Manim), podcast-style videos, TTS/STT configuration, and audio
uploads. Optimized for Apple Silicon.

Installed via [geno-tools](https://github.com/42euge/geno-tools):
```bash
geno-tools install media
```

## Commands

| Command | Description |
|---|---|
| `/gt-media-audiobook-create [folder]` | Generate audiobook from transcript using Kokoro TTS |
| `/gt-media-audiobook-recursive [folder]` | Recursive audiobook generation across subfolders |
| `/gt-media-video-create [folder]` | Transcript + audio → animated Manim video |
| `/gt-media-podcast-create [folder]` | Transcript + audio → karaoke-style text-on-screen video |
| `/gt-media-tts-config` | Configure TTS (voice, speed profile, accent) |
| `/gt-media-stt-config` | Configure STT (Whisper model, language, backend) |
| `/gt-media-audio-upload` | Upload audio files to Google Drive |

## Runtime

Runtime lives under `~/.geno-tools/geno-media/`:
- `venvs/media/` — shared venv (Kokoro, Manim, stable-ts, pymupdf)
- `scripts/audiobook/generate.py`, `scripts/video/{align_audio,sync_utils}.py` — symlinks into this repo
- `configs/tts.yaml`, `configs/stt.yaml` — user-editable (copy-once from defaults)
- `configs/profiles/*.yaml` — TTS speed profiles (user-editable)

System deps: `brew install cairo pango ffmpeg` (macOS).
