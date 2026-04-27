# geno-media — media creation toolkit for AI coding agents

Audiobook generation (Kokoro TTS), animated video creation (Manim), podcast-style videos, TTS/STT configuration, and audio uploads. Optimized for Apple Silicon.

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

## Repo structure

```
geno-media/
├── GENO.md              # agent instructions (this file)
├── SKILL.md             # umbrella skill manifest
├── genotools.yaml       # geno-tools install manifest
├── skills/              # skill definitions
│   ├── geno-media/                    # umbrella
│   ├── geno-media-audiobooks-create/  # single audiobook generation
│   ├── geno-media-audiobooks-recurse/ # recursive batch generation
│   ├── geno-media-videos-create/      # Manim explainer videos
│   ├── geno-media-podcasts-create/    # karaoke text-on-screen videos
│   ├── geno-media-tts-configure/      # TTS settings
│   ├── geno-media-stt-configure/      # STT settings
│   └── geno-media-audio-upload/       # Google Drive upload
├── runtime/             # Python scripts (symlinked at install)
│   ├── audiobook/generate.py
│   └── video/{align_audio.py, sync_utils.py}
├── config/              # default configs (copied at install)
│   └── defaults/
│       ├── tts.yaml
│       ├── stt.yaml
│       └── profiles/*.yaml
├── docs/                # MkDocs Material site
└── LICENSE
```

## Conventions

- **Skill naming**: `geno-media-{sub-skillset}-{action}` where sub-skillset is a pluralized noun and action is a verb.
- **SKILL.md frontmatter**: every skill directory contains a `SKILL.md` with `name`, `description`, `allowed-tools`, `license`, and `metadata` fields.
- **Adding a new skill**: create `skills/geno-media-{sub}-{verb}/SKILL.md`, update the umbrella SKILL.md skills table, update this file's skills table and repo structure.

## Architecture

### Audiobook pipeline
`generate.py` reads `transcript.md` (or extracts text from PDFs via pymupdf), splits into chunks, runs Kokoro TTS locally on Apple Silicon, and concatenates into a single WAV. Speed profiles let an LLM vary per-chunk speed for natural pacing.

### Video pipeline
`align_audio.py` uses Whisper forced alignment (stable-ts, MLX backend) to produce `timing.yaml` with per-word timestamps. Manim scene scripts consume this via `sync_utils.SegmentTimer` for frame-accurate animation sync. Two modes: full Manim explainer videos and data-driven podcast (karaoke) videos.

### Audio upload
Discovers WAV/MP3 files, converts WAV to MP3, copies to Google Drive local mount preserving directory structure.

## Dependencies and runtime

**Python venv** (`~/.geno-tools/geno-media/venvs/media/`):
- kokoro, misaki[en], soundfile, numpy, pyyaml — audiobook generation
- manim — animation engine
- stable-ts[mlx] — Whisper forced alignment on Apple Silicon
- pymupdf — PDF text extraction

**System deps** (macOS): `brew install cairo pango ffmpeg`

**Install**: `geno-tools install geno-media`
