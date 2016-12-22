; Functions dealing with rendering and interacting with maps.

CheckTriggers::
; Checks wCurrentMapTriggerPointer.  If it's empty, returns -1 in a.  Otherwise, returns the active trigger ID in a.
	push hl
	ld hl, wCurrentMapTriggerPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ld a, [hl]
	jr nz, .triggerexists
	ld a, -1

.triggerexists
	pop hl
	ret

GetCurrentMapTrigger::
; Grabs the wram map trigger pointer for the current map and loads it into wCurrentMapTriggerPointer.
; If there are no triggers, both bytes of wCurrentMapTriggerPointer are wiped clean.
; Copy the current map group and number into bc.  This is needed for GetMapTrigger.
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
; Blank out wCurrentMapTriggerPointer; this is the default scenario.
	xor a
	ld [wCurrentMapTriggerPointer], a
	ld [wCurrentMapTriggerPointer + 1], a
	call GetMapTrigger
	ret c ; The map is not in the trigger table
; Load the trigger table pointer from de into wCurrentMapTriggerPointer
	ld a, e
	ld [wCurrentMapTriggerPointer], a
	ld a, d
	ld [wCurrentMapTriggerPointer + 1], a
	xor a
	ret

GetMapTrigger::
; Searches the trigger table for the map group and number loaded in bc, and returns the wram pointer in de.
; If the map is not in the trigger table, returns carry.
	anonbankpush MapTriggers
	
.Function:
	ld hl, MapTriggers
	ld de, 4
	jr .handleLoop
.loop
	pop hl
	add hl, de
.handleLoop
	push hl
	ld a, [hli] ; map group, or terminator
	cp -1
	jr z, .end ; the current map is not in the trigger table
	cp b
	jr nz, .loop ; map group did not match
	ld a, [hli] ; map number
	cp c
	jr nz, .loop ; map number did not match
	ld a, [hli]
	ld d, [hl]
	ld e, a
	jr .done
.end
	scf
.done
	pop hl
	ret

OverworldTextModeSwitch::
	call LoadMapPart
	jp FarCallSwapTextboxPalettes

LoadMapPart::
	call LoadMetatiles
	ld a, $60
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	call ByteFill
	
AdjustMapScreenForBlockXY:
	ld hl, wMisc
	ld a, [wMetatileStandingY]
	and a
	jr z, .top_row
	ld bc, WMISC_WIDTH * 2
	add hl, bc

.top_row
	ld a, [wMetatileStandingX]
	and a
	jr z, .left_column
	inc hl
	inc hl

.left_column
	decoord 0, 0
	ld b, SCREEN_HEIGHT
.loop
	ld c, SCREEN_WIDTH
.loop2
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop2
	ld a, l
	add 4
	ld l, a
	jr nc, .carry
	inc h

.carry
	dec b
	jr nz, .loop
	ret

LoadMetatiles::
	; de <- wOverworldMapAnchor
	ld a, [wOverworldMapAnchor]
	ld e, a
	ld a, [wOverworldMapAnchor + 1]
	ld d, a
	ld hl, wMisc
	ld a, WMISC_HEIGHT / 4 ; 5
	ld [hMetatileCountHeight], a

; copy to hram registers for speed

	ld a, [MapBorderBlock]
	ld [hMapBorderBlock], a
	ld a, [MapWidth]
	add 6
	ld [hMapWidthPlus6], a

	ld a, BANK(wDecompressedMetatiles)
	call StackCallInWRAMBankA
	
.Function
	ld bc, WMISC_WIDTH - 4

.row
	push de
	push hl
	ld a, WMISC_WIDTH / 4 ; 6
.col
	ld [hMetatileCountWidth], a

	push de
	push hl
	; Load the current map block.
	; If the current map block is a border block, load the border block.
	ld a, [de]
	and a
	jr nz, .ok
	ld a, [hMapBorderBlock]

.ok
	swap a
	ld d, a
	and $f0
	ld e, a
	ld a, d
	and $f
	add (wDecompressedMetatiles >> 8)
	ld d, a	
	; copy the 4x4 metatile

; rows 1 - 3
	rept 3
		rept 4
			ld a, [de]
			ld [hli], a
			inc e
		endr
		add hl, bc
	endr
; row 4
	rept 3
		ld a, [de]
		ld [hli], a
		inc e
	endr
	ld a, [de]
	ld [hl], a

	; Next metatile
	pop hl
	pop de
	ld a, 4
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	inc de
	ld a, [hMetatileCountWidth]
	dec a
	jp nz, .col
	; Next metarow
	pop hl
	pop de

	ld a, WMISC_WIDTH * 4
	add l
	ld l, a
	jr nc, .noCarry2
	inc h
.noCarry2
	ld a, [hMapWidthPlus6]
	add e
	ld e, a
	jr nc, .noCarry3
	inc d
.noCarry3
	ld a, [hMetatileCountHeight]
	dec a
	ld [hMetatileCountHeight], a
	jp nz, .row
	ret

ReturnToMapFromSubmenu::
	ld a, MAPSETUP_SUBMENU
	ld [hMapEntryMethod], a
	callba RunMapSetupScript
	xor a
	ld [hMapEntryMethod], a
	ret

CheckWarpTile::
	call GetDestinationWarpNumber
	ret nc

	push bc
	callba CheckDirectionalWarp
	pop bc
	ret nc

	call CopyWarpData
	scf
	ret
	
WarpCheck::
	call GetDestinationWarpNumber
	ret nc
	jp CopyWarpData

GetDestinationWarpNumber::
	callba CheckWarpCollision
	ret nc
	call StackCallInMapScriptHeaderBank

.GetDestinationWarpNumber:
	ld a, [PlayerStandingMapY]
	sub $4
	ld e, a
	ld a, [PlayerStandingMapX]
	sub $4
	ld d, a
	ld a, [wCurrMapWarpCount]
	and a
	ret z

	ld c, a
	ld hl, wCurrMapWarpHeaderPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
.loop
	push hl
	ld a, [hli]
	cp e
	jr nz, .next
	ld a, [hli]
	cp d
	jr nz, .next
	jr .found_warp

.next
	pop hl
	ld a, 5
	add l
	ld l, a
	jr nc, .okay
	inc h

.okay
	dec c
	jr nz, .loop
	xor a
	ret

.found_warp
	pop hl
	inc hl
	inc hl

	ld a, [wCurrMapWarpCount]
	inc a
	sub c
	ld c, a
	scf
	ret

CopyWarpData::
	call StackCallInMapScriptHeaderBank

.CopyWarpData
	push bc
	ld hl, wCurrMapWarpHeaderPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, c
	dec a
	ld bc, 5 ; warp size
	rst AddNTimes
	ld bc, 2 ; warp number
	add hl, bc
	ld a, [hli]
	cp $ff
	jr nz, .skip
	ld hl, BackupWarpNumber
	ld a, [hli]

.skip
	pop bc
	ld [wNextWarp], a
	ld a, [hli]
	ld [wNextMapGroup], a
	ld a, [hli]
	ld [wNextMapNumber], a

	ld a, c
	ld [wPrevWarp], a
	ld a, [MapGroup]
	ld [wPrevMapGroup], a
	ld a, [MapNumber]
	ld [wPrevMapNumber], a
	scf
	ret

CheckOutdoorMap::
	cp ROUTE
	ret z
	cp TOWN
	ret

CheckIndoorMap::
	cp INDOOR
	ret z
	cp CAVE
	ret z
	cp DUNGEON
	ret z
	cp GATE
	ret

LoadMapAttributes::
	call CopyMapHeaders
	call SwitchToMapScriptHeaderBank
	call ReadMapScripts
	xor a
	jp ReadMapEventHeader

LoadMapAttributes_SkipPeople::
	call CopyMapHeaders
	call SwitchToMapScriptHeaderBank
	call ReadMapScripts
	ld a, $1
	jp ReadMapEventHeader

CopyMapHeaders::
	call PartiallyCopyMapHeader
	call SwitchToMapBank
	call GetSecondaryMapHeaderPointer
	call CopySecondMapHeader
	jp GetMapConnections

ReadMapEventHeader::
	push af
	ld hl, MapEventHeaderPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	inc hl
	call ReadWarps
	call ReadCoordEvents
	call ReadSignposts

	pop af
	and a
	ret nz

	jp ReadObjectEvents

ReadMapScripts::
	ld hl, MapScriptHeaderPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call ReadMapTriggers
	jp ReadMapCallbacks

CopySecondMapHeader::
	ld de, MapHeader
	ld bc, 12 ; size of the second map header
	rst CopyBytes
	ret

GetMapConnections::
	ld a, $ff
	ld [NorthConnectedMapGroup], a
	ld [SouthConnectedMapGroup], a
	ld [WestConnectedMapGroup], a
	ld [EastConnectedMapGroup], a

	ld a, [MapConnections]
	swap a

	add a
	ld de, NorthMapConnection
	call c, GetMapConnection

	add a
	ld de, SouthMapConnection
	call c, GetMapConnection

	add a
	ld de, WestMapConnection	
	call c, GetMapConnection

	add a
	ret nc
	ld de, EastMapConnection

GetMapConnection::
; Load map connection struct at hl into de.
	push af
	ld bc, SouthMapConnection - NorthMapConnection
	rst CopyBytes
	pop af
	ret

ReadMapTriggers::
	ld a, [hli] ; trigger count
	ld c, a
	ld [wCurrMapTriggerCount], a ; current map trigger count
	ld a, l
	ld [wCurrMapTriggerHeaderPointer], a ; map trigger pointer
	ld a, h
	ld [wCurrMapTriggerHeaderPointer + 1], a
	ld a, c
	and a
	ret z

	ld bc, 4 ; size of a map trigger header entry
	rst AddNTimes
	ret

ReadMapCallbacks::
	ld a, [hli]
	ld c, a
	ld [wCurrMapCallbackCount], a
	ld a, l
	ld [wCurrMapCallbackHeaderPointer], a
	ld a, h
	ld [wCurrMapCallbackHeaderPointer + 1], a
	ld a, c
	and a
	ret z

	ld bc, 3
	rst AddNTimes
	ret

ReadWarps::
	ld a, [hli]
	ld c, a
	ld [wCurrMapWarpCount], a
	ld a, l
	ld [wCurrMapWarpHeaderPointer], a
	ld a, h
	ld [wCurrMapWarpHeaderPointer + 1], a
	ld a, c
	and a
	ret z
	ld bc, 5
	rst AddNTimes
	ret

ReadCoordEvents::
	ld a, [hli]
	ld c, a
	ld [wCurrentMapXYTriggerCount], a
	ld a, l
	ld [wCurrentMapXYTriggerHeaderPointer], a
	ld a, h
	ld [wCurrentMapXYTriggerHeaderPointer + 1], a

	ld a, c
	and a
	ret z

	ld bc, 8
	rst AddNTimes
	ret

ReadSignposts::
	ld a, [hli]
	ld c, a
	ld [wCurrentMapSignpostCount], a
	ld a, l
	ld [wCurrentMapSignpostHeaderPointer], a
	ld a, h
	ld [wCurrentMapSignpostHeaderPointer + 1], a

	ld a, c
	and a
	ret z

	ld bc, 5
	rst AddNTimes
	ret

ReadObjectEvents::
	push hl
	call ClearObjectStructs
	pop de
	ld hl, Map1Object
	ld a, [de]
	inc de
	ld [wCurrentMapPersonEventCount], a
	ld a, e
	ld [wCurrentMapPersonEventHeaderPointer], a
	ld a, d
	ld [wCurrentMapPersonEventHeaderPointer + 1], a

	ld a, [wCurrentMapPersonEventCount]
	call CopyMapObjectHeaders

; get NUM_OBJECTS - [wCurrentMapPersonEventCount]
	ld a, [wCurrentMapPersonEventCount]
	ld c, a
	ld a, NUM_OBJECTS ; - 1
	sub c
	jr z, .skip
	jr c, .skip

	inc hl
; Fill the remaining sprite IDs and y coords with 0 and -1, respectively.
; Bleeds into wObjectMasks due to a bug.  Uncomment the above subtraction
; to fix.
	ld bc, OBJECT_LENGTH
.loop
	ld [hl],  0
	inc hl
	ld [hl], -1
	dec hl
	add hl, bc
	dec a
	jr nz, .loop

.skip
	ld h, d
	ld l, e
	ret

CopyMapObjectHeaders::
	and a
	ret z

	ld c, a
.loop
	push bc
	push hl
	ld a, $ff
	ld [hli], a
	ld b, MAPOBJECT_E - MAPOBJECT_SPRITE
.loop2
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .loop2

	pop hl
	ld bc, OBJECT_LENGTH
	add hl, bc
	pop bc
	dec c
	jr nz, .loop
	ret

ClearObjectStructs::
	ld hl, Object1Struct
	ld bc, OBJECT_STRUCT_LENGTH * (NUM_OBJECT_STRUCTS - 1)
	xor a
	jp ByteFill

RestoreFacingAfterWarp::
	call SwitchToMapScriptHeaderBank

	ld hl, MapEventHeaderPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl ; get to the warp coords
	inc hl
	inc hl
	ld a, [WarpNumber]
	dec a
	ld c, a
	ld b, 0
	ld a, 5
	rst AddNTimes
	ld a, [hli]
	ld [YCoord], a
	ld a, [hli]
	ld [XCoord], a
	; destination warp number
	ld a, [hli]
	cp $ff
	jr nz, .skip
	ld a, [wPrevWarp]
	ld [BackupWarpNumber], a
	ld a, [wPrevMapGroup]
	ld [BackupMapGroup], a
	ld a, [wPrevMapNumber]
	ld [BackupMapNumber], a
.skip
	jpba GetCoordOfUpperLeftCorner

SwitchToMapScriptHeaderBank:
	ld a, [MapScriptHeaderBank]
	rst Bankswitch
	ret

LoadBlockData::
	ld a, [hVBlank]
	push af
	ld a, 2
	ld [hVBlank], a
	ld hl, OverworldMap
	ld bc, OverworldMapEnd - OverworldMap
	xor a
	call ByteFill
	call ChangeMap
	call FillMapConnections
	ld a, MAPCALLBACK_TILES
	call RunMapCallback
	pop af
	ld [hVBlank], a
	ret

ChangeMap::
	ld a, [MapBlockDataBank]
	ld b, a
	ld a, [MapBlockDataPointer]
	ld l, a
	ld a, [MapBlockDataPointer+1]
	ld h, a
	ld a, [MapWidth]
	ld d, a
	ld a, [MapHeight]
	ld e, a

	call RunFunctionInWRA6

.Function:
	push de
	call FarDecompressAtB_D000
	pop de

	ld a, d
	ld [hConnectedMapWidth], a
	add $6
	ld [hConnectionStripLength], a
	ld hl, OverworldMap

	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	add hl, bc
	ld c, 3
	add hl, bc

	ld b, e
	ld de, wDecompressScratch
.row
	push hl
	ld a, [hConnectedMapWidth]
	ld c, a
.col
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	ld a, [hConnectionStripLength]
	add l
	ld l, a
	jr nc, .okay
	inc h
.okay
	dec b
	jr nz, .row
	ret

DecompressConnectionMap:
	push de
	push bc
	call DecompressWRA6
	pop bc
	pop de
	ret

FillMapConnections::

; North
	ld a, [NorthConnectedMapGroup]
	cp $ff
	jr z, .South
	ld b, a
	ld a, [NorthConnectedMapNumber]
	ld c, a
	call GetAnyMapBlockdataBankPointer
	call DecompressConnectionMap

	ld a, [NorthConnectionStripPointer]
	ld l, a
	ld a, [NorthConnectionStripPointer + 1]
	ld h, a

	ld a, [NorthConnectionStripLocation]
	ld e, a
	ld a, [NorthConnectionStripLocation + 1]
	ld d, a
	ld a, [NorthConnectionStripLength]
	ld [hConnectionStripLength], a
	ld a, [NorthConnectedMapWidth]
	ld [hConnectedMapWidth], a
	call FillNorthConnectionStrip

.South
	ld a, [SouthConnectedMapGroup]
	cp $ff
	jr z, .West
	ld b, a
	ld a, [SouthConnectedMapNumber]
	ld c, a
	call GetAnyMapBlockdataBankPointer
	call DecompressConnectionMap

	ld a, [SouthConnectionStripPointer]
	ld l, a
	ld a, [SouthConnectionStripPointer + 1]
	ld h, a
	ld a, [SouthConnectionStripLocation]
	ld e, a
	ld a, [SouthConnectionStripLocation + 1]
	ld d, a
	ld a, [SouthConnectionStripLength]
	ld [hConnectionStripLength], a
	ld a, [SouthConnectedMapWidth]
	ld [hConnectedMapWidth], a
	call FillSouthConnectionStrip

.West
	ld a, [WestConnectedMapGroup]
	cp $ff
	jr z, .East
	ld b, a
	ld a, [WestConnectedMapNumber]
	ld c, a
	call GetAnyMapBlockdataBankPointer
	call DecompressConnectionMap

	ld a, [WestConnectionStripPointer]
	ld l, a
	ld a, [WestConnectionStripPointer + 1]
	ld h, a
	ld a, [WestConnectionStripLocation]
	ld e, a
	ld a, [WestConnectionStripLocation + 1]
	ld d, a
	ld a, [WestConnectionStripLength]
	ld b, a
	ld a, [WestConnectedMapWidth]
	ld [hConnectionStripLength], a
	call FillWestConnectionStrip

.East
	ld a, [EastConnectedMapGroup]
	cp $ff
	ret z
	ld b, a
	ld a, [EastConnectedMapNumber]
	ld c, a
	call GetAnyMapBlockdataBankPointer
	call DecompressConnectionMap

	ld a, [EastConnectionStripPointer]
	ld l, a
	ld a, [EastConnectionStripPointer + 1]
	ld h, a
	ld a, [EastConnectionStripLocation]
	ld e, a
	ld a, [EastConnectionStripLocation + 1]
	ld d, a
	ld a, [EastConnectionStripLength]
	ld b, a
	ld a, [EastConnectedMapWidth]
	ld [hConnectionStripLength], a

; fallthrough
FillWestConnectionStrip::
FillEastConnectionStrip::
	ld a, [MapWidth]
	add 6
	ld [hConnectedMapWidth], a

	call RunFunctionInWRA6

.loop
	push de

	push hl
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	pop hl

	ld a, [hConnectionStripLength]
	ld e, a
	ld d, 0
	add hl, de
	pop de

	ld a, [hConnectedMapWidth]
	add e
	ld e, a
	jr nc, .okay
	inc d
.okay
	dec b
	jr nz, .loop
	ret

FillNorthConnectionStrip::
FillSouthConnectionStrip::
	ld a, [MapWidth]
	add 6
	ld [hMapWidthPlus6], a
	call RunFunctionInWRA6
	
.Function:
	ld c, 3
.y
	push de

	push hl
	ld a, [hConnectionStripLength]
	ld b, a
.x
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .x
	pop hl

	ld a, [hConnectedMapWidth]
	ld e, a
	ld d, 0
	add hl, de
	pop de

	ld a, [hMapWidthPlus6]
	add e
	ld e, a
	jr nc, .okay
	inc d
.okay
	dec c
	jr nz, .y
	ret

LoadMetatilesTilecoll:
	ld hl, TilesetBlocksBank
	ld c, BANK(wDecompressedMetatiles)
	call .Decompress

	ld hl, TilesetCollisionBank
	ld c, BANK(wDecompressedCollision)

; fallthrough
.Decompress:
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wDecompressedMetatiles ; same as wDecompressedCollision
	ld a, c
	call StackCallInWRAMBankA

.Function:
	jp FarDecompressAtB_D000
	
CallMapScript::
; Call a script at hl in the current bank if there isn't already a script running
	ld a, [ScriptRunning]
	and a
	ret nz
	ld a, [MapScriptHeaderBank]

CallScript::
; Call a script at a:hl.

	ld [ScriptBank], a
	ld a, l
	ld [ScriptPos], a
	ld a, h
	ld [ScriptPos + 1], a

	ld a, PLAYEREVENT_MAPSCRIPT
	ld [ScriptRunning], a

	scf
	ret

RunMapCallback::
; Will run the first callback found in the map header with execution index equal to a.
	ld b, a
	call StackCallInMapScriptHeaderBank
	
.Function
	call .FindCallback
	ret nc
	
	ld a, [MapScriptHeaderBank]
	ld b, a
	ld d, h
	ld e, l
	jp ExecuteCallbackScript

.FindCallback
	ld a, [wCurrMapCallbackCount]
	ld c, a
	and a
	ret z
	ld hl, wCurrMapCallbackHeaderPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld de, 3
.loop
	ld a, [hl]
	cp b
	jr z, .found
	add hl, de
	dec c
	jr nz, .loop
	xor a
	ret

.found
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	scf
	ret

ExecuteCallbackScript::
; Do map callback de and return to script bank b.
	callba CallCallback
	ld a, [ScriptMode]
	push af
	ld hl, ScriptFlags
	ld a, [hl]
	push af
	set 1, [hl]
	callba EnableScriptMode
	callba ScriptEvents
	pop af
	ld [ScriptFlags], a
	pop af
	ld [ScriptMode], a
	ret

MapTextbox::
	ld a, b
	call StackCallInBankA

.Function:
	push hl
	call SpeechTextBox
	call Function2e31
	ld a, 1
	ld [hOAMUpdate], a
	call ApplyTilemap
	pop hl
	call PrintTextBoxText
	xor a
	ld [hOAMUpdate], a
	ret

PeekScriptByte::
	push hl
	ld hl, ScriptPos
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [ScriptBank]
	call GetFarByte
	pop hl
	ret
	
GetScriptByte::
; Return byte at ScriptBank:ScriptPos in a.
	ld a, [ScriptBank]
	call StackCallInBankA
	
.Function:
	push hl
	push de

	ld hl, ScriptPos
	ld a, [hli]
	ld d, [hl]
	ld e, a

	ld a, [de]
	inc de

	ld [hl], d
	dec hl
	ld [hl], e

	pop de
	pop hl
	ret

GetScriptHalfword::
; Return 16-bit value at ScriptBank:ScriptPos in hl.
	ld a, [ScriptBank]
	call StackCallInBankA
	
.Function:
	ld hl, ScriptPos
	ld a, [hli]
	ld h, [hl]
	ld l, a

	inc hl
	inc hl

	ld a, l
	ld [ScriptPos], a
	ld a, h
	ld [ScriptPos + 1], a

	dec hl
	ld a, [hld]
	ld l, [hl]
	ld h, a
	ret

GetScriptThreeBytes::
; Return 24-bit value at ScriptBank:ScriptPos in cde.
	push hl
	call GetScriptByte
	ld c, a
	call GetScriptHalfword
	ld d, l
	ld e, h
	pop hl
	ret

GetScriptWord::
; Return 32-bit value at ScriptBank:ScriptPos in bcde.
	push hl
	call GetScriptHalfword
	ld b, l
	ld c, h
	call GetScriptHalfword
	ld d, l
	ld e, h
	pop hl
	ret

ObjectEvent::
	jumptextfaceplayer ObjectEventText

ObjectEventText::
	text_jump _ObjectEventText

BGEvent::
	jumptext BGEventText

BGEventText::
	text_jump UnknownText_0x1c46fc

CoordinatesEvent::
	jumptext CoordinatesEventText

CoordinatesEventText::
	text_jump UnknownText_0x1c4706

AddSignpostHeader::
	signpostheader 0
	text_jump _AddSignpostText

ScrollMapDown::
	hlcoord 0, 0
	ld de, BGMapBuffer
	call BackupBGMapRow
	ld c, 2 * SCREEN_WIDTH
	call FarCallScrollBGMapPalettes
	ld a, [wBGMapAnchor]
	ld e, a
	ld a, [wBGMapAnchor + 1]
	jr ScrollMapHorizontally_UpdateBGMapRow

ScrollMapUp::
	hlcoord 0, SCREEN_HEIGHT - 2
	ld de, BGMapBuffer
	call BackupBGMapRow
	ld c, 2 * SCREEN_WIDTH
	call FarCallScrollBGMapPalettes
	ld a, [wBGMapAnchor]
	ld l, a
	ld a, [wBGMapAnchor + 1]
	ld h, a
	ld bc, $0200
	add hl, bc
; cap d at VBGMap1 / $100
	ld a, h
	and %00000011
	or VBGMap0 / $100
	ld e, l
ScrollMapHorizontally_UpdateBGMapRow:
	ld d, a
	call UpdateBGMapRow
	jr ScrollMap_SetBGMapUpdate

ScrollMapRight::
	hlcoord 0, 0
	ld de, BGMapBuffer
	call BackupBGMapColumn
	ld c, 2 * SCREEN_HEIGHT
	call FarCallScrollBGMapPalettes
	ld a, [wBGMapAnchor]
	jr ScrollMapHorizontally_UpdateBGMapColumn

ScrollMapLeft::
	hlcoord SCREEN_WIDTH - 2, 0
	ld de, BGMapBuffer
	call BackupBGMapColumn
	ld c, 2 * SCREEN_HEIGHT
	call FarCallScrollBGMapPalettes
	ld a, [wBGMapAnchor]
	ld e, a
	and %11100000
	ld b, a
	ld a, e
	add SCREEN_HEIGHT
	and %00011111
	or b
ScrollMapHorizontally_UpdateBGMapColumn:
	ld e, a
	ld a, [wBGMapAnchor + 1]
	ld d, a
	call UpdateBGMapColumn
ScrollMap_SetBGMapUpdate:
	ld a, $1
	ld [hBGMapUpdate], a
	ret

BackupBGMapRow::
	ld c, 2 * SCREEN_WIDTH
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	ret

BackupBGMapColumn::
	ld c, SCREEN_HEIGHT
.loop
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	ld a, SCREEN_WIDTH - 1
	add l
	ld l, a
	jr nc, .skip
	inc h

.skip
	dec c
	jr nz, .loop
	ret

UpdateBGMapRow::
	ld hl, BGMapBufferPtrs
	push de
	call .iteration
	pop de
	ld a, $20
	add e
	ld e, a

.iteration
	ld c, 10
.loop
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, e
	inc a
	inc a
	and $1f
	ld b, a
	ld a, e
	and $e0
	or b
	ld e, a
	dec c
	jr nz, .loop
	ld a, SCREEN_WIDTH
	ld [hBGMapTileCount], a
	ret

UpdateBGMapColumn::
	ld hl, BGMapBufferPtrs
	ld c, SCREEN_HEIGHT
.loop
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, $20
	add e
	ld e, a
	jr nc, .skip
	inc d
; cap d at VBGMap1 / $100
	ld a, d
	and $3
	or VBGMap0 / $100
	ld d, a

.skip
	dec c
	jr nz, .loop
	ld a, SCREEN_HEIGHT
	ld [hBGMapTileCount], a
	ret

LoadTileset::
	ld hl, TilesetBank
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	
	call .LoadTilesetGFX
	ld a, [wTileset]
	cp TILESET_NALJO_1
	jr z, .load_roof
	cp TILESET_NALJO_2
	jr nz, .skip_roof
.load_roof
	callba LoadMapGroupRoof

.skip_roof
	xor a
	ld [hTileAnimFrame], a
	ret

.LoadTilesetGFX:
	call RunFunctionInWRA6
.Function1:

	push hl
	ld hl, wDecompressScratch
	ld bc, (2 * $60) tiles
	xor a
	call ByteFill
	pop hl

	ld a, e
	ld de, wDecompressScratch
	call FarDecompress

	ld hl, wDecompressScratch
	ld de, VTiles2
	ld bc, $60 tiles
	rst CopyBytes

	call StackCallInVBK1
.Function2:
	ld hl, wDecompressScratch + $60 tiles
	ld de, VTiles2
	ld bc, $60 tiles
	rst CopyBytes
	ret

BufferScreen::
	ld hl, wOverworldMapAnchor
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wScreenSave
	lb bc, $6, $5
.row
	push bc
	push hl
.col
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .col
	pop hl
	ld a, [MapWidth]
	add $6
	ld c, a
	ld b, $0
	add hl, bc
	pop bc
	dec c
	jr nz, .row
	ret

SaveScreen::
	ld hl, wOverworldMapAnchor
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wScreenSave
	ld a, [MapWidth]
	add 6
	ld [hMapObjectIndexBuffer], a
	ld a, [wPlayerStepDirection]
	and a
	jr z, .down
	cp UP
	jr z, .up
	cp LEFT
	jr z, .left
	cp RIGHT
	jr z, .right
	ret

.up
	ld de, wScreenSave + 6
	ld a, [hMapObjectIndexBuffer]
	ld c, a
	ld b, $0
	add hl, bc
	jr .vertical

.down
	ld de, wScreenSave
.vertical
	lb bc, 6, 4
	jr SaveScreen_LoadNeighbor

.left
	ld de, wScreenSave + 1
	inc hl
	jr .horizontal

.right
	ld de, wScreenSave
.horizontal
	lb bc, 5, 5
	jr SaveScreen_LoadNeighbor

LoadNeighboringBlockData::
	ld hl, wOverworldMapAnchor
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [MapWidth]
	add 6
	ld [hConnectionStripLength], a
	ld de, wScreenSave
	lb bc, 6, 5

SaveScreen_LoadNeighbor::
.row
	push bc
	push hl
	push de
.col
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .col
	pop de
	ld a, e
	add 6
	ld e, a
	jr nc, .okay
	inc d

.okay
	pop hl
	ld a, [hConnectionStripLength]
	ld c, a
	ld b, 0
	add hl, bc
	pop bc
	dec c
	jr nz, .row
	ret

GetMovementPermissions::
	xor a
	ld [TilePermissions], a
	call .LeftRight
	call .UpDown
; get coords of current tile
	ld a, [PlayerStandingMapX]
	ld d, a
	ld a, [PlayerStandingMapY]
	ld e, a
	call GetCoordTile
	ld [PlayerStandingTile], a
	call .CheckHiNybble
	ret nz

	ld a, [PlayerStandingTile]
	and 7
	ld hl, .MovementPermissionsData
	add l
	ld l, a
	ld a, 0
	adc h
	ld h, a
	ld a, [hl]
	ld hl, TilePermissions
	or [hl]
	ld [hl], a
	ret

.MovementPermissionsData
	db 1, 2, 4, 8, 9, 10, 5, 6

.UpDown
	ld a, [PlayerStandingMapX]
	ld d, a
	ld a, [PlayerStandingMapY]
	ld e, a

	push de
	inc e
	call GetCoordTile
	ld [TileDown], a
	call .Down

	pop de
	dec e
	call GetCoordTile
	ld [TileUp], a
	jp .Up

.LeftRight
	ld a, [PlayerStandingMapX]
	ld d, a
	ld a, [PlayerStandingMapY]
	ld e, a

	push de
	dec d
	call GetCoordTile
	ld [TileLeft], a
	call .Left

	pop de
	inc d
	call GetCoordTile
	ld [TileRight], a
	jp .Right

.Down
	call .CheckHiNybble
	ret nz
	ld a, [TileDown]
	and 7
	cp $2
	jr z, .ok_down
	cp $6
	jr z, .ok_down
	cp $7
	ret nz

.ok_down
	ld a, [TilePermissions]
	or FACE_DOWN
	ld [TilePermissions], a
	ret

.Up
	call .CheckHiNybble
	ret nz
	ld a, [TileUp]
	and 7
	cp $3
	jr z, .ok_up
	cp $4
	jr z, .ok_up
	cp $5
	ret nz

.ok_up
	ld a, [TilePermissions]
	or FACE_UP
	ld [TilePermissions], a
	ret

.Right
	call .CheckHiNybble
	ret nz
	ld a, [TileRight]
	and 7
	cp $1
	jr z, .ok_right
	cp $5
	jr z, .ok_right
	cp $7
	ret nz

.ok_right
	ld a, [TilePermissions]
	or FACE_RIGHT
	ld [TilePermissions], a
	ret

.Left
	call .CheckHiNybble
	ret nz
	ld a, [TileLeft]
	and 7
	cp $0
	jr z, .ok_left
	cp $4
	jr z, .ok_left
	cp $6
	ret nz

.ok_left
	ld a, [TilePermissions]
	or FACE_LEFT
	ld [TilePermissions], a
	ret

.CheckHiNybble
	and $f0
	cp $b0
	ret z
	cp $c0
	ret

GetFacingTileCoord::
; Return map coordinates in (d, e) and tile id in a
; of the tile the player is facing.

	ld a, [PlayerDirection]
	and %1100
	rrca
	rrca
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, .Directions
	add hl, de

	ld d, [hl]
	inc hl
	ld e, [hl]
	inc hl

	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [PlayerStandingMapX]
	add d
	ld d, a
	ld a, [PlayerStandingMapY]
	add e
	ld e, a
	ld a, [hl]
	ret

.Directions
	;   x,  y
	db  0,  1
	dw TileDown
	db  0, -1
	dw TileUp
	db -1,  0
	dw TileLeft
	db  1,  0
	dw TileRight

GetCoordTile::
; Get the collision byte for tile d, e
	call GetBlockLocation
	ld a, [hl]
	and a
	jr z, .nope
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	ld a, h
	add (wDecompressedCollision >> 8)
	ld h, a

	rr d
	jr nc, .nocarry
	inc l

.nocarry
	rr e
	jr nc, .nocarry2
	inc l
	inc l

.nocarry2
	ld a, BANK(wDecompressedCollision)
	jp GetFarWRAMByte

.nope
	ld a, -1
	ret

GetBlockLocation::
	ld a, [MapWidth]
	add 6
	ld c, a
	ld b, 0
	ld hl, OverworldMap + 1
	add hl, bc
	ld a, e
	srl a
	jr z, .nope
	rst AddNTimes
.nope
	ld c, d
	srl c
	ld b, 0
	add hl, bc
	ret

CheckFacingSign::
	call GetFacingTileCoord
; Load facing into b.
	ld b, a
; Convert the coordinates at de to within-boundaries coordinates.
	ld a, d
	sub 4
	ld d, a
	ld a, e
	sub 4
	ld e, a
; If there are no signposts, we don't need to be here.
	ld a, [wCurrentMapSignpostCount]
	and a
	ret z
	ld c, a
	call StackCallInMapScriptHeaderBank

.CheckIfFacingTileCoordIsSign:
; Checks to see if you are facing a signpost.  If so, copies it into EngineBuffer1 and sets carry.
	ld hl, wCurrentMapSignpostHeaderPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
.loop
	push hl
	ld a, [hli]
	cp e
	jr nz, .next
	ld a, [hli]
	cp d
	jr nz, .next
	jr .copysign

.next
	pop hl
	ld a, 5 ; signpost event length
	add l
	ld l, a
	jr nc, .nocarry
	inc h

.nocarry
	dec c
	jr nz, .loop
	xor a
	ret

.copysign
	pop hl
	ld de, wCurSignpostYCoord
	ld bc, 5 ; signpost event length
	rst CopyBytes
	scf
	ret

CheckCurrentMapXYTriggers::
; If there are no xy triggers, we don't need to be here.
	ld a, [wCurrentMapXYTriggerCount]
	and a
	ret z
; Copy the trigger count into c.
	ld c, a
	call StackCallInMapScriptHeaderBank

.TriggerCheck:
; Checks to see if you are standing on an xy-trigger.  If yes, copies the trigger to EngineBuffer1 and sets carry.
	ld hl, wCurrentMapXYTriggerHeaderPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
; Load the active trigger ID into b
	call CheckTriggers
	ld b, a
; Load your current coordinates into de.  This will be used to check if your position is in the xy-trigger table for the current map.
	ld a, [PlayerStandingMapX]
	sub 4
	ld d, a
	ld a, [PlayerStandingMapY]
	sub 4
	ld e, a

.loop
	push hl
	ld a, [hli]
	cp b
	jr z, .got_id
	cp -1
	jr nz, .next

.got_id
	ld a, [hli]
	cp e
	jr nz, .next
	ld a, [hli]
	cp d
	jr nz, .next
	inc hl
	inc hl
	inc hl
	push de
	push bc
	call .CheckXYTriggerFlag
	pop bc
	pop de
	jr nz, .copytrigger

.next
	pop hl
	ld a, $8 ; xy-trigger size
	add l
	ld l, a
	jr nc, .nocarry
	inc h

.nocarry
	dec c
	jr nz, .loop
	xor a
	ret

.CheckXYTriggerFlag:
	ld a, [hli]
	ld d, [hl]
	ld e, a
	or d
	ld b, CHECK_FLAG
	jp nz, EventFlagAction
	inc a
	ret

.copytrigger
	pop hl
	ld de, wCurCoordEventTriggerID
	ld bc, 8 ; xy-trigger size
	rst CopyBytes
	scf
	ret

FadeToMenu::
	xor a
	ld [hBGMapMode], a
	call LoadStandardMenuDataHeader
	ld c, 1 << 7 | 3
	call FadeToWhite
	call ClearSprites
	jp DisableSpriteUpdates

CloseSubmenu::
	call ClearBGPalettes
	call ReloadTilesetAndPalettes
	call UpdateSprites
	call ExitMenu
	jr FinishExitMenu

ExitAllMenus::
	call ClearBGPalettes
	call ExitMenu
	call ReloadTilesetAndPalettes
	call UpdateSprites
	; fallthrough
FinishExitMenu::
	ld b, SCGB_MAPPALS
	predef GetSGBLayout
	callba LoadOW_BGPal7
	call ApplyAttrAndTilemapInVBlank
	callba FadeInPalettes
	jp EnableSpriteUpdates

ReturnToMapWithSpeechTextbox::
	push af
	ld a, $1
	ld [wSpriteUpdatesEnabled], a
	call ClearBGPalettes
	call ClearSprites
	call ReloadTilesetAndPalettes
	hlcoord 0, 12
	lb bc, 4, 18
	call TextBox
	ld hl, VramState
	set 0, [hl]
	call UpdateSprites
	call ApplyAttrAndTilemapInVBlank
	ld b, SCGB_MAPPALS
	predef GetSGBLayout
	callba LoadOW_BGPal7
	call UpdateTimePals
	call DelayFrame
	ld a, $1
	ld [hMapAnims], a
	pop af
	ret

ReloadTilesetAndPalettes::
	call DisableLCD
	call ClearSprites
	callba RefreshSprites
	call LoadStandardFont
	call LoadFontsExtra
	call ProtectedBankStackCall
	
.Function
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
	call SwitchToAnyMapBank
	callba UpdateTimeOfDayPal
	call OverworldTextModeSwitch
	call LoadTileset
	ld a, 9
	call SkipMusic
	jp EnableLCD

GetMapHeaderPointer::
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
GetAnyMapHeaderPointer::
; Prior to calling this function, you must have switched banks so that
; MapGroupPointers is visible.

; inputs:
; b = map group, c = map number
; XXX de = ???

; outputs:
; hl points to the map header
	push bc ; save map number for later

	; get pointer to map group
	dec b
	ld c, b
	ld b, 0
	ld hl, MapGroupPointers
	add hl, bc
	add hl, bc

	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop bc ; restore map number

	; find the cth map header
	dec c
	ld b, 0
	ld a, 9
	rst AddNTimes
	ret

GetMapHeaderMember::
; Extract data from the current map's header.

; inputs:
; de = offset of desired data within the mapheader

; outputs:
; bc = data from the current map's header
; (e.g., de = $0003 would return a pointer to the secondary map header)

	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
GetAnyMapHeaderMember::
	; bankswitch
	
	anonbankpush MapGroupPointers
	
.Function:
	call GetAnyMapHeaderPointer
	add hl, de
	ld a, [hli]
	ld b, [hl]
	ld c, a
	ret

SwitchToMapBank::
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
	; fallthrough
SwitchToAnyMapBank::
	call GetAnyMapBank
	rst Bankswitch
	ret

GetMapBank::
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
GetAnyMapBank::
	push hl
	push de
	ld de, 0
	call GetAnyMapHeaderMember
	ld a, c
	pop de
	pop hl
	ret

PartiallyCopyMapHeader::
; Copy second map header bank, tileset, permission, and second map header address
; from the current map's map header.
	anonbankpush MapGroupPointers
	
.Function:
	call GetMapHeaderPointer
	ld de, wSecondMapHeaderBank
	ld bc, MapHeader - wSecondMapHeaderBank
	rst CopyBytes
	ret

GetAnyMapBlockdataBankPointer::
; Return the blockdata bank for group b map c.
	push de
	push bc

	push bc
	ld de, 3 ; second map header pointer
	call GetAnyMapHeaderMember
	ld l, c
	ld h, b
	pop bc

	push hl
	ld de, 0 ; second map header bank
	call GetAnyMapHeaderMember
	pop hl

	inc hl
	inc hl
	inc hl
	ld a, c
	call GetFarByteHalfword
	rst Bankswitch

	jr PopOffBCDEAndReturn

GetSecondaryMapHeaderPointer::
; returns the current map's secondary map header pointer in hl.
	push de
	push bc
	ld de, 3 ; secondary map header pointer (offset within header)
	call GetMapHeaderMember
	ld l, c
	ld h, b
PopOffBCDEAndReturn:
	pop bc
	pop de
	ret

GetMapPermission::
	push hl
	push de
	push bc
	ld de, 2 ; permission
	call GetMapHeaderMember
	jp GetMapHeaderAttribute_PopOffBCDEHLAndReturn

GetAnyMapPermission::
	push hl
	push de
	push bc
	ld de, 2 ; permission
	call GetAnyMapHeaderMember
	jp GetMapHeaderAttribute_PopOffBCDEHLAndReturn

GetCurMapTileset::
	ld de, 1 ; tileset
	call GetMapHeaderMember
	ld a, c
	ret

GetAnyMapTileset::
	ld de, 1 ; tileset
	call GetAnyMapHeaderMember
	ld a, c
	ret

GetCurWorldMapLocation::
	push hl
	push de
	push bc

	ld de, 5 ; landmark
	call GetMapHeaderMember
	jp GetMapHeaderAttribute_PopOffBCDEHLAndReturn

GetWorldMapLocation::
; given a map group/id in bc, return its location on the Pokégear map.
	push hl
	push de
	push bc

	ld de, 5 ; landmark
	call GetAnyMapHeaderMember
	jp GetMapHeaderAttribute_PopOffBCDEHLAndReturn

GetMapMusic::
	call SpecialMapMusic
	ret c

; fallthrough
GetMapHeaderMusic::
	push hl
	push bc
	ld de, 6 ; music
	call GetMapHeaderMember
	ld e, c
	ld d, 0
PopOffBCHLAndReturn:
	pop bc
	pop hl
	ret

GetMapHeaderTimeOfDayNybble::
	push hl
	push bc

	ld de, 7 ; phone service and time of day
	call GetMapHeaderMember
	ld a, c
	and $f

	jr PopOffBCHLAndReturn

GetFishingGroup::
	push de
	push hl
	push bc

	ld de, 8 ; fishing group
	call GetMapHeaderMember
	jp GetMapHeaderAttribute_PopOffBCDEHLAndReturn

LoadTilesetHeader::
	push hl
	push bc

	ld hl, Tilesets
	ld bc, Tileset01 - Tileset00
	ld a, [wTileset]
	rst AddNTimes

	ld de, TilesetBank
	ld bc, Tileset01 - Tileset00

	ld a, BANK(Tilesets)
	call FarCopyBytes
	jr PopOffBCHLAndReturn
	
GetCurNick::
	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames
	; fallthrough

GetNick::
; Get nickname a from list hl.

	push hl
	push bc

	call SkipNames
	ld de, wStringBuffer1

	push de
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	pop de

	callba CheckNickErrors

	jr PopOffBCHLAndReturn