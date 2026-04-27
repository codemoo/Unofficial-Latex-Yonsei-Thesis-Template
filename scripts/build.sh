#!/usr/bin/env bash
# Build main.pdf and surface only errors/warnings (agent-friendly output).
#
# Steps:
#   1. Regenerate front/cover.tex and front/titlekor.tex from thesis.json.
#   2. Run latexmk if available; otherwise fall back to pdflatex + bibtex.
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
if command -v latexmk >/dev/null 2>&1; then
  have_latexmk=1
elif ! command -v pdflatex >/dev/null 2>&1; then
  echo "build: error: no latexmk or pdflatex in PATH." >&2
  echo "  Install MacTeX (https://tug.org/mactex) or texlive-full." >&2
  exit 1
fi

# 3. Compile. Suppress normal chatter; we read main.log afterwards.
set +e
if [ "$have_latexmk" -eq 1 ]; then
  latexmk -pdf -interaction=nonstopmode -file-line-error main.tex \
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
