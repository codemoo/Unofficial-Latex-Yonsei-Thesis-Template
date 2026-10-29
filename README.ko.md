# 연세대학교 일반대학원 학위논문 LaTeX 템플릿 (비공식)

[English](README.md) | 한국어

연세대학교 일반대학원의 **영문 학위논문과 국문 초록**을 작성하기 위한 LaTeX
템플릿입니다. 2026년 3월 30일 양식 변경 안내와 함께 배포된 영문 박사학위논문
Word 양식 `영문 MSword_박사학위논문_양식_2026.docx`를 기준으로 구성했습니다.

제공 예제의 기본값은 **박사학위논문**입니다. 학위 구분, 학위명, 심사위원 목록을
변경하면 석사학위논문으로도 사용할 수 있습니다. 로컬 빌드와 Overleaf 업로드를
지원합니다.

학교가 배포하거나 제출 적합성을 보증하는 공식 템플릿은 **아닙니다**. 최종 제출
전에는 일반대학원의 최신 지침을 확인하고, 제목·이름·본문 분량을 수정한 뒤에는
완성된 PDF를 직접 점검하세요.

## 빠른 시작

### 로컬 빌드

Python 3.8 이상과 pdfLaTeX·BibTeX를 포함한 TeX 배포판이 필요하며, `latexmk`
사용을 권장합니다. MacTeX 또는 TeX Live 전체 설치에는 `newtx`, `caption`,
`geometry`, `CJKutf8`, 나눔명조 TeX 글꼴 등 필요한 구성요소가 포함됩니다.
Debian/Ubuntu에서는 `texlive-full` 설치가 가장 간단하며, 최소 설치를 사용한다면
`texlive-lang-korean` 등의 한국어 지원도 필요합니다.
미리보기에는 Poppler가 필요합니다 (`brew install poppler` 또는
`apt install poppler-utils`).

```sh
git clone https://github.com/codemoo/Unofficial-Latex-Yonsei-Thesis-Template.git
cd Unofficial-Latex-Yonsei-Thesis-Template
# thesis.json과 예제 본문을 수정한 뒤 빌드합니다.
scripts/build.sh
scripts/preview.sh 1-5
```

빌드 스크립트는 `thesis.json`과 `.in` 템플릿에서 `front/cover.tex`,
`front/signature.tex`, `front/titlekor.tex`를 다시 생성한 뒤 `main.pdf`를 만듭니다.
터미널에는 오류와 일부 경고만 표시하므로 `main.log`와 PDF도 확인하세요.
배치 문제까지 모두 자동으로 검출되는 것은 아닙니다.
미리보기는 `preview/`에 저장됩니다. 페이지 범위를 생략하면 전체를, 숫자 하나만
지정하면 해당 페이지만 변환합니다.

### Docker로 빌드

메타데이터를 생성하므로 호스트에도 Python이 필요합니다. Docker를 설치하고
실행한 상태에서 다음 명령을 사용합니다.

```sh
docker pull texlive/texlive:latest
USE_DOCKER=1 scripts/build.sh
```

로컬에 `latexmk`와 `pdflatex`가 모두 없으면 이미 내려받은 Docker 이미지를
자동으로 사용합니다. `TEXLIVE_IMAGE`로 다른 호환 이미지를 지정할 수 있으며,
Poppler 미리보기는 호스트에서 실행됩니다. 장기적인 재현성이 필요하면 `latest`
대신 TeX Live 버전이나 이미지 digest를 고정하세요.

### Overleaf에서 사용

1. GitHub의 **Code → Download ZIP**으로 내려받고, Overleaf에서
   **New Project → Upload Project**로 올립니다.
2. Main document는 `main.tex`, Compiler는 **pdfLaTeX**, TeX Live는 2023 이상으로
   설정합니다.
3. Overleaf에서는 메타데이터 스크립트가 실행되지 않습니다. 제목·저자·학위·날짜·
   지도교수는 `front/cover.tex`, 심사위원은 `front/signature.tex`, 국문 제목은
   `front/titlekor.tex`에서 직접 수정합니다.
4. 예제 챕터와 초록을 자신의 내용으로 바꾸고 컴파일한 뒤 PDF를 확인합니다.

로컬 빌드로 돌아오기 전에는 메타데이터 수정사항을 `thesis.json`에, 구조 변경사항을
`.in` 템플릿에 먼저 옮기세요. 그렇지 않으면 다음 로컬 빌드가 위 세 생성 파일의
수정사항을 덮어씁니다.

## 논문 정보와 학위 구분

로컬에서는 [`thesis.json`](thesis.json)이 표지·제목·인준서 정보의 기준 파일입니다.

| 항목 | 의미와 제약 |
|---|---|
| `title`, `title_kor`, `author` | 영문 제목, 국문 제목, 저자 이름. |
| `department`, `degree` | 학과명과 학위명의 전체 표기. 학과명은 필요에 따라 `Department of …`까지 포함합니다. |
| `degree_level` | 예제는 `doctoral`; 석사는 `master`. 생략 시 호환성을 위해 `master`로 처리하므로 명시적으로 지정하세요. |
| `degree_month`, `degree_year` | 학위수여 월과 연도. `February` 또는 `August`만 허용합니다. |
| `supervisors` | `{ "name": "…", "title": "Professor" }` 형식의 비어 있지 않은 목록. 제목 페이지에는 이름을 표시하며, 여러 명이면 가운뎃점으로 연결합니다. |
| `committee` | 박사 5명, 석사 3명. 각 항목은 `role`, `title`, 비어 있지 않은 `name`을 포함합니다. 첫 번째는 `chair`, 나머지는 `member`입니다. |

심사위원 직함은 모두 `Prof.`, 모두 `Dr.`, 또는 모두 빈 문자열로 통일합니다.
빈 문자열은 직함 없이 이름만 출력합니다. 스크립트가 위원 수, 역할, 직함 통일,
학위 구분과 월을 검증합니다. 메타데이터는 LaTeX로 삽입되므로 `&` 같은 특수문자는
`\&`로 이스케이프하세요 (JSON 안에서는 `\\&`로 작성).

**석사학위논문**으로 바꾸려면 다음 세 항목을 함께 수정합니다.

1. `degree_level`을 `master`로 설정합니다.
2. `degree`를 해당 학위명으로 바꿉니다. 예: `Master of Science in Mechanical Engineering`.
3. 심사위원을 위원장 1명과 위원 2명, 총 3명으로 구성합니다.

Overleaf에서는 `front/cover.tex`의 문구를 다음과 같이 바꾸고 `\degree{…}`도
수정합니다. `front/signature.tex`의 `\signature{role}{name}` 항목은 3명으로 맞춥니다.

```tex
\renewcommand{\thesistypetitle}{Master's Thesis}
\renewcommand{\thesistypelower}{master's thesis}
```

제출 전에는 해당 석사 양식과도 대조하세요.

## 수정할 파일

| 내용 | 파일 또는 방법 |
|---|---|
| 표지·제목·인준서 정보 | `thesis.json`. Overleaf에서는 위에서 안내한 생성 파일을 수정합니다. |
| 감사의 글 | `front/acknowldgment.tex`. 예제 이름과 날짜도 별도로 수정합니다. 기존 참조를 위해 유지한 파일명이므로 이름을 바꾸지 마세요. |
| 영문 초록 | `front/abstract.tex`. 마지막에 `\keywords{…}`를 둡니다. |
| 국문 초록 | `back/abstract_kor.tex`. 마지막에 `\keywordskor{핵심되는 말}{…}`를 둡니다. |
| 본문 챕터 | `chapters/chapN.tex`를 `\chapter{…}`로 시작하고 `main.tex`에 `\include`를 추가합니다. |
| 결론 | `back/conclusion.tex`. |
| 부록 | `back/appN.tex`를 만들고 `main.tex`의 `\appendix` 뒤에 포함합니다. 제목은 `Appendix 1. …` 형식입니다. |
| 참고문헌 | `main.bib`. 스타일은 `biblio.tex`에서 지정하며 기본값은 `IEEEtran`입니다. |
| 본문 크기 | `main.tex`의 `\documentclass[10pt]{mitthesis}`. 11pt도 지원합니다. |
| 공통 레이아웃 | `mitthesis.cls`. 양식 규칙을 바꾸기 전에 공식 샘플을 확인하세요. |

서명된 인준서를 넣으려면 스캔본을 `front/signed.pdf`로 저장합니다.
`front/cover.tex.in` (Overleaf에서는 `front/cover.tex`)의
`\input{front/signature}`를 주석 처리하고, 제공된 `\includepdf` 줄의 주석을
해제합니다. 개인 서명이 들어간 파일은 공개 저장소에 올리지 마세요.

## 구현된 레이아웃

- 순서: 표지, 제목 페이지, 인준서, 선택적인 감사의 글, 차례, 그림 목록,
  표 목록, 영문 초록, 본문, 부록, 참고문헌, 국문 초록.
- A4; 위·아래 여백 5.3 cm, 좌·우 여백 3.5 cm. 쪽번호는 하단 중앙이며 기준선이
  용지 아래 끝에서 3.2 cm 위치에 놓입니다.
- 영문과 수식은 `newtx`의 Times 계열 글꼴입니다. Times New Roman과 호환되는
  계열이지 해당 상용 글꼴 자체는 아닙니다. 한국어는 나눔명조를 사용합니다.
- 표지 제목 18pt, 제목 페이지·챕터 제목 16pt, 절 제목 13pt, 본문 10pt 또는
  11pt, 각주 9pt. 본문 행간 배율 1.5, 문단 들여쓰기 2em, 국문 초록 들여쓰기 1em.
- 학위에 따른 제출·인준 문구, 박사 5명 또는 석사 3명의 서명 행.
  지도교수 표기는 `Advisor : Name1·Name2` 형식입니다.
- 차례부터 로마자 쪽번호, 첫 챕터부터 아라비아 숫자 1로 다시 시작합니다.
  표지부터 감사의 글까지는 쪽번호를 표시하지 않습니다.
- 점선 리더가 있는 차례와 목록, `1. Introduction` 형식의 챕터 제목,
  전체 연속번호를 사용하는 `<Fig 1>`, `<Table 1>` 캡션.
- 영문·국문 초록의 제목, 본문, 구분선과 핵심어. IEEE 번호 인용과 단일 행간의
  참고문헌 항목.

기준 샘플은 영문 박사학위논문용입니다. `\headerkor`를 `국문 요약`으로 바꾸는
것은 국문 초록 제목만 바꾸며, 논문 전체를 국문 논문 양식으로 전환하지는 않습니다.

## 제출 전 확인

첫 다섯 쪽뿐 아니라 PDF 전체를 확인하세요. 긴 제목, 지도교수·심사위원 이름,
페이지 순서와 번호, 그림·표 목록, 참고문헌, 한글 표시와 차례 링크를 점검하고,
예제 문구와 날짜를 모두 교체하세요.

클래스가 `amsmath`, `amsthm`, `newtxtext`, `newtxmath`, `caption`, `geometry`,
`setspace`, `CJKutf8`, `babel`을 이미 불러옵니다. `amssymb`와 `amsfonts`를 추가하면
기존 수식 설정과 충돌할 수 있습니다. 한국어는
`\begin{CJK}{UTF8}{nanummj} … \end{CJK}` 안에 작성하세요. 제공된 국문 초록과
감사의 글은 이미 해당 환경으로 감싸져 있습니다.

구현 구조와 생성 파일 규칙은 [AGENTS.md](AGENTS.md)를 참고하세요.
충돌하는 내용이 있다면 일반대학원의 공식 지침을 우선합니다.

## 라이선스와 원본 표기

[`LICENSE`](LICENSE)에는 **LaTeX Project Public License 1.3c**가 들어 있습니다.
[`mitthesis.cls`](mitthesis.cls)에는 원본 MIT 학위논문 클래스의 저작권·이용허락
고지도 유지하며, 재판매를 위한 복제·배포 제한이 포함되어 있습니다.
재배포 전 두 고지를 함께 확인하세요. MIT 학위논문 템플릿에서 유래했다는 사실이
MIT 소프트웨어 라이선스를 적용한다는 뜻은 아닙니다.
