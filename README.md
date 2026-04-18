# geno-media

Media creation skills for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Audiobooks (Kokoro TTS), animated videos (Manim), podcast videos, TTS/STT configuration, and audio uploads. Optimized for Apple Silicon.

Part of the [geno-tools](https://github.com/42euge/geno-tools) ecosystem.

## Install

```bash
geno-tools install media                       # from registry
geno-tools dev media /path/to/local/checkout   # for local dev
```

System deps:
```bash
brew install cairo pango ffmpeg
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

## Repository structure

```
geno-media/
├── SKILL.md                    # umbrella skill (discovered by geno-tools)
├── genotools.yaml              # install manifest
├── commands/                   # slash-command .md files
│   └── gt-media-*.md
├── runtime/                    # symlinked → ~/.geno-tools/geno-media/scripts/
│   ├── audiobook/generate.py
│   └── video/{align_audio,sync_utils}.py
└── config/
    └── defaults/               # copied once → ~/.geno-tools/geno-media/configs/
        ├── tts.yaml
        ├── stt.yaml
        └── profiles/*.yaml
```

## Runtime location

Installed to `~/.geno-tools/geno-media/`:
- `venvs/media/` — shared Python environment
- `scripts/` — symlinks into this repo's `runtime/`
- `configs/` — user-editable configs (initial copy from `config/defaults/`)

## License

MIT
