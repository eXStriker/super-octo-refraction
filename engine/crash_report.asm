; err codes
; 00 = rst 00
; 01 = rst 38
; 02 = division by zero
; 03 = invalid character
; 04 = text script runs asm code outside ROM
; 05 = code isn't running in ROM (under normal conditions) (PC >= $8000)
; 06 = stack underflow (SP >= $c100)
; 07 = stack overflow (SP < $c000)
; 08 = invalid build number (loaded a savestate from another build)
; 09 = invalid script command
; 10 = invalid command for cmdwitharrayargs
; 11 = script stack full

pnh: MACRO
	and $f
	add "0"
	or $80
	ld [hli], a
ENDM

_Crash::
	xor a
	ld [rNR52], a

	ld de, .sparrow
	ld hl, VTiles1 + $5d0
	ld b, .sparrowend - .sparrow
.loop
	ld a, [de]
	inc de
	ld [hli], a
	ld [hli], a
	dec b
	jr nz, .loop
	ld hl, VTiles2 + $7f0
	ld bc, 16
	xor a
	ld [rSCX], a
	ld [rSCY], a
	ld [rIF], a
	ld [rIE], a
	call ByteFill
	ld a, 144
	ld [rWY], a
	ld a, [rLCDC]
	and %01100010
	ld b, a
	ld a, %00000001
	or b
	ld [rLCDC], a

	ld hl, VBGMap0
	ld bc, BG_MAP_WIDTH * BG_MAP_HEIGHT
	ld a, " "
	call ByteFill

	ld de, .string
	ld hl, VBGMap0
	jr .loop2
.writeChar
	ld [hli], a
.loop2
	ld a, [de]
	inc de
	cp "@"
	jr z, .done
	cp $4e
	jr nz, .writeChar
	ld a, l
	and $e0
	add $20
	ld l, a
	jr nc, .loop2
	inc h
	jr .loop2
.done
	ld a, [hCGB]
	and a
	jr z, .DMGskip
	ld a, 1
	ld [rVBK], a
	ld hl, VBGMap0
	ld bc, 32 * 18
	xor a
	call ByteFill
	xor a
	ld [rVBK], a
.DMGskip
	ld hl, $fe00
	lb bc, 0, 40
.sprloop
	ld [hl], b
	ld a, l
	add 4
	ld l, a
	dec c
	jr nz, .sprloop
	hlbgcoord 4, 2
	ld a, [hCrashRST]
	swap a
	pnh
	ld a, [hCrashRST]
	pnh
	hlbgcoord 15, 11
	ld a, [hROMBank]
	swap a
	pnh
	ld a, [hROMBank]
	pnh
	pop bc
	hlbgcoord 4, 9
	call .pwh
	pop bc
	hlbgcoord 13, 9
	call .pwh
	pop bc
	hlbgcoord 4, 10
	call .pwh
	pop bc
	hlbgcoord 13, 10
	call .pwh
	pop bc
	push bc
	hlbgcoord 4, 11
	call .pwh
	pop hl
	ld bc, -4
	add hl, bc
	ld b, h
	ld c, l
	hlbgcoord 0, 12
	ld e, 10
.stackloop
	ld a, [bc]
	swap a
	pnh
	ld a, [bc]
	inc bc
	pnh
	dec e
	jr nz, .stackloop
	ld hl, MapGroup
	ld a, [hli]
	push hl
	hlbgcoord 5, 13
	call .print_decimal
	pop hl
	ld a, [hli]
	push hl
	hlbgcoord 9, 13
	call .print_decimal
	pop hl
	inc hl
	ld a, [hld]
	push hl
	hlbgcoord 14, 13
	call .print_decimal
	pop hl
	ld a, [hl]
	hlbgcoord 18, 13
	call .print_decimal
	ld a, [ScriptBank]
	ld c, a
	hlbgcoord 7, 14
	call .pbh
	ld hl, ScriptPos
	ld a, [hli]
	ld b, [hl]
	ld c, a
	hlbgcoord 9, 14
	call .pwh
	ld a, [hScriptVar]
	ld c, a
	hlbgcoord 18, 14
	call .pbh
	ld hl, wScriptStackSize
	ld a, [hli]
	push hl
	hlbgcoord 4, 15
	call .pbh_noleadingzero
	pop de
	hlbgcoord 7, 15
	call .print_script_address
	inc hl
	call .print_script_address
	hlbgcoord 0, 16
	call .print_script_address
	inc hl
	call .print_script_address
	inc hl
	call .print_script_address
	ld a, [ScriptMode]
	hlbgcoord 4, 17
	call .pbh_noleadingzero
	ld a, [ScriptRunning]
	hlbgcoord 10, 17
	call .pbh_noleadingzero
	ld a, [ScriptFlags]
	hlbgcoord 18, 17
	ld c, a
	call .pbh
	ld a, $80
	ld [rBGPI], a
	ld a, $ff
	ld [rBGPD], a
	ld a, $7f
	ld [rBGPD], a
	ld a, $86
	ld [rBGPI], a
	xor a
	ld [rBGPD], a
	ld [rBGPD], a
	call EnableLCD
	halt
	jr @

.filltrail
	ld a, " "
.loop4
	ld [hli], a
	dec c
	jr nz, .loop4
	ld c, 32
	ret

.print_script_address
	ld a, [de]
	push af
	inc de
	ld a, [de]
	inc de
	ld c, a
	ld a, [de]
	inc de
	ld b, a
	or c
	jr z, .no_script
	pop af
	and a
	jr z, .plain_script_address
	push bc
	ld a, c
	call .pbh
	pop bc
	jr .pwh
.no_script
	rept 6
		inc hl
	endr
	pop af
	ret
.plain_script_address
	inc hl
	inc hl
	; fallthrough

.pwh
	ld a, b
	swap a
	pnh
	ld a, b
	pnh
.pbh
	ld a, c
	swap a
	pnh
	ld a, c
	pnh
	ret

.pbh_noleadingzero
	ld a, c
	and $f0
	jr nz, .pbh
	inc hl
	ld a, c
	pnh
	ret

.print_decimal
	ld c, 10
	call SimpleDivide
	add a, "0"
	ld [hld], a
	ld a, b
	and a
	ret z
	ld c, 10
	call SimpleDivide
	add a, "0"
	ld [hld], a
	ld a, b
	and a
	ret z
	add a, "0"
	ld [hl], a
	ret

.string
	db   "Oh no!"
	next ""
	next "err   h was somehow"
	next "tripped unexpectedly"
	next ""
	next "Please give this"
	next "info to the devs and"
	next "restart the game"
	next ""
	next "AF:      BC:"
	next "DE:      HL:"
	next "SP:     <DOWN> Bank"
	next ""
	next "Map   :    (   ,   )"
	next "Script        var"
	next "stk:"
	next ""
	next "mode   run   flag@"

.sparrow INCBIN "gfx/misc/sparrow.1bpp"
.sparrowend
