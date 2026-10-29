# 연세대 일반대학원 학위논문 LaTeX 템플릿 (비공식, 2026 양식)
# Unofficial Yonsei Graduate School Thesis LaTeX Template (2026 spec)

연세대학교 일반대학원 학위논문용 비공식 LaTeX 템플릿. 공식 Word 양식
**`영문 MSword_박사학위논문_양식_2026.docx`**(2026-03-30 공지)의 페이지 구성·여백·글꼴
크기·문구를 그대로 따르도록 `mitthesis.cls`를 작성했다. 기본값은 **박사** 양식이며
`thesis.json` 한 줄로 석사로 전환된다. 로컬 스크립트 빌드와 **Overleaf 업로드** 모두 지원.

Unofficial LaTeX template for Yonsei University Graduate School theses, following the
official Word sample **`영문 MSword_박사학위논문_양식_2026.docx`** (announced 2026-03-30)
page by page. Doctoral layout by default; one line in `thesis.json` switches to master's.
Builds locally via `scripts/build.sh` or on **Overleaf** as is.

---

## 시작하기 / Quick start

**로컬 빌드 (권장)**

1. TeX Live 또는 MacTeX (`newtx`, `caption`, `geometry`, `cjk`, 한국어 폰트 `texlive-lang-korean`/Nanum 포함 — texlive-full 권장), `python3` 3.8+, 미리보기용 `poppler`. 로컬 TeX가 없으면 `docker pull texlive/texlive:latest` 만 해두면 `scripts/build.sh`가 컨테이너 안에서 빌드한다.
2. `thesis.json` 편집 — 제목, 저자, 학과, 학위, 지도교수(`supervisors[]`), 인준 위원(`committee[]`), 졸업월/연도, `degree_level`. 위원 수(박사 5 / 석사 3)와 직함 통일(`Prof.`/`Dr.`), 제출월(February/August)은 빌드 시 자동 검증.
3. `scripts/build.sh` — `front/cover.tex`·`signature.tex`·`titlekor.tex`를 렌더한 뒤 `latexmk` 실행. 에러·주요 경고만 출력.
4. `scripts/preview.sh 1-5` 로 표지/제목/인준/감사의 글/차례를 PNG로 확인.

**Overleaf**

1. 이 폴더를 zip으로 묶어 **New Project → Upload Project**. Main document `main.tex`, Compiler **pdfLaTeX**, TeX Live 2023 이상.
2. Overleaf에서는 스크립트를 쓸 수 없으므로 `thesis.json` 대신 생성 파일 `front/cover.tex`(제목·저자·학위·지도교수), `front/signature.tex`(인준 위원), `front/titlekor.tex`(국문 제목)를 직접 편집한다.

**Local build (recommended)**

1. TeX Live or MacTeX (needs `newtx`, `caption`, `geometry`, `cjk` and Korean fonts — texlive-full recommended), `python3` 3.8+, `poppler` for previews. Without a local TeX, `docker pull texlive/texlive:latest` is enough: `scripts/build.sh` builds inside the container.
2. Edit `thesis.json` — title, author, department, degree, `supervisors[]`, `committee[]`, month/year, `degree_level`. Committee size (5 doctoral / 3 master), title consistency (`Prof.`/`Dr.`) and submission month (February/August) are validated at build time.
3. `scripts/build.sh` renders `front/cover.tex`, `signature.tex`, `titlekor.tex` and runs `latexmk`, printing only errors and key warnings.
4. `scripts/preview.sh 1-5` rasterises the cover / title / signature / acknowledgements / TOC pages.

**Overleaf**

1. Zip the folder and upload it (**New Project → Upload Project**); main document `main.tex`, compiler **pdfLaTeX**, TeX Live 2023 or newer.
2. The scripts cannot run on Overleaf, so edit the generated files directly instead of `thesis.json`: `front/cover.tex` (title, author, degree, advisor), `front/signature.tex` (committee), `front/titlekor.tex` (Korean title).

---

## 어디를 고치나 / What to edit

| 내용 / Item | 파일 / File |
|---|---|
| 제목, 저자, 학과, 학위명, 제출 월/연도, 지도교수 / title, author, department, degree, month/year, advisor(s) | `thesis.json` (Overleaf: `front/cover.tex`) |
| 석사 ↔ 박사 / master's ↔ doctoral | `thesis.json` `degree_level` + `committee[]` 3↔5인 + `degree` (Overleaf: `front/cover.tex`의 `\thesistypetitle`/`\thesistypelower`, `front/signature.tex`) |
| 인준 위원 (박사 5인 / 석사 3인) / committee (5 doctoral / 3 master's) | `thesis.json` `committee[]` `{role, title, name}` (Overleaf: `front/signature.tex` — `\signature{Committee Chair}{Prof. Name}` 한 줄씩) |
| 서명본 스캔 삽입 / signed scan | `front/signed.pdf` 저장 후 `front/cover.tex.in`(Overleaf: `front/cover.tex`)에서 `\input{front/signature}` 주석 처리, `\includepdf` 주석 해제 |
| 감사의 글 / acknowledgements | `front/acknowldgment.tex` (파일명 오타는 의도적, 바꾸지 말 것) |
| 영문 초록 / English abstract | `front/abstract.tex` — 마지막에 `\keywords{…}` |
| 국문 제목 / Korean title | `thesis.json` `title_kor` (Overleaf: `front/titlekor.tex`) |
| 국문 초록 / Korean abstract | `back/abstract_kor.tex` — 마지막에 `\keywordskor{핵심되는 말}{…}` |
| 본문 챕터 / chapters | `chapters/chapN.tex` (`\chapter{…}`로 시작) 후 `main.tex`의 `\include` 목록에 추가 |
| 부록 / appendices | `back/appN.tex`, `main.tex`의 `\appendix` 뒤에 `\include` → `Appendix 1. …`로 출력 |
| 참고문헌 / references | `main.bib` (IEEE 스타일 `IEEEtran`; 변경은 `biblio.tex`) |
| 본문 글자 크기 10pt ↔ 11pt | `main.tex` 첫 줄 `\documentclass[10pt]{mitthesis}` |

---

## 2026 양식 반영 사항 / Spec compliance

- **페이지 순서 / order**: Cover → Title → Signature → Acknowledgements → TABLE OF CONTENTS(i) → List of Figures → List of Tables → Abstract → 본문(1, 2, 3 …) → Appendices → References → Abstract in Korean
- **용지·여백 / margins**: A4, 위/아래 5.3cm, 좌/우 3.5cm, 쪽번호 하단 중앙(용지 끝 3.2cm). 표지 제목 6.8cm, 제목 페이지 6.1cm 시작 — Word 표 행 높이 그대로 재현
- **글꼴 / fonts**: Times (newtx). 표지 18pt, 제목 페이지 16pt, 인준서 13pt, 챕터 `1. Introduction` 16pt, 소제목 `1.1 …` 13pt, 본문 10–11pt, 각주 9pt, 행간 1.5, 2칸 들여쓰기, 양쪽 정렬
- **Title page**: `Advisor : 이름·이름`, `A Dissertation Submitted / to the Department of … / and the Committee of the Graduate School / of Yonsei University in Partial Fulfillment of the / Requirements for the Degree of / Doctor of …`, 저자, `February 2026`
- **Signature page**: `This certifies that the dissertation / of NAME is approved.`, 위원별 서명선 + `Committee Chair | Prof. Name` (열 폭 1/4.5/7.5/1cm), 하단 학과·Graduate School·Yonsei University·제출월. 직함은 `Prof.`/`Dr.` 중 하나로 통일하거나 생략
- **TOC**: `TABLE OF CONTENTS` 16pt 중앙, Word 표와 같은 작은 점 리더 + 중앙 정렬 쪽번호 열, `1. Introduction`, `2.1 …`, `Appendix 1. …`, `References`, `Abstract in Korean` (굵게 없음)
- **List of Figures / Tables**: `<Fig 1> …`, `<Table 1> …` (전체 일련번호, 본문 캡션 동일)
- **Abstract**: `Abstract` → 제목 → 본문 → 괘선 + `Keywords : …`; **Abstract in Korean**(보통 굵기) → 국문 제목(나눔명조 Bold) → 본문 → 괘선 + `핵심되는 말 : …` (국문 논문이면 `\renewcommand{\headerkor}{국문 요약}`)
- **References**: 제목 13pt(보통 굵기, 양식과 동일), 항목 10pt 단일 행간, IEEE 스타일 (`[1]`, `[2]` 번호 인용)
- **제출월**: February 또는 August

---

## 주의사항 / Notes

- `front/cover.tex`, `front/signature.tex`, `front/titlekor.tex`는 `scripts/build.sh`가 `thesis.json`에서 **자동 생성**한다. 로컬 빌드 시 직접 고치면 덮어쓰이므로 `thesis.json`이나 `.in` 템플릿을 고칠 것 (Overleaf 전용이면 생성 파일을 직접 편집).
  Those three files are **generated** from `thesis.json` by `scripts/build.sh`; edit `thesis.json` or the `.in` templates (or the generated files when working only on Overleaf).

- `mitthesis.cls`가 `amsmath`, `amsthm`, `newtxtext`/`newtxmath`, `caption`, `geometry`, `setspace`, `CJKutf8`, `babel`을 이미 로드한다. `amssymb`/`amsfonts`는 `newtxmath`와 충돌하므로 추가하지 말 것.
  `mitthesis.cls` already loads those packages; do not add `amssymb`/`amsfonts` (they clash with `newtxmath`).
- 한국어는 `\begin{CJK}{UTF8}{nanummj} … \end{CJK}` 안에서만 쓴다 (`main.tex`의 국문 초록 블록, 감사의 글은 이미 감싸져 있음).
  Korean text must sit inside a CJK environment (the Korean abstract and acknowledgements already are).
- 부록은 Word 양식의 "Order of Manuscript" 규정대로 References 앞에 둔다. 뒤로 보내려면 `main.tex`에서 `\include{biblio}`와 부록 블록 순서만 바꾸면 된다.
  Appendices precede References per the spec's "Order of Manuscript"; swap the two blocks in `main.tex` if your department wants the reverse.

## 라이선스 / License

MIT — see [`LICENSE`](LICENSE). Inherited from the upstream MIT thesis template.

이 템플릿은 **비공식**이다. 최종 제출 전 반드시 일반대학원 행정실에 양식 일치 여부를 확인할 것.
This template is **unofficial**. Always verify formatting compliance with the Graduate School administration before final submission.
