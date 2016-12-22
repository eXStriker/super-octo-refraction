Pokepic:: ; 244e3
	ld a, b
	and a
	jr z, .okay
	xor a
	ld hl, TempMonDVs
	ld [hli], a
	ld [hl], a
.okay
	xor a
	ld [hBGMapMode], a
	ld hl, PokepicMenuDataHeader
	call CopyMenuDataHeader
	call MenuBox
	call UpdateSprites
	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	call GetBaseData
	ld de, VTiles1
	predef GetFrontpic
	ld a, [wMenuBorderTopCoord]
	inc a
	ld b, a
	ld a, [wMenuBorderLeftCoord]
	inc a
	ld c, a
	call Coord2Tile
	ld a, $80
	ld [hGraphicStartTile], a
	lb bc, 7, 7
	predef PlaceGraphic
	ld a, [hVBlank]
	push af
	ld a, 2
	ld [hVBlank], a
	ld b, SCGB_POKEPIC
	predef GetSGBLayout
	ld b, 1
	call SafeCopyTilemapAtOnce
	pop af
	ld [hVBlank], a
	ret

ClosePokepic:: ; 24528
	ld b, SCGB_RAM
	predef GetSGBLayout
	xor a
	ld [hBGMapMode], a
	call OverworldTextModeSwitch
	call ApplyTilemap
	call UpdateSprites
	jp LoadStandardFont

PokepicMenuDataHeader: ; 0x24547
	db $40 ; flags
	db 04, 06 ; start coords
	db 12, 14 ; end coords
	dw NULL
	db 1 ; default option
