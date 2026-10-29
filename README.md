# Unofficial Yonsei Graduate School Thesis LaTeX Template

English | [한국어](README.ko.md)

A LaTeX template for **English-language theses and dissertations at Yonsei
University Graduate School**, with a Korean abstract. The layout targets the
2026 English doctoral Word sample, `영문 MSword_박사학위논문_양식_2026.docx`,
distributed with the March 30, 2026 format announcement.

The included example uses the **doctoral** layout. A master's configuration is
also supported by changing the degree level, degree name and committee list.
Build locally or upload the source to Overleaf.

This is an **unofficial** template, not a guarantee of submission acceptance.
Check the latest Graduate School instructions and inspect your final PDF,
especially after changing titles, names or content length.

## Quick start

### Local build

Install Python 3.8+ and a TeX distribution with pdfLaTeX and BibTeX; `latexmk` is
recommended. Full MacTeX or TeX Live installations include the required packages
(`newtx`, `caption`, `geometry`, `CJKutf8`, and Nanum Myeongjo TeX fonts).
On Debian/Ubuntu, `texlive-full` is the simplest option; smaller installations
also need Korean support such as `texlive-lang-korean`.
Install Poppler (`brew install poppler` or `apt install poppler-utils`) for previews.

```sh
git clone https://github.com/codemoo/Unofficial-Latex-Yonsei-Thesis-Template.git
cd Unofficial-Latex-Yonsei-Thesis-Template
# Edit thesis.json and replace the example text before building.
scripts/build.sh
scripts/preview.sh 1-5
```

The build regenerates `front/cover.tex`, `front/signature.tex` and
`front/titlekor.tex` from `thesis.json` and the `.in` templates, then creates
`main.pdf`. It prints errors and selected warnings; also inspect `main.log` and
the PDF, because the filtered output does not catch every layout problem.
Previews are saved in `preview/`. Omit the range to render all pages, or pass a
single page number.

### Docker alternative

Python is still required on the host for metadata generation. With Docker
installed and running:

```sh
docker pull texlive/texlive:latest
USE_DOCKER=1 scripts/build.sh
```

The build automatically uses an already-downloaded image when neither `latexmk`
nor `pdflatex` is available locally. `TEXLIVE_IMAGE` selects another compatible
image; Poppler previews run on the host. For reproducibility, pin your TeX Live
version or image digest rather than relying indefinitely on `latest`.

### Overleaf

1. Download the repository via **Code → Download ZIP**, then choose
   **New Project → Upload Project** in Overleaf.
2. Set the main document to `main.tex`, compiler to **pdfLaTeX**, and TeX Live to
   2023 or newer.
3. Overleaf does not run the metadata scripts. Edit `front/cover.tex` for the
   title, author, degree, dates and advisors; `front/signature.tex` for the
   committee; and `front/titlekor.tex` for the Korean title.
4. Replace the example chapters and abstracts, compile, and inspect the PDF.

Before returning to local builds, copy metadata changes back into `thesis.json`
and structural changes into the `.in` templates. Otherwise the local build will
overwrite your edits to those three generated files.

## Metadata and degree options

[`thesis.json`](thesis.json) is the local source of truth for front-matter metadata.

| Field | Meaning and constraints |
|---|---|
| `title`, `title_kor`, `author` | English/Korean titles and author name. |
| `department`, `degree` | Full department and degree names, including `Department of …` where appropriate. |
| `degree_level` | `doctoral` in the example, or `master`. Set explicitly; omitting it defaults to `master` for compatibility. |
| `degree_month`, `degree_year` | Graduation month and year. Only `February` or `August` is accepted. |
| `supervisors` | Nonempty list of `{ "name": "…", "title": "Professor" }`. The title page prints names, joined with a middle dot for multiple advisors. |
| `committee` | Five entries for doctoral, three for master's. Each has `role`, `title`, and a nonempty `name`; first role `chair`, all others `member`. |

Committee titles must all be `Prof.`, all `Dr.`, or all empty strings for
names-only output. The renderer validates committee count, roles, title
consistency, degree level and month. Metadata is inserted as LaTeX: escape
special characters such as `&` as `\&` (written `\\&` inside JSON).

To switch to **master's**, update all three:

1. Set `degree_level` to `master`.
2. Set `degree` to the appropriate name, e.g. `Master of Science in Mechanical Engineering`.
3. Use three committee members: one chair and two members.

On Overleaf, change the following in `front/cover.tex`, also update `\degree{…}`,
and keep three `\signature{role}{name}` entries in `front/signature.tex`:

```tex
\renewcommand{\thesistypetitle}{Master's Thesis}
\renewcommand{\thesistypelower}{master's thesis}
```

Review the applicable master's sample before submission.

## What to edit

| Content | File or action |
|---|---|
| Front-matter metadata | `thesis.json`; Overleaf alternatives are described above. |
| Acknowledgements | `front/acknowldgment.tex`. Update its example author/date separately; retain the filename used by the template. |
| English abstract | `front/abstract.tex`, ending with `\keywords{…}`. |
| Korean abstract | `back/abstract_kor.tex`, ending with `\keywordskor{핵심되는 말}{…}`. |
| Chapters | `chapters/chapN.tex`, starting with `\chapter{…}`; add an `\include` in `main.tex`. |
| Conclusion | `back/conclusion.tex`. |
| Appendices | `back/appN.tex`; include after `\appendix` in `main.tex`, producing `Appendix 1. …`. |
| References | `main.bib`; style is selected in `biblio.tex` (default: `IEEEtran`). |
| Body size | `\documentclass[10pt]{mitthesis}` in `main.tex`; 11pt is also supported. |
| Shared layout | `mitthesis.cls`; check the official sample before changing layout rules. |

For a signed approval-page scan, save it as `front/signed.pdf`. In
`front/cover.tex.in` (or `front/cover.tex` on Overleaf), comment out
`\input{front/signature}` and uncomment the supplied `\includepdf` line.
Do not publish personal signatures in a public repository.

## Layout implemented

- Order: cover, title, signature, optional acknowledgements, table of contents,
  list of figures, list of tables, English abstract, body, appendices, references,
  Korean abstract.
- A4; top/bottom margins 5.3 cm, left/right margins 3.5 cm; centered page-number
  baseline 3.2 cm from the bottom edge.
- Times-style text and mathematics via `newtx` (a Times-compatible family, not
  the proprietary Times New Roman font itself); Nanum Myeongjo for Korean text.
- Cover title 18pt; title-page/chapter headings 16pt; section headings 13pt;
  body 10pt or 11pt; footnotes 9pt. Body line-spacing multiplier 1.5 and 2em
  paragraph indentation; Korean abstract indentation 1em.
- Degree-specific submission/approval wording, five doctoral or three master's
  signature rows; advisors listed as `Advisor : Name1·Name2`.
- Roman numbering starts at the contents; Arabic numbering restarts at chapter 1.
  Cover through acknowledgements have no printed page numbers.
- Dot-leader contents and lists; headings such as `1. Introduction`; continuous
  figure/table numbering with `<Fig 1>` and `<Table 1>` captions.
- Abstracts with title, body, horizontal rule and keywords; numeric IEEE citations
  and single-spaced reference entries.

The target sample is for an English dissertation. Changing `\headerkor` to
`국문 요약` changes only the Korean abstract heading, not the whole thesis format.

## Before submitting

Inspect the full PDF, not only the first five pages. Check long titles, advisor
and committee names, page order, numbering, figure/table lists, references, Korean
glyphs and clickable contents. Replace all placeholder text and dates.

The class already loads `amsmath`, `amsthm`, `newtxtext`, `newtxmath`, `caption`,
`geometry`, `setspace`, `CJKutf8` and `babel`. Do not add `amssymb` or `amsfonts`;
they conflict with the existing math setup. Korean text belongs inside
`\begin{CJK}{UTF8}{nanummj} … \end{CJK}`; the supplied Korean abstract and
acknowledgements already provide this environment.

See [AGENTS.md](AGENTS.md) for the implementation map and generated-file rules.
Official Graduate School instructions take precedence over this template.

## License and attribution

[`LICENSE`](LICENSE) contains the **LaTeX Project Public License 1.3c**.
[`mitthesis.cls`](mitthesis.cls) also retains the original MIT thesis class's
copyright and permission notice, including its restriction on copies made or
distributed for resale. Read both notices before redistribution. The template's
MIT origin is not a claim that it uses the MIT software license.
