_PlaceVWFString:
; place vwf string of de to hl with options b
	call SetupVWFBitMask
.loop
	call PlaceVWFChar_BitmaskSetup
	ret c
	call z, Place1pxSpace
	jr .loop

_PlaceVWFChar:
	call SetupVWFBitMask
PlaceVWFChar_BitmaskSetup:
	ld a, [de]
	inc de
	cp "@"
	jp z, .terminator
	cp "<LNBRK>"
	jp z, .newtile
	cp "┘"
	jp z, .hairspace
	cp " "
	jp z, .space
	cp $80
	jp c, .invalid
	push de
	push hl
	cp $ae ; o
	ld d, 0
	jr nc, .secondlist
	ld hl, VWFPosList1
	sub $80
	ld e, a
	add hl, de
	ld a, [hli]
	push hl
	ld e, a
	ld hl, VWF1
	jr .done
.secondlist
	cp $e1 ; <PK>
	jr nc, .thirdlist
	ld hl, VWFPosList2
	sub $ae
	ld e, a
	add hl, de
	ld a, [hli]
	push hl
	ld e, a
	ld hl, VWF2
	jr .done
.thirdlist
	ld hl, VWFPosList3
	sub $e1
	ld e, a
	add hl, de
	ld a, [hli]
	push hl
	ld e, a
	ld hl, VWF3
	jr .done
.done
	add hl, de
	ld a, l
	ld [hPrintNum1], a
	ld a, h
	ld [hPrintNum2], a
	pop hl
	ld a, [hl]
	sub e
	jr z, .invalid_2
	pop hl
	push af
	ld a, [hPrintNum1]
	ld e, a
	ld a, [hPrintNum2]
	ld d, a
	pop af
.drawloop
	push af
	ld a, [de]
	inc de
	push de
	push hl
	ld d, a
	ld e, 8
	bit 3, b
	jr nz, .twobpp
.onebpp
	ld a, [hl]
	or c
	sla d
	jr c, .black
	xor c
.black
	ld [hli], a
	dec e
	jr nz, .onebpp
	jr .drawdone
.twobpp
	ld a, [hl]
	or c
	xor c
	ld [hli], a
	ld a, [hl]
	or c
	xor c
	ld [hl], a
	sla d
	jr nc, .white
	dec hl
	bit 4, b
	jr z, .skip1
	ld a, [hl]
	or c
	ld [hl], a
.skip1
	inc hl
	bit 5, b
	jr z, .white
	ld a, [hl]
	or c
	ld [hl], a
.white
	inc hl
	dec e
	jr nz, .twobpp
.drawdone
	pop hl
	pop de
	call ShiftVWFBitMask
	pop af
	dec a
	jr nz, .drawloop
	pop de
.hairspace
	xor a
	ret
.invalid_2
	pop hl
	pop de
.invalid
	ld a, 1
	and a
	ret
.terminator
	scf
	ret
.newtile
	ld a, c
	cp $40
	jr nz, .newtileloop
	ld c, $80
.newtileloop
	ld a, c
	cp $80
	jr z, .invalid
	call Place1pxSpace
	jr .newtileloop
.space
	ld a, 4
.spaceloop
	push af
	call Place1pxSpace
	pop af
	dec a
	jr nz, .spaceloop
	jr .invalid

SetupVWFBitMask:
	ld a, b
	and $7
	inc a
	ld c, 0
	scf
.loop
	rr c
	dec a
	jr nz, .loop
	ret

Place1pxSpace:
	push hl
	push de
	ld d, 8
.loop2
	ld a, [hl]
	or c
	xor c
	ld [hli], a
	bit 3, b
	jr z, .onebpp
	ld a, [hl]
	or c
	xor c
	ld [hli], a
.onebpp
	dec d
	jr nz, .loop2
	pop de
	pop hl

ShiftVWFBitMask:
	ld a, b
	inc b
	rrc c
	ret nc
	and $f8
	ld b, a
	push de
	ld de, 8
	add hl, de
	bit 3, b
	jr z, .onebpp
	add hl, de
.onebpp
	pop de
	ret

VWFPosList1:
; A - n
	db 0, 7, 14, 21, 28, 35, 42, 49, 56, 61, 68, 75, 81, 88, 95, 102
	db 109, 116, 123, 130, 137, 144, 151, 158, 165, 172, 179, 183, 187, 189, 191, 194
	db 197, 202, 207, 212, 217, 222, 226, 231, 235, 236, 239, 243, 244, 249, 254

VWFPosList2:
; o - '
	db 0, 5
	db 10, 15, 20, 25, 29, 34, 39, 46, 53, 57, 62, 62, 68, 75, 82, 89
	db 95, 102, 109, 116, 122, 128, 133, 136, 139, 142, 145, 148, 151, 154, 157, 160
	db 163, 170, 174, 182, 190, 198, 205, 212, 212, 212, 212, 219, 224, 229, 236, 243
	db 250, 252

VWFPosList3:
; <PK> - 9
	db 0, 7, 14, 20, 20, 20, 28, 32, 34, 41, 48, 55, 60, 65, 72
	db 79, 84, 89, 91, 98, 100, 105, 112, 118, 125, 132, 139, 146, 153, 160, 167
	db 175

VWF1: INCBIN "gfx/misc/font_vwf_1.1bpp"
VWF2: INCBIN "gfx/misc/font_vwf_2.1bpp"
VWF3: INCBIN "gfx/misc/font_vwf_3.1bpp"