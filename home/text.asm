BORDER_WIDTH   EQU 2
TEXTBOX_WIDTH  EQU SCREEN_WIDTH
TEXTBOX_INNERW EQU TEXTBOX_WIDTH - BORDER_WIDTH
TEXTBOX_HEIGHT EQU 6
TEXTBOX_INNERH EQU TEXTBOX_HEIGHT - BORDER_WIDTH
TEXTBOX_X      EQU 0
TEXTBOX_INNERX EQU TEXTBOX_X + 1
TEXTBOX_Y      EQU SCREEN_HEIGHT - TEXTBOX_HEIGHT
TEXTBOX_INNERY EQU TEXTBOX_Y + 2

TEXTBOX_PAL EQU 7

ClearBox::
; Fill a c*b box at hl with blank tiles.
	ld a, " "

FillBoxWithByte::
.row
	push bc
	push hl
.col
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	ret

ClearTileMapAndWipeAttrMap:
	call ClearTileMapNoDelay

; fallthrough
ClearAttrMap::
	coord hl, 0, 0, AttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	xor a
	jp ByteFill

ClearScreen::
	call TextClearAttrMap

ClearTileMap::
; Fill TileMap with blank tiles.

	call ClearTileMapNoDelay

	; Update the BG Map.
	ld a, [rLCDC]
	bit 7, a
	ret z
	jp ApplyTilemapInVBlank

ClearTileMapNoDelay:
	hlcoord 0, 0
	ld a, " "
	ld bc, TileMapEnd - TileMap
	jp ByteFill

TextClearAttrMap:
	ld a, TEXTBOX_PAL
	hlcoord 0, 0, AttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	jp ByteFill

TextBox::
; Draw a text box at hl with room for
; b lines of c characters each.
; Places a border around the textbox,
; then switches the palette to the
; text black-and-white scheme.
	push bc
	push hl
	call TextBoxBorder
	pop hl
	pop bc
	jr TextBoxPalette

TextBoxBorder::

	; Top
	push hl
	ld a, "┌"
	ld [hli], a
	inc a ; "─"
	call .PlaceChars
	inc a ; "┐"
	ld [hl], a
	pop hl

	; Middle
	ld de, SCREEN_WIDTH
	add hl, de
.row
	push hl
	ld a, "│"
	ld [hli], a
	ld a, " "
	call .PlaceChars
	ld [hl], "│"
	pop hl

	ld de, SCREEN_WIDTH
	add hl, de
	dec b
	jr nz, .row

	; Bottom
	ld a, "└"
	ld [hli], a
	ld a, "─"
	call .PlaceChars
	ld [hl], "┘"

	ret

.PlaceChars
; Place char a c times.
	ld d, c
.loop
	ld [hli], a
	dec d
	jr nz, .loop
	ret

TextBoxPalette::
; Fill text box width c height b at hl with pal 7
	ld de, AttrMap - TileMap
	add hl, de
	inc b
	inc b
	inc c
	inc c
	ld a, TEXTBOX_PAL
.col
	push bc
	push hl
.row
	ld [hli], a
	dec c
	jr nz, .row
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	pop bc
	dec b
	jr nz, .col
	ret

SpeechTextBox::
; Standard textbox.
	hlcoord TEXTBOX_X, TEXTBOX_Y
	ld b, TEXTBOX_INNERH
	ld c, TEXTBOX_INNERW
	jr TextBox

PrintInstantText::
	ld a, [wOptions]
	push af
	set NO_TEXT_SCROLL, a
	ld [wOptions], a
	call PrintText
	pop af
	ld [wOptions], a
	ret

FarPrintText::
	call StackCallInBankA

PrintText::
	call SetUpTextBox
	push hl
	hlcoord TEXTBOX_INNERX, TEXTBOX_INNERY
	lb bc, TEXTBOX_INNERH - 1, TEXTBOX_INNERW
	call ClearBox
	pop hl
	; fallthrough

PrintTextBoxText::
	bccoord TEXTBOX_INNERX, TEXTBOX_INNERY
ProcessTextCommands_::
	ld a, [TextBoxFlags]
	push af
	set 1, a
	ld [TextBoxFlags], a

	call ProcessTextCommands

	pop af
	ld [TextBoxFlags], a
	ret

SetUpTextBox::
	push hl
	call SpeechTextBox
	call UpdateSprites
	call ApplyTilemap
	pop hl
	ret

FarString::
Place2DMenuItemName::
	call StackCallInBankA

PlaceString::
; Process string at de into hl.
	push hl
	jr PlaceNextChar

NextChar::
	inc de
PlaceNextChar::
	ld a, [de]
	cp "@"
	jr nz, CheckDict
	ld b, h
	ld c, l
	pop hl
	ret

CheckDict::
	cp $60
	jr nc, .notDict
	sub LEAST_CHAR
	jr c, InvalidChar

	; Stack manip
	push hl
	push hl
	push de
	ld hl, TextControlCodeJumptable
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld hl, sp + 4
	ld [hli], a
	ld [hl], d
	pop de
	pop hl
	ld a, [de]
	ret
.notDict
	ld [hli], a
	call PrintLetterDelay
	jr NextChar

InvalidChar::
	ld [hCrashSavedA], a
	ld a, $3
	jp Crash

TextControlCodeJumptable::
	dw PlaceEnemyMonNick        ; "<EMON>"
	dw PlaceStringBuffer1       ; "<STRBF1>"
	dw PlaceStringBuffer2       ; "<STRBF2>"
	dw PlaceStringBuffer3       ; "<STRBF3>"
	dw PlaceStringBuffer4       ; "<STRBF4>"
	dw PlaceEnemysName          ; "<ENEMY>"
	dw PlaceBattleMonNick       ; "<BMON>"
	dw PlacePKMN                ; "<PKMN>"
	dw ScrollText               ; "<SCROLL>"
	dw PlacePOKE                ; "<POKE>"
	dw NextLineChar             ; "<NEXT>"
	dw LineChar                 ; "<LINE>"
	dw PlaceNextChar            ; "@"
	dw Paragraph                ; "<PARA>"
	dw PrintPlayerName          ; "<PLAYER>"
	dw PrintRivalName           ; "<RIVAL>"
	dw PlacePOKe                ; "#"
	dw ContText                 ; "<CONT>"
	dw SDoneText                ; "<SDONE>"
	dw DoneText                 ; "<DONE>"
	dw PromptText               ; "<PROMPT>"
	dw PlaceMoveTargetsName     ; "<TARGET>"
	dw PlaceMoveUsersName       ; "<USER>"
	dw PlaceMonOrItemNameBuffer ; "<MINB>"
	dw SixDotsChar              ; "<......>"
	dw TrainerChar              ; "<TRNER>"
	dw RocketChar               ; "<ROCKET>"
	dw LinebreakText            ; "<LNBRK>"

print_name: macro
	push de
	ld de, \1
	jp PlaceCommandCharacter
endm

PrintPlayerName: print_name PlayerName
PrintRivalName:  print_name RivalName
PlaceMonOrItemNameBuffer: print_name wMonOrItemNameBuffer
PlaceStringBuffer1: print_name wStringBuffer1
PlaceStringBuffer2: print_name wStringBuffer2
PlaceStringBuffer3: print_name wStringBuffer3
PlaceStringBuffer4: print_name wStringBuffer4
PlaceEnemyMonNick:  print_name EnemyMonNick
PlaceBattleMonNick: print_name BattleMonNick

TrainerChar:  print_name TrainerCharText
TMChar:       print_name TMCharText
RocketChar:   print_name RocketCharText
PlacePOKe:    print_name PlacePOKeText
SixDotsChar:  print_name SixDotsCharText
PlacePKMN:    print_name PlacePKMNText
PlacePOKE:    print_name PlacePOKEText

PlaceMoveTargetsName::
	ld a, [hBattleTurn]
	xor 1
	jr PlaceMoveTargetsName_5A

PlaceMoveUsersName::
	ld a, [hBattleTurn]
	; fallthrough

PlaceMoveTargetsName_5A:
	push de
	and a
	jr nz, .enemy

	ld de, BattleMonNick
	jr PlaceCommandCharacter

.enemy
	ld de, EnemyText ; Enemy
	ld a, [wBattleMode]
	dec a
	jr nz, .place
	ld de, WildText ; Wild
.place
	call PlaceString
	ld h, b
	ld l, c
	ld de, EnemyMonNick
	jr PlaceCommandCharacter

PlaceEnemysName::
	push de

	ld a, [wLinkMode]
	and a
	jr nz, .linkbattle

	ld a, [TrainerClass]
	cp RIVAL1
	jr z, .rival

	ld de, OTClassName
	call PlaceString
	ld h, b
	ld l, c
	ld de, .SpaceString
	call PlaceString
	push bc
	callba Battle_GetTrainerName
	pop hl
	ld de, wStringBuffer1
	jr PlaceCommandCharacter

.rival
	ld de, RivalName
	jr PlaceCommandCharacter

.linkbattle
	ld de, OTClassName
	jr PlaceCommandCharacter

.SpaceString
	db " "
TerminatorText:
	db "@"

PlaceCommandCharacter::
	call PlaceString
	ld h, b
	ld l, c
	pop de
	jp NextChar

TMCharText:: db "TM@"
TrainerCharText:: db "Trainer@"
PCCharText:: db "PC@"
RocketCharText:: db "Rocket@"
PlacePOKeText:: db "Poké@"
SixDotsCharText:: db "……@"
EnemyText:: db "Enemy @"
WildText:: db "Wild @"
PlacePKMNText:: db "<PK><MN>@" ; PK MN
PlacePOKEText:: db "<PO><KE>@" ; PO KE

NextLineChar::
	pop hl
	ld bc, SCREEN_WIDTH * 2
	add hl, bc
	push hl
	jp NextChar

LinebreakText::
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	push hl
	jp NextChar

LineChar::
	pop hl
	hlcoord TEXTBOX_INNERX, TEXTBOX_INNERY + 2
	push hl
	jp NextChar

Paragraph::
	push de

	ld a, [wLinkMode]
	cp LINK_COLOSSEUM
	jr z, .linkbattle
	call LoadBlinkingCursor

.linkbattle
	call WaitUpdateOAM
	call ButtonSound
	hlcoord TEXTBOX_INNERX, TEXTBOX_INNERY
	lb bc, TEXTBOX_INNERH - 1, TEXTBOX_INNERW
	call ClearBox
	call UnloadBlinkingCursor
	ld c, 20
	call DelayFrames
	hlcoord TEXTBOX_INNERX, TEXTBOX_INNERY
	pop de
	jp NextChar

ContText::
	ld a, [wLinkMode]
	and a
	call z, LoadBlinkingCursor

	call WaitUpdateOAM

	push de
	call ButtonSound
	pop de

	ld a, [wLinkMode]
	and a
	call z, UnloadBlinkingCursor

ScrollText::
	push de
	ld e, 20
.loop
	call DelayFrame
	call GetJoypad
	ld a, [hJoyDown]
	and A_BUTTON | B_BUTTON
	jr nz, .break
	dec e
	jr nz, .loop
.break
	call TextScroll
	call TextScroll
	hlcoord TEXTBOX_INNERX, TEXTBOX_INNERY + 2
	pop de
	jp NextChar

SDoneText:
	push hl
	call WaitButton
	jr DoneText_NoPush

Text_PlaySFXAndPrompt:
	ld hl, TerminatorText
	push hl
	call PlayWaitSFX

; fallthrough
PromptText::
	push hl
	ld a, [wLinkMode]
	cp LINK_COLOSSEUM
	call nz, LoadBlinkingCursor
	call WaitUpdateOAM
	call ButtonSound
	ld a, [wLinkMode]
	cp LINK_COLOSSEUM
	jr z, DoneText
	call UnloadBlinkingCursor
	jr DoneText_NoPush

DoneText::
	push hl
DoneText_NoPush:
	ld hl, wTextEndPointer
	inc de
	ld a, e
	ld [hli], a
	ld [hl], d
	pop hl
	ld b, h
	ld c, l
	pop hl
	ld de, TerminatorText - 1
	ret

TextScroll::
	hlcoord TEXTBOX_INNERX, TEXTBOX_INNERY
	decoord TEXTBOX_INNERX, TEXTBOX_INNERY - 1
	ld b, TEXTBOX_INNERH - 1

.col
	ld c, TEXTBOX_INNERW

.row
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .row

	inc de
	inc de
	inc hl
	inc hl
	dec b
	jr nz, .col

	hlcoord TEXTBOX_INNERX, TEXTBOX_INNERY + 2
	ld a, " "
	ld bc, TEXTBOX_INNERW
	call ByteFill
	ld c, 5
	jp DelayFrames

WaitUpdateOAM::
	push bc
	ld a, [hOAMUpdate]
	push af
	ld a, 1
	ld [hOAMUpdate], a

	call ApplyTilemapInVBlank

	pop af
	ld [hOAMUpdate], a
	pop bc
	ret

LoadBlinkingCursor::
	ld a, "▼"
	ldcoord_a 18, 17
	ret

UnloadBlinkingCursor::
	lda_coord 17, 17
	ldcoord_a 18, 17
	ret

FarText::
	call StackCallInBankA

PlaceText::
	; similar to PlaceString, places text from de to hl, using standard text commands instead of db's
	; exits with hl pointing after the text and bc pointing to the next position to write
	ld b, h
	ld c, l
	ld h, d
	ld l, e
	callba GetCurrentColumn
	ld [wInitialTextColumn], a
	; fallthrough

ProcessTextCommands::
	ld a, [hli]
	cp "@"
	jr z, .done
	call NextTextCommand
	jr ProcessTextCommands
.done
	ld hl, wTextEndPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

NextTextCommand:
	cp LEAST_CHAR
	jr nc, Text_TX
	cp LEAST_CHAR - $40 ; lowest PlaceString char minus minimum value to represent a byte of TX_FAR
	jr nc, Text_TX_FAR

	push hl
	push bc
	ld c, a
	ld b, 0
	ld hl, TextCommands
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	ld e, a
	pop bc
	pop hl

_de_::
	push de
	ret

TextCommands::
	dw Text_TX_RAM
	dw Text_START_ASM
	dw Text_TX_NUM
	dw Text_TX_COMPRESSED
TextCommandsEnd:

Text_TX::
; TX
; write text until "@"
; ["...@"]
	dec hl

	ld d, h
	ld e, l
	ld h, b
	ld l, c
	call PlaceString
	ld h, d
	ld l, e
	inc hl
	ret

Text_TX_RAM::
; text_from_ram
; write text from a ram address
; little endian
; [$01][addr]

	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push hl
	ld h, b
	ld l, c
	call PlaceString
	pop hl
	ret

Text_TX_FAR::
; text_far
; write text from a different bank
; little endian
; [upper byte of addr][addr][bank]
	add $40 - (LEAST_CHAR - $40)
	ld d, a

	ld a, [hli]
	ld e, a ; lower byte
	ld a, [hli] ; bank

	bit 7, a
	jr z, .text_far
	res 7, a
	ld hl, TerminatorText
.text_far
	call StackCallInBankA

.Function:
	push hl
	ld h, d
	ld l, e
	call ProcessTextCommands
	pop hl
	ret

Text_START_ASM::
; TX_ASM

	bit 7, h
	jr nz, .not_rom
	jp hl

.not_rom
	ld [hCrashSavedA], a
	ld a, $4
	jp Crash

Text_TX_NUM::
; TX_NUM
; [$09][addr][hi:bytes lo:digits]
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	ld b, a
	and $f
	ld c, a
	ld a, b
	and $f0
	swap a
	set PRINTNUM_RIGHTALIGN_F, a
	ld b, a
	call PrintNum
	ld b, h
	ld c, l
	pop hl
	ret

Text_TX_COMPRESSED::
	ld a, [hROMBank]
	jpba PrintCompressedString