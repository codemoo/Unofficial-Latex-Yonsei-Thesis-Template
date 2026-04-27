# Agent guide

A practical map of this repo for any LLM-based coding agent (Claude Code,
Cursor, Aider, Codex CLI, etc.). Read this before changing anything.

## What this repo produces

A PDF thesis (`main.pdf`) for the **Yonsei University Graduate School 2026
spec**, built from a customised MIT `mitthesis` LaTeX class. Master's
program by default; doctoral via one flag in `thesis.json`. English thesis
with a Korean abstract appendix is the assumed shape, but the cls supports
either.

## TL;DR — the only commands you usually need

```sh
# 1. Edit per-thesis metadata (title, author, supervisors, …):
#    thesis.json  ← single source of truth

# 2. Build (renders metadata, runs latexmk, prints only errors/warnings):
scripts/build.sh

# 3. Inspect specific pages as PNGs (so you can Read them as images):
scripts/preview.sh 1-5      # cover/title/signature/ack/TOC
scripts/preview.sh 8         # English abstract
scripts/preview.sh           # all pages
```

`scripts/build.sh` automatically regenerates `front/cover.tex` and
`front/titlekor.tex` from `thesis.json` before compiling. You only run
`python3 scripts/render_metadata.py` manually if you skip `build.sh`.

## File map

| Path | What it is | Edit it? |
|---|---|---|
| `main.tex` | Root document. `\include`s front matter, chapters, back matter, biblio, Korean abstract. | Yes (chapter list around lines 72–77). |
| `mitthesis.cls` | Customised thesis class. Defines `\maketitle`, `\makecover`, `\signature`, `\abstractpage`, `\abstractpagekor`, advisor accumulator, margins. | Carefully — this is shared infrastructure. |
| `thesis.json` | Per-thesis metadata: title, title_kor, author, department, degree, degree_month/year, supervisors[], committee[], degree_level. **Single source of truth for cover, title, and signature pages.** | Yes — primary edit point. |
| `front/cover.tex.in` | Template for `cover.tex`. `@@TOKEN@@` placeholders substituted by `render_metadata.py`. | Only for structural changes. |
| `front/cover.tex` | **GENERATED** from `cover.tex.in` + `thesis.json`. | Never hand-edit — overwritten on build. |
| `front/titlekor.tex` | **GENERATED**. Contains `\newcommand{\titlekor}{…}`. `\input` from inside the CJK environment in `main.tex`. | Never hand-edit. |
| `front/signature.tex.in` | Template for the signature page. `@@COMMITTEE_BLOCKS@@` is substituted by `render_metadata.py` based on `committee[]` in `thesis.json`. | Only for structural changes. |
| `front/signature.tex` | **GENERATED** from `signature.tex.in` + `thesis.json`. Committee names, roles, titles all come from `thesis.json` `committee[]`. | Never hand-edit. |
| `front/contents.tex` | TOC heading (`TABLE OF CONTENTS` uppercase) + `\addcontentsline` calls so `List of Figures`, `List of Tables`, `Abstract` show up. | Carefully. |
| `front/abstract.tex` | English abstract body + `Keywords:` line. | Yes (replace lorem ipsum). |
| `front/acknowldgment.tex` | Acknowledgments body (filename **misspelled** intentionally — referenced from `cover.tex.in`; do NOT rename). | Yes. |
| `chapters/chap*.tex` | Body chapters. Add new ones with `\include{chapters/chapN}` in `main.tex`. | Yes. |
| `back/abstract_kor.tex` | Korean abstract body. Wrapped in CJK environment in `main.tex`. | Yes. |
| `back/conclusion.tex`, `back/appa.tex`, `back/appb.tex` | Conclusion + appendices. | Yes. |
| `biblio.tex` | `\bibliography{main}` + style. | Carefully. |
| `main.bib` | BibTeX entries. | Yes. |
| `scripts/build.sh` | Render metadata + run latexmk (or pdflatex/bibtex fallback) + filter `main.log` to errors/important warnings only. Exits non-zero on failure. | Carefully. |
| `scripts/preview.sh` | `pdftoppm` wrapper → `preview/page-NN.png`. Accepts no arg / `N` / `N-M`. | Yes. |
| `scripts/render_metadata.py` | Stdlib-only Python; reads `thesis.json`, validates, writes `cover.tex` and `titlekor.tex`. | Yes. |
| `preview/` | Rasterised pages (gitignored). | Throwaway. |
| `CLAUDE.md` | Local Claude-specific notes (gitignored). | Maintained per-machine. |

## Editing flows by intent

| Goal | Action |
|---|---|
| Change title / author / department / dates | Edit `thesis.json` → `scripts/build.sh`. |
| Add/remove a supervisor | Edit `thesis.json` `supervisors[]` (each `{name, title}`) → build. Multiple names auto-join with `·` (no space) on the title page. |
| Switch master ↔ PhD | `thesis.json`: set `degree_level` to `"master"` or `"doctoral"`, update `degree` (e.g. `"Doctor of Philosophy in …"`), and grow `committee[]` from 3 entries (master = chair + 2 members) to 5 entries (doctoral = chair + 4 members). The renderer enforces the count and the cls flips Title page (`A Master's Thesis Submitted` / `A Dissertation Submitted`) and Signature page (`the master's thesis` / `the dissertation`) wording automatically. |
| Edit committee names / titles on signature page | `thesis.json` `committee[]` — each entry is `{role, title, name}` where `role` is `"chair"` for the first entry and `"member"` for the rest, `title` is `"Prof."` / `"Dr."` (must be the same across the whole committee — no mixing) or `""` (names only, per the digital-approval spec), `name` is the signer's full name. |
| Add a chapter | Create `chapters/chapN.tex` starting with `\chapter{...}`, then add `\include{chapters/chapN}` in `main.tex` near lines 72–77. |
| Drop in a signed signature scan | Save scan as `front/signed.pdf`, uncomment the `\includepdf` line in `front/cover.tex.in`, rebuild. |
| Adjust English abstract | `front/abstract.tex`. |
| Adjust Korean abstract | `back/abstract_kor.tex` (content), `thesis.json` `title_kor` (Korean title). |
| Verify a layout change | `scripts/build.sh && scripts/preview.sh <page-or-range>` and Read the resulting PNGs. |

## Spec compliance map (Yonsei 2026)

Where each official 2026 change is enforced. Before changing anything in
this list, check the official Word samples in the spec announcement
(forwarded by lab admin 2026-03-30) — they are authoritative.

| Spec item | Where enforced |
|---|---|
| Cover wording/order: `[Title] / [Author] / [Department] / Graduate School / Yonsei University` | `mitthesis.cls` `\makecover` |
| Title page `Advisor :` (with colon) | `mitthesis.cls` `\maketitle` + `\@advisornames` accumulator in `\supervisor` |
| Title page `Committee of the Graduate School` (was “Committee on…”) | `mitthesis.cls` `\maketitle` |
| Title page `A Master's Thesis Submitted` / `A Dissertation Submitted` | `\thesistypetitle` (cls default + cover.tex `\renewcommand` from JSON) |
| Title page Title Case (`Partial Fulfillment of the Requirements for the Degree of`) | `mitthesis.cls` `\maketitle` |
| Submission month February or August (only) | `scripts/render_metadata.py` fails if `degree_month` is anything else |
| Signature page lowercase `master's thesis ... is approved.` (period added) | `front/signature.tex.in` + `\thesistypelower` |
| Signature `Committee Chair / Prof. Name` two-line layout | `mitthesis.cls` `\signature{role}{name}` (renders #2 below #1 if non-empty) |
| Signature titles unified `Prof.` or `Dr.` | `render_metadata.py` enforces — all entries in `committee[]` must share the same `title` value |
| Signature committee count (3 master / 5 doctoral) | `render_metadata.py` enforces from `degree_level` |
| TOC heading uppercase `TABLE OF CONTENTS` | `front/contents.tex` `\renewcommand{\contentsname}{...}` |
| TOC entries mixed case (`List of Figures`, `Abstract`) and no trailing period on subsection numbers | LaTeX defaults; `\addcontentsline` calls in `front/contents.tex` and `\abstractpage` |
| `Keywords:` (concatenated, was `Key words`) | `front/abstract.tex` placeholder |
| English abstract page = `Abstract` + title + body (no MIT preamble) | `mitthesis.cls` `\abstractpage` |
| Korean abstract page header `Abstract in Korean` (English-thesis form) | `mitthesis.cls` `\headerkor` (`\renewcommand{\headerkor}{국문 요약}` for Korean theses) |
| Margins: top/bottom 5.30 cm, L/R 3.50 cm (cover page +1.5 cm extra top to reach 6.8 cm; title page +0.8 cm to reach 6.1 cm) | `mitthesis.cls` `\setlength{\topmargin}{1.087in}` etc.; `\vspace*` overrides in `\makecover` and `\maketitle` |
| Chapter heading single-line `1. Introduction` (drop "Chapter" word, add period after number); TOC chapter entry `1. Introduction` with period | `mitthesis.cls` `\@makechapterhead` + `\l@chapter` overrides |
| Pagination i, ii, iii … through abstract; 1, 2, 3 … from chapter 1 | `front/cover.tex.in` `\pagenumbering{roman}` then `main.tex` `\pagenumbering{arabic}` after `\include{front/cover}` |

## Gotchas

- **Generated files**: `front/cover.tex`, `front/titlekor.tex`, and
  `front/signature.tex` are produced by `scripts/render_metadata.py`. They
  have a `% GENERATED` header. Hand-edits will be silently overwritten on
  next build. Edit the `.in` templates and `thesis.json` instead.
- **Filename typo**: `front/acknowldgment.tex` is misspelled. Do not “fix”
  it without also patching `cover.tex.in`.
- **Internal `@` macros**: `\@title`, `\@author`, `\@department`,
  `\@degreemonth`, `\@degreeyear` are LaTeX-internal. Outside the `.cls`,
  wrap their use in `\makeatletter ... \makeatother` (see
  `front/signature.tex:14,43`).
- **CJK scope**: Korean content must sit inside `\begin{CJK}{UTF8}{nanummj}
  ... \end{CJK}`. The `\titlekor` macro is `\input`-ed inside the CJK env in
  `main.tex` so its UTF-8 bytes get tokenised under the Nanum font.
- **`\signature{role}{name}`**: the cls renders `#2` only if non-empty.
  Legacy single-arg call sites pass `{}` for `#2` and still work.
- **Multi-supervisor**: names auto-join with `·` (U+00B7) and no spaces.
  Tested up to 5 names on a single 14 cm-wide line. Six+ may wrap; if it
  does, hand-format in `\maketitle` or shorten names.
- **`degree_level`**: optional in `thesis.json`. Defaults to `"master"`.
  Valid values: `"master"`, `"doctoral"`. Anything else makes
  `render_metadata.py` exit 1.
- **`degree_month`**: spec restricts to `February` or `August`. Other
  values cause `render_metadata.py` to exit 1.
- **`committee[]`**: required. Length must be exactly 3 (master) or 5
  (doctoral). `committee[0].role` must be `"chair"`; the rest are
  `"member"`. All `title` values must be identical and one of `"Prof."`,
  `"Dr."`, or `""` (empty, names-only mode for the digital approval flow).
- **TeX toolchain**: Needs MacTeX or texlive-full + Korean fonts
  (`texlive-lang-korean` or just Nanum installed). `scripts/build.sh`
  auto-prepends common macOS TeX paths (`/Library/TeX/texbin`).
- **Cmap warning** `Package cmap Warning: fontenc already loaded` is
  harmless and pre-existing.

## What NOT to do

- Don’t edit `front/cover.tex` or `front/titlekor.tex` directly.
- Don’t rename `front/acknowldgment.tex`.
- Don’t commit `preview/` or `*.pdf` build artifacts (already gitignored).
- Don’t bypass `scripts/build.sh` for routine builds — its log filter
  catches errors that scroll past a raw `latexmk` run.
- Don’t change cls margins, page numbering, or wording without checking
  the spec compliance map above and the Word samples first.

## Validation checklist before submission

After any change, run:

```sh
scripts/build.sh                  # must exit 0
scripts/preview.sh 1-5            # cover, title, signature, ack, TOC
```

Read the PNGs and confirm:
1. Cover: title at top, author centered, `[Department] / Graduate School / Yonsei University` at bottom.
2. Title: `Advisor : ...` colon-spaced; `A Master's Thesis Submitted to the [Department] and the Committee of the Graduate School of Yonsei University in Partial Fulfillment of the Requirements for the Degree of [Degree]`; February/August year at bottom.
3. Signature: title at top; `This certifies that the master's thesis of [Name] is approved.` lowercase + period; Committee Chair / Member each with `Prof.` or `Dr.` (consistent); department + Graduate School + Yonsei University + month/year at bottom.
4. TOC: `TABLE OF CONTENTS` uppercase heading; `List of Figures`, `List of Tables`, `Abstract` each with roman page numbers.
5. PhD only: `A Dissertation Submitted` / `the dissertation` wording, 5-committee-member layout active.

## External authoritative sources

- **Email** from 일반대학원 행정실 dated 2026-03-30 announcing the format
  changes (forwarded by lab admin Bogyeong Suh / 서보경).
- **Official Word samples** distributed with that email:
  `석사학위 논문양식_2026.zip` and `박사학위 논문양식_2026.zip`. These are
  the ground truth for layout, wording, and pagination.
- This repo is unofficial — verify with the graduate school administration
  before final submission.
