#!/usr/bin/env bash
# geno-media installer
# Sets up ~/.geno/geno-media/ runtime environment, venvs, and Claude Code skills.
#
# Usage:
#   ./install.sh           # full install (venvs + symlinks + configs + commands)
#   ./install.sh --link    # symlinks + configs + commands only (skip venv creation)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_NAME="$(basename "$SCRIPT_DIR")"
RUNTIME_DIR="$HOME/.geno/geno-media"

echo "=== ${REPO_NAME} installer ==="
echo "  Source:  $SCRIPT_DIR"
echo "  Runtime: $RUNTIME_DIR"
echo ""

# ── Install skill ──────────────────────────────────────────
SKILLS_DIR="${HOME}/.claude/skills"
mkdir -p "${SKILLS_DIR}"
ln -sfn "${SCRIPT_DIR}/skills/${REPO_NAME}" "${SKILLS_DIR}/${REPO_NAME}"
echo "  Skill: ${SKILLS_DIR}/${REPO_NAME}"

# ── Install commands ───────────────────────────────────────
CMD_DIR="${HOME}/.claude/commands"
mkdir -p "${CMD_DIR}"
for cmd in "${SCRIPT_DIR}"/commands/gt-*.md; do
    [ -f "$cmd" ] || continue
    name="$(basename "$cmd")"
    ln -sf "$cmd" "${CMD_DIR}/${name}"
    echo "  Command: ${name}"
done

# ── Create directory structure ─────────────────────────────
mkdir -p "$RUNTIME_DIR"/{audiobook,video,tts/profiles,stt}

# ── Symlink source files ──────────────────────────────────
link_file() {
    local src="$1" dst="$2"
    if [ -L "$dst" ]; then
        rm "$dst"
    elif [ -f "$dst" ]; then
        echo "  Backing up existing $dst -> ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi
    ln -s "$src" "$dst"
    echo "  Linked: $(basename "$dst")"
}

echo ""
echo "Linking source files..."
link_file "$SCRIPT_DIR/audiobook/generate.py" "$RUNTIME_DIR/audiobook/generate.py"
link_file "$SCRIPT_DIR/video/align_audio.py"  "$RUNTIME_DIR/video/align_audio.py"
link_file "$SCRIPT_DIR/video/sync_utils.py"   "$RUNTIME_DIR/video/sync_utils.py"
link_file "$SCRIPT_DIR/video/README.md"       "$RUNTIME_DIR/video/README.md"

for profile in "$SCRIPT_DIR"/tts/profiles/*.yaml; do
    [ -f "$profile" ] || continue
    name="$(basename "$profile")"
    link_file "$profile" "$RUNTIME_DIR/tts/profiles/$name"
done

# ── Copy default configs ──────────────────────────────────
copy_default() {
    local src="$1" dst="$2"
    if [ ! -f "$dst" ]; then
        cp "$src" "$dst"
        echo "  Created: $dst (from defaults)"
    else
        echo "  Skipped: $dst (already exists)"
    fi
}

echo ""
echo "Setting up configs..."
copy_default "$SCRIPT_DIR/config/defaults/tts.yaml" "$RUNTIME_DIR/tts/config.yaml"
copy_default "$SCRIPT_DIR/config/defaults/stt.yaml" "$RUNTIME_DIR/stt/config.yaml"

# ── Backward compatibility symlink ─────────────────────────
if [ ! -e "$HOME/.genotools" ]; then
    ln -s "$RUNTIME_DIR" "$HOME/.genotools"
    echo "  Compat symlink: ~/.genotools -> $RUNTIME_DIR"
elif [ -L "$HOME/.genotools" ]; then
    rm "$HOME/.genotools"
    ln -s "$RUNTIME_DIR" "$HOME/.genotools"
    echo "  Updated compat symlink: ~/.genotools -> $RUNTIME_DIR"
fi

# ── Create virtual environments ────────────────────────────
if [ "${1:-}" = "--link" ]; then
    echo ""
    echo "Skipping venv creation (--link mode)."
else
    echo ""
    echo "Setting up virtual environments..."

    # Audiobook venv
    if [ ! -d "$RUNTIME_DIR/audiobook/.venv" ]; then
        echo "  Creating audiobook venv..."
        python3 -m venv "$RUNTIME_DIR/audiobook/.venv"
        "$RUNTIME_DIR/audiobook/.venv/bin/pip" install -q \
            "kokoro>=0.9" "misaki[en]" soundfile numpy pyyaml
        echo "  Audiobook venv ready."
    else
        echo "  Audiobook venv already exists."
    fi

    # Video venv
    if [ ! -d "$RUNTIME_DIR/video/.venv" ]; then
        echo "  Creating video venv..."
        python3 -m venv "$RUNTIME_DIR/video/.venv"
        "$RUNTIME_DIR/video/.venv/bin/pip" install -q \
            manim "stable-ts[mlx]" pyyaml
        echo "  Video venv ready."
    else
        echo "  Video venv already exists."
    fi
fi

# ── System dependencies check ──────────────────────────────
echo ""
echo "Checking system dependencies..."
missing=()
for cmd in ffmpeg cairo-trace pango-view; do
    if ! command -v "$cmd" &>/dev/null; then
        case "$cmd" in
            cairo-trace) missing+=("cairo") ;;
            pango-view)  missing+=("pango") ;;
            *)           missing+=("$cmd") ;;
        esac
    fi
done

if [ ${#missing[@]} -gt 0 ]; then
    echo "  Missing: ${missing[*]}"
    echo "  Install with: brew install ${missing[*]}"
else
    echo "  All system dependencies found."
fi

echo ""
echo "Done."
