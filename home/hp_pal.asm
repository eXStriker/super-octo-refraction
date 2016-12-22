SetHPPal::
; Set palette for hp bar pixel length e at hl.
	call GetHPPal
	ld [hl], d
	ret

GetHPPal::
; Get palette for hp bar pixel length e in d.

	ld d, HP_GREEN
	ld a, e
	cp 24 * 2
	ret nc
	inc d ; yellow
	cp 10 * 2
	ret nc
	inc d ; red
	ret