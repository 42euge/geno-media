# geno-media

Media creation skills for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Audiobooks with Kokoro TTS, animated videos with Manim, podcast videos, and TTS/STT configuration. Optimized for Apple Silicon.

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

## Repository structure

```
geno-media/
├── install.sh              # Sets up ~/.geno/geno-media/ runtime + skills
├── audiobook/
│   └── generate.py         # Text -> audiobook using Kokoro TTS
├── video/
│   ├── align_audio.py      # Forced alignment: transcript + audio -> timing.yaml
│   ├── sync_utils.py       # SegmentTimer for syncing Manim animations to audio
│   └── README.md           # Video pipeline docs
├── tts/
│   └── profiles/           # Speed variation profiles
└── config/
    └── defaults/           # Default config templates
```

## Install

```bash
./install.sh           # full install (venvs + symlinks)
./install.sh --link    # symlinks only (skip venv creation)
```

System dependencies:
```bash
brew install cairo pango ffmpeg
```

## Runtime location

`~/.geno/geno-media/` — venvs, configs, symlinks to source.

## Part of the geno ecosystem

- [geno-tools](https://github.com/42euge/geno-tools) — orchestrator + general tools
- [geno-research](https://github.com/42euge/geno-research) — deep research workflows
- [geno-kaggle](https://github.com/42euge/geno-kaggle) — Kaggle benchmarking

## License

MIT
