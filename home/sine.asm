Cosine::
; Return d * cos(a) in hl
	add $10 ; 90 degrees

Sine::
; Return d * sin(a) in hl
; a is a signed 6-bit value.
	ld e, a
	jpba _Sine

GetDemoSine::
	push hl
	ld l, a
	ld h, DemoSine / $100
	ld a, [hROMBank]
	ld [hBuffer], a
	ld a, BANK(DemoSine)
	ld [hROMBank], a
	ld [MBC3RomBank], a
	ld l, [hl]
	ld a, [hBuffer]
	ld [hROMBank], a
	ld [MBC3RomBank], a
	ld a, l
	pop hl
	ret
