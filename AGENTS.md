# Agent guide

A practical map of this repo for any LLM-based coding agent (Claude Code,
Cursor, Aider, Codex CLI, etc.). Read this before changing anything.

## What this repo produces

A PDF thesis (`main.pdf`) for the **Yonsei University Graduate School 2026
spec**, built from `mitthesis.cls` — a class rewritten to follow the
official English doctoral Word sample
(`영문 MSword_박사학위논문_양식_2026.docx`) page by page: Times (newtx),
exact row heights of the cover / title / signature tables, 10 pt body,
`<Fig 1>` captions, dot-leader TOC, `Appendix 1.` appendices. Doctoral
program by default; master's via one flag in `thesis.json`. English
thesis with a Korean abstract at the end is the assumed shape. The tree
also compiles unchanged on Overleaf (edit the generated files there).

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

`scripts/build.sh` automatically regenerates `front/cover.tex`,
`front/titlekor.tex` and `front/signature.tex` from `thesis.json` before
compiling. You only run `python3 scripts/render_metadata.py` manually if
you skip `build.sh`. With no local TeX, `build.sh` runs `latexmk` inside
the `texlive/texlive:latest` Docker image if it is pulled (`USE_DOCKER=1`
forces this).

## File map

| Path | What it is | Edit it? |
|---|---|---|
| `main.tex` | Root document (`\documentclass[10pt]`, 11pt also allowed). `\include`s front matter, chapters, conclusion, `\appendix` + appendices, biblio, Korean abstract. Loads only extra packages (graphicx, booktabs, siunitx, algorithm, pdfpages, hyperref). | Yes (chapter list). |
| `mitthesis.cls` | Thesis class (Yonsei 2026). Loads fonts (newtx = Times), geometry, setspace, caption, CJKutf8, babel. Defines `\makecover`, `\maketitle`, `signpage` + `\signpagehead`/`\signature`/`\signpagefoot`, `abstractpage`/`abstractpagekor` + `\keywords`/`\keywordskor`, `\frontheading`/`\frontheadingplain`/`\centerheading`, heading/TOC/LoF formats, `\appendix`. All font sizes live in one block near the top (`\yonsei@size*`). | Carefully — this is shared infrastructure. |
| `thesis.json` | Per-thesis metadata: title, title_kor, author, department, degree, degree_month/year, supervisors[], committee[], degree_level. **Single source of truth for cover, title, and signature pages.** | Yes — primary edit point. |
| `front/cover.tex.in` | Template for `cover.tex`. `@@TOKEN@@` placeholders substituted by `render_metadata.py`. | Only for structural changes. |
| `front/cover.tex` | **GENERATED** from `cover.tex.in` + `thesis.json`. | Never hand-edit — overwritten on build. |
| `front/titlekor.tex` | **GENERATED**. Contains `\newcommand{\titlekor}{…}`. `\input` from inside the CJK environment in `main.tex`. | Never hand-edit. |
| `front/signature.tex.in` | Template for the signature page. `@@COMMITTEE_BLOCKS@@` is substituted by `render_metadata.py` based on `committee[]` in `thesis.json`. | Only for structural changes. |
| `front/signature.tex` | **GENERATED** from `signature.tex.in` + `thesis.json`. Committee names, roles, titles all come from `thesis.json` `committee[]`. | Never hand-edit. |
| `front/contents.tex` | `\tableofcontents` + `\addcontentsline` calls so `List of Figures`, `List of Tables` show up (heading and entry formats live in the cls). | Carefully. |
| `front/abstract.tex` | English abstract body, ending with `\keywords{…}` (prints the full-width rule + `Keywords :`). | Yes (replace lorem ipsum). |
| `front/acknowldgment.tex` | Acknowledgments body (filename **misspelled** intentionally — referenced from `cover.tex.in`; do NOT rename). | Yes. |
| `chapters/chap*.tex` | Body chapters. Add new ones with `\include{chapters/chapN}` in `main.tex`. | Yes. |
| `back/abstract_kor.tex` | Korean abstract body, ending with `\keywordskor{핵심되는 말}{…}`. Wrapped in CJK environment in `main.tex`. | Yes. |
| `back/conclusion.tex`, `back/appa.tex`, `back/appb.tex` | Conclusion (numbered chapter) + appendices (`\chapter{…}` after `\appendix` renders as `Appendix 1. …`). | Yes. |
| `biblio.tex` | `\bibliography{main}` + style. | Carefully. |
| `main.bib` | BibTeX entries. | Yes. |
| `scripts/build.sh` | Render metadata + run latexmk (or pdflatex/bibtex fallback) + filter `main.log` to errors/important warnings only. Exits non-zero on failure. | Carefully. |
| `scripts/preview.sh` | `pdftoppm` wrapper → `preview/page-NN.png`. Accepts no arg / `N` / `N-M`. | Yes. |
| `scripts/render_metadata.py` | Stdlib-only Python; reads `thesis.json`, validates, writes `cover.tex`, `titlekor.tex`, `signature.tex`. | Yes. |
| `preview/` | Rasterised pages (gitignored). | Throwaway. |
| `CLAUDE.md` | Local Claude-specific notes (gitignored). | Maintained per-machine. |

## Editing flows by intent

| Goal | Action |
|---|---|
| Change title / author / department / dates | Edit `thesis.json` → `scripts/build.sh`. |
| Add/remove a supervisor | Edit `thesis.json` `supervisors[]` (each `{name, title}`) → build. Multiple names auto-join with `·` (no space) on the title page. |
| Switch PhD ↔ master | `thesis.json`: set `degree_level` to `"doctoral"` (default) or `"master"`, update `degree` (e.g. `"Master of Science in …"`), and resize `committee[]` between 5 entries (doctoral = chair + 4 members) and 3 entries (master = chair + 2 members). The renderer enforces the count and the cls flips Title page (`A Master's Thesis Submitted` / `A Dissertation Submitted`) and Signature page (`the master's thesis` / `the dissertation`) wording automatically. |
| Edit committee names / titles on signature page | `thesis.json` `committee[]` — each entry is `{role, title, name}` where `role` is `"chair"` for the first entry and `"member"` for the rest, `title` is `"Prof."` / `"Dr."` (must be the same across the whole committee — no mixing) or `""` (names only, per the digital-approval spec), `name` is the signer's full name. |
| Add a chapter | Create `chapters/chapN.tex` starting with `\chapter{...}`, then add `\include{chapters/chapN}` in `main.tex` before `\include{back/conclusion}`. |
| Add an appendix | Create `back/appN.tex` starting with `\chapter{...}` and `\include` it after `\appendix` in `main.tex`. Renders as `Appendix N. Title` (heading and TOC). |
| Drop in a signed signature scan | Save scan as `front/signed.pdf`; in `front/cover.tex.in` comment out `\input{front/signature}` and uncomment the `\includepdf` line; rebuild. |
| Adjust English abstract | `front/abstract.tex`. |
| Adjust Korean abstract | `back/abstract_kor.tex` (content), `thesis.json` `title_kor` (Korean title). |
| Verify a layout change | `scripts/build.sh && scripts/preview.sh <page-or-range>` and Read the resulting PNGs. |
| Change a font size | The `\yonsei@size*` block near the top of `mitthesis.cls` (18 cover / 16 title+chapter / 13 subheadings), `\footnotesize` (9), body via `\documentclass[10pt]`. |
| Change the figure/table label style (`<Fig 1>`) | `mitthesis.cls` caption block (`\DeclareCaptionLabelFormat{yonsei}`) and `\yonsei@listline`. |

## Spec compliance map (Yonsei 2026)

Where each requirement of the official doctoral Word sample is enforced.
Before changing anything here, re-check the sample
(`영문 MSword_박사학위논문_양식_2026.docx` / master's zip from the
2026-03-30 announcement) — it is authoritative.

| Spec item | Where enforced |
|---|---|
| Page order: Cover / Title / Signature / Acknowledgements / TOC / LoF / LoT / Abstract / Text / Appendices / References / Abstract in Korean | `front/cover.tex.in` then `main.tex` |
| A4; margins top/bottom 5.3 cm, L/R 3.5 cm; page number centred, 3.2 cm from paper edge | `mitthesis.cls` `geometry` options (`footskip=2.1cm`) |
| Times New Roman | `mitthesis.cls` `newtxtext`/`newtxmath` |
| Body 10 or 11 pt, 1.5 line spacing, 2-space paragraph indent (2em; Korean abstract 1em), justified; footnotes 9 pt | `main.tex` class option; `mitthesis.cls` `\setstretch`, `\parindent`, `\footnotesize` |
| Cover: title 18 pt bold at 6.8 cm; author; `Department / Graduate School / Yonsei University` at the bottom (rows 1.5/4.75/3.85/8.9 cm) | `mitthesis.cls` `\makecover` |
| Title page: 16 pt bold; title at 6.1 cm; `Advisor : A·B`; `A Dissertation Submitted … Requirements for the Degree of …`; author; month year (rows 0.8/3.4/1.2/1.0/6.0/1.7/3.7/1.0 cm) | `mitthesis.cls` `\maketitle` + `\supervisor` accumulator; wording from `\thesistypetitle` |
| Submission month February or August only | `scripts/render_metadata.py` |
| Signature page: 13 pt bold; `This certifies that the dissertation / of NAME is approved.`; per member a 1 cm signature line + 1 cm `Committee Chair | Prof. Name` row, columns 1/4.5/7.5/1 cm; footer dept / Graduate School / Yonsei University / month year | `mitthesis.cls` `signpage`, `\signpagehead`, `\signature`, `\signpagefoot`; `front/signature.tex.in` |
| Signature titles unified `Prof.` / `Dr.` / none; count 3 master / 5 doctoral | `render_metadata.py` |
| `TABLE OF CONTENTS` 16 pt centred, page i; entries not bold, small-dot leaders, page number centred in a 1 cm column, rows 0.78 cm; `1. Introduction`, `2.1` / `2.2.1` (no trailing period) stepped 13/26 pt; `Appendix 1. …` | `mitthesis.cls` `\tableofcontents`, `\yonsei@tocline`, `\l@chapter/section/subsection`; `front/cover.tex.in` `\pagenumbering{roman}` |
| `List of Figures` / `List of Tables` 13 pt bold headings; entries `<Fig 1> …`, `<Table 1> …` with the same dot leaders | `mitthesis.cls` `\@makeschapterhead`, `\yonsei@listline`; `front/contents.tex` |
| Figure/table captions `<Fig 1>`, `<Table 1>`, continuous numbering, body size | `mitthesis.cls` caption setup, `\counterwithout` |
| Abstract: `Abstract` 13 pt bold left → title 13 pt bold centred → body → full-width rule + `Keywords : …` | `mitthesis.cls` `abstractpage`, `\keywords`; `front/abstract.tex` |
| Acknowledgements (optional, free-form): 16 pt bold centred heading like the TOC | `front/cover.tex.in` `\centerheading` |
| Chapter heading `1. Introduction` 16 pt bold, one line; sections `1.1 …` 13 pt bold indented 13 pt, subsections 26 pt; first paragraph after every heading indented | `mitthesis.cls` `\@makechapterhead`, `\section` (positive before-skip), `\@afterindenttrue` |
| Appendices `Appendix 1. Title` (heading and TOC) | `mitthesis.cls` `\appendix`, `\@chapter` |
| `References` 13 pt **regular** heading, body-size single-spaced entries, IEEE style, TOC entry | `biblio.tex` (`IEEEtran`); `thebibliography` and `\bibname` (via `\addto\captionsenglish`) in the cls |
| `Abstract in Korean` 13 pt regular → Korean title 13 pt (Nanum Myeongjo Bold) → body (1em indent) → full rule + `핵심되는 말 : …` | `mitthesis.cls` `abstractpagekor`, `\keywordskor`; `back/abstract_kor.tex`; `\headerkor` (`국문 요약` for Korean theses) |
| Pagination i, ii, … from TOC through abstract; 1, 2, … from chapter 1; cover/title/signature/acknowledgements unnumbered | `front/cover.tex.in` + `main.tex` |

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
- **Fonts/packages**: the cls loads `amsmath`, `amsthm`, `newtxtext`,
  `newtxmath`, `caption`, `geometry`, `setspace`, `CJKutf8`, `babel`.
  Never add `amssymb`/`amsfonts` to `main.tex` (clash with newtxmath).
  `hyperref` is loaded last in `main.tex`. Do not use `tabu` (broken on
  current TeX Live); plain `tabular`/`booktabs` is fine.
- **babel resets names**: `\contentsname`, `\bibname`, `\figurename`,
  etc. are set inside `\addto\captionsenglish` in the cls. A plain
  `\renewcommand` in the preamble is overwritten at `\begin{document}`.
- **Fixed-layout pages** (cover, title, signature) use `\setstretch{1}`,
  `\offinterlineskip` and `\yonsei@topgap` so that the Word row heights
  add up exactly; the title page has a `\vskip 3.7cm minus 1cm` that
  absorbs overflow from a long title or degree name. If a page still
  spills, shorten the title before touching the row heights.
- **`\keywords` / `\keywordskor`** end the abstracts; they `\vfill` to the
  foot of the page, so put nothing after them.
- **Overleaf**: the scripts cannot run there, so users edit the generated
  `front/cover.tex`, `front/signature.tex`, `front/titlekor.tex` directly.
  Keep those files committed and compilable.

## What NOT to do

- Don’t edit `front/cover.tex`, `front/titlekor.tex` or `front/signature.tex` directly (unless working only on Overleaf).
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
1. Cover: title (18 pt) at top, author centered, `[Department] / Graduate School / Yonsei University` at bottom; nothing spills to a second page.
2. Title: `Advisor : ...`; `A Dissertation Submitted to the [Department] and the Committee of the Graduate School of Yonsei University in Partial Fulfillment of the Requirements for the Degree of [Degree]`; author; February/August year at the bottom of the same page.
3. Signature: title at top; `This certifies that the dissertation of [Name] is approved.`; 5 (doctoral) or 3 (master) signature lines with `Committee Chair` / `Committee Member` beside `Prof. Name`; department + Graduate School + Yonsei University + month/year at bottom.
4. TOC (page i): `TABLE OF CONTENTS` centred; `List of Figures`, `List of Tables`, `Abstract` with roman numbers; `1. Introduction`, `Appendix 1. …`, `References`, `Abstract in Korean`; no bold, dot leaders.
5. Master's only: `A Master's Thesis Submitted` / `the master's thesis` wording, 3-member layout.

## External authoritative sources

- **Email** from 일반대학원 행정실 dated 2026-03-30 announcing the format
  changes (forwarded by lab admin Bogyeong Suh / 서보경).
- **Official Word samples** distributed with that email:
  `석사학위 논문양식_2026.zip` and `박사학위 논문양식_2026.zip`. These are
  the ground truth for layout, wording, and pagination.
- This repo is unofficial — verify with the graduate school administration
  before final submission.
