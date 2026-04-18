---
name: geno-media
description: >-
  Media creation toolkit — audiobooks with Kokoro TTS, animated videos with Manim,
  podcast videos, TTS/STT configuration, and audio uploads.
  Use when user says /gt-create-audiobook, /gt-create-video, /gt-config-tts,
  /gt-config-stt, or /gt-upload-audio.
license: MIT
metadata:
  author: 42euge
  version: "0.1.0"
---

# geno-media

Media creation skills for Claude Code. Provides audiobook generation, animated video creation,
podcast videos, and TTS/STT configuration. Optimized for Apple Silicon.

## Commands

| Command | Description |
|---------|-------------|
| `/gt-create-audiobook [folder]` | Generate audiobook from transcript using Kokoro TTS |
| `/gt-create-audiobook-recursive [folder]` | Recursive audiobook generation across subfolders |
| `/gt-create-video [folder]` | Full video pipeline: transcript + audio to animated Manim video |
| `/gt-create-podcast-video [folder]` | Transcript + audio to karaoke-style text-on-screen video |
| `/gt-config-tts` | Configure TTS: voice, speed profile, accent |
| `/gt-config-stt` | Configure STT: Whisper model, language, backend |
| `/gt-upload-audio` | Upload audio files to Google Drive |

## Runtime

Runtime files are installed to `~/.geno/geno-media/` including:
- Python venvs for audiobook (Kokoro) and video (Manim) pipelines
- TTS speed profiles and configuration
- STT configuration
