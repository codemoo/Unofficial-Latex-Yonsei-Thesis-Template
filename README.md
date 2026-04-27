# 연세대 일반대학원 학위논문 LaTeX 템플릿 (비공식, 2026 양식)
# Unofficial Yonsei Graduate School Thesis LaTeX Template (2026 spec)

연세대학교 일반대학원 학위논문용 비공식 LaTeX 템플릿. **2026-03-30 공지된 신규 양식**(제출월 2월/8월, `Advisor :` 콜론, `Committee of the Graduate School` 표기, 인준서 소문자 + 마침표, TOC 대소문자 혼용, `Keywords` 표기 등)을 반영했다. MIT `mitthesis` 클래스를 기반으로 연세대 양식에 맞게 수정.

Unofficial LaTeX template for Yonsei University Graduate School theses, updated to the **2026 spec announced on 2026-03-30** (February/August submission month, `Advisor :` colon, `Committee of the Graduate School` wording, lowercase signature page with period, mixed-case TOC, `Keywords`, …). Built on the MIT `mitthesis` class.

---

## LLM 에이전트로 작업 시 / Working with an LLM agent

Claude Code, Cursor, Aider, Codex CLI 등 어떤 에이전트라도 [`AGENTS.md`](AGENTS.md) 한 파일이면 파일 맵, 빌드 명령, 2026 spec 매핑, 흔한 함정 (생성 파일 / `acknowldgment` 오타 / `\makeatletter` scope / 다중 지도교수 한계 등) 을 한 번에 파악할 수 있다.

Any LLM agent (Claude Code, Cursor, Aider, Codex CLI, …) can use [`AGENTS.md`](AGENTS.md) as a self-contained guide covering the file map, build commands, 2026 spec compliance map, and common pitfalls (generated files, the `acknowldgment` filename typo, `\makeatletter` scope, multi-supervisor limits, etc.).


---

## 시작하기

1. **사전 설치**: TeX Live 또는 MacTeX (한국어 폰트 포함 — `texlive-lang-korean` 또는 Nanum), `python3` (3.8+), 그리고 미리보기용 `poppler` (macOS는 `brew install poppler`).
2. **메타데이터 입력**: `thesis.json` 편집 — 제목, 저자, 학과, 학위, 지도교수(`supervisors[]`), 인준 위원(`committee[]`), 졸업월/연도, 학위 유형(`degree_level`). 위원 수와 직함 일치(`Prof.`/`Dr.`)는 빌드 시 자동 검증.
3. **빌드**: `scripts/build.sh` — `thesis.json`에서 `front/cover.tex`를 자동 렌더한 뒤 `latexmk`(또는 `pdflatex`/`bibtex` 폴백) 실행. 에러와 주요 경고만 출력.
4. **검수**: `scripts/preview.sh 1-5` 로 표지/제목/인준/감사의 글/차례 페이지를 PNG로 떠서 확인.

## Quick start

1. **Prerequisites**: TeX Live or MacTeX (with Korean fonts — `texlive-lang-korean` or Nanum), `python3` (3.8+), and `poppler` for previews (`brew install poppler` on macOS).
2. **Set metadata**: edit `thesis.json` — title, author, department, degree, `supervisors[]`, `committee[]`, submission month/year, `degree_level`. Committee count and title consistency (`Prof.`/`Dr.`) are auto-validated at build time.
3. **Build**: `scripts/build.sh` — auto-renders `front/cover.tex` from `thesis.json`, then runs `latexmk` (falls back to `pdflatex`/`bibtex`). Prints only errors and key warnings.
4. **Review**: `scripts/preview.sh 1-5` rasterises the cover / title / signature / acknowledgments / TOC pages as PNGs.

---

## 2026 양식 반영 사항

일반대학원 행정실 2026-03-30 공지된 모든 변경사항을 적용:

- **Cover / Title / Signature** 페이지의 문구·순서를 공식 docx 샘플에 맞춤
- **Title page**: `Advisor :` 콜론, `Committee of the Graduate School` (구 `on Graduate School`), Title Case `Partial Fulfillment of the Requirements for the Degree of`
- **Signature page**: 제목 상단, 소문자 `master's thesis ... is approved.` + 마침표, `Committee Chair / Prof. Name` 2단 layout, 위원 수(석사 3인 / 박사 5인) 및 직함(`Prof.`/`Dr.`) 일관성을 `render_metadata.py`가 자동 검증
- **제출월**: February 또는 August만 허용 (`render_metadata.py`가 그 외엔 빌드 실패)
- **챕터 헤딩**: `1. Introduction` 단일 라인 ("Chapter" 단어 제거 + 마침표 추가); TOC도 동일한 `1.` 형식
- **TOC**: `TABLE OF CONTENTS` 대문자 헤더, `List of Figures / List of Tables / Abstract / References`를 자동 entry로 추가, sub-level 번호 trailing period 없음 (`2.1`, `2.1.1`)
- **`Keywords:`** 붙여쓰기 (구 `Key words`)
- **영문 thesis의 한국어 초록** 헤더는 `Abstract in Korean`, 한국어 thesis는 `\renewcommand{\headerkor}{국문 요약}`로 오버라이드 가능
- **여백**: 본문 위/아래 5.30cm, 좌/우 3.50cm. 표지는 추가 1.5cm (총 6.80cm), 제목 페이지는 추가 0.8cm (총 6.10cm)

**석사 ↔ 박사 전환**은 `thesis.json`에서 `degree_level` 변경 + `committee[]` 항목 수 (석사 3인 → 박사 5인) 조정 + `degree` 갱신만 하면 Title page (`A Master's Thesis Submitted` ↔ `A Dissertation Submitted`)와 Signature (`the master's thesis` ↔ `the dissertation`) 문구가 자동 전환.

## 2026 spec compliance

This template applies the full 2026 spec change list (Graduate School office, 2026-03-30):

- **Cover / Title / Signature** pages match the official Word samples in wording and order.
- **Title page**: `Advisor :` (with colon), `Committee of the Graduate School` (was `on Graduate School`), Title Case `Partial Fulfillment of the Requirements for the Degree of`.
- **Signature page**: thesis title at the top, lowercase `master's thesis ... is approved.` with a period, two-line `Committee Chair / Prof. Name` layout. Committee count (3 master / 5 doctoral) and title consistency (`Prof.`/`Dr.`, no mixing) are validated by `render_metadata.py`.
- **Submission month** restricted to `February` or `August` — `render_metadata.py` fails the build on other values.
- **Chapter heading**: single-line `1. Introduction` (the "Chapter" word is dropped and a period is added after the number); TOC chapter entries match.
- **TOC**: `TABLE OF CONTENTS` uppercase heading; `List of Figures`, `List of Tables`, `Abstract`, and `References` auto-added as TOC entries; trailing period dropped on sub-level numbers (`2.1`, `2.1.1`).
- **`Keywords:`** (concatenated, was `Key words`).
- Korean abstract page header in English-thesis form: `Abstract in Korean`. Override `\headerkor` if writing a Korean-language thesis.
- **Margins**: body 5.30 cm top/bottom, 3.50 cm left/right. The cover page adds 1.5 cm extra at top (total 6.80 cm) and the title page adds 0.8 cm (total 6.10 cm) per the official samples.

The **master ↔ PhD** switch flips `degree_level` in `thesis.json`, resizes `committee[]` (3 entries master, 5 entries doctoral), and updates `degree`. The title page (`A Master's Thesis Submitted` ↔ `A Dissertation Submitted`) and signature page (`the master's thesis` ↔ `the dissertation`) wording follow automatically.

---

## 자주 하는 작업

| 대상 | 위치 |
|---|---|
| 제목 / 저자 / 학과 변경 | `thesis.json` |
| 지도교수 추가·변경 | `thesis.json` `supervisors[]` (다중이면 `·`로 자동 연결, 5명까지 한 줄) |
| 석사 → 박사 | `thesis.json`에서 `degree_level: "doctoral"`, `degree` 갱신, `committee[]` 5인으로 확장 |
| 챕터 추가 | `chapters/chapN.tex` 작성 후 `main.tex`의 `\include` 목록에 추가 |
| 인준서 위원 이름 / 직함 | `thesis.json` `committee[]` (각 항목 `{role, title, name}`. `role`은 `"chair"`(첫번째)/`"member"`. `title`은 `"Prof."`/`"Dr."` 통일 또는 `""` (이름만)) |
| 서명본 PDF 삽입 | 스캔본을 `front/signed.pdf`로 저장 + `front/cover.tex.in`의 `\includepdf` 줄 주석 해제 후 재빌드 |
| 영문 초록 본문 | `front/abstract.tex` |
| 국문 초록 본문 | `back/abstract_kor.tex` (`thesis.json`의 `title_kor`로 한글 제목 설정) |

## Common edits

| Goal | Where |
|---|---|
| Title / author / department | `thesis.json` |
| Add or change supervisor | `thesis.json` `supervisors[]` (multiple auto-joined with `·`, up to 5 fits one line) |
| Master → PhD | In `thesis.json`: `degree_level: "doctoral"`, update `degree`, grow `committee[]` to 5 entries |
| Add a chapter | Create `chapters/chapN.tex`, add to the `\include` list in `main.tex` |
| Committee names / titles | `thesis.json` `committee[]` (each `{role, title, name}`; `role` = `"chair"` for the first entry and `"member"` for the rest; `title` = `"Prof."` / `"Dr."` (consistent across the whole committee) or `""` for names-only) |
| Drop in signed scan | Save scan as `front/signed.pdf`, uncomment the `\includepdf` line in `front/cover.tex.in`, rebuild |
| English abstract body | `front/abstract.tex` |
| Korean abstract body | `back/abstract_kor.tex` (set Korean title via `thesis.json` `title_kor`) |

---

## 주의사항

- `front/cover.tex`, `front/titlekor.tex`, `front/signature.tex` 는 모두 **자동 생성 파일**이다. 직접 수정하지 말고 `thesis.json` 편집 후 재빌드.
- `front/acknowldgment.tex` 파일명은 의도적 오타. 변경하면 `cover.tex.in` 도 같이 고쳐야 한다.
- 한국어 콘텐츠는 `\begin{CJK}{UTF8}{nanummj} ... \end{CJK}` 안에 있어야 함.
- TeX 빌드 시 `Package cmap Warning: fontenc already loaded` 경고는 기존부터 있던 무해한 메시지.

## Notes

- `front/cover.tex`, `front/titlekor.tex`, and `front/signature.tex` are all **generated files**. Don't hand-edit them — edit `thesis.json` (or the `.in` templates for structural changes) and rebuild.
- The `front/acknowldgment.tex` filename is a deliberate misspelling. Renaming requires also updating `cover.tex.in`.
- Korean content must live inside a `\begin{CJK}{UTF8}{nanummj} ... \end{CJK}` block.
- The `Package cmap Warning: fontenc already loaded` message during builds is harmless and pre-existing.

---

## 라이선스 / License

MIT — see [`LICENSE`](LICENSE). Inherited from the upstream MIT thesis template.

이 템플릿은 **비공식**이다. 최종 제출 전 반드시 일반대학원 행정실에 양식 일치 여부를 확인할 것. (사실 도서관에서 양식 안맞으면 전화옴!)

This template is **unofficial**. Always verify formatting compliance with the Graduate School administration before final submission.
