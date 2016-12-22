BlindingFlash::
	callba FadeOutPalettes
	SetEngine ENGINE_FLASH
	callba ReplaceTimeOfDayPals
	callba UpdateTimeOfDayPal
	ld b, SCGB_MAPPALS
	predef GetSGBLayout
	callba LoadOW_BGPal7
	jpba FadeInPalettes

ShakeHeadbuttTree:
	callba ClearSpriteAnims
	ld de, CutGrassGFX
	ld hl, VTiles1
	lb bc, BANK(CutGrassGFX), 4
	call Request2bpp
	ld de, HeadbuttTreeGFX
	ld hl, VTiles1 tile $04
	lb bc, BANK(HeadbuttTreeGFX), 8
	call Request2bpp
	call Cut_Headbutt_GetPixelFacing
	ld a, SPRITE_ANIM_INDEX_1B
	call _InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], $84
	ld a, 36 * 4
	ld [wCurrSpriteOAMAddr], a
	callba DoNextFrameForAllSprites
	call HideHeadbuttTree
	ld a, $20
	ld [wcf64], a
	call WaitSFX
	ld de, SFX_SANDSTORM
	call PlaySFX
.loop
	ld hl, wcf64
	ld a, [hl]
	and a
	jr z, .done
	dec [hl]
	ld a, 36 * 4
	ld [wCurrSpriteOAMAddr], a
	callba DoNextFrameForAllSprites
	call DelayFrame
	jr .loop

.done
	call OverworldTextModeSwitch
	call ApplyTilemapInVBlank
	xor a
	ld [hBGMapMode], a
	callba ClearSpriteAnims
	ld hl, Sprites + 36 * 4
	ld bc, SpritesEnd - (Sprites + 36 * 4)
	xor a
	call ByteFill
	ld de, Font
	ld hl, VTiles1
	lb bc, BANK(Font), 12
	call Get1bpp
	jp ReplaceKrisSprite

HeadbuttTreeGFX: INCBIN "gfx/misc/headbutt_tree.2bpp"

HideHeadbuttTree:
	xor a
	ld [hBGMapMode], a
	ld a, [PlayerDirection]
	and %00001100
	rra
	ld e, a
	ld d, 0
	ld hl, TreeRelativeLocationTable
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, $5
	ld [hli], a
	ld [hld], a
	ld e, SCREEN_WIDTH
	add hl, de
	ld [hli], a
	ld [hld], a
	call ApplyTilemapInVBlank
	xor a
	ld [hBGMapMode], a
	ret

TreeRelativeLocationTable:
	dwcoord 8,     8 + 2 ; RIGHT
	dwcoord 8,     8 - 2 ; LEFT
	dwcoord 8 - 2, 8     ; DOWN
	dwcoord 8 + 2, 8     ; UP

OWCutAnimation:
	; Animation index in e
	; 0: Split tree in half
	; 1: Mow the lawn
	ld a, e
	and $1
	ld [wJumptableIndex], a
	call .LoadCutGFX
	call WaitSFX
	ld de, SFX_PLACE_PUZZLE_PIECE_DOWN
	call PlaySFX
	jr .handleLoop
.loop
	ld a, 36 * 4
	ld [wCurrSpriteOAMAddr], a
	callba DoNextFrameForAllSprites
	call OWCutJumptable
	call DelayFrame
.handleLoop
	ld a, [wJumptableIndex]
	add a, a
	jr nc, .loop
	ret

.LoadCutGFX
	callba ClearSpriteAnims ; pointless to callba
	ld de, CutGrassGFX
	ld hl, VTiles1
	lb bc, BANK(CutGrassGFX), 4
	push bc
	call Request2bpp
	ld de, CutTreeGFX
	ld hl, VTiles1 tile $4
	pop bc
	jp Request2bpp

CutTreeGFX: INCBIN "gfx/misc/cut_tree.2bpp"

CutGrassGFX: INCBIN "gfx/misc/cut_grass.2bpp"

OWCutJumptable:
	call RunAnonymousJumptable

.dw
	dw Cut_SpawnAnimateTree
	dw Cut_SpawnAnimateLeaves
	dw Cut_StartWaiting
	dw Cut_WaitAnimSFX

Cut_SpawnAnimateTree:
	call Cut_Headbutt_GetPixelFacing
	ld a, SPRITE_ANIM_INDEX_CUT_TREE ; cut tree
	call _InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], $84
	ld a, 32
	ld [wcf64], a
; Cut_StartWaiting
	ld hl, wJumptableIndex
	inc [hl]
	inc [hl]
	ret

Cut_SpawnAnimateLeaves:
	call Cut_GetLeafSpawnCoords
	xor a
	call Cut_SpawnLeaf
	ld a, $10
	call Cut_SpawnLeaf
	ld a, $20
	call Cut_SpawnLeaf
	ld a, $30
	call Cut_SpawnLeaf
	ld a, 32 ; frames
	ld [wcf64], a
; Cut_StartWaiting
	ld hl, wJumptableIndex
	inc [hl]
	ret

Cut_StartWaiting:
	ld a, $1
	ld [hBGMapMode], a
; Cut_WaitAnimSFX
	ld hl, wJumptableIndex
	inc [hl]

Cut_WaitAnimSFX:
	ld hl, wcf64
	ld a, [hl]
	and a
	jr z, .finished
	dec [hl]
	ret

.finished
	ld hl, wJumptableIndex
	set 7, [hl]
	ret

Cut_SpawnLeaf:
	push de
	push af
	ld a, SPRITE_ANIM_INDEX_LEAF ; leaf
	call _InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], $80
	ld hl, SPRITEANIMSTRUCT_0E
	add hl, bc
	ld [hl], $4
	pop af
	dec hl ;ld hl, SPRITEANIMSTRUCT_0C
	dec hl ;add hl, bc
	ld [hl], a
	pop de
	ret

Cut_GetLeafSpawnCoords:
	ld de, 0
	ld a, [wMetatileStandingX]
	rra
	jr nc, .left_side
	inc e
.left_side
	ld a, [wMetatileStandingY]
	rra
	jr nc, .top_side
	set 1, e
.top_side
	ld a, [PlayerDirection]
	and %00001100
	add e
	ld e, a
	ld hl, .Coords
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ret

.Coords
	dbpixel 11, 12 ; facing down,  top left
	dbpixel  9, 12 ; facing down,  top right
	dbpixel 11, 14 ; facing down,  bottom left
	dbpixel  9, 14 ; facing down,  bottom right

	dbpixel 11,  8 ; facing up,    top left
	dbpixel  9,  8 ; facing up,    top right
	dbpixel 11, 10 ; facing up,    bottom left
	dbpixel  9, 10 ; facing up,    bottom right

	dbpixel  7, 12 ; facing left,  top left
	dbpixel  9, 12 ; facing left,  top right
	dbpixel  7, 10 ; facing left,  bottom left
	dbpixel  9, 10 ; facing left,  bottom right

	dbpixel 11, 12 ; facing right, top left
	dbpixel 13, 12 ; facing right, top right
	dbpixel 11, 10 ; facing right, bottom left
	dbpixel 13, 10 ; facing right, bottom right

Cut_Headbutt_GetPixelFacing:
	ld a, [PlayerDirection]
	and %00001100
	rra
	ld e, a
	ld d, 0
	ld hl, .Coords
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ret

.Coords
	dbpixel 10, 13
	dbpixel 10,  9
	dbpixel  8, 11
	dbpixel 12, 11

GetAnimStructWithFlyMonPal:
	push de
	callba GetCurPartySpritePalIndex
	ld h, 0
	ld de, .AnimIndices
	add hl, de
	ld a, [hl]
	pop de
	jp _InitSpriteAnimStruct

.AnimIndices:
	db SPRITE_ANIM_INDEX_RED_WALK
	db SPRITE_ANIM_INDEX_BLUE_WALK
	db SPRITE_ANIM_INDEX_WALK_02
	db SPRITE_ANIM_INDEX_WALK_03
	db SPRITE_ANIM_INDEX_WALK_04
	db SPRITE_ANIM_INDEX_WALK_05
	db SPRITE_ANIM_INDEX_WALK_06
	db SPRITE_ANIM_INDEX_WALK_07

FlyFromAnim:
	call DelayFrame
	ld a, [VramState]
	push af
	xor a
	ld [VramState], a
	call FlyFunction_InitGFX
	depixel 10, 10, 4, 0
	call GetAnimStructWithFlyMonPal
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], $84
	dec hl ;ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID / add hl, bc
	ld [hl], SPRITE_ANIM_SEQ_FLY_FROM
	ld a, 128
	ld [wcf64], a
.loop
	ld a, [wJumptableIndex]
	add a, a
	jr c, .exit
	xor a
	ld [wCurrSpriteOAMAddr], a
	callba DoNextFrameForAllSprites
	call FlyFunction_FrameTimer
	call DelayFrame
	jr .loop

.exit
	pop af
	ld [VramState], a
	ret

FlyToAnim:
	call DelayFrame
	ld a, [VramState]
	push af
	xor a
	ld [VramState], a
	call FlyFunction_InitGFX
	depixel 31, 10, 4, 0
	call GetAnimStructWithFlyMonPal
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], $84
	dec hl ;ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID / add hl, bc
	ld [hl], SPRITE_ANIM_SEQ_FLY_TO
	ld hl, SPRITEANIMSTRUCT_0F
	add hl, bc
	ld [hl], 11 * 8
	ld a, 64
	ld [wcf64], a
.loop
	ld a, [wJumptableIndex]
	add a, a
	jr c, .exit
	xor a
	ld [wCurrSpriteOAMAddr], a
	callba DoNextFrameForAllSprites
	call FlyFunction_FrameTimer
	call DelayFrame
	jr .loop

.exit
	pop af
	ld [VramState], a
	ld hl, Sprites + 2 ; Tile ID
	xor a
	ld c, $4
.loop2
	ld [hli], a
	inc hl
	inc hl
	inc hl
	inc a
	dec c
	jr nz, .loop2
	ld hl, Sprites + 4 * 4
	ld bc, SpritesEnd - (Sprites + 4 * 4)
	xor a
	jp ByteFill

FlyFunction_InitGFX:
	callba ClearSpriteAnims
	ld de, CutGrassGFX
	ld hl, VTiles1 tile $00
	lb bc, BANK(CutGrassGFX), 4
	call Request2bpp
	ld a, [wCurPartyMon]
	ld hl, wPartySpecies
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	ld [wd265], a
	ld e, $84
	callba FlyFunction_GetMonIcon
	xor a
	ld [wJumptableIndex], a
	ret

FlyFunction_FrameTimer:
	call .SpawnLeaf
	ld hl, wcf64
	ld a, [hl]
	and a
	jr z, .exit
	dec [hl]
	cp $40
	ret c
	and $7
	ret nz
	ld de, SFX_FLY
	jp PlaySFX

.exit
	ld hl, wJumptableIndex
	set 7, [hl]
	ret

.SpawnLeaf
	ld hl, wcf65
	ld a, [hl]
	inc [hl]
	and $7
	ret nz
	ld a, [hl]
	and (6 * 8) >> 1
	add a, a
	add 8 * 8 ; gives a number in [$40, $50, $60, $70]
	ld d, a
	ld e, $0
	ld a, SPRITE_ANIM_INDEX_FLY_LEAF ; fly land
	call _InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], $80
	ret
