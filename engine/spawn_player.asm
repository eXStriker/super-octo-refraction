SpawnPlayer:
	ld a, -1
	ld [wObjectFollow_Leader], a
	ld [wObjectFollow_Follower], a
	ld a, PLAYER
	ld hl, PlayerObjectTemplate
	call CopyPlayerObjectTemplate
	ld b, PLAYER
	call PlayerSpawn_ConvertCoords
	callba GetPlayerSprite
	ld a, PLAYER
	call GetMapObject
	ld hl, MAPOBJECT_COLOR
	add hl, bc
	CheckEngine ENGINE_POKEMON_MODE
	ln a, (1 << 3) | PAL_OW_PLAYER, PERSONTYPE_SCRIPT
	jr z, .okay
	push hl
	ld hl, wPokeonlyMainDVs
	ld a, [wPokeonlyMainSpecies]
	ld [wCurPartySpecies], a
	callba GetPalette
	ld a, l
	ld [wPokeonlyMonPalette], a
	pop hl
	xor a
.okay
	ld [hl], a
	ld a, PLAYER
	ld [hMapObjectIndexBuffer], a
	ld bc, MapObjects
	ld a, PLAYER
	ld [hObjectStructIndexBuffer], a
	ld de, ObjectStructs
	call CopyMapObjectToObjectStruct
	ld a, PLAYER
	ld [wCenteredObject], a
	ret

PlayerObjectTemplate:
; A dummy map object used to initialize the player object.
; Shorter than the actual amount copied by two bytes.
; Said bytes seem to be unused.
	person_event SPRITE_P0, -4, -4, SPRITEMOVEDATA_PLAYER, 15, 15, -1, -1, 0, PERSONTYPE_SCRIPT, 0, 0, -1

PlayerSpawn_ConvertCoords:
	push bc
	ld a, [XCoord]
	add 4
	ld d, a
	ld a, [YCoord]
	add 4
	ld e, a
	pop bc
CopyDECoordsToMapObject::
	push de
	ld a, b
	call GetMapObject
	pop de
	ld hl, MAPOBJECT_X_COORD
	add hl, bc
	ld [hl], d
	ld hl, MAPOBJECT_Y_COORD
	add hl, bc
	ld [hl], e
	ret

WritePersonXY::
	ld a, b
	call CheckObjectVisibility
	ret c

	ld hl, OBJECT_NEXT_MAP_X
	add hl, bc
	ld d, [hl]
	ld hl, OBJECT_NEXT_MAP_Y
	add hl, bc
	ld e, [hl]
	ld a, [hMapObjectIndexBuffer]
	ld b, a
	call CopyDECoordsToMapObject
	and a
	ret

RefreshPlayerCoords:
	ld a, [XCoord]
	add 4
	ld d, a
	ld hl, PlayerStandingMapX
	sub [hl]
	ld [hl], d
	ld hl, MapObjects + MAPOBJECT_X_COORD
	ld [hl], d
	ld hl, PlayerLastMapX
	ld [hl], d
	ld d, a
	ld a, [YCoord]
	add 4
	ld e, a
	ld hl, PlayerStandingMapY
	sub [hl]
	ld [hl], e
	ld hl, MapObjects + MAPOBJECT_Y_COORD
	ld [hl], e
	ld hl, PlayerLastMapY
	ld [hl], e
	ld e, a
	ld a, [wObjectFollow_Leader]
	and a
	ret
