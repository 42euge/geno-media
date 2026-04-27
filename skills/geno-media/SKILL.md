---
name: geno-media
description: >-
  Media creation toolkit — audiobooks with Kokoro TTS, animated videos with Manim,
  podcast videos, TTS/STT configuration, and audio uploads.
  Use when user says /geno-media-audiobooks-create, /geno-media-videos-create,
  /geno-media-podcasts-create, /geno-media-tts-configure, /geno-media-stt-configure,
  /geno-media-audio-upload, or /geno-media-audiobooks-recurse.
allowed-tools: "Bash(source *) Bash(python *) Bash(python3 *) Bash(ffmpeg *) Bash(ffprobe *) Bash(ffplay *) Bash(manim *) Bash(brew *) Bash(ls *) Bash(cat *) Bash(cp *) Bash(mkdir *) Bash(rm *) Bash(find *) Bash(osascript *) Read(*) Write(*) Edit(*)"
license: MIT
metadata:
  author: 42euge
  version: "0.2.0"
---

# geno-media

Media creation skills for AI coding agents. Audiobook generation (Kokoro TTS), animated
video creation (Manim), podcast-style videos, TTS/STT configuration, and audio
uploads. Optimized for Apple Silicon.

Installed via [geno-tools](https://github.com/42euge/geno-tools):
```bash
geno-tools install geno-media
```

## Skills

| Skill | Sub-skillset | Slash command |
|-------|-------------|---------------|
| geno-media | — | — (umbrella) |
| geno-media-audiobooks-create | audiobooks | /geno-media-audiobooks-create |
| geno-media-audiobooks-recurse | audiobooks | /geno-media-audiobooks-recurse |
| geno-media-videos-create | videos | /geno-media-videos-create |
| geno-media-podcasts-create | podcasts | /geno-media-podcasts-create |
| geno-media-tts-configure | tts | /geno-media-tts-configure |
| geno-media-stt-configure | stt | /geno-media-stt-configure |
| geno-media-audio-upload | audio | /geno-media-audio-upload |

## Runtime

Runtime lives under `~/.geno-tools/geno-media/`:
- `venvs/media/` — shared venv (Kokoro, Manim, stable-ts, pymupdf)
- `scripts/audiobook/generate.py`, `scripts/video/{align_audio,sync_utils}.py` — symlinks into this repo
- `configs/tts.yaml`, `configs/stt.yaml` — user-editable (copy-once from defaults)
- `configs/profiles/*.yaml` — TTS speed profiles (user-editable)

System deps: `brew install cairo pango ffmpeg` (macOS).
