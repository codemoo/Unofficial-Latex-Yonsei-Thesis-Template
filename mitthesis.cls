%% mitthesis.cls — Yonsei University Graduate School thesis class
%%
%% Originally derived from the MIT thesis class (Stephen Gildea, Peter
%% Nuth, Krishna Sethuraman; (c) 1987-1990, permission to copy granted
%% provided the notice is retained). Rewritten for the Yonsei University
%% Graduate School 2026 thesis format, following the official Word sample
%% "영문 MSword_박사학위논문_양식_2026.docx" (doctoral, English thesis).
%%
%% The file keeps its historical name so that main.tex and the build
%% scripts stay unchanged.
%%
%% What the official 2026 spec says (and where it is enforced here):
%%   - A4 paper, Times New Roman ............... geometry / newtx below
%%   - Margins: top/bottom 5.3 cm, left/right 3.5 cm,
%%     header 1.5 cm, footer 3.2 cm ............ geometry below
%%   - Main title 18 pt bold, subheadings 13 pt bold, body 10-11 pt,
%%     footnotes 9 pt, 1.5 line spacing ........ sizes / setspace below
%%   - Paragraphs indented 2 spaces, justified . \parindent below
%%   - Page numbers centred at the bottom ...... pagestyle plain
%%   - Cover page (title 6.8 cm from top) ...... \makecover
%%   - Title page (title 6.1 cm from top) ...... \maketitle
%%   - Signature page (1 cm rows, 1/4.5/7.5/1 cm columns) ... signpage,
%%     \signature, \signpagefoot
%%   - "TABLE OF CONTENTS" 16 pt centred; entries "1. Title" / "2.1 Title"
%%     with small-dot leaders and a centred page column, as in the
%%     sample's TOC table; List of Figures / Tables / Abstract /
%%     References / Abstract in Korean as 13 pt left headings
%%     ........................................ \tableofcontents,
%%     \yonsei@tocline, \l@chapter, \@makeschapterhead
%%   - Figure / table labels "<Fig 1>", "<Table 1>" .. caption setup
%%   - Chapter heading "1. Introduction" 16 pt bold on one line;
%%     "1.1 Section" 13 pt bold ................. \@makechapterhead,
%%     \section
%%   - Appendices listed as "Appendix 1. Title" . \appendix
%%   - Abstract / Abstract in Korean pages ...... abstractpage,
%%     abstractpagekor, \keywords, \keywordskor
%%
%% Public interface used by the template:
%%   \title \author \department \degree \degreemonth \degreeyear
%%   \supervisor{name}{title}   (repeat for several advisors; names are
%%                               joined with a middle dot on the title page)
%%   \thesistypetitle \thesistypelower   (set in front/cover.tex)
%%   \makecover \maketitle
%%   signpage environment, \signpagehead, \signature{role}{name},
%%   \signpagefoot
%%   \frontheading{...}  — 13 pt bold left heading
%%   \centerheading{...} — 16 pt bold centred heading (Acknowledgements)
%%   \frontheadingplain{...} — same, regular weight (References, Abstract in Korean)
%%   abstractpage / abstractpagekor environments, \keywords, \keywordskor
%%   \headerkor — heading of the Korean abstract ("Abstract in Korean")
%%   \titlekor  — Korean title, defined by front/titlekor.tex

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mitthesis}[2026/10/29 Yonsei University Graduate School thesis (2026 spec)]

%% ---------------------------------------------------------------------
%% Options
%% ---------------------------------------------------------------------
\def\yonsei@stretch{1.5}
\DeclareOption{doublespace}{\def\yonsei@stretch{1.5}}
\DeclareOption{singlespace}{\def\yonsei@stretch{1}}
% Accepted for backward compatibility; they have no effect any more.
\DeclareOption{vi}{}
\DeclareOption{upcase}{}
\DeclareOption{leftblank}{}
\DeclareOption{twoside}{\ClassWarning{mitthesis}{Yonsei theses are single-sided; ignoring twoside}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions\relax
\LoadClass[a4paper,oneside]{report}

%% ---------------------------------------------------------------------
%% Fonts: Times New Roman look-alike (newtx) with matching maths.
%% NOTE: newtxmath already provides the AMS symbol fonts — do NOT load
%% amssymb/amsfonts in main.tex (it causes "already defined" errors).
%% ---------------------------------------------------------------------
\RequirePackage{cmap}            % searchable/copyable PDF text (before fontenc)
\RequirePackage[T1]{fontenc}
\RequirePackage{amsmath}
\RequirePackage{amsthm}
\RequirePackage{newtxtext}
\RequirePackage{newtxmath}
\RequirePackage{textcomp}
\RequirePackage{CJKutf8}         % Korean (nanummj) for title_kor / abstract
\RequirePackage[english]{babel}

%% ---------------------------------------------------------------------
%% Page geometry (spec C. Margins)
%% ---------------------------------------------------------------------
\RequirePackage[a4paper,
  top=5.3cm, bottom=5.3cm, left=3.5cm, right=3.5cm,
  headheight=0pt, headsep=0pt,
  footskip=2.1cm]{geometry}       % footer 3.2 cm from the paper edge
\pagestyle{plain}                 % page number centred at the bottom

%% ---------------------------------------------------------------------
%% Line spacing, indentation, footnotes
%% ---------------------------------------------------------------------
\RequirePackage{setspace}
\setstretch{\yonsei@stretch}
\setlength{\parindent}{2em}       % "indent the beginning of paragraphs by 2 spaces"
                                  % (the Word sample uses 2 characters = 20 pt at 10 pt)
\setlength{\parskip}{0pt}
\renewcommand{\footnotesize}{\fontsize{9}{11}\selectfont}

%% Heading font sizes
\newcommand{\yonsei@sizecover}{\fontsize{18}{24}\selectfont}   % cover title etc.
\newcommand{\yonsei@sizetitle}{\fontsize{16}{24}\selectfont}   % title page
\newcommand{\yonsei@sizechap}{\fontsize{16}{20}\selectfont}    % chapter / TOC heading
\newcommand{\yonsei@sizesub}{\fontsize{13}{18}\selectfont}     % 13 pt subheadings

%% ---------------------------------------------------------------------
%% Front-matter data
%% ---------------------------------------------------------------------
\def\department#1{\gdef\@department{#1}}
\def\@department{\ClassError{mitthesis}{No \string\department\space given}{}}
\def\degree#1{\gdef\@degree{#1}}
\def\@degree{\ClassError{mitthesis}{No \string\degree\space given}{}}
\def\degreemonth#1{\gdef\@degreemonth{#1}}
\def\degreeyear#1{\gdef\@degreeyear{#1}}
\def\@degreemonth{February}
\def\@degreeyear{\the\year}

% Advisors: "Advisor : Name1·Name2" on the title page.
\let\@advisornames\@empty
\newif\if@firstadvisor \@firstadvisortrue
\def\supervisor#1#2{%
  \if@firstadvisor
    \g@addto@macro\@advisornames{#1}%
    \@firstadvisorfalse
  \else
    \g@addto@macro\@advisornames{\textperiodcentered#1}%
  \fi}

% Master's vs doctoral wording, overridden in front/cover.tex.
\providecommand{\thesistypetitle}{Dissertation}
\providecommand{\thesistypelower}{dissertation}

% Korean-abstract heading: English thesis -> "Abstract in Korean";
% for a Korean thesis \renewcommand{\headerkor}{국문 요약}.
\newcommand{\headerkor}{Abstract in Korean}

% Exact gap from the top of the text area to the first box on a page
% (\null absorbs \topskip so the gap is literally #1).
\newcommand{\yonsei@topgap}[1]{\null\vskip\dimexpr#1-\topskip\relax}

%% ---------------------------------------------------------------------
%% Cover page (Appendix 1 of the spec)
%%   rows: 1.5 cm (blank) | 4.75 cm title (top) | 3.85 cm author (bottom)
%%         | 8.90 cm department block (bottom)
%% ---------------------------------------------------------------------
\def\makecover{%
  \clearpage\thispagestyle{empty}%
  \begingroup\setstretch{1}\offinterlineskip\parindent\z@\parskip\z@\centering
  \yonsei@topgap{1.5cm}%
  \begin{minipage}[t][8.6cm][s]{\textwidth}\centering
    {\yonsei@sizecover\bfseries\@title\par}
    \vfill
    {\yonsei@sizecover\bfseries\@author\par}
  \end{minipage}\par
  \vfill
  \begin{minipage}[t]{\textwidth}\centering
    \fontsize{18}{31}\selectfont\bfseries
    \@department\\
    Graduate School\\
    Yonsei University\par
  \end{minipage}\par
  \endgroup
  \clearpage}

%% ---------------------------------------------------------------------
%% Title page (Appendix 2 of the spec)
%%   rows: 0.8 (blank) | 3.4 title | 1.2 advisor | 1.0 (blank) | 6.0
%%         submission block | 1.7 author | 3.7 (blank) | 1.0 date
%% ---------------------------------------------------------------------
\def\maketitle{%
  \clearpage\thispagestyle{empty}%
  \begingroup\setstretch{1}\offinterlineskip\parindent\z@\parskip\z@\centering
  \yonsei@topgap{0.8cm}%
  \begin{minipage}[t][3.4cm][t]{\textwidth}\centering
    {\fontsize{16}{23}\selectfont\bfseries\@title\par}
  \end{minipage}\par
  \begin{minipage}[t][1.2cm][c]{\textwidth}\centering
    \ifx\@advisornames\@empty\else
      {\yonsei@sizetitle\bfseries Advisor :\ \@advisornames\par}
    \fi
  \end{minipage}\par
  \vskip 1.0cm
  \begin{minipage}[t][6.0cm][t]{\textwidth}\centering
    \yonsei@sizetitle\bfseries
    A \thesistypetitle\ Submitted\\
    to the \@department\\
    and the Committee of the Graduate School\\
    of Yonsei University in Partial Fulfillment of the\\
    Requirements for the Degree of\\
    \@degree\par
  \end{minipage}\par
  \begin{minipage}[t][1.7cm][b]{\textwidth}\centering
    {\yonsei@sizetitle\bfseries\@author\par}
  \end{minipage}\par
  \vskip 3.7cm minus 1cm   % shrinks if a long title/degree needs room
  \begin{minipage}[t][1.0cm][b]{\textwidth}\centering
    {\yonsei@sizetitle\bfseries\@degreemonth\ \@degreeyear\par}
  \end{minipage}\par
  \endgroup
  \clearpage}

%% ---------------------------------------------------------------------
%% Signature page (Appendix 3 of the spec)
%%   rows: 2.43 title | 1.95 "This certifies ..." | 1.0 signature line +
%%         1.0 role/name per committee member | gap | 3.04 footer
%%   columns: 1.0 | 4.5 | 7.5 | 1.0 cm  (text width 14 cm)
%% ---------------------------------------------------------------------
\newlength{\yonsei@sigcolA}\setlength{\yonsei@sigcolA}{1.0cm}
\newlength{\yonsei@sigcolB}\setlength{\yonsei@sigcolB}{4.5cm}
\newlength{\yonsei@sigcolC}\setlength{\yonsei@sigcolC}{7.5cm}
\newlength{\yonsei@sigrow}\setlength{\yonsei@sigrow}{1.0cm}

\newenvironment{signpage}{%
  \clearpage\thispagestyle{empty}%
  \begingroup\setstretch{1}\offinterlineskip\parindent\z@\parskip\z@\raggedright}{%
  \par\endgroup\clearpage}

\def\signpagehead{%
  \begin{minipage}[t][2.43cm][t]{\textwidth}\centering
    {\yonsei@sizesub\bfseries\@title\par}
  \end{minipage}\par
  \begin{minipage}[t][1.95cm][t]{\textwidth}\centering
    {\yonsei@sizesub\bfseries
     This certifies that the \thesistypelower\\
     of \@author\ is approved.\par}
  \end{minipage}\par}

% \signature{role}{name}: a 1 cm row holding the signature line over the
% name column, then a 1 cm row with "Committee Chair" | "Prof. Name".
% If #2 is empty only the role is printed (legacy single-field call).
\def\signature#1#2{%
  \begin{minipage}[t][\yonsei@sigrow][b]{\textwidth}
    \noindent\hspace*{\yonsei@sigcolA}\hspace*{\yonsei@sigcolB}%
    \rule{\yonsei@sigcolC}{0.4pt}\par
  \end{minipage}\par
  \begin{minipage}[t][\yonsei@sigrow][c]{\textwidth}
    \yonsei@sizesub\bfseries
    \noindent\hspace*{\yonsei@sigcolA}\hspace*{0.23cm}%
    \makebox[\dimexpr\yonsei@sigcolB-0.23cm\relax][l]{#1}%
    \hspace*{0.1cm}%
    \makebox[\dimexpr\yonsei@sigcolC-0.1cm\relax][l]{#2}\par
  \end{minipage}\par}

\def\signpagefoot{%
  \vfill
  \begin{minipage}[t][3.04cm][t]{\textwidth}\centering
    \yonsei@sizesub\bfseries
    \@department\\
    Graduate School\\
    Yonsei University\\[0.2cm]
    \@degreemonth\ \@degreeyear\par
  \end{minipage}\par}

%% ---------------------------------------------------------------------
%% Headings
%% ---------------------------------------------------------------------
% 13 pt bold left-aligned heading used for Acknowledgements, List of
% Figures, List of Tables, Abstract, References, Abstract in Korean.
\newcommand{\frontheading}[1]{%
  \par\noindent{\yonsei@sizesub\bfseries #1\par}\vskip 1em}
% 16 pt bold centred heading in the style of "TABLE OF CONTENTS"
% (used for the free-form Acknowledgements / Dedication page).
\newcommand{\centerheading}[1]{%
  \par{\centering\yonsei@sizechap\bfseries #1\par}\vskip 2em}
% Regular-weight variant: the Word sample sets "References" and
% "Abstract in Korean" in 13 pt WITHOUT bold.
\newcommand{\frontheadingplain}[1]{%
  \par\noindent{\yonsei@sizesub #1\par}\vskip 1em}

% Bibliography heading: 13 pt regular (as in the sample), no \chapter*.
\renewenvironment{thebibliography}[1]
     {\clearpage\frontheadingplain{\bibname}%
      \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}

% \chapter*{...} (List of Figures, List of Tables, References) -> 13 pt.
\renewcommand{\@makeschapterhead}[1]{%
  {\parindent\z@\raggedright\normalfont\yonsei@sizesub\bfseries #1\par\nobreak}%
  \vskip 1em}

% Numbered chapter: "1. Introduction" on one line, 16 pt bold.
% Appendices: "Appendix 1. Title".
\newif\if@yonseiappendix
\renewcommand{\@makechapterhead}[1]{%
  {\parindent\z@\raggedright\normalfont\yonsei@sizechap\bfseries
    \ifnum\c@secnumdepth>\m@ne
      \if@yonseiappendix\@chapapp~\fi\thechapter.\ %
    \fi
    #1\par\nobreak}%
  \vskip 1.5em}

% Every chapter starts on a new page; first paragraph is indented like
% the others (spec D).
\def\chapter{\clearpage\thispagestyle{plain}%
  \global\@topnum\z@
  \@afterindenttrue
  \secdef\@chapter\@schapter}

% Same as report.cls but the TOC line of an appendix reads
% "Appendix 1. Title".
\def\@chapter[#1]#2{%
  \ifnum\c@secnumdepth>\m@ne
    \refstepcounter{chapter}%
    \typeout{\@chapapp\space\thechapter.}%
    \if@yonseiappendix
      \addcontentsline{toc}{chapter}{\protect\numberline{\@chapapp~\thechapter}#1}%
    \else
      \addcontentsline{toc}{chapter}{\protect\numberline{\thechapter}#1}%
    \fi
  \else
    \addcontentsline{toc}{chapter}{#1}%
  \fi
  \chaptermark{#1}%
  \addtocontents{lof}{\protect\addvspace{10\p@}}%
  \addtocontents{lot}{\protect\addvspace{10\p@}}%
  \@makechapterhead{#2}%
  \@afterheading}

\renewcommand\appendix{\par
  \setcounter{chapter}{0}%
  \setcounter{section}{0}%
  \gdef\@chapapp{Appendix}%
  \gdef\thechapter{\@arabic\c@chapter}%
  \@yonseiappendixtrue}

% Sections: 13 pt bold ("1.1 Research background"). The Word sample
% indents the section heading by one 13 pt character; subsections get
% twice that, like the 2-space / 4-space steps in its table of contents.
% The before-skip is POSITIVE on purpose: a negative value makes
% \@startsection suppress the indent of the first paragraph, but the
% spec indents every paragraph.
\renewcommand\section{\@startsection{section}{1}{13pt}%
  {3.5ex \@plus 1ex \@minus .2ex}{1.5ex \@plus .2ex}%
  {\normalfont\yonsei@sizesub\bfseries}}
\renewcommand\subsection{\@startsection{subsection}{2}{26pt}%
  {3.25ex \@plus 1ex \@minus .2ex}{1.2ex \@plus .2ex}%
  {\normalfont\yonsei@sizesub\bfseries}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{39pt}%
  {3.25ex \@plus 1ex \@minus .2ex}{1ex \@plus .2ex}%
  {\normalfont\normalsize\bfseries}}
\@afterindenttrue
\renewcommand{\@afterheading}{%
  \@nobreaktrue
  \everypar{%
    \if@nobreak\@nobreakfalse\clubpenalty\@M
      \if@afterindent\else{\setbox\z@\lastbox}\fi
    \else\clubpenalty\@clubpenalty\everypar{}\fi}}

%% ---------------------------------------------------------------------
%% Table of contents, List of Figures, List of Tables
%% ---------------------------------------------------------------------
% babel resets these at \begin{document}, so hook into its caption list.
\addto\captionsenglish{%
  \renewcommand{\contentsname}{TABLE OF CONTENTS}%
  \renewcommand{\listfigurename}{List of Figures}%
  \renewcommand{\listtablename}{List of Tables}%
  \renewcommand{\bibname}{References}%
  \renewcommand{\figurename}{Fig}%
  \renewcommand{\tablename}{Table}%
  \renewcommand{\appendixname}{Appendix}}
\setcounter{tocdepth}{2}

\renewcommand\tableofcontents{%
  \clearpage\thispagestyle{plain}%
  {\centering\yonsei@sizechap\bfseries\contentsname\par}%
  \vskip 2em
  \begingroup\yonsei@tocsetup\@starttoc{toc}\endgroup}

% Entry lines reproduce the Word sample's table: entry text in the body
% font (not bold), a leader of small middle dots (the sample uses U+2219
% at 7.5 pt), and the page number centred in a 1 cm column; rows are
% 0.78 cm apart. The same line format is used for the lists of figures
% and tables.
\def\yonsei@tocsetup{%
  \setstretch{1}\normalsize\normalfont
  \parindent\z@ \parskip\z@ \baselineskip 22pt \lineskiplimit\z@}
\def\yonsei@tocdot{{\fontsize{7.5}{7.5}\selectfont\textperiodcentered}}
% \yonsei@tocline{indent}{entry}{page}
\def\yonsei@tocline#1#2#3{%
  \par\begingroup
    \leftskip#1\relax \rightskip\z@ \parfillskip\z@ \parindent\z@
    \interlinepenalty\@M
    \leavevmode #2\nobreak\hskip 0.2cm\nobreak
    \leaders\hbox to 2.5pt{\hss\yonsei@tocdot\hss}\hfill\nobreak
    \hskip 0.2cm\nobreak\hb@xt@ 0.6cm{\hss #3\hss}\par
  \endgroup}

% Chapter-level: "1. Introduction", "Appendix 1. Title", "References".
\renewcommand*\l@chapter[2]{%
  \ifnum\c@tocdepth>\m@ne
    \begingroup\def\numberline##1{##1.\ }\yonsei@tocline{0pt}{#1}{#2}\endgroup
  \fi}
% Sections "2.1 Title" and subsections "2.2.1 Title", stepped in like the
% 2-space / 4-space indents of the sample (and like the body headings).
\renewcommand*\l@section[2]{%
  \ifnum\c@tocdepth>\z@
    \begingroup\def\numberline##1{##1\ }\yonsei@tocline{13pt}{#1}{#2}\endgroup
  \fi}
\renewcommand*\l@subsection[2]{%
  \ifnum\c@tocdepth>\@ne
    \begingroup\def\numberline##1{##1\ }\yonsei@tocline{26pt}{#1}{#2}\endgroup
  \fi}

% List entries "<Fig 1> Caption ...... 5" / "<Table 1> Caption ...... 5".
\renewcommand\listoffigures{%
  \chapter*{\listfigurename}%
  \begingroup\yonsei@tocsetup\@starttoc{lof}\endgroup}
\renewcommand\listoftables{%
  \chapter*{\listtablename}%
  \begingroup\yonsei@tocsetup\@starttoc{lot}\endgroup}
\def\yonsei@listline#1#2#3{%
  \begingroup\def\numberline##1{\textless#1~##1\textgreater\ }%
  \yonsei@tocline{0pt}{#2}{#3}\endgroup}
\renewcommand*\l@figure{\yonsei@listline{Fig}}
\renewcommand*\l@table{\yonsei@listline{Table}}

%% ---------------------------------------------------------------------
%% Figures and tables: continuous numbering, "<Fig 1>" / "<Table 1>"
%% ---------------------------------------------------------------------
\RequirePackage{caption}
\counterwithout{figure}{chapter}
\counterwithout{table}{chapter}
\DeclareCaptionLabelFormat{yonsei}{\textless#1~#2\textgreater}
\captionsetup{labelformat=yonsei,labelsep=space,font=normalsize,justification=centering}
% A float that ends up alone on a page sits at the top, not mid-page.
\setlength{\@fptop}{0pt}
\setlength{\@fpbot}{0pt plus 1fil}

%% ---------------------------------------------------------------------
%% Abstract pages
%% ---------------------------------------------------------------------
% English abstract: "Abstract" (13 pt, left) / title (13 pt, centred) /
% body / "Keywords : ..." at the foot of the page above a full-width rule.
\newenvironment{abstractpage}{%
  \clearpage\thispagestyle{plain}%
  \frontheading{Abstract}%
  \addcontentsline{toc}{chapter}{Abstract}%
  {\centering\yonsei@sizesub\bfseries\@title\par}%
  \vskip 1.5em
  \@afterindenttrue\noindent\ignorespaces}{%
  \par\clearpage}

\newcommand{\keywords}[1]{%
  \par\vfill
  \noindent\rule{\textwidth}{0.4pt}\par
  \noindent{\bfseries Keywords :}\ #1\par}

% Korean abstract (inside \begin{CJK}{UTF8}{nanummj} in main.tex):
% heading \headerkor / Korean title / body / "핵심되는 말 : ..." above a
% full-width rule.
\newenvironment{abstractpagekor}{%
  \clearpage\thispagestyle{plain}%
  \frontheadingplain{\headerkor}%
  \addcontentsline{toc}{chapter}{\headerkor}%
  {\centering\yonsei@sizesub\bfseries\titlekor\par}%  % Nanum Myeongjo Bold (moderately heavier)
  \vskip 1.5em
  % Korean "2칸" = two half-width spaces = one full-width character.
  \setlength{\parindent}{1em}%
  \@afterindenttrue\noindent\ignorespaces}{%
  \par\clearpage}

% \keywordskor{핵심되는 말}{keyword, ...} — the label is passed in from
% back/abstract_kor.tex so that no Korean text lives in this class file.
\newcommand{\keywordskor}[2]{%
  \par\vfill
  \noindent\rule{\textwidth}{0.4pt}\par
  \noindent{\bfseries #1 :}\ #2\par}

%% ---------------------------------------------------------------------
%% Misc
%% ---------------------------------------------------------------------
\newcounter{savepage}            % kept for compatibility with cover.tex
\def\Mit{Yonsei University}
\def\MIT{YONSEI UNIVERSITY}

\endinput
