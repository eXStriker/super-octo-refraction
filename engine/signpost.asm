signpostborderattr: MACRO
	db \1 ; region
	dw \2SignpostBorderGFX ; signpost border gfx
	db \3_SIGNPOST palettes ; signpost color
ENDM

WOODEN_SIGNPOST EQU 0
METAL_SIGNPOST  EQU 1

_Signpost::
	call SignpostFront
	ld b, 144
.inloop
	call DelayFrame
	ld a, b
	sub 8
	ld [hWY], a
	ld b, a
	jr nz, .inloop
.wait
	call DelayFrame
	call CheckIfAOrBPressed
	jr z, .wait
	ld b, 0
.outloop
	call DelayFrame
	ld a, b
	add 8
	ld [hWY], a
	ld b, a
	cp 144
	jr c, .outloop
	ret

SignpostFront:
	push hl
	call .LoadSignpostGFX
	pop hl
	ld a, [ScriptBank]
	call GetFarByte
	cp TX_COMPRESSED ; hacky way of saving space
	jr z, .useLandmarkName
	inc hl
	push hl
	jr nc, .doNotAdjustHeaderIndex
	and a
	jr z, .useLandmarkNameWithUncompressedBodyText ; if we still need to use the landmark name, but the body text isn't compressed
	inc a
.doNotAdjustHeaderIndex
	dec a
	ld hl, SignpostFrontHeaders
	ld d, 0
	jr .handle_header_loop
.header_loop
	ld e, [hl]
	add hl, de
.handle_header_loop
	dec a
	jr nz, .header_loop
	ld d, h
	ld e, l
	inc de
	jr .printSignpostHeader	
.useLandmarkName
	push hl
.useLandmarkNameWithUncompressedBodyText
	call GetCurWorldMapLocation
	ld e, a
	callba GetLandmarkName
	ld de, StringBuffer1AndDoneText
.printSignpostHeader
	hlcoord 2, 4
	call PlaceText
	pop de
	hlcoord 2, 7
	ld a, [ScriptBank]
	call FarText
	ld hl, hBGMapAddress + 1
	ld a, [hld]
	ld c, [hl]
	ld b, a
	push bc
	xor a
	ld [hli], a
	ld [hl], VBGMap1 >> 8
	ld b, 1
	call SafeCopyTilemapAtOnce
	pop bc
	ld hl, hBGMapAddress
	ld a, c
	ld [hli], a
	ld [hl], b
	ret

.LoadSignpostGFX:
	xor a
	ld [hBGMapMode], a
	call ClearTileMapNoDelay
	ld a, $87
	ld hl, AttrMap
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	call ByteFill
	callba RegionCheck
	ld hl, .signpostregionlist
	ld bc, 3
.regioncheckloop
	ld a, [hli]
	cp $ff
	jr z, .regioncheckdone
	cp e
	jr z, .regioncheckdone
	add hl, bc
	jr .regioncheckloop
.regioncheckdone
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	call .LoadGFX
	hlcoord 0, 1
	ld de, 19
	ld b, 8
	ld a, $c8
.sideloop
	ld [hl], a
	add hl, de
	inc a
	ld [hli], a
	inc a
	ld [hl], a
	add hl, de
	inc a
	ld [hli], a
	sub 3
	dec b
	jr nz, .sideloop
	ld a, $c4
	hlcoord 0, 0
	call .FillTopBottomBorder
	ld a, $cc
	hlcoord 0, 17

.FillTopBottomBorder
	ld b, 4
	ld [hli], a
	inc a
.loop2
	ld [hli], a
	ld [hli], a
	inc a
	ld [hli], a
	ld [hli], a
	dec a
	dec b
	jr nz, .loop2
	ld [hli], a
	ld [hli], a
	inc a
	inc a
	ld [hl], a
	ret

.LoadGFX:
	call RunFunctionInWRA6

.Function:
	push bc
	push de
	ld hl, wDecompressScratch
	push hl
	call FarCopyFontToHL
	pop hl
	ld bc, FontEnd - Font
	ld a, $ff
.graybackloop
	ld [hli], a
	inc hl
	dec c
	jr nz, .graybackloop
	dec b
	jr nz, .graybackloop
	pop hl
	ld de, wDecompressScratch tile $44
	ld bc, 12 tiles
	ld a, BANK(NaljoSignpostBorderGFX)
	call FarCopyBytes
	ld hl, VTiles1
	ld de, wDecompressScratch
	lb bc, BANK(SignpostFront), 128
	call Request2bpp
	ld hl, VTiles2 tile $7f
	ld de, wDecompressScratch tile $3a ; should be blank
	lb bc, BANK(SignpostFront), 1
	call Request2bpp
	ld a, BANK(BGPals)
	ld [rSVBK], a
	ld hl, SignpostPals
	pop bc
	ld b, 0
	add hl, bc
	ld de, BGPals + 7 palettes
	ld c, 1 palettes
	rst CopyBytes
	ret

.signpostregionlist
	signpostborderattr REGION_NALJO, Naljo, WOODEN
	signpostborderattr REGION_RIJON, Rijon, WOODEN
	signpostborderattr REGION_JOHTO, Johto, METAL
	signpostborderattr REGION_TUNOD, Tunod, METAL
	signpostborderattr $ff,          Kanto, WOODEN ; kanto, sevii, mystery

StringBuffer1AndDoneText:
	text "<STRBF1>"
	done

SignpostPals:
	; WOODEN_SIGNPOST
	RGB 31, 31, 31
	RGB 30, 30, 15
	RGB 13, 08, 00
	RGB 00, 00, 00
	; METAL_SIGNPOST
	RGB 31, 31, 31
	RGB 24, 24, 24
	RGB 12, 12, 12
	RGB 00, 00, 00

SignpostFrontHeaders:
	next_list_item
	ctxt "Trainer Tips" ;0
	done

	next_list_item
	ctxt "Notice!" ;1
	done

	next_list_item
	ctxt "Route 68+1"
	done

	end_list_items

SignpostContent:
	; next_list_item


	; next_list_item


	; next_list_item
	; ctxt "<UP>Heath Village"
	; next "<DOWN>Caper City"
	; done ;4

	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item
	; ctxt "Apartment"
	; next "Complex."
	; next "Find yourself"
	; next "a nice home!"
	; done ;13

	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item
	; ctxt "Spurge"
	; next "Mini-mall"
	; next "The mall that"
	; next "has it all!"
	; done ;17

	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item
	; ctxt "Great, great"
	; next "scientists!"
	; done ;28

	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item
	; ctxt "Magikarp"
	; next "caverns"
	; done ;32

	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item
	; ctxt "<LEFT><UP>Oxalis City"
	; next "<RIGHT> Phacelia"
	; next "<LEFT> Clathrite"
	; done ;37

	; next_list_item


	; next_list_item
	; ctxt "Magma Caverns"
	; next "Entrance"
	; done ;39

	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item
	; ctxt "Naljo Federal"
	; next "Penitentiary"
	; done ;43

	; next_list_item

	; next_list_item
	; ctxt "<LEFT> Torenia City"
	; next "<RIGHT> Phlox Town"
	; done ;45

	; next_list_item


	; next_list_item
	; ctxt "The inception"
	; next "of complete"
	; next "felicity"
	; done ;47

	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item


	; next_list_item


	; end_list_items
