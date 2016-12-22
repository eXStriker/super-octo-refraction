OverworldLoop::
	xor a
	ld [MapStatus], a
.loop
	call .OverworldLoop
	jr nc, .loop
	ret

.OverworldLoop
	ld a, [MapStatus]
	and a
	jr z, StartMap
	dec a
	jr z, EnterMap
	dec a
	jr z, HandleMap
	scf
	ret

DisableEvents:
	xor a
	ld [ScriptFlags3], a
	ret

EnableEvents::
	ld a, $ff
	ld [ScriptFlags3], a
	ret

EnableWildEncounters:
	ld hl, ScriptFlags3
	set 4, [hl]
	ret

StartMap:
	xor a
	ld [hScriptVar], a
	ld [ScriptRunning], a
	ld hl, MapStatus
	ld bc, wMapStatusEnd - MapStatus
	call ByteFill
	call ClearJoypad
EnterMap:
	call SetUpFiveStepWildEncounterCooldown
	callba RunMapSetupScript
	call DisableEvents

	ld a, [hMapEntryMethod]
	cp MAPSETUP_CONNECTION
	jr nz, .dont_enable
	call EnableEvents
.dont_enable

	ld a, [hMapEntryMethod]
	cp MAPSETUP_RELOADMAP
	jr nz, .dontresetpoison
	xor a
	ld [PoisonStepCount], a
.dontresetpoison

	xor a ; end map entry
	ld [hMapEntryMethod], a
	ld a, 2 ; HandleMap
	ld [MapStatus], a
	and a
	ret

HandleMap:
	call ResetOverworldDelay
	call HandleMapTimeAndJoypad
	call HandleCmdQueue
	call MapEvents

; Not immediately entering a connected map will cause problems.
	ld a, [MapStatus]
	cp 2 ; HandleMap
	jr nz, .done
	call DoBackgroundEvents
	call DoBackgroundEvents
.done
	and a
	ret

DoBackgroundEvents:
	call HandleOverworldObjects
	call NextOverworldFrame
	call HandleMapBackgroundEvents
	jp EnableEventsIfPlayerNotMoving

MapEvents:
	ld a, [MapEventStatus]
	and a
	ret nz
	call PlayerEvents
	call DisableEvents
	jpba ScriptEvents

ResetOverworldDelay:
	ld hl, wOverworldDelay
	bit 7, [hl]
	res 7, [hl]
	ret nz
	ld [hl], 2
	ret

NextOverworldFrame:
	ld a, [wOverworldDelay]
	and a
	jp nz, DelayFrame
; reset overworld delay to leak into the next frame
	ld a, $82
	ld [wOverworldDelay], a
	ret

HandleMapTimeAndJoypad:
	ld a, [MapEventStatus]
	dec a ; no events
	ret z

	call UpdateTime
	call GetJoypad
	jp TimeOfDayPals

HandleOverworldObjects:
	callba HandleNPCStep ; engine/map_objects.asm
	callba _HandlePlayerStep
	jp _CheckObjectEnteringVisibleRange

HandleMapBackgroundEvents:
	callba _UpdateSprites
	callba RunLandmarkSignAnim
	jpba ScrollScreen

EnableEventsIfPlayerNotMoving:
	ld a, [wPlayerStepFlags]
	bit 5, a ; in the middle of step
	jr z, .events
	bit 6, a ; stopping step
	jr z, .noevents
	bit 4, a ; in midair
	jr nz, .noevents
	call EnableEvents
.events
	xor a ; events
	ld [MapEventStatus], a
	ret

.noevents
	ld a, 1 ; no events
	ld [MapEventStatus], a
	ret

_CheckObjectEnteringVisibleRange:
	ld hl, wPlayerStepFlags
	bit 6, [hl]
	ret z
	jpba CheckObjectEnteringVisibleRange

PlayerEvents:
; If there's already a player event, don't interrupt it.
	ld a, [ScriptRunning]
	and a
	ret nz

	call CheckTrainerBattle3
	jr c, .ok

	call CheckTileEvent
	jr c, .ok

	call DoMapTrigger
	jr c, .ok

	call CheckTimeEvents
	jr c, .ok

	call OWPlayerInput
	jr c, .ok

	xor a
	ret

.ok
	push af
	callba EnableScriptMode
	pop af

	ld [ScriptRunning], a
	call DoPlayerEvent
	ld a, [ScriptRunning]
	cp PLAYEREVENT_CONNECTION
	jr z, .ok2
	cp PLAYEREVENT_JOYCHANGEFACING
	call nz, CancelMapSign
.ok2
	scf
	ret

CheckTrainerBattle3:
	call CheckTrainerBattle
	jr nc, .nope

	ld a, PLAYEREVENT_SEENBYTRAINER
	scf
	ret

.nope
	xor a
	ret

CheckTileEvent:
; Check for warps, tile triggers or wild battles.

	ld hl, ScriptFlags3
	bit 2, [hl]
	jr z, .connections_disabled

	callba CheckMovingOffEdgeOfMap
	jr c, .map_connection

	call CheckWarpTile
	jr c, .warp_tile

.connections_disabled
	ld hl, ScriptFlags3
	bit 1, [hl]
	jr z, .coord_events_disabled

	call CheckCurrentMapXYTriggers
	jr c, .coord_event

.coord_events_disabled
	ld hl, ScriptFlags3
	bit 0, [hl]
	jr z, .step_count_disabled

	call CountStep
	ret c

.step_count_disabled
	ld hl, ScriptFlags3
	bit 4, [hl]
	jr z, .ok

	call RandomEncounter
	ret c

.ok
	xor a
	ret

.map_connection
	ld a, PLAYEREVENT_CONNECTION
	scf
	ret

.warp_tile
	ld a, [PlayerStandingTile]
	call CheckPitTile
	jr nz, .not_pit
	ld a, PLAYEREVENT_FALL
	scf
	ret

.not_pit
	ld a, PLAYEREVENT_WARP
	scf
	ret

.coord_event
	ld hl, wCurCoordEventScriptAddr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [MapScriptHeaderBank]
	jp CallScript

CheckWildEncounterCooldown::
	ld hl, wWildEncounterCooldown
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret z
	scf
	ret

SetUpFiveStepWildEncounterCooldown:
	ld a, 5
	ld [wWildEncounterCooldown], a
	ret

SetMinTwoStepWildEncounterCooldown:
	ld a, [wWildEncounterCooldown]
	cp 2
	ret nc
	ld a, 2
	ld [wWildEncounterCooldown], a
	ret

DoMapTrigger:
	ld a, [wCurrMapTriggerCount]
	and a
	jr z, .nope

	ld c, a
	call CheckTriggers
	cp c
	jr nc, .nope

	ld e, a
	ld d, 0
	ld hl, wCurrMapTriggerHeaderPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	add hl, de
	add hl, de
	add hl, de

	ld a, [MapScriptHeaderBank]
	call GetFarHalfword
	ld a, [MapScriptHeaderBank]
	call CallScript

	ld hl, ScriptFlags
	res 3, [hl]

	callba EnableScriptMode
	callba ScriptEvents

	ld hl, ScriptFlags
	bit 3, [hl]
	jr z, .nope

	ld hl, wPriorityScriptAddr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wPriorityScriptBank]
	call CallScript
	scf
	ret

.nope
	xor a
	ret

CheckTimeEvents:
	ld a, [wLinkMode]
	and a
	jr nz, .nothing

	ld hl, wTimeEventCallback
	ld a, [hli]
	and a
	jr z, .do_daily
	ld l, [hl]
	ld h, a
	ld a, [wTimeEventCallbackBank]
	call FarCall_hl
	ret c

.do_daily
	callba CheckDailyResetTimer
	callba CheckPokerusTick
	ret c

.nothing
	xor a
	ret

OWPlayerInput:
	call PlayerMovement
	ret c
	and a
	jr nz, .NoAction

; Can't perform button actions while sliding on ice.
	callba CheckStandingOnIce
	jr c, .NoAction

	call CheckAPressOW
	jr c, .Action

	call CheckMenuOW
	jr c, .Action

.NoAction
	xor a
	ret

.Action
	push af

	ld hl, wPlayerNextMovement
	ld a, movement_step_sleep_1
	cp [hl]
	jr z, .skip

	ld [hl], a
	xor a
	ld [wPlayerMovementDirection], a
.skip
	pop af
	scf
	ret

CheckAPressOW:
	ld a, [hJoyPressed]
	and A_BUTTON
	ret z
	call TryObjectEvent
	ret c
	call TryReadSign
	ret c
	call CheckFacingTileEvent
	ret c
	xor a
	ret

PlayTalkObject:
	push de
	ld de, SFX_READ_TEXT_2
	call PlaySFX
	pop de
	ret

TryObjectEvent:
	callba CheckFacingObject
	ret nc
	call PlayTalkObject
	ld a, [hObjectStructIndexBuffer]
	call GetObjectStruct
	ld hl, OBJECT_MAP_OBJECT_INDEX
	add hl, bc
	ld a, [hl]
	ld [hLastTalked], a

	ld a, [hLastTalked]
	call GetMapObject
	ld hl, MAPOBJECT_COLOR
	add hl, bc
	ld a, [hl]
	and %00001111

	cp (.pointers_end - .pointers) / 2
	ret nc
	jumptable

.pointers
	dw .script ; PERSONTYPE_SCRIPT
	dw .itemball ; PERSONTYPE_ITEMBALL
	dw .trainer ; PERSONTYPE_TRAINER
	dw .tmhm ; PERSONTYPE_TMHMBALL
.pointers_end

.script
	; call CheckTellPlayerOff
	; jr c, .tell_player_off
	ld hl, MAPOBJECT_SCRIPT_POINTER
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [MapScriptHeaderBank]
	jp CallScript

.itemball
	ld hl, MAPOBJECT_SCRIPT_POINTER
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [MapScriptHeaderBank]
	ld de, wCurItemBallContents
	ld bc, 2
	call FarCopyBytes
	ld a, PLAYEREVENT_ITEMBALL
	scf
	ret

.trainer
	; call CheckTellPlayerOff
	; jr c, .tell_player_off
	call TalkToTrainer
	ld a, PLAYEREVENT_TALKTOTRAINER
	scf
	ret

.tmhm
	ld hl, MAPOBJECT_PARAMETER
	add hl, bc
	ld a, [hl]
	ld [wCurItemBallContents], a
	ld a, PLAYEREVENT_GETTMHM
	scf
	ret

; .tell_player_off
	; call Random
	; and $7
	; ld e, a
	; ld d, 0
	; ld hl, .TellPlayerOffTexts
	; add hl, de
	; add hl, de
	; ld a, [hli]
	; ld d, [hl]
	; ld e, a
	; ld a, BANK(.TellPlayerOffTexts)
	; ld hl, wScriptTextBank
	; ld [hli], a
	; ld [hl], e
	; inc hl
	; ld [hl], d
	; ld a, BANK(JumpTextFacePlayerScript)
	; ld hl, JumpTextFacePlayerScript
	; jp CallScript

; .TellPlayerOffTexts:
	; dw .dummy
	; dw .dummy
	; dw .dummy
	; dw .dummy
	; dw .dummy
	; dw .dummy
	; dw .dummy
	; dw .dummy

; .dummy
	; text "Bugger off."
	; done

; CheckTellPlayerOff:
	; ld a, [bc]
	; push bc
	; call GetObjectStruct
	; ld hl, OBJECT_TELL_OFF_FLAG
	; add hl, bc
	; pop bc
	; ld a, [hli]
	; and a
	; jr nz, .tell_off
	; ld a, [hl]
	; cp 5
	; jr nc, .sample_tell_off
	; inc [hl]
	; and a
	; ret

; .sample_tell_off
	; call Random
	; and $3
	; ret nz
	; dec hl
	; ld [hl], 1
; .tell_off
	; scf
	; ret

TryReadSign:
	call CheckFacingSign
	jr c, .IsSign
	xor a
	ret

.IsSign
	ld a, [wCurSignpostType]
	jumptable

.signs
	dw .read
	dw .up
	dw .down
	dw .right
	dw .left
	dw .ifset
	dw .ifnotset
	dw .itemifset
	dw .loadsignpost

.up
	ld b, OW_UP
	jr .checkdir

.down
	ld b, OW_DOWN
	jr .checkdir

.right
	ld b, OW_RIGHT
	jr .checkdir

.left
	ld b, OW_LEFT
.checkdir
	ld a, [PlayerDirection]
	and %1100
	cp b
	jr nz, .dontread

.read
	call PlayTalkObject
	ld hl, wCurSignpostScriptAddr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [MapScriptHeaderBank]
	jr .callScriptAndReturnCarry

.loadsignpost
	call PlayTalkObject
	ld hl, wLoadSignpostScriptBuffer + 2
	ld a, [wCurSignpostScriptAddr + 1]
	ld [hld], a
	ld a, [wCurSignpostScriptAddr]
	ld [hld], a
	ld [hl], loadsignpost_command
	ld a, [MapScriptHeaderBank]
	jr .callScriptAndReturnCarry
	
.itemifset
	call CheckSignFlag
	jp nz, .dontread
	call PlayTalkObject
	ld a, [MapScriptHeaderBank]
	ld de, wCurSignpostItemFlag
	ld bc, 3
	call FarCopyBytes
	ld a, BANK(HiddenItemScript)
	ld hl, HiddenItemScript
	jr .callScriptAndReturnCarry

.dontread
	xor a
	ret

.ifset
	call CheckSignFlag
	jr z, .dontread
	jr .thenread

.ifnotset
	call CheckSignFlag
	jr nz, .dontread

.thenread
	push hl
	call PlayTalkObject
	pop hl
	inc hl
	inc hl
	ld a, [MapScriptHeaderBank]
	push af
	call GetFarHalfword
	pop af
.callScriptAndReturnCarry
	call CallScript
	scf
	ret

CheckSignFlag:
	ld hl, wCurSignpostScriptAddr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld a, [MapScriptHeaderBank]
	call GetFarHalfword
	ld e, l
	ld d, h
	ld b, CHECK_FLAG
	predef EventFlagAction
	ld a, c
	and a
	pop hl
	ret

PlayerMovement:
	callba DoPlayerMovement
	ld a, c
	jumptable

	dw .zero
	dw .one
	dw .two
	dw .three
	dw .four
	dw .five
	dw .six
	dw .seven

.zero
.four
.seven
	xor a
	ret

.one
	ld a, PLAYEREVENT_WARP
	scf
	ret

.two
	ld a, PLAYEREVENT_JOYCHANGEFACING
	scf
	ret

.three
; force the player to move in some direction
	ld a, BANK(Script_ForcedMovement)
	ld hl, Script_ForcedMovement
	call CallScript
	ld a, PLAYEREVENT_MAPSCRIPT
	scf
	ret

.five
.six
	ld a, PLAYEREVENT_MAPSCRIPT
	and a
	ret

CheckMenuOW:
	xor a
	ld [hMenuReturn], a
	ld [hMenuReturn + 1], a

	debug_mode_flag
	jr c, .debug_mode
	CheckEngine ENGINE_WILDS_DISABLED
	jr nz, .NoMenu
.debug_mode
	ld a, [hJoyPressed]

	bit SELECT_F, a
	jr nz, .Select

	bit START_F, a
	jr z, .NoMenu

	ld a, BANK(StartMenuScript)
	ld hl, StartMenuScript
	call CallScript
	scf
	ret
.IncrementCounter
	ld hl, wSelectButtonCounter
	bit 7, [hl]
	jr nz, .NoMenu
	inc hl
	inc hl
	inc [hl]
	jr nz, .NoMenu
	dec hl
	inc [hl]
	jr nz, .NoMenu
	dec hl
	inc [hl]
.NoMenu
	xor a
	ret

.Select
	CheckEngine ENGINE_POKEMON_MODE
	jr nz, .NoMenu
	callba CheckRegisteredItem
	jr c, .IncrementCounter
	call PlayTalkObject
	ld a, BANK(SelectMenuScript)
	ld hl, SelectMenuScript
	call CallScript
	scf
	ret

StartMenuScript:
	callasm StartMenu
	jump StartMenuCallback

SelectMenuScript:
	callasm SelectMenu
StartMenuCallback:
	copybytetovar hMenuReturn
	if_equal HMENURETURN_SCRIPT, .Script
	if_equal HMENURETURN_ASM, .Asm
	end

.Script
	ptjump wQueuedScriptBank

.Asm
	ptcallasm wQueuedScriptBank
	end

CountStep:
	; Global counter is always updated
	ld hl, wGlobalStepCounter
	inc [hl]
	jr nz, .done_global_counter
	rept 3
		inc hl
		inc [hl]
		jr nz, .done_global_counter
	endr
	ld a, -1
	rept 4
		ld [hld], a
	endr
.done_global_counter

	; Don't count steps in link communication rooms.
	ld a, [wLinkMode]
	and a
	jr nz, .done

	call CollectSoot
	; If Repel wore off, don't count the step.
	call DoRepelStep
	jr c, .doscript

	; Count the step for poison and total steps
	ld hl, PoisonStepCount
	inc [hl]
	ld hl, StepCount
	inc [hl]
	; Every 256 steps, increase the happiness of all your Pokemon.
	jr nz, .skip_happiness

	callba StepHappiness

.skip_happiness
	; Every 256 steps, offset from the happiness incrementor by 128 steps,
	; decrease the hatch counter of all your eggs until you reach the first
	; one that is ready to hatch.
	ld a, [StepCount]
	cp $80
	jr nz, .skip_egg

	callba DoEggStep
	jr nz, .hatch

.skip_egg
	; Increase the EXP of (both) DayCare Pokemon by 1.
	callba DaycareStep

	; Every four steps, deal damage to all Poisoned Pokemon
	ld hl, PoisonStepCount
	ld a, [hl]
	cp 4
	jr c, .done
	ld [hl], 0

	callba DoPoisonStep
	jr c, .doscript
.done
	xor a
	ret

.doscript
	ld a, PLAYEREVENT_MAPSCRIPT
	scf
	ret

.hatch
	ld a, PLAYEREVENT_HATCH
	scf
	ret

CollectSoot:
	ld a, [MapGroup]
	cp GROUP_MAGMA_F1
	ret nz
	ld a, SOOT_SACK
	ld [wCurItem], a
	ld hl, NumItems
	call CheckItem
	ret nc
	
	xor a
	ld [hMoneyTemp], a
	inc a
	ld [hMoneyTemp + 1], a
	ld bc, hMoneyTemp
	jpba GiveAsh

DoRepelStep:
	callba CheckStandingOnIce
	jr c, .nope

	ld hl, wRepelEffect
	ld a, [hli]
	or [hl]
	ret z

	ld a, [hld]
	ld c, [hl]
	ld b, a
	dec bc
	ld a, c
	ld [hli], a
	ld [hl], b
	or b
	ret nz

	ld a, BANK(RepelWoreOffScript)
	ld hl, RepelWoreOffScript
	call CallScript
	scf
	ret

.nope
	and a
	ret

DoPlayerEvent:
	ld a, [ScriptRunning]
	and a
	ret z

	cp PLAYEREVENT_MAPSCRIPT ; run script
	ret z

	cp NUM_PLAYER_EVENTS
	ret nc

	ld c, a
	ld b, 0
	ld hl, PlayerEventScriptPointers
	add hl, bc
	add hl, bc
	add hl, bc

	ld a, [hli]
	ld [ScriptBank], a
	ld a, [hli]
	ld [ScriptPos], a
	ld a, [hl]
	ld [ScriptPos + 1], a
	ret

PlayerEventScriptPointers:
	dba Invalid_0x96c2d          ; 0
	dba SeenByTrainerScript      ; 1
	dba TalkToTrainerScript      ; 2
	dba FindItemInBallScript     ; 3
	dba EdgeWarpScript           ; 4
	dba WarpToNewMapScript       ; 5
	dba FallIntoMapScript        ; 6
	dba Script_OverworldWhiteout ; 7
	dba HatchEggScript           ; 8
	dba ChangeDirectionScript    ; 9
	dba FindTMorHMScript         ; 10

HatchEggScript:
	callasm OverworldHatchEgg
Invalid_0x96c2d:
	end

WarpToNewMapScript:
	warpsound
	newloadmap MAPSETUP_DOOR
	end

FallIntoMapScript:
	newloadmap MAPSETUP_FALL
	playsound SFX_KINESIS
	applymovement PLAYER, MovementData_0x96c48
	playsound SFX_STRENGTH
	earthquake 16
	end

MovementData_0x96c48:
	skyfall
	step_end

EdgeWarpScript: ; 4
	reloadandreturn MAPSETUP_CONNECTION

ChangeDirectionScript: ; 9
	callasm ReleaseAllMapObjects
	callasm EnableWildEncounters
	end

INCLUDE "engine/scripting.asm"

; More overworld event handling.

ClearSafariZoneFlag::
	ResetEngine ENGINE_SAFARI_ZONE
	ret

CheckFacingTileEvent::
	call GetFacingTileCoord
	ld [wTempFacingTile], a
	ld c, a
	call CheckFacingTileForStd
	jr c, .skip_sfx

	ld a, [wTempFacingTile]
	call CheckCutTreeTile
	jr nz, .waterfall
	callba TryCutOW
	jr .done

.waterfall
	ld a, [wTempFacingTile]
	call CheckWaterfallTile
	jr nz, .headbutt
	callba TryWaterfallOW
	jr .done

.headbutt
	ld a, [wTempFacingTile]
	call CheckHeadbuttTreeTile
	jr nz, .surf
	callba TryHeadbuttOW
	jr c, .done
	jr .noevent

.surf
	callba TrySurfOW
	jr nc, .noevent
	jr .done

.noevent
	xor a
	ret

.done
	call PlayClickSFX
.skip_sfx
	ld a, $ff
	scf
	ret

RandomEncounter::
; Random encounter

	call CheckWildEncounterCooldown
	jr c, .nope
	call CanUseSweetScent
	jr nc, .nope
	ld hl, wStatusFlags2
	callba TryWildEncounter
	jr nz, .nope
	jr .ok

.nope
	ld a, 1
	and a
	ret

.ok
	ld a, BANK(WildBattleScript)
	ld hl, WildBattleScript
	call CallScript
	scf
	ret

WildBattleScript:
	randomwildmon
	startbattle
	reloadmapafterbattle
	end

CanUseSweetScent::
	CheckEngine ENGINE_WILDS_DISABLED
	jr nz, .no

	ld a, [wPermission]
	cp CAVE
	jr z, .ice_check
	cp DUNGEON
	jr z, .ice_check
	callba CheckGrassCollision
	jr nc, .no

.ice_check
	ld a, [PlayerStandingTile]
	call CheckIceTile
	jr z, .no
	scf
	ret

.no
	and a
	ret

ClearCmdQueue::
	ld hl, wCmdQueue
	ld de, 6
	ld c, 4
	xor a
.loop
	ld [hl], a
	add hl, de
	dec c
	jr nz, .loop
	ret

HandleCmdQueue::
	ld hl, wCmdQueue
	xor a
.loop
	ld [hMapObjectIndexBuffer], a
	ld a, [hl]
	and a
	jr z, .skip
	push hl
	ld b, h
	ld c, l
	call HandleQueuedCommand
	pop hl

.skip
	ld de, CMDQUEUE_ENTRY_SIZE
	add hl, de
	ld a, [hMapObjectIndexBuffer]
	inc a
	cp CMDQUEUE_CAPACITY
	jr nz, .loop
	ret

WriteCmdQueue::
	push bc
	push de
	call .GetNextEmptyEntry
	ld d, h
	ld e, l
	pop hl
	pop bc
	ret c
	ld a, b
	ld bc, CMDQUEUE_ENTRY_SIZE - 1
	call FarCopyBytes
	xor a
	ld [hl], a
	ret

.GetNextEmptyEntry
	ld hl, wCmdQueue
	ld de, CMDQUEUE_ENTRY_SIZE
	ld c, CMDQUEUE_CAPACITY
.loop
	ld a, [hl]
	and a
	jr z, .done
	add hl, de
	dec c
	jr nz, .loop
	scf
	ret

.done
	ld a, CMDQUEUE_CAPACITY
	sub c
	and a
	ret

DelCmdQueue::
	ld hl, wCmdQueue
	ld de, CMDQUEUE_ENTRY_SIZE
	ld c, CMDQUEUE_CAPACITY
.loop
	ld a, [hl]
	cp b
	jr z, .done
	add hl, de
	dec c
	jr nz, .loop
	and a
	ret

.done
	xor a
	ld [hl], a
	scf
	ret

HandleQueuedCommand:
	ld de, PlayerStruct
	ld a, NUM_OBJECT_STRUCTS
.loop
	push af

	ld hl, OBJECT_SPRITE
	add hl, de
	ld a, [hl]
	and a
	jr z, .next

	ld hl, OBJECT_MOVEMENTTYPE
	add hl, de
	ld a, [hl]
	cp STEP_TYPE_SKYFALL_TOP
	jr nz, .next

	ld hl, OBJECT_NEXT_TILE
	add hl, de
	ld a, [hl]
	call CheckPitTile
	jr nz, .next

	ld hl, OBJECT_DIRECTION_WALKING
	add hl, de
	ld a, [hl]
	cp STANDING
	jr nz, .next
	call HandleStoneQueue
	jr c, .fall_down_hole

.next
	ld hl, OBJECT_STRUCT_LENGTH
	add hl, de
	ld d, h
	ld e, l

	pop af
	dec a
	jr nz, .loop
	ret

.fall_down_hole
	pop af
	ret

CheckFacingTileForStd::
; Checks to see if the tile you're facing has a std script associated with it.  If so, executes the script and returns carry.
	ld a, c
	ld e, 2
	ld hl, .table1
	call IsInArray
	jr nc, .notintable

	ld a, jumpstd_command
	ld [wJumpStdScriptBuffer], a
	inc hl
	ld a, [hli]
	ld [wJumpStdScriptBuffer + 1], a
	cp jumpingshoes
	jr z, .skip_sfx
	cp mining
	jr z, .skip_sfx
	cp pcscript
	jr nz, .play_sfx
	ld a, [PlayerDirection]
	cp OW_UP
	jr nz, .notintable
.play_sfx
	call PlayClickSFX
.skip_sfx
	ld a, BANK(Script_JumpStdFromRAM)
	ld hl, Script_JumpStdFromRAM
	call CallScript
	scf
	ret

.notintable
	xor a
	ret

.table1
	db $91, magazinebookshelf
	db $93, pcscript
	db $94, smelting
	db $95, townmap
	db $96, merchandiseshelf
	db $97, jumpingshoes
	db $9d, mining
	db $9f, fastcurrent
	db   -1 ; end

Script_JumpStdFromRAM:
	jump wJumpStdScriptBuffer
