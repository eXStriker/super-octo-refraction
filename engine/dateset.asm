CalendarSet::
	ld a, [hInMenu]
	push af
	xor a
	ld [wSpriteUpdatesEnabled], a
	ld [wJumptableIndex], a
	inc a
	ld [hInMenu], a

	call ClearTileMap
	call ClearSprites

	call SpeechTextBox
	ld hl, CalendarSet_IntroText
	call PrintText
	jr .handleLoop

.restart
	ld a, 3
	ld [wJumptableIndex], a
	call DrawMonth
.loop
	call CalendarSet_JumpTable
.handleLoop:
	ld a, [wJumptableIndex]
	bit 7, a
	jr z, .loop
	call ClearSprites
	call ConfirmDateAndTimeText
	call SpeechTextBox
	ld hl, AskDateOkayText
	call PrintText
	call YesNoBox
	jr c, .restart
	ld a, [wDatesetYear]
	ld [CurYear], a
	ld a, [wDatesetMonth]
	ld [CurMonth], a
	ld a, [wDatesetDay]
	ld [CurDay], a
	call ClearTileMap
	callba ClearSpriteAnims
	pop af
	ld [hInMenu], a
	ret

CalendarSet_JumpTable:
	call RunAnonymousJumptable

; functions
	dw CalendarSet_Next
	dw CalendarSet_InitGraphics
	dw SelectingMonthYear
	dw SelectingDay
	dw CalendarSet_Quit

CalendarSet_Quit:
	ld hl, wJumptableIndex
	set 7, [hl]
	ret

CalendarSet_InitGraphics:
	xor a
	ld [hBGMapMode], a
	call ClearTileMapNoDelay
	call CopyTilemapAtOnce
	call .InitGraphics
	ld a, $1
	ld [hBGMapMode], a
	ret

.InitGraphics:
	call LoadStandardFont
	call LoadFontsBattleExtra
	ld hl, VTiles2
	ld de, CalendarNumbersGFX
	lb bc, BANK(CalendarNumbersGFX), 28
	call Request1bpp
	ld hl, VTiles0
	ld de, CalendarCursorGFX
	lb bc, BANK(CalendarCursorGFX), 1
	call Request2bpp

	ld a, 16
	ld [wDatesetYear], a
	ld a, 11 ; December
	ld [wDatesetMonth], a
	ld a, 24 ; 25th
	ld [wDatesetDay], a

	; load palettes
	ld b, SCGB_SCROLLINGMENU
	predef GetSGBLayout
	callba ApplyPals
	ld a, 1
	ld [hCGBPalUpdate], a
	call DelayFrame
CalendarSet_Next:
	ld hl, wJumptableIndex
	inc [hl]
	ret

CalendarSet_Prev:
	ld hl, wJumptableIndex
	dec [hl]
	ret

SelectingMonthYear:
	; clear sprite anim struct for cursor
	callba ClearSpriteAnims
	call ClearSprites
	; init arrows at month selection
	call DrawMonth
	jr .handleLoop

.loop
	call z, DrawMonth
	call DelayFrameIfNotPassed
.handleLoop
	call SelectingMonthYear_JoypadAction
	jr nc, .loop
	ret

SelectingMonthYear_JoypadAction:
	call GetJoypad
	ld a, [hJoyPressed]
	bit A_BUTTON_F, a
	jr nz, .a_button
	bit D_UP_F, a
	jr nz, .d_up
	bit D_DOWN_F, a
	jr nz, .d_down
	bit D_LEFT_F, a
	jr nz, .d_left
	bit D_RIGHT_F, a
	jr nz, .d_right
	ld a, 1
	and a
	ret

.a_button
	call CalendarSet_Next
	scf
	ret

.d_up
	ld a, [wDatesetYear]
	cp 249
	jr c, .okay_up
	ld a, -1
.okay_up
	inc a
	ld [wDatesetYear], a
	xor a
	ret

.d_down
	ld a, [wDatesetYear]
	and a
	jr nz, .okay_down
	ld a, 250
.okay_down
	dec a
	ld [wDatesetYear], a
	xor a
	ret

.d_left
	ld a, [wDatesetMonth]
	and a
	jr nz, .okay_left
	call .d_down
	ld a, 12
.okay_left
	dec a
	ld [wDatesetMonth], a
	xor a
	ret

.d_right
	ld a, [wDatesetMonth]
	cp 11
	jr c, .okay_right
	call .d_up
	ld a, -1
.okay_right
	inc a
	ld [wDatesetMonth], a
	xor a
	ret

SelectingDay:
	; clear arrows at month selection
	ld a, " "
	ldcoord_a 1, 2
	ldcoord_a 11, 2
	; init sprite anim struct for cursor
	depixel 7, 5
	ld a, SPRITE_ANIM_INDEX_CALENDAR_CURSOR
	call _InitSpriteAnimStruct
	hlcoord 10, 15
	ld de, .String
	call PlaceText
	jr .handleLoop

.loop
	callba PlaySpriteAnimationsAndDelayFrame
.handleLoop
	call SelectingDay_JoypadAction
	jr nc, .loop
	ret

.String:
	ctxt "A: Confirm"
	next "B: Back"
	done

SelectingDay_JoypadAction:
	call GetJoypad
	ld a, [hJoyPressed]
	bit A_BUTTON_F, a
	jr nz, .a_button
	bit B_BUTTON_F, a
	jr nz, .b_button
	bit D_UP_F, a
	jr nz, .d_up
	bit D_DOWN_F, a
	jr nz, .d_down
	bit D_LEFT_F, a
	jr nz, .d_left
	bit D_RIGHT_F, a
	jr nz, .d_right
	and a
	ret

.a_button
	call CalendarSet_Next
	scf
	ret

.b_button
	call CalendarSet_Prev
	scf
	ret

.d_up
	ld a, [wDatesetDay]
	and a
	ret z
	sub 7
	jr nc, .done_up
	xor a
.done_up
	ld [wDatesetDay], a
	ret

.d_down
	ld a, [wDatesetMonthLength]
	dec a
	ld b, a
	ld a, [wDatesetDay]
	add 7
	cp b
	jr c, .okay_down
	ld a, b
.okay_down
	ld [wDatesetDay], a
	and a
	ret

.d_left
	ld a, [wDatesetDay]
	and a
	ret z
	dec a
	ld [wDatesetDay], a
	and a
	ret

.d_right
	ld a, [wDatesetMonthLength]
	ld b, a
	ld a, [wDatesetDay]
	inc a
	cp b
	jr nc, .okay_right
	ld [wDatesetDay], a
.okay_right
	and a
	ret

DrawMonth:
	xor a
	ld [hBGMapMode], a
	call ClearTileMapNoDelay
	call .DrawMonth
	ld a, [wJumptableIndex]
	cp 3 ; hacky fix to clear arrows here
	jr nz, .notRedrawingMonth
	; clear arrows at month selection
	ld a, " "
	ldcoord_a 1, 2
	ldcoord_a 11, 2
.notRedrawingMonth
	call CopyTilemapAtOnce
	ld a, $1
	ld [hBGMapMode], a
	ret

.DrawMonth:
	ld a, [wDatesetDay]
	push af
	xor a
	ld [wDatesetDay], a
	call Dateset_GetWeekday
	ld [wWeekdayAtStartOfMonth], a

	ld a, [wDatesetMonth]
	ld bc, 10
	ld hl, MonthLengthAndNameData
	rst AddNTimes
	ld a, [hli]
	and a
	jr nz, .got_month_length
	ld a, [wDatesetYear]
	and a
	jr z, .common
	and $3
	ld a, 29
	jr z, .got_month_length
.common
	ld a, 28
.got_month_length
	ld [wDatesetMonthLength], a
	decoord 2, 2
	ld bc, 9
	rst CopyBytes
	hlcoord 13, 2
	ld [hl], "2"
	inc hl
	ld de, wDatesetYear
	lb bc, PRINTNUM_LEADINGZEROS | 1, 3
	call PrintNum

	ld a, [wDatesetMonthLength]
	ld c, a
.loop
	ld a, [wDatesetMonthLength]
	sub c
	push bc
	call .get_tile_coord
	pop bc
	dec c
	jr nz, .loop
	ld a, "◀"
	ldcoord_a 1, 2
	ld a, "▶"
	ldcoord_a 11, 2
	ld hl, .Sprites
	ld de, Sprites
	ld bc, 8
	rst CopyBytes

	hlcoord 10, 15
	ld de, .String
	call PlaceText

	pop af
	ld [wDatesetDay], a
	ret

.get_tile_coord
	push af
	inc a
	ld c, 10
	call SimpleDivide
	ld e, a
	ld a, b
	add 10
	ld d, a
	pop af
	ld b, a
	ld a, [wWeekdayAtStartOfMonth]
	add b
	ld c, 7
	call SimpleDivide
	push af
	ld a, b
	ld bc, 2 * SCREEN_WIDTH
	hlcoord 3, 4
	rst AddNTimes
	pop af
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld [hl], d
	inc hl
	ld [hl], e
	ld bc, SCREEN_WIDTH - 1
	add hl, bc
	ld a, d
	add $e
	ld [hli], a
	ld a, e
	add $e
	ld [hl], a
	ret

.Sprites:
	db $1c, $90, $ee, (1 << OAM_Y_FLIP)
	db $24, $90, $ee, $00

.String:
	ctxt "A: Confirm"
	done

MonthLengthAndNameData:
	db 31, " January "
	db 00, " February"
	db 31, "  March  "
	db 30, "  April  "
	db 31, "   May   "
	db 30, "  June   "
	db 31, "  July   "
	db 31, "  August "
	db 30, "September"
	db 31, " October "
	db 30, " November"
	db 31, " December"

CalendarNumbersGFX: INCBIN "gfx/misc/calendar_numbers.1bpp"
CalendarCursorGFX:  INCBIN "gfx/misc/calendar_cursor.2bpp"

ConfirmDateAndTimeText:
	ld a, [wDatesetMonth]
	ld bc, 10
	ld hl, MonthLengthAndNameData + 1
	rst AddNTimes
.loop1
	dec c
	ld a, [hli]
	cp " "
	jr z, .loop1
	dec hl
	ld de, wStringBuffer1
.loop2
	ld a, [hli]
	cp " "
	jr z, .done
	ld [de], a
	inc de
	dec c
	jr nz, .loop2
.done
	ld h, d
	ld l, e
	ld [hl], " "
	inc hl
	ld a, [wDatesetDay]
	inc a
	ld c, 10
	call SimpleDivide
	ld c, a
	ld a, b
	and a
	jr z, .skip
	add "0"
	ld [hli], a
.skip
	ld a, c
	add "0"
	ld [hli], a
	ld [hl], ","
	inc hl
	ld [hl], " "
	inc hl
	ld [hl], "2"
	inc hl
	ld de, wDatesetYear
	lb bc, PRINTNUM_LEADINGZEROS | 1, 3
	call PrintNum
	ld [hl], "@"
	ret

UpdateCalendarCursor:
	push bc
	ld a, [wDatesetDay]
	ld b, a
	ld a, [wWeekdayAtStartOfMonth]
	add b
	ld c, 7
	call SimpleDivide
	ld d, a
	ld e, b
	pop bc
	swap d
	swap e
	ld hl, SPRITEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], d
	inc hl
	ld [hl], e
	ret

AskDateOkayText:
	text "<STRBF1>"
	line "Is that correct?"
	done

Dateset_GetWeekday:
	lb bc, 6, 0 ; Jan 1, 2000 is Saturday
.yearloop
	ld a, [wDatesetYear]
	cp c
	jr z, .yeardone
	ld a, b
	cp 7
	jr c, .nomod
	sub 7
.nomod
	inc b
	ld a, c
	inc c
	call IsLeapYear
	jr nc, .yearloop
	inc b
	jr .yearloop
.yeardone
	ld a, [wDatesetMonth]
	ld e, a
	cp 2 ; February
	jr c, .skipleapcheck
	ld a, c
	call IsLeapYear
	jr nc, .skipleapcheck
	inc b
.skipleapcheck
	ld d, 0
	ld hl, MonthOffsets
	add hl, de
	ld a, [hl]
	add b
	ld b, a
	ld a, [wDatesetDay]
	add b
.mod
	sub 7
	jr nc, .mod
	add 7
	ret

CalendarSet_IntroText:
	text "Please set the"
	line "year and date."
	prompt
