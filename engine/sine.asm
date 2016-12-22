_Sine::
; A simple sine function.
; Return d * sin(e) in hl.

; e is a signed 6-bit value.
	ld a, e
	bit 5, a
	push af
	and $1f
	call .ApplySineWave
	pop af
	ld a, h
	ret z
	cpl
	inc a
	ret

.ApplySineWave
	ld e, a
	ld a, d
	ld d, 0
	ld hl, .sinewave
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, 0

; Factor amplitude
.multiply
	srl a
	jr nc, .even
	add hl, de
.even
	sla e
	rl d
	and a
	jr nz, .multiply
	ret

.sinewave
; A $20-word table representing a sine wave.
; 90 degrees is index $10 at a base amplitude of $100.
	sine_wave $100
