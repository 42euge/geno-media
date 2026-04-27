# Getting Started

## Prerequisites

- A supported coding CLI: [Claude Code](https://docs.anthropic.com/en/docs/claude-code), [Gemini CLI](https://github.com/google-gemini/gemini-cli), [Codex](https://github.com/openai/codex), or [OpenCode](https://github.com/nicepkg/opencode)
- [geno-tools](https://github.com/42euge/geno-tools) installed
- macOS with Apple Silicon (M1+) recommended
- System dependencies: `brew install cairo pango ffmpeg`

## Install

```bash
geno-tools install geno-media
```

This clones the repo, creates a Python venv with all dependencies (Kokoro, Manim, stable-ts, pymupdf), and registers skills with your coding agent.

## First use

### Generate an audiobook

1. Create a folder with a `transcript.md` file containing the text you want to convert to audio.
2. From an agent session, run:
   ```
   /geno-media-audiobooks-create /path/to/folder
   ```
3. The agent will guide you through voice selection and generate a WAV file.

### Create a video

1. Start with a folder containing `transcript.md` and an audio file (`.mp3`).
2. From an agent session, run:
   ```
   /geno-media-videos-create /path/to/folder
   ```
3. The agent will segment the transcript, run forced alignment, design visuals, and render with Manim.

### Configure TTS/STT

```
/geno-media-tts-configure
/geno-media-stt-configure
```

These interactive skills let you choose voices, speed profiles, Whisper models, and other settings.

## Runtime location

After installation, runtime files live at `~/.geno-tools/geno-media/`:

```
~/.geno-tools/geno-media/
├── venvs/media/          # Python venv (Kokoro, Manim, stable-ts)
├── scripts/              # symlinks to runtime/ in this repo
│   ├── audiobook/generate.py
│   └── video/{align_audio.py, sync_utils.py}
└── configs/              # user-editable (copied from config/defaults/)
    ├── tts.yaml
    ├── stt.yaml
    └── profiles/*.yaml
```
