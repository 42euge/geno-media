# geno-media

Media creation skills for AI coding agents. Audiobooks (Kokoro TTS), animated videos (Manim), podcast videos, TTS/STT configuration, and audio uploads. Optimized for Apple Silicon.

Part of the [geno-tools](https://github.com/42euge/geno-tools) ecosystem.

## Install

Prerequisites: a supported coding CLI ([Claude Code](https://docs.anthropic.com/en/docs/claude-code), [Gemini CLI](https://github.com/google-gemini/gemini-cli), [Codex](https://github.com/openai/codex), or [OpenCode](https://github.com/nicepkg/opencode)) and [geno-tools](https://github.com/42euge/geno-tools) installed.

```bash
geno-tools install geno-media
```

System deps:
```bash
brew install cairo pango ffmpeg
```

## Skills

| Skill | Description |
|---|---|
| `/geno-media-audiobooks-create [folder]` | Generate audiobook from transcript using Kokoro TTS |
| `/geno-media-audiobooks-recurse [folder]` | Recursive audiobook generation across subfolders |
| `/geno-media-videos-create [folder]` | Transcript + audio → animated Manim video |
| `/geno-media-podcasts-create [folder]` | Transcript + audio → karaoke-style text-on-screen video |
| `/geno-media-tts-configure` | Configure TTS (voice, speed profile, accent) |
| `/geno-media-stt-configure` | Configure STT (Whisper model, language, backend) |
| `/geno-media-audio-upload` | Upload audio files to Google Drive |

## Repository structure

```
geno-media/
├── GENO.md              # agent instructions
├── SKILL.md             # umbrella skill manifest
├── genotools.yaml       # geno-tools install manifest
├── skills/              # skill definitions
│   ├── geno-media/
│   └── geno-media-*/
├── runtime/             # symlinked → ~/.geno-tools/geno-media/scripts/
│   ├── audiobook/generate.py
│   └── video/{align_audio,sync_utils}.py
└── config/
    └── defaults/        # copied once → ~/.geno-tools/geno-media/configs/
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
