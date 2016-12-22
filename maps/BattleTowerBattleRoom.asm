const_value SET 2
	const BATTLE_TOWER_BATTLE_ROOM_OPPONENT
	const BATTLE_TOWER_BATTLE_ROOM_RECEPTIONIST

BattleTowerBattleRoom_MapScriptHeader:
; triggers
	db 2
	maptrigger .Trigger0
	maptrigger .Trigger1

; callbacks
	db 1
	dbw MAPCALLBACK_NEWMAP, .Callback

.Trigger0:
	end

.Trigger1:
	priorityjump .Script
	end

.Callback:
	disappear BATTLE_TOWER_BATTLE_ROOM_OPPONENT
	return

.Script:
	dotrigger 0
	applymovement PLAYER, BattleTowerMovement_PlayerWalksUpToBattlePosition
	callasm BattleTower_LoadChallengeData
	iftrue .notFirstBattle
	; spriteface PLAYER, LEFT
	; applymovement BATTLE_TOWER_BATTLE_ROOM_RECEPTIONIST, BattleTowerMovement_NurseWalksToYou
	; opentext
	; jump .backToNextBattleMenu
.loop
	callasm BattleTower_LoadCurrentTeam
	playsound SFX_ENTER_DOOR
	appear BATTLE_TOWER_BATTLE_ROOM_OPPONENT
	applymovement BATTLE_TOWER_BATTLE_ROOM_OPPONENT, BattleTowerMovement_OpponentWalksIn
	opentext
	battletowertext 1
	waitbutton
	closetext
	domaptrigger BATTLE_TOWER_ENTRANCE, 1
	setlasttalked $3
	callasm StartBattleTowerBattle
	reloadmap
	iftrue .exit_failure
	applymovement BATTLE_TOWER_BATTLE_ROOM_OPPONENT, BattleTowerMovement_OpponentWalksOut
	playsound SFX_EXIT_BUILDING
	disappear BATTLE_TOWER_BATTLE_ROOM_OPPONENT
	callasm BattleTower_SaveChallengeData
	callasm BattleTower_CheckFought7Trainers
	iffalse .exit_victorious
	writebyte 0

.notFirstBattle
	spriteface PLAYER, LEFT
	applymovement BATTLE_TOWER_BATTLE_ROOM_RECEPTIONIST, BattleTowerMovement_NurseWalksToYou
	opentext
	iftrue .backToNextBattleMenu
	writetext BattleTowerText_HealParty
	special HealParty
	playwaitsfx SFX_HEAL_POKEMON
.backToNextBattleMenu
	writetext BattleTowerText_AskNextBattle
.loop_ask
	loadmenudata BattleTowerBeforeMatchMenuDataHeader
	verticalmenu
	closewindow
	anonjumptable
	dw .loop_ask
	dw .close_text
	dw .quicksave
	dw .close_text_exit_failure

.close_text
	closetext
	spriteface PLAYER, RIGHT
	applymovement BATTLE_TOWER_BATTLE_ROOM_RECEPTIONIST, BattleTowerMovement_NurseWalksAway
	jump .loop

.close_text_exit_failure
	writetext BattleTowerText_WouldYouLikeToRetireFromThisChallenge
	yesorno
	iffalse .backToNextBattleMenu
	closetext
.exit_failure
	domaptrigger BATTLE_TOWER_ENTRANCE, 4
	jump .return_to_entrance

.exit_victorious
	domaptrigger BATTLE_TOWER_ENTRANCE, 3
.return_to_entrance
	pause 20
	warpfacing UP, BATTLE_TOWER_ENTRANCE, 3, 5
	end

.quicksave
	writetext BattleTowerText_AskQuickSave
	yesorno
	iffalse .backToNextBattleMenu
	writetext BattleTower_SavingPleaseWaitText
	domaptrigger BATTLE_TOWER_ENTRANCE, 1
	writebyte 2
	scriptstartasm

.BattleTowerReset
	call SetBattleTowerChallengeState
	callba BattleTower_SaveChallengeData
	ld a, $3
	ld [wSpawnAfterChampion], a
	callba SaveGameData
	ld de, SFX_SAVE
	call PlaySFX
	ld c, 1
	call FadeToDarkestColor
	ld a, $1
	ld [hCGBPalUpdate], a
	call DelayFrame
	call WaitSFX
	jp Reset

BattleTowerBeforeMatchMenuDataHeader:
	db $40 ; flags
	db 00, 00 ; start coords
	db 07, 11 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2: ; 17d297
	db %10000001 ; flags
	db 3
	db "Continue@"
	db "Rest@"
	db "Retire@"

BattleTowerMovement_PlayerWalksUpToBattlePosition:
	step_up
	step_up
	step_up
	turn_head_right
	step_end

BattleTowerMovement_OpponentWalksIn:
	step_down
	step_down
	step_down
	step_down
	turn_head_left
	step_end

BattleTowerMovement_OpponentWalksOut:
	step_up
	step_up
	step_up
	step_up
	step_end

BattleTowerMovement_NurseWalksToYou:
	step_right
	step_end

BattleTowerMovement_NurseWalksAway:
	step_left
	turn_head_right
	step_end

BattleTowerText_HealParty:
	ctxt "We will now heal"
	line "your #mon."
	done

BattleTowerText_AskNextBattle:
	start_asm
	ld a, [rSVBK]
	push af
	ld a, BANK(wBT_WinStreak)
	ld [rSVBK], a
	ld a, [wBT_WinStreak]
	ld h, a
	pop af
	ld [rSVBK], a
	ld a, h
	ld hl, .NormalOpponent
	cp 20
	jr z, .Tycoon
	cp 48
	ret nz
.Tycoon
	ld hl, .TycoonText
	ret

.NormalOpponent:
	ctxt "Opponent no. @"
	start_asm
	ld a, [rSVBK]
	push af
	ld a, BANK(wBT_CurStreak)
	ld [rSVBK], a
	ld a, [wBT_CurStreak]
	add "1"
	ld [bc], a
	pop af
	ld [rSVBK], a
	call JoyTextDelay
	ld hl, .continue_text
	ret

.continue_text
	ctxt ""
	line "is up next."

	para "Are you ready?"
	done

.TycoonText:
	ctxt "Congratulations on"
	line "winning thus far!"

	para "I've just been in-"
	line "formed that our"

	para "esteemed Tower"
	line "Tycoon seeks an"
	cont "audience with you."

	para "Are you ready to"
	line "accept their chal-"
	cont "lenge?"
	done

BattleTowerText_AskQuickSave:
	ctxt "Would you like to"
	line "save and rest?"
	done

BattleTowerText_WouldYouLikeToRetireFromThisChallenge:
	ctxt "Do you wish to"
	line "retire from this"
	cont "challenge?"
	done

BattleTower_SavingPleaseWaitText:
	ctxt "Saving..."
	done

BattleTowerBattleRoom_MapEventHeader:: db 0, 0

.Warps: db 2
	warp_def 7, 3, 2, BATTLE_TOWER_HALLWAY
	warp_def 7, 4, 2, BATTLE_TOWER_HALLWAY

.CoordEvents: db 0

.BGEvents: db 0

.ObjectEvents: db 2
	person_event SPRITE_YOUNGSTER, 0, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 0, 0, ObjectEvent, EVENT_BATTLE_TOWER_TRAINER
	person_event SPRITE_RECEPTIONIST, 4, 1, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, ObjectEvent, -1
