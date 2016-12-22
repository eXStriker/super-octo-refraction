; Special non-control chars
	charmap "<NULL>",   $00
	charmap "¯",        $1f
	charmap "%",        $25
	charmap "<GREEN>",  $39
	charmap "<SHINY>",  $3f

; Control characters
LEAST_CHAR EQU $44

	charmap "<EMON>",   $44
	charmap "<STRBF1>", $45
	charmap "<STRBF2>", $46
	charmap "<STRBF3>", $47
	charmap "<STRBF4>", $48
	charmap "<ENEMY>",  $49
	charmap "<BMON>",   $4a
	charmap "<PKMN>",   $4b
	charmap "<SCROLL>", $4c
	charmap "<POKE>",   $4d
	charmap "<NEXT>",   $4e
	charmap "<LINE>",   $4f

	charmap "@",        $50
	charmap "<PARA>",   $51
	charmap "<PLAYER>", $52
	charmap "<RIVAL>",  $53
	charmap "#",        $54
	charmap "<CONT>",   $55
	charmap "<SDONE>",  $56
	charmap "<DONE>",   $57
	charmap "<PROMPT>", $58
	charmap "<TARGET>", $59
	charmap "<USER>",   $5a
	charmap "<MINB>",   $5b
	charmap "<......>", $5c
	charmap "<TRNER>",  $5d
	charmap "<ROCKET>", $5e
	charmap "<LNBRK>",  $5f

; Actual characters
	charmap "▲",        $61
	charmap "<CUP>",    $61
	charmap "_",        $62
	charmap "<COLON>",  $6d ; necessary because ":" is already used
	charmap "′",        $6e
	charmap "<LV>",     $6e
	charmap "″",        $6f

	charmap "<PO>",     $70
	charmap "<KE>",     $71
	charmap "◀",        $71
	charmap "<CLEFT>",  $71
	charmap "<``>",     $72
	charmap "<''>",     $73
	charmap "<ID>",     $73
	charmap "<No.>",    $73
	charmap "№",        $74
	charmap "…",        $75
	charmap "<...>",    $75

	charmap "┌",        $79
	charmap "─",        $7a
	charmap "┐",        $7b
	charmap "│",        $7c
	charmap "|",        $7c
	charmap "└",        $7d
	charmap "┘",        $7e
	charmap " ",        $7f

	charmap "A",        $80
	charmap "B",        $81
	charmap "C",        $82
	charmap "D",        $83
	charmap "E",        $84
	charmap "F",        $85
	charmap "G",        $86
	charmap "H",        $87
	charmap "I",        $88
	charmap "J",        $89
	charmap "K",        $8a
	charmap "L",        $8b
	charmap "M",        $8c
	charmap "N",        $8d
	charmap "O",        $8e
	charmap "P",        $8f
	charmap "Q",        $90
	charmap "R",        $91
	charmap "S",        $92
	charmap "T",        $93
	charmap "U",        $94
	charmap "V",        $95
	charmap "W",        $96
	charmap "X",        $97
	charmap "Y",        $98
	charmap "Z",        $99

	charmap "(",        $9a
	charmap ")",        $9b
	charmap ":",        $9c
	charmap ";",        $9d
	charmap "[",        $9e
	charmap "]",        $9f

	charmap "a",        $a0
	charmap "b",        $a1
	charmap "c",        $a2
	charmap "d",        $a3
	charmap "e",        $a4
	charmap "f",        $a5
	charmap "g",        $a6
	charmap "h",        $a7
	charmap "i",        $a8
	charmap "j",        $a9
	charmap "k",        $aa
	charmap "l",        $ab
	charmap "m",        $ac
	charmap "n",        $ad
	charmap "o",        $ae
	charmap "p",        $af
	charmap "q",        $b0
	charmap "r",        $b1
	charmap "s",        $b2
	charmap "t",        $b3
	charmap "u",        $b4
	charmap "v",        $b5
	charmap "w",        $b6
	charmap "x",        $b7
	charmap "y",        $b8
	charmap "z",        $b9

	charmap "<@>",      $bb
	charmap "♥",        $bc
	charmap "♦",        $bd
	charmap "♠",        $be
	charmap "♣",        $bf

	charmap "'d",       $d0
	charmap "'l",       $d1
	charmap "'m",       $d2
	charmap "'r",       $d3
	charmap "'s",       $d4
	charmap "'t",       $d5
	charmap "'v",       $d6

	charmap "%",        $da
	charmap "+",        $db
	charmap "<DOWN>",   $dd
	charmap "<UP>",     $de
	charmap "<LEFT>",   $df
	charmap "'",        $e0
	charmap "<PK>",     $e1
	charmap "<MN>",     $e2
	charmap "-",        $e3

	charmap "?",        $e6
	charmap "!",        $e7
	charmap ".",        $e8
	charmap "&",        $e9

	charmap "é",        $ea
	charmap "<RIGHT>",  $eb
	charmap "▷",        $ec
	charmap "▶",        $ed
	charmap "<CRIGHT>", $ec
	charmap "▼",        $ee
	charmap "<CDOWN>",  $ee
	charmap "♂",        $ef
	charmap "¥",        $f0
	charmap "<YEN>",    $f0
	charmap "×",        $f1
	charmap "/",        $f3
	charmap ",",        $f4
	charmap "♀",        $f5
	charmap "<FEMALE>", $f5

	charmap "0",        $f6
	charmap "1",        $f7
	charmap "2",        $f8
	charmap "3",        $f9
	charmap "4",        $fa
	charmap "5",        $fb
	charmap "6",        $fc
	charmap "7",        $fd
	charmap "8",        $fe
	charmap "9",        $ff
