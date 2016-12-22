UpdateStopwatches:
	ld a, [wStopwatchControl]
	and a
	ret z
	ld b, a
	ld a, BANK(wStopwatchCounters)
	ld [rSVBK], a
	ld a, b
	ld hl, wStopwatchCounters
	ld bc, 4
.next_counter
	and a
	ret z
	rra ;and clears carry
	jr nc, .skip_counter
	rept 3
		inc [hl]
		jr nz, .counter_updated
		inc l ;since the initial address is aligned to a multiple of 4, there will never be carry from l into h
	endr
	inc [hl]
.counter_updated
	; this resets the lower two bits to point hl to the beginning of the counter
	; it's a minor speed save over push/pop, but it requires the initial address to be a multiple of 4
	res 0, l
	res 1, l
.skip_counter
	add hl, bc
	jr .next_counter
