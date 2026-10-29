#!/usr/bin/env bash
# Build main.pdf and surface only errors/warnings (agent-friendly output).
#
# Steps:
#   1. Regenerate front/cover.tex, titlekor.tex, signature.tex from thesis.json.
#   2. Run latexmk if available; else pdflatex + bibtex; else latexmk inside
#      the texlive/texlive Docker image (USE_DOCKER=1 forces this).
#   3. Parse main.log and print just the lines that matter.
#
# Exits non-zero if compilation fails.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# 1. Render metadata
if [ -f thesis.json ] && [ -f front/cover.tex.in ]; then
  if ! command -v python3 >/dev/null 2>&1; then
    echo "build: error: python3 required to render thesis metadata" >&2
    exit 1
  fi
  python3 scripts/render_metadata.py
fi

# 2. Ensure a LaTeX toolchain exists. Append common macOS TeX paths if not
# already in PATH so `pdflatex` is found when called from GUIs.
for p in /Library/TeX/texbin /usr/local/texlive/2024/bin/universal-darwin \
         /usr/local/texlive/2023/bin/universal-darwin; do
  case ":$PATH:" in
    *":$p:"*) ;;
    *) [ -d "$p" ] && PATH="$PATH:$p" ;;
  esac
done
export PATH

have_latexmk=0
use_docker=0
if command -v latexmk >/dev/null 2>&1; then
  have_latexmk=1
elif ! command -v pdflatex >/dev/null 2>&1; then
  # No local TeX: fall back to the texlive/texlive Docker image if present.
  # Override with TEXLIVE_IMAGE=<image>; force it with USE_DOCKER=1.
  TEXLIVE_IMAGE="${TEXLIVE_IMAGE:-texlive/texlive:latest}"
  if command -v docker >/dev/null 2>&1 && docker image inspect "$TEXLIVE_IMAGE" >/dev/null 2>&1; then
    use_docker=1
    have_latexmk=1
  else
    echo "build: error: no latexmk or pdflatex in PATH." >&2
    echo "  Install MacTeX (https://tug.org/mactex) or texlive-full," >&2
    echo "  or 'docker pull texlive/texlive:latest' to build in a container." >&2
    exit 1
  fi
fi
if [ "${USE_DOCKER:-0}" = "1" ]; then use_docker=1; have_latexmk=1; fi

latexmk_cmd() {
  if [ "$use_docker" -eq 1 ]; then
    docker run --rm -u "$(id -u):$(id -g)" -v "$ROOT:/work" -w /work \
      "${TEXLIVE_IMAGE:-texlive/texlive:latest}" latexmk "$@"
  else
    latexmk "$@"
  fi
}

# 3. Compile. Suppress normal chatter; we read main.log afterwards.
set +e
if [ "$have_latexmk" -eq 1 ]; then
  latexmk_cmd -pdf -interaction=nonstopmode -file-line-error main.tex \
    >/dev/null 2>&1
  status=$?
else
  pdflatex -interaction=nonstopmode -file-line-error main.tex >/dev/null 2>&1
  pdflatex_status=$?
  if [ "$pdflatex_status" -eq 0 ] && [ -f main.aux ]; then
    bibtex main >/dev/null 2>&1 || true
    pdflatex -interaction=nonstopmode -file-line-error main.tex \
      >/dev/null 2>&1 || true
    pdflatex -interaction=nonstopmode -file-line-error main.tex \
      >/dev/null 2>&1
    status=$?
  else
    status=$pdflatex_status
  fi
fi
set -e

# 4. Extract the interesting bits of main.log.
if [ -f main.log ]; then
  # Pattern covers: bare "!" errors, file:line: messages, LaTeX/Package
  # warnings and errors, undefined refs, runaway arguments, emergency stops.
  # Overfull/Underfull hbox noise is deliberately excluded.
  grep -E \
    '^(!|.*:[0-9]+:|LaTeX (Warning|Error)|Package .* (Warning|Error)|Undefined control sequence|Runaway argument|Emergency stop)' \
    main.log || true
fi

if [ "$status" -ne 0 ]; then
  echo "---" >&2
  echo "build: FAILED (exit $status). Full log: main.log" >&2
  exit "$status"
fi

echo "build: ok → main.pdf"
