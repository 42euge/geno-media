# Getting Started

## Prerequisites

- A supported coding CLI: [Claude Code](https://docs.anthropic.com/en/docs/claude-code), [Gemini CLI](https://github.com/google-gemini/gemini-cli), [Codex](https://github.com/openai/codex), or [OpenCode](https://github.com/opencode-ai/opencode)
- [geno-tools](https://github.com/42euge/geno-tools) installed (`pipx install geno-tools`)
- macOS with Apple Silicon (M1+) recommended for MLX acceleration
- System dependencies: `brew install cairo pango ffmpeg`

## Install

From within an agent session:

```
/geno-tools install geno-media
```

Or from the command line:

```bash
geno-tools install geno-media
```

This clones the repo, creates a Python venv with all dependencies (Kokoro, Manim, stable-ts, pymupdf), and registers the skills with your coding CLI.

## Runtime location

After installation, runtime files live at `~/.geno-tools/geno-media/`:

```
~/.geno-tools/geno-media/
├── venvs/media/           # shared Python environment
├── scripts/               # symlinks to this repo's runtime/
│   ├── audiobook/
│   │   └── generate.py
│   └── video/
│       ├── align_audio.py
│       └── sync_utils.py
└��─ configs/               # user-editable (copy-once from defaults)
    ├── tts.yaml
    ├── stt.yaml
    └── profiles/          # TTS speed profiles
```

## First use

### Create an audiobook

1. Prepare a `transcript.md` file with the text you want to convert to audio
2. Run `/geno-media-audiobook-create` from an agent session
3. The skill will guide you through voice selection and generate a WAV file

### Create a video

1. Start with a `transcript.md` and an audio file (`.mp3`) in a folder
2. Run `/geno-media-video-create` for animated Manim videos, or `/geno-media-podcast-create` for karaoke-style text-on-screen
3. The skill handles forced alignment, scene generation, rendering, and audio combination

### Configure TTS/STT

- `/geno-media-tts-config` — set voice, speed profile, and output format
- `/geno-media-stt-config` — set Whisper model, language, and backend
