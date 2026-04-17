# Create Audiobooks Recursively with Kokoro TTS

You are generating audiobooks for every `.md` and `.pdf` file found in a folder and its subfolders, using Kokoro TTS (82M params, runs locally on Apple Silicon).

Supporting code lives in `~/.geno/geno-media/audiobook/`.

## Input

The user may provide a folder path as an argument: `$ARGUMENTS`

If `$ARGUMENTS` is empty or not provided, **default to the current working directory**.

## Your Workflow

### 0. Ensure environment

Check if `~/.geno/geno-media/audiobook/.venv` exists. If not, create it and install dependencies:
```bash
python3 -m venv ~/.geno/geno-media/audiobook/.venv
source ~/.geno/geno-media/audiobook/.venv/bin/activate
pip install "kokoro>=0.9" "misaki[en]" soundfile numpy pyyaml pymupdf
```

Always activate the venv before any python commands:
```bash
source ~/.geno/geno-media/audiobook/.venv/bin/activate
```

### 1. Discover files

Resolve the folder path: if `$ARGUMENTS` is non-empty use it, otherwise use the current working directory. Call the resolved path `ROOT`.

Recursively find all `.md` and `.pdf` files under `ROOT`. Use Glob with patterns like `**/*.md` and `**/*.pdf`.

**Skip these files/folders:**
- Any path containing `.venv/`, `node_modules/`, `__pycache__/`, `.git/`
- Files named `README.md`, `CLAUDE.md`, `MEMORY.md`, `CHANGELOG.md`, `LICENSE.md`
- Files named `audiobook_script.md` or `audiobook_meta.yaml` (these are outputs)
- Files smaller than 500 characters (too short for meaningful audio)
- Any `.md` file that is clearly not prose (e.g., only contains YAML frontmatter, tables, or config)

**Skip files that already have audio:**
- For each candidate file, check if `.wav` files with matching names already exist in the same directory
- Use the naming pattern to detect: e.g., for `Paper.md`, look for `Paper (md) - *.wav`; for `Paper.pdf`, look for `Paper (pdf) - *.wav`
- A file is considered "done" if it already has wav files matching its name pattern. In dual-voice mode, skip only if BOTH the af_heart and a random voice version exist
- If only one voice version exists (e.g., af_heart but no random), generate only the missing one

### 2. Present the plan

Before generating anything, show the user a summary:
- Total files found
- Files that will be skipped (already have audio)
- Files that will be processed, with estimated duration (~150 words/min)
- Total estimated generation time

### 3. Choose profile

Use `AskUserQuestion` to present a selection menu with these options:

1. **"Default — dual voice, strip citations, include PDFs"** — the default profile (see below)
2. **"Single voice — af_heart only"** — one version per file with af_heart, speed 1.0, strip citations, include PDFs
3. **"Custom — let me configure"** — ask the user for voice, speed, citations, and PDF preferences manually
4. **"V2 — sanitized PDFs with af_heart regular + varied"** — Sanitizes PDF text (strips authors, references, footers, numerical data), generates two af_heart versions: regular and varied (blended voice + speed variation), sends iMessage notifications per completion

#### Default profile settings:
- **Voices:** Generate **two versions** of each file — one with `af_heart` and one with a **random voice** (picked per file from the pool below)
- **Speed:** 1.0
- **Strip citations:** yes (`--strip-citations`)
- **Process PDFs:** yes (both `.md` and `.pdf` files are processed)
- **Output naming:** `FileName (md) - VOICE.wav` / `FileName (pdf) - VOICE.wav` (e.g., `SCAN (2018) (md) - af_heart.wav`, `SCAN (2018) (pdf) - am_fenrir.wav`)

#### Random voice pool:
Pick one random voice per file (not af_heart) from:
`af_bella`, `af_sarah`, `af_nova`, `af_sky`, `af_jessica`, `af_kore`, `af_nicole`, `af_river`, `am_adam`, `am_michael`, `am_fenrir`, `am_echo`, `am_eric`, `am_liam`, `am_puck`

#### If "Custom" is selected, ask about:

**Available Kokoro English voices:**

Female: `af_heart` (warm, natural), `af_bella` (clear, professional), `af_sarah` (calm, measured), `af_nova` (bright, energetic), `af_sky` (light, youthful), `af_alloy`, `af_aoede`, `af_jessica`, `af_kore`, `af_nicole`, `af_river`

Male: `am_adam` (clear narrator), `am_michael` (deep, authoritative), `am_fenrir` (strong, dramatic), `am_echo`, `am_eric`, `am_liam`, `am_onyx`, `am_puck`

Speed: 0.8 (slow/deliberate) to 1.2 (brisk). Default 1.0.

Options: same voice for all, random voice per file, dual voice (af_heart + random), or user-assigned voices. Strip citations yes/no. Process PDFs yes/no.

After profile selection, ask the user to confirm the plan before proceeding.

### 3b. V2 Mode (sanitized PDFs)

If the user selects profile 4 (V2), the workflow uses a dedicated batch script that handles sanitization, dual-voice generation, visual descriptions, and notifications.

**V2 scripts:**
- `~/.geno/geno-media/audiobook/batch_pdf_v2.py` — main batch processing script
- `~/.geno/geno-media/audiobook/sanitize_pdf.py` — text sanitization
- `~/.geno/geno-media/audiobook/describe_visuals.py` — figure/table descriptions (optional)

**V2 sanitization** (`sanitize_pdf.py`):
- Strips author names, affiliations, emails from first page
- Removes page headers/footers (detected by repetition across pages)
- Truncates at References/Bibliography section
- Removes Acknowledgments section
- Strips lines of mostly numerical data (table rows)
- Removes URLs, DOIs, arXiv IDs
- Removes LaTeX math artifacts
- Removes copyright notices

**V2 voice versions:**
- **Regular:** `af_heart` at speed 1.0
- **Varied:** `af_heart,af_nicole` blended voice with per-chunk speed variation (0.93x–1.07x sine wave pattern)
- **Output naming:** `FileName (pdf) v2 - af_heart.wav` and `FileName (pdf) v2 - af_heart-varied.wav`

**V2 visual descriptions** (optional, requires `ANTHROPIC_API_KEY`):
- Extracts pages with figures/tables from the PDF
- Sends to Claude Vision API for natural-language descriptions
- Injects descriptions into text where figures/tables are first referenced

**iMessage notifications:**
- Uses `osascript` to send iMessage after each file completes
- Phone number configured in `batch_pdf_v2.py` (`IMESSAGE_PHONE` constant)

**Running V2 mode:**
```bash
source ~/.geno/geno-media/audiobook/.venv/bin/activate
python ~/.geno/geno-media/audiobook/batch_pdf_v2.py "/path/to/root/folder"
```

The batch script handles discovery, skipping already-processed files, sanitization, generation, and notifications internally. You do NOT need to manually loop through files — just invoke the batch script on the root folder.

### 4. Process each file

For each file to process, generate.py expects a `transcript.md` in the target folder. Handle source files like this:

#### For `.md` files:
1. Read the file content — skip if it's mostly code/config/tables (not prose)
2. Temporarily copy it to `transcript.md` in the same folder, run generate.py with `--output` to name the wav, then clean up:

```bash
source ~/.geno/geno-media/audiobook/.venv/bin/activate

# Copy source to transcript.md, generate, clean up
cp "/path/to/folder/Paper Name.md" "/path/to/folder/transcript.md"
python ~/.geno/geno-media/audiobook/generate.py "/path/to/folder" --voice VOICE --speed SPEED --strip-citations --output "Paper Name (md) - VOICE.wav"
rm "/path/to/folder/transcript.md"
```

If the file IS already named `transcript.md`, run generate.py directly without copying.

#### For `.pdf` files:
generate.py auto-detects PDFs when no `transcript.md` exists. Ensure no `transcript.md` is in the folder (rename it temporarily if needed), then:

```bash
python ~/.geno/geno-media/audiobook/generate.py "/path/to/folder" --voice VOICE --speed SPEED --strip-citations --output "Paper Name (pdf) - VOICE.wav"
```

The script will create a `transcript.md` from the PDF automatically. Clean up the generated `transcript.md` afterward if the folder didn't originally have one.

#### Dual-voice mode (default profile):
For each source file, run generate.py **twice** — once with `af_heart` and once with the random voice for that file. Use `--output` to differentiate:
- `"Paper Name (md) - af_heart.wav"` and `"Paper Name (md) - am_fenrir.wav"`
- `"Paper Name (pdf) - af_heart.wav"` and `"Paper Name (pdf) - af_nova.wav"`

When processing a folder with both `.md` and `.pdf`, process the `.md` first (both voices), then the `.pdf` (both voices). Between the md and pdf runs, make sure to remove the temporary `transcript.md` so generate.py picks up the PDF.

#### Progress tracking:
- After each file completes, report: `[3/12] ✓ papers/attention/RULER (2024).md → RULER (2024) (md) - af_heart.wav (4:32)`
- If a file fails, log the error and continue to the next file
- Keep a running tally of successes/failures

### 4b. Incremental upload (runs alongside generation)

By default, start `~/.geno/geno-media/audio-upload/incremental_upload.py` in the background **immediately after generation begins**. This watches for new WAV files, converts them to MP3, and copies to Google Drive as they complete — no need to wait for the full batch.

```bash
python ~/.geno/geno-media/audio-upload/incremental_upload.py "/path/to/root" --pattern "v2" --interval 30 --max-idle 3600 &
```

For non-v2 runs (default/single/custom profiles), omit `--pattern` or use the appropriate filter:
```bash
python ~/.geno/geno-media/audio-upload/incremental_upload.py "/path/to/root" --interval 30 --max-idle 3600 &
```

The uploader:
- Scans for new WAV files every 30 seconds
- Converts WAV→MP3 with ffmpeg (libmp3lame, -qscale:a 2)
- Copies to Google Drive mount at `~/Library/CloudStorage/GoogleDrive-42euge@gmail.com/My Drive/Audiobooks/`
- Preserves directory structure from ROOT
- Tracks uploaded files to avoid re-uploading
- Stops automatically after 1 hour of no new files

### 5. Summary

After all files are processed, show a final summary:

```
Audiobook generation complete!

Processed: 10/12 files
Skipped:   2 (already had audio)
Failed:    0

Total audio: 1h 23m 45s
Total files: 10 WAV files

Files generated:
  docs/research/paper1/Paper Title.wav          (12:34)
  docs/research/paper2/Another Paper.wav        (8:21)
  ...
```

### 6. Verify outputs

For each generated file:
- Confirm the `.wav` exists and has non-zero size
- Check `audiobook_meta.yaml` was created
- Report any anomalies (very short audio for long text, etc.)

## Important Notes

- Kokoro is ~82M params and runs very fast on Apple Silicon (~36x realtime)
- The model generates at 24kHz sample rate
- Process files **sequentially** (not in parallel) to avoid memory issues — Kokoro loads the model once and reuses it across chunks, but running multiple instances could crash the machine
- For very large batches, suggest the user processes in smaller groups
- If a file produces garbled audio (common with PDFs that have lots of math/tables), note it in the summary and suggest the user clean the transcript manually before re-running with `/gt-create-audiobook` on that specific folder
- The `--strip-citations` flag is highly recommended for academic papers
