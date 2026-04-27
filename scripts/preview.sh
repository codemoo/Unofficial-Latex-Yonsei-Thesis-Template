#!/usr/bin/env bash
# Rasterize main.pdf pages to PNGs under preview/ so an LLM agent with
# image-read support (e.g. Claude Code) can inspect layout.
#
# Usage:
#   scripts/preview.sh               # render all pages
#   scripts/preview.sh 3             # render only page 3
#   scripts/preview.sh 1-5           # render pages 1 through 5
#
# Requires poppler's pdftoppm (brew install poppler on macOS).

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if ! command -v pdftoppm >/dev/null 2>&1; then
  echo "preview: error: pdftoppm not found. Install poppler:" >&2
  echo "  macOS:  brew install poppler" >&2
  echo "  Debian: apt install poppler-utils" >&2
  exit 1
fi

if [ ! -f main.pdf ]; then
  echo "preview: error: main.pdf not found. Run scripts/build.sh first." >&2
  exit 1
fi

mkdir -p preview
rm -f preview/page-*.png

args=(-png -r 120)
range="${1:-}"
if [ -n "$range" ]; then
  if [[ "$range" == *-* ]]; then
    args+=(-f "${range%-*}" -l "${range#*-}")
  else
    args+=(-f "$range" -l "$range")
  fi
fi

pdftoppm "${args[@]}" main.pdf preview/page

count=$(find preview -maxdepth 1 -name 'page-*.png' | wc -l | tr -d ' ')
echo "preview: rendered $count page(s) → preview/"
