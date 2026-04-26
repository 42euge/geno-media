# geno-media

Media creation toolkit for AI coding agents. Audiobooks with Kokoro TTS, animated videos with Manim, podcast videos, TTS/STT configuration, and audio uploads. Optimized for Apple Silicon.

## Commands

| Command | Description |
|---|---|
| `/geno-media-audiobook-create [folder]` | Generate audiobook from transcript using Kokoro TTS |
| `/geno-media-audiobook-recursive [folder]` | Recursive audiobook generation across subfolders |
| `/geno-media-video-create [folder]` | Transcript + audio → animated Manim video |
| `/geno-media-podcast-create [folder]` | Transcript + audio → karaoke-style text-on-screen video |
| `/geno-media-tts-config` | Configure TTS (voice, speed profile, accent) |
| `/geno-media-stt-config` | Configure STT (Whisper model, language, backend) |
| `/geno-media-audio-upload` | Upload audio files to Google Drive |

## Ecosystem

- [geno-tools](https://github.com/42euge/geno-tools) — skillset manager (install, update, remove)
- [geno-research](https://github.com/42euge/geno-research) — deep research workflows
- [geno-kaggle](https://github.com/42euge/geno-kaggle) — Kaggle benchmarking
- **geno-media** — media creation (this repo)
