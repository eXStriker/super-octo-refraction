PlayBingo::
	call InitializeBingo
.loop
	call GetJoypad
	call HandleBingoCursorMovement
	call UpdateBingoCursorPosition
	call GetBingoCellFromCursor
	ld c, a
	ld hl, BingoUpdateCellStatus
	call ExecuteWithoutMapUpdates
	ld a, [hJoyPressed]
	bit B_BUTTON_F, a
	jr nz, .done
	bit A_BUTTON_F, a
	call nz, ClickBingoCell
	callba PlaySpriteAnimationsAndDelayFrame
	jr .loop
.done
	ld hl, wBingoCursorPointer
	ld a, [hli]
	ld b, [hl]
	ld c, a
	jpba DeinitializeSprite

GetNextPendingBingoLine::
	; returns in [hScriptVar] the next unawarded prize, 1 - 13. Returns 0 if all fulfilled prizes have been awarded.
	call GetBingoLines
	ld hl, wBingoAwardedPrizes
	ld a, [hli]
	xor c
	ld c, a
	ld a, [hl]
	xor b
	ld b, a
	or c
	jr z, .selected
	ld e, 0
	ld a, c
	and a
	jr nz, .find_first
	ld a, b
	ld e, 8
.find_first
	ld b, a
	and $f
	jr nz, .loop
	ld a, b
	swap a
	set 2, e
.loop
	inc e
	rrca
	jr nc, .loop
	ld a, e
.selected
	ld [hScriptVar], a
	ret

GetBingoCardStatus::
	; returns in [hScriptVar] the current card's status. 0: there are still some prizes left, 1: all prizes claimed, there is another card, 2: reached the end
	ld a, [wBingoAwardedPrizes + 1]
	and $10
	jr z, .done
	ld hl, wBingoCurrentCard
	ld a, (BingoCardsEnd - BingoCards) / 2
	cp [hl]
	ld a, 2
	jr z, .done
	dec a
.done
	ld [hScriptVar], a
	ret

MarkBingoPrizeAwarded::
	; marks the prize indicated in [hScriptVar] as awarded
	ld a, [hScriptVar]
	cp 13
	ret nc
	ld hl, wBingoAwardedPrizes
	ld b, 1
	ld c, a
	jp FlagAction

ExecuteWithoutMapUpdates::
	ld a, [hBGMapMode]
	push af
	xor a
	ld [hBGMapMode], a
	call _hl_
	pop hl ;to preserve f
	ld a, h
	ld [hBGMapMode], a
	ret

InitializeBingo:
	ld c, 1
	call FadeToWhite
	call ClearBGPalettes
	call ClearTileMap
	callba DeinitializeAllSprites
	call ClearSprites
	call ClearAttrMap
	call DisableLCD
	xor a
	ld [hSCX], a
	ld [hSCY], a
	ld [rSCX], a
	ld [rSCY], a
	dec a
	ld [hWY], a
	ld [rWY], a
	ld hl, $fe00
	ld bc, $a0
	call ByteFill ;write directly to OAM since LCD is disabled
	call LoadBingoTiles
	call LoadBingoPalettes
	call CreateBingoBoard
	call LoadBingoSelectionCursor
	ld hl, wBingoCursorPointer
	ld a, c
	ld [hli], a
	ld [hl], b
	call LoadScreen
	ld de, 0
	call PlayMusic
	call EnableLCD
	callba PlaySpriteAnimationsAndDelayFrame
	ld de, MUSIC_MOBILE_ADAPTER
	call PlayMusic
	ld a, 61
	ld hl, wBingoCursorX
	ld [hli], a
	ld [hl], 56
	ld a, 12
	ld [wBingoCurrentCell], a
	ld c, a
	jp BingoPrintCellStatus

LoadBingoTiles:
	lb bc, BANK(Font), (FontEnd - Font) / ((1 tiles) / 2) ;half a tile because it's a 1bpp
	ld de, Font
	ld hl, VTiles1
	call Copy1bpp
	ld hl, BingoTiles
	ld de, VTiles2
	call _Decompress
	ld hl, VTiles2 tile $7f
	ld bc, 1 tiles
	xor a
	jp ByteFill

LoadBingoPalettes:
	ld a, [rSVBK]
	push af
	ld a, BANK(BGPals)
	ld [rSVBK], a
	ld hl, BingoPalettes
	ld bc, BingoPalettesEnd - BingoPalettes
	ld de, BGPals
	rst CopyBytes
	ld hl, BingoCursorPalette
	ld bc, 1 palettes
	ld de, OBPals
	rst CopyBytes
	pop af
	ld [rSVBK], a
	jp ForceUpdateCGBPals

RedrawBingoBoard:
	call ClearAttrMap
	call CreateBingoBoard
	ld a, [wBingoCurrentCell]
	cp 25
	ret nc
	ld c, a
	jp BingoPrintCellStatus

CreateBingoBoard:
	call DrawBingoBoard
	jp FillBingoBoard

BINGO_PALETTE_BORDERS   EQU 1
BINGO_PALETTE_INSIDE    EQU 2

DrawBingoBoard:
	ld hl, BingoTilemapCompressed
	ld de, TileMap
	call _Decompress
	hlcoord 4, 1, AttrMap
	ld e, 14
.loop
	ld a, BINGO_PALETTE_BORDERS
	ld [hli], a
	ld bc, 14
	inc a ; BINGO_PALETTE_INSIDE
	call ByteFill
	ld [hl], BINGO_PALETTE_BORDERS
	ld bc, 5
	add hl, bc
	dec e
	jr nz, .loop
	hlcoord 4, 0, AttrMap
	ld c, 16
	push bc
	ld a, BINGO_PALETTE_BORDERS
	call ByteFill
	pop bc
	hlcoord 4, 15, AttrMap
	jp ByteFill

BINGO_NUMBER_SYMBOL_TILE        EQU $32

FillBingoBoard:
	ld hl, wBingoMarkedCells
	ld bc, 0
	ld e, $30
.loop
	; a note on implementation here: the e register contains a counter for remaining bytes (upper nibble) and remaining bits (lower nibble).
	; The counter is decremented twice: once at the beginning of the loop, and once at the end. This allows testing for special cases cheaply: the need
	; to load the next bit from the multibyte value can be tested by checking for half-carry, and the end of the loop can be checked by testing for zero.
	; Therefore, the double decrement is intentional. Do not remove.
	xor a
	dec e
	daa ; transfer the half carry into a zero flag (note that this requires a to be zero)
	jr z, .no_reload
	ld d, [hl]
	inc hl
.no_reload
	push bc
	push hl
	srl d
	push de
	sbc a
	call FillBingoCell
	pop de
	pop hl
	pop bc
	inc c
	ld a, c
	cp 5
	jr c, .same_row
	inc b
	ld c, 0
.same_row
	ld a, b
	cp c
	jr nz, .not_center
	cp 2
	jr nz, .not_center
	inc c
.not_center
	dec e
	jr nz, .loop
	hlcoord 0, 1
	ld de, .card_text
	call PlaceString
	hlcoord 0, 2
	ld a, BINGO_NUMBER_SYMBOL_TILE
	ld [hli], a
	ld a, "."
	ld [hli], a
	ld a, [wBingoCurrentCard]
	call PrintTwoDigitValue
	ld de, .left_text
	hlcoord 0, 5
	call PlaceString
	ld hl, wBingoMarkedCells
	ld b, 3
	call CountSetBits
	ld a, 24
	sub c
	hlcoord 2, 6
	call PrintTwoDigitValue
	hlcoord 0, 9
	ld de, .line_text
	call PlaceString
	call GetBingoLines
	res 4, b
	push bc
	ld hl, sp + 0
	ld b, 2
	call CountSetBits
	pop bc
	hlcoord 2, 10
	jp PrintTwoDigitValue
.card_text
	db "CARD@"
.left_text
	db "LEFT@"
.line_text
	db "LINE@"

BINGO_PALETTE_CHECKED   EQU 3
BINGO_PALETTE_UNCHECKED EQU 4

BINGO_CHECKED_FIRST_TILE        EQU $0C
BINGO_UNCHECKED_FIRST_TILE      EQU $10

FillBingoCell:
	; in: b = cell Y, c = cell X, a = value (0 unchecked, non-zero checked)
	; the coordinates for the first cell are (5, 1)
	and a
	lb de, BINGO_PALETTE_CHECKED, BINGO_CHECKED_FIRST_TILE
	jr nz, .go
	lb de, BINGO_PALETTE_UNCHECKED, BINGO_UNCHECKED_FIRST_TILE
.go
	ld a, c
	add a, a
	add a, c
	ld l, a
	ld h, 0
	ld c, b
	ld b, h
	ld a, SCREEN_WIDTH * 3
	rst AddNTimes
	push hl
	bccoord 5, 1
	add hl, bc
	ld a, e
	ld [hli], a
	inc e
	ld [hl], e
	inc e
	ld a, l
	add a, SCREEN_WIDTH - 1
	ld l, a
	jr nc, .no_carry_tilemap
	inc h
.no_carry_tilemap
	ld a, e
	ld [hli], a
	inc e
	ld [hl], e
	pop hl
	bccoord 5, 1, AttrMap
	add hl, bc
	ld a, d
	ld [hli], a
	ld [hl], a
	ld a, l
	add a, SCREEN_WIDTH - 1
	ld l, a
	jr nc, .no_carry_attrmap
	inc h
.no_carry_attrmap
	ld a, d
	ld [hli], a
	ld [hl], a
	ret

GetBingoLines:
	; returns the current bingo lines in bc
	ld hl, BingoCombinations
	ld bc, 0
	ld e, b
.loop
	ld a, [hli]
	cp -1
	ret z
	ld d, -1
.inner_loop
	inc d
	jr nz, .skip
	call IsBingoCellMarked
	jr nc, .skip
	dec d
.skip
	ld a, [hli]
	cp -1
	jr nz, .inner_loop
	inc d
	jr nz, .no_line
	push hl
	push bc
	ld hl, sp + 0
	ld b, 1
	ld c, e
	call FlagAction
	pop bc
	pop hl
.no_line
	inc e
	jr .loop

GetBingoLinesContainingCell:
	; returns in bc the lines that involve cell a
	ld bc, 0
	ld hl, BingoCombinations
	ld e, b
.loop
	push af
	push bc
	push de
	call IsInSingularArray
	pop de
	jr nc, .skip_line
	push hl
	ld hl, sp + 2
	ld c, e
	ld b, 1
	call FlagAction
	pop hl
.skip_loop
	ld a, [hli]
	cp -1
	jr nz, .skip_loop
.skip_line
	pop bc
	inc e
	cp [hl] ; a must be -1 at this point
	jr z, .done
	pop af
	jr .loop
.done
	pop af
	ret

IsBingoCellMarked:
	; in: a = cell number
	; returns carry if the cell is marked
	cp 12
	jr z, .marked
	jr c, .lower
	dec a
.lower
	push bc
	push hl
	ld hl, wBingoMarkedCells
	ld c, a
	ld b, CHECK_FLAG
	call FlagAction
	pop hl
	pop bc
	ret z
.marked
	scf
	ret

PrintTwoDigitValue:
	; while PrintNum can handle this, it's a lot simpler and faster to use a special routine
	; prints two-digit value from a to hl, right-aligned, adding a space if less than 10
	push bc
	ld c, 10
	call SimpleDivide
	ld c, a
	ld a, b
	and a
	jr z, .less_than_ten
	add a, "0"
	jr .ok
.less_than_ten
	ld a, " "
.ok
	ld [hli], a
	ld a, c
	add a, "0"
	ld [hli], a
	pop bc
	ret

LoadScreen::
	; DO NOT CALL THIS FUNCTION WITH THE LCD ENABLED
	ld hl, hBGMapMode
	ld [hl], 2 ; go backwards, it's easier
.loop
	push hl
	call UpdateBGMap
	call UpdateBGMap ; so it updates both halves
	pop hl
	dec [hl]
	jr nz, .loop
	inc [hl]
	ret

LoadBingoSelectionCursor:
	ld a, SPRITE_ANIM_INDEX_NONE
	ld e, 200 ; offscreen
	call _InitSpriteAnimStruct
	push bc
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], 0
	lb bc, BANK(MemoryGameGloveGFX), 4 tiles
	ld de, MemoryGameGloveGFX
	ld hl, VTiles0
	call Copy2bpp
	pop bc
	ret

CURSOR_LEFT_LIMIT  EQU 4
CURSOR_RIGHT_LIMIT EQU 119
CURSOR_DOWN_LIMIT  EQU 112

HandleBingoCursorMovement:
	ld hl, wBingoCursorX
	ld a, [hJoyDown]
	ld e, a
	bit D_LEFT_F, e
	jr z, .left_handled
	dec [hl]
	ld a, [hl]
	cp CURSOR_LEFT_LIMIT
	jr nc, .left_handled
	ld [hl], CURSOR_LEFT_LIMIT
.left_handled
	bit D_RIGHT_F, e
	jr z, .right_handled
	inc [hl]
	ld a, [hl]
	cp CURSOR_RIGHT_LIMIT + 1
	jr c, .right_handled
	ld [hl], CURSOR_RIGHT_LIMIT
.right_handled
	inc hl
	bit D_UP_F, e
	jr z, .up_handled
	dec [hl]
	bit 7, [hl]
	jr z, .up_handled
	ld [hl], 0
.up_handled
	bit D_DOWN_F, e
	ret z
	inc [hl]
	ld a, [hl]
	cp CURSOR_DOWN_LIMIT + 1
	ret c
	ld [hl], CURSOR_DOWN_LIMIT
	ret

CURSOR_HORIZONTAL_OFFSET EQU 43
CURSOR_VERTICAL_OFFSET   EQU 24

UpdateBingoCursorPosition:
	ld hl, wBingoCursorPointer
	ld a, [hli]
	ld c, a
	ld b, [hl]
	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [wBingoCursorX]
	add a, CURSOR_HORIZONTAL_OFFSET
	ld [hli], a
	ld a, [wBingoCursorY]
	add a, CURSOR_VERTICAL_OFFSET
	ld [hl], a
	ret

HideBingoCursor:
	ld hl, wBingoCursorPointer
	ld a, [hli]
	ld c, a
	ld b, [hl]
	ld hl, SPRITEANIMSTRUCT_YCOORD
	add hl, bc
	ld [hl], 200
	ret

GetBingoCellFromCursor:
	; each cell comprises the space of its own 2x2 tiles, and a two-pixel border around it
	; in other words, cells are 20 pixels wide and tall, thus leaving a 4-pixel separation between cells
	push hl
	push bc
	push de
	ld hl, wBingoCursorX
	ld a, [hli]
	sub 6
	jr c, .out
	cp 120
	jr nc, .out
	ld c, 24
	call SimpleDivide
	cp 20
	jr nc, .out
	ld d, b
	ld a, [hl]
	sub 6
	jr c, .out
	ld c, 24
	call SimpleDivide
	cp 20
	jr nc, .out
	ld a, b
	cp 5
	jr nc, .out
	ld c, 5
	call SimpleMultiply
	add a, d
	jr .done
.out
	ld a, -1
.done
	pop de
	pop bc
	pop hl
	ret

BINGO_PROGRESS_BAR_START_TILES  EQU $14
BINGO_PROGRESS_BAR_MIDDLE_TILES EQU $19
BINGO_PROGRESS_BAR_END_TILES    EQU $22

DrawBingoProgressBar::
	; in: hl: coordinates, bc: value, de: goal, carry flag: 16-tile bar (8 if no carry)
	push hl
	push af
	ld a, b
	cp d
	jr c, .go
	jr nz, .full_bar
	ld a, c
	cp e
	jr nc, .full_bar
.go
	ld hl, hDividend
	xor a
	ld [hli], a
	ld [hl], b
	inc hl
	ld [hl], c
	inc hl
	ld [hli], a
	ld a, d
	ld [hli], a
	ld [hl], e
	predef DivideLong
	ld a, [hLongQuotient + 3]
	ld b, a
	ld c, 15
	srl b
	ld d, b
	srl d
	pop af
	jr c, .sixteen
	ld b, d
	ld c, 7
.sixteen
	pop hl
	ld e, 4
	call .get_min
	ld a, e
	add a, BINGO_PROGRESS_BAR_START_TILES
	ld [hli], a
	ld a, b
	sub e
	jr z, .whole_bar_empty
	ld b, a
.loop
	ld e, 8
	call .get_min
	ld a, e
	add a, BINGO_PROGRESS_BAR_MIDDLE_TILES
	ld [hli], a
	ld a, b
	sub e
	jr z, .empty_bar
	ld b, a
	dec c
	jr nz, .loop
	ld a, b
	add a, BINGO_PROGRESS_BAR_END_TILES
	ld [hl], a
	jr .done_filling_bar
.whole_bar_empty
	inc c
.empty_bar
	ld a, BINGO_PROGRESS_BAR_MIDDLE_TILES
	jr .handle_empty_loop
.empty_bar_loop
	ld [hli], a
.handle_empty_loop
	dec c
	jr nz, .empty_bar_loop
	ld [hl], BINGO_PROGRESS_BAR_END_TILES
.done_filling_bar
	; here, we select a palette for the progress bar
	; d contains a value between 1 and 63 (0 becomes 1) that will be mapped to a color
	; 1 = red, 32 = yellow, 63 = green; the rest is linear interpolation
	ld a, d
	and a
	jr nz, .not_zero
	inc a
.not_zero
	cp 32
	jr nc, .over_half
	dec a
	swap a
	rlca
	push af
	or $1f
	ld c, a
	pop af
	and $1f
	ld b, a
	jr .set_palette
.over_half
	xor $3f
	or $e0
	ld c, a
	ld b, 3
	jr .set_palette
.full_bar
	pop af
	sbc a
	and 8
	add a, 7
	ld c, a
	pop hl
	ld [hl], BINGO_PROGRESS_BAR_START_TILES + 4
	inc hl
	ld a, BINGO_PROGRESS_BAR_MIDDLE_TILES + 8
.full_bar_loop
	ld [hli], a
	dec c
	jr nz, .full_bar_loop
	ld [hl], BINGO_PROGRESS_BAR_END_TILES + 4
	ld bc, $03e0 ; green
.set_palette
	ld a, [rSVBK]
	push af
	ld a, BANK(BGPals)
	ld [rSVBK], a
	ld hl, BGPals + 4
	ld a, c
	ld [hli], a
	ld [hl], b
	pop af
	ld [rSVBK], a
	ld a, 1
	ld [hCGBPalUpdate], a
	ret
.get_min
	; returns in e the minimum of e and b (a destroyed)
	ld a, b
	cp e
	ret nc
	ld e, a
	ret

BINGO_BLUE_SLASH_TILE           EQU $27
BINGO_BLUE_NUMBER_TILES         EQU $28
BINGO_BLUE_MINUS_TILE           EQU $33

BingoBlueText::
	; makes the text at hl, c characters long, become blue
	; only affects numbers, slashes and minus signs
	inc c
	jr .handle_loop
.loop
	ld a, [hl]
	cp "-"
	jr z, .minus
	cp "/"
	jr z, .slash
	cp "0"
	jr c, .updated
	sub "0" - BINGO_BLUE_NUMBER_TILES
	jr .updated
.minus
	ld a, BINGO_BLUE_MINUS_TILE
	jr .updated
.slash
	ld a, BINGO_BLUE_SLASH_TILE
.updated
	ld [hli], a
.handle_loop
	dec c
	jr nz, .loop
	ret

BINGO_MESSAGE_CORNER_TILE       EQU $34
BINGO_MESSAGE_HORIZONTAL_TILE   EQU $35
BINGO_MESSAGE_VERTICAL_TILE     EQU $36

; tile flips: $20 H-flipped, $40 V-flipped, $60 both

MakeBingoTextBox:
	; makes a 20 by e textbox at x = 0, y = 1
	ld a, e
	add a, a
	add a, a
	ld c, e
	swap c
	add a, c
	; a = e * 20
	ld c, a
	xor a
	ld b, a
	hlcoord 0, 1, AttrMap
	push bc
	push hl
	call ByteFill
	pop hl
	call .move_to_end_of_line
	ld [hl], $20
	inc hl
	ld c, e
	dec c
	jr .attribute_loop_handle
.attribute_loop
	call .move_to_end_of_line
	ld [hl], $20
	inc hl
.attribute_loop_handle
	dec c
	jr nz, .attribute_loop
	ld bc, 19
	ld a, $40
	call ByteFill
	ld [hl], $60
	pop bc
	ld a, " "
	hlcoord 0, 1
	push hl
	call ByteFill
	pop hl
	ld [hl], BINGO_MESSAGE_CORNER_TILE
	inc hl
	ld bc, 18
	ld a, BINGO_MESSAGE_HORIZONTAL_TILE
	call ByteFill
	ld [hl], BINGO_MESSAGE_CORNER_TILE
	inc hl
	ld c, e
	dec c
	jr .tile_loop_handle
.tile_loop
	ld [hl], BINGO_MESSAGE_VERTICAL_TILE
	call .move_to_end_of_line
	ld [hl], BINGO_MESSAGE_VERTICAL_TILE
	inc hl
.tile_loop_handle
	dec c
	jr nz, .tile_loop
	ld [hl], BINGO_MESSAGE_CORNER_TILE
	inc hl
	ld bc, 18
	ld a, BINGO_MESSAGE_HORIZONTAL_TILE
	call ByteFill
	ld [hl], BINGO_MESSAGE_CORNER_TILE
	ret
.move_to_end_of_line
	ld a, l
	add a, 19
	ld l, a
	ret nc
	inc h
	ret

BingoUpdateCellStatus:
	; in: c = new cell number
	ld a, c
	ld hl, wBingoCurrentCell
	cp [hl]
	ret z
	ld [hl], a
	cp 25
	ld c, a
	jr c, BingoPrintCellStatus
	; fallthrough

BingoClearCellStatus:
	hlcoord 0, 16
	ld bc, 2 * SCREEN_WIDTH
	ld a, " "
	jp ByteFill

BingoPrintCellStatus:
	; in: c = cell number
	push bc
	call BingoClearCellStatus
	pop bc
	call BingoGetCurrentCellPointer
	jr c, .free_space
	push de
	push hl
	ld c, 1
	call _hl_
	hlcoord 0, 16
	call PlaceText
	pop hl
	ld c, 0
	call _hl_
	ld a, b
	and a
	jr nz, .hundred_thousand_overflow
	ld a, c
	cp 1
	jr c, .print_value
	jr nz, .hundred_thousand_overflow
	ld a, d
	cp $86
	jr c, .print_value
	jr nz, .hundred_thousand_overflow
	cp $9f
	jr c, .print_value
.hundred_thousand_overflow
	; $1869f = 99,999
	ld bc, $1
	ld de, $869f
.print_value
	ld a, $85
	ld [hDigitsFlags], a
	hlcoord 9, 17
	push bc
	push de
	predef PrintBigNumber
	pop de
	pop bc
	dec c ;bc can only be 0 or 1 here
	jr z, .sixteen_bit_overflow
	ld b, d
	ld c, e
	jr .value_copied
.sixteen_bit_overflow
	dec bc ;if we jumped, bc was 0
.value_copied
	pop de
	push bc
	ld bc, 0
	push de
	hlcoord 14, 17
	ld a, "/"
	ld [hli], a
	ld a, $85
	predef PrintBigNumber
	pop de
	pop bc
	ld a, b
	cp d
	jr nz, .compared
	ld a, c
	cp e
.compared
	push af
	hlcoord 0, 17
	and a
	call DrawBingoProgressBar
	pop af
	ret c
	hlcoord 8, 17
	ld c, 12
	jp BingoBlueText
.free_space
	ld de, .free_space_text
	hlcoord 0, 16
	jp PlaceText
.free_space_text
	ctxt "Free space - no goal"
	db   "Checked by default." ;db instead of nl because the previous line reaches 20 characters
	done

BingoGetCurrentCellPointer:
	; in: c = cell number
	; out: hl = pointer, de = threshold; returns carry if c is free space
	ld a, c
	cp 12
	jr z, .free_space
	jr nc, .selected_cell
	inc c
.selected_cell
	ld a, [wBingoCurrentCard]
	ld hl, BingoCards - 2
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld b, [hl]
	ld l, c
	ld h, d
	ld c, a
	add hl, hl
	add hl, hl
	add hl, bc
	dec hl
	ld a, [hld]
	ld d, a
	ld a, [hld]
	ld e, a
	ld a, [hld]
	ld l, [hl]
	ld h, a
	and a
	ret
.free_space
	scf
	ret

BINGO_BLUE_C_UPPERCASE          EQU $37
BINGO_BLUE_D                    EQU $38
BINGO_BLUE_E                    EQU $39
BINGO_BLUE_L                    EQU $3A
BINGO_BLUE_M                    EQU $3B
BINGO_BLUE_O                    EQU $3C
BINGO_BLUE_P                    EQU $3D
BINGO_BLUE_T                    EQU $3E
BINGO_BLUE_EXCLAMATION_MARK     EQU $3F

DisplayBingoCellInfobox:
	; in: c = cell number
	; returns carry if the goal was reached, no carry if it wasn't
	call BingoGetCurrentCellPointer
	ret c ; sanity check. Literally.
	push hl
	push de
	ld c, 2
	call _hl_
	ld b, 0
	push bc
	push de
	ld a, c
	add a, 7
	ld e, a
	call MakeBingoTextBox
	pop de
	hlcoord 1, 3
	call PlaceText
	pop bc
	pop de
	pop hl
	push de
	push bc
	push hl
	hlcoord 12, 4
	ld a, SCREEN_WIDTH
	rst AddNTimes
	ld bc, 0
	ld a, "/"
	ld [hli], a
	ld a, $85
	ld [hDigitsFlags], a
	predef PrintBigNumber
	pop hl
	ld c, 0
	call _hl_
	pop hl
	push bc
	ld b, h
	ld c, l
	ld a, SCREEN_WIDTH
	hlcoord 2, 4
	rst AddNTimes
	pop bc
	ld a, $8a
	ld [hDigitsFlags], a
	push hl
	push bc
	push de
	predef PrintBigNumber
	pop bc
	pop hl
	ld a, h
	or l
	jr z, .no_overflow
	ld bc, $ffff
.no_overflow
	pop hl
	pop de
	ld a, b
	cp d
	jr nz, .compared
	ld a, c
	cp e
.compared
	jr nc, .completed
	ld a, SCREEN_WIDTH - 1
	add a, l
	ld l, a
	jr nc, .no_overflow_on_bar_position
	inc h
.no_overflow_on_bar_position
	scf
	call DrawBingoProgressBar
	and a
	ret
.completed
	push hl
	ld c, 16
	call BingoBlueText
	pop de
	ld a, SCREEN_WIDTH + 3
	add a, e
	ld e, a
	jr nc, .no_overflow_on_text_position
	inc d
.no_overflow_on_text_position
	ld hl, .completed_string
	ld bc, .completed_string_end - .completed_string
	rst CopyBytes
	scf
	ret
.completed_string
	db BINGO_BLUE_C_UPPERCASE
	db BINGO_BLUE_O
	db BINGO_BLUE_M
	db BINGO_BLUE_P
	db BINGO_BLUE_L
	db BINGO_BLUE_E
	db BINGO_BLUE_T
	db BINGO_BLUE_E
	db BINGO_BLUE_D
	db BINGO_BLUE_EXCLAMATION_MARK
.completed_string_end

ClickBingoCell:
	ld a, [wBingoCurrentCell]
	cp 12
	jr z, .nope
	cp 25
	jr nc, .nope
	ld c, a
	or $80
	push af
	push bc
	call HideBingoCursor
	callba PlaySpriteAnimationsAndDelayFrame
	pop bc
	push bc
	ld hl, DisplayBingoCellInfobox
	call ExecuteWithoutMapUpdates
	pop bc
	jr nc, .no_cell_check
	ld a, c
	cp 12
	jr c, .below
	dec c
.below
	ld hl, wBingoMarkedCells
	ld b, CHECK_FLAG
	push bc
	push hl
	call FlagAction
	pop hl
	pop bc
	jr nz, .no_cell_check
	dec b
	call FlagAction
	pop af
	and $7f
	push af
.no_cell_check
	call CopyTilemapAtOnce
	pop af
	bit 7, a
	call z, PlayCellSound
.loop
	call DelayFrame
	call GetJoypad
	ld a, [hJoyPressed]
	and B_BUTTON
	jr z, .loop
	ld hl, RedrawBingoBoard
	call ExecuteWithoutMapUpdates
	call CopyTilemapAtOnce
	jp UpdateBingoCursorPosition
.nope
	ld de, SFX_WRONG
	jp PlayWaitSFX

PlayCellSound:
	call GetBingoLinesContainingCell
	push bc
	call GetBingoLines
	pop de
	bit 4, b
	jr nz, .completed_card
	ld a, b
	and d
	jr nz, .line
	ld a, c
	and e
	jr nz, .line
	ld de, SFX_LEVEL_UP
	jp PlayWaitSFX
.line
	ld de, SFX_KEY_ITEM
	jp PlayWaitSFX
.completed_card
	ld de, SFX_DONATION
	jp PlayWaitSFX

BingoCombinations::
	; list of scoring combinations
	; the free space in the middle (cell 12) is intentionally not included even in the combinations that would normally have it
	
	; rows
	db 0, 1, 2, 3, 4, -1
	db 5, 6, 7, 8, 9, -1
	db 10, 11, 13, 14, -1
	db 15, 16, 17, 18, 19, -1
	db 20, 21, 22, 23, 24, -1
	
	; columns
	db 0, 5, 10, 15, 20, -1
	db 1, 6, 11, 16, 21, -1
	db 2, 7, 17, 22, -1
	db 3, 8, 13, 18, 23, -1
	db 4, 9, 14, 19, 24, -1
	
	; downwards diagonal
	db 0, 6, 18, 24, -1
	
	; upwards diagonal
	db 4, 8, 16, 20, -1
	
	; full card
	db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, -1
	
	; and nothing else
	db -1

BingoTiles: INCBIN "gfx/bingo_tiles.2bpp.lz"
BingoPalettes: INCLUDE "gfx/bingo_tiles.asm"
BingoPalettesEnd:
BingoCursorPalette:
	RGB 31, 31, 31
	RGB 20, 20, 31
	RGB 09, 00, 31
	RGB 00, 00, 00

BingoTilemapCompressed:
	lzrepeat 4, $7f
	lzzero 1
	lzrepeat 14, $01
	lzdata $02
	lzrepeat 4, $7f
	lzdata $03, $0b, $0b, $0a
	lzcopy normal, 11, -3
	lzdata $07
	lzcopy normal, 25, -20
	lzdata $08, $08, $09
	lzcopy normal, 11, -3
	lzdata $07
	lzcopy normal, 224, -60
	lzdata $04
	lzrepeat 14, $05
	lzdata $06
	lzend

; Bingo check functions are called to check the values used for each bingo card.
; in: de = threshold as declared, c = function
; function: 0 = return current value (return in bcde), 1 = return short description (return pointer in de, 1 line, 20 chars)
;           2 = return long description (pointer in de, line count in c, max 10 lines, 18 chars)

BingoCards:
	dw BingoCard1
	dw BingoCard2
	dw BingoCard3
BingoCardsEnd:

BingoCard1:
	dw BingoCheckMinerLevel, 10
	dw BingoCheckBattlesWon, 500
	dw BingoCheckJewelerLevel, 3
	dw BingoCheckSootSackAsh, 1000
	dw BingoCheckBadgesOwned, 8
	
	dw BingoCheckTimesPachisiWon, 1
	dw BingoCheckGoldTokensFound, 5
	dw BingoCheckFlew, 1
	dw BingoCheckMoneyInHandThousands, 30
	dw BingoCheckSecretRijonItemsFound, 1
	
	dw BingoCheckFossilsRevived, 1
	dw BingoCheckBicycleOwned, 1
	dw BingoCheckEeveelutionsOwned, 1
	dw BingoCheckOwnedTyranitar, 1
	
	dw BingoCheckTMs, 10
	dw BingoCheckKantoStartersOwned, 1
	dw BingoCheckSmelterLevel, 5
	dw BingoCheckJohtoStartersOwned, 1
	dw BingoCheckCoins, 600
	
	dw BingoCheckPokemonOwned, 40
	dw BingoCheckRijonCitiesVisited, 3
	dw BingoCheckOrphanPoints, 50
	dw BingoCheckMaxPartyLevel, 65
	dw BingoCheckPokemonSeen, 100

BingoCard2:
	dw BingoCheckBattlesWon, 1200
	dw BingoCheckJohtoStartersOwned, 3
	dw BingoCheckKantoStartersOwned, 3
	dw BingoCheckTowerTycoonsDefeated, 1
	dw BingoCheckGoldTokensFound, 30
	
	dw BingoCheckSmelterLevel, 20
	dw BingoCheckJewelerLevel, 10
	dw BingoCheckMoneyInBank, 65000
	dw BingoCheckBallMakingLevel, 5
	dw BingoCheckMinerLevel, 30
	
	dw BingoCheckBadgesOwned, 20
	dw BingoCheckSecretRijonItemsFound, 2
	dw BingoCheckOrphanPoints, 500
	dw BingoCheckArcadeMaxScore, 6000
	
	dw BingoCheckSootSackAsh, 4000
	dw BingoCheckEeveelutionsOwned, 4
	dw BingoCheckTimesDefeatedRijonLeague, 1
	dw BingoCheckFossilsRevived, 3
	dw BingoCheckPokemonOwned, 75
	
	dw BingoCheckBattleArcadeMaxRound, 3
	dw BingoCheckTimesPachisiWon, 2
	dw BingoCheckFoundRivalSecretHidingPlace, 1
	dw BingoCheckMaxLevelPokemonOwned, 1
	dw BingoCheckNaljoGuardiansOwned, 1

BingoCard3:
	dw BingoCheckMaxLevelPokemonOwned, 6
	dw BingoCheckGoldTokensFound, 90
	dw BingoCheckPokemonSeen, 240
	dw BingoCheckSecretRijonItemsFound, 6
	dw BingoCheckEeveelutionsOwned, 8

	dw BingoCheckCoins, 3500
	dw BingoCheckBallMakingLevel, 50
	dw BingoCheckSmelterLevel, 60
	dw BingoCheckMinerLevel, 70
	dw BingoCheckJewelerLevel, 40

	dw BingoCheckBattlesWon, 4000
	dw BingoCheckMoneyInHandThousands, 200
	dw BingoCheckOwnedPhancero, 1
	dw BingoCheckTimesDefeatedRijonLeague, 3

	dw BingoCheckBattleArcadeMaxRound, 7
	dw BingoCheckMysteryZoneCleared, 1
	dw BingoCheckTowerTycoonsDefeated, 3
	dw BingoCheckTMs, 60
	dw BingoCheckArcadeMaxScore, 20000

	dw BingoCheckLegendaryBirdsOwned, 3
	dw BingoCheckPokemonOwned, 160
	dw BingoCheckFossilsRevived, 10
	dw BingoCheckNaljoGuardiansOwned, 4
	dw BingoCheckCraftedMasterBall, 1

PrintNumberToBuffer:
	; prints the value in de to wStringBuffer4
	push bc
	push de
	push hl
	ld hl, wStringBuffer4 + 17
	ld a, d
	ld [hli], a
	ld [hl], e
	ld hl, wStringBuffer4
	ld bc, 6
	ld a, "@"
	push hl
	call ByteFill
	pop hl
	ld de, wStringBuffer4 + 17
	lb bc, $42, 5
	call PrintNum
	pop hl
	pop de
	pop bc
	ret

BingoCheckEvent:
	ld b, CHECK_FLAG
	predef EventFlagAction
	ld bc, 0
	ld d, b
	ld e, b
	ret z
	inc e
	ret

BingoCheckPokemonOwned:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	call PrintNumberToBuffer
	ld c, 3
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld hl, PokedexCaught
	ld b, EndPokedexCaught - PokedexCaught
	call CountSetBits
	ld e, a
	ld bc, 0
	ld d, b
	ret
.long_description_text
	ctxt "Own at least <STRBF4>"
	nl   "different species"
	nl   "of #mon."
	done
.short_description_text
	ctxt "#mon owned"
	done

BingoCheckPokemonSeen:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long description
	call PrintNumberToBuffer
	ld c, 3
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld hl, PokedexSeen
	ld b, EndPokedexSeen - PokedexSeen
	call CountSetBits
	ld e, a
	ld bc, 0
	ld d, b
	ret
.long_description_text
	ctxt "See at least <STRBF4>"
	nl   "different species"
	nl   "of #mon."
	done
.short_description_text
	ctxt "#mon seen"
	done

BingoCheckJohtoStartersOwned:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	ld a, e
	cp 3
	push af
	call PrintNumberToBuffer
	pop af
	ld c, 2
	ld de, .long_description_text_all
	ret z
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld de, .starters
	call CountOwnedMonsFromList
	ld bc, 0
	ld d, b
	ret
.long_description_text
	ctxt "Own <STRBF4> of the"
	nl   "Johto starters."
	done
.long_description_text_all
	ctxt "Own all of the"
	nl   "Johto starters."
	done
.short_description_text
	ctxt "Johto starters owned"
	done
.starters
	db CHIKORITA
	db CYNDAQUIL
	db TOTODILE
	db -1

BingoCheckKantoStartersOwned:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	ld a, e
	cp 3
	push af
	call PrintNumberToBuffer
	pop af
	ld c, 2
	ld de, .long_description_text_all
	ret z
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld de, .starters
	call CountOwnedMonsFromList
	ld bc, 0
	ld d, b
	ret
.long_description_text
	ctxt "Own <STRBF4> of the"
	nl   "Kanto starters."
	done
.long_description_text_all
	ctxt "Own all of the"
	nl   "Kanto starters."
	done
.short_description_text
	ctxt "Kanto starters owned"
	done
.starters
	db BULBASAUR
	db CHARMANDER
	db SQUIRTLE
	db -1

BingoCheckOwnedTyranitar:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	ld c, 1
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld hl, PokedexCaught
	lb bc, CHECK_FLAG, TYRANITAR - 1
	call FlagAction
	ld bc, 0
	ld d, b
	ld e, b
	ret z
	inc e
	ret
.long_description_text
	ctxt "Own a Tyranitar."
	done
.short_description_text
	ctxt "Tyranitar owned"
	done

BingoCheckTimesDefeatedRijonLeague:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	ld a, e
	cp 2
	push af
	call PrintNumberToBuffer
	pop af
	ld c, 2
	ld de, .long_description_text_many
	ret nc
	ld de, .long_description_text_once
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld hl, wHallOfFameCount
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld bc, 0
	ret
.long_description_text_once
	ctxt "Defeat the Rijon"
	nl   "League once."
	done
.long_description_text_many
	ctxt "Defeat the Rijon"
	nl   "League <STRBF4> times."
	done
.short_description_text
	ctxt "Rijon League won"
	done

BingoCheckSmelterLevel:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	call PrintNumberToBuffer
	ld c, 2
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld a, [SmeltingLevel]
	ld bc, 0
	ld d, b
	ld e, a
	ret
.long_description_text
	ctxt "Reach Smelting"
	nl   "level <STRBF4>."
	done
.short_description_text
	ctxt "Smelting level"
	done

BingoCheckJewelerLevel:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	call PrintNumberToBuffer
	ld c, 2
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld a, [JewelingLevel]
	ld bc, 0
	ld d, b
	ld e, a
	ret
.long_description_text
	ctxt "Reach Jeweling"
	nl   "level <STRBF4>."
	done
.short_description_text
	ctxt "Jeweling level"
	done

BingoCheckMoneyInHandThousands:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	call PrintNumberToBuffer
	ld c, 3
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld hl, Money
	xor a
	ld [hDividend], a
	ld a, [hli]
	ld [hDividend + 1], a
	ld a, [hli]
	ld [hDividend + 2], a
	ld a, [hl]
	ld [hDividend + 3], a
	; $3e8 = 1000
	ld a, 3
	ld [hDivisor], a
	ld a, $e8
	ld [hDivisor + 1], a
	predef DivideLong
	ld hl, hLongQuotient
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ret
.long_description_text
	ctxt "Have at least"
	nl   "¥<STRBF4> thousand"
	nl   "in cash."
	done
.short_description_text
	ctxt "Thousand ¥ in hand"
	done

BingoCheckMinerLevel:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	call PrintNumberToBuffer
	ld c, 2
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld a, [MiningLevel]
	ld bc, 0
	ld d, b
	ld e, a
	ret
.long_description_text
	ctxt "Reach Mining"
	nl   "level <STRBF4>."
	done
.short_description_text
	ctxt "Mining level"
	done

BingoCheckBadgesOwned:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	call PrintNumberToBuffer
	ld c, 1
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld b, 3
	ld hl, Badges
	call CountSetBits
	ld bc, 0
	ld d, b
	ld e, a
	ret
.long_description_text
	ctxt "Get <STRBF4> badges."
	done
.short_description_text
	ctxt "Badges obtained"
	done

BingoCheckSecretRijonItemsFound:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	ld a, e
	cp 2
	push af
	call PrintNumberToBuffer
	pop af
	ld de, .long_description_text_many
	ret nc
	ld de, .long_description_text_one
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld hl, .item_flags
	call CountEventFlagsFromList
	ld bc, 0
	ret
.long_description_text_one
	ctxt "Find a secret"
	nl   "Rijon item."
	done
.long_description_text_many
	ctxt "Find <STRBF4> secret"
	nl   "Rijon items."
	done
.short_description_text
	ctxt "Secret Rijon items"
	done
.item_flags
	dw EVENT_HIDDEN_GOLD_EGG
	dw EVENT_ROUTE_56_HIDDENITEM_SILVER_EGG
	dw EVENT_SILK_TUNNEL_1F_HIDDENITEM_CRYSTAL_EGG
	dw EVENT_HAUNTED_FOREST_GATE_HIDDENITEM_RUBY_EGG
	dw EVENT_ROUTE_75_HIDDENITEM_SAPPHIRE_EGG
	dw EVENT_CASTRO_FOREST_HIDDENITEM_EMERALD_EGG
	dw EVENT_SEASHORE_GYM_HIDDENITEM_PRISM_KEY
	dw -1

BingoCheckOrphanPoints:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	call PrintNumberToBuffer
	ld c, 2
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld hl, wAccumulatedOrphanPoints
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ret
.long_description_text
	ctxt "Get <STRBF4> or more"
	nl   "Orphan Points."
	done
.short_description_text
	ctxt "Orphan Points"
	done

BingoCheckTowerTycoonsDefeated:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	ld c, 3
	ld a, d
	and a
	jr nz, .many
	ld a, e
	cp 2
	jr nc, .many
	ld de, .long_description_text_once
	ret
.many
	call PrintNumberToBuffer
	ld de, .long_description_text_many
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld hl, wTowerTycoonsDefeated
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld bc, 0
	ret
.long_description_text_once
	ctxt "Defeat a Battle"
	nl   "Tower Tycoon once."
	done
.long_description_text_many
	ctxt "Defeat a Battle"
	nl   "Tower Tycoon"
	nl   "<STRBF4> times."
	done
.short_description_text
	ctxt "Tycoons defeated"
	done

BingoCheckSootSackAsh:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	call PrintNumberToBuffer
	ld c, 2
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld hl, SootSackAsh
	ld a, [hli]
	ld e, [hl]
	ld d, a
	ld bc, 0
	ret
.long_description_text
	ctxt "Get <STRBF4> ash in"
	nl   "your Soot Sack."
	done
.short_description_text
	ctxt "Ash in Soot Sack"
	done

BingoCheckEeveelutionsOwned:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	call PrintNumberToBuffer
	ld c, 2
	ld a, e
	cp 8
	ld de, .long_description_text_all
	ret nc
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld de, .eeveelutions
	call CountOwnedMonsFromList
	ld bc, 0
	ld d, b
	ret
.long_description_text
	ctxt "Own <STRBF4> of Eevee's"
	nl   "evolutions."
	done
.long_description_text_all
	ctxt "Own all of Eevee's"
	nl   "evolutions."
	done
.short_description_text
	ctxt "Eeveelutions owned"
	done
.eeveelutions
	db VAPOREON
	db JOLTEON
	db FLAREON
	db ESPEON
	db UMBREON
	db LEAFEON
	db GLACEON
	db SYLVEON
	db -1

BingoCheckBallMakingLevel:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	call PrintNumberToBuffer
	ld c, 2
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld a, [BallMakingLevel]
	ld bc, 0
	ld d, b
	ld e, a
	ret
.long_description_text
	ctxt "Reach Ball Making"
	nl   "level <STRBF4>."
	done
.short_description_text
	ctxt "Ball Making level"
	done

BingoCheckFossilsRevived:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	ld a, d
	and a
	jr nz, .many
	ld a, e
	cp 2
	jr nc, .many
	ld de, .long_description_text_one
	ld c, 1
	ret
.many
	call PrintNumberToBuffer
	ld c, 2
	ld de, .long_description_text_many
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld hl, wFossilsRevived
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld bc, 0
	ret
.long_description_text_one
	ctxt "Revive a fossil."
	done
.long_description_text_many
	ctxt "Revive at least"
	nl   "<STRBF4> fossils."
	done
.short_description_text
	ctxt "Fossils revived"
	done

BingoCheckBattleArcadeMaxRound:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	call PrintNumberToBuffer
	ld c, 2
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld hl, wBattleArcadeMaxRound
	ld a, [hli]
	ld e, [hl]
	ld d, a
	ld bc, 0
	ret
.long_description_text
	ctxt "Clear round <STRBF4> in"
	nl   "the Battle Arcade."
	done
.short_description_text
	ctxt "Battle Arcade round"
	done

BingoCheckTimesPachisiWon:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	ld c, 2
	ld a, d
	and a
	jr nz, .multiple
	ld a, e
	cp c ; = 2
	jr nc, .multiple
	ld de, .long_description_text_once
	ret
.multiple
	call PrintNumberToBuffer
	ld de, .long_description_text_many
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld hl, wPachisiWinCount
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld bc, 0
	ret
.long_description_text_once
	ctxt "Win at Pachisi"
	nl   "at least once."
	done
.long_description_text_many
	ctxt "Win at Pachisi"
	nl   "<STRBF4> times."
	done
.short_description_text
	ctxt "Pachisi wins"
	done

BingoCheckFoundRivalSecretHidingPlace:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	ld c, 3
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld de, EVENT_RIVAL_GOLDENROD_BASEMENT
	jp BingoCheckEvent
.long_description_text
	ctxt "Find your rival's"
	nl   "final secret"
	nl   "hiding place."
	done
.short_description_text
	ctxt "Found rival's hideout"
	done

BingoCheckBicycleOwned:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long description
	ld c, 2
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld de, EVENT_GOT_BICYCLE
	jp BingoCheckEvent
.long_description_text
	ctxt "Receive and own a"
	nl   "Bicycle."
	done
.short_description_text
	ctxt "Bicycle owned"
	done

BingoCheckMaxLevelPokemonOwned:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	call PrintNumberToBuffer
	ld c, 2
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld de, 0
	ld a, [wPartyCount]
	and a
	jr z, .done_party
	ld hl, PartyMon1Level
	ld bc, PARTYMON_STRUCT_LENGTH
.party_loop
	push af
	ld a, [hl]
	cp 100
	jr c, .party_mon_not_100
	inc de
.party_mon_not_100
	pop af
	dec a
	add hl, bc
	jr nz, .party_loop
.done_party
	ld a, BANK(sBox)
	call GetSRAMBank
	ld hl, sBox
	call .count_box_mons
	ld a, [wSaveFileExists]
	and a
	jr z, .no_save
	ld a, [wSavedAtLeastOnce]
	and a
	jr z, .no_save
	lb bc, 2, 0 ; 2 = first bank with boxes
.box_loop
	ld hl, sBox1
	ld a, b
	call GetSRAMBank
.inner_box_loop
	ld a, [wCurBox]
	cp c
	call nz, .count_box_mons
	push bc
	ld bc, sBox2 - sBox1
	add hl, bc
	pop bc
	inc c
	ld a, h
	cp $bc ; past this point there is no way to store a box in SRAM, so this detects the end of the list
	jr c, .inner_box_loop
	inc b
	ld a, b
	cp 4 ; beyond the end of the box banks
	jr c, .box_loop
.no_save
	call CloseSRAM
	ld bc, 0
	ret
.long_description_text
	ctxt "Have <STRBF4> #mon"
	nl   "at level 100."
	done
.short_description_text
	ctxt "Level 100 #mon"
	done
.count_box_mons
	push hl
	push bc
	ld bc, sBoxCount - sBox
	add hl, bc
	ld a, [hl]
	and a
	jr z, .empty_box
	ld bc, sBoxMon1Level - sBoxCount
	add hl, bc
.current_box_loop
	push af
	ld a, [hl]
	cp 100
	jr c, .box_mon_not_100
	inc de
.box_mon_not_100
	pop af
	ld bc, BOXMON_STRUCT_LENGTH
	add hl, bc
	dec a
	jr nz, .current_box_loop
.empty_box
	pop bc
	pop hl
	ret

BingoCheckNaljoGuardiansOwned:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	ld c, 2
	ld a, e
	cp 4
	push af
	call PrintNumberToBuffer
	pop af
	ld de, .long_description_text_all
	ret nc
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld de, .guardians
	call CountOwnedMonsFromList
	ld bc, 0
	ld d, b
	ret
.long_description_text
	ctxt "Own <STRBF4> of the"
	nl   "Naljo guardians."
	done
.long_description_text_all
	ctxt "Own all of the"
	nl   "Naljo guardians."
	done
.short_description_text
	ctxt "Naljo guardians"
	done
.guardians
	db LIBABEEL
	db FAMBACO
	db RAIWATO
	db VARANEOUS
	db -1

BingoCheckBattlesWon:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	call PrintNumberToBuffer
	ld c, 1
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld hl, wBattlesWonCounter
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld c, [hl]
	ld b, 0
	ret
.long_description_text
	ctxt "Win <STRBF4> battles."
	done
.short_description_text
	ctxt "Battles won"
	done

BingoCheckGoldTokensFound:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	call PrintNumberToBuffer
	ld c, 2
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	callba CountFoundGoldTokens
	ld bc, 0
	ret
.long_description_text
	ctxt "Find at least"
	nl   "<STRBF4> Gold Tokens."
	done
.short_description_text
	ctxt "Gold Tokens found"
	done

BingoCheckArcadeMaxScore:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	call PrintNumberToBuffer
	ld c, 3
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld hl, wBattleArcadeMaxScore
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ret
.long_description_text
	ctxt "Get a high score"
	nl   "of <STRBF4> in the"
	nl   "Battle Arcade."
	done
.short_description_text
	ctxt "Battle Arcade score"
	done

BingoCheckCoins:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	call PrintNumberToBuffer
	ld c, 3
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld hl, Coins
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ld bc, 0
	ret
.long_description_text
	ctxt "Have at least"
	nl   "<STRBF4> coins in"
	nl   "your Coin Case."
	done
.short_description_text
	ctxt "Coins in Coin Case"
	done

BingoCheckFlew:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	ld c, 3
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld de, EVENT_USED_FLY_AT_LEAST_ONCE
	jp BingoCheckEvent
.long_description_text
	ctxt "Use Fly to travel"
	nl   "to a different"
	nl   "location."
	done
.short_description_text
	ctxt "Used Fly"
	done

BingoCheckTMs:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long description
	call PrintNumberToBuffer
	ld c, 2
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld hl, TMsHMs
	ld b, NUM_TMS >> 3
	assert (NUM_TMS & 7) == 0
	call CountSetBits
	ld e, a
	ld bc, 0
	ld d, b
	ret
.long_description_text
	ctxt "Have at least <STRBF4>"
	nl   "different TMs."
	done
.short_description_text
	ctxt "TMs owned"
	done

BingoCheckMaxPartyLevel:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long description
	call PrintNumberToBuffer
	ld c, 3
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld a, [wPartyCount]
	ld bc, PARTYMON_STRUCT_LENGTH
	ld e, b ; b = 0 from the above instruction
	and a
	jr z, .done
	ld d, a
	ld hl, PartyMon1Level
.loop
	ld a, [hl]
	add hl, bc
	cp e
	jr c, .not_higher
	ld e, a
.not_higher
	dec d
	jr nz, .loop
.done
	; b = 0 since nothing changed it
	ld c, b
	ld d, b
	ret
.long_description_text
	ctxt "Have a #mon in"
	nl   "your party reach"
	nl   "level <STRBF4>."
	done
.short_description_text
	ctxt "Maximum party level"
	done

BingoCheckRijonCitiesVisited:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	call PrintNumberToBuffer
	ld c, 2
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld hl, VisitedSpawns + 1
	ld a, [hli]
	swap a ; only the upper 4 bits contain Rijon landmarks
	ld b, a
	ld a, [hl]
	and $3f ; the upper 2 bits contain non-city Rijon landmarks (the league and Seneca Caverns)
	ld c, a
	ld a, 12 ; so the upper 4 bits of b are ignored
	ld de, 0
.loop
	srl b
	rr c
	jr nc, .ok
	inc e
.ok
	dec a
	jr nz, .loop
	ld d, b ; note that b = 0 here
	ld c, b
	ret
.long_description_text
	ctxt "Visit <STRBF4> cities or"
	nl   "towns in Rijon."
	done
.short_description_text
	ctxt "Rijon cities visited"
	done

BingoCheckMysteryZoneCleared:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long description
	ld c, 4
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld hl, wMysteryZoneWinCount
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld bc, 0
	ret
.long_description_text
	ctxt "Defeat every"
	nl   "trainer in the"
	nl   "Mystery Zone at"
	nl   "least once."
	done
.short_description_text
	ctxt "Mystery Zone cleared"
	done

BingoCheckLegendaryBirdsOwned:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	ld c, 2
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld de, .birds
	call CountOwnedMonsFromList
	ld bc, 0
	ld d, b
	ret
.long_description_text
	ctxt "Own all of the"
	nl   "legendary birds."
	done
.short_description_text
	ctxt "Legendary birds"
	done
.birds
	db ARTICUNO
	db ZAPDOS
	db MOLTRES
	db -1

BingoCheckOwnedPhancero:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	ld c, 1
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld hl, PokedexCaught
	lb bc, CHECK_FLAG, PHANCERO - 1
	call FlagAction
	ld bc, 0
	ld d, b
	ld e, b
	ret z
	inc e
	ret
.long_description_text
	ctxt "Get Phancero."
	done
.short_description_text
	ctxt "Phancero owned"
	done

BingoCheckCraftedMasterBall:
	ld a, c
	and a
	jr z, .value
	dec a
	jr z, .short_description
	; long_description
	ld c, 3
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld de, EVENT_CRAFTED_MASTER_BALL
	jp BingoCheckEvent
.long_description_text
	ctxt "Craft a Master"
	nl   "Ball using an"
	nl   "Apricorn."
	done
.short_description_text
	ctxt "Master Ball crafted"
	done

BingoCheckMoneyInBank:
	ld a, c
	add a
	jr z, .value
	dec a
	jr z, .short_description
	; long description
	call PrintNumberToBuffer
	ld c, 3
	ld de, .long_description_text
	ret
.short_description
	ld de, .short_description_text
	ret
.value
	ld hl, wBankMoney
	ld b, 0
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ret
.long_description_text
	ctxt "Have at least"
	nl   "¥<STRBF4> in your"
	nl   "bank account."
	done
.short_description_text
	ctxt "Money in bank"
	done
