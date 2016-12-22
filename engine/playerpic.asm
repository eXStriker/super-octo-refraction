HOF_LoadTrainerFrontpic:
	call ApplyTilemapInVBlank
	xor a
	ld [hBGMapMode], a
	call GetPlayerFrontpic
	call ApplyTilemapInVBlank
	ld a, $1
	ld [hBGMapMode], a
	ret

DrawIntroPlayerPic:
; Draw the player pic at (6,4).
	call GetPlayerFrontpic

; Draw
	xor a
	ld [hGraphicStartTile], a
	hlcoord 6, 4
	lb bc, 7, 7
	predef_jump PlaceGraphic

GetPlayerFrontpic:
GLOBAL PlayerPics
	ld a, [wPlayerCharacteristics]
	and $f
	ld c, a
	ld b, 0
	ld hl, PlayerClasses
	add hl, bc
	add hl, bc
	ld a, [hl]
	ld [TrainerClass], a

GetPlayerFrontpic_Customization:
	ld a, c
	srl a
	cp 6
	jr z, .palettePatroller

	ld a, c
	ld bc, 7 * 7 * $10
	ld hl, PlayerPics
	rst AddNTimes
	ld d, h
	ld e, l
	lb bc, BANK(PlayerPics), 7 * 7
	ld hl, VTiles2
	ld b, BANK(PlayerPics)
	jp Get2bpp

.palettePatroller
	lb bc, BANK(PlayerPalettePatroller), 7 * 7
	ld hl, VTiles2
	ld de, PlayerPalettePatroller
	jp Get2bpp

PlayerClasses:
	db CHRIS, KRIS
	db CHRIS, KRIS
	db CHRIS, KRIS
	db CHRIS, KRIS
	db CHRIS, KRIS
	db CHRIS, KRIS

GetTrainerBackpic:
GLOBAL PlayerBackpics, DudeBackpic

; Load the player character's backpic (6x6) into VRAM starting from VTiles2 tile $31.
; Special exception for Dude.

	ld a, [wBattleType]
	cp BATTLETYPE_TUTORIAL
	jr nz, GetPlayerBackpic
	ld de, DudeBackpic
	ld hl, VTiles2 tile $31
	lb bc, BANK(DudeBackpic), 6 * 6
	jp Get2bpp

GetPlayerBackpic:
; What gender are we?
	ld a, [wPlayerCharacteristics]
	and $f
	ld c, a
	srl a
	cp 6
	jr z, .palettePatrollerBack
	ld a, c

	ld bc, 6 * 6 * $10
	ld hl, PlayerBackpics
	rst AddNTimes
	ld d, h
	ld e, l
	ld hl, VTiles2 tile $31
	lb bc, BANK(PlayerBackpics), 6 * 6
	jp Get2bpp

.palettePatrollerBack
	lb bc, BANK(PlayerPalettePatrollerBack), 7 * 7
	ld hl, VTiles2 tile $31
	ld de, PlayerPalettePatrollerBack
	jp Get2bpp

DudeBackpic: INCBIN "gfx/misc/dude.6x6.2bpp"
