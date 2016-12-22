FieldMoveFailed:
	ld hl, .CantUseHere
	jp MenuTextBoxBackup

.CantUseHere
	; Can't use that here.
	text_jump UnknownText_0x1c05c8

FieldMovePokepicScript::
	checkflag ENGINE_POKEMON_MODE
	iftrue .skip
	refreshscreen $0
	callasm GetPartyMonUsingFieldMove
	checkcode VAR_MOVEMENT
	iftrue .no_movement
	applymovement $0, FieldMoveMovement
	special ReplaceKrisSprite
.no_movement
	copybytetovar wFieldMovePokepicSpecies
	pokepic 0
	callasm .PlayCry
	closepokepic
	reloadmappart
.skip
	end

.PlayCry:
	ld a, [hScriptVar]
	call LoadCryHeader
	jr nc, .regularCry
	ld a, 3
	ld [hRunPicAnim], a
	call .regularCry
	xor a
	ld [hRunPicAnim], a
	ret
.regularCry
	ld a, [hScriptVar]
	jp PlayCry

FieldMoveMovement:
	field_move
	step_end

CutFunction:
	call ClearFieldMoveBuffer
.loop
	ld hl, .Jumptable
	call FieldMoveJumptable
	jr nc, .loop
	and $7f
	ld [wFieldMoveSucceeded], a
	ret

.Jumptable
	dw .CheckAble
	dw .DoCut
	dw .FailCut

.CheckAble
	CheckEngine ENGINE_NATUREBADGE
	jr z, .nohivebadge
	call CheckMapForSomethingToCut
	jr c, .nothingtocut
	ld a, $1
	ret

.nohivebadge
	call PrintNoBadgeText
	ld a, $80
	ret

.nothingtocut
	ld a, $2
	ret

.DoCut
	ld hl, Script_CutFromMenu
	call QueueScript
	ld a, $81
	ret

.FailCut
	ld hl, Text_NothingToCut
	call MenuTextBoxBackup
	ld a, $80
	ret

Text_UsedCut:
	; used CUT!
	text_jump UnknownText_0x1c05dd

Text_NothingToCut:
	; There's nothing to CUT here.
	text_jump UnknownText_0x1c05ec

CheckMapForSomethingToCut:
	; Does the collision data of the facing tile permit cutting?
	call GetFacingTileCoord
	ld c, a
	push de
	callba CheckCutCollision
	pop de
	jr nc, .fail
	; Get the location of the current block in OverworldMap.
	call GetBlockLocation
	ld c, [hl]
	; See if that block contains something that can be cut.
	push hl
	ld hl, CutTreeBlockPointers
	call CheckOverworldTileArrays
	pop hl
	jr nc, .fail
	; Back up the OverworldMap address to wFieldMoveCutTileLocation
	ld a, l
	ld [wFieldMoveCutTileLocation], a
	ld a, h
	ld [wFieldMoveCutTileLocation + 1], a
	; Back up the replacement tile to wFieldMoveCutTileReplacement
	ld a, b
	ld [wFieldMoveCutTileReplacement], a
	; Back up the animation index to wWhichCutAnimation
	ld a, c
	ld [wWhichCutAnimation], a
	xor a
	ret

.fail
	scf
	ret

Script_CutFromMenu:
	reloadmappart
	special UpdateTimePals

Script_Cut:
	callasm GetPartyNick
	writetext Text_UsedCut
	reloadmappart
	callstd fieldmovepokepic
	callasm CutDownTreeOrGrass
	closetext
	end

CutDownTreeOrGrass:
	ld hl, wFieldMoveCutTileLocation ; OverworldMapTile
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wFieldMoveCutTileReplacement] ; ReplacementTile
	ld [hl], a
	xor a
	ld [hBGMapMode], a
	call OverworldTextModeSwitch
	call UpdateSprites
	call DelayFrame
	ld a, [wWhichCutAnimation] ; Animation type
	ld e, a
	callba OWCutAnimation
	call BufferScreen
	call GetMovementPermissions
	call UpdateSprites
	call DelayFrame
	jp LoadStandardFont

CheckOverworldTileArrays:
	; Input: c contains the tile you're facing
	; Output: Replacement tile in b and effect on wild encounters in c, plus carry set.
	;         Carry is not set if the facing tile cannot be replaced, or if the tileset
	;         does not contain a tile you can replace.

	; Dictionary lookup for pointer to tile replacement table
	push bc
	ld a, [wTileset]
	ld e, 3
	call IsInArray
	pop bc
	jr nc, .nope
	; Load the pointer
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	; Look up the tile you're facing
	ld e, 3
	ld a, c
	call IsInArray
	jr nc, .nope
	inc hl
	ld a, [hli]
	ld c, [hl] ; Load the animation type parameter to c
	ld b, a ; Load the replacement to b
	scf
	ret

.nope
	xor a
	ret

CutTreeBlockPointers:
; Which tileset are we in?
	dbw TILESET_NALJO_1, .naljo
	dbw TILESET_NALJO_2, .naljo
	dbw TILESET_RIJON, .rijon
	dbw TILESET_JOHTO, .johto
	dbw TILESET_KANTO, .kanto
	dbw TILESET_PARK, .park
	dbw TILESET_FOREST, .ilex
	db -1

.naljo
; Which meta tile are we facing, which should we replace it with, and which animation?
	db $03, $02, $01 ; grass
	db $5b, $3c, $00 ; tree
	db $5f, $3d, $00 ; tree
	db $63, $3f, $00 ; tree
	db $67, $3e, $00 ; tree
	db -1

.johto ; Goldenrod area
	db $03, $02, $01 ; grass
	db -1

.rijon ; Rijon OW
.kanto ; Kanto OW
	db $0b, $0a, $01 ; grass
	db $32, $6d, $00 ; tree
	db $33, $6c, $00 ; tree
	db $34, $6f, $00 ; tree
	db $35, $41, $00 ; tree
	db $60, $6e, $00 ; tree
	db -1

.park ; National Park
	db $13, $03, $01 ; grass
	db $03, $04, $01 ; grass
	db -1

.ilex ; Ilex Forest
	db $0f, $17, $00
	db -1

WhirlpoolBlockPointers:
	db -1

.johto
	db $07, $36, $00
	db -1

OWFlash:
	call .CheckUseFlash
	and $7f
	ld [wFieldMoveSucceeded], a
	ret

.CheckUseFlash
	jr c, .useflash
	ld a, [wTimeOfDayPalset]
	cp %11111111 ; 3, 3, 3, 3
	jr nz, .notadarkcave
.useflash
	call UseFlash
	ld a, $81
	ret

.notadarkcave
	call FieldMoveFailed
	ld a, $80
	ret

UseFlash:
	ld hl, Script_UseFlash
	jp QueueScript

Script_UseFlash:
	reloadmappart
	special UpdateTimePals
	callstd fieldmovepokepic
	writetext UnknownText_0xc8f3
	playwaitsfx SFX_FLASH
	callasm BlindingFlash
	closetext
	end

UnknownText_0xc8f3:
	text_jump UnknownText_0x1c0609

SurfFunction:
	call ClearFieldMoveBuffer
.loop
	ld hl, .Jumptable
	call FieldMoveJumptable
	jr nc, .loop
	and $7f
	ld [wFieldMoveSucceeded], a
	ret

.Jumptable
	dw .TrySurf
	dw .DoSurf
	dw .FailSurf
	dw .AlreadySurfing

.TrySurf
	CheckEngine ENGINE_HAZEBADGE
	jr z, .no_badge
	ld hl, wBikeFlags
	bit 1, [hl] ; always on bike
	jr nz, .cannotsurf
	ld a, [PlayerState]
	cp PLAYER_SURF
	jr z, .alreadyfail
	cp PLAYER_SURF_PIKA
	jr z, .alreadyfail
	call GetFacingTileCoord
	cp $9f ; fast current
	jr z, .currentTooFast
	call GetTileCollision
	dec a
	jr nz, .cannotsurf
	call CheckDirection
	jr c, .cannotsurf
	callba CheckFacingObject
	jr c, .cannotsurf
	ld hl, MapGroup
	ld a, [hli]
	cp GROUP_SAXIFRAGE_ISLAND
	jr nz, .notInSaxifrage
	ld a, [hl]
	cp MAP_SAXIFRAGE_ISLAND
	jr z, .inSaxifrage
.notInSaxifrage
	ld a, $1
	ret

.inSaxifrage
	ld hl, CantSurfSaxifrageText
	jr .PrintFailureMessageWithPrompt

.currentTooFast:
	ld hl, .FastCurrentText

.PrintFailureMessageWithPrompt:
	call MenuTextBox
	call ButtonSound
	call CloseWindow
	ld a, $80
	ret

.no_badge
	call PrintNoBadgeText
	ld a, $80
	ret

.alreadyfail
	ld a, $3
	ret

.cannotsurf
	ld a, $2
	ret

.DoSurf
	call GetSurfType
	ld [wFieldMoveSurfType], a
	call GetPartyNick
	ld hl, SurfFromMenuScript
	call QueueScript
	ld a, $81
	ret

.FailSurf
	ld hl, CantSurfText
	call MenuTextBoxBackup
	ld a, $80
	ret

.AlreadySurfing
	ld hl, AlreadySurfingText
	call MenuTextBoxBackup
	ld a, $80
	ret

.FastCurrentText
	text_jump FastCurrentText

SurfFromMenuScript:
	special UpdateTimePals

UsedSurfScript:
	writetext UsedSurfText ; "used SURF!"
	waitbutton
	closetext
	callstd fieldmovepokepic
	copybytetovar wFieldMoveSurfType
	writevarcode VAR_MOVEMENT

	special ReplaceKrisSprite
	special PlayMapMusic
; step into the water
	special Special_SurfStartStep ; (slow_step_x, step_end)
	applymovement PLAYER, MovementBuffer ; PLAYER, MovementBuffer
	end

UsedSurfText:
	text_jump _UsedSurfText

CantSurfText:
	text_jump _CantSurfText

AlreadySurfingText:
	text_jump _AlreadySurfingText

GetSurfType:
; Surfing on Pikachu uses an alternate sprite.
; This is done by using a separate movement type.

	ld a, [wCurPartyMon]
	ld e, a
	ld d, 0
	ld hl, wPartySpecies
	add hl, de

	ld a, [hl]
	cp PIKACHU
	ld a, PLAYER_SURF_PIKA
	ret z
	ld a, PLAYER_SURF
	ret

CheckDirection:
; Return carry if a tile permission prevents you
; from moving in the direction you're facing.

; Get player direction
	ld a, [PlayerDirection]
	and %00001100 ; bits 2 and 3 contain direction
	rrca
	rrca
	ld e, a
	ld d, 0
	ld hl, .Directions
	add hl, de

; Can you walk in this direction?
	ld a, [TilePermissions]
	and [hl]
	jr nz, .quit
	xor a
	ret

.quit
	scf
	ret

.Directions
	db FACE_DOWN
	db FACE_UP
	db FACE_LEFT
	db FACE_RIGHT

TrySurfOW::
; Checking a tile in the overworld.
; Return carry if fail is allowed.

; Don't ask to surf if already fail.
	ld a, [PlayerState]
	cp PLAYER_SURF_PIKA
	jr z, .quit
	cp PLAYER_SURF
	jr z, .quit

; Must be facing water.
	ld a, [wTempFacingTile]
	call GetTileCollision
	dec a ; surfable
	jr nz, .quit

; Check tile permissions.
	call CheckDirection
	jr c, .quit

	CheckEngine ENGINE_HAZEBADGE
	jr z, .quit

	ld d, SURF
	call CheckPartyMove
	jr c, .quit

	ld hl, wBikeFlags
	bit 1, [hl] ; always on bike (can't surf)
	jr nz, .quit

	ld hl, MapGroup
	ld a, [hli]
	cp GROUP_SAXIFRAGE_ISLAND
	jr nz, .notInSaxifrage
	ld a, [hl]
	cp MAP_SAXIFRAGE_ISLAND
	jr z, .inSaxifrage

.notInSaxifrage
	call GetSurfType
	ld [wFieldMoveSurfType], a
	call GetPartyNick

	ld hl, AskSurfScript
	jr .script

.inSaxifrage
	ld hl, NoSurfSaxifrageScript
.script
	ld a, BANK(NoSurfSaxifrageScript)
	call CallScript
	scf
	ret

.quit
	xor a
	ret

NoSurfSaxifrageScript:
	jumptext CantSurfSaxifrageText

AskSurfScript:
	opentext
	writetext AskSurfText
	yesorno
	iftrue UsedSurfScript
	closetext
	end

AskSurfText:
	text_jump _AskSurfText ; The water is calm.

FlyFunction:
	call ClearFieldMoveBuffer
.loop
	ld hl, .Jumptable
	call FieldMoveJumptable
	jr nc, .loop
	and $7f
	ld [wFieldMoveSucceeded], a
	ret

.Jumptable
 	dw .TryFly
 	dw .DoFly
 	dw .FailFly
	dw .FailFlyNoMessage

.TryFly
	CheckEngine ENGINE_ELECTRONBADGE
	jp z, .nostormbadge
	call GetMapPermission
	call CheckOutdoorMap
	jp nz, .indoors

	; outdoors
	ld a, [MapGroup]
	cp GROUP_SAXIFRAGE_ISLAND
	jr nz, .notSaxifrage
	CheckEngine ENGINE_RAUCOUSBADGE
	jr z, .cantFlySaxifrage
.notSaxifrage
	ld a, [EventFlags + (EVENT_IN_UNDERCOVER_MISSION / 8)]
	bit (EVENT_IN_UNDERCOVER_MISSION % 8), a
	jr nz, .inUndercoverMission

	CheckEngine ENGINE_PARK_MINIGAME
	jr nz, .in_park_minigame

	callba RegionCheck
	ld a, e
	cp REGION_KANTO
	jp z, .no
	cp REGION_SEVII
	jp z, .no
	cp REGION_MYSTERY
	jp z, .no
	cp REGION_TUNOD
	jp z, .tunodCheck
	cp REGION_JOHTO
	jp z, .johtoCheck
	jp .ok
.no
	ld hl, CantUseFlyHere
.error_message_loaded
	call MenuTextBox
	call CloseWindow
	ld a, $3
	ret

.ok
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
	call GetWorldMapLocation

	xor a
	ld [hMapAnims], a
	call LoadStandardMenuDataHeader
	call ClearSprites
	callba _FlyMap
	ld a, e
	cp -1
	jr z, .illegal
	cp NUM_SPAWNS
	jr nc, .illegal

	ld [wd001], a
	call CloseWindow
	ld a, $1
	ret

.tunodCheck
	ld a, [VisitedSpawns + 3]
	and 8
	jr z, .no
	jr .ok

.johtoCheck
	ld a, [VisitedSpawns + 3]
	and 3
	jr z, .no
	jr .ok

.inUndercoverMission
	ld hl, CantFlyUndercover
	jr .error_message_loaded

.cantFlySaxifrage
	ld hl, CantFlySaxifrage
	jr .error_message_loaded

.in_park_minigame
	ld hl, CantFlyParkChallenge
	jr .error_message_loaded

.nostormbadge
	call PrintNoBadgeText
	ld a, $82
	ret

.indoors
	ld a, $2
	ret

.illegal
	call CloseWindow
	call ApplyTilemapInVBlank
	ld a, $80
	ret

.DoFly
	ld hl, .FlyScript
	call QueueScript
	ld a, $81
	ret

.FailFly
	call FieldMoveFailed
.FailFlyNoMessage
	ld a, $82
	ret

.FlyScript
	reloadmappart
	callasm HideSprites
	special UpdateTimePals
	callstd fieldmovepokepic
	callasm FlyFromAnim
	special ClearSafariZoneFlag
	callasm DelayLoadingNewSprites
	writecode VAR_MOVEMENT, PLAYER_NORMAL
	newloadmap MAPSETUP_FLY
	callasm FlyToAnim
	waitsfx
	callasm .ReturnFromFly
	setevent EVENT_USED_FLY_AT_LEAST_ONCE
	end

.ReturnFromFly
	callba ReturnFromFly_SpawnOnlyPlayer
	call DelayFrame
	jp ReplaceKrisSprite

CantUseFlyHere:
	text_jump _CantUseFlyHere

CantFlyUndercover:
	text_jump _CantFlyUndercover

CantFlySaxifrage:
	text_jump _CantFlySaxifrage

CantFlyParkChallenge:
	text_jump _CantFlyParkChallenge

WaterfallFunction:
	call .TryWaterfall
	and $7f
	ld [wFieldMoveSucceeded], a
	ret

.TryWaterfall
	CheckEngine ENGINE_MARINEBADGE
	jr z, .noMarineBadge
	call CheckMapCanWaterfall
	jr c, .failed
	ld hl, Script_WaterfallFromMenu
	call QueueScript
	ld a, $81
	ret

.noMarineBadge
	call PrintNoBadgeText
	ld a, $80
	ret

.failed
	call FieldMoveFailed
	ld a, $80
	ret

CheckMapCanWaterfall:
	ld a, [PlayerDirection]
	and $c
	cp FACE_UP
	jr nz, .failed
	ld a, [TileUp]
	call CheckWaterfallTile
	jr nz, .failed
	xor a
	ret

.failed
	scf
	ret

Script_WaterfallFromMenu:
	reloadmappart
	special UpdateTimePals

Script_UsedWaterfall:
	callasm GetPartyNick
	writetext .Text_UsedWaterfall
	waitbutton
	closetext
	callstd fieldmovepokepic
.loop
	applymovement PLAYER, .WaterfallStep
	callasm .CheckContinueWaterfall
	iffalse .loop
	end

.CheckContinueWaterfall
	xor a
	ld [hScriptVar], a
	ld a, [PlayerStandingTile]
	call CheckWaterfallTile
	ret z
	ld a, $1
	ld [hScriptVar], a
	ret

.WaterfallStep
	slow_step_up
	step_end

.Text_UsedWaterfall
	; used WATERFALL!
	text_jump UnknownText_0x1c068e

TryWaterfallOW::
	ld d, WATERFALL
	call CheckPartyMove
	jr c, .failed
	CheckEngine ENGINE_MARINEBADGE
	jr z, .failed
	call CheckMapCanWaterfall
	jr c, .failed
	ld a, BANK(Script_AskWaterfall)
	ld hl, Script_AskWaterfall
	call CallScript
	scf
	ret

.failed
	ld a, BANK(Script_CantDoWaterfall)
	ld hl, Script_CantDoWaterfall
	call CallScript
	scf
	ret

Script_CantDoWaterfall:
	jumptext .Text_CantDoWaterfall

.Text_CantDoWaterfall
	; Wow, it's a huge waterfall.
	text_jump UnknownText_0x1c06a3

Script_AskWaterfall:
	opentext
	writetext .AskUseWaterfall
	yesorno
	iftrue Script_UsedWaterfall
	closetext
	end

.AskUseWaterfall
	; Do you want to use WATERFALL?
	text_jump UnknownText_0x1c06bf

EscapeRopeFunction:
	call ClearFieldMoveBuffer
	ld a, $1
	jr Dig_InCave

DigFunction:
	call ClearFieldMoveBuffer
	ld a, $2
	; fallthrough

Dig_InCave:
	ld [wFieldMoveEscapeType], a
.loop
	ld hl, .DigTable
	call FieldMoveJumptable
	jr nc, .loop
	and $7f
	ld [wFieldMoveSucceeded], a
	ret

.DigTable
	dw .CheckCanDig
	dw .DoDig
	dw .FailDig

.CheckCanDig
	CheckEngine ENGINE_PARK_MINIGAME
	jr nz, .fail
	call GetMapPermission
	cp CAVE
	jr z, .incave
	cp DUNGEON
	jr z, .incave
.fail
	ld a, $2
	ret

.incave
	ld hl, wDigWarp
	ld a, [hli]
	and a
	jr z, .fail
	ld a, [hli]
	and a
	jr z, .fail
	ld a, [hl]
	and a
	jr z, .fail
	CheckEngine ENGINE_POKEMON_MODE
	jr nz, .fail
	ld a, $1
	ret

.DoDig
	ld hl, wDigWarp
	ld de, wNextWarp
	ld bc, 3
	rst CopyBytes
	call GetPartyNick
	ld a, [wFieldMoveEscapeType]
	cp $2
	jr nz, .escaperope
	ld hl, .UsedDigScript
	call QueueScript
	ld a, $81
	ret

.escaperope
	;callba SpecialKabutoChamber
	ld hl, .UsedEscapeRopeScript
	call QueueScript
	ld a, $81
	ret

.FailDig
	ld a, [wFieldMoveEscapeType]
	cp $2
	jr nz, .failescaperope
	ld hl, .Text_CantUseHere
	call MenuTextBox
	call WaitPressAorB_BlinkCursor
	call CloseWindow

.failescaperope
	ld a, $80
	ret

.Text_UsedDig
	; used DIG!
	text_jump UnknownText_0x1c06de

.Text_UsedEscapeRope
	; used an ESCAPE ROPE.
	text_jump UnknownText_0x1c06ed

.Text_CantUseHere
	; Can't use that here.
	text_jump UnknownText_0x1c0705

.UsedEscapeRopeScript
	reloadmappart
	special UpdateTimePals
	writetext .Text_UsedEscapeRope
	waitbutton
	closetext
	jump .UsedDigOrEscapeRopeScript

.UsedDigScript
	reloadmappart
	special UpdateTimePals
	writetext .Text_UsedDig
	waitbutton
	closetext
	callstd fieldmovepokepic
	; fallthrough

.UsedDigOrEscapeRopeScript
	playsound SFX_WARP_TO
	applymovement PLAYER, .DigOut
	special ClearSafariZoneFlag
	writecode VAR_MOVEMENT, PLAYER_NORMAL
	newloadmap MAPSETUP_DOOR
	playsound SFX_WARP_FROM
	applymovement PLAYER, .DigReturn
	end

.DigOut
	step_dig 32
	hide_person
	step_end

.DigReturn
	show_person
	return_dig 32
	step_end

TeleportFunction:
	call ClearFieldMoveBuffer
.loop
	ld hl, .Jumptable
	call FieldMoveJumptable
	jr nc, .loop
	and $7f
	ld [wFieldMoveSucceeded], a
	ret

.Jumptable
	dw .TryTeleport
	dw .DoTeleport
	dw .FailTeleport

.TryTeleport
	CheckEngine ENGINE_PARK_MINIGAME
	jr nz, .nope
	call GetMapPermission
	call CheckOutdoorMap
	jr z, .CheckIfSpawnPoint
	jr .nope

.CheckIfSpawnPoint
	ld a, [wLastSpawnMapGroup]
	ld d, a
	ld a, [wLastSpawnMapNumber]
	ld e, a
	callba IsSpawnPoint
	jr nc, .nope
	ld a, c
	ld [wd001], a
	ld a, $1
	ret

.nope
	ld a, $2
	ret

.DoTeleport
	call GetPartyNick
	ld hl, .TeleportScript
	call QueueScript
	ld a, $81
	ret

.FailTeleport
	ld hl, .Text_CantUseHere
	call MenuTextBoxBackup
	ld a, $80
	ret

.Text_CantUseHere
	; Can't use that here.
	text_jump UnknownText_0x1c073b

.TeleportScript
	reloadmappart
	special UpdateTimePals
	callstd fieldmovepokepic
	playsound SFX_WARP_TO
	applymovement PLAYER, .TeleportFrom
	special ClearSafariZoneFlag
	writecode VAR_MOVEMENT, PLAYER_NORMAL
	newloadmap MAPSETUP_TELEPORT
	playsound SFX_WARP_FROM
	applymovement PLAYER, .TeleportTo
	end

.TeleportFrom
	teleport_from
	step_end

.TeleportTo
	teleport_to
	step_end

StrengthFunction:
	call .TryStrength
	and $7f
	ld [wFieldMoveSucceeded], a
	ret

.TryStrength
	CheckEngine ENGINE_GULFBADGE
	jr z, .Failed
	ld hl, Script_StrengthFromMenu
	call QueueScript
	ld a, $81
	ret

.Failed
	call PrintNoBadgeText
	ld a, $80
	ret

SetStrengthFlag:
	ld hl, wBikeFlags
	set 0, [hl]
	call GetPartyNick
GetPartyMonUsingFieldMove:
	ld a, [PlayerState]
	and a
	call z, .LoadGFX
	ld a, [wCurPartyMon]
	ld e, a
	ld d, 0
	ld hl, wPartySpecies
	add hl, de
	ld a, [hl]
	ld [wFieldMovePokepicSpecies], a
	ld a, MON_DVS
	call GetPartyParamLocation
	ld de, TempMonDVs
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ret

.LoadGFX:
	ld a, [rVBK]
	push af
	ld a, $1
	ld [rVBK], a
	ld a, [wPlayerCharacteristics]
	ld hl, Player12FieldMoveSpriteGFX
	and $f
	cp $c
	jr nc, .setGFX

	ld hl, FieldMoveSpriteGFX
	ld bc, 8 tiles
	rst AddNTimes

.setGFX
	ld d, h
	ld e, l
	lb bc, BANK(FieldMoveSpriteGFX), 4
	push bc
	push de
	ld hl, VTiles0 tile $00
	call Request2bpp
	pop hl
	ld de, 4 tiles
	add hl, de
	ld d, h
	ld e, l
	pop bc
	ld hl, VTiles1 tile $00
	call Request2bpp
	pop af
	ld [rVBK], a
	ret

Script_StrengthFromMenu:
	reloadmappart
	special UpdateTimePals

Script_UsedStrength:
	checkflag ENGINE_POKEMON_MODE
	iftrue .skip
	closetext
	callasm SetStrengthFlag
	checkcode VAR_MOVEMENT
	iftrue .no_movement
	applymovement $0, FieldMoveMovement
	special ReplaceKrisSprite
.no_movement
	copybytetovar wFieldMovePokepicSpecies
	pokepic 0
	cry 0
	waitsfx
	closepokepic
	opentext
.skip
	writetext .StrengthAllowedItToMoveBoulders
	endtext

.StrengthAllowedItToMoveBoulders
	text_jump UnknownText_0x1c0788

AskStrengthScript:
	callasm TryStrengthOW
	anonjumptable
	dw .AskStrength
	dw .DontMeetRequirements
	dw .AlreadyUsedStrength

.DontMeetRequirements
	jumptext UnknownText_0xcd73

.AlreadyUsedStrength
	jumptext UnknownText_0xcd6e

.AskStrength
	opentext
	writetext UnknownText_0xcd69
	yesorno
	iftrue Script_UsedStrength
	closetext
	end

UnknownText_0xcd69:
	; A #mon may be able to move this. Want to use STRENGTH?
	text_jump UnknownText_0x1c07a0

UnknownText_0xcd6e:
	; Boulders may now be moved!
	text_jump UnknownText_0x1c07d8

UnknownText_0xcd73:
	; A #mon may be able to move this.
	text_jump UnknownText_0x1c07f4

TryStrengthOW:
	ld d, STRENGTH
	call CheckPartyMove
	jr c, .nope

	CheckEngine ENGINE_HAZEBADGE
	jr z, .nope

	CheckEngine ENGINE_STRENGTH_ACTIVE
	jr z, .allow_use

	ld a, 2
	jr .done

.nope
	ld a, 1
	jr .done

.allow_use
	xor a

.done
	ld [hScriptVar], a
	ret

HeadbuttFunction:
	call TryHeadbuttFromMenu
	and $7f
	ld [wFieldMoveSucceeded], a
	ret

TryHeadbuttFromMenu:
	call GetFacingTileCoord
	call CheckHeadbuttTreeTile
	jr nz, .no_tree

	ld hl, HeadbuttFromMenuScript
	call QueueScript
	ld a, $81
	ret

.no_tree
	call FieldMoveFailed
	ld a, $80
	ret

UnknownText_0xce9d:
	; did a HEADBUTT!
	text_jump UnknownText_0x1c0897

UnknownText_0xcea2:
	; Nope. Nothing…
	text_jump UnknownText_0x1c08ac

HeadbuttFromMenuScript:
	reloadmappart
	special UpdateTimePals

HeadbuttScript:
	callasm GetPartyNick
	writetext UnknownText_0xce9d
	callstd fieldmovepokepic
	callasm ShakeHeadbuttTree

	callasm TreeMonEncounter
	iffalse .no_battle
	closetext
	randomwildmon
	startbattle
	reloadmapafterbattle
	end

.no_battle
	writetext UnknownText_0xcea2
	endtext

TryHeadbuttOW::
	ld d, HEADBUTT
	call CheckPartyMove
	jr c, .no

	ld a, BANK(AskHeadbuttScript)
	ld hl, AskHeadbuttScript
	call CallScript
	scf
	ret

.no
	xor a
	ret

AskHeadbuttScript:
	opentext
	writetext UnknownText_0xcee6
	yesorno
	iftrue HeadbuttScript
	closetext
	end

UnknownText_0xcee6:
	; A #mon could be in this tree. Want to HEADBUTT it?
	text_jump UnknownText_0x1c08bc

RockSmashFunction:
	call TryRockSmashFromMenu
	and $7f
	ld [wFieldMoveSucceeded], a
	ret

TryRockSmashFromMenu:
	call GetFacingObject
	jr c, .no_rock
	ld a, d
	cp $18
	jr nz, .no_rock

	ld hl, RockSmashFromMenuScript
	call QueueScript
	ld a, $81
	ret

.no_rock
	call FieldMoveFailed
	ld a, $80
	ret

GetFacingObject:
	callba CheckFacingObject
	jr nc, .fail

	ld a, [hObjectStructIndexBuffer]
	call GetObjectStruct
	ld hl, OBJECT_MAP_OBJECT_INDEX
	add hl, bc
	ld a, [hl]
	ld [hLastTalked], a
	call GetMapObject
	ld hl, MAPOBJECT_MOVEMENT
	add hl, bc
	ld a, [hl]
	ld d, a
	and a
	ret

.fail
	scf
	ret

RockSmashFromMenuScript:
	reloadmappart
	special UpdateTimePals

RockSmashScript::
	callasm GetPartyNick
	writetext UnknownText_0xcf58
	closetext
	callstd fieldmovepokepic
	playsound SFX_STRENGTH
	earthquake 84
	applymovement2 MovementData_0xcf55
	disappear -2

	callasm RockMonEncounter
	copybytetovar TempWildMonSpecies
	iffalse .done
	randomwildmon
	startbattle
	reloadmapafterbattle
.done
	end

MovementData_0xcf55:
	rock_smash 10
	step_end

UnknownText_0xcf58:
	text_jump UnknownText_0x1c08f0

AskRockSmashScript:
	callasm HasRockSmash
	if_equal 1, .no

	opentext
	writetext UnknownText_0xcf77
	yesorno
	iftrue RockSmashScript
	closetext
	end
.no
	jumptext UnknownText_0xcf72

UnknownText_0xcf72:
	; Maybe a #mon can break this.
	text_jump UnknownText_0x1c0906

UnknownText_0xcf77:
	; This rock looks breakable. Want to use ROCK SMASH?
	text_jump UnknownText_0x1c0924

HasRockSmash::
	ld d, ROCK_SMASH
	call CheckPartyMove
	jr nc, .yes
.no
	ld a, 1
	jr .done

.yes
	xor a

.done
	ld [hScriptVar], a
	ret

TryCutOW::
	ld d, CUT
	call CheckPartyMove
	jr c, .cant_cut

	CheckEngine ENGINE_NATUREBADGE
	jr z, .cant_cut

	ld a, BANK(AskCutScript)
	ld hl, AskCutScript
	call CallScript
	scf
	ret

.cant_cut
	ld a, BANK(CantCutScript)
	ld hl, CantCutScript
	call CallScript
	scf
	ret

AskCutScript:
	opentext
	writetext UnknownText_0xd1c8
	yesorno
	iffalse .script_d1b8
	callasm .CheckMap
	iftrue Script_Cut
.script_d1b8
	closetext
	end

.CheckMap
	xor a
	ld [hScriptVar], a
	call CheckMapForSomethingToCut
	ret c
	ld a, TRUE
	ld [hScriptVar], a
	ret

UnknownText_0xd1c8:
	text_jump UnknownText_0x1c09dd

CantCutScript:
	jumptext UnknownText_0xd1d0

UnknownText_0xd1d0:
	text_jump UnknownText_0x1c0a05

ClearFieldMoveBuffer:
	xor a
	ld hl, wFieldMoveBufferSpace
	ld bc, wFieldMoveBufferSpaceEnd - wFieldMoveBufferSpace
	jp ByteFill

FieldMoveJumptable:
	ld a, [wFieldMoveJumptableIndex]
	call OldJumpTable
	ld [wFieldMoveJumptableIndex], a
	bit 7, a
	jr nz, .okay
	and a
	ret

.okay
	and $7f
	scf
	ret

GetPartyNick:
; write wCurPartyMon nickname to wStringBuffer1-3
	ld hl, wPartyMonNicknames
	ld a, BOXMON
	ld [wMonType], a
	ld a, [wCurPartyMon]
	call GetNick
	call CopyName1
; copy text from wStringBuffer2 to wStringBuffer3
	ld de, wStringBuffer2
	ld hl, wStringBuffer3
	jp CopyName2

CantSurfSaxifrageText::
	text_jump _CantSurfSaxifrageText

PrintNoBadgeText:
; Check engine flag a (ENGINE_ZEPHYRBADGE thru ENGINE_EARTHBADGE)
; Display "Badge required" text and return carry if the badge is not owned
	ld hl, .BadgeRequiredText
	jp MenuTextBoxBackup ; push text to queue

.BadgeRequiredText
	; Sorry! A new BADGE
	; is required.
	text_jump _BadgeRequiredText

CheckPartyMove:
; Check if a monster in your party has move d.

	ld e, 0
	xor a
	ld [wCurPartyMon], a
.loop
	ld c, e
	ld b, 0
	ld hl, wPartySpecies
	add hl, bc
	ld a, [hl]
	and a
	jr z, .no
	cp a, -1
	jr z, .no
	cp a, EGG
	jr z, .next

	ld bc, PARTYMON_STRUCT_LENGTH
	ld hl, PartyMon1Moves
	ld a, e
	rst AddNTimes
	ld b, NUM_MOVES
.check
	ld a, [hli]
	cp d
	jr z, .yes
	dec b
	jr nz, .check

.next
	inc e
	jr .loop

.yes
	ld a, e
	ld [wCurPartyMon], a ; which mon has the move
	xor a
	ret

.no
	scf
	ret
