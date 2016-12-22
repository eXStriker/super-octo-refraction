LoadLCDCode::
	di
	ld hl, LCDCode
	ld de, LCD
	ld bc, LCDCodeEnd - LCDCode
	rst CopyBytes
	reti

LCDCode::
	push af
	ld a, [wLCDCPointer]
	and a
	jr z, .skip

; At this point it's assumed we're in WRAM bank 5!
	push hl
	ld a, [rLY]
	ld l, a
	ld h, wLYOverrides >> 8
	ld a, [hl]
	ld [rJOYP], a ; get overwritten with wLCDCPointer
	pop hl
.skip
	pop af
	reti
LCDCodeEnd::

LCD_VSTrick::
	push af
	ld a, [wLYOverrides]
	ld [rSCX], a
	pop af
	reti
LCD_VSTrickEnd::

LCD_LeaderPal::
	push af
	push hl
	ld a, $92
	ld [rBGPI], a
	ld a, $82
	ld [rOBPI], a
	ld a, [hPalTrick]
	ld hl, wTrainerCardLeaderPals
	add l
	ld l, a
	jr nc, .nocarry
	inc h
.nocarry
	ld a, [rSTAT]
	and 3
	jr z, .nocarry
.waithb
	ld a, [rSTAT]
	and 3
	jr nz, .waithb
	rept 4
	ld a, [hli]
	ld [rBGPD], a
	endr
	xor a
	ld [rBGPD], a
	ld [rBGPD], a
	ld a, $ff
	ld [rBGPD], a
	ld [rBGPD], a
	ld a, l
	and $f
	jr nz, .nocarry
	ld a, wTrainerCardBadgePals - wTrainerCardLeaderPals - 16
	add l
	ld l, a
	jr nc, .nocarry2
	inc h
.nocarry2
	ld a, [rSTAT]
	and 3
	jr z, .nocarry2
.waithb2
	ld a, [rSTAT]
	and 3
	jr nz, .waithb2
	rept 4
	ld a, [hli]
	ld [rOBPD], a
	endr
	xor a
	ld [rOBPD], a
	ld [rOBPD], a
	ld a, $ff
	ld [rOBPD], a
	ld [rOBPD], a
	ld a, l
	and $f
	jr nz, .nocarry2
	ld a, [hPalTrick]
	add 16
	ld [hPalTrick], a
	ld a, [rLYC]
	add 24
	ld [rLYC], a
	cp 135
	jr nz, .done
	xor a
	ld [hPalTrick], a
	ld a, 15
	ld [rLYC], a
.done
	pop hl
	pop af
	reti

DisableLCD::
; Turn the LCD off

; Don't need to do anything if the LCD is already off
	ld a, [rLCDC]
	bit 7, a ; lcd enable
	ret z

	xor a
	ld [rIF], a
	ld a, [rIE]
	ld b, a

; Disable VBlank
	res 0, a ; vblank
	ld [rIE], a

.wait
; Wait until VBlank would normally happen
	ld a, [rLY]
	cp $90
	jr c, .wait
	cp $99
	jr z, .wait

	ld a, [rLCDC]
	and %01111111 ; lcd enable off
	ld [rLCDC], a

	xor a
	ld [rIF], a
	ld a, b
	ld [rIE], a
	ret

EnableLCD::
	ld a, [rLCDC]
	set 7, a ; lcd enable
	ld [rLCDC], a
	ret
