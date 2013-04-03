
\version "2.16.2"
% automatically converted by musicxml2ly from -

\header {
    worknumber = "Op. 98"
    copyright = "Copyright © 2002 Recordare LLC"
    title = "An die ferne Geliebte (Page 1)"
    encodingdate = "2011-08-08"
    encodingsoftware = "Finale 2011 for Windows"
    composer = "Ludwig van Beethoven"
    poet = "Aloys Jeitteles"
    }

#(set-global-staff-size 18.0675)
\paper {
    paper-width = 21.59\cm
    paper-height = 27.94\cm
    top-margin = 1.27\cm
    bottom-margin = 1.27\cm
    left-margin = 1.27\cm
    right-margin = 1.27\cm
    between-system-space = 1.71\cm
    page-top-space = 1.03\cm
    }
\layout {
    \context { \Score
        skipBars = ##t
        autoBeaming = ##f
        }
    }
PartPOneVoiceOne =  \relative bes' {
    \clef "treble" \key es \major \time 3/4 | % 1
    r4 ^\markup{ \bold {Ziemlich langsam und mit Ausdruck} } ^\markup{
        \bold {No. 1} } bes4 bes4 | % 2
    bes4. c8 d8 [ es8 ] | % 3
    es4 g,8 r8 as8 [ g8 ] | % 4
    f8 [ as8 ] c4 c4 \break | % 5
    f,4 bes4. c8 | % 6
    bes4 a4 as8 [ bes8 ] | % 7
    as4 g4 es'8 [ d8 ] | % 8
    d4 ( c8 ) [ bes8 ] as8 [ f8 ] | % 9
    es4 r4 r4 | \barNumberCheck #10
    R2. \break | % 11
    r4 bes'4 bes4 | % 12
    bes4. c8 d8 [ es8 ] | % 13
    es4 g,8 r8 as8 [ g8 ] | % 14
    f8 [ as8 ] c4 c4 | % 15
    f,4 bes4. c8 }

PartPOneVoiceOneLyricsOne =  \lyricmode { Auf dem Hü -- gel "sitz’" spä
    -- hend in blau -- Ne -- bel -- "land," nach den fer -- nen Trif --
    se -- "hend," wo "dich, " __ lieb -- "fand." Weit bin ich von dir
    schie -- "den," tren -- lie -- Berg und Thal zwi -- schen }
PartPTwoVoiceOne =  \relative bes {
    \clef "treble" \key es \major \time 3/4 | % 1
    <bes es g bes>4 \p bes'4 ( as4 ) | % 2
    g4 <g, es' g>4 r4 | % 3
    r4 <g c es g>4 r8 <g es' g>8 | % 4
    f'8 ( [ as8 ] c4 ) c4 \break s4 bes4. ( c8 | % 6
    bes4 a4 ) as8 ( [ bes8 ) ] | % 7
    <f as>4 ( g4 ) <es bes' es>8 \< [ <es bes' d>8 ] | % 8
    <es bes' d>4 \! \> ( <es as c>8 ) [ <es g bes>8 \! <d f as>8 <as d
        f>8 ] | % 9
    <g es'>4 \acciaccatura { bes'8 ( } bes'4. ) es,8 ^\markup{ \bold
        {Ausdrucksvoll} } \> _\markup{ \italic {espressivo} } \! |
    \barNumberCheck #10
    d4 \acciaccatura { bes8 ( } bes'4. ) d,8 \> \! _\markup{ \italic
        {dim.} } ( \break | % 11
    f8 [ <f, as>8 ) <f as>8 ( <e g>8 <g bes>8 <f as>8 ) ] | % 12
    <es g>8 b'8 \rest <bes, g'>8 [ r16 <bes g'>16 ] <bes g'>8 b'8 \rest
    | % 13
    b4 \rest <es, g>8 [ r16 <es g>16 ] <es as es'>8 [ <es g>8 ] | % 14
    <c f>8 b'8 \rest <c, f>8 [ r16 <c f>16 ] <c es f c'>8 b'8 \rest | % 15
    <d, f>8 b'8 \rest <f bes>8 [ r16 <f bes>16 ] <g bes>8 b8 \rest }

PartPTwoVoiceThree =  \relative es, {
    \clef "bass" \key es \major \time 3/4 <es es'>4 \sustainOn \clef
    "treble" g''4 \sustainOff ( f4 ) | % 2
    es4 \clef "bass" <es,, es'>4 \sustainOn r4 \sustainOff | % 3
    r4 <c c'>4 \sustainOn r8 \sustainOff <bes bes'>8 | % 4
    <as as'>4 <as as'>4 ( <a a'>4 \break | % 5
    <bes bes'>4 ) d'4 ( es4 | % 6
    c4 c'4 ) s4 | % 7
    bes4 ( es4 ) s4 | % 8
    <as,, es' as>4 <as es' as>8 [ <bes es bes'>8 <bes bes'>8 <bes, bes'>8
    ] | % 9
    <es es'>4 <es' g bes es>2 | \barNumberCheck #10
    <es f as d>4 <es f as bes d>4. d'8 ( \break | % 11
    f8 [ <f, as>8 ) <f as>8 ( <e g>8 <g bes>8 <f as>8 ) ] | % 12
    <es g>8 d8 \rest es8 [ r16 es16 ] es,8 d'8 \rest | % 13
    d4 \rest c'8 [ c16 \rest c16 ] c,8 [ bes8 ] | % 14
    as8 d8 \rest as'8 [ r16 <as, as'>16 ] <a a'>4 | % 15
    <bes bes'>8 d8 \rest <d bes'>8 [ r16 <d bes'>16 ] <es bes'>8 d8
    \rest }

PartPTwoVoiceTwo =  \relative c' {
    \clef "treble" \key es \major \time 3/4 | % 1
    s4*9 \p | % 4
    c4 <c f>4 <c es f>4 ( ~ \break | % 5
    <d f>4 ) f4 g4 | % 6
    <es ges>2 f4 s2 s4 \< | % 8
    s4. \! \> s8*5 \! s4. ^\markup{ \bold {Ausdrucksvoll} } \> _\markup{
        \italic {espressivo} } s4. \! s4. \> s8 \! _\markup{ \italic
        {dim.} } \break }

PartPTwoVoiceFour =  \relative c {
    \clef "bass" \key es \major \time 3/4 s4 \sustainOn \clef "treble"
    s2. \sustainOff \clef "bass" s4 \sustainOn s2 \sustainOff s4
    \sustainOn s1 \sustainOff \break s2. | % 6
    c2 <d bes' d>4 | % 7
    es2 <g, es' g>4 s4*9 \break }


% The score definition
\score {
    <<
        \new Staff <<
            \set Staff.instrumentName = "Voice"
            \context Staff << 
                \context Voice = "PartPOneVoiceOne" { \PartPOneVoiceOne }
                \new Lyrics \lyricsto "PartPOneVoiceOne" \PartPOneVoiceOneLyricsOne
                >>
            >>
        \new PianoStaff <<
            \set PianoStaff.instrumentName = "Piano"
            \context Staff = "1" << 
                \context Voice = "PartPTwoVoiceOne" { \voiceOne \PartPTwoVoiceOne }
                \context Voice = "PartPTwoVoiceTwo" { \voiceTwo \PartPTwoVoiceTwo }
                >> \context Staff = "2" <<
                \context Voice = "PartPTwoVoiceThree" { \voiceOne \PartPTwoVoiceThree }
                \context Voice = "PartPTwoVoiceFour" { \voiceTwo \PartPTwoVoiceFour }
                >>
            >>
        
        >>
    \layout {}
    % To create MIDI output, uncomment the following line:
    %  \midi {}
    }

