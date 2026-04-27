# geno-media

Media creation skills for AI coding agents. Audiobooks with Kokoro TTS, animated videos with Manim, podcast videos, TTS/STT configuration, and audio uploads. Optimized for Apple Silicon.

## Skills

| Skill | Description |
|---|---|
| `/geno-media-audiobooks-create [folder]` | Generate audiobook from transcript using Kokoro TTS |
| `/geno-media-audiobooks-recurse [folder]` | Recursive audiobook generation across subfolders |
| `/geno-media-videos-create [folder]` | Transcript + audio to animated Manim video |
| `/geno-media-podcasts-create [folder]` | Transcript + audio to karaoke-style text-on-screen video |
| `/geno-media-tts-configure` | Configure TTS (voice, speed profile, accent) |
| `/geno-media-stt-configure` | Configure STT (Whisper model, language, backend) |
| `/geno-media-audio-upload` | Upload audio files to Google Drive |

## Ecosystem

geno-media is part of the [geno-tools](https://github.com/42euge/geno-tools) ecosystem.

- [geno-tools](https://github.com/42euge/geno-tools) — orchestrator and general tools
- [geno-research](https://github.com/42euge/geno-research) — deep research workflows
- [geno-kaggle](https://github.com/42euge/geno-kaggle) — Kaggle benchmarking
- **geno-media** — media creation skills (you are here)
