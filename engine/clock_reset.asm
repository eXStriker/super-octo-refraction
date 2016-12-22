ResetClock_GetWraparoundTime: ; 20000 (8:4000)
	push hl
	dec a
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, .WrapAroundTimes
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld c, [hl]
	pop hl
	ret
; 20015 (8:4015)

.WrapAroundTimes: ; 20015
clock_reset_data: macro
	dw \1 ; address
	db \2 ; max value
	db \3 ; x coord
	endm

	clock_reset_data wClockResetWeekday,  7,  4
	clock_reset_data wClockResetHours,   24, 12
	clock_reset_data wClockResetMinutes, 60, 15
; 20021

RestartClock: ; 20021 (8:4021)
; If we're here, we had an RTC overflow.
	ld hl, .Text_ClockTimeMayBeWrong
	call PrintText
	ld hl, wOptions
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]
	call LoadStandardMenuDataHeader
	call ClearTileMap
	ld hl, .Text_SetWithControlPad
	call PrintText
	call .SetClock
	call ExitMenu
	pop bc
	ld hl, wOptions
	ld [hl], b
	ld c, a
	ret
; 20047 (8:4047)

.Text_ClockTimeMayBeWrong: ; 0x20047
	; The clock's time may be wrong. Please reset the time.
	text_jump UnknownText_0x1c40e6
; 0x2004c

.Text_SetWithControlPad: ; 0x2004c
	; Set with the Control Pad. Confirm: A Button Cancel:  B Button
	text_jump UnknownText_0x1c411c
; 0x20051

.SetClock: ; 20051 (8:4051)
	ld a, 1
	ld [wClockResetCurrentField], a ; which digit
	ld [wClockResetPreviousField], a
	ld a, 8
	ld [wClockResetYCoord], a
	call UpdateTime
	call GetWeekday
	ld [wClockResetWeekday], a
	ld a, [hHours]
	ld [wClockResetHours], a
	ld a, [hMinutes]
	ld [wClockResetMinutes], a

.loop
	call .joy_loop
	jr nc, .loop
	and a
	ret nz
	call .PrintTime
	ld hl, .Text_IsThisOK
	call PrintText
	call YesNoBox
	jr c, .cancel
	ld a, [wClockResetWeekday]
	ld [wStringBuffer2], a
	ld a, [wClockResetHours]
	ld [wStringBuffer2 + 1], a
	ld a, [wClockResetMinutes]
	ld [wStringBuffer2 + 2], a
	xor a
	ld [wStringBuffer2 + 3], a
	call InitTime
	call .PrintTime
	ld hl, .Text_ClockReset
	call PrintText
	call WaitPressAorB_BlinkCursor
	xor a
	ret

.cancel
	ld a, $1
	ret
; 200b0 (8:40b0)

.Text_IsThisOK: ; 0x200b0
	; Is this OK?
	text_jump UnknownText_0x1c415b
; 0x200b5

.Text_ClockReset: ; 0x200b5
	; The clock has been reset.
	text_jump UnknownText_0x1c4168
; 0x200ba

.joy_loop
	call GetJoypadForQuantitySelectionMenus
	ld c, a
	push af
	call .PrintTime
	pop af
	bit A_BUTTON_F, a
	jr nz, .press_A
	bit B_BUTTON_F, a
	jr nz, .press_B
	bit D_UP_F, a
	jr nz, .pressed_up
	bit D_DOWN_F, a
	jr nz, .pressed_down
	bit D_LEFT_F, a
	jr nz, .pressed_left
	bit D_RIGHT_F, a
	jr nz, .pressed_right
	jr .joy_loop

.press_A
	ld a, $0
	scf
	ret

.press_B
	ld a, $1
	scf
	ret

.pressed_up
	ld a, [wClockResetCurrentField]
	call ResetClock_GetWraparoundTime
	ld a, [de]
	inc a
	ld [de], a
	cp b
	jr c, .done_scroll
	ld a, $0
	ld [de], a
	jr .done_scroll

.pressed_down
	ld a, [wClockResetCurrentField]
	call ResetClock_GetWraparoundTime
	ld a, [de]
	dec a
	ld [de], a
	cp -1
	jr nz, .done_scroll
	ld a, b
	dec a
	ld [de], a
	jr .done_scroll

.pressed_left
	ld hl, wClockResetCurrentField
	dec [hl]
	jr nz, .done_scroll
	ld [hl], $3
	jr .done_scroll

.pressed_right
	ld hl, wClockResetCurrentField
	inc [hl]
	ld a, [hl]
	cp $4
	jr c, .done_scroll
	ld [hl], $1

.done_scroll
	xor a
	ret

.PrintTime: ; 2011f (8:411f)
	hlcoord 0, 5
	lb bc, 5, 18
	call TextBox
	decoord 1, 8
	ld a, [wClockResetWeekday]
	ld b, a
	callba PrintDayOfWeek
	ld a, [wClockResetHours]
	ld b, a
	ld a, [wClockResetMinutes]
	ld c, a
	decoord 11, 8
	callba PrintHoursMins
	ld a, [wClockResetPreviousField]
	lb de, " ", " "
	call .PlaceChars
	ld a, [wClockResetCurrentField]
	lb de, "▲", "▼"
	call .PlaceChars
	ld a, [wClockResetCurrentField]
	ld [wClockResetPreviousField], a
	ret
; 20160 (8:4160)

.PlaceChars: ; 20168 (8:4168)
	push de
	call ResetClock_GetWraparoundTime
	ld a, [wClockResetYCoord]
	dec a
	ld b, a
	call Coord2Tile
	pop de
	ld [hl], d
	ld bc, 2 * SCREEN_WIDTH
	add hl, bc
	ld [hl], e
	ret
; 2017c (8:417c)
