ResetMapBufferEventFlags::
	xor a
	ld hl, EventFlags
	ld [hli], a
	ret

ResetBikeFlags::
	xor a
	ld hl, wBikeFlags
	ld [hli], a
	ld [hl], a
	ret

ResetFlashIfOutOfCave::
	ld a, [wPermission]
	cp ROUTE
	jr z, ForceResetFlash
	cp TOWN
	ret nz
ForceResetFlash::
	ld hl, wStatusFlags2
	res 0, [hl]
	ret

FlagAction::
; Perform action b on flag c in flag array hl.

; For longer flag arrays, see BigFlagAction.
	push hl
	push bc
	push de
	ld e, c
	ld d, 0
	call BigFlagAction
	pop de
	pop bc
	pop hl

	ld [hBuffer], a
	ld a, b
	cp CHECK_FLAG
	ret nz
	ld a, [hBuffer]
	ld c, a
	and a
	ret

EventFlagAction:
	ld hl, EventFlags

BigFlagAction::
; Perform action b on bit de in flag array hl.

; inputs:
; b: function
;    0 clear bit
;    1 set bit
;    2 check bit
; de: bit number
; hl: index within bit table

	; get index within the byte
	ld a, e
	and 7

	; shift de right by three bits (get the index within memory)
	srl d
	rr e
	srl d
	rr e
	srl d
	rr e
	add hl, de

	; implement a decoder
	ld c, 1
	rrca
	jr nc, .one
	rlc c
.one
	rrca
	jr nc, .two
	rlc c
	rlc c
.two
	rrca
	jr nc, .three
	swap c
.three

	; check b's value: 0, 1, 2
	ld a, b
	cp 1
	jr c, .clearbit ; 0
	jr z, .setbit ; 1

	; check bit
	ld a, [hl]
	and c
	ld c, a
	ret

.setbit
	; set bit
	ld a, [hl]
	or c
	ld [hl], a
	ret

.clearbit
	; clear bit
	ld a, c
	cpl
	and [hl]
	ld [hl], a
	ret
