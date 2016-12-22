RestartStopwatch::
	; c = which stopwatch
	xor a
	ld b, a
	inc b
	scf
	inc c
.loop
	rla
	dec c
	jr nz, .loop
	ld hl, wStopwatchControl
	or [hl]
	ld [hl], a
	; fallthrough

ReadStopwatch::
	; c = which stopwatch
	; b = bit 0: reset after reading, bit 1: read formatted
	; reading formatted returns hours in b, minutes in c, seconds in d and hundredths in e; otherwise return frame count in bcde
	push bc
	call ReadStopwatch_RetrieveStopwatch
	pop hl
	bit 1, h
	ret z

; fallthrough
FormatStopwatchCounter:
	; takes in a counter in bcde, returns hours in b, minutes in c, seconds in d and hundredths in e; returns $ff in hours on overflow
	; the hours value will also be in hLongQuotient (this value cannot overflow)
	; this function relies on the fact that there are 70,224 CPU clocks between consecutive vblanks
	; which (given the CPU speed of 4,194,304 Hz) amounts to a fps value of (2 ^ 18) / 4389
	push bc
	ld bc, 4389
	call Multiply16
	ld hl, hProduct
	xor a
	ld [hli], a
	ld [hli], a
	ld a, b
	ld [hli], a
	ld [hl], c
	pop bc
	push de
	ld de, 4389
	call AddNTimes16
	ld hl, hProduct
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld l, [hl]
	ld h, a
	xor a
	rept 2
		srl b
		rr c
		rr h
		rr l
		rra
	endr
	rlca
	rlca
	pop de
	push hl
	push bc
	ld hl, hMultiplicand
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld [hl], 25
	predef Multiply
	ld hl, hProduct + 1
	ld a, [hli]
	ld d, 0
	bit 7, [hl]
	jr z, .hundredths_done
	inc a
	cp 100
	jr c, .hundredths_done
	sub 100
	inc d
.hundredths_done
	ld e, a
	ld hl, hDividend
	rept 2
		pop bc
		ld a, b
		ld [hli], a
		ld a, c
		ld [hli], a
	endr
	bit 0, d
	jr z, .seconds_done
.increment_seconds
	dec hl
	inc [hl]
	jr z, .increment_seconds
	ld hl, hDivisor
.seconds_done
	xor a
	ld [hli], a
	ld [hl], 60
	predef DivideLong
	ld d, [hl]
	ld [hl], 60
	predef DivideLong
	ld c, [hl]
	ld hl, hLongQuotient + 2
	ld a, [hli]
	and a
	jr nz, .overflow
	ld b, [hl]
	ret
.overflow
	ld b, $ff
	scf
	ret

ReadStopwatch_RetrieveStopwatch:
	ld a, BANK(wStopwatchCounters)
	call StackCallInWRAMBankA

.Function:
	ld hl, wStopwatchCounters
	ld a, c
	and 7
	ld e, a
	sla e
	sla e
	ld d, 0
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	bit 0, b
	ld b, [hl]
	ret z
	xor a
	ld [hld], a
	ld [hld], a
	ld [hld], a
	ld [hld], a
	ret
	
PrintFormattedStopwatchValue::
	; prints a stopwatch value that is already formatted
	; reads the value from a pointer at bc and prints at coordinates indicated by de
	push de
	ld h, b
	ld l, c
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	pop hl
	jp _PrintFormattedStopwatchValue

PrintStopwatchValue::
	; prints a stopwatch indicated by bc at the coordinates indicated by de
	; if b = 0 then c is a stopwatch number, otherwise bc itself is a pointer to the stopwatch value (big endian)
	push de
	ld a, b
	and a
	jr nz, .value_in_buffer
	ld b, 2
	call ReadStopwatch
	jr .value_obtained
.value_in_buffer
	ld h, b
	ld l, c
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	call FormatStopwatchCounter
.value_obtained
	pop hl
	; fallthrough

_PrintFormattedStopwatchValue:
	ld a, b
	cp 100
	jr nc, .overflowed
	and a
	jr nz, .has_hours
	ld a, c
	and a
	jr nz, .has_minutes
	ld a, " "
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, d
	ld c, 10
	call SimpleDivide
	ld c, a
	ld a, b
	and a
	jr nz, .over_10_seconds
	ld a, " "
	jr .loaded_seconds
.over_10_seconds
	add a, "0"
.loaded_seconds
	ld [hli], a
	ld a, c
	add a, "0"
	ld [hli], a
.display_hundredths
	ld a, "."
	ld [hli], a
	ld a, e
	ld c, 10
	call SimpleDivide
	ld c, a
	ld a, b
	add a, "0"
	ld [hli], a
	ld a, c
	add a, "0"
	ld [hl], a
	ret
.overflowed
	ld a, "?"
	rept 8
		ld [hli], a
	endr
	ret
.has_hours
	push bc
	ld a, b
	ld c, 10
	call SimpleDivide
	ld c, a
	ld a, b
	and a
	jr nz, .over_10_hours
	ld a, " "
	jr .loaded_hours
.over_10_hours
	add a, "0"
.loaded_hours
	ld [hli], a
	ld a, c
	add a, "0"
	ld [hli], a
	pop bc
	push de
	ld d, c
	call .display_next_component
	pop de
	jr .display_next_component
.has_minutes
	ld a, c
	ld c, 10
	call SimpleDivide
	ld c, a
	ld a, b
	and a
	jr nz, .over_10_minutes
	ld a, " "
	jr .loaded_minutes
.over_10_minutes
	add a, "0"
.loaded_minutes
	ld [hli], a
	ld a, c
	add a, "0"
	ld [hli], a
	call .display_next_component
	jp .display_hundredths
.display_next_component
	ld a, ":"
	ld [hli], a
	ld a, d
	ld c, 10
	call SimpleDivide
	ld c, a
	ld a, b
	add a, "0"
	ld [hli], a
	ld a, c
	add a, "0"
	ld [hli], a
	ret
