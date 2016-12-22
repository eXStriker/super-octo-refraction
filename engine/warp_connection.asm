RunCallback_05_03:
	call ResetMapBufferEventFlags
	call ResetFlashIfOutOfCave
	call GetCurrentMapTrigger
	call ResetBikeFlags
	ld a, MAPCALLBACK_NEWMAP
	call RunMapCallback
RunCallback_03:
	callba ClearCmdQueue
	ld a, MAPCALLBACK_CMDQUEUE
	call RunMapCallback
	call GetMapHeaderTimeOfDayNybble
	ld [wMapTimeOfDay], a
	ret

EnterMapConnection:
; Return carry if a connection has been entered.
	ld a, [wPlayerStepDirection]
	and a
	jp z, EnterSouthConnection
	dec a
	jr z, EnterNorthConnection
	dec a
	jr z, EnterWestConnection
	dec a
	ret nz
	; fallthrough

EnterEastConnection:
	ld a, [EastConnectedMapGroup]
	ld [MapGroup], a
	ld a, [EastConnectedMapNumber]
	ld [MapNumber], a
	ld a, [EastConnectionStripXOffset]
	ld [XCoord], a
	ld a, [EastConnectionStripYOffset]
	ld hl, YCoord
	add [hl]
	ld [hl], a
	ld c, a
	ld hl, EastConnectionWindow
	ld a, [hli]
	ld h, [hl]
	ld l, a
	srl c
	jr z, .skip_to_load
	ld a, [EastConnectedMapWidth]
	add 6
	ld e, a
	ld d, 0

.loop
	add hl, de
	dec c
	jr nz, .loop

.skip_to_load
	ld a, l
	ld [wOverworldMapAnchor], a
	ld a, h
	ld [wOverworldMapAnchor + 1], a
	scf
	ret

EnterWestConnection:
	ld a, [WestConnectedMapGroup]
	ld [MapGroup], a
	ld a, [WestConnectedMapNumber]
	ld [MapNumber], a
	ld a, [WestConnectionStripXOffset]
	ld [XCoord], a
	ld a, [WestConnectionStripYOffset]
	ld hl, YCoord
	add [hl]
	ld [hl], a
	ld c, a
	ld hl, WestConnectionWindow
	ld a, [hli]
	ld h, [hl]
	ld l, a
	srl c
	jr z, .skip_to_load
	ld a, [WestConnectedMapWidth]
	add 6
	ld e, a
	ld d, 0

.loop
	add hl, de
	dec c
	jr nz, .loop

.skip_to_load
	ld a, l
	ld [wOverworldMapAnchor], a
	ld a, h
	ld [wOverworldMapAnchor + 1], a
	scf
	ret

EnterNorthConnection:
	ld a, [NorthConnectedMapGroup]
	ld [MapGroup], a
	ld a, [NorthConnectedMapNumber]
	ld [MapNumber], a
	ld a, [NorthConnectionStripYOffset]
	ld [YCoord], a
	ld a, [NorthConnectionStripXOffset]
	ld hl, XCoord
	add [hl]
	ld [hl], a
	ld c, a
	ld hl, NorthConnectionWindow
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld b, 0
	srl c
	add hl, bc
	ld a, l
	ld [wOverworldMapAnchor], a
	ld a, h
	ld [wOverworldMapAnchor + 1], a
	scf
	ret

EnterSouthConnection:
	ld a, [SouthConnectedMapGroup]
	ld [MapGroup], a
	ld a, [SouthConnectedMapNumber]
	ld [MapNumber], a
	ld a, [SouthConnectionStripYOffset]
	ld [YCoord], a
	ld a, [SouthConnectionStripXOffset]
	ld hl, XCoord
	add [hl]
	ld [hl], a
	ld c, a
	ld hl, SouthConnectionWindow
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld b, 0
	srl c
	add hl, bc
	ld a, l
	ld [wOverworldMapAnchor], a
	ld a, h
	ld [wOverworldMapAnchor + 1], a
	scf
	ret

LoadWarpData:
	call .SaveDigWarp
	call .SetSpawn
	ld a, [wNextWarp]
	ld [WarpNumber], a
	ld a, [wNextMapGroup]
	ld [MapGroup], a
	ld a, [wNextMapNumber]
	ld [MapNumber], a
	ret

.SaveDigWarp
	call GetMapPermission
	call CheckOutdoorMap
	ret nz
	ld a, [wNextMapGroup]
	ld b, a
	ld a, [wNextMapNumber]
	ld c, a
	call GetAnyMapPermission
	call CheckIndoorMap
	ret nz
	ld a, [wPrevWarp]
	ld [wDigWarp], a
	ld a, [wPrevMapGroup]
	ld [wDigMapGroup], a
	ld a, [wPrevMapNumber]
	ld [wDigMapNumber], a
	ret

.SetSpawn
	call GetMapPermission
	call CheckOutdoorMap
	ret nz
	ld a, [wNextMapGroup]
	ld b, a
	ld a, [wNextMapNumber]
	ld c, a
	push bc
	call GetAnyMapPermission
	call CheckIndoorMap
	pop bc
	ret nz
	call GetAnyMapTileset
	ld a, c
	cp TILESET_POKECENTER
	ret nz
	ld a, [wPrevMapGroup]
	ld [wLastSpawnMapGroup], a
	ld a, [wPrevMapNumber]
	ld [wLastSpawnMapNumber], a
	ret

LoadMapTimeOfDay:
	ld hl, VramState
	res 6, [hl]
	ld a, $1
	ld [wSpriteUpdatesEnabled], a
	callba ReplaceTimeOfDayPals
	callba UpdateTimeOfDayPal
	call OverworldTextModeSwitch
	call Function104770

	decoord 0, 0
	call .copy

	decoord 0, 0, AttrMap
	ld a, $1
	ld [rVBK], a
.copy:
	hlbgcoord 0, 0
	ld c, SCREEN_WIDTH
	ld b, SCREEN_HEIGHT
.row
	push bc
.column
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .column
	ld bc, BG_MAP_WIDTH - SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	ld a, $0
	ld [rVBK], a
	ret

Function104770:
	ld a, VBGMap0 / $100
	ld [wBGMapAnchor + 1], a
	xor a
	ld [wBGMapAnchor], a
	ld [hSCY], a
	ld [hSCX], a
	callba ReanchorOverworldSprites
	ld a, [rVBK]
	push af
	ld a, $1
	ld [rVBK], a
	xor a
	ld bc, VBGMap1 - VBGMap0
	hlbgcoord 0, 0
	call ByteFill
	pop af
	ld [rVBK], a
	ld a, $60
	ld bc, VBGMap1 - VBGMap0
	hlbgcoord 0, 0
	jp ByteFill

LoadGraphics:
	call LoadTilesetHeader
LoadGraphicsNoHeader:
	call LoadTileset
	xor a
	ld [hMapAnims], a
	xor a
	ld [hTileAnimFrame], a
	callba RefreshSprites
	jp LoadFontsExtra

LoadMapPalettes:
	ld b, SCGB_MAPPALS
	predef_jump GetSGBLayout

PrismNoMapSign::
	ld a, $90
	ld [rWY], a
	ld [hWY], a
	xor a
	ld [wLCDCPointer], a
	ld [hBGMapMode], a
	ret

RefreshMapSprites:
	call ClearSprites
	; call PrismNoMapSign
	callba QueueLandmarkSignAnim
	call GetMovementPermissions
	callba RefreshPlayerSprite
	callba CheckReplaceKrisSprite
	ld hl, wPlayerSpriteSetupFlags
	bit 6, [hl]
	jr nz, .skip
	ld hl, VramState
	set 0, [hl]
	call Function2e31
.skip
	ld a, [wPlayerSpriteSetupFlags]
	and %00011100
	ld [wPlayerSpriteSetupFlags], a
	ret

CheckMovingOffEdgeOfMap::
	ld a, [wPlayerStepDirection]
	cp STANDING
	ret z
	and a ; DOWN
	jr z, .down
	cp UP
	jr z, .up
	cp LEFT
	jr z, .left
	cp RIGHT
	jr z, .right
	and a
	ret

.down
	ld a, [PlayerStandingMapY]
	sub 4
	ld b, a
	ld a, [MapHeight]
	add a
	cp b
	jr z, .ok
	and a
	ret

.up
	ld a, [PlayerStandingMapY]
	sub 4
	cp -1
	jr z, .ok
	and a
	ret

.left
	ld a, [PlayerStandingMapX]
	sub $4
	cp -1
	jr z, .ok
	and a
	ret

.right
	ld a, [PlayerStandingMapX]
	sub 4
	ld b, a
	ld a, [MapWidth]
	add a
	cp b
	jr z, .ok
	and a
	ret

.ok
	scf
	ret

GetCoordOfUpperLeftCorner::
	ld hl, OverworldMap
	ld a, [XCoord]
	bit 0, a
	jr nz, .increment_then_halve1
	srl a
	add $1
	jr .resume

.increment_then_halve1
	add $1
	srl a

.resume
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [MapWidth]
	add $6
	ld c, a
	ld b, $0
	ld a, [YCoord]
	bit 0, a
	jr nz, .increment_then_halve2
	srl a
	add $1
	jr .resume2

.increment_then_halve2
	add $1
	srl a

.resume2
	rst AddNTimes
	ld a, l
	ld [wOverworldMapAnchor], a
	ld a, h
	ld [wOverworldMapAnchor + 1], a
	ld a, [YCoord]
	and $1
	ld [wMetatileStandingY], a
	ld a, [XCoord]
	and $1
	ld [wMetatileStandingX], a
	ret
