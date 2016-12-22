_TitleScreen:

	call ClearBGPalettes
	call ClearSprites
	call ClearTileMap

; Turn BG Map update off
	xor a
	ld [hBGMapMode], a

; Reset timing variables
	ld hl, wJumptableIndex
	ld [hli], a ; cf63 ; Scene?
	ld [hli], a ; cf64
	ld [hli], a ; cf65 ; Timer lo
	ld [hl], a  ; cf66 ; Timer hi

; Turn LCD off
	call DisableLCD


; VRAM bank 1
	ld a, 1
	ld [rVBK], a


; Decompress running Suicune gfx
	ld hl, TitleSuicuneGFX
	ld de, VTiles1
	call Decompress

; Clear 3D prism plane 1 gfx
	ld hl, VTiles0
	ld bc, 70 tiles
	xor a
	call ByteFill

; 3D prism cover gfx
	ld hl, VTiles2
	ld b, 8
	xor a
.coverloop
	dec a
	ld [hli], a
	inc a
	ld [hli], a
	dec b
	jr nz, .coverloop

; Clear screen palettes
	hlbgcoord 0, 0
	ld bc, 20 bgrows
	xor a
	call ByteFill


; Fill tile palettes:

; BG Map 0:

; Apply logo gradient:

; lines 3-4
	hlbgcoord 0, 2
	ld bc, 3 bgrows
	ld a, 2
	call ByteFill
; line 5
	hlbgcoord 0, 5
	ld bc, 1 bgrows
	ld a, 3
	call ByteFill
; line 6
	hlbgcoord 0, 6
	ld bc, 1 bgrows
	ld a, 4
	call ByteFill
; line 7
	hlbgcoord 0, 7
	ld bc, 1 bgrows
	ld a, 5
	call ByteFill
; lines 8-9
	hlbgcoord 0, 8
	ld bc, 4 bgrows
	ld a, 6
	call ByteFill


; 'PRISM VERSION'
	hlbgcoord 5, 9
	ld bc, NAME_LENGTH ; length of version text
	ld a, 1
	call ByteFill

; Pokemon gfx
	hlbgcoord 0, 12
	ld bc, 7 bgrows ; the rest of the screen
	ld a, 8
	call ByteFill

; Trainers gfx
	hlbgcoord 11, 12
	lb bc, 7, 8
	ld a, 15
.row
	push bc
.col
	ld [hli], a
	dec c
	jr nz, .col
	ld bc, BG_MAP_WIDTH - 8
	add hl, bc
	pop bc
	dec b
	jr nz, .row

; 3D prism cover
	hlbgcoord 7, 12
	ld bc, 5 ; the rest of the screen
	ld a, 9
	call ByteFill

; Back to VRAM bank 0
	ld a, $0
	ld [rVBK], a


; Decompress logo
	ld hl, TitleLogoGFX
	ld de, VTiles1
	call Decompress

; Clear 3D prism plane 0 gfx
	ld hl, VTiles0
	ld bc, 70 tiles
	xor a
	call ByteFill


; Clear screen tiles
	hlbgcoord 0, 0
	ld bc, 64 bgrows
	ld a, " "
	call ByteFill

; Draw Pokemon logo
	hlbgcoord 0, 3
	lb bc, 9, 20
	lb de, $80, $14
	call DrawTitleGraphic

; Draw clouds
	hlbgcoord 20, 10
	lb bc, 2, 12
	lb de, $c, $14
	call DrawTitleGraphic
	hlbgcoord 20, 9
	ld b, 3
.cloudsloop
	ld a, $f8
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	ld a, $7
	ld [hli], a
	dec b
	jr nz, .cloudsloop

; Draw Pokemon
	hlbgcoord 0, 12
	lb bc, 7, 9
	lb de, $80, $11
	call DrawTitleGraphic

; Draw Trainers
	hlbgcoord 11, 12
	lb bc, 7, 8
	lb de, $89, $11
	call DrawTitleGraphic

; 3D prism cover
	hlbgcoord 7, 12
	ld bc, 5
	xor a
	call ByteFill

; Draw copyright text
	hlbgcoord 3, 0, VBGMap1
	lb bc, 1, 13
	lb de, $34, $10
	call DrawTitleGraphic

; Initialize background crystal
	call InitializeBackground

; Update palette colors
	ld hl, TitleScreenPalettes
	ld de, UnknBGPals
	ld bc, 8 palettes
	rst CopyBytes

	ld hl, TitleScreenPalettes
	ld de, BGPals
	ld bc, 8 palettes
	rst CopyBytes

; Make alternating lines come in from opposite sides

; ( This part is actually totally pointless, you can't
;   see anything until these values are overwritten!  )

	ld b, 78 / 2 ; alternate for 78 lines
	ld hl, wLYOverrides
.loop
; $00 is the middle position
	ld [hl], +112 ; coming from the left
	inc hl
	ld [hl], -112 ; coming from the right
	inc hl
	dec b
	jr nz, .loop

; Make sure the rest of the buffer is empty
	ld hl, wLYOverrides + 78
	xor a
	ld bc, wLYOverridesEnd - (wLYOverrides + 78)
	call ByteFill

; Let LCD Stat know we're messing around with SCX
	ld a, rSCX & $ff
	ld [wLCDCPointer], a


; Reset audio
	call ChannelsOff
	call EnableLCD

; Set sprite size to 8x16
	ld a, [rLCDC]
	set 2, a
	ld [rLCDC], a

	ld a, +112
	ld [hSCX], a
	ld a, 16
	ld [hSCY], a
	ld a, 7
	ld [hWX], a
	ld a, -112
	ld [hWY], a

	ld a, $1
	ld [hCGBPalUpdate], a

	xor a
	ld [UnknBGPals + 2], a
	dec a
	ld [w3DPrismState], a

; Play starting sound effect
	call SFXChannelsOff
	ld de, SFX_TITLE_SCREEN_ENTRANCE
	call PlaySFX

; Initialize bitmask table for 3D prism drawing
	ld hl, w3DPrismBitMasks
	ld a, $ff
	ld b, 9
.loop2
	ld [hli], a
	srl a
	dec b
	jr nz, .loop2

; $90 for 23 runs
; $98 for 8 runs
; $a0 for 8 runs
; $a8 for 8 runs
; $b0 for 9 runs
; $90 for 1 run
	ld hl, wTitleScreenBGPIListAndSpectrumColours
	ld a, $90
	ld de, 4
	ld c, 23
	call FillEveryByteWithDEOffset
	ld b, 4
.loop3
	add 8
	ld c, 8
	call FillEveryByteWithDEOffset
	dec b
	jr nz, .loop3
	ld [hl], a
	add hl, de
	ld [hl], $90
	ld hl, wTitleScreenBGPIListAndSpectrumColours + 1
	ld de, TitleScreenSpectrumPalettes
	ld c, (TitleScreenSpectrumPalettesEnd - TitleScreenSpectrumPalettes) / 2
.loop4
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	inc hl
	inc hl
	dec c
	jr nz, .loop4
	ret

FillEveryByteWithDEOffset:
	ld [hl], a
	add hl, de
	dec c
	jr nz, FillEveryByteWithDEOffset
	ret

SuicuneFrameIterator:
	ld a, [wTitleCloudsCounter]
	inc a
	and 7
	ld [wTitleCloudsCounter], a
	jr nz, .notover
	ld hl, hPrintNum7
	inc [hl]
.notover
	ld a, [w3DPrismState]
	inc a
	cp 3
	jr c, .notover2
	xor a
.notover2
	ld [w3DPrismState], a
	and a
	jp z, Update3DPrism
	dec a
	jr nz, .frame2

.frame1
	ld bc, w3DPrismTmpGFX
	ld d, 40
	call Draw3DPrism
	ld hl, VTiles0 tile 1
	ld de, w3DPrismTmpGFX
	jr Copy3DPrismToVram

.frame2
	ld bc, w3DPrismTmpGFX + 5 tiles
	call Draw3DPrismInverted
	ld hl, VTiles0 tile 5
	ld de, w3DPrismTmpGFX tile 4

Copy3DPrismToVram:
; HBlank copy disables all interrupts so make sure all scanline tricks are done
	ld a, [rLY]
	cp 80
	jr c, Copy3DPrismToVram
	ld a, [rVBK]
	push af
	ld a, [w3DPrismPage]
	ld [rVBK], a
	ld c, 7
.loop
	push bc
	push hl
	push de
	ld b, BANK(Copy3DPrismToVram)
	ld a, [w3DPrismState]
	add 3 ; frame1 4 tiles, frame2 5 tiles
	ld c, a
	call Request2bpp
	pop hl
	ld bc, 9 tiles
	add hl, bc
	ld e, l
	ld d, h
	pop hl
	ld c, 12 tiles
	add hl, bc
	pop bc
	dec c
	jr nz, .loop
	pop af
	ld [rVBK], a
	ret

Update3DPrism:
	ld hl, w3DPrismAngles
	inc [hl]
	inc [hl]
	inc [hl]
	ld a, [hl]
	ld c, 0
	sub $20
	rlca
	rl c
	rlca
	rl c
	ld a, c
	and 1
	ld [w3DPrismShadePos], a
	ld a, [hli]
	rept 3
	add $40
	ld [hli], a
	endr
	ld a, 2
	sub c
	and 3
	ld hl, w3DPrismXIncs
	ld bc, 3
.loop
	push af
	push bc
	push hl
	ld c, a
	ld hl, w3DPrismAngles
	add hl, bc
	ld a, [hl]
	ld e, a
	add $40
	call GetDemoSine
	bit 7, a
	ld b, 0
	jr z, .plus
	dec b
.plus
	ld c, a
	ld hl, 2.4 >> 8
	add hl, bc
	ld c, l
	ld b, h
	add hl, hl ; x2
	add hl, hl ; x4
	add hl, bc ; x5
	add hl, hl ; x10
	add hl, hl ; x20
	add hl, hl ; x40
	ld a, h
	ld [hDivisor], a
	ld a, l
	ld [hDivisor + 1], a
	ld a, e
	call GetDemoSine
	ld c, 0
	bit 7, a
	push af
	jr z, .plus3
	ld b, a
	xor a
	sub b
.plus3
	ld b, a
	srl b
	rr c
	ld a, b
	ld [hDividend + 1], a
	ld a, c
	ld [hDividend + 2], a
	xor a
	ld [hDividend], a
	ld [hDividend + 3], a
	predef DivideLong
	pop af
	pop hl
	push af
	ld a, [hLongQuotient + 3]
	ld e, a
	jr z, .plus4
	xor a
	sub e
.plus4
	ld [hli], a
	pop af
	ld [hl], 0
	jr z, .plus2
	dec [hl]
.plus2
	inc hl
	pop bc
	pop af
	dec a
	and 3
	dec c
	jr nz, .loop
	lb bc, 3, hPrintNum1 % $100
.loop2
	xor a
	ld [$ff00+c], a
	inc c
	ld a, 28
	ld [$ff00+c], a
	inc c
	dec b
	jr nz, .loop2
	call Toggle3DPrismPage
	ld a, 1
	ld [hCGBPalUpdate], a
; shades = hsl(180,75%,37%)-hsl(180,75%,93%)
	ld a, [w3DPrismAngles]
	ld hl, OBPals + $2
	ld b, 143 ; top
	add $20
	call Get3DPrismShade
	add $40
	call Get3DPrismShade
	ld hl, OBPals + $a
	ld b, 95 ; bottom
	sub $40
	call Get3DPrismShade
	add $40

Get3DPrismShade:
	push af
	and $7f
	add $40
	call GetDemoSine
	add $80
	srl a
	srl a
	ld c, a
	srl a
	add c
	add b
	ld c, a
	cp $80
	jr c, .nosub
	ld a, $ff
	sub c
.nosub
	ld d, a
	srl a
	add d
	ld d, a
	srl a
	ld e, a
	ld a, c
	sub e
	ld e, a
	srl a
	srl a
	srl a
	ld [hl], a
	ld a, d
	add e
	ld e, a
	ld c, 0
	and $f8
	sla a
	rl c
	sla a
	rl c
	or [hl]
	ld [hli], a
	ld a, e
	and $f8
	srl a
	or c
	ld [hli], a
	pop af
	ret

Toggle3DPrismPage:
	ld hl, Sprites + 3
	ld bc, 4
	ld e, 29
	ld a, [w3DPrismPage]
	xor 1
	ld [w3DPrismPage], a
	and a
	jr nz, .page0
.loop
	set 3, [hl]
	add hl, bc
	dec e
	jr nz, .loop
	ret
.page0
	res 3, [hl]
	add hl, bc
	dec e
	jr nz, .page0
	ret

Draw3DPrismInverted:
	ld hl, w3DPrismXIncs
	lb de, 32, 3
.loop
	xor a
	sub [hl]
	ld [hli], a
	ld a, 0
	sbc [hl]
	ld [hli], a
	dec e
	jr nz, .loop

Draw3DPrism:
	ld a, [w3DPrismShadePos]
	and a
	jr z, .loop
	inc bc
.loop
	push de
	push bc
	ld hl, w3DPrismXIncs
	ld de, 9 tiles
	ld a, [hPrintNum1]
	add [hl]
	ld [hPrintNum1], a
	inc hl
	ld a, [hPrintNum2]
	adc [hl]
	ld [hPrintNum2], a
	inc hl
	ld a, [hPrintNum3]
	add [hl]
	ld [hPrintNum3], a
	inc hl
	ld a, [hPrintNum4]
	adc [hl]
	ld [hPrintNum4], a
	inc hl
	ld a, [hPrintNum5]
	add [hl]
	ld [hPrintNum5], a
	inc hl
	ld a, [hPrintNum6]
	adc [hl]
	ld [hPrintNum6], a
	ld h, b
	ld a, c
	and $fe
	ld l, a
	xor a
	rept 7
	ld [hli], a
	ld [hld], a
	add hl, de
	endr
	pop de
	push de
	ld a, [hPrintNum2]
	ld b, a
	ld a, [hPrintNum4]
	cp b
	jr c, .oneshadeinvert
	ld c, a
	ld a, [hPrintNum6]
	cp c
	jr c, .oneshade
; two shades
	call .writefirstshade
	ld a, l
	xor 1 ; switch shade
	ld l, a
	ld a, [de]
	ld [hl], a
	ld a, [hPrintNum6]
	ld c, a
	ld a, b
	call .writesecondshade
	pop bc
	pop de
	inc bc
	inc bc
	dec d
	jp nz, .loop
	ret

.oneshadeinvert
	ld b, a
	ld a, [hPrintNum6]
	ld c, a
	ld a, e
	xor 1 ; switch shade
	ld e, a
.oneshade
	call .writefirstshade
	pop bc
	pop de
	inc bc
	inc bc
	dec d
	jp nz, .loop
	ret

.writefirstshade
	ld a, b
	and $f8
	ld l, a ; x8
	rrca ;x4
	rrca ;x2
	rrca ;x1
	add l ; x9
	ld l, a
	swap l
	ld a, l
	and $f
	ld h, a
	ld a, l
	and $f0
	ld l, a ; x144
	add hl, de
	ld a, b
	and $7
	ld e, a
	ld d, w3DPrismBitMasks / $100
	ld a, [de]
	ld [hl], a
	ld a, b
	and $f8
.writesecondshade
	ld de, 9 tiles
.loop2
	add 8
	cp c
	jr nc, .over
	add hl, de
	ld [hl], $ff
	jr .loop2
.over
	sub 8
	ld b, a
	ld a, c
	sub b
	ld e, a
	ld d, w3DPrismBitMasks / $100
	ld a, [de]
	xor [hl]
	ld [hl], a
	ret

DrawTitleGraphic:
; input:
;   hl: draw location
;   b: height
;   c: width
;   d: tile to start drawing from
;   e: number of tiles to advance for each bgrows
.bgrows
	push de
	push bc
	push hl
.col
	ld a, d
	ld [hli], a
	inc d
	dec c
	jr nz, .col
	pop hl
	ld bc, BG_MAP_WIDTH
	add hl, bc
	pop bc
	pop de
	ld a, e
	add d
	ld d, a
	dec b
	jr nz, .bgrows
	ret


InitializeBackground:
	ld hl, Sprites
	lb bc, $3c, $4
	lb de, -$c, $1
	call .InitRow
	inc c
	inc c
	lb de, -$1c, $2
	call .InitRow
	rept 3
	lb de, -$2c, $3
	call .InitRow
	endr
	inc c
	inc c
	lb de, -$1c, $2
	call .InitRow
	rept 4
	inc c
	endr
	lb de, -$c, $1

.InitRow:
	ld a, $80
	ld [hPrintNum1], a
	call .InitColumn
	ld a, $81
	ld [hPrintNum1], a
	ld e, $2
	call .InitColumn
	inc c
	inc c
	ld a, b
	add $8
	ld b, a
	ret

.InitColumn:
	ld a, d
	ld [hli], a
	add $10
	ld d, a
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	inc c
	inc c
	ld a, [hPrintNum1]
	ld [hli], a
	dec e
	jr nz, .InitColumn
	ret


AnimateTitleCrystal:
; Move the title screen crystal downward until it's fully visible

; Stop at y=-4
	ld hl, Sprites
	ld a, [hl]
	cp -4 + $30
	ret z

; Move all 29 parts of the crystal down by 2
	ld c, 29
.loop
	ld a, [hl]
	add 2
	ld [hli], a
	inc hl
	inc hl
	inc hl
	dec c
	jr nz, .loop

	ret


TitleSuicuneGFX:
INCBIN "gfx/title/suicune.w136.2bpp.lz"


TitleLogoGFX:
INCBIN "gfx/title/logo.w160.t4.2bpp.lz"


TitleScreenPalettes:
; BG
	RGB 31, 31, 31
	RGB 16, 28, 00
	RGB 15, 10, 27
	RGB 00, 00, 00

	RGB 22, 25, 30
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 03, 13, 25

	RGB 06, 05, 15
	RGB 07, 07, 07
	RGB 31, 31, 31
	RGB 02, 03, 30

	RGB 12, 13, 21
	RGB 13, 13, 13
	RGB 31, 31, 18
	RGB 02, 03, 30

	RGB 15, 17, 24
	RGB 19, 19, 19
	RGB 29, 28, 12
	RGB 02, 03, 30

	RGB 18, 20, 26
	RGB 25, 25, 25
	RGB 28, 25, 06
	RGB 02, 03, 30

	RGB 22, 25, 30
	RGB 31, 31, 31
	RGB 26, 21, 00
	RGB 02, 03, 30

	RGB 31, 31, 31
	RGB 26, 21, 14
	RGB 27, 03, 00
	RGB 00, 00, 00

TitleScreenSpectrumPalettes:
	RGB 08, 06, 17
	RGB 11, 06, 19
	RGB 13, 07, 21
	RGB 15, 07, 23
	RGB 17, 08, 25
	RGB 20, 08, 26
	RGB 22, 09, 28
	RGB 24, 09, 30
	RGB 25, 09, 27
	RGB 26, 10, 25
	RGB 26, 10, 22
	RGB 27, 11, 20
	RGB 28, 11, 17
	RGB 29, 11, 14
	RGB 29, 12, 12
	RGB 30, 12, 09
	RGB 30, 14, 09
	RGB 29, 17, 09
	RGB 29, 19, 09
	RGB 28, 21, 09
	RGB 28, 23, 09
	RGB 28, 26, 09
	RGB 27, 28, 09
	RGB 27, 30, 09
	RGB 25, 30, 09
	RGB 23, 29, 08
	RGB 21, 28, 08
	RGB 19, 28, 08
	RGB 17, 27, 07
	RGB 14, 27, 07
	RGB 12, 26, 06
	RGB 10, 26, 06
	RGB 11, 26, 08
	RGB 11, 27, 11
	RGB 12, 27, 13
	RGB 12, 28, 16
	RGB 13, 28, 18
	RGB 13, 29, 20
	RGB 14, 29, 23
	RGB 14, 30, 25
	RGB 14, 28, 26
	RGB 14, 27, 26
	RGB 14, 26, 27
	RGB 14, 24, 27
	RGB 14, 23, 28
	RGB 14, 22, 29
	RGB 14, 20, 29
	RGB 14, 19, 30
	RGB 15, 20, 30
	RGB 16, 21, 30
	RGB 17, 21, 30
	RGB 18, 22, 30
	RGB 19, 23, 30
	RGB 20, 23, 30
	RGB 21, 24, 30
	RGB 22, 25, 30
	RGB 06, 05, 15
TitleScreenSpectrumPalettesEnd:
