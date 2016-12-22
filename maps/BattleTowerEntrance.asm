BattleTowerEntrance_MapScriptHeader:
; triggers
	db 5
	maptrigger .Null
	maptrigger .Resume
	maptrigger .Abort
	maptrigger .Reward
	maptrigger .Finished

; callbacks
	db 0

.Null:
	end

.Abort:
	priorityjump ._Abort
	end

.Resume:
	priorityjump ._Resume
	end

.Reward:
	priorityjump ._Reward
	end

.Finished:
	priorityjump BattleTower_AbortedOrFinishedBattleTower
	end

._Abort:
	spriteface PLAYER, UP
	opentext
	writetext ChallengeInterruptedText
	jump BattleTower_AbortedOrFinishedBattleTower

._Resume:
	spriteface PLAYER, UP
	opentext
	writetext BattleTowerSaveResumeText
	callasm BattleTower_LoadChallengeData
	dotrigger 2
	writebyte 1
	callasm SetBattleTowerChallengeState
	callasm SaveGameData
	playwaitsfx SFX_SAVE
	jump BattleTowerReceptionistScript_GoToBattleRoom

._Reward:
	spriteface PLAYER, UP
	opentext
	callasm BattleTower_CheckDefeatedBrain
	sif false, then
		writetext BattleTowerClearedStreakText
		playwaitsfx SFX_2ND_PLACE
		givebattlepoints 3
	selse
		callasm BattleTower_IncrementTycoonWinCounter
		writetext BattleTowerAmazingFeatText
		playwaitsfx SFX_1ST_PLACE
		givebattlepoints 20
	sendif

; fallthrough

BattleTower_AbortedOrFinishedBattleTower:
	opentext
	callasm RestorePartyAfterBattleTower
	domaptrigger BATTLE_TOWER_BATTLE_ROOM, 0
	dotrigger 0
	writebyte 0
	callasm SetBattleTowerChallengeState
	callasm SaveGameData
	playwaitsfx SFX_SAVE
	jump BattleTowerReceptionistScript_cancel

BattleTower_IncrementTycoonWinCounter:
	ld hl, wTowerTycoonsDefeated
	inc [hl]
	ret nz
	inc hl
	inc [hl]
	ret nz
	ld a, $ff
	ld [hld], a
	ld [hl], a
	ret

GetBattleTowerChallengeState:
	ld a, BANK(sBattleTowerChallengeState)
	call GetSRAMBank
	ld a, [sBattleTowerChallengeState]
	ld [hScriptVar], a
	jp CloseSRAM

SetBattleTowerChallengeState:
	ld a, BANK(sBattleTowerChallengeState)
	call GetSRAMBank
	ld a, [hScriptVar]
	ld [sBattleTowerChallengeState], a
	jp CloseSRAM

BattleTowerScript_Receptionist:
	faceplayer
	opentext
	writetext BattleTowerWelcomeText
	checkevent EVENT_BATTLE_TOWER_INTRO
	iftrue .skip_intro
	setevent EVENT_BATTLE_TOWER_INTRO
.play_intro
	writetext BattleTowerIntroText
.skip_intro
	writetext BattleTowerAskStartChallengeText
	loadmenudata MenuDataHeader_BattleTowerChallenge
	verticalmenu
	closewindow
	anonjumptable
	dw BattleTowerReceptionistScript_cancel
	dw .Continue
	dw .play_intro
IF DEF(DEBUG_MODE)
	dw .DEBUG
ELSE
	dw BattleTowerReceptionistScript_cancel
ENDC

.DEBUG
	callasm BattleTower_InitChallenge
	callasm BattleTower_DebugTeam
	jump .ask_save

.Continue:
	; Do you have at least 3 Pokemon?
	checkcode VAR_PARTYCOUNT
	if_less_than 3, BattleTowerReceptionistScript_not_enough_pokemon
	; Do you have at least 3 Pokemon that are legal?
	callasm BattleTower_InitChallenge
	writetext BattleTower_ChooseRoomStrengthText
	; Choose either level 50 or open level
	loadmenudata MenuDataHeader_LevelSet
	verticalmenu
	closewindow
	iffalse BattleTowerReceptionistScript_cancel
	if_equal 3, BattleTowerReceptionistScript_cancel
	; Do you have enough Pokemon that can participate?
	callasm BattleTower_SetLevelGroup
	callasm CheckAtLeastThreeLegalPokemon
	if_less_than 3, BattleTowerReceptionistScript_not_enough_pokemon_level
	; Party menu select
	writetext BattleTowerSelectThreePokemonText
	waitbutton
	callasm BattleTower_LegalityCheck
	callasm ChooseThreePartyMonsForBattle
	iffalse BattleTowerReceptionistScript_cancel
	writetext BattleTowerSaveBeforeText
	yesorno
	iffalse BattleTowerReceptionistScript_cancel
	callasm BattleTower_SaveGame
	sif false, then
		dotrigger 0
		jump BattleTowerReceptionistScript_cancel
	sendif
	callasm SetBattleTowerParty
.ask_save
	dotrigger 2
	callasm BattleTower_SaveChallengeData
	callasm PrintSavedGameText

BattleTowerReceptionistScript_GoToBattleRoom:
	domaptrigger BATTLE_TOWER_BATTLE_ROOM, 1
	domaptrigger BATTLE_TOWER_HALLWAY, 0
	domaptrigger BATTLE_TOWER_ELEVATOR, 0
	writetext BattleTowerFollowMeText
	waitbutton
	closetext
	follow $2, PLAYER
	applymovement $2, BattleTowerMovement_ReceptionistWalksUp
	stopfollow
	playsound SFX_ENTER_DOOR
	disappear $2
	applymovement PLAYER, BattleTowerMovement_PlayerStepsUp
	warpcheck
	end

BattleTowerReceptionistScript_not_enough_pokemon:
	writetext BattleTower_NotEnoughLegalPokemonText
	jump BattleTowerReceptionistScript_wait_cancel

BattleTowerReceptionistScript_not_enough_pokemon_level:
	writetext BattleTower_NotEnoughPokemonLevelText
BattleTowerReceptionistScript_wait_cancel:
	pause 30
BattleTowerReceptionistScript_cancel:
	writetext BattleTower_CancelText
	endtext

BattleTowerExchangeCorner:
	opentext
	pokemart 5, 0
	closetext
	end

MenuDataHeader_BattleTowerChallenge:
	db $40 ; flags
	db 00, 00 ; start coords
	db 09, 14 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2
	db $a0 ; flags
	db 3
	db "Challenge@"
	db "Explanation@"
IF DEF(DEBUG_MODE)
	db "DEBUG @" ;trailing space so there are no shifts between debug and release
ELSE
	db "Cancel@"
ENDC

MenuDataHeader_LevelSet:
	db $40 ; flags
	db 00, 00 ; start coords
	db 07, 14 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2
	db $a0 ; flags
	db 3
	db "Level 50@"
	db "Open Level@"
	db "Cancel@"

BattleTowerMovement_ReceptionistWalksUp:
	step_up
	step_up
	step_up
BattleTowerMovement_PlayerStepsUp:
	step_up
	step_end

BattleTowerEntrance_LassScript:
	jumptextfaceplayer BattleTowerEntrance_LassText

BattleTowerEntrance_CooltrainerMScript:
	jumptextfaceplayer BattleTowerEntrance_CooltrainerMText

BattleTowerEntrance_CooltrainerFScript:
	jumptextfaceplayer BattleTowerEntrance_CooltrainerFText

BattleTower_LegalityCheck:
	ld hl, wPartyCount
	ld a, [hli]
	ld c, a
	ld b, 0
.loop
	srl b
	ld a, [hli]
	push bc
	push hl
	ld b, a
	callba BattleTower_IsCurSpeciesLegal_Far
	pop hl
	pop bc
	jr c, .legal
	set 5, b
.legal
	dec c
	jr nz, .loop
	ld a, [wPartyCount]
	ld c, a
	ld a, 6
	sub c
	and a
	jr z, .ok
	
.bitShiftLoop
	srl b
	dec a
	jr nz, .bitShiftLoop
	
.ok
	ld a, b
	ld [wBattleTowerLegalPokemonFlags], a
	ret

BattleTowerWelcomeText:
	ctxt "Welcome to the"
	line "Battle Tower!"
	prompt

BattleTowerIntroText:
	ctxt "Here you can par-"
	line "ticipate in a"

	para "series of conse-"
	line "cutive battles."

	para "When you enter,"
	line "you will face 7"
	cont "Trainers in a row."

	para "Beat all of them"
	line "to continue your"
	cont "winning streak!"

	para "Lose, and your"
	line "streak is over."

	para "If you defeat"
	line "enough Trainers,"

	para "you may draw the"
	line "attention of our"
	cont "Chief!"
	prompt

BattleTowerAskStartChallengeText:
	ctxt "Would you like to"
	line "start a challenge?"
	done

BattleTowerSaveBeforeText:
	ctxt "Before you begin,"
	line "we must save the"
	cont "game. Is that OK?"
	done

BattleTowerSaveResumeText:
	ctxt "Welcome back!"

	para "Before we resume,"
	line "we must save the"
	cont "game."
	done

BattleTower_ChooseRoomStrengthText:
	ctxt "Which room do you"
	line "wish to challenge?"
	done

BattleTowerSelectThreePokemonText:
	ctxt "Please select 3"
	line "#mon."
	done

BattleTowerFollowMeText:
	ctxt "Please follow me."
	done

BattleTower_NotEnoughLegalPokemonText:
	ctxt "I'm sorry."

	para "You need at least"
	line "3 #mon in"

	para "order to par-"
	line "ticipate."

	para "Eggs and Legendary"
	line "#mon are not"
	cont "permitted."
	done

BattleTower_NotEnoughPokemonLevelText:
	ctxt "I'm sorry."

	para "You do not have"
	line "enough #mon"

	para "which are at or"
	line "below the selected"
	cont "level."

	para "You need at least"
	line "3 #mon in"

	para "order to par-"
	line "ticipate."

	para "Eggs and Legendary"
	line "#mon are not"
	cont "permitted."
	done

ChallengeInterruptedText:
	ctxt "I'm sorry."

	para "You did not save"
	line "before ending your"
	cont "last challenge."

	para "Because of this,"
	line "your progress has"
	cont "been lost."

	para "We will now save"
	line "the game."
	done

BattleTower_CancelText:
	ctxt "We hope to see you"
	line "again!"
	done

BattleTowerClearedStreakText:
	ctxt "Congratulations!"

	para "For beating all"
	line "seven Trainers,"
	cont "you win BP!"

	para "<PLAYER> received"
	line "3 BP!"
	done

BattleTowerAmazingFeatText:
	ctxt "Congratulations!"

	para "For beating all"
	line "seven Trainers<...>"

	para "And for your"
	line "amazing fight with"
	cont "our Tycoon<...>"

	para "We hereby award"
	line "you these BP!"

	para "<PLAYER> received"
	line "20 BP!"
	done

BattleTowerEntrance_LassText:
	ctxt "Alright! Me and my"
	line "Azumarill are"

	para "gonna roll over"
	line "the competition!"

	para "With its cute"
	line "looks, we'll be"
	cont "unstoppable!"

	para "<...> <...> <...> Huh?"
	line "This isn't a"
	cont "Contest Hall?"
	done

BattleTowerEntrance_CooltrainerMText:
	ctxt "They finally put"
	line "a PC here."

	para "Before, you had to"
	line "go all the way"
	cont "back to Phacelia"

	para "just to change"
	line "teams around!"
	done

BattleTowerEntrance_CooltrainerFText:
	ctxt "There's a Battle"
	line "Tower in Olivine"
	cont "City, too."

	para "They don't allow"
	line "#mon stronger"
	cont "than level 40."

	para "What a joke! How"
	line "are you supposed"

	para "to win if you can't"
	line "use your strongest"
	cont "#mon?"
	done

BattleTowerEntrance_MapEventHeader:: db 0, 0

.Warps: db 3
	warp_def 7, 3, 3, ROUTE_71B
	warp_def 7, 4, 3, ROUTE_71B
	warp_def 0, 3, 1, BATTLE_TOWER_ELEVATOR

.CoordEvents: db 0

.BGEvents: db 0

.ObjectEvents: db 5
	person_event SPRITE_RECEPTIONIST, 4, 3, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, BattleTowerScript_Receptionist, -1
	person_event SPRITE_LASS, 5, 0, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 0, 1, -1, -1, PAL_OW_GREEN, 0, 0, BattleTowerEntrance_LassScript, -1
	person_event SPRITE_COOLTRAINER_M, 7, 1, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, BattleTowerEntrance_CooltrainerMScript, -1
	person_event SPRITE_COOLTRAINER_F, 6, 6, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_PURPLE, 0, 0, BattleTowerEntrance_CooltrainerFScript, -1
	person_event SPRITE_RECEPTIONIST, 3, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, BattleTowerExchangeCorner, -1
