; Functions handling map objects.

GetSpritePalette::
	push hl
	push de
	push bc
	ld b, a

	callba GetSpriteHeaderFromFar

	ld a, h
	pop bc
	pop de
	pop hl
	ret

GetSpriteVTile::
	push hl
	push bc
	ld hl, UsedSprites + 2
	ld c, SPRITE_GFX_LIST_CAPACITY - 1
	ld b, a
	ld a, [hMapObjectIndexBuffer]
	and a
	jr z, .nope
	ld a, b
.loop
	cp [hl]
	jr z, .found
	inc hl
	inc hl
	dec c
	jr nz, .loop
	ld a, [UsedSprites + 1]
	scf
	jr .done

.nope
	ld a, [UsedSprites + 1]
	jr .done

.found
	inc hl
	xor a
	ld a, [hl]

.done
	pop bc
	pop hl
	ret

DoesSpriteHaveFacings::
	push de
	push hl

	ld b, a
	callba _DoesSpriteHaveFacings
	ld c, a
	pop hl
	pop de
	ret

GetPlayerStandingTile::
	ld a, [PlayerStandingTile]
	call GetTileCollision
	ld b, a
	ret

CheckOnWater::
	ld a, [PlayerStandingTile]
	call GetTileCollision
	dec a
	ret z
	and a
	ret

GetTileCollision::
; Get the collision type of tile a.

	push de
	push hl

	ld hl, TileCollisionTable
	ld e, a
	ld d, 0
	add hl, de

	ld a, BANK(TileCollisionTable)
	call GetFarByte

	and $f ; lo nybble only

	pop hl
	pop de
	ret

CheckGrassTile::
	ld d, a
	and $f0
	cp $10
	jr z, .ok
	cp $20
	jr z, .ok
	scf
	ret

.ok
	ld a, d
	and 7
	ret z
	scf
	ret

CheckSuperTallGrassTile::
	cp $14
	ret z
	cp $1c
	ret

CheckCutTreeTile::
	cp $12
	ret z
	cp $1a
	ret

CheckHeadbuttTreeTile::
	cp $15
	ret z
	cp $1d
	ret

CheckCounterTile::
	cp $90
	ret z
	cp $98
	ret

CheckPitTile::
	cp $60
	ret z
	cp $68
	ret

CheckIceTile::
	cp $23
	ret z
	cp $2b
	ret z
	scf
	ret

CheckWhirlpoolTile::
	cp $24
	ret z
	cp $2c
	ret z
	scf
	ret

CheckWaterfallTile::
	cp $33
	ret z
	cp $3b
	ret

CheckStandingOnEntrance::
	ld a, [PlayerStandingTile]
	cp $71 ; door
	ret z
	cp $79
	ret z
	cp $7a ; stairs
	ret z
	cp $7b ; cave
	ret

GetMapObject::
; Return the location of map object a in bc.
	ld hl, MapObjects
	ld bc, OBJECT_LENGTH
	rst AddNTimes
	ld b, h
	ld c, l
	ret

CheckObjectVisibility::
; Sets carry if the object is not visible on the screen.
	ld [hMapObjectIndexBuffer], a
	call GetMapObject
	ld hl, MAPOBJECT_OBJECT_STRUCT_ID
	add hl, bc
	ld a, [hl]
	cp -1
	jr z, .not_visible
	ld [hObjectStructIndexBuffer], a
	call GetObjectStruct
	and a
	ret

.not_visible
	scf
	ret

CheckObjectTime::
	ld hl, MAPOBJECT_HOUR
	add hl, bc
	ld a, [hl]
	cp -1
	jr nz, .check_hour
	ld hl, MAPOBJECT_TIMEOFDAY
	add hl, bc
	ld a, [hl]
	cp -1
	jr z, .timeofday_always
	ld hl, .TimeOfDayValues_191e
	ld a, [TimeOfDay]
	add l
	ld l, a
	jr nc, .ok
	inc h

.ok
	ld a, [hl]
	ld hl, MAPOBJECT_TIMEOFDAY
	add hl, bc
	and [hl]
	jr nz, .timeofday_always
	scf
	ret

.timeofday_always
	and a
	ret

.TimeOfDayValues_191e
	db 1 << MORN ; 1
	db 1 << DAY  ; 2
	db 1 << NITE ; 4

.check_hour
	ld hl, MAPOBJECT_HOUR
	add hl, bc
	ld d, [hl]
	ld hl, MAPOBJECT_TIMEOFDAY
	add hl, bc
	ld e, [hl]
	ld hl, hHours
	ld a, d
	cp e
	jr z, .yes
	jr c, .check_timeofday
	ld a, [hl]
	cp d
	jr nc, .yes
	cp e
	jr c, .yes
	jr z, .yes
	jr .no

.check_timeofday
	ld a, e
	cp [hl]
	jr c, .no
	ld a, [hl]
	cp d
	jr nc, .yes
	jr .no

.yes
	and a
	ret

.no
	scf
	ret

_CopyObjectStruct::
	ld [hMapObjectIndexBuffer], a
	ld hl, wObjectMasks
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	ld [hl], 0 ; unmasked

	ld a, [hMapObjectIndexBuffer]
	call GetMapObject
	jpba CopyObjectStruct

ApplyDeletionToMapObject::
	ld [hMapObjectIndexBuffer], a
	call GetMapObject
	ld hl, MAPOBJECT_OBJECT_STRUCT_ID
	add hl, bc
	ld a, [hl]
	cp -1
	ret z ; already hidden
	ld [hl], -1
	push af
	call .CheckStopFollow
	pop af
	call GetObjectStruct
	jpba DeleteMapObject

.CheckStopFollow
	ld hl, wObjectFollow_Leader
	cp [hl]
	jr z, .ok
	ld hl, wObjectFollow_Follower
	cp [hl]
	ret nz
.ok
	callba StopFollow
	ld a, -1
	ld [wObjectFollow_Leader], a
	ld [wObjectFollow_Follower], a
	ret

DeleteObjectStruct::
	call ApplyDeletionToMapObject

MaskObject::
	ld a, [hMapObjectIndexBuffer]
	ld hl, wObjectMasks
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	ld [hl], -1 ; masked
	ret

CopyPlayerObjectTemplate::
	push hl
	call GetMapObject
	ld d, b
	ld e, c
	ld a, -1
	ld [de], a
	inc de
	pop hl
	ld bc, OBJECT_LENGTH - 1
	rst CopyBytes
	ret

GetMovementData::
; Initialize the movement data for person c at b:hl
	ld a, b
	call StackCallInBankA
	
.Function
	ld a, c

LoadMovementDataPointer::
; Load the movement data pointer for person a.
	ld [wMovementPerson], a
	ld a, [hROMBank]
	ld [wMovementDataPointer], a
	ld a, l
	ld [wMovementDataPointer + 1], a
	ld a, h
	ld [wMovementDataPointer + 2], a
	ld a, [wMovementPerson]
	call CheckObjectVisibility
	ret c

	ld hl, OBJECT_MOVEMENTTYPE
	add hl, bc
	ld [hl], SPRITEMOVEDATA_SCRIPTED

	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_00

	ld hl, VramState
	set 7, [hl]
	and a
	ret

FindFirstEmptyObjectStruct::
; Returns the index of the first empty object struct in A and its address in HL, then sets carry.
; If all object structs are occupied, A = 0 and Z is set.
; Preserves BC and DE.
	push bc
	push de
	ld hl, ObjectStructs
	ld de, OBJECT_STRUCT_LENGTH
	ld c, NUM_OBJECT_STRUCTS
.loop
	ld a, [hl]
	and a
	jr z, .break
	add hl, de
	dec c
	jr nz, .loop
	xor a
	jr .done

.break
	ld a, NUM_OBJECT_STRUCTS
	sub c
	scf

.done
	pop de
	pop bc
	ret

GetSpriteMovementFunction::
	ld hl, OBJECT_MOVEMENTTYPE
	add hl, bc
	ld a, [hl]
	cp NUM_SPRITEMOVEDATA
	jr c, .ok
	xor a

.ok
	ld hl, SpriteMovementData
	ld e, a
	ld d, 0
rept SPRITEMOVEDATA_FIELDS
	add hl, de
endr
	ld a, [hl]
	ret

GetInitialFacing::
	push bc
	push de
	ld e, a
	ld d, 0
	ld hl, SpriteMovementData + 1 ; init facing
rept SPRITEMOVEDATA_FIELDS
	add hl, de
endr
	ld a, BANK(SpriteMovementData)
	call GetFarByte
	add a
	add a
	and $c
	pop de
	pop bc
	ret

CopySpriteMovementData::
	anonbankpush SpriteMovementData

.Function:
	push bc
	call .CopyData
	pop bc
	ret

.CopyData
	ld hl, OBJECT_MOVEMENTTYPE
	add hl, de
	ld [hl], a

	push de
	ld e, a
	ld d, 0
	ld hl, SpriteMovementData + 1 ; init facing
rept SPRITEMOVEDATA_FIELDS
	add hl, de
endr
	ld b, h
	ld c, l
	pop de

	ld a, [bc]
	inc bc
	rlca
	rlca
	and %00001100
	ld hl, OBJECT_FACING
	add hl, de
	ld [hl], a

	ld a, [bc]
	inc bc
	ld hl, OBJECT_ACTION
	add hl, de
	ld [hl], a

	ld a, [bc]
	inc bc
	ld hl, OBJECT_FLAGS1
	add hl, de
	ld [hl], a

	ld a, [bc]
	inc bc
	ld hl, OBJECT_FLAGS2
	add hl, de
	ld [hl], a

	ld a, [bc]
	inc bc
	ld hl, OBJECT_PALETTE
	add hl, de
	ld [hl], a
	ret

_GetMovementByte::
; Switch to the movement data bank
	ld a, [hli]
	call StackCallInBankA
	
.Function
; Load the current script byte as given by OBJECT_MOVEMENT_BYTE_INDEX, and increment OBJECT_MOVEMENT_BYTE_INDEX
	ld a, [hli]
	ld d, [hl]
	ld hl, OBJECT_MOVEMENT_BYTE_INDEX
	add hl, bc
	add [hl]
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
	inc [hl]
	ld a, [de]
	ret

SetVramState_Bit0::
	ld hl, VramState
	set 0, [hl]
	ret

ResetVramState_Bit0::
	ld hl, VramState
	res 0, [hl]
	ret

UpdateSprites::
	ld a, [VramState]
	bit 0, a
	ret z

	jpba UpdateMapObjectDataAndSprites

GetObjectStruct::
	ld bc, OBJECT_STRUCT_LENGTH
	ld hl, ObjectStructs
	rst AddNTimes
	ld b, h
	ld c, l
	ret

GetObjectSprite::
	ld hl, OBJECT_SPRITE
	add hl, bc
	ld a, [hl]
	and a
	ret

SetSpriteDirection::
	; preserves other flags
	push af
	ld hl, OBJECT_FACING
	add hl, bc
	ld a, [hl]
	and %11110011
	ld e, a
	pop af
	and %00001100
	or e
	ld [hl], a
	ret

SpriteDirectionToMapMovement:
	call GetSpriteDirection
	rrca
	rrca
	add SPRITEMOVEDATA_STANDING_DOWN
	ret

GetSpriteDirection::
	ld hl, OBJECT_FACING
	add hl, bc
	ld a, [hl]
	and %00001100
	ret

SidescrollGetSpriteDirection::
; If the player object...
	ld a, [hMapObjectIndexBuffer]
	and a
	jr nz, GetSpriteDirection
; would normally be facing down...
	call GetSpriteDirection
	ret nz
; on a sidescroll map...
	ld a, [wTileset]
	cp TILESET_SIDESCROLL
	ld a, OW_DOWN
	ret nz
; in a place where you can move up and down...
	push hl
	ld hl, TileDown
	ld a, [hli]
	and [hl]
	pop hl
; face up. Else, face down.
	ld a, OW_DOWN
	ret nz
	ld a, OW_UP
	ret

GetPlayerIcon:
	ld a, [wPlayerCharacteristics]
	call GetPlayerSpriteHeader
	ld h, d
	ld l, e
	ld a, b
	jp FarDecompressWRA6

GetPlayerSpriteHeader:
	and $f
	ld c, a
	ld b, 0
	ld hl, PlayerSprites
	add hl, bc
	ld b, [hl]
	jpba GetSpriteHeaderFromFar

PlayerSprites::
	db SPRITE_P0
	db SPRITE_P1
	db SPRITE_P2
	db SPRITE_P3
	db SPRITE_P4
	db SPRITE_P5
	db SPRITE_P6
	db SPRITE_P7
	db SPRITE_P8
	db SPRITE_P9
	db SPRITE_P10
	db SPRITE_P11
	db SPRITE_PALETTE_PATROLLER
	db SPRITE_PALETTE_PATROLLER