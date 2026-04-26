# geno-media

Media creation toolkit for AI coding agents. Audiobook generation (Kokoro TTS), animated video creation (Manim), podcast-style videos, TTS/STT configuration, and audio uploads. Optimized for Apple Silicon.

## Skills

| Skill | Sub-skillset | Slash command |
|-------|-------------|---------------|
| geno-media | — | — (umbrella) |
| geno-media-audiobook-create | audiobook | /geno-media-audiobook-create |
| geno-media-audiobook-recursive | audiobook | /geno-media-audiobook-recursive |
| geno-media-video-create | video | /geno-media-video-create |
| geno-media-podcast-create | video | /geno-media-podcast-create |
| geno-media-tts-config | config | /geno-media-tts-config |
| geno-media-stt-config | config | /geno-media-stt-config |
| geno-media-audio-upload | uploads | /geno-media-audio-upload |

## Repo structure

```
geno-media/
├── GENO.md              # agent instructions (this file)
├── SKILL.md             # umbrella skill manifest
├── genotools.yaml       # geno-tools install manifest
├── skills/              # skill definitions
│   ├── geno-media/      #   umbrella
│   ├── geno-media-audiobook-create/
│   ├── geno-media-audiobook-recursive/
│   ├── geno-media-video-create/
│   ├── geno-media-podcast-create/
│   ├── geno-media-tts-config/
│   ├── geno-media-stt-config/
│   └── geno-media-audio-upload/
├── runtime/             # Python scripts (symlinked at install)
│   ├── audiobook/
│   │   └── generate.py  # text → audiobook via Kokoro TTS
│   └── video/
│       ├── align_audio.py   # forced alignment (Whisper + MLX)
│       ├── sync_utils.py    # SegmentTimer for Manim sync
│       └── README.md        # video pipeline docs
├── config/              # default configs (copied once at install)
│   └── defaults/
│       ├── tts.yaml
│       ├── stt.yaml
│       └── profiles/    # TTS speed profiles
├── docs/                # MkDocs Material site
└── LICENSE
```

## Conventions

- **Skill naming**: skills follow the `geno-media-{sub-skillset}-{action}` pattern
- **Runtime location**: installed to `~/.geno-tools/geno-media/` by `geno-tools install geno-media`
- **Venv**: `~/.geno-tools/geno-media/venvs/media/` — shared Python env (Kokoro, Manim, stable-ts, pymupdf)
- **Configs**: `~/.geno-tools/geno-media/configs/` — user-editable TTS/STT configs (copy-once from defaults)
- **Scripts**: `~/.geno-tools/geno-media/scripts/` — symlinks into this repo's `runtime/`

## Architecture

### Audiobook pipeline

`generate.py` reads a `transcript.md`, chunks it, runs Kokoro TTS per chunk, applies speed profiles, and concatenates into a single WAV. Supports `--voice`, `--speed`, `--strip-citations`, and `--output` flags.

### Video pipeline

1. `align_audio.py` — forced alignment via Whisper (stable-ts, MLX backend) maps transcript segments to audio timestamps, producing `timing.yaml`
2. `sync_utils.py` — `SegmentTimer` class wraps Manim's `play()`/`wait()` to track elapsed time per segment, enabling tight audio-visual sync
3. Scene scripts (written per-project) use `SegmentTimer` to animate in lockstep with narration

### TTS/STT config

User-editable YAML configs at `~/.geno-tools/geno-media/configs/`. Speed profiles control per-chunk speed variation via LLM annotation.

## Dependencies

- **Python**: kokoro, misaki, soundfile, numpy, pyyaml, manim, stable-ts[mlx], pymupdf
- **System** (macOS): `brew install cairo pango ffmpeg`
- **Hardware**: Apple Silicon (M1+) recommended for MLX acceleration
