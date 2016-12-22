; Core components of the battle engine.
BattleCore:
DoBattle:
	xor a
	ld [wBattleParticipantsNotFainted], a
	ld [wBattleParticipantsIncludingFainted], a
	ld [wPlayerAction], a
	ld [BattleEnded], a
	inc a
	ld [wBattleHasJustStarted], a
	ld hl, OTPartyMon1HP
	ld bc, PARTYMON_STRUCT_LENGTH - 1
	ld d, BATTLEACTION_SWITCH1 - 1
.loop
	inc d
	ld a, [hli]
	or [hl]
	jr nz, .alive
	add hl, bc
	jr .loop

.alive
	ld a, d
	ld [wBattleAction], a
	ld a, [wLinkMode]
	and a
	jr z, .not_linked

	ld a, [hLinkPlayerNumber]
	cp $2
	jr z, .player_2

.not_linked
	ld a, [wBattleMode]
	dec a
	jr z, .wild
	xor a
	ld [wEnemySwitchMonIndex], a
	call NewEnemyMonStatus
	call ResetEnemyStatLevels
	call BreakAttraction
	call EnemySwitch

.wild
	ld c, 40
	call DelayFrames

.player_2
	call LoadTileMapToTempTileMap
	call CheckPlayerPartyForFitPkmn
	ld a, d
	and a
	jp z, LostBattle
	call Call_LoadTempTileMapToTileMap
	ld a, [wBattleType]
	cp BATTLETYPE_DEBUG
	jp z, .tutorial_debug
	cp BATTLETYPE_TUTORIAL
	jp z, .tutorial_debug
	xor a
	ld [wCurPartyMon], a
.loop2
	call CheckIfCurPartyMonIsStillAlive
	jr nz, .alive2
	ld hl, wCurPartyMon
	inc [hl]
	jr .loop2

.alive2
	ld a, [CurBattleMon]
	ld [LastPlayerMon], a
	ld a, [wCurPartyMon]
	ld [CurBattleMon], a
	inc a
	ld hl, wPartySpecies - 1
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [wCurPartySpecies], a
	ld [TempBattleMonSpecies], a

	CheckEngine ENGINE_POKEMON_MODE
	jr nz, .skipSlideOut
	hlcoord 1, 5
	ld a, 9
	call SlideBattlePicOut
	call LoadTileMapToTempTileMap
.skipSlideOut
	call InitBattleMon
	call ResetBattleParticipants
	call ResetPlayerStatLevels
	call SendOutPkmnText
	call NewBattleMonStatus
	call BreakAttraction
	CheckEngine ENGINE_POKEMON_MODE
	jr z, .regularSendOut
	call SendOutPlayerMon_PModeBattleStart
	jr .continue
.regularSendOut
	call SendOutPlayerMon
.continue
	call EmptyBattleTextBox
	call LoadTileMapToTempTileMap
	call SetPlayerTurn
	call SpikesDamage
	ld a, [wLinkMode]
	and a
	jr z, .not_linked_2
	ld a, [hLinkPlayerNumber]
	cp $2
	jr nz, .not_linked_2
	xor a
	ld [wEnemySwitchMonIndex], a
	call NewEnemyMonStatus
	call ResetEnemyStatLevels
	call BreakAttraction
	call EnemySwitch
	call SetEnemyTurn
	call SpikesDamage

.not_linked_2
	jp BattleTurn

.tutorial_debug
	jp BattleMenu

WildFled_EnemyFled_LinkBattleCanceled:
	call Call_LoadTempTileMapToTileMap
	ld a, [wBattleResult]
	and $c0
	add $2
	ld [wBattleResult], a
	ld a, [wLinkMode]
	and a
	ld hl, BattleText_WildFled
	jr z, .print_text

	ld a, [wBattleResult]
	and $c0
	ld [wBattleResult], a
	ld hl, BattleText_EnemyFled

.print_text
	call StdBattleTextBox
	call StopDangerSound

	ld de, SFX_RUN
	call PlaySFX

	call SetPlayerTurn
	ld a, 1
	ld [BattleEnded], a
	ret

BattleTurn:
.loop
	xor a
	ld [wPlayerIsSwitching], a
	ld [wEnemyIsSwitching], a
	ld [wBattleHasJustStarted], a
	ld [wPlayerJustGotFrozen], a
	ld [wEnemyJustGotFrozen], a
	dec a
	ld [wLastBallShakes], a
	call ResetDamage

	call AbilityOnMonEntrance
	call HandleBerserkGene
	call UpdateBattleMonInParty
	callba AIChooseMove

	call CheckPlayerLockedIn
	jr c, .skip_iteration
.loop1
	call BattleMenu
	ret c
	ld a, [BattleEnded]
	and a
	ret nz
	ld a, [wForcedSwitch] ; roared/whirlwinded/teleported
	and a
	ret nz
.skip_iteration
	call ParsePlayerAction
	jr nz, .loop1

	call EnemyTriesToFlee
	ret c

	ld a, [wBattleTurns]
	cp 200
	jr nc, .too_long
	inc a
	ld [wBattleTurns], a
.too_long
	call DetermineMoveOrder
	jr c, .player_first
	call Battle_EnemyFirst
	jr .proceed
.player_first
	call Battle_PlayerFirst
.proceed

	ld a, [wForcedSwitch]
	and a
	ret nz

	ld a, [BattleEnded]
	and a
	ret nz
	call HandleBetweenTurnEffects
	ld a, [BattleEnded]
	and a
	jp z, .loop
	ret

HandleBetweenTurnEffects:
	ld a, [wBattleHasJustStarted]
	and a
	ret nz
	ld a, [hLinkPlayerNumber]
	cp $1
	jr z, .CheckEnemyFirst
	call CheckFaint_PlayerThenEnemy
	ret c
	call ResidualDamage_PlayerThenEnemy
	call CheckFaint_PlayerThenEnemy
	ret c
	call HandleFutureSight
	call CheckFaint_PlayerThenEnemy
	ret c
	call CheckAbilityNegatesWeather
	call nz, HandleWeather
	call CheckFaint_PlayerThenEnemy
	ret c
	call HandleWrap
	call CheckFaint_PlayerThenEnemy
	ret c
	call HandlePerishSong
	call CheckFaint_PlayerThenEnemy
	ret c
	jr .NoMoreFaintingConditions

.CheckEnemyFirst
	call CheckFaint_EnemyThenPlayer
	ret c
	call ResidualDamage_EnemyThenPlayer
	call CheckFaint_EnemyThenPlayer
	ret c
	call HandleFutureSight
	call CheckFaint_EnemyThenPlayer
	ret c
	call CheckAbilityNegatesWeather
	call nz, HandleWeather
	call CheckFaint_EnemyThenPlayer
	ret c
	call HandleWrap
	call CheckFaint_EnemyThenPlayer
	ret c
	call HandlePerishSong
	call CheckFaint_EnemyThenPlayer
	ret c

.NoMoreFaintingConditions
	call HandleLeftovers
	call HandleMysteryberry
	call HandleDefrost
	call HandleSafeguard
	call HandleScreens
	call HandleStatBoostingHeldItems
	call HandleHealingItems
	call HandleBetweenTurnsAbilities
	call UpdateBattleMonInParty
	call LoadTileMapToTempTileMap
	jp HandleEncore

CheckFaint_PlayerThenEnemy:
	call HasPlayerFainted
	jr nz, .PlayerNotFainted
	call HandlePlayerMonFaint
	ld a, [BattleEnded]
	and a
	jr nz, .BattleIsOver

.PlayerNotFainted
	call HasEnemyFainted
	jr nz, .BattleContinues
	call HandleEnemyMonFaint
	ld a, [BattleEnded]
	and a
	jr nz, .BattleIsOver

.BattleContinues
	and a
	ret

.BattleIsOver
	scf
	ret

ResidualDamage_PlayerThenEnemy:
	call ResidualDamage_CheckPlayer
ResidualDamage_CheckEnemy:
	call SetEnemyTurn
	jp ResidualDamage

ResidualDamage_EnemyThenPlayer:
	call ResidualDamage_CheckEnemy
ResidualDamage_CheckPlayer:
	call SetPlayerTurn
	jp ResidualDamage

CheckFaint_EnemyThenPlayer:
	call HasEnemyFainted
	jr nz, .EnemyNotFainted
	call HandleEnemyMonFaint
	ld a, [BattleEnded]
	and a
	jr nz, .BattleIsOver

.EnemyNotFainted
	call HasPlayerFainted
	jr nz, .BattleContinues
	call HandlePlayerMonFaint
	ld a, [BattleEnded]
	and a
	jr nz, .BattleIsOver

.BattleContinues
	and a
	ret

.BattleIsOver
	scf
	ret

HandleBerserkGene:
	ld a, [hLinkPlayerNumber]
	cp $1
	jr z, .reverse

	call .player
	jr .enemy

.reverse
	call .enemy
.player
	call SetPlayerTurn
	ld de, PartyMon1Item
	ld a, [CurBattleMon]
	ld b, a
	jr .go

.enemy
	call SetEnemyTurn
	ld de, OTPartyMon1Item
	ld a, [CurOTMon]
	ld b, a
.go
	push de
	push bc
	call GetUserItem ; this is in ROM0
	ld a, [hl]
	ld [wd265], a
	sub BERSERK_GENE
	pop bc
	pop de
	ret nz

	ld [hl], a

	ld h, d
	ld l, e
	ld a, b
	call GetPartyLocation
	xor a
	ld [hl], a
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	push af
	call GetUserAbility
	cp ABILITY_OWN_TEMPO
	jr z, .protected
	set SUBSTATUS_CONFUSED, [hl]
.protected
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVarAddr
	push hl
	push af
	xor a
	ld [hl], a
	ld [AttackMissed], a
	ld [EffectFailed], a
	callba BattleCommand_AttackUp2
	pop af
	pop hl
	ld [hl], a
	call GetItemName
	ld hl, BattleText_UsersStringBuffer1Activated
	call StdBattleTextBox
	callba BattleCommand_StatUpMessage
	pop af
	bit SUBSTATUS_CONFUSED, a
	ret nz
	call GetUserAbility
	cp ABILITY_OWN_TEMPO
	ret z
	xor a
	ld [wNumHits], a
	ld de, ANIM_CONFUSED
	call Call_PlayBattleAnim_OnlyIfVisible
	call SwitchTurn
	ld hl, BecameConfusedText
	jp StdBattleTextBox

EnemyTriesToFlee:
	ld a, [wLinkMode]
	and a
	jr z, .not_linked
	ld a, [wBattleAction]
	cp BATTLEACTION_FORFEIT
	jr z, .forfeit

.not_linked
	and a
	ret

.forfeit
	call WildFled_EnemyFled_LinkBattleCanceled
	scf
	ret

DetermineMoveOrder:
	ld a, [wLinkMode]
	and a
	jr z, .use_move
	ld a, [wBattleAction]
	cp BATTLEACTION_E
	jr z, .use_move
	cp BATTLEACTION_D
	jr z, .use_move
	sub BATTLEACTION_SWITCH1
	jr c, .use_move
	ld a, [wPlayerAction]
	cp $2
	jr nz, .switch
	ld a, [hLinkPlayerNumber]
	cp $2
	jr z, .player_2

	call BattleRandom
	and 1
	jp z, .player_first
	jp .enemy_first

.player_2
	call BattleRandom
	and 1
	jp z, .enemy_first
	jp .player_first

.switch
	callba AI_Switch
	call SetEnemyTurn
	call SpikesDamage
	jp .enemy_first

.use_move
	ld a, [wPlayerSubStatus2]
	bit SUBSTATUS_GUARDING, a
	jp nz, .player_first
	ld a, [wPlayerAction]
	and a
	jp nz, .player_first
	call CompareMovePriority
	jp c, .player_first ; player goes first
	jp nz, .enemy_first

.equal_priority
	call SetPlayerTurn
	call GetUserItem ; this is in ROM0
	push bc
	call GetOpponentItem ; this is in ROM0
	pop de
	ld a, d
	cp HELD_QUICK_CLAW
	jr nz, .player_no_quick_claw
	ld a, b
	cp HELD_QUICK_CLAW
	jr z, .both_have_quick_claw
	call BattleRandom
	cp e
	jr nc, .speed_check
	jp .player_first

.player_no_quick_claw
	ld a, b
	cp HELD_QUICK_CLAW
	jr nz, .speed_check
	call BattleRandom
	cp c
	jr nc, .speed_check
	jp .enemy_first

.both_have_quick_claw
	ld a, [hLinkPlayerNumber]
	cp $2
	jr z, .player_2b
	call BattleRandom
	cp c
	jp c, .enemy_first
	call BattleRandom
	cp e
	jp c, .player_first
	jr .speed_check

.player_2b
	call BattleRandom
	cp e
	jp c, .player_first
	call BattleRandom
	cp c
	jp c, .enemy_first

.speed_check
	ld hl, BattleMonSpeed
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, EnemyMonSpeed
	ld a, [hli]
	ld d, a
	ld e, [hl]

	call CheckAbilityNegatesWeather
	jr z, .skip_weather_boosts
	ld a, [Weather]
	cp WEATHER_SUN
	ld h, ABILITY_CHLOROPHYLL
	jr z, .compare_ability
	cp WEATHER_RAIN
	ld h, ABILITY_SWIFT_SWIM
	jr nz, .skip_weather_boosts
.compare_ability
	ld a, [PlayerAbility]
	cp h
	jr nz, .check_enemy_chlorophyll
	sla c
	rl b
	jr nc, .check_enemy_chlorophyll
	ld bc, $FFFF
.check_enemy_chlorophyll
	ld a, [EnemyAbility]
	cp h
	jr nz, .skip_weather_boosts
	sla e
	rl d
	jr nc, .skip_weather_boosts
	ld de, $FFFF
.skip_weather_boosts
	ld a, [PlayerAbility]
	cp ABILITY_QUICK_FEET
	jr nz, .check_enemy_quick_feet
	ld a, [BattleMonStatus]
	and a
	jr z, .check_enemy_quick_feet
	push hl
	ld l, c
	ld h, b
	srl b
	rr c
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	jr nc, .check_enemy_quick_feet
	ld bc, $FFFF
.check_enemy_quick_feet
	ld a, [EnemyAbility]
	cp ABILITY_QUICK_FEET
	jr nz, .check_player_unburden
	ld a, [EnemyMonStatus]
	and a
	jr z, .check_player_unburden
	push hl
	ld l, e
	ld h, d
	srl d
	rr e
	add hl, de
	ld e, l
	ld d, h
	pop hl
	jr nc, .check_player_unburden
	ld de, $FFFF
.check_player_unburden
	ld a, [wPlayerSubStatus2]
	bit SUBSTATUS_UNBURDEN, a
	jr z, .check_enemy_unburden
	sla c
	rl b
	jr nc, .check_enemy_unburden
	ld bc, $FFFF
.check_enemy_unburden
	ld a, [wEnemySubStatus2]
	bit SUBSTATUS_UNBURDEN, a
	jr z, .compare_speed
	sla e
	rl d
	jr nc, .compare_speed
	ld de, $FFFF
.compare_speed
	call .CheckBothHaveStall
	jr z, .stall_check
	ld a, b
	cp d
	jr z, .check_lower_no_stall
	jr nc, .player_first
	jr .enemy_first

.check_lower_no_stall
	ld a, c
	cp e
	jr z, .speed_tie
	jr nc, .player_first
	jr .enemy_first

.stall_check
	ld a, b
	cp d
	jr z, .check_lower_stall
	jr c, .player_first
	jr .enemy_first

.check_lower_stall
	ld a, c
	cp e
	jr z, .speed_tie
	jr c, .player_first
	jr .enemy_first

.speed_tie
	ld a, [hLinkPlayerNumber]
	cp $2
	jr z, .player_2c
	call BattleRandom
	and 1
	jr z, .player_first
.enemy_first
	and a
	ret

.player_2c
	call BattleRandom
	and 1
	jr z, .enemy_first
.player_first
	scf
	ret

.CheckBothHaveStall
	ld a, [PlayerAbility]
	cp ABILITY_STALL
	ret nz
	ld a, [EnemyAbility]
	cp ABILITY_STALL
	ret

CheckPlayerLockedIn:
	ld a, [wPlayerSubStatus4]
	bit SUBSTATUS_RECHARGE, a
	jr nz, .quit

	ld hl, wEnemySubStatus3
	res SUBSTATUS_FLINCHED, [hl]
	ld hl, wPlayerSubStatus3
	res SUBSTATUS_FLINCHED, [hl]
	ld a, [hld]
	and 1 << SUBSTATUS_CHARGED | 1 << SUBSTATUS_RAMPAGE
	jr nz, .quit
	ld a, [hld]
	bit SUBSTATUS_GUARDING, a
	jr nz, .quit
	bit SUBSTATUS_ROLLOUT, [hl]
	jr nz, .quit

	and a
	ret

.quit
	scf
	ret

ParsePlayerAction:
	call CheckPlayerLockedIn
	jp c, .locked_in
	ld hl, wPlayerSubStatus5
	bit SUBSTATUS_ENCORED, [hl]
	jr z, .not_encored
	ld a, [LastPlayerMove]
	ld [CurPlayerMove], a
	jr .encored

.not_encored
	ld a, [wPlayerAction]
	cp $2
	jr z, .reset_rage
	and a
	jr nz, .locked_in
	xor a
	ld [wMoveSelectionMenuType], a
	inc a ; POUND
	ld [FXAnimIDLo], a
	call MoveSelectionScreen
	push af
	call Call_LoadTempTileMapToTileMap
	call UpdateBattleHuds
	ld a, [CurPlayerMove]
	cp STRUGGLE
	jr z, .struggle
	call PlayClickSFX

.struggle
	ld a, $1
	ld [hBGMapMode], a
	pop af
	ret nz

.encored
	call SetPlayerTurn
	callba UpdateMoveData
	xor a
	ld [wPlayerCharging], a
	ld a, [wPlayerMoveStruct + MOVE_EFFECT]
	cp EFFECT_FURY_CUTTER
	jr z, .continue_fury_cutter
	xor a
	ld [PlayerFuryCutterCount], a

.continue_fury_cutter
	ld a, [wPlayerMoveStruct + MOVE_EFFECT]
	cp EFFECT_RAGE
	jr z, .continue_rage
	ld hl, wPlayerSubStatus4
	res SUBSTATUS_RAGE, [hl]

.continue_rage
	ld a, [wPlayerMoveStruct + MOVE_EFFECT]
	cp EFFECT_PROTECT
	jr z, .continue_protect
	cp EFFECT_ENDURE
	jr z, .continue_protect
	xor a
	ld [PlayerProtectCount], a
	jr .continue_protect

.locked_in
	xor a
	ld [PlayerFuryCutterCount], a
	ld [PlayerProtectCount], a
	ld hl, wPlayerSubStatus4
	res SUBSTATUS_RAGE, [hl]

.continue_protect
	call ParseEnemyAction
	xor a
	ret

.reset_rage
	xor a
	ld [PlayerFuryCutterCount], a
	ld [PlayerProtectCount], a
	ld hl, wPlayerSubStatus4
	res SUBSTATUS_RAGE, [hl]
	ret

HandleEncore:
	ld a, [hLinkPlayerNumber]
	cp $1
	jr z, .player_1
	call .do_player
	jr .do_enemy

.player_1
	call .do_enemy
.do_player
	ld hl, wPlayerSubStatus5
	bit SUBSTATUS_ENCORED, [hl]
	ret z
	ld a, [PlayerEncoreCount]
	dec a
	ld [PlayerEncoreCount], a
	jr z, .end_player_encore
	ld hl, BattleMonPP
	ld a, [CurMoveNum]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	and $3f
	ret nz

.end_player_encore
	ld hl, wPlayerSubStatus5
	res SUBSTATUS_ENCORED, [hl]
	call SetEnemyTurn
	ld hl, BattleText_TargetsEncoreEnded
	jp StdBattleTextBox

.do_enemy
	ld hl, wEnemySubStatus5
	bit SUBSTATUS_ENCORED, [hl]
	ret z
	ld a, [EnemyEncoreCount]
	dec a
	ld [EnemyEncoreCount], a
	jr z, .end_enemy_encore
	ld hl, EnemyMonPP
	ld a, [CurEnemyMoveNum]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	and $3f
	ret nz

.end_enemy_encore
	ld hl, wEnemySubStatus5
	res SUBSTATUS_ENCORED, [hl]
	call SetPlayerTurn
	ld hl, BattleText_TargetsEncoreEnded
	jp StdBattleTextBox

TryEnemyFlee:
	ld a, [wBattleMode]
	dec a
	jr nz, .Stay

	ld a, [wPlayerSubStatus5]
	bit SUBSTATUS_CANT_RUN, a
	jr nz, .Stay

	ld a, [wEnemySubStatus2]
	bit SUBSTATUS_FINAL_CHANCE, a
	jr nz, .Stay

	ld a, [wEnemyWrapCount]
	and a
	jr nz, .Stay

	ld a, [EnemyMonStatus]
	and 1 << FRZ | SLP
	jr nz, .Stay

	call CheckPlayerArenaTrap
	jr c, .Stay

	CheckEngine ENGINE_PARK_MINIGAME
	jr nz, .check_park_minigame_flee

	ld a, [TempEnemyMonSpecies]
	ld hl, AlwaysFleeMons
	call IsInSingularArray
	jr c, .Flee

	call BattleRandom
	ld b, a
	and 1
	jr nz, .Stay

	push bc
	ld a, [TempEnemyMonSpecies]
	ld hl, OftenFleeMons
	call IsInSingularArray
	pop bc
	jr c, .Flee

	ld a, b
	cp 1 + (10 percent)
	jr nc, .Stay

	ld a, [TempEnemyMonSpecies]
	ld hl, SometimesFleeMons
	call IsInSingularArray
	jr c, .Flee

.Stay
	and a
	ret

.Flee
	scf
	ret

.check_park_minigame_flee
	ld a, [wLastBallShakes]
	add a, 5
	jr c, .Stay ; if the addition carries, [wLastBallShakes] wasn't positive to begin with, meaning no ball was used
	ld hl, hMultiplier
	ld [hld], a
	ld a, [EnemyMonCatchRate]
	ld [hld], a
	ld [hl], 3
	push hl
	predef Multiply
	pop hl
	call Random ; no need for BattleRandom since this is a wild battle
	cp [hl]
	jr c, .Flee
	jr nz, .Stay
	inc hl
	call Random
	cp [hl]
	jr c, .Flee
	jr .Stay

FleeMons:

SometimesFleeMons:
	db MAGNEMITE
	db TANGELA
	db -1

OftenFleeMons:
	db BULBASAUR
	db -1

AlwaysFleeMons:
	db BULBASAUR
	db -1

CompareMovePriority:
; Compare the priority of the player and enemy's moves.
; Return carry if the player goes first, or z if they match.
	ld a, [PlayerAbility]
	cp ABILITY_STALL
	jr z, .PlayerStall
	ld a, [EnemyAbility]
	cp ABILITY_STALL
	jr z, .EnemyStall
.ComparePriorities:
	ld a, [CurPlayerMove]
	call GetMovePriority
	ld b, a
	push bc
	ld a, [CurEnemyMove]
	call GetMovePriority
	pop bc
	cp b
	ret

.PlayerStall
	ld a, [EnemyAbility]
	cp ABILITY_STALL
	jr z, .ComparePriorities
	; Only player has Stall
	call .ComparePriorities
	ret nz
	inc a
	ret

.EnemyStall
	; Only enemy has Stall
	call .ComparePriorities
	ret nz
	scf
	ret

GetMovePriority:
; Return the priority (0-3) of move a.

	ld b, a

	call GetMoveEffect
	ld hl, MoveEffectPriorities
.loop
	ld a, [hli]
	cp b
	jr z, .done
	inc hl
	cp -1
	jr nz, .loop

	ld a, 1
	ret

.done
	ld a, [hl]
	ret

MoveEffectPriorities:
	db EFFECT_PROTECT,      3
	db EFFECT_ENDURE,       3
	db EFFECT_PRIORITY_HIT, 2
	db EFFECT_WHIRLWIND,    0
	db EFFECT_COUNTER,      0
	; db EFFECT_MIRROR_COAT,  0
	db -1

GetMoveEffect:
	ld a, b
	dec a
	ld hl, Moves + MOVE_EFFECT
	ld bc, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	ld b, a
	ret

Battle_EnemyFirst:
	call LoadTileMapToTempTileMap
	call TryEnemyFlee
	jp c, WildFled_EnemyFled_LinkBattleCanceled
	call SetEnemyTurn
	ld a, $1
	ld [wEnemyGoesFirst], a
	callba AI_SwitchOrTryItem
	jr c, .switch_item
	call EnemyTurn_EndOpponentProtectEndureDestinyBondGuarding
	ld a, [wForcedSwitch]
	and a
	ret nz
	call HasPlayerFainted
	jp z, HandlePlayerMonFaint
	call HasEnemyFainted
	jp z, HandleEnemyMonFaint

.switch_item
	call RefreshBattleHuds
	call PlayerTurn_EndOpponentProtectEndureDestinyBondGuarding
	ld a, [wForcedSwitch]
	and a
	ret nz
	call HasEnemyFainted
	jp z, HandleEnemyMonFaint
	call HasPlayerFainted
	jp z, HandlePlayerMonFaint
	call RefreshBattleHuds
	xor a
	ld [wPlayerAction], a
	ret

Battle_PlayerFirst:
	xor a
	ld [wEnemyGoesFirst], a
	call SetEnemyTurn
	callba AI_SwitchOrTryItem
	push af
	call PlayerTurn_EndOpponentProtectEndureDestinyBondGuarding
	pop bc
	ld a, [wForcedSwitch]
	and a
	ret nz
	call HasEnemyFainted
	jp z, HandleEnemyMonFaint
	call HasPlayerFainted
	jp z, HandlePlayerMonFaint
	push bc
	call RefreshBattleHuds
	pop af
	jr c, .switched_or_used_item
	call LoadTileMapToTempTileMap
	call TryEnemyFlee
	jp c, WildFled_EnemyFled_LinkBattleCanceled
	call EnemyTurn_EndOpponentProtectEndureDestinyBondGuarding
	ld a, [wForcedSwitch]
	and a
	ret nz
	call HasPlayerFainted
	jp z, HandlePlayerMonFaint
	call HasEnemyFainted
	jp z, HandleEnemyMonFaint

.switched_or_used_item
	call RefreshBattleHuds
	xor a
	ld [wPlayerAction], a
	ret

PlayerTurn_EndOpponentProtectEndureDestinyBondGuarding:
	call SetPlayerTurn
	call EndUserDestinyBond
	callba DoPlayerTurn
	jr EndOpponentProtectEndureDestinyBondGuarding

EnemyTurn_EndOpponentProtectEndureDestinyBondGuarding:
	call SetEnemyTurn
	call EndUserDestinyBond
	callba DoEnemyTurn

EndOpponentProtectEndureDestinyBondGuarding:
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVarAddr
	res SUBSTATUS_PROTECT, [hl]
	res SUBSTATUS_ENDURE, [hl]
	ld a, BATTLE_VARS_SUBSTATUS5_OPP
	call GetBattleVarAddr
	res SUBSTATUS_DESTINY_BOND, [hl]
	ld a, BATTLE_VARS_SUBSTATUS2_OPP
	call GetBattleVarAddr
	res SUBSTATUS_GUARDING, [hl]
	ret

EndUserDestinyBond:
	ld a, BATTLE_VARS_SUBSTATUS5
	call GetBattleVarAddr
	res SUBSTATUS_DESTINY_BOND, [hl]
	ret

HasUserFainted:
	ld a, [hBattleTurn]
	and a
	jr z, HasPlayerFainted
HasEnemyFainted:
	ld hl, EnemyMonHP
	jr CheckIfHPIsZero

HasPlayerFainted:
	ld hl, BattleMonHP
	; fallthrough

CheckIfHPIsZero:
	ld a, [hli]
	or [hl]
	ret

ResidualDamage:
; Return z if the user fainted before
; or as a result of residual damage.
; For Sandstorm damage, see HandleWeather.

	call HasUserFainted
	ret z

	call GetUserAbility
	cp ABILITY_SHED_SKIN
	jr nz, .skip_shed_skin

	ld a, BATTLE_VARS_STATUS
	call GetBattleVarAddr
	and a
	jp z, .did_psn_brn

	call BattleRandom
	cp 30 percent
	jr nc, .skip_shed_skin

	ld [hl], 0
	call UpdateUserInParty
	call UpdateBattleHUDs
	ld hl, ShedSkinText
	call StdBattleTextBox
	jp .did_psn_brn

.skip_shed_skin

	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and 1 << PSN | 1 << BRN
	jp z, .did_psn_brn

	ld hl, HurtByPoisonText
	ld de, ANIM_PSN
	and 1 << BRN
	jr nz, .check_brn
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_POISON_HEAL
	jr nz, .got_anim
	ld hl, PoisonHealText
	ld de, NO_MOVE
	jr .got_anim

.check_brn
	ld hl, HurtByBurnText
	ld de, ANIM_BRN
.got_anim

	push de
	call StdBattleTextBox
	pop de

	xor a
	ld [wNumHits], a
	call Call_PlayBattleAnim_OnlyIfVisible
	call GetEighthMaxHP
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	bit BRN, a
	jr nz, .burn
	ld de, PlayerToxicCount
	ld a, [hBattleTurn]
	and a
	jr z, .check_toxic
	ld de, EnemyToxicCount
.check_toxic

	ld a, BATTLE_VARS_SEMISTATUS
	call GetBattleVar
	bit SEMISTATUS_TOXIC, a
	jr z, .psn_check_poison_heal
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_POISON_HEAL
	push af
	ld a, [de]
	inc a
	ld [de], a
	pop af
	jr z, .heal

	srl b
	rr c
	ld a, b
	or c
	jr nz, .okay_toxic
	inc c
.okay_toxic
	ld a, [de]
	ld hl, 0
	rst AddNTimes
	ld b, h
	ld c, l
	jr .deal_damage

.psn_check_poison_heal
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_POISON_HEAL
	jr z, .heal
	jr .deal_damage

.burn
	call GetUserAbility
	cp ABILITY_HEATPROOF
	jr nz, .deal_damage
	srl b
	rr c
	ld a, b
	or c
	jr nz, .deal_damage
	inc c
.deal_damage
	call SubtractHPFromUser
	jr .did_psn_brn

.heal
	call RestoreUserHP
.did_psn_brn
	call HasUserFainted
	jp z, .fainted

	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	bit SUBSTATUS_LEECH_SEED, [hl]
	jr z, .not_seeded

	call SwitchTurn
	xor a
	ld [wNumHits], a
	ld de, ANIM_SAP
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	call z, Call_PlayBattleAnim_OnlyIfVisible
	call SwitchTurn

	call GetEighthMaxHP
	call SubtractHPFromUser
	ld a, $1
	ld [hBGMapMode], a
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_LIQUID_OOZE
	ld de, RestoreOpponentHP
	ld hl, LeechSeedSapsText
	jr nz, .print
	ld de, SubtractHPFromTarget
	ld hl, LiquidOozeHurtsText
.print
	push hl
	call _de_
	pop hl
	call StdBattleTextBox
.not_seeded

	call HasUserFainted
	jr z, .fainted

	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	bit SUBSTATUS_NIGHTMARE, [hl]
	jr z, .not_nightmare
	xor a
	ld [wNumHits], a
	ld de, ANIM_IN_NIGHTMARE
	call Call_PlayBattleAnim_OnlyIfVisible
	call GetQuarterMaxHP
	call SubtractHPFromUser
	ld hl, HasANightmareText
	call StdBattleTextBox
.not_nightmare

	call HasUserFainted
	jr z, .fainted

	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	bit SUBSTATUS_CURSE, [hl]
	jr z, .not_cursed

	xor a
	ld [wNumHits], a
	ld de, ANIM_IN_NIGHTMARE
	call Call_PlayBattleAnim_OnlyIfVisible
	call GetQuarterMaxHP
	call SubtractHPFromUser
	ld hl, HurtByCurseText
	call StdBattleTextBox

.not_cursed
	ld hl, BattleMonHP
	ld a, [hBattleTurn]
	and a
	jr z, .check_fainted
	ld hl, EnemyMonHP

.check_fainted
	ld a, [hli]
	or [hl]
	ret nz

.fainted
	call RefreshBattleHuds
	ld c, 20
	call DelayFrames
	xor a
	ret

HandlePerishSong:
	ld a, [hLinkPlayerNumber]
	cp $1
	jr z, .EnemyFirst
	call SetPlayerTurn
	call .do_it
	call SetEnemyTurn
	jp .do_it

.EnemyFirst
	call SetEnemyTurn
	call .do_it
	call SetPlayerTurn

.do_it
	ld hl, PlayerPerishCount
	ld a, [hBattleTurn]
	and a
	jr z, .got_count
	ld hl, EnemyPerishCount

.got_count
	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVar
	bit SUBSTATUS_PERISH, a
	ret z
	dec [hl]
	ld a, [hl]
	ld [wd265], a
	push af

	ld hl, PerishCountText
	push hl
	ld a, BATTLE_VARS_SUBSTATUS2
	call GetBattleVar
	bit SUBSTATUS_FINAL_CHANCE, a
	jr z, .pop
	pop hl
	ld hl, FinalChanceText
	jr .print

.pop
	pop hl
.print
	call StdBattleTextBox
	pop af
	jr z, .kill_mon

	ld a, BATTLE_VARS_SUBSTATUS2
	call GetBattleVar
	bit SUBSTATUS_FINAL_CHANCE, a
	ret z

	; Final Chance healing animation
	ld de, FINAL_CHANCE
	ld a, 1
	ld [wBattleAnimParam], a
	xor a
	ld [wNumHits], a
	call Call_PlayBattleAnim_OnlyIfVisible

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	res SUBSTATUS_CONFUSED, [hl]
	ld a, BATTLE_VARS_SEMISTATUS
	call GetBattleVarAddr
	res SEMISTATUS_TOXIC, [hl]
	ld a, [hBattleTurn]
	and a
	ld hl, BattleMonHP
	ld de, BattleMonStatus
	jr z, .okay
	ld hl, EnemyMonHP
	ld de, EnemyMonStatus
.okay
	xor a
	ld [de], a
	ld d, h
	ld e, l
	ld a, [hli]
	ld [wCurHPAnimOldHP + 1], a
	ld a, [hli]
	ld [wCurHPAnimOldHP], a
	ld a, [hli]
	ld [de], a
	inc de
	ld [wCurHPAnimMaxHP + 1], a
	ld [wCurHPAnimNewHP + 1], a
	ld a, [hl]
	ld [de], a
	ld [wCurHPAnimMaxHP], a
	ld [wCurHPAnimNewHP], a
	call UpdateHPBarBattleHuds
	call UpdateUserInParty
	ld hl, FinalChanceHealedText
	jp StdBattleTextBox

.kill_mon
	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	res SUBSTATUS_PERISH, [hl]
	ld a, [hBattleTurn]
	and a
	jr nz, .kill_enemy
	ld hl, BattleMonHP
	xor a
	ld [hli], a
	ld [hl], a
	ld hl, PartyMon1HP
	ld a, [CurBattleMon]
	call GetPartyLocation
	xor a
	ld [hli], a
	ld [hl], a
	ret

.kill_enemy
	ld hl, EnemyMonHP
	xor a
	ld [hli], a
	ld [hl], a
	ld a, [wBattleMode]
	dec a
	ret z
	ld hl, OTPartyMon1HP
	ld a, [CurOTMon]
	call GetPartyLocation
	xor a
	ld [hli], a
	ld [hl], a
	ret

HandleWrap:
	ld a, [hLinkPlayerNumber]
	cp $1
	jr z, .EnemyFirst
	call SetPlayerTurn
	call .do_it
	call SetEnemyTurn
	jr .do_it

.EnemyFirst
	call SetEnemyTurn
	call .do_it
	call SetPlayerTurn

.do_it
	ld hl, wPlayerWrapCount
	ld de, wPlayerTrappingMove
	ld a, [hBattleTurn]
	and a
	jr z, .got_addrs
	ld hl, wEnemyWrapCount
	ld de, wEnemyTrappingMove

.got_addrs
	ld a, [hl]
	and a
	ret z

	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVar
	bit SUBSTATUS_SUBSTITUTE, a
	ret nz

	ld a, [de]
	ld [wd265], a
	ld [FXAnimIDLo], a
	call GetMoveName
	dec [hl]
	jr z, .release_from_bounds

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	jr nz, .skip_anim

	call SwitchTurn
	xor a
	ld [wNumHits], a
	ld [FXAnimIDHi], a
	predef PlayBattleAnim
	call SwitchTurn

.skip_anim
	call GetEighthMaxHP
	call SubtractHPFromUser
	ld hl, BattleText_UsersHurtByStringBuffer1
	jr .print_text

.release_from_bounds
	ld hl, BattleText_UserWasReleasedFromStringBuffer1

.print_text
	jp StdBattleTextBox

HandleLeftovers:
	ld a, [hLinkPlayerNumber]
	cp $1
	jr z, .DoEnemyFirst
	call SetPlayerTurn
	call .do_it
	call SetEnemyTurn
	jp .do_it

.DoEnemyFirst
	call SetEnemyTurn
	call .do_it
	call SetPlayerTurn
.do_it

	call GetUserItem ; this is in ROM0
	ld a, [hl]
	ld [wd265], a
	call GetItemName
	ld a, b
	cp HELD_LEFTOVERS
	ret nz

	ld hl, BattleMonHP
	ld a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld hl, EnemyMonHP

.got_hp
; Don't restore if we're already at max HP
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	cp b
	jr nz, .restore
	ld a, [hl]
	cp c
	ret z

.restore
	call GetSixteenthMaxHP
	call SwitchTurn
	call RestoreOpponentHP
	ld hl, BattleText_TargetRecoveredWithItem
	jp StdBattleTextBox

HandleMysteryberry:
	ld a, [hLinkPlayerNumber]
	cp $1
	jr z, .DoEnemyFirst
	call SetPlayerTurn
	call .do_it
	call SetEnemyTurn
	jp .do_it

.DoEnemyFirst
	call SetEnemyTurn
	call .do_it
	call SetPlayerTurn

.do_it
	call GetUserItem ; this is in ROM0
	ld a, b
	cp HELD_RESTORE_PP
	ret nz
	ld hl, PartyMon1PP
	ld a, [CurBattleMon]
	call GetPartyLocation
	ld d, h
	ld e, l
	ld hl, PartyMon1Moves
	ld a, [CurBattleMon]
	call GetPartyLocation
	ld a, [hBattleTurn]
	and a
	jr z, .wild
	ld de, wWildMonPP
	ld hl, wWildMonMoves
	ld a, [wBattleMode]
	dec a
	jr z, .wild
	ld hl, OTPartyMon1PP
	ld a, [CurOTMon]
	call GetPartyLocation
	ld d, h
	ld e, l
	ld hl, OTPartyMon1Moves
	ld a, [CurOTMon]
	call GetPartyLocation

.wild
	ld c, $0
.loop
	ld a, [hl]
	and a
	ret z
	ld a, [de]
	and $3f
	jr z, .restore
	inc hl
	inc de
	inc c
	ld a, c
	cp NUM_MOVES
	jr nz, .loop
	ret

.restore
	; lousy hack
	ld a, [hl]
	ld b, 5
	ld a, [de]
	add b
	ld [de], a
	push bc
	push bc
	ld a, [hl]
	ld [wd265], a
	ld de, BattleMonMoves - 1
	ld hl, BattleMonPP
	ld a, [hBattleTurn]
	and a
	jr z, .player_pp
	ld de, EnemyMonMoves - 1
	ld hl, EnemyMonPP
.player_pp
	inc de
	pop bc
	ld b, 0
	add hl, bc
	push hl
	ld h, d
	ld l, e
	add hl, bc
	pop de
	pop bc

	ld a, [wd265]
	cp [hl]
	jr nz, .skip_checks
	ld a, [hBattleTurn]
	and a
	ld a, [wPlayerSubStatus5]
	jr z, .check_transform
	ld a, [wEnemySubStatus5]
.check_transform
	bit SUBSTATUS_TRANSFORMED, a
	jr nz, .skip_checks
	ld a, [de]
	add b
	ld [de], a
.skip_checks
	call GetUserItem ; this is in ROM0
	ld a, [hl]
	ld [wd265], a
	xor a
	ld [hl], a
	call GetPartymonItem
	ld a, [hBattleTurn]
	and a
	jr z, .consume_item
	ld a, [wBattleMode]
	dec a
	jr z, .skip_consumption
	call GetOTPartymonItem

.consume_item
	xor a
	ld [hl], a

.skip_consumption
	call GetItemName
	call SwitchTurn
	call ItemRecoveryAnim
	call SwitchTurn
	ld hl, BattleText_UserRecoveredPPUsing
	jp StdBattleTextBox

HandleFutureSight:
	ld a, [hLinkPlayerNumber]
	cp $1
	jr z, .enemy_first
	call SetPlayerTurn
	call .do_it
	call SetEnemyTurn
	jp .do_it

.enemy_first
	call SetEnemyTurn
	call .do_it
	call SetPlayerTurn

.do_it
	ld hl, wPlayerFutureSightCount
	ld a, [hBattleTurn]
	and a
	jr z, .okay
	ld hl, wEnemyFutureSightCount

.okay
	ld a, [hl]
	and a
	ret z
	dec a
	ld [hl], a
	cp $1
	ret nz

	ld hl, BattleText_TargetWasHitByFutureSight
	call StdBattleTextBox

	ld a, BATTLE_VARS_MOVE
	call GetBattleVarAddr
	push af
	ld a, FUTURE_SIGHT
	ld [hl], a

	callba UpdateMoveData
	xor a
	ld [AttackMissed], a
	ld [AlreadyDisobeyed], a
	ld a, 10
	ld [TypeModifier], a
	callba DoMove
	call ResetDamage

	ld a, BATTLE_VARS_MOVE
	call GetBattleVarAddr
	pop af
	ld [hl], a

	call UpdateBattleMonInParty
	jp UpdateEnemyMonInParty

HandleDefrost:
	ld a, [hLinkPlayerNumber]
	cp $1
	jr z, .enemy_first
	call .do_player_turn
	jr .do_enemy_turn

.enemy_first
	call .do_enemy_turn
.do_player_turn
	ld a, [BattleMonStatus]
	bit FRZ, a
	ret z

	ld a, [wPlayerJustGotFrozen]
	and a
	ret nz

	ld a, [EnemyAbility]
	cp ABILITY_MOLD_BREAKER
	jr z, .sample_player
	ld a, [PlayerAbility]
	cp ABILITY_MAGMA_ARMOR
	jr z, .succeed_player
.sample_player
	call BattleRandom
	cp 10 percent
	ret nc
.succeed_player
	xor a
	ld [BattleMonStatus], a
	ld a, [CurBattleMon]
	ld hl, PartyMon1Status
	call GetPartyLocation
	ld [hl], 0
	call UpdateBattleHuds
	call SetEnemyTurn
	ld hl, DefrostedOpponentText
	jp StdBattleTextBox

.do_enemy_turn
	ld a, [EnemyMonStatus]
	bit FRZ, a
	ret z
	ld a, [wEnemyJustGotFrozen]
	and a
	ret nz

	ld a, [PlayerAbility]
	cp ABILITY_MOLD_BREAKER
	jr z, .sample_enemy
	ld a, [EnemyAbility]
	cp ABILITY_MAGMA_ARMOR
	jr z, .succeed_enemy
.sample_enemy
	call BattleRandom
	cp 10 percent
	ret nc
.succeed_enemy
	xor a
	ld [EnemyMonStatus], a

	ld a, [wBattleMode]
	dec a
	jr z, .wild
	ld a, [CurOTMon]
	ld hl, OTPartyMon1Status
	call GetPartyLocation
	ld [hl], 0
.wild

	call UpdateBattleHuds
	call SetPlayerTurn
	ld hl, DefrostedOpponentText
	jp StdBattleTextBox

HandleSafeguard:
	ld a, [hLinkPlayerNumber]
	cp $1
	jr z, .player1
	call .CheckPlayer
	jr .CheckEnemy

.player1
	call .CheckEnemy
.CheckPlayer
	ld a, [wPlayerScreens]
	bit SCREENS_SAFEGUARD, a
	ret z
	ld hl, PlayerSafeguardCount
	dec [hl]
	ret nz
	res SCREENS_SAFEGUARD, a
	ld [wPlayerScreens], a
	xor a
	jr .print

.CheckEnemy
	ld a, [wEnemyScreens]
	bit SCREENS_SAFEGUARD, a
	ret z
	ld hl, EnemySafeguardCount
	dec [hl]
	ret nz
	res SCREENS_SAFEGUARD, a
	ld [wEnemyScreens], a
	ld a, $1

.print
	ld [hBattleTurn], a
	ld hl, BattleText_SafeguardFaded
	jp StdBattleTextBox

HandleScreens:
	ld a, [hLinkPlayerNumber]
	cp 1
	jr z, .Both
	call .CheckPlayer
	jr .CheckEnemy

.Both
	call .CheckEnemy

.CheckPlayer
	call SetPlayerTurn
	ld de, .Your
	call .Copy
	ld hl, wPlayerScreens
	ld de, PlayerLightScreenCount
	jr .TickScreens

.CheckEnemy
	call SetEnemyTurn
	ld de, .Enemy
	call .Copy
	ld hl, wEnemyScreens
	ld de, EnemyLightScreenCount

.TickScreens
	bit SCREENS_LIGHT_SCREEN, [hl]
	call nz, .LightScreenTick
	bit SCREENS_REFLECT, [hl]
	ret z
.ReflectTick
	inc de
	ld a, [de]
	dec a
	ld [de], a
	ret nz
	res SCREENS_REFLECT, [hl]
	ld hl, BattleText_PkmnReflectFaded
	jp StdBattleTextBox

.Copy
	ld hl, wStringBuffer1
	jp CopyName2

.Your
	db "Your@"
.Enemy
	db "Enemy@"

.LightScreenTick
	ld a, [de]
	dec a
	ld [de], a
	ret nz
	res SCREENS_LIGHT_SCREEN, [hl]
	push hl
	push de
	ld hl, BattleText_PkmnLightScreenFell
	call StdBattleTextBox
	pop de
	pop hl
	ret

HandleWeather:

	ld a, [Weather]
	and a ; cp WEATHER_NONE
	ret z

	ld hl, WeatherCount
	dec [hl]
	jp z, .ended

	ld hl, .WeatherMessages
	call .PrintWeatherMessage

	xor a
	ld [wNumHits], a
	call PlayWeatherAnimation

	ld a, [Weather]
	cp WEATHER_SUN
	jp z, DrySkinCheck
	cp WEATHER_RAIN
	jp z, RainDishCheck
	cp WEATHER_SANDSTORM
	jr z, .hail_sandstorm
	cp WEATHER_HAIL
	ret nz
.hail_sandstorm

	ld a, [hLinkPlayerNumber]
	cp 1
	jr z, .enemy_first

.player_first
	call SetPlayerTurn
	call .RainDishHeal
	call SetEnemyTurn
	jr .RainDishHeal

.enemy_first
	call SetEnemyTurn
	call .RainDishHeal
	call SetPlayerTurn

.RainDishHeal
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	bit SUBSTATUS_UNDERGROUND, a
	ret nz

	call GetUserItem ; this is in ROM0
	ld a, b
	cp HELD_SAFE_GOGGLES
	ret z

	ld hl, BattleMonType1
	ld a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, EnemyMonType1
.ok
	ld a, [Weather]
	cp WEATHER_SANDSTORM
	jr z, .sandstorm_types
	call GetUserAbility
	cp ABILITY_ICE_BODY
	jp z, .Restore
	ld a, [hli]
	cp ICE
	ret z
	ld a, [hl]
	cp ICE
	ret z
	jr .damage

.sandstorm_types
	call GetUserAbility
	cp ABILITY_SAND_VEIL
	ret z
	ld a, [hli]
	cp ROCK
	ret z
	cp GROUND
	ret z
	cp STEEL
	ret z

	ld a, [hl]
	cp ROCK
	ret z
	cp GROUND
	ret z
	cp STEEL
	ret z
.damage
	call SwitchTurn
	xor a
	ld [wNumHits], a
	ld hl, SandstormHitsText
	ld a, [Weather]
	cp WEATHER_SANDSTORM
	jr z, .got_anim
	ld hl, HailHitsText
.got_anim
	push hl

	ld a, 1
	ld [wNumHits], a
	ld a, 10
	ld [TypeModifier], a
	ld de, ANIM_ENEMY_DAMAGE
	ld a, [hBattleTurn]
	and a
	jr z, .animate_damage
	ld de, ANIM_PLAYER_DAMAGE
.animate_damage
	call Call_PlayBattleAnim

	call SwitchTurn
	call GetEighthMaxHP
	call SubtractHPFromUser

	pop hl
	jp StdBattleTextBox

.ended
	ld hl, .WeatherEndedMessages
	call .PrintWeatherMessage
	xor a
	ld [Weather], a
	ret

.PrintWeatherMessage
	ld a, [Weather]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp StdBattleTextBox

.Restore
	call GetSixteenthMaxHP
	call RestoreUserHP
	ld hl, IceBodyText
	jp StdBattleTextBox

.WeatherMessages
	dw BattleText_RainContinuesToFall
	dw BattleText_TheSunlightIsStrong
	dw BattleText_TheSandstormRages
	dw BattleText_HailContinuesToFall
.WeatherEndedMessages
	dw BattleText_TheRainStopped
	dw BattleText_TheSunlightFaded
	dw BattleText_TheSandstormSubsided
	dw BattleText_TheHailStopped

PlayWeatherAnimation:
	call CheckBattleScene
	ret c
	ld a, [Weather]
	dec a
	ld e, a
	ld d, 0
	ld hl, .WeatherAnimations
	add hl, de
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	jp Call_PlayBattleAnim

.WeatherAnimations
	dw RAIN_DANCE
	dw SUNNY_DAY
	dw ANIM_IN_SANDSTORM
	dw ANIM_IN_HAILSTORM

DrySkinCheck:
	ld a, [hLinkPlayerNumber]
	cp 1
	jr z, .enemy_first

.player_first
	call SetPlayerTurn
	call .DrySkinHurt
	call SetEnemyTurn
	jr .DrySkinHurt

.enemy_first
	call SetEnemyTurn
	call .DrySkinHurt
	call SetPlayerTurn
.DrySkinHurt
	call GetUserAbility
	cp ABILITY_DRY_SKIN
	ret nz
	ld [wd265], a
	call GetAbilityName
	call GetEighthMaxHP
	call SubtractHPFromUser
	ld hl, AbilityHurtText
	jp StdBattleTextBox

RainDishCheck:

	ld a, [hLinkPlayerNumber]
	cp 1
	jr z, .enemy_first

.player_first
	call SetPlayerTurn
	call .RainDishHeal
	call SetEnemyTurn
	jr .RainDishHeal

.enemy_first
	call SetEnemyTurn
	call .RainDishHeal
	call SetPlayerTurn
.RainDishHeal
	call GetUserAbility
	cp ABILITY_DRY_SKIN
	jr z, .DrySkinRain
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_RAIN_DISH
	ret nz
	ld [wd265], a
	call GetAbilityName
	call GetSixteenthMaxHP
	call RestoreUserHP
	ld hl, AbilityRestoreHPText
	jp StdBattleTextBox

.DrySkinRain
	ld [wd265], a
	call GetAbilityName
	call GetEighthMaxHP
	call RestoreUserHP
	ld hl, AbilityRestoreHPText
	jp StdBattleTextBox

SubtractHPFromTarget:
	call SwitchTurn
	push bc
	call GetMaxHP
	pop bc
	call SubtractHP
	call UpdateHPBarBattleHuds
	jp SwitchTurn

SubtractHPFromUser:
; Subtract HP from Pkmn
	call SubtractHP
	jp UpdateHPBarBattleHuds

SubtractHP:
	ld hl, BattleMonHP
	ld a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, EnemyMonHP
.ok
	inc hl
	ld a, [hl]
	ld [wCurHPAnimOldHP], a
	sub c
	ld [hld], a
	ld [wCurHPAnimNewHP], a
	ld a, [hl]
	ld [wCurHPAnimOldHP + 1], a
	sbc b
	ld [hl], a
	ld [wCurHPAnimNewHP + 1], a
	ret nc

	ld a, [wCurHPAnimOldHP]
	ld c, a
	ld a, [wCurHPAnimOldHP + 1]
	ld b, a
	xor a
	ld [hli], a
	ld [hl], a
	ld [wCurHPAnimNewHP], a
	ld [wCurHPAnimNewHP + 1], a
	ret

GetSixteenthMaxHP:
	call GetQuarterMaxHP
	; quarter result
	srl c
	srl c
	; round up
	ld a, c
	and a
	ret nz
	inc c
	ret

GetEighthMaxHP:
; output: bc
	call GetQuarterMaxHP
; assumes nothing can have 1024 or more hp
; halve result
	srl c
; round up
	ld a, c
	and a
	ret nz
	inc c
	ret

GetThirdMaxHP:
	call GetMaxHP
	ld a, b
	ld [hDividend], a
	ld a, c
	ld [hDividend + 1], a
	ld a, 3
	ld [hDivisor], a
	ld b, 2
	predef Divide
	ld a, [hQuotient + 1]
	ld b, a
	ld a, [hQuotient + 2]
	ld c, a
	or b
	ret nz
	inc c
	ret

GetQuarterMaxHP:
; output: bc
	call GetMaxHP

; quarter result
	srl b
	rr c
	srl b
	rr c

; assumes nothing can have 1024 or more hp
; round up
	ld a, c
	and a
	ret nz
	inc c
	ret

GetHalfMaxHP:
; output: bc
	call GetMaxHP

; halve result
	srl b
	rr c

; floor = 1
	ld a, c
	or b
	ret nz
	inc c
	ret

GetMaxHP:
; output: bc, wCurHPAnimMaxHP

	ld hl, BattleMonMaxHP
	ld a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, EnemyMonMaxHP
.ok
	ld a, [hli]
	ld [wCurHPAnimMaxHP + 1], a
	ld b, a

	ld a, [hl]
	ld [wCurHPAnimMaxHP], a
	ld c, a
	ret

CheckUserHasEnoughHP:
	ld hl, BattleMonHP + 1
	ld a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, EnemyMonHP + 1
.ok
	ld a, c
	sub [hl]
	dec hl
	ld a, b
	sbc [hl]
	ret

RestoreUserHP:
	call SwitchTurn
	call RestoreOpponentHP
	jp SwitchTurn

RestoreOpponentHP:
	ld hl, EnemyMonMaxHP
	ld a, [hBattleTurn]
	and a
	jr z, RestoreHP
	ld hl, BattleMonMaxHP
RestoreHP:
	ld a, [hli]
	ld [wCurHPAnimMaxHP + 1], a
	ld a, [hld]
	ld [wCurHPAnimMaxHP], a
	dec hl
	ld a, [hl]
	ld [wCurHPAnimOldHP], a
	add c
	ld [hld], a
	ld [wCurHPAnimNewHP], a
	ld a, [hl]
	ld [wCurHPAnimOldHP + 1], a
	adc b
	ld [hli], a
	ld [wCurHPAnimNewHP + 1], a

	ld a, [wCurHPAnimMaxHP]
	ld c, a
	ld a, [hld]
	sub c
	ld a, [wCurHPAnimMaxHP + 1]
	ld b, a
	ld a, [hl]
	sbc b
	jr c, .maxed
	ld a, b
	ld [hli], a
	ld [wCurHPAnimNewHP + 1], a
	ld a, c
	ld [hl], a
	ld [wCurHPAnimNewHP], a
.maxed

	call SwitchTurn
	call UpdateHPBarBattleHuds
	jp SwitchTurn

UpdateHPBarBattleHuds:
	call UpdateHPBar
	jp UpdateBattleHuds

UpdateHPBar:
	hlcoord 10, 9
	ld a, [hBattleTurn]
	and a
	ld a, 1
	jr z, .ok
	hlcoord 2, 2
	xor a
.ok
	push bc
	ld [wWhichHPBar], a
	predef AnimateHPBar
	pop bc
	ret

HandleEnemyMonFaint:
	call FaintEnemyPokemon
	ld hl, BattleMonHP
	ld a, [hli]
	or [hl]
	call z, FaintYourPokemon
	ld a, [EnemyAbility]
	cp ABILITY_AFTERMATH
	jr nz, .skip_aftermath
	ld [wd265], a
	call GetAbilityName
	callba UsedContactMove
	jr nc, .skip_aftermath
	ld a, [hBattleTurn]
	push af
	call SetPlayerTurn
	ld hl, BattleMonMaxHP + 1
	call HandleAftermath
	call z, FaintYourPokemon
	pop af
	ld [hBattleTurn], a
.skip_aftermath
	xor a
	ld [wWhichMonFaintedFirst], a
	call UpdateBattleStateAndExperienceAfterEnemyFaint
	call CheckPlayerPartyForFitPkmn
	ld a, d
	and a
	jp z, LostBattle

	ld hl, BattleMonHP
	ld a, [hli]
	or [hl]
	call nz, UpdatePlayerHUD

	ld a, $1
	ld [hBGMapMode], a
	ld c, 60
	call DelayFrames

	ld a, [wBattleMode]
	dec a
	jr nz, .trainer

	callba CheckPickup
	ld a, 1
	ld [BattleEnded], a
	ret

.trainer
	call CheckEnemyTrainerDefeated
	jp z, WinTrainerBattle

	ld hl, BattleMonHP
	ld a, [hli]
	or [hl]
	jr nz, .player_mon_not_fainted

	call AskUseNextPokemon
	jr nc, .dont_flee

	ld a, 1
	ld [BattleEnded], a
	ret

.dont_flee
	call ForcePlayerMonChoice

	ld a, $1
	ld [wPlayerAction], a
	call HandleEnemySwitch
	jp z, WildFled_EnemyFled_LinkBattleCanceled
	jr DoubleSwitch

.player_mon_not_fainted
	ld a, $1
	ld [wPlayerAction], a
	call HandleEnemySwitch
	jp z, WildFled_EnemyFled_LinkBattleCanceled
	xor a
	ld [wPlayerAction], a
	ret

DoubleSwitch:
	ld a, [hLinkPlayerNumber]
	cp $1
	jr z, .player_1
	call ClearSprites
	hlcoord 1, 0
	lb bc, 4, 10
	call ClearBox
	call PlayerPartyMonEntrance
	ld a, $1
	call EnemyPartyMonEntrance
	jr .done

.player_1
	ld a, [wCurPartyMon]
	push af
	ld a, $1
	call EnemyPartyMonEntrance
	call ClearSprites
	call LoadTileMapToTempTileMap
	pop af
	ld [wCurPartyMon], a
	call PlayerPartyMonEntrance

.done
	xor a
	ld [wPlayerAction], a
	ret

GetEnemyFaintedText:
	ld hl, BattleText_EnemyPkmnFainted
	ld a, [wBattleMode]
	dec a
	ret nz
	ld hl, BattleText_WildPkmnFainted
	ret

StopDangerSound:
	xor a
	ld [Danger], a
	ret

FaintYourPokemon:
	call StopDangerSound
	call WaitSFX
	ld a, $f0
	ld [CryTracks], a
	ld a, [BattleMonSpecies]
	call PlayFaintingCry
	call WaitSFX
	ld de, SFX_KINESIS
	call PlaySFX
	call PlayerMonFaintedAnimation
	ld de, SFX_FAINT
	call PlaySFX
	hlcoord 9, 7
	lb bc, 5, 11
	call ClearBox
	ld hl, BattleText_PkmnFainted
	jp StdBattleTextBox

FaintEnemyPokemon:
	call WaitSFX
	ld a, $0f
	ld [CryTracks], a
	ld a, [EnemyMonSpecies]
	call PlayFaintingCry
	call WaitSFX
	ld de, SFX_KINESIS
	call PlaySFX
	call EnemyMonFaintedAnimation
	ld de, SFX_FAINT
	call PlaySFX
	hlcoord 1, 0
	lb bc, 4, 10
	call ClearBox
	call GetEnemyFaintedText
	jp StdBattleTextBox

CheckEnemyTrainerDefeated:
	ld a, [OTPartyCount]
	ld b, a
	xor a
	ld hl, OTPartyMon1HP
	ld de, PARTYMON_STRUCT_LENGTH

.loop
	or [hl]
	inc hl
	or [hl]
	dec hl
	add hl, de
	dec b
	jr nz, .loop

	and a
	ret

HandleEnemySwitch:
	ld hl, EnemyHPPal
	ld e, HP_BAR_LENGTH_PX
	call UpdateHPPal
	call ApplyTilemapInVBlank
	callba EnemySwitch_TrainerHud
	ld a, [wLinkMode]
	and a
	jr z, .not_linked

	call LinkBattleSendReceiveAction
	ld a, [wBattleAction]
	cp BATTLEACTION_FORFEIT
	ret z

	call Call_LoadTempTileMapToTileMap

.not_linked
	ld hl, BattleMonHP
	ld a, [hli]
	or [hl]
	ld a, $1
	jr nz, .okay
	and a
	ret

.okay
	xor a
EnemyPartyMonEntrance:
	push af
	xor a
	ld [wEnemySwitchMonIndex], a
	call NewEnemyMonStatus
	call ResetEnemyStatLevels
	call BreakAttraction
	pop af
	and a
	jr nz, .set
	call EnemySwitch
	jr .done_switch

.set
	call EnemySwitch_SetMode
.done_switch
	call ResetBattleParticipants
	call SetEnemyTurn
	call SpikesDamage
	xor a
	ld [wEnemyMoveStruct + MOVE_ANIM], a
	ld [wPlayerAction], a
	inc a
	ret

WinTrainerBattle:
; Player won the battle
	call StopDangerSound
	callba CheckPickup
	ld a, $1
	ld [wDanger], a
	ld [BattleEnded], a
	ld a, [wLinkMode]
	and a
	ld a, b
	call z, PlayVictoryMusic
	callba Battle_GetTrainerName
	ld hl, BattleText_EnemyWasDefeated
	call StdBattleTextBox

	ld a, [wLinkMode]
	and a
	ret nz

	ld a, [InBattleTowerBattle]
	bit 0, a
	jr nz, .battle_tower

	call BattleWinSlideInEnemyTrainerFrontpic
	ld c, 40
	call DelayFrames
	ld a, [wBattleType]
	cp BATTLETYPE_CANLOSE
	jr nz, .skip_heal
	ld a, [InBattleTowerBattle]
	bit 2, a
	jr nz, .skip_heal
	predef HealParty
.skip_heal
	ld a, [wMonStatusFlags]
	bit 0, a
	jr nz, .skip_win_loss_text
	call PrintWinLossText

.skip_win_loss_text
	ld a, [InBattleTowerBattle]
	bit 2, a
	ret nz
	jp HandleBattleReward

.battle_tower
	call BattleWinSlideInEnemyTrainerFrontpic
	ld c, 40
	call DelayFrames
	call EmptyBattleTextBox
	ld c, $3
	callba BattleTowerText
	call WaitPressAorB_BlinkCursor
	ld hl, wPayDayMoney
	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	ret nz
	call ClearTileMap
	jp ClearBGPalettes

HandleBattleReward:
	CheckEngine ENGINE_POKEMON_MODE
	ret nz
	ld a, [wAmuletCoin]
	and a
	call nz, .DoubleReward
	call .CheckMaxedOutMomMoney
	push af
	ld a, $0
	jr nc, .okay
	ld a, [wBankSavingMoney]
	and $7
	cp $3
	jr nz, .okay
	inc a

.okay
	ld b, a
	ld c, $4
.loop
	ld a, b
	and a
	jr z, .loop2
	call .SendMoneyToMom
	dec c
	dec b
	jr .loop

.loop2
	ld a, c
	and a
	jr z, .done
	call .AddMoneyToWallet
	dec c
	jr .loop2

.done
	call .DoubleReward
	call .DoubleReward
	pop af
	jr nc, .KeepItAll
	ld a, [wBankSavingMoney]
	and $7
	jr z, .KeepItAll
	ld hl, .SentToMomTexts
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp StdBattleTextBox

.KeepItAll
	ld hl, GotMoneyForWinningText
	jp StdBattleTextBox

.SendMoneyToMom
	push bc
	ld hl, wBattleReward + 2
	ld de, wBankMoney + 2
	call AddBattleMoneyToAccount
	pop bc
	ret

.AddMoneyToWallet
	push bc
	ld hl, wBattleReward + 2
	ld de, Money + 2
	call AddBattleMoneyToAccount
	pop bc
	ret

.DoubleReward
	ld hl, wBattleReward + 2
	sla [hl]
	dec hl
	rl [hl]
	dec hl
	rl [hl]
	ret nc
	ld a, $ff
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

.SentToMomTexts
	dw SentSomeToMomText
	dw SentHalfToMomText
	dw SentAllToMomText

.CheckMaxedOutMomMoney
	ld hl, wBankMoney + 2
	ld a, [hld]
	cp 999999 % $100
	ld a, [hld]
	sbc 999999 / $100 % $100
	ld a, [hl]
	sbc 999999 / $10000 % $100
	ret

AddBattleMoneyToAccount:
	ld c, $3
	and a
	push de
	push hl
	push bc
	ld b, h
	ld c, l
	pop bc
	pop hl
.loop
	ld a, [de]
	adc [hl]
	ld [de], a
	dec de
	dec hl
	dec c
	jr nz, .loop
	pop hl
	ld a, [hld]
	cp 999999 % $100
	ld a, [hld]
	sbc 999999 / $100 % $100
	ld a, [hl]
	sbc 999999 / $10000 % $100
	ret c
	ld [hl], 999999 / $10000 % $100
	inc hl
	ld [hl], 999999 / $100 % $100
	inc hl
	ld [hl], 999999 % $100
	ret

PlayVictoryMusic:
	push de
	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame
	ld de, MUSIC_WILD_VICTORY
	ld a, [wBattleMode]
	dec a
	jr nz, .trainer_victory
	push de
	call IsAnyMonHoldingExpShare
	pop de
	jr nz, .play_music
	ld hl, wPayDayMoney
	ld a, [hli]
	or [hl]
	jr nz, .play_music
	ld a, [wBattleParticipantsNotFainted]
	and a
	jr z, .lost
	jr .play_music

.trainer_victory
	ld de, MUSIC_GYM_VICTORY
	call IsJohtoGymLeader
	jr c, .play_music
	ld de, MUSIC_TRAINER_VICTORY

.play_music
	call PlayMusic

.lost
	pop de
	ret

; These functions check if the current opponent is a gym leader or one of a
; few other special trainers.

; Note: KantoGymLeaders is a subset of JohtoGymLeaders. If you wish to
; differentiate between the two, call IsKantoGymLeader first.

; The Lance and Red entries are unused for music checks; those trainers are
; accounted for elsewhere.

; Arguments:
; [OtherTrainerClass]
; Returns:
; c if in array

IsKantoGymLeader:
	ld hl, KantoGymLeaders
	jr IsGymLeaderCommon

IsJohtoGymLeader:
	ld hl, JohtoGymLeaders
	jr IsGymLeaderCommon

IsRijonGymLeader:
	ld hl, RijonGymLeaders
	jr IsGymLeaderCommon

IsNaljoGymLeader:
	ld hl, NaljoGymLeaders
IsGymLeaderCommon:
	push de
	ld a, [OtherTrainerClass]
	call IsInSingularArray
	pop de
	ret

JohtoGymLeaders:
	db BUGSY
	db WHITNEY
	db GOLD

NaljoGymLeaders:
	db JOSIAH
	db BROOKLYN
	db RINJI
	db EDISON
	db AYAKA
	db CADENCE
	db ANDRE
	db BRUCE
	db YUKI
	db SORA
	db MURA
	db DAICHI
; fallthrough
; these two entries are unused
	db CHAMPION
	db RED
; fallthrough
RijonGymLeaders:
	db KARPMAN
	db LILY
	db SPARKY
	db LOIS
	db KOJI
	db SHERYL
	db JOE
	db SILVER

KantoGymLeaders:
	db SABRINA
	db BLUE
	db BROWN
	db -1

HandleAftermath:
; Aftermath does max(1, [MaxHP] / 4) damage
; This routine also sets up the WRAM variables for the HP bar animation
; Arguments:
; hl = *MaxHP + 1
; Returns:
; z if target fainted due to aftermath
	ld a, [hld]
	ld c, a
	ld [wCurHPAnimMaxHP], a
	ld a, [hld]
	ld b, a
	ld [wCurHPAnimMaxHP + 1], a
	srl b
	rr c
	srl b
	rr c
	ld a, b
	or c
	jr nz, .min_hp
	inc c
.min_hp
	ld a, [hld]
	ld [wCurHPAnimOldHP], a
	or [hl]
	jr nz, .continue
	inc a
	ret

.continue
	sub c
	ld [wCurHPAnimNewHP], a
	ld a, [hl]
	ld [wCurHPAnimOldHP + 1], a
	sbc b
; Fainting condition
	jr nc, .load_new_hp
	xor a
	ld [hli], a
	ld [hld], a
	ld [wCurHPAnimNewHP], a
.load_new_hp
	ld [wCurHPAnimNewHP + 1], a
	ld a, [hli]
	or [hl]
	push af ; return this at the end
	ld a, [hBattleTurn]
	xor 1
	hlcoord 2, 2
	jr z, .got_coord
	hlcoord 10, 9
.got_coord
	ld [wWhichHPBar], a
	predef AnimateHPBar
	ld hl, BattleText_UsersHurtByStringBuffer1
	call StdBattleTextBox
	pop af
	ret

HandlePlayerMonFaint:
	call FaintYourPokemon
	ld hl, EnemyMonHP
	ld a, [hli]
	or [hl]
	call z, FaintEnemyPokemon
	ld a, [PlayerAbility]
	cp ABILITY_AFTERMATH
	jr nz, .skip_aftermath
	ld [wd265], a
	call GetAbilityName
	callba UsedContactMove
	jr nc, .skip_aftermath
	ld a, [hBattleTurn]
	push af
	call SetEnemyTurn
	ld hl, EnemyMonMaxHP + 1
	call HandleAftermath
	call z, FaintEnemyPokemon
	pop af
	ld [hBattleTurn], a
.skip_aftermath
	ld a, $1
	ld [wWhichMonFaintedFirst], a
	call PlayerMonFaintHappinessMod
	call CheckPlayerPartyForFitPkmn
	ld a, d
	and a
	jp z, LostBattle
	ld hl, EnemyMonHP
	ld a, [hli]
	or [hl]
	jr nz, .notfainted
	call UpdateBattleStateAndExperienceAfterEnemyFaint
	ld a, [wBattleMode]
	dec a
	jr nz, .trainer
	ld a, $1
	ld [BattleEnded], a
	ret

.trainer
	call CheckEnemyTrainerDefeated
	jp z, WinTrainerBattle

.notfainted
	call AskUseNextPokemon
	jr nc, .switch
	ld a, $1
	ld [BattleEnded], a
	ret

.switch
	call ForcePlayerMonChoice
	ld a, c
	and a
	ret nz
	ld a, $1
	ld [wPlayerAction], a
	call HandleEnemySwitch
	jp z, WildFled_EnemyFled_LinkBattleCanceled
	jp DoubleSwitch

PlayerMonFaintHappinessMod:
	ld a, [CurBattleMon]
	ld c, a
	ld hl, wBattleParticipantsNotFainted
	ld b, RESET_FLAG
	predef FlagAction
	ld hl, wEnemySubStatus3
	res SUBSTATUS_IN_LOOP, [hl]
	xor a
	ld [Danger], a
	ld hl, PlayerDamageTaken
	ld [hli], a
	ld [hl], a
	ld [BattleMonStatus], a
	call UpdateBattleMonInParty
	ld c, HAPPINESS_FAINTED
	; If TheirLevel > (YourLevel + 30), use a different parameter
	ld a, [BattleMonLevel]
	add 30
	ld b, a
	ld a, [EnemyMonLevel]
	cp b
	jr c, .got_param
	ld c, HAPPINESS_BEATENBYSTRONGFOE

.got_param
	ld a, [CurBattleMon]
	ld [wCurPartyMon], a
	callba ChangeHappiness
	ld a, [wBattleResult]
	and %11000000
	add $1
	ld [wBattleResult], a
	ld a, [wWhichMonFaintedFirst]
	and a
	ret

AskUseNextPokemon:
	call EmptyBattleTextBox
	call LoadTileMapToTempTileMap
; We don't need to be here if we're in a Trainer battle,
; as that decision is made for us.
	ld a, [wBattleMode]
	and a
	dec a
	ret nz

	ld hl, BattleText_UseNextMon
	call StdBattleTextBox
.loop
	lb bc, 1, 7
	call PlaceYesNoBox
	ld a, [wMenuCursorY]
	jr c, .pressed_b
	and a
	ret

.pressed_b
	ld a, [wMenuCursorY]
	cp $1 ; YES
	jr z, .loop
	ld hl, PartyMon1Speed
	ld de, EnemyMonSpeed
	jp TryToRunAwayFromBattle

ForcePlayerMonChoice:
	call EmptyBattleTextBox
	call LoadStandardMenuDataHeader
	call SetUpBattlePartyMenu_NoLoop
	call ForcePickPartyMonInBattle
	ld a, [wLinkMode]
	and a
	jr z, .skip_link
	ld a, $1
	ld [wPlayerAction], a
	call LinkBattleSendReceiveAction

.skip_link
	xor a
	ld [wPlayerAction], a
	ld hl, EnemyMonHP
	ld a, [hli]
	or [hl]
	jr nz, .send_out_pokemon

	call ClearSprites
	call ClearBGPalettes
	call _LoadHPBar
	call ExitMenu
	call LoadTileMapToTempTileMap
	call ApplyTilemapInVBlank
	ld b, SCGB_RAM
	predef GetSGBLayout
	call SetPalettes
	xor a
	ld c, a
	ret

.send_out_pokemon
	call ClearSprites
	ld a, [CurBattleMon]
	ld [LastPlayerMon], a
	ld a, [wCurPartyMon]
	ld [CurBattleMon], a
	call AddBattleParticipant
	call InitBattleMon
	call ResetPlayerStatLevels
	call ClearPalettes
	call DelayFrame
	call _LoadHPBar
	call CloseWindow
	ld b, SCGB_RAM
	predef GetSGBLayout
	call SetPalettes
	call SendOutPkmnText
	call NewBattleMonStatus
	call BreakAttraction
	call SendOutPlayerMon
	call EmptyBattleTextBox
	call LoadTileMapToTempTileMap
	call SetPlayerTurn
	call SpikesDamage
	ld a, $1
	and a
	ld c, a
	ret

PlayerPartyMonEntrance:
	ld a, [CurBattleMon]
	ld [LastPlayerMon], a
	ld a, [wCurPartyMon]
	ld [CurBattleMon], a
	call AddBattleParticipant
	call InitBattleMon
	call ResetPlayerStatLevels
	call SendOutPkmnText
	call NewBattleMonStatus
	call BreakAttraction
	call SendOutPlayerMon
	call EmptyBattleTextBox
	call LoadTileMapToTempTileMap
	call SetPlayerTurn
	jp SpikesDamage

SetUpBattlePartyMenu_NoLoop:
	call ClearBGPalettes
SetUpBattlePartyMenu: ; switch to fullscreen menu?
	callba LoadPartyMenuGFX
	callba InitPartyMenuWithCancel
	callba InitPartyMenuBGPal7
	jpba InitPartyMenuGFX

JumpToPartyMenuAndPrintText:
	callba WritePartyMenuTilemap
	callba PrintPartyMenuText
	call ApplyTilemapInVBlank
	call SetPalettes
	jp DelayFrame

SelectBattleMon:
	jpba PartyMenuSelect

PickPartyMonInBattle:
.loop
	ld a, $2 ; Which PKMN?
	ld [wPartyMenuActionText], a
	call JumpToPartyMenuAndPrintText
	call SelectBattleMon
	ret c
	call CheckIfCurPartyMonIsStillAlive
	jr z, .loop
	xor a
	ret

SwitchMonAlreadyOut:
	ld hl, CurBattleMon
	ld a, [wCurPartyMon]
	cp [hl]
	jr nz, .notout

	ld hl, BattleText_PkmnIsAlreadyOut
	call StdBattleTextBox
	scf
	ret

.notout
	xor a
	ret

ForcePickPartyMonInBattle:
; Can't back out.

.pick
	call PickPartyMonInBattle
	ret nc

	ld de, SFX_WRONG
	call PlayWaitSFX
	jr .pick

PickSwitchMonInBattle:
.pick
	call PickPartyMonInBattle
	ret c
	call SwitchMonAlreadyOut
	jr c, .pick
	xor a
	ret

ForcePickSwitchMonInBattle:
; Can't back out.

.pick
	call ForcePickPartyMonInBattle
	call SwitchMonAlreadyOut
	jr c, .pick

	xor a
	ret

LostBattle:
	ld a, 1
	ld [BattleEnded], a

	ld a, [InBattleTowerBattle]
	bit 0, a
	jr nz, .battle_tower

	ld a, [wBattleType]
	cp BATTLETYPE_CANLOSE
	jr nz, .not_canlose

; Remove the enemy from the screen.
	hlcoord 0, 0
	lb bc, 8, 21
	call ClearBox
	call BattleWinSlideInEnemyTrainerFrontpic

	ld c, 40
	call DelayFrames

	ld a, [wMonStatusFlags]
	bit 0, a
	jr nz, .skip_win_loss_text
	call PrintWinLossText
.skip_win_loss_text
	ret

.battle_tower
; Remove the enemy from the screen.
	hlcoord 0, 0
	lb bc, 8, 21
	call ClearBox
	call BattleWinSlideInEnemyTrainerFrontpic

	ld c, 40
	call DelayFrames

	call EmptyBattleTextBox
	ld c, 2
	callba BattleTowerText
	call WaitPressAorB_BlinkCursor
	call ClearTileMap
	jp ClearBGPalettes

.not_canlose
	ld a, [wLinkMode]
	and a
	jr nz, .LostLinkBattle

; Greyscale
	ld b, SCGB_BATTLE_GRAYSCALE
	predef GetSGBLayout
	call SetPalettes
	jr .end

.LostLinkBattle
	call UpdateEnemyMonInParty
	call CheckEnemyTrainerDefeated
	jr nz, .not_tied
	ld hl, TiedAgainstText
	ld a, [wBattleResult]
	and $c0
	add 2
	ld [wBattleResult], a
	jr .text

.not_tied
	ld hl, LostAgainstText
.text
	call StdBattleTextBox

.end
	scf
	ret

EnemyMonFaintedAnimation:
	hlcoord 12, 5
	decoord 12, 6
	jr MonFaintedAnimation

PlayerMonFaintedAnimation:
	hlcoord 1, 10
	decoord 1, 11
	; fallthrough

MonFaintedAnimation:
; disable joypad
	ld a, [wcfbe]
	push af
	set 6, a
	ld [wcfbe], a
	ld b, 7

.OuterLoop
	push bc
	push de
	push hl
	ld b, 6

.InnerLoop
	push bc
	push hl
	push de
	ld bc, 7
	rst CopyBytes
	pop de
	pop hl
	ld bc, -SCREEN_WIDTH
	add hl, bc
	push hl
	ld h, d
	ld l, e
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	pop bc
	dec b
	jr nz, .InnerLoop

	ld bc, 20
	add hl, bc
	ld de, .Spaces
	call PlaceText
	call Delay2
	pop hl
	pop de
	pop bc
	dec b
	jr nz, .OuterLoop

	pop af
	ld [wcfbe], a
	ret

.Spaces
	ctxt "       "
	done

SlideBattlePicOut:
	ld [hMapObjectIndexBuffer], a
	ld c, a
.loop
	push bc
	push hl
	ld b, $7
.loop2
	push hl
	call .DoFrame
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	dec b
	jr nz, .loop2
	ld c, 2
	call DelayFrames
	pop hl
	pop bc
	dec c
	jr nz, .loop
	ret

.DoFrame
	ld a, [hMapObjectIndexBuffer]
	ld c, a
	cp $8
	jr nz, .back
.forward
	ld a, [hli]
	ld [hld], a
	dec hl
	dec c
	jr nz, .forward
	ret

.back
	ld a, [hld]
	ld [hli], a
	inc hl
	dec c
	jr nz, .back
	ret

ForceEnemySwitch:
	call ResetEnemyBattleVars
	ld a, [wEnemySwitchMonIndex]
	dec a
	ld b, a
	call LoadEnemyPkmnToSwitchTo
	call ClearEnemyMonBox
	call NewEnemyMonStatus
	call ResetEnemyStatLevels
	call Function_SetEnemyPkmnAndSendOutAnimation
	call BreakAttraction
	jp ResetBattleParticipants

EnemySwitch:
	call CheckWhetherToAskSwitch
	jr nc, EnemySwitch_SetMode
	; Shift Mode
	call ResetEnemyBattleVars
	call CheckWhetherSwitchmonIsPredetermined
	jr c, .skip
	call FindPkmnInOTPartyToSwitchIntoBattle
.skip
	; 'b' contains the PartyNr of the Pkmn the AI will switch to
	call LoadEnemyPkmnToSwitchTo
	call OfferSwitch
	push af
	call ClearEnemyMonBox
	call Function_BattleTextEnemySentOut
	call Function_SetEnemyPkmnAndSendOutAnimation
	pop af
	jp c, EnemyAbilityOnMonEntrance
	; If we're here, then we're switching too
	xor a
	ld [wBattleParticipantsNotFainted], a
	ld [wBattleParticipantsIncludingFainted], a
	ld [wPlayerAction], a
	inc a
	ld [wEnemyIsSwitching], a
	call LoadTileMapToTempTileMap
	jp PlayerSwitch

EnemySwitch_SetMode:
	call ResetEnemyBattleVars
	call CheckWhetherSwitchmonIsPredetermined
	jr c, .skip
	call FindPkmnInOTPartyToSwitchIntoBattle
.skip
	; 'b' contains the PartyNr of the Pkmn the AI will switch to
	call LoadEnemyPkmnToSwitchTo
	ld a, 1
	ld [wEnemyIsSwitching], a
	call ClearEnemyMonBox
	call Function_BattleTextEnemySentOut
	jp Function_SetEnemyPkmnAndSendOutAnimation

CheckWhetherSwitchmonIsPredetermined:
; Returns index of enemy switchmon in b (0-5).
; Sets carry if:
;     Link opponent is switching
;     Enemy is switching to Pokemon 1-5
;     Enemy is switching to Pokemon 0 at the very start of battle
	ld a, [wLinkMode]
	and a
	jr z, .not_linked

	ld a, [wBattleAction]
	sub BATTLEACTION_SWITCH1
	ld b, a
	scf
	ret

.not_linked
	ld a, [wEnemySwitchMonIndex]
	and a
	jr z, .first_mon_to_be_sent_out

	dec a
	ld b, a
	scf
	ret

.first_mon_to_be_sent_out
	ld b, a
	ld a, [wBattleHasJustStarted]
	and a
	ret z
	scf
	ret

ResetEnemyBattleVars:
; and draw empty TextBox
	xor a
	ld [LastEnemyCounterMove], a
	ld [LastPlayerCounterMove], a
	ld [LastEnemyMove], a
	ld [CurEnemyMove], a
	dec a
	ld [wEnemyItemState], a
	xor a
	ld [wPlayerWrapCount], a
	hlcoord 18, 0
	ld a, 8
	call SlideBattlePicOut
	call EmptyBattleTextBox
	jp LoadStandardMenuDataHeader

ResetBattleParticipants:
	xor a
	ld [wBattleParticipantsNotFainted], a
	ld [wBattleParticipantsIncludingFainted], a
AddBattleParticipant:
	ld a, [CurBattleMon]
	ld c, a
	ld hl, wBattleParticipantsNotFainted
	ld b, SET_FLAG
	push bc
	predef FlagAction
	pop bc
	ld hl, wBattleParticipantsIncludingFainted
	predef_jump FlagAction

FindPkmnInOTPartyToSwitchIntoBattle:
	ld b, $ff
	ld a, $1
	ld [wCurHPAnimMaxHP], a
	ld [wCurHPAnimMaxHP + 1], a
.loop
	ld hl, wCurHPAnimMaxHP
	sla [hl]
	inc hl
	sla [hl]
	inc b
	ld a, [OTPartyCount]
	cp b
	jp z, ScoreMonTypeMatchups
	ld a, [CurOTMon]
	cp b
	jr z, .discourage
	ld hl, OTPartyMon1HP
	push bc
	ld a, b
	call GetPartyLocation
	ld a, [hli]
	ld c, a
	ld a, [hl]
	or c
	pop bc
	jr z, .discourage
	call LookUpTheEffectivenessOfEveryMove
	call IsThePlayerPkmnTypesEffectiveAgainstOTPkmn
	jr .loop

.discourage
	ld hl, wCurHPAnimMaxHP + 1
	set 0, [hl]
	jr .loop

LookUpTheEffectivenessOfEveryMove:
	push bc
	ld hl, OTPartyMon1Moves
	ld a, b
	call GetPartyLocation
	pop bc
	ld e, NUM_MOVES + 1
.loop
	dec e
	ret z
	ld a, [hli]
	and a
	ret z
	push hl
	push de
	push bc
	dec a
	ld hl, Moves
	ld bc, MOVE_LENGTH
	rst AddNTimes
	ld de, wEnemyMoveStruct
	ld a, BANK(Moves)
	call FarCopyBytes
	call SetEnemyTurn
	predef BattleCheckTypeMatchup
	pop bc
	pop de
	pop hl
	ld a, [wd265] ; Get The Effectiveness Modifier
	cp 10 + 1 ; 1.0 + 0.1
	jr c, .loop
	ld hl, wCurHPAnimMaxHP
	set 0, [hl]
	ret

IsThePlayerPkmnTypesEffectiveAgainstOTPkmn:
; Calculates the effectiveness of the types of the PlayerPkmn
; against the OTPkmn
	push bc
	ld hl, OTPartyCount
	ld a, b
	inc a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	dec a
	ld hl, BaseData + 7 ; type
	ld bc, BaseData1 - BaseData0
	rst AddNTimes
	ld de, EnemyMonType
	ld bc, 2
	ld a, BANK(BaseData)
	call FarCopyBytes
	ld a, [BattleMonType1]
	ld [wPlayerMoveStruct + MOVE_TYPE], a
	call SetPlayerTurn
	predef BattleCheckTypeMatchup
	ld a, [wd265]
	cp 10 + 1 ; 1.0 + 0.1
	jr nc, .super_effective
	ld a, [BattleMonType2]
	ld [wPlayerMoveStruct + MOVE_TYPE], a
	predef BattleCheckTypeMatchup
	ld a, [wd265]
	cp 10 + 1 ; 1.0 + 0.1
	jr nc, .super_effective
	pop bc
	ret

.super_effective
	pop bc
	ld hl, wCurHPAnimMaxHP
	bit 0, [hl]
	jr nz, .reset
	inc hl
	set 0, [hl]
	ret

.reset
	res 0, [hl]
	ret

ScoreMonTypeMatchups:
.loop1
	ld hl, wCurHPAnimMaxHP
	sla [hl]
	inc hl
	sla [hl]
	jr nc, .loop1
	ld a, [OTPartyCount]
	ld b, a
	ld c, [hl]
.loop2
	sla c
	jr nc, .okay
	dec b
	jr z, .loop5
	jr .loop2

.okay
	ld a, [wCurHPAnimMaxHP]
	and a
	jr z, .okay2
	ld b, $ff
	ld c, a
.loop3
	inc b
	sla c
	jr nc, .loop3
	ret

.okay2
	ld b, $ff
	ld a, [wCurHPAnimMaxHP + 1]
	ld c, a
.loop4
	inc b
	sla c
	jr c, .loop4
	ret

.loop5
	ld a, [OTPartyCount]
	ld b, a
	call BattleRandom
	and $7
	cp b
	jr nc, .loop5
	ld b, a
	ld a, [CurOTMon]
	cp b
	jr z, .loop5
	ld hl, OTPartyMon1HP
	push bc
	ld a, b
	call GetPartyLocation
	pop bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	or c
	jr z, .loop5
	ret

LoadEnemyPkmnToSwitchTo:
	; 'b' contains the PartyNr of the Pkmn the AI will switch to
	ld a, [EnemyAbility]
	cp ABILITY_NATURAL_CURE
	jr nz, .no_heal
	push bc
	ld a, [CurOTMon]
	ld hl, OTPartyMon1Status
	call GetPartyLocation
	ld [hl], 0
	pop bc
.no_heal
	ld a, b
	ld [wCurPartyMon], a
	ld hl, OTPartyMon1Level
	call GetPartyLocation
	ld a, [hl]
	ld [CurPartyLevel], a
	ld a, [wCurPartyMon]
	inc a
	ld hl, OTPartyCount
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [TempEnemyMonSpecies], a
	ld [wCurPartySpecies], a
	call LoadEnemyMon

	ld a, [wCurPartySpecies]
	ld hl, EnemyMonHP
	ld a, [hli]
	ld [wEnemyHPAtTimeOfPlayerSwitch], a
	ld a, [hl]
	ld [wEnemyHPAtTimeOfPlayerSwitch + 1], a
	ret

CheckWhetherToAskSwitch:
; Determine whether to bring up the shift dialogue.
;  c: Yes (SHIFT)
; nc: No  (SET)

	; Don't ask if this is the very start of the battle.
	ld a, [wBattleHasJustStarted]
	dec a
	ret z

	; Don't ask if you only have one party member.
	ld a, [wPartyCount]
	dec a
	ret z

	; Don't ask in a link battle.
	ld a, [wLinkMode]
	and a
	ret nz

	; Don't ask if you're on SET mode.
	ld a, [wOptions]
	bit BATTLE_SHIFT, a
	ret nz

	; Don't ask if your Pokemon fainted as well.
	ld a, [wCurPartyMon]
	push af
	ld a, [CurBattleMon]
	ld [wCurPartyMon], a
	callba CheckIfOnlyAliveMonIsCurPartyMon
	pop bc
	ld a, b
	ld [wCurPartyMon], a
	jr c, .return_nc
	scf
	ret

.return_nc
	and a
	ret

OfferSwitch:
	ld a, [wCurPartyMon]
	push af
	callba Battle_GetTrainerName
	ld hl, BattleText_EnemyIsAboutToUseWillPlayerChangePkmn
	call StdBattleTextBox
	lb bc, 1, 7
	call PlaceYesNoBox
	ld a, [wMenuCursorY]
	dec a
	jr nz, .said_no
	call SetUpBattlePartyMenu_NoLoop
	call PickSwitchMonInBattle
	jr c, .canceled_switch
	ld a, [CurBattleMon]
	ld [LastPlayerMon], a
	ld a, [wCurPartyMon]
	ld [CurBattleMon], a
	call ClearPalettes
	call DelayFrame
	call _LoadHPBar
	pop af
	ld [wCurPartyMon], a
	xor a
	ld [CurEnemyMove], a
	ld [CurPlayerMove], a
	and a
	ret

.canceled_switch
	call ClearPalettes
	call DelayFrame
	call _LoadHPBar

.said_no
	pop af
	ld [wCurPartyMon], a
	scf
	ret

ClearEnemyMonBox:
	xor a
	ld [hBGMapMode], a
	call ExitMenu
	call ClearSprites
	hlcoord 1, 0
	lb bc, 4, 10
	call ClearBox
	call ApplyTilemapInVBlank
	jp FinishBattleAnim

Function_BattleTextEnemySentOut:
	callba Battle_GetTrainerName
	ld hl, BattleText_EnemySentOut
	call StdBattleTextBox
	jp ApplyTilemapInVBlank

Function_SetEnemyPkmnAndSendOutAnimation:
	ld a, [TempEnemyMonSpecies]
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	call GetBaseData
	ld a, OTPARTYMON
	ld [wMonType], a
	predef CopyPkmnToTempMon
	call GetMonFrontpic

	xor a
	ld [wNumHits], a
	ld [wBattleAnimParam], a
	call SetEnemyTurn
	ld de, ANIM_SEND_OUT_MON
	call Call_PlayBattleAnim

	call BattleCheckEnemyShininess
	jr nc, .not_shiny
	ld a, 1 ; shiny anim
	ld [wBattleAnimParam], a
	ld de, ANIM_SEND_OUT_MON
	call Call_PlayBattleAnim
.not_shiny
	ld bc, TempMonSpecies
	callba CheckFaintedFrzSlp
	jr c, .skip_cry
	;call CheckBattleScene
	;jr c, .cry_no_anim
	hlcoord 12, 0
	ld d, $0
	ld e, ANIM_MON_SLOW
	predef AnimateFrontpic
	jr .skip_cry

.cry_no_anim
	ld a, $f
	ld [CryTracks], a
	ld a, [TempEnemyMonSpecies]
	call PlayStereoCry

.skip_cry
	call UpdateEnemyHUD
	ld a, $1
	ld [hBGMapMode], a
	ret

NewEnemyMonStatus:
	xor a
	ld [LastEnemyCounterMove], a
	ld [LastPlayerCounterMove], a
	ld [LastEnemyMove], a
	ld hl, wEnemySubStatus1
rept 4
	ld [hli], a
endr
	ld [hl], a
	ld [EnemyDisableCount], a
	ld [EnemyFuryCutterCount], a
	ld [EnemyProtectCount], a
	ld [EnemyDisabledMove], a
	ld [wEnemyMinimized], a
	ld [wPlayerWrapCount], a
	ld [wEnemyWrapCount], a
	ld [EnemyTurnsTaken], a
	ld hl, wPlayerSubStatus5
	res SUBSTATUS_CANT_RUN, [hl]
	ret

ResetEnemyStatLevels:
	ld a, BASE_STAT_LEVEL
	ld b, NUM_LEVEL_STATS - 1
	ld hl, EnemyStatLevels
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	ld hl, EnemyStatLevels
	ld a, [EnemyMonItem]
	jp ApplyHeldRingEffect

CheckPlayerPartyForFitPkmn:
; Has the player any Pkmn in his Party that can fight?
	ld a, [wPartyCount]
	ld e, a
	xor a
	ld hl, PartyMon1HP
	ld bc, wPartyMon2 - (wPartyMon1 + 1)
.asm_3d87e
	or [hl]
	inc hl
	or [hl]
	add hl, bc
	dec e
	jr nz, .asm_3d87e
	ld d, a
	ret

CheckIfCurPartyMonIsStillAlive:
	ld a, [wCurPartyMon]
	ld hl, PartyMon1HP
	call GetPartyLocation
	ld a, [hli]
	or [hl]
	ret nz

	ld a, [wBattleHasJustStarted]
	and a
	jr nz, .no_text
	ld hl, wPartySpecies
	ld a, [wCurPartyMon]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	cp EGG
	ld hl, BattleText_AnEGGCantBattle
	jr z, .print_text

	ld hl, BattleText_TheresNoWillToBattle

.print_text
	call StdBattleTextBox

.no_text
	xor a
	ret

TryToRunAwayFromBattle:
; Run away from battle, with or without item
	ld a, [wBattleType]
	cp BATTLETYPE_DEBUG
	jp z, .can_escape
	cp BATTLETYPE_TRAP
	jp z, .cant_escape
	cp BATTLETYPE_CELEBI
	jp z, .cant_escape
	cp BATTLETYPE_SHINY
	jp z, .cant_escape
	cp BATTLETYPE_SUICUNE
	jp z, .cant_escape
	call CheckIfInEagulouParkBattle
	jp z, .can_escape
	
	ld a, [wLinkMode]
	and a
	jp nz, .can_escape

	ld a, [wBattleMode]
	dec a
	jp nz, .cant_run_from_trainer

	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_CANT_RUN, a
	jp nz, .cant_escape
	ld a, [wPlayerSubStatus2]
	bit SUBSTATUS_FINAL_CHANCE, a
	jp nz, .cant_escape

	call CheckEnemyArenaTrap
	jp c, .cant_escape

	ld a, [wPlayerWrapCount]
	and a
	jp nz, .cant_escape

	push hl
	push de
	ld a, [BattleMonItem]
	ld [wd265], a
	ld b, a
	call GetItemHeldEffect ; this is in ROM0
	ld a, b
	cp HELD_ESCAPE
	pop de
	pop hl
	jr nz, .no_flee_item

	call GetItemName
	jr .flee_using_text

.no_flee_item
	ld a, [PlayerAbility]
	ld [wd265], a
	cp ABILITY_RUN_AWAY
	jr nz, .no_flee_ability
	call GetAbilityName
.flee_using_text
	call SetPlayerTurn
	ld hl, BattleText_UserFledUsingItsStringBuffer1
	call StdBattleTextBox
	jp .can_escape

.no_flee_ability
	ld a, [wNumFleeAttempts]
	inc a
	ld [wNumFleeAttempts], a

	ld a, [hli]
	ld l, [hl]
	ld h, a

	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	ld e, a
	ld d, b
; hl = player speed
; de = enemy speed

	push hl
	push de
	call Call_LoadTempTileMapToTileMap
	pop de
	pop hl

; compare hl and de
	ld a, l
	sub e
	ld a, h
	sbc d
	jr nc, .can_escape
; multiply player speed by 32
	add hl, hl ; x2
	add hl, hl ; x4
	add hl, hl ; x8
	add hl, hl ; x16
	add hl, hl ; x32

; store PSpeed*32 into dividend
	ld a, h
	ld [hDividend], a
	ld a, l
	ld [hDividend + 1], a

; divide ESpeed by 4
	srl d
	rr e
	srl d
	rr e
	ld a, e
	and a ; prevent division by 0
	jr z, .can_escape
; calculate PSpeed*32/(ESpeed/4)
	ld [hDivisor], a
	ld b, 2
	predef Divide
	ld a, [hQuotient + 1]
	and a ; player can escape if result is greater than 255
	jr nz, .can_escape
	ld a, [wNumFleeAttempts]
	ld c, a
	ld a, [hQuotient + 2]
	jr .handleLoop
.loop
	add 30
	jr c, .can_escape
.handleLoop
	dec c
	jr nz, .loop
	ld c, a
	call BattleRandom
	ld b, a
	ld a, c
	cp b
	jr nc, .can_escape
	ld a, $1
	ld [wPlayerAction], a
	ld hl, BattleText_CantEscape
	jr .print_inescapable_text

.cant_escape
	ld hl, BattleText_CantEscape
	jr .print_inescapable_text

.cant_run_from_trainer
	ld a, [InBattleTowerBattle]
	bit 1, a
	jr nz, .dont_ask_forfeit
	and $5
	jr nz, .ask_forfeit
.dont_ask_forfeit
	ld hl, BattleText_TheresNoEscapeFromTrainerBattle

.print_inescapable_text
	call StdBattleTextBox
.didnt_flee
	ld a, $1
	ld [wFailedToFlee], a
	call LoadTileMapToTempTileMap
	and a
	ret

.ask_forfeit
	ld hl, BattleText_ForfeitChallenge
	call StdBattleTextBox
	call YesNoBox
	jr c, .didnt_flee

.can_escape
	ld a, [wLinkMode]
	and a
	ld a, DRAW
	jr z, .fled
	call LoadTileMapToTempTileMap
	xor a
	ld [wPlayerAction], a
	ld a, $f
	ld [CurMoveNum], a
	xor a
	ld [CurPlayerMove], a
	call LinkBattleSendReceiveAction
	call Call_LoadTempTileMapToTileMap

	; Got away safely
	ld a, [wBattleAction]
	cp BATTLEACTION_FORFEIT
	ld a, DRAW
	jr z, .fled
	dec a
.fled
	ld b, a
	ld a, [wBattleResult]
	and $c0
	add b
	ld [wBattleResult], a
	call StopDangerSound
	push de
	ld de, SFX_RUN
	call WaitPlaySFX
	pop de
	call WaitSFX
	ld hl, BattleText_GotAwaySafely
	call StdBattleTextBox
	call WaitSFX
	call LoadTileMapToTempTileMap
	scf
	ret

InitBattleMon:
	ld a, 1
	ld [wPlayerJustSentMonOut], a
	ld a, MON_SPECIES
	call GetPartyParamLocation
	ld de, BattleMonSpecies
	ld bc, MON_ID
	rst CopyBytes
	ld bc, MON_DVS - MON_ID
	add hl, bc
	ld de, BattleMonDVs
	ld bc, MON_PKRUS - MON_DVS
	rst CopyBytes
	inc hl
	inc hl
	inc hl
	ld de, BattleMonLevel
	ld bc, PARTYMON_STRUCT_LENGTH - MON_LEVEL
	rst CopyBytes
	ld a, [BattleMonSpecies]
	ld [TempBattleMonSpecies], a
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	call GetBaseData
	ld a, [BaseType1]
	ld [BattleMonType1], a
	ld a, [BaseType2]
	ld [BattleMonType2], a
	ld hl, wPartyMonNicknames
	ld a, [CurBattleMon]
	call SkipNames
	ld de, BattleMonNick
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	ld hl, BattleMonAttack
	ld de, PlayerStats
	ld bc, PARTYMON_STRUCT_LENGTH - MON_ATK
	rst CopyBytes
	call CalcPlayerAbility
	call ApplyStatusEffectOnPlayerStats
	jpba BadgeStatBoosts

BattleCheckPlayerShininess:
	call GetPartyMonDVs
	jpba CheckShininessHL

BattleCheckEnemyShininess:
	call GetEnemyMonDVs
	jpba CheckShininessHL

GetPartyMonDVs:
	ld hl, BattleMonDVs
	ld a, [wPlayerSubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	ret z
	ld hl, PartyMon1DVs
	ld a, [CurBattleMon]
	jp GetPartyLocation

GetEnemyMonDVs:
	ld hl, EnemyMonDVs
	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	ret z
	ld hl, wEnemyBackupDVs
	ld a, [wBattleMode]
	dec a
	ret z
	ld hl, OTPartyMon1DVs
	ld a, [CurOTMon]
	jp GetPartyLocation

ResetPlayerStatLevels:
	ld a, BASE_STAT_LEVEL
	ld b, NUM_LEVEL_STATS - 1
	ld hl, PlayerStatLevels
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	ld hl, PlayerStatLevels
	ld a, [BattleMonItem]

ApplyHeldRingEffect::
	ld a, b
	push hl
	ld hl, .StatRings
	ld e, 2
	call IsInArray
	jr nc, .nope
	inc hl
	ld a, [hl]
	swap a
	and $f
	ld c, a
	ld a, [hl]
	and $f
	ld e, a
	pop hl
	push hl
	ld b, 0
	add hl, bc
	ld a, [hl]
	cp 13
	jr nc, .skip
	inc [hl]
.skip
	pop hl
	ld d, 0
	add hl, de
	ld a, [hl]
	cp 2
	ret c
	dec [hl]
	ret

.nope
	pop hl
	ret

.StatRings
statring: MACRO
	db \1
	dn \2, \3
ENDM
	statring GRASS_RING,     SP_DEFENSE, DEFENSE
	statring FIRE_RING,      DEFENSE,    SP_DEFENSE
	statring WATER_RING,     ATTACK,     EVASION
	statring THUNDER_RING,   SP_ATTACK,  ACCURACY
	statring MOON_RING,      EVASION,    SPEED
	statring SHINY_RING,     ACCURACY,   EVASION
	statring DAWN_RING,      SPEED,      ACCURACY
	db $ff

InitEnemyMon:
	ld a, [wCurPartyMon]
	ld hl, OTPartyMon1Species
	call GetPartyLocation
	ld de, EnemyMonSpecies
	ld bc, MON_ID
	rst CopyBytes
	ld bc, MON_DVS - MON_ID
	add hl, bc
	ld de, EnemyMonDVs
	ld bc, MON_PKRUS - MON_DVS
	rst CopyBytes
	inc hl
	inc hl
	inc hl
	ld de, EnemyMonLevel
	ld bc, PARTYMON_STRUCT_LENGTH - MON_LEVEL
	rst CopyBytes
	ld a, [EnemyMonSpecies]
	ld [wCurSpecies], a
	call GetBaseData
	ld hl, OTPartyMonNicknames
	ld a, [wCurPartyMon]
	call SkipNames
	ld de, EnemyMonNick
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	ld hl, EnemyMonAttack
	ld de, EnemyStats
	ld bc, PARTYMON_STRUCT_LENGTH - MON_ATK
	rst CopyBytes
	call CalcEnemyAbility
	call ApplyStatusEffectOnEnemyStats
	ld hl, BaseType1
	ld de, EnemyMonType1
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld hl, BaseStats
	ld de, EnemyMonBaseStats
	ld b, 5
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	ld a, [wCurPartyMon]
	ld [CurOTMon], a
	ret

SwitchPlayerMon:
	call ClearSprites
	ld a, [CurBattleMon]
	ld [LastPlayerMon], a
	ld a, [wCurPartyMon]
	ld [CurBattleMon], a
	call AddBattleParticipant
	call InitBattleMon
	call ResetPlayerStatLevels
	call NewBattleMonStatus
	call BreakAttraction
	call SendOutPlayerMon
	call EmptyBattleTextBox
	call LoadTileMapToTempTileMap
	ld hl, EnemyMonHP
	ld a, [hli]
	or [hl]
	ret

SendOutPlayerMon_PModeBattleStart:
	call SendOutPlayerMon_InitVars
	jr SendOutPlayerMon_continue

SendOutPlayerMon:
	hlcoord 1, 5
	lb bc, 7, 8
	call ClearBox
	call ApplyTilemapInVBlank
	xor a
	ld [hBGMapMode], a
	call GetMonBackpic
	call SendOutPlayerMon_InitVars
	ld de, ANIM_SEND_OUT_MON
	call Call_PlayBattleAnim
SendOutPlayerMon_continue:
	call BattleCheckPlayerShininess
	jr nc, .notShiny
	ld a, 1
	ld [wBattleAnimParam], a
	ld de, ANIM_SEND_OUT_MON
	call Call_PlayBattleAnim
.notShiny
	ld a, MON_SPECIES
	call GetPartyParamLocation
	ld b, h
	ld c, l
	callba CheckFaintedFrzSlp
	jr c, .statused
	ld a, $f0
	ld [CryTracks], a
	ld a, [wCurPartySpecies]
	call PlayStereoCry

.statused
	call UpdatePlayerHUD
	ld a, $1
	ld [hBGMapMode], a
	ret

SendOutPlayerMon_InitVars:
	xor a
	ld [hGraphicStartTile], a
	ld [wd0d2], a
	ld [CurMoveNum], a
	ld [TypeModifier], a
	ld [wPlayerMoveStruct + MOVE_ANIM], a
	ld [LastEnemyCounterMove], a
	ld [LastPlayerCounterMove], a
	ld [LastPlayerMove], a
	call CheckAmuletCoin
	call FinishBattleAnim
	xor a
	ld [wEnemyWrapCount], a
	call SetPlayerTurn
	xor a
	ld [wNumHits], a
	ld [wBattleAnimParam], a
	ret

NewBattleMonStatus:
	xor a
	ld [LastEnemyCounterMove], a
	ld [LastPlayerCounterMove], a
	ld [LastPlayerMove], a
	ld hl, wPlayerSubStatus1
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, PlayerUsedMoves
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [PlayerDisableCount], a
	ld [PlayerFuryCutterCount], a
	ld [PlayerProtectCount], a
	ld [DisabledMove], a
	ld [wPlayerMinimized], a
	ld [wEnemyWrapCount], a
	ld [wPlayerWrapCount], a
	ld [PlayerTurnsTaken], a
	ld hl, wEnemySubStatus5
	res SUBSTATUS_CANT_RUN, [hl]
	ret

BreakAttraction:
	ld hl, wPlayerSubStatus1
	res SUBSTATUS_IN_LOVE, [hl]
	ld hl, wEnemySubStatus1
	res SUBSTATUS_IN_LOVE, [hl]
	ret

SpikesDamage:
	call GetUserAbility
	cp ABILITY_LEVITATE
	ret z
	ld hl, wPlayerScreens
	ld de, BattleMonType
	ld bc, UpdatePlayerHUD
	ld a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wEnemyScreens
	ld de, EnemyMonType
	ld bc, UpdateEnemyHUD
.ok
	bit SCREENS_LAVA_POOL, [hl]
	jr z, .spikes
	push hl
	push de
	push bc

	ld a, [de]
	cp FIRE
	jr z, .no_pool
	cp FLYING
	jr z, .no_pool
	inc de
	ld a, [de]
	cp FIRE
	jr z, .no_pool
	cp FLYING
	jr z, .no_pool

	call GetUserItem ; this is in ROM0
	ld a, b
	cp HELD_PREVENT_BURN
	jr z, .no_pool

	callba SafeCheckSafeguard
	jr nz, .no_pool

	; already burned
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and 1 << BRN
	jr nz, .no_pool

	; Lava Pool residual animation
	call SwitchTurn
	ld de, LAVA_POOL
	ld a, 1
	ld [wBattleAnimParam], a
;	xor a
;	ld [wNumHits], a
	call Call_PlayBattleAnim_OnlyIfVisible
	call SwitchTurn

	ld a, BATTLE_VARS_STATUS
	call GetBattleVarAddr
	set BRN, [hl]
	call UpdateUserInParty
	call ApplyBrnEffectOnAttack
	ld de, ANIM_BRN
	call Call_PlayBattleAnim_OnlyIfVisible

	ld hl, BattleText_UserBurnedByLavaPool
	call StdBattleTextBox

	pop hl
	push hl
	call _hl_
	call ApplyTilemapInVBlank

.no_pool
	pop bc
	pop de
	pop hl
.spikes
	ld a, [hl]
	and $3
	ret z

	; Flying-types aren't affected by Spikes.
	ld a, [de]
	cp FLYING
	ret z
	inc de
	ld a, [de]
	cp FLYING
	ret z

	ld a, [hl]
	and $3

	push bc
	push af

	ld hl, BattleText_UserHurtBySpikes ; "hurt by SPIKES!"
	call StdBattleTextBox

	pop af
	add a
	cpl
	add 11
	ld [hDivisor], a
	call GetMaxHP
	ld a, b
	ld [hDividend], a
	ld a, c
	ld [hDividend + 1], a
	ld b, 2
	predef Divide
	ld a, [hQuotient + 1]
	ld b, a
	ld a, [hQuotient + 2]
	ld c, a
	or b
	jr nz, .damage
	inc c
.damage
	call SubtractHPFromUser

	pop hl
	call _hl_

	jp ApplyTilemapInVBlank

PursuitSwitch:
	ld a, BATTLE_VARS_MOVE
	call GetBattleVar
	ld b, a
	call GetMoveEffect
	ld a, b
	cp EFFECT_PURSUIT
	jr nz, .done

	ld a, [CurBattleMon]
	push af

	ld hl, DoPlayerTurn
	ld a, [hBattleTurn]
	and a
	jr z, .do_turn
	ld a, [LastPlayerMon]
	ld [CurBattleMon], a
	ld hl, DoEnemyTurn
.do_turn
	ld a, BANK(DoPlayerTurn)
	call FarCall_hl

	ld a, BATTLE_VARS_MOVE
	call GetBattleVarAddr
	ld a, $ff
	ld [hl], a

	pop af
	ld [CurBattleMon], a

	ld a, [hBattleTurn]
	and a
	jr z, .check_enemy_fainted

	ld a, [LastPlayerMon]
	call UpdateBattleMon
	ld hl, BattleMonHP
	ld a, [hli]
	or [hl]
	jr nz, .done

	ld a, $f0
	ld [CryTracks], a
	ld a, [BattleMonSpecies]
	call PlayStereoCry
	ld a, [LastPlayerMon]
	ld c, a
	ld hl, wBattleParticipantsNotFainted
	ld b, RESET_FLAG
	predef FlagAction
	call PlayerMonFaintedAnimation
	ld hl, BattleText_PkmnFainted
	jr .done_fainted

.check_enemy_fainted
	ld hl, EnemyMonHP
	ld a, [hli]
	or [hl]
	jr nz, .done

	ld de, SFX_KINESIS
	call PlayWaitSFX
	ld de, SFX_FAINT
	call PlayWaitSFX
	call EnemyMonFaintedAnimation
	call GetEnemyFaintedText

.done_fainted
	call StdBattleTextBox
	scf
	ret

.done
	and a
	ret

RecallPlayerMon:
	ld a, [hBattleTurn]
	push af
	xor a
	ld [hBattleTurn], a
	ld [wNumHits], a
	ld de, ANIM_RETURN_MON
	call Call_PlayBattleAnim
	pop af
	ld [hBattleTurn], a
	ret

HandleHealingItems:
	ld a, [hLinkPlayerNumber]
	cp $1
	jr z, .player_1
	call SetPlayerTurn
	call HandleHPHealingItem
	call UseHeldStatusHealingItem
	call UseConfusionHealingItem
	call SetEnemyTurn
	call HandleHPHealingItem
	call UseHeldStatusHealingItem
	jp UseConfusionHealingItem

.player_1
	call SetEnemyTurn
	call HandleHPHealingItem
	call UseHeldStatusHealingItem
	call UseConfusionHealingItem
	call SetPlayerTurn
	call HandleHPHealingItem
	call UseHeldStatusHealingItem
	jp UseConfusionHealingItem

HandleHPHealingItem:
	call GetOpponentItem ; this is in ROM0
	ld a, b
	cp HELD_BERRY
	ret nz
	call SwitchTurn
	ld a, [hl]
	cp SITRUS_BERRY
	jr nz, .not_sitrus_berry
	call GetQuarterMaxHP
.not_sitrus_berry
	push bc
	call GetThirdMaxHP ; hl = max hp + 1, bc = max(1, (1/3) * ([max hp]))
	ld d, b
	ld e, c
	pop bc
	call SwitchTurn
	dec hl
	dec hl
	ld a, [hld]
	ld [wCurHPAnimOldHP], a
	ld a, [hli]
	ld [wCurHPAnimOldHP + 1], a
	cp d
	jr c, .go
	ret nz
	ld a, [hl]
	cp e
	jr z, .go
	ret nc
.go
	ld a, [hld]
	add c
	ld c, a
	ld a, [hli]
	adc 0
	ld b, a
	push hl
	inc hl
	inc hl
	ld a, [hld]
	cp c
	ld a, [hl]
	sbc b
	jr nc, .load_bc
	ld b, [hl]
	inc hl
	ld c, [hl]
.load_bc
	push bc
	ld a, c
	ld [wCurHPAnimNewHP], a
	ld a, b
	ld [wCurHPAnimNewHP + 1], a
	call ItemRecoveryAnim
	ld a, [hBattleTurn]
	ld [wWhichHPBar], a
	and a
	hlcoord 2, 2
	jr z, .got_hp_bar_coords
	hlcoord 10, 9

.got_hp_bar_coords
	ld [wWhichHPBar], a
	predef AnimateHPBar
	pop bc
	pop hl
	ld [hl], c
	dec hl
	ld [hl], b
UseOpponentItem:
	call RefreshBattleHuds
	call GetOpponentItem ; this is in ROM0
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	callba ConsumeHeldItem
	ld a, [wStringBuffer1]
	ld hl, .Vowels
	call IsInSingularArray
	ld hl, RecoveredUsingText
	jr nc, .okay
	ld hl, RecoveredUsingText2
.okay
	call StdBattleTextBox
	call GetTargetAbility
	cp ABILITY_UNBURDEN
	ret nz
	ld a, BATTLE_VARS_SUBSTATUS2_OPP
	call GetBattleVarAddr
	set SUBSTATUS_UNBURDEN, [hl]
	ret

.Vowels
	db "AEIOUaeiou"
	db -1

ItemRecoveryAnim:
	push hl
	push de
	push bc
	call EmptyBattleTextBox
	ld a, RECOVER
	ld [FXAnimIDLo], a
	call SwitchTurn
	xor a
	ld [wNumHits], a
	ld [FXAnimIDHi], a
	predef PlayBattleAnim
	call SwitchTurn
	pop bc
	pop de
	pop hl
	ret

UseHeldStatusHealingItem:
	call GetOpponentItem ; this is in ROM0
	ld hl, .Statuses
.loop
	ld a, [hli]
	cp $ff
	ret z
	inc hl
	cp b
	jr nz, .loop
	dec hl
	ld b, [hl]
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	and b
	ret z
	xor a
	ld [hl], a
	push bc
	call UpdateOpponentInParty
	pop bc
	ld a, BATTLE_VARS_SEMISTATUS_OPP
	call GetBattleVarAddr
	res SEMISTATUS_TOXIC, [hl]
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVarAddr
	res SUBSTATUS_NIGHTMARE, [hl]
	ld a, b
	cp ALL_STATUS
	jr nz, .skip_confuse
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVarAddr
	res SUBSTATUS_CONFUSED, [hl]

.skip_confuse
	ld hl, CalcEnemyStats
	ld a, [hBattleTurn]
	and a
	jr z, .got_pointer
	ld hl, CalcPlayerStats

.got_pointer
	call SwitchTurn
	ld a, BANK(CalcEnemyStats)
	call FarCall_hl
	call SwitchTurn
	call ItemRecoveryAnim
	call UseOpponentItem
	ld a, $1
	and a
	ret

.Statuses
	db HELD_HEAL_POISON, 1 << PSN
	db HELD_HEAL_FREEZE, 1 << FRZ
	db HELD_HEAL_BURN, 1 << BRN
	db HELD_HEAL_SLEEP, SLP
	db HELD_HEAL_PARALYZE, 1 << PAR
	db HELD_HEAL_STATUS, ALL_STATUS
	db $ff

UseConfusionHealingItem:
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	bit SUBSTATUS_CONFUSED, a
	ret z
	call GetOpponentItem ; this is in ROM0
	ld a, b
	cp HELD_HEAL_CONFUSION
	jr z, .heal_status
	cp HELD_HEAL_STATUS
	ret nz

.heal_status
	ld a, [hl]
	ld [wd265], a
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVarAddr
	res SUBSTATUS_CONFUSED, [hl]
	call GetItemName
	call ItemRecoveryAnim
	ld hl, BattleText_ItemHealedConfusion
	call StdBattleTextBox
	ld a, [hBattleTurn]
	and a
	jr nz, .do_partymon
	call GetOTPartymonItem
	xor a
	ld [bc], a
	ld a, [wBattleMode]
	dec a
	ret z
	ld [hl], $0
	ret

.do_partymon
	call GetPartymonItem
	xor a
	ld [bc], a
	ld [hl], a
	ret

HandleStatBoostingHeldItems:
; The effects handled here are not used in-game.
	ld a, [hLinkPlayerNumber]
	cp $1
	jr z, .player_1
	call .DoEnemy
	jp .DoPlayer

.player_1
	call .DoPlayer
	jp .DoEnemy

.DoEnemy
	call GetPartymonItem
	ld a, $0
	jp .HandleItem

.DoPlayer
	call GetOTPartymonItem
	ld a, $1
.HandleItem
	ld [hBattleTurn], a
	ld d, h
	ld e, l
	push de
	push bc
	ld a, [bc]
	ld b, a
	call GetItemHeldEffect ; this is in ROM0
	ld hl, .StatUpItems
.loop
	ld a, [hli]
	cp $ff
	jr z, .finish
	inc hl
	inc hl
	cp b
	jr nz, .loop
	pop bc
	ld a, [bc]
	ld [wd265], a
	push bc
	dec hl
	dec hl
	ld a, BANK(BattleCommand_AttackUp)
	call FarCall_Pointer
	pop bc
	pop de
	ld a, [FailedMessage]
	and a
	ret nz
	xor a
	ld [bc], a
	ld [de], a
	call GetItemName
	ld hl, BattleText_UsersStringBuffer1Activated
	call StdBattleTextBox
	jpba BattleCommand_StatUpMessage

.finish
	pop bc
	pop de
	ret

.StatUpItems
	dbw HELD_ATTACK_UP,     BattleCommand_AttackUp
	dbw HELD_DEFENSE_UP,    BattleCommand_DefenseUp
	dbw HELD_SPEED_UP,      BattleCommand_SpeedUp
	dbw HELD_SP_ATTACK_UP,  BattleCommand_SpecialAttackUp
	dbw HELD_SP_DEFENSE_UP, BattleCommand_SpecialDefenseUp
	dbw HELD_ACCURACY_UP,   BattleCommand_AccuracyUp
	dbw HELD_EVASION_UP,    BattleCommand_EvasionUp
	db $ff

GetPartymonItem:
	ld hl, PartyMon1Item
	ld a, [CurBattleMon]
	call GetPartyLocation
	ld bc, BattleMonItem
	ret

GetOTPartymonItem:
	ld hl, OTPartyMon1Item
	ld a, [CurOTMon]
	call GetPartyLocation
	ld bc, EnemyMonItem
	ret

UpdateBattleHUDs:
	push hl
	push de
	push bc
	call DrawPlayerHUD
	ld hl, PlayerHPPal
	call SetHPPal
	call CheckDanger
	call DrawEnemyHUD
	ld hl, EnemyHPPal
	call SetHPPal
	pop bc
	pop de
	pop hl
	ret

UpdatePlayerHUD::
	push hl
	push de
	push bc
	call DrawPlayerHUD
	call UpdatePlayerHPPal
	call CheckDanger
	pop bc
	pop de
	pop hl
	ret

DrawPlayerHUD:
	xor a
	ld [hBGMapMode], a

	; Clear the area
	hlcoord 9, 7
	lb bc, 5, 11
	call ClearBox

	callba DrawPlayerHUDBorder

	hlcoord 18, 9
	ld [hl], $73 ; vertical bar
	call PrintPlayerHUD

	; HP bar
	hlcoord 10, 9
	ld b, 1
	xor a ; PARTYMON
	ld [wMonType], a
	predef DrawPlayerHP

	; Exp bar
	push de
	ld a, [CurBattleMon]
	ld hl, PartyMon1Exp + 2
	call GetPartyLocation
	ld d, h
	ld e, l

	hlcoord 10, 11
	ld a, [TempMonLevel]
	ld b, a
	call FillInExpBar
	pop de
	ret

UpdatePlayerHPPal:
	ld hl, PlayerHPPal
	jp UpdateHPPal

CheckDanger:
	ld hl, BattleMonHP
	ld a, [hli]
	or [hl]
	jr z, .no_danger
	ld a, [wDanger]
	and a
	ret nz
	ld a, [PlayerHPPal]
	cp HP_RED
	jr z, .danger

.no_danger
	ld hl, Danger
	ld [hl], $00
	ret

.danger
	ld hl, Danger
	set 7, [hl]
	ret

PrintPlayerHUD:
	ld de, BattleMonNick
	hlcoord 10, 7
	call PlaceString

	push bc

	ld a, [CurBattleMon]
	ld hl, PartyMon1DVs
	call GetPartyLocation
	ld de, TempMonDVs
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld hl, BattleMonLevel
	ld de, TempMonLevel
	ld bc, $0011
	rst CopyBytes
	ld a, [CurBattleMon]
	ld hl, PartyMon1Species
	call GetPartyLocation
	ld a, [hl]
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	call GetBaseData

	pop hl
	dec hl

	ld a, BREEDMON
	ld [wMonType], a
	callba GetGender
	ld a, " "
	jr c, .got_gender_char
	ld a, "♂"
	jr nz, .got_gender_char
	ld a, "♀"

.got_gender_char
	hlcoord 17, 8
	ld [hl], a
	hlcoord 14, 8
	push af ; back up gender
	push hl
	ld de, BattleMonStatus
	predef PlaceNonFaintStatus
	pop hl
	pop bc
	ret nz
	ld a, b
	cp " "
	jr nz, .copy_level ; male or female
	dec hl ; genderless

.copy_level
	ld a, [BattleMonLevel]
	ld [TempMonLevel], a
	jp PrintLevel

_UpdateBattleHuds::
	call UpdatePlayerHUD
	; fallthrough

UpdateEnemyHUD::
	push hl
	push de
	push bc
	call DrawEnemyHUD
	call UpdateEnemyHPPal
	pop bc
	pop de
	pop hl
	ret

DrawEnemyHUD:
	xor a
	ld [hBGMapMode], a

	hlcoord 1, 0
	lb bc, 4, 11
	call ClearBox

	callba DrawEnemyHUDBorder

	ld a, [TempEnemyMonSpecies]
	ld [wCurSpecies], a
	ld [wCurPartySpecies], a
	call GetBaseData
	ld de, EnemyMonNick
	hlcoord 1, 0
	call PlaceString
	ld h, b
	ld l, c
	dec hl

	ld hl, EnemyMonDVs
	ld de, TempMonDVs
	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	jr z, .ok
	ld hl, wEnemyBackupDVs
.ok
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a

	ld a, BREEDMON
	ld [wMonType], a
	callba GetGender
	ld a, " "
	jr c, .got_gender
	ld a, "♂"
	jr nz, .got_gender
	ld a, "♀"

.got_gender
	hlcoord 9, 1
	ld [hl], a

	hlcoord 6, 1
	push af
	push hl
	ld de, EnemyMonStatus
	predef PlaceNonFaintStatus
	pop hl
	pop bc
	jr nz, .skip_level
	ld a, b
	cp " "
	jr nz, .print_level
	dec hl
.print_level
	ld a, [EnemyMonLevel]
	ld [TempMonLevel], a
	call PrintLevel
.skip_level

	ld hl, EnemyMonHP
	ld a, [hli]
	ld [hMultiplicand + 1], a
	ld a, [hld]
	ld [hMultiplicand + 2], a
	or [hl]
	jr nz, .not_fainted

	ld c, a
	ld e, a
	ld d, HP_BAR_LENGTH
	jp .draw_bar

.not_fainted
	xor a
	ld [hMultiplicand], a
	ld a, HP_BAR_LENGTH_PX
	ld [hMultiplier], a
	predef Multiply
	ld hl, EnemyMonMaxHP
	ld a, [hli]
	ld [hDivisor], a
	ld a, [hl]
	ld [hDivisor + 1], a
	predef DivideLong
	ld a, [hLongQuotient + 3]
	ld e, a
	ld a, HP_BAR_LENGTH
	ld d, a
	ld c, a

.draw_bar
	xor a
	ld [wWhichHPBar], a
	hlcoord 2, 2
	ld b, 0
	jp DrawBattleHPBar

UpdateEnemyHPPal:
	ld hl, EnemyHPPal
	; fallthrough

UpdateHPPal:
	ld b, [hl]
	call SetHPPal
	ld a, [hl]
	cp b
	ret z
	jp FinishBattleAnim

BattleMenu:
	xor a
	ld [hBGMapMode], a
	call LoadTempTileMapToTileMap

	ld a, [wBattleType]
	cp BATTLETYPE_DEBUG
	jr z, .ok
	cp BATTLETYPE_TUTORIAL
	jr z, .ok
	call EmptyBattleTextBox
	call UpdateBattleHuds
	call EmptyBattleTextBox
	call LoadTileMapToTempTileMap
.ok

.loop
	; Auto input: choose "ITEM"
	ld a, [InputType]
	or a
	jr z, .skip_dude_pack_select
	callba _DudeAutoInput_DownA
.skip_dude_pack_select
	callba LoadBattleMenu
	ld a, $1
	ld [hBGMapMode], a
	ld a, [wd0d2]
	dec a
	jp z, BattleMenu_Fight
	dec a
	jp z, BattleMenu_PKMN
	dec a
	jp z, BattleMenu_PackOrGuard
	dec a
	jr nz, .loop
	; fallthrough

BattleMenu_Run:
	call Call_LoadTempTileMapToTileMap
	ld a, $3
	ld [wMenuCursorY], a
	ld hl, BattleMonSpeed
	ld de, EnemyMonSpeed
	call TryToRunAwayFromBattle
	ld a, $0
	ld [wFailedToFlee], a
	ret c
	ld a, [wPlayerAction]
	and a
	jr z, BattleMenu
	ret

BattleMenu_Guard:
	ld hl, wPlayerSubStatus2
	set SUBSTATUS_GUARDING, [hl]

; fallthrough
BattleMenu_Fight:
	call CheckIfInEagulouParkBattle
	jr z, .eagulouParkBattle
	xor a
	ld [wNumFleeAttempts], a
	call Call_LoadTempTileMapToTileMap
	and a
	ret
.eagulouParkBattle
	ld hl, BattleText_BattleCantFightEagulou
	call StdBattleTextBox
	jr BattleMenu

BattleMenu_PackOrGuard:
	ld a, [wLinkMode]
	and a
	jp nz, .ItemsCantBeUsed

	CheckEngine ENGINE_POKEMON_MODE
	jr nz, BattleMenu_Guard
	ld a, [InBattleTowerBattle]
	and 5
	jp nz, .ItemsCantBeUsed

	call LoadStandardMenuDataHeader

	ld a, [wBattleType]
	cp BATTLETYPE_TUTORIAL
	jr z, .tutorial

	callba BattlePack
	ld a, [wPlayerAction]
	and a
	jr z, .didnt_use_item
	jr .got_item

.tutorial
	callba TutorialPack
	ld a, POKE_BALL
	ld [wCurItem], a
	call DoItemEffect
	; fallthrough

.got_item
	jp .UseItem

.didnt_use_item
	call ClearPalettes
	call DelayFrame
	call _LoadBattleFontsHPBar
	call GetMonBackpic
	call GetMonFrontpic
	call ExitMenu
	call ApplyTilemapInVBlank
	call FinishBattleAnim
	call LoadTileMapToTempTileMap
	jp BattleMenu

.ItemsCantBeUsed
	ld hl, BattleText_ItemsCantBeUsedHere
	call StdBattleTextBox
	jp BattleMenu

.UseItem
	ld a, [wWildMon]
	and a
	jr nz, .run
	callba CheckItemPocket
	ld a, [wItemAttributeParamBuffer]
	cp BALL
	jr z, .ball
	call ClearBGPalettes

.ball
	xor a
	ld [hBGMapMode], a
	call _LoadBattleFontsHPBar
	call ClearSprites
	ld a, [wBattleType]
	cp BATTLETYPE_TUTORIAL
	jr z, .tutorial2
	call GetMonBackpic

.tutorial2
	call GetMonFrontpic
	ld a, $1
	ld [wMenuCursorY], a
	call ExitMenu
	call UpdateBattleHUDs
	call ApplyTilemapInVBlank
	call LoadTileMapToTempTileMap
	call ClearWindowData
	call FinishBattleAnim
	and a
	ret

.run
	xor a
	ld [wWildMon], a
	ld a, [wBattleResult]
	and $c0
	ld [wBattleResult], a
	call ClearWindowData
	call SetPalettes
	scf
	ret

BattleMenu_PKMNFinalChance:
	ld hl, BattleText_NoSwitchFinalChance
	call StdBattleTextBox
	jp BattleMenu

BattleMenu_PKMN:
	ld a, [wPlayerSubStatus2]
	bit SUBSTATUS_FINAL_CHANCE, a 
	jr nz, BattleMenu_PKMNFinalChance

	call LoadStandardMenuDataHeader
BattleMenuPKMN_ReturnFromStats:
	call ExitMenu
	call LoadStandardMenuDataHeader
	call ClearBGPalettes
BattleMenuPKMN_Loop:
	call SetUpBattlePartyMenu
	xor a
	ld [wPartyMenuActionText], a
	call JumpToPartyMenuAndPrintText
	call SelectBattleMon
	jr c, .Cancel
.loop
	callba FreezeMonIcons
	call .GetMenu
	jr c, BattleMenuPKMN_Loop
	call PlaceHollowCursor
	ld a, [wMenuCursorY]
	cp $1 ; SWITCH
	jp z, TryPlayerSwitch
	cp $2 ; STATS
	jr z, .Stats
	cp $3 ; CANCEL
	jr z, .Cancel
	jr .loop

.Stats
	call Battle_StatsScreen
	jp BattleMenuPKMN_ReturnFromStats

.Cancel
	call ClearSprites
	call ClearPalettes
	call DelayFrame
	call _LoadHPBar
	call CloseWindow
	call LoadTileMapToTempTileMap
	ld b, SCGB_RAM
	predef GetSGBLayout
	call SetPalettes
	jp BattleMenu

.GetMenu
	jpba BattleMonMenu

Battle_StatsScreen:
	call DisableLCD
	ld hl, VTiles2 tile $31
	ld de, VTiles0
	ld bc, $0110
	rst CopyBytes
	ld hl, VTiles2
	ld de, VTiles0 tile $11
	ld bc, $31 tiles
	rst CopyBytes
	call EnableLCD
	call ClearSprites
	call LowVolume
	xor a ; PARTYMON
	ld [wMonType], a
	callba BattleStatsScreenInit
	call MaxVolume
	call DisableLCD
	ld hl, VTiles0
	ld de, VTiles2 tile $31
	ld bc, $11 tiles
	rst CopyBytes
	ld hl, VTiles0 tile $11
	ld de, VTiles2
	ld bc, $31 tiles
	rst CopyBytes
	jp EnableLCD

TryPlayerSwitch:
	ld a, [CurBattleMon]
	ld d, a
	ld a, [wCurPartyMon]
	cp d
	jr nz, .check_trapped
	ld hl, BattleText_PkmnIsAlreadyOut
	call StdBattleTextBox
	jp BattleMenuPKMN_Loop

.check_trapped
	ld a, [wPlayerWrapCount]
	and a
	jr nz, .trapped
	call CheckEnemyArenaTrap
	jr c, .trapped
	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_CANT_RUN, a
	jr z, .try_switch
	ld a, [wPlayerSubStatus2]
	bit SUBSTATUS_FINAL_CHANCE, a
	jr z, .try_switch

.trapped
	ld hl, BattleText_PkmnCantBeRecalled
	call StdBattleTextBox
	jp BattleMenuPKMN_Loop

.try_switch
	call CheckIfCurPartyMonIsStillAlive
	jp z, BattleMenuPKMN_Loop
	ld a, [CurBattleMon]
	ld [LastPlayerMon], a
	ld a, $2
	ld [wPlayerAction], a
	call ClearPalettes
	call DelayFrame
	call ClearSprites
	call _LoadHPBar
	call CloseWindow
	ld b, SCGB_RAM
	predef GetSGBLayout
	call SetPalettes
	ld a, [wCurPartyMon]
	ld [CurBattleMon], a
PlayerSwitch:
	ld a, 1
	ld [wPlayerIsSwitching], a
	ld a, [wLinkMode]
	and a
	jr z, .not_linked
	call LoadStandardMenuDataHeader
	call LinkBattleSendReceiveAction
	call CloseWindow

.not_linked
	call ParseEnemyAction
	ld a, [wLinkMode]
	and a
	jr nz, .linked

.switch
	call CheckPlayerNaturalCure
	call BattleMonEntrance
	call AbilityOnMonEntrance
	and a
	ret

.linked
	ld a, [wBattleAction]
	cp BATTLEACTION_E
	jp z, .switch
	cp BATTLEACTION_D
	jp z, .switch
	cp BATTLEACTION_SWITCH1
	jp c, .switch
	cp BATTLEACTION_FORFEIT
	jr nz, .dont_run
	jp WildFled_EnemyFled_LinkBattleCanceled

.dont_run
	ld a, [hLinkPlayerNumber]
	cp $1
	jr z, .player_1
	call BattleMonEntrance
	call EnemyMonEntrance
	and a
	ret

.player_1
	call EnemyMonEntrance
	call BattleMonEntrance
	and a
	ret

EnemyMonEntrance:
	callba AI_Switch
	call SetEnemyTurn
	jp SpikesDamage

BattleMonEntrance:
	call WithdrawPkmnText

	ld c, 50
	call DelayFrames

	ld hl, wPlayerSubStatus4
	res SUBSTATUS_RAGE, [hl]

	call SetEnemyTurn
	call PursuitSwitch
	jr c, .ok
	call RecallPlayerMon
.ok

	hlcoord 9, 7
	lb bc, 5, 11
	call ClearBox

	ld a, [CurBattleMon]
	ld [wCurPartyMon], a
	call AddBattleParticipant
	call InitBattleMon
	call ResetPlayerStatLevels
	call SendOutPkmnText
	call NewBattleMonStatus
	call BreakAttraction
	call SendOutPlayerMon
	call EmptyBattleTextBox
	call LoadTileMapToTempTileMap
	call SetPlayerTurn
	call SpikesDamage
	ld a, $2
	ld [wMenuCursorY], a
	ret

PassedBattleMonEntrance:
	ld c, 50
	call DelayFrames

	hlcoord 9, 7
	lb bc, 5, 11
	call ClearBox

	ld a, [wCurPartyMon]
	ld [CurBattleMon], a
	call AddBattleParticipant
	call InitBattleMon
	xor a
	ld [wd265], a
	call ApplyStatLevelMultiplierOnAllStats
	call SendOutPlayerMon
	call EmptyBattleTextBox
	call LoadTileMapToTempTileMap
	call SetPlayerTurn
	jp SpikesDamage

CheckAmuletCoin:
	ld a, [BattleMonItem]
	ld b, a
	call GetItemHeldEffect ; this is in ROM0
	ld a, b
	cp HELD_AMULET_COIN
	ret nz
	ld a, 1
	ld [wAmuletCoin], a
	ret

MoveSelectionScreen:
	ld hl, EnemyMonMoves
	ld a, [wMoveSelectionMenuType]
	dec a
	jr z, .got_menu_type
	dec a
	jr z, .ether_elixer_menu
	call CheckPlayerHasUsableMoves
	ret z ; use Struggle
	ld hl, BattleMonMoves
	jr .got_menu_type

.ether_elixer_menu
	ld a, MON_MOVES
	call GetPartyParamLocation

.got_menu_type
	ld de, wListMoves_MoveIndicesBuffer
	ld bc, NUM_MOVES
	rst CopyBytes
	xor a
	ld [hBGMapMode], a

	hlcoord 4, 17 - NUM_MOVES - 1
	lb bc, 4, 14
	ld a, [wMoveSelectionMenuType]
	cp $2
	jr nz, .got_dims
	hlcoord 4, 17 - NUM_MOVES - 1 - 4
	lb bc, 4, 14
.got_dims
	call TextBox

	hlcoord 6, 17 - NUM_MOVES
	ld a, [wMoveSelectionMenuType]
	cp $2
	jr nz, .got_start_coord
	hlcoord 6, 17 - NUM_MOVES - 4
.got_start_coord
	ld a, SCREEN_WIDTH
	ld [wCurHPAnimMaxHP], a
	predef ListMoves

	ld b, 5
	ld a, [wMoveSelectionMenuType]
	cp $2
	ld a, 17 - NUM_MOVES
	jr nz, .got_default_coord
	ld b, 5
	ld a, 17 - NUM_MOVES - 4

.got_default_coord
	ld [w2DMenuCursorInitY], a
	ld a, b
	ld [w2DMenuCursorInitX], a
	ld a, [wMoveSelectionMenuType]
	cp $1
	jr z, .skip_inc
	ld a, [CurMoveNum]
	inc a

.skip_inc
	ld [wMenuCursorY], a
	ld a, $1
	ld [wMenuCursorX], a
	ld a, [wNumMoves]
	inc a
	ld [w2DMenuNumRows], a
	ld a, $1
	ld [w2DMenuNumCols], a
	ld c, $2c
	ld a, [wMoveSelectionMenuType]
	dec a
	ld b, A_BUTTON | D_UP | D_DOWN ; $c1
	jr z, .okay
	dec a
	ld b, A_BUTTON | B_BUTTON | D_UP | D_DOWN ; $c3
	jr z, .okay
	ld a, [wLinkMode]
	and a
	jr nz, .okay
	ld b, A_BUTTON | B_BUTTON | SELECT | D_UP | D_DOWN ; $c7

.okay
	ld a, b
	ld [wMenuJoypadFilter], a
	ld a, c
	ld [w2DMenuFlags1], a
	xor a
	ld [w2DMenuFlags2], a
	ld a, $10
	ld [w2DMenuCursorOffsets], a
.menu_loop
	ld a, [wMoveSelectionMenuType]
	and a
	jr z, .battle_player_moves
	dec a
	jr nz, .interpret_joypad
	jr .interpret_joypad

.battle_player_moves
	call MoveInfoBox
	ld a, [wMoveSwapBuffer]
	and a
	jr z, .interpret_joypad
	hlcoord 5, 13
	ld bc, SCREEN_WIDTH
	dec a
	rst AddNTimes
	ld [hl], "▷"

.interpret_joypad
	ld a, $1
	ld [hBGMapMode], a
	call DoMenuJoypadLoop
	bit D_UP_F, a
	jp nz, .pressed_up
	bit D_DOWN_F, a
	jp nz, .pressed_down
	bit SELECT_F, a
	jp nz, .pressed_select
	bit B_BUTTON_F, a
	push af

	xor a
	ld [wMoveSwapBuffer], a
	ld a, [wMenuCursorY]
	dec a
	ld [wMenuCursorY], a
	ld b, a
	ld a, [wMoveSelectionMenuType]
	dec a
	jr nz, .not_enemy_moves_process_b

	pop af
	ret

.not_enemy_moves_process_b
	dec a
	ld a, b
	ld [CurMoveNum], a
	jr nz, .use_move

	pop af
	ret

.use_move
	pop af
	ret nz

	ld hl, BattleMonPP
	ld a, [wMenuCursorY]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	and $3f
	jr z, .no_pp_left
	ld a, [PlayerDisableCount]
	swap a
	and $f
	dec a
	cp c
	jr z, .move_disabled
	ld a, [wUnusedPlayerLockedMove]
	and a
	jr nz, .skip2
	ld a, [wMenuCursorY]
	ld hl, BattleMonMoves
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]

.skip2
	ld [CurPlayerMove], a
	xor a
	ret

.move_disabled
	ld hl, BattleText_TheMoveIsDisabled
	jr .place_textbox_start_over

.no_pp_left
	ld hl, BattleText_TheresNoPPLeftForThisMove

.place_textbox_start_over
	call StdBattleTextBox
	call Call_LoadTempTileMapToTileMap
	jp MoveSelectionScreen

.pressed_up
	ld a, [wMenuCursorY]
	and a
	jp nz, .menu_loop
	ld a, [wNumMoves]
	inc a
	ld [wMenuCursorY], a
	jp .menu_loop

.pressed_down
	ld a, [wMenuCursorY]
	ld b, a
	ld a, [wNumMoves]
	inc a
	inc a
	cp b
	jp nz, .menu_loop
	ld a, $1
	ld [wMenuCursorY], a
	jp .menu_loop

.pressed_select
	ld a, [wMoveSwapBuffer]
	and a
	jr z, .start_swap
	ld hl, BattleMonMoves
	call .swap_bytes
	ld hl, BattleMonPP
	call .swap_bytes
	ld hl, PlayerDisableCount
	ld a, [hl]
	swap a
	and $f
	ld b, a
	ld a, [wMenuCursorY]
	cp b
	jr nz, .not_swapping_disabled_move
	ld a, [hl]
	and $f
	ld b, a
	ld a, [wMoveSwapBuffer]
	swap a
	add b
	ld [hl], a
	jr .swap_moves_in_party_struct

.not_swapping_disabled_move
	ld a, [wMoveSwapBuffer]
	cp b
	jr nz, .swap_moves_in_party_struct
	ld a, [hl]
	and $f
	ld b, a
	ld a, [wMenuCursorY]
	swap a
	add b
	ld [hl], a

.swap_moves_in_party_struct
; Fixes the COOLTRAINER glitch
	ld a, [wPlayerSubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	jr nz, .transformed
	ld hl, PartyMon1Moves
	ld a, [CurBattleMon]
	call GetPartyLocation
	push hl
	call .swap_bytes
	pop hl
	ld bc, MON_PP - MON_MOVES
	add hl, bc
	call .swap_bytes

.transformed
	xor a
	ld [wMoveSwapBuffer], a
	jp MoveSelectionScreen

.swap_bytes
	push hl
	ld a, [wMoveSwapBuffer]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld a, [wMenuCursorY]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [de]
	ld b, [hl]
	ld [hl], a
	ld a, b
	ld [de], a
	ret

.start_swap
	ld a, [wMenuCursorY]
	ld [wMoveSwapBuffer], a
	jp MoveSelectionScreen

MoveInfoBox:
	xor a
	ld [hBGMapMode], a

	hlcoord 0, 8
	lb bc, 3, 9
	call TextBox

	ld a, [PlayerDisableCount]
	and a
	jr z, .not_disabled

	swap a
	and $f
	ld b, a
	ld a, [wMenuCursorY]
	cp b
	jr nz, .not_disabled

	hlcoord 1, 10
	ld de, .Disabled
	call PlaceText
	ret

.not_disabled
	ld hl, wMenuCursorY
	dec [hl]
	call SetPlayerTurn
	ld hl, BattleMonMoves
	ld a, [wMenuCursorY]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [CurPlayerMove], a

	ld a, [CurBattleMon]
	ld [wCurPartyMon], a
	ld a, WILDMON
	ld [wMonType], a
	callba GetMaxPPOfMove

	ld hl, wMenuCursorY
	ld c, [hl]
	inc [hl]
	ld b, 0
	ld hl, BattleMonPP
	add hl, bc
	ld a, [hl]
	and $3f
	ld [wStringBuffer1], a
	call .PrintPP

	hlcoord 1, 9
	ld de, .Type
	call PlaceText

	hlcoord 7, 11
	ld [hl], "/"

	callba UpdateMoveData
	ld a, [wPlayerMoveStruct + MOVE_ANIM]
	ld b, a
	hlcoord 2, 10
	predef PrintMoveType
	ret

.Disabled
	ctxt "Disabled!"
	done
.Type
	text "TYPE/"
	done

.PrintPP
	hlcoord 5, 11
	push hl
	ld de, wStringBuffer1
	lb bc, 1, 2
	call PrintNum
	pop hl
	inc hl
	inc hl
	ld [hl], "/"
	inc hl
	ld de, wNamedObjectIndexBuffer
	lb bc, 1, 2
	jp PrintNum

CheckPlayerHasUsableMoves:
	ld a, STRUGGLE
	ld [CurPlayerMove], a
	ld a, [PlayerDisableCount]
	and a
	ld hl, BattleMonPP
	jr nz, .disabled

	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	inc hl
	or [hl]
	and $3f
	ret nz
	jr .force_struggle

.disabled
	swap a
	and $f
	ld b, a
	ld d, $5
	xor a
.loop
	dec d
	jr z, .done
	ld c, [hl]
	inc hl
	dec b
	jr z, .loop
	or c
	jr .loop

.done
	and a
	ret nz

.force_struggle
	ld hl, BattleText_PkmnHasNoMovesLeft
	call StdBattleTextBox
	ld c, 60
	call DelayFrames
	xor a
	ret

ParseEnemyAction:
	ld a, [wEnemyIsSwitching]
	and a
	ret nz
	ld a, [wLinkMode]
	and a
	jr z, .not_linked
	call EmptyBattleTextBox
	call LoadTileMapToTempTileMap
	ld a, [wPlayerAction]
	and a
	call z, LinkBattleSendReceiveAction
	call Call_LoadTempTileMapToTileMap
	ld a, [wBattleAction]
	cp BATTLEACTION_E
	jp z, .struggle
	cp BATTLEACTION_D
	jp z, .battle_action_d
	cp BATTLEACTION_SWITCH1
	jp nc, ResetVarsForSubStatusRage
	ld [CurEnemyMoveNum], a
	ld c, a
	ld a, [wEnemySubStatus1]
	bit SUBSTATUS_ROLLOUT, a
	jp nz, .skip_load
	ld a, [wEnemySubStatus3]
	and 1 << SUBSTATUS_CHARGED | 1 << SUBSTATUS_RAMPAGE ; | 1 << SUBSTATUS_BIDE
	jp nz, .skip_load

	ld hl, wEnemySubStatus5
	bit SUBSTATUS_ENCORED, [hl]
	ld a, [LastEnemyMove]
	jp nz, .finish
	ld hl, EnemyMonMoves
	ld b, 0
	add hl, bc
	ld a, [hl]
	jp .finish

.not_linked
	ld hl, wEnemySubStatus5
	bit SUBSTATUS_ENCORED, [hl]
	jr z, .skip_encore
	ld a, [LastEnemyMove]
	jp .finish

.skip_encore
	call CheckSubStatus_RechargeChargedRampageBideRollout
	jp nz, ResetVarsForSubStatusRage
	jr .continue

.battle_action_d
	ld a, $ff
	jr .finish

.continue
	ld hl, EnemyMonMoves
	ld de, EnemyMonPP
	ld b, NUM_MOVES
.loop
	ld a, [hl]
	and a
	jp z, .struggle
	ld a, [EnemyDisabledMove]
	cp [hl]
	jr z, .disabled
	ld a, [de]
	and $3f
	jr nz, .enough_pp

.disabled
	inc hl
	inc de
	dec b
	jr nz, .loop
	jr .struggle

.enough_pp
	ld a, [wBattleMode]
	dec a
	jr nz, .skip_load
; wild
.loop2
	ld hl, EnemyMonMoves
	call BattleRandom
	and 3 ; TODO factor in NUM_MOVES
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [EnemyDisableCount]
	swap a
	and $f
	dec a
	cp c
	jr z, .loop2
	ld a, [hl]
	and a
	jr z, .loop2
	ld hl, EnemyMonPP
	add hl, bc
	ld b, a
	ld a, [hl]
	and $3f
	jr z, .loop2
	ld a, c
	ld [CurEnemyMoveNum], a
	ld a, b

.finish
	ld [CurEnemyMove], a

.skip_load
	call SetEnemyTurn
	callba UpdateMoveData
	call CheckSubStatus_RechargeChargedRampageBideRollout
	jr nz, .raging
	xor a
	ld [wEnemyCharging], a

.raging
	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	cp EFFECT_FURY_CUTTER
	jr z, .fury_cutter
	xor a
	ld [EnemyFuryCutterCount], a

.fury_cutter
	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	cp EFFECT_RAGE
	jr z, .no_rage
	ld hl, wEnemySubStatus4
	res SUBSTATUS_RAGE, [hl]

.no_rage
	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	cp EFFECT_PROTECT
	ret z
	cp EFFECT_ENDURE
	ret z
	xor a
	ld [EnemyProtectCount], a
	ret

.struggle
	ld a, STRUGGLE
	jr .finish

ResetVarsForSubStatusRage:
	xor a
	ld [EnemyFuryCutterCount], a
	ld [EnemyProtectCount], a
	ld hl, wEnemySubStatus4
	res SUBSTATUS_RAGE, [hl]
	ret

CheckSubStatus_RechargeChargedRampageBideRollout:
	ld a, [wEnemySubStatus4]
	and 1 << SUBSTATUS_RECHARGE
	ret nz

	ld hl, wEnemySubStatus3
	ld a, [hl]
	and 1 << SUBSTATUS_CHARGED | 1 << SUBSTATUS_RAMPAGE ; | 1 << SUBSTATUS_BIDE
	ret nz

	ld hl, wEnemySubStatus1
	bit SUBSTATUS_ROLLOUT, [hl]
	ret

LinkBattleSendReceiveAction:
	jpba _LinkBattleSendReceiveAction

LoadEnemyMon:
; Initialize enemy monster parameters
; To do this we pull the species from TempEnemyMonSpecies

; Notes:
;   BattleRandom is used to ensure sync between Game Boys

; Clear the whole EnemyMon struct
	xor a
	ld hl, EnemyMonSpecies
	ld bc, EnemyMonEnd - EnemyMon
	call ByteFill
	ld a, 1
	ld [wEnemyJustSentMonOut], a

; We don't need to be here if we're in a link battle
	ld a, [wLinkMode]
	and a
	jp nz, InitEnemyMon

; and also in a BattleTower-Battle
	ld a, [InBattleTowerBattle]
	and 5
	jp nz, InitEnemyMon

; Make sure everything knows what species we're working with
	ld a, [TempEnemyMonSpecies]
	ld [EnemyMonSpecies], a
	ld [wCurSpecies], a
	ld [wCurPartySpecies], a

; Grab the BaseData for this species
	call GetBaseData

; Let's get the item:

; Is the item predetermined?
	ld a, [wBattleMode]
	dec a
	jr z, .WildItem

; If we're in a trainer battle, the item is in the party struct
	ld a, [wCurPartyMon]
	ld hl, OTPartyMon1Item
	call GetPartyLocation ; bc = PartyMon[wCurPartyMon] - wPartyMons
	ld a, [hl]
	jr .UpdateItem

.WildItem
; In a wild battle, we pull from the item slots in BaseData

; Force Item1
; Used for Ho-Oh, Lugia and Snorlax encounters
	ld a, [wWildMonCustomItem]
	and a
	jr z, .notCustomItem
	ld [EnemyMonItem], a
	xor a
	ld [wWildMonCustomItem], a
	jr .afterEnemyItem
.notCustomItem
	ld a, [wBattleType]
	cp BATTLETYPE_FORCEITEM
	ld a, [BaseItems]
	jr z, .UpdateItem

; Failing that, it's all up to chance
;  Effective chances:
;    75% None
;    23% Item1
;     2% Item2

; 25% chance of getting an item
	call BattleRandom
	and 3
	ld a, NO_ITEM
	jr nz, .UpdateItem

; From there, an 8% chance for Item2
	call BattleRandom
	cp a, 8 percent ; 8% of 25% = 2% Item2
	ld a, [BaseItems]
	jr nc, .UpdateItem
	ld a, [BaseItems+1]

.UpdateItem
	ld [EnemyMonItem], a
.afterEnemyItem
; Initialize DVs

; If we're in a trainer battle, DVs are predetermined
	ld a, [wBattleMode]
	and a
	jr z, .InitDVs

	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	jr z, .InitDVs

; Unknown
	ld hl, wEnemyBackupDVs
	ld de, EnemyMonDVs
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	jp .Happiness

.InitDVs

; Trainer DVs

; All trainers have preset DVs, determined by class
; See GetTrainerDVs for more on that
	callba GetTrainerDVs
; These are the DVs we'll use if we're actually in a trainer battle
	ld a, [wBattleMode]
	dec a
	jr nz, .UpdateDVs

; Wild DVs
; Here's where the fun starts

; Roaming monsters (Entei, Raikou) work differently
; They have their own structs, which are shorter than normal
	ld a, [wBattleType]
	cp a, BATTLETYPE_ROAMING
	jr nz, .NotRoaming

; Grab HP
	ld hl, wRoamMon1HP
	ld a, [hli]
; Check if the HP has been initialized
	or [hl]
; We'll do something with the result in a minute
	push af

; Grab DVs
	ld hl, wRoamMon1DVs + 1
	ld a, [hld]
	ld c, a
	ld b, [hl]

; Get back the result of our check
	pop af
; If the RoamMon struct has already been initialized, we're done
	jr nz, .UpdateDVs

; If it hasn't, we need to initialize the DVs
; (HP is initialized at the end of the battle)
	ld hl, wRoamMon1DVs + 1
	call BattleRandom
	ld [hld], a
	ld c, a
	call BattleRandom
	ld [hl], a
	ld b, a
; We're done with DVs
	jr .UpdateDVs

.NotRoaming
; Register a contains wBattleType

; Forced shiny battle type
; Used by Red Gyarados at Lake of Rage
	cp a, BATTLETYPE_SHINY
	jr nz, .check_park_minigame

	ld b, ATKDEFDV_SHINY ; $ea
	ld c, SPDSPCDV_SHINY ; $aa
	jr .UpdateDVs

.check_park_minigame
; If we're in the park minigame, DVs are already generated
	CheckEngine ENGINE_PARK_MINIGAME
	jr z, .GenerateDVs
	ld hl, wParkMinigameCurrentSpotDVs
	ld a, [hli]
	ld b, a
	ld c, [hl]
	jr .UpdateDVs

.GenerateDVs
; Generate new random DVs
	call BattleRandom
	ld b, a
	call BattleRandom
	ld c, a

.UpdateDVs
; Input DVs in register bc
	ld hl, EnemyMonDVs
	ld a, b
	ld [hli], a
	ld [hl], c

.Happiness
; Set happiness
	ld a, BASE_HAPPINESS
	ld [EnemyMonHappiness], a
; Set level
	ld a, [CurPartyLevel]
	ld [EnemyMonLevel], a
; Fill stats
	ld de, EnemyMonMaxHP
	ld b, FALSE
	ld hl, EnemyMonDVs + (MON_STAT_EXP - 1) - (MON_DVS)
	predef CalcPkmnStats

; If we're in a trainer battle,
; get the rest of the parameters from the party struct
	ld a, [wBattleMode]
	cp a, TRAINER_BATTLE
	jr z, .OpponentParty

; If we're in a wild battle, check wild-specific stuff
	and a
	jr z, .TreeMon

	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	jp nz, .Moves

.TreeMon
; If we're headbutting trees, some monsters enter battle asleep
	call CheckSleepingTreeMon
	ld a, SLP ; Asleep for 7 turns
	jr c, .UpdateStatus
; Otherwise, no status
	xor a

.UpdateStatus
	ld hl, EnemyMonStatus
	ld [hli], a

; Unused byte
	xor a
	ld [hli], a

; Full HP..
	ld a, [EnemyMonMaxHP]
	ld [hli], a
	ld a, [EnemyMonMaxHP + 1]
	ld [hl], a

; ..unless it's a RoamMon
	ld a, [wBattleType]
	cp a, BATTLETYPE_ROAMING
	jr nz, .Moves

; Grab HP
	ld hl, wRoamMon1HP
	ld a, [hli]
; Check if it's been initialized again
	or [hl]
	jr z, .InitRoamHP
; Update from the struct if it has
	ld a, [hl]
	ld [EnemyMonHP + 1], a
	jr .Moves

.InitRoamHP
	ld a, [EnemyMonHP + 1]
	ld [hld], a
	ld a, [EnemyMonHP]
	ld [hl], a
	jr .Moves

.OpponentParty
; Get HP from the party struct
	ld hl, (OTPartyMon1HP + 1)
	ld a, [wCurPartyMon]
	call GetPartyLocation
	ld a, [hld]
	ld [EnemyMonHP + 1], a
	ld a, [hld]
	ld [EnemyMonHP], a

; Make sure everything knows which monster the opponent is using
	ld a, [wCurPartyMon]
	ld [CurOTMon], a

; Get status from the party struct
	dec hl
	ld a, [hl] ; OTPartyMonStatus
	ld [EnemyMonStatus], a

.Moves
	ld hl, BaseType1
	ld de, EnemyMonType1
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a

; Get moves
	ld de, EnemyMonMoves
; Are we in a trainer battle?
	ld a, [wBattleMode]
	cp TRAINER_BATTLE
	jr nz, .WildMoves
; Then copy moves from the party struct
	ld hl, OTPartyMon1Moves
	ld a, [wCurPartyMon]
	call GetPartyLocation
	ld bc, NUM_MOVES
	rst CopyBytes
	jr .PP

.WildMoves
; Clear EnemyMonMoves
	ld a, [wWildMonCustomMoves]
	and a
	jr z, .notCustom
	ld hl, wWildMonCustomMoves
	ld bc, NUM_MOVES
	rst CopyBytes
	xor a
	ld [wWildMonCustomMoves], a
	jr .PP
.notCustom
	xor a
	ld h, d
	ld l, e
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
; Make sure the predef knows this isn't a partymon
	ld [wFillMoves_IsPartyMon], a
; Fill moves based on level
	predef FillMoves

.PP
; Trainer battle?
	ld a, [wBattleMode]
	cp a, TRAINER_BATTLE
	jr z, .TrainerPP

; Fill wild PP
	ld hl, EnemyMonMoves
	ld de, EnemyMonPP
	predef FillPP
	jr .Finish

.TrainerPP
; Copy PP from the party struct
	ld hl, OTPartyMon1PP
	ld a, [wCurPartyMon]
	call GetPartyLocation
	ld de, EnemyMonPP
	ld bc, NUM_MOVES
	rst CopyBytes

.Finish
; Only the first five base stats are copied..
	ld hl, BaseStats
	ld de, EnemyMonBaseStats
	ld b, BaseSpecialDefense - BaseStats
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop

	ld a, [BaseCatchRate]
	ld [de], a
	inc de

	ld a, [BaseExp]
	ld [de], a

	ld a, [TempEnemyMonSpecies]
	ld [wd265], a

	call GetPokemonName

; Did we catch it?
	ld a, [wBattleMode]
	and a
	ret z

; Update enemy nick
	ld hl, wStringBuffer1
	ld de, EnemyMonNick
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes

; Saw this mon
	ld a, [TempEnemyMonSpecies]
	dec a
	ld c, a
	ld b, SET_FLAG
	ld hl, PokedexSeen
	predef FlagAction

	ld hl, EnemyMonStats
	ld de, EnemyStats
	ld bc, EnemyMonStatsEnd - EnemyMonStats
	rst CopyBytes

	jp CalcEnemyAbility

CheckSleepingTreeMon:
; Return carry if species is in the list
; for the current time of day

; Don't do anything if this isn't a tree encounter
	ld a, [wBattleType]
	cp a, BATTLETYPE_TREE
	jr nz, .NotSleeping

; Get list for the time of day
	ld hl, .Morn
	ld a, [TimeOfDay]
	cp a, DAY
	jr c, .Check
	ld hl, .Day
	jr z, .Check
	ld hl, .Nite

.Check
	ld a, [TempEnemyMonSpecies]
	call IsInSingularArray
; If it's a match, the opponent is asleep
	ret c

.NotSleeping
	and a
	ret

.Nite
	db CATERPIE
	db METAPOD
	db BUTTERFREE
	db EXEGGCUTE
	db -1 ; end

.Day
	db VENONAT
	db SPINARAK
	db -1 ; end

.Morn
	db VENONAT
	db SPINARAK
	db -1 ; end

BattleWinSlideInEnemyTrainerFrontpic:
	xor a
	ld [TempEnemyMonSpecies], a
	call FinishBattleAnim
	ld a, [OtherTrainerClass]
	ld [TrainerClass], a
	ld de, VTiles2
	predef GetTrainerPic
	hlcoord 19, 0
	ld c, 0

.outer_loop
	inc c
	ld a, c
	cp 7
	ret z
	xor a
	ld [hBGMapMode], a
	ld [hBGMapHalf], a
	ld d, a
	push bc
	push hl

.inner_loop
	call .CopyColumn
	inc hl
	ld a, 7
	add d
	ld d, a
	dec c
	jr nz, .inner_loop

	ld a, $1
	ld [hBGMapMode], a
	ld c, 3
	call DelayFrames
	pop hl
	pop bc
	dec hl
	jr .outer_loop

.CopyColumn
	push hl
	push de
	push bc
	ld e, 7

.loop
	ld [hl], d
	ld bc, SCREEN_WIDTH
	add hl, bc
	inc d
	dec e
	jr nz, .loop

	pop bc
	pop de
	pop hl
	ret

ApplyStatusEffectOnPlayerStats:
	ld a, 1
	jr ApplyStatusEffectOnStats

ApplyStatusEffectOnEnemyStats:
	xor a
	; fallthrough

ApplyStatusEffectOnStats:
	ld [hBattleTurn], a
	call ApplyPrzEffectOnSpeed
	jp ApplyBrnEffectOnAttack

ApplyPrzEffectOnSpeed:
	ld a, [hBattleTurn]
	and a
	jr z, .enemy
	ld a, [BattleMonStatus]
	and 1 << PAR
	ret z
	ld a, [PlayerAbility]
	cp ABILITY_QUICK_FEET
	ret z
	ld hl, BattleMonSpeed + 1
	ld a, [hld]
	ld b, a
	ld a, [hl]
	srl a
	rr b
	srl a
	rr b
	ld [hli], a
	or b
	jr nz, .player_ok
	ld b, $1 ; min speed

.player_ok
	ld [hl], b
	ret

.enemy
	ld a, [EnemyMonStatus]
	and 1 << PAR
	ret z
	ld a, [EnemyAbility]
	cp ABILITY_QUICK_FEET
	ret z
	ld hl, EnemyMonSpeed + 1
	ld a, [hld]
	ld b, a
	ld a, [hl]
	srl a
	rr b
	srl a
	rr b
	ld [hli], a
	or b
	jr nz, .enemy_ok
	ld b, $1 ; min speed

.enemy_ok
	ld [hl], b
	ret

ApplyBrnEffectOnAttack:
	ld a, [hBattleTurn]
	and a
	ld hl, EnemyMonAttack
	ld a, [EnemyMonStatus]
	jr z, .checkEnemy
	ld hl, BattleMonAttack
	ld a, [BattleMonStatus]
.checkEnemy
	and 1 << BRN
	ret z
	ld a, [hli]
	ld b, a
	ld c, [hl]
	srl b
	rr c
	ld a, b
	or c
	jr nz, .nonZero
	inc c ; min attack
.nonZero
	call GetTargetAbility
	cp ABILITY_GUTS
	jr nz, .writeNewValue
	push hl
	ld a, [hld]
	ld h, [hl]
	ld l, a
	add hl, bc
	ld b, h
	ld c, l
	pop hl
.writeNewValue
	ld a, c
	ld [hld], a
	ld [hl], b
	ret

ApplyStatLevelMultiplierOnAllStats:
; Apply StatLevelMultipliers on all 5 Stats
	ld c, 0
.stat_loop
	call ApplyStatLevelMultiplier
	inc c
	ld a, c
	cp 5
	jr nz, .stat_loop
	ret

ApplyStatLevelMultiplier:
	push bc
	push bc
	ld a, [wd265]
	and a
	ld a, c
	ld hl, BattleMonAttack
	ld de, PlayerStats
	ld bc, PlayerAtkLevel
	jr z, .got_pointers
	ld hl, EnemyMonAttack
	ld de, EnemyStats
	ld bc, EnemyAtkLevel

.got_pointers
	add c
	ld c, a
	jr nc, .okay
	inc b
.okay
	ld a, [bc]
	pop bc
	ld b, a
	push bc
	sla c
	ld b, 0
	add hl, bc
	ld a, c
	add e
	ld e, a
	jr nc, .okay2
	inc d
.okay2
	pop bc
	push hl
	ld hl, .StatLevelMultipliers
	dec b
	sla b
	ld c, b
	ld b, 0
	add hl, bc
	xor a
	ld [hMultiplicand + 0], a
	ld a, [de]
	ld [hMultiplicand + 1], a
	inc de
	ld a, [de]
	ld [hMultiplicand + 2], a
	ld a, [hli]
	ld [hMultiplier], a
	predef Multiply
	ld a, [hl]
	ld [hDivisor], a
	ld b, $4
	predef Divide
	pop hl

	; cap at 2,560. This is purely a failsafe, as the maximum legal value is 2,432.
	ld a, [hQuotient + 1]
	cp 10
	jp c, .okay3

	ld a, 10
	ld [hQuotient + 1], a
	xor a
	ld [hQuotient + 2], a

.okay3
	ld a, [hQuotient + 1]
	ld [hli], a
	ld b, a
	ld a, [hQuotient + 2]
	ld [hl], a
	or b
	jr nz, .okay4
	inc [hl]

.okay4
	pop bc
	ret

.StatLevelMultipliers
;	     /
	db 1, 4 ; 25%
	db 2, 7 ; 29%
	db 1, 3 ; 33%
	db 2, 5 ; 40%
	db 1, 2 ; 50%
	db 2, 3 ; 67%

	db 1, 1 ; 100%

	db 3, 2 ; 150%
	db 2, 1 ; 200%
	db 5, 2 ; 250%
	db 3, 1 ; 300%
	db 7, 2 ; 350%
	db 4, 1 ; 400%

_LoadBattleFontsHPBar:
	jpba LoadBattleFontsHPBar

_LoadHPBar:
	jpba LoadHPBar

EmptyBattleTextBox:
	ld hl, .empty
	jp BattleTextBox
.empty
	db "@"

_BattleRandom::
; If the normal RNG is used in a link battle it'll desync.
; To circumvent this a shared PRNG is used instead.

; The PRNG operates in streams of 10 values.

; Which value are we trying to pull?
	push hl
	push bc
	ld a, [LinkBattleRNCount]
	ld c, a
	ld b, 0
	ld hl, LinkBattleRNs
	add hl, bc
	inc a
	ld [LinkBattleRNCount], a

; If we haven't hit the end yet, we're good
	cp 10 - 1 ; Exclude last value. See the closing comment
	ld a, [hl]
	pop bc
	pop hl
	ret c

; If we have, we have to generate new pseudorandom data
; Instead of having multiple PRNGs, ten seeds are used
	push hl
	push bc
	push af

; Reset count to 0
	xor a
	ld [LinkBattleRNCount], a
	ld hl, LinkBattleRNs
	ld b, 10 ; number of seeds

; Generate next number in the sequence for each seed
; The algorithm takes the form *5 + 1 % 256
.loop
	; get last #
	ld a, [hl]

	; a * 5 + 1
	ld c, a
	add a
	add a
	add c
	inc a

	; update #
	ld [hli], a
	dec b
	jr nz, .loop

; This has the side effect of pulling the last value first,
; then wrapping around. As a result, when we check to see if
; we've reached the end, we check the one before it.

	pop af
	pop bc
	pop hl
	ret

Call_PlayBattleAnim_OnlyIfVisible:
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	ret nz
	; fallthrough

Call_PlayBattleAnim:
	ld a, e
	ld [FXAnimIDLo], a
	ld a, d
	ld [FXAnimIDHi], a
	or e
	ret z
	call ApplyTilemapInVBlank
	predef_jump PlayBattleAnim

FinishBattleAnim:
	push af
	push bc
	push de
	push hl
	ld b, SCGB_BATTLE_COLORS
	predef GetSGBLayout
	call SetPalettes
	call DelayFrame
	pop hl
	pop de
	pop bc
	pop af
	ret

UpdateBattleStateAndExperienceAfterEnemyFaint:
	call UpdateBattleMonInParty
	ld a, [wBattleMode]
	dec a
	jr z, .wild
	ld a, [CurOTMon]
	ld hl, OTPartyMon1HP
	call GetPartyLocation
	xor a
	ld [hli], a
	ld [hl], a

.wild
	ld hl, wPlayerSubStatus3
	res SUBSTATUS_IN_LOOP, [hl]
	xor a
	ld hl, EnemyDamageTaken
	ld [hli], a
	ld [hl], a
	call NewEnemyMonStatus
	call BreakAttraction
	ld a, [wBattleMode]
	dec a
	jr z, .wild2
	jr .trainer

.wild2
	call StopDangerSound
	ld a, $1
	ld [wDanger], a

.trainer
	ld hl, BattleMonHP
	ld a, [hli]
	or [hl]
	jr nz, .player_mon_did_not_faint
	ld a, [wWhichMonFaintedFirst]
	and a
	call z, PlayerMonFaintHappinessMod
.player_mon_did_not_faint
	call CheckPlayerPartyForFitPkmn
	ld a, d
	and a
	ret z
	ld a, [wBattleMode]
	dec a
	call z, PlayVictoryMusic
	call EmptyBattleTextBox
	call LoadTileMapToTempTileMap
	ld a, [wBattleResult]
	and $c0
	ld [wBattleResult], a
INCLUDE "battle/experience.asm"

SendOutPkmnText:
	CheckEngine ENGINE_POKEMON_MODE
	ret nz

	ld a, [wLinkMode]
	and a
	jr z, .not_linked

	ld hl, JumpText_GoPkmn ; If we're in a LinkBattle print just "Go <PlayerMon>"

	ld a, [wBattleHasJustStarted] ; unless we're in the middle of the battle
	and a
	jr nz, .skip_to_textbox

.not_linked
; Depending on the HP of the enemy Pkmn, the game prints a different text
	ld hl, EnemyMonHP
	ld a, [hli]
	or [hl]
	ld hl, JumpText_GoPkmn
	jr z, .skip_to_textbox

	; compute enemy helth remaining as a percentage
	xor a
	ld [hMultiplicand + 0], a
	ld hl, EnemyMonHP
	ld a, [hli]
	ld [wEnemyHPAtTimeOfPlayerSwitch], a
	ld [hMultiplicand + 1], a
	ld a, [hl]
	ld [wEnemyHPAtTimeOfPlayerSwitch + 1], a
	ld [hMultiplicand + 2], a
	ld a, 100
	ld [hMultiplier], a
	predef Multiply
	ld hl, EnemyMonMaxHP
	ld a, [hli]
	ld [hDivisor], a
	ld a, [hl]
	ld [hDivisor + 1], a
	predef DivideLong

	ld a, [hLongQuotient + 3]
	ld hl, JumpText_GoPkmn
	cp 70
	jr nc, .skip_to_textbox

	ld hl, JumpText_DoItPkmn
	cp 40
	jr nc, .skip_to_textbox

	ld hl, JumpText_GoForItPkmn
	cp 10
	jr nc, .skip_to_textbox

	ld hl, JumpText_YourFoesWeakGetmPkmn
.skip_to_textbox
	jp BattleTextBox

JumpText_GoPkmn:
	text_far Text_GoPkmn
	start_asm
	jr Function_TextJump_BattleMonNick01

JumpText_DoItPkmn:
	text_far Text_DoItPkmn
	start_asm
	jr Function_TextJump_BattleMonNick01

JumpText_GoForItPkmn:
	text_far Text_GoForItPkmn
	start_asm
	jr Function_TextJump_BattleMonNick01

JumpText_YourFoesWeakGetmPkmn:
	text_far Text_YourFoesWeakGetmPkmn
	start_asm
Function_TextJump_BattleMonNick01:
	ld hl, TextJump_BattleMonNick01
	ret

TextJump_BattleMonNick01:
	text_jump Text_BattleMonNick01

WithdrawPkmnText:
	ld hl, .WithdrawPkmnText
	jp BattleTextBox

.WithdrawPkmnText
	text_far Text_BattleMonNickComma
	start_asm
; Print text to withdraw Pkmn
; depending on HP the message is different
	push de
	push bc
	ld hl, EnemyMonHP + 1
	ld de, wEnemyHPAtTimeOfPlayerSwitch + 1
	ld b, [hl]
	dec hl
	ld a, [de]
	sub b
	ld [hMultiplicand + 2], a
	dec de
	ld b, [hl]
	ld a, [de]
	sbc b
	ld [hMultiplicand + 1], a
	sbc a ; sign-extend the value, so negative numbers give a huge result
	ld [hMultiplicand], a
	ld a, 100
	ld [hMultiplier], a
	predef Multiply
	ld a, [hli]
	ld [hDivisor], a
	ld a, [hl]
	ld [hDivisor + 1], a
	predef DivideLong
	pop bc
	pop de
	ld a, [hLongQuotient + 2] ; negative differences give huge results when dividing, that overflow one byte
	ld hl, TextJump_ThatsEnoughComeBack
	and a
	ret nz
	ld a, [hLongQuotient + 3]
	and a
	ret z

	ld hl, TextJump_ComeBack
	cp 30
	ret c

	ld hl, TextJump_OKComeBack
	cp 70
	ret c

	ld hl, TextJump_GoodComeBack
	ret

TextJump_ThatsEnoughComeBack:
	text_jump Text_ThatsEnoughComeBack

TextJump_OKComeBack:
	text_jump Text_OKComeBack

TextJump_GoodComeBack:
	text_jump Text_GoodComeBack

TextJump_ComeBack:
	text_jump Text_ComeBack

GetMonBackpic:
	ld a, [wPlayerSubStatus4]
	bit SUBSTATUS_SUBSTITUTE, a
	ld hl, BattleAnimCmd_RaiseSub
	jr nz, GetBackpic_DoAnim ; substitute
	; fallthrough

DropPlayerSub:
	ld a, [wPlayerMinimized]
	and a
	ld hl, BattleAnimCmd_MinimizeOpp
	jr nz, GetBackpic_DoAnim
	ld a, [wCurPartySpecies]
	push af
	ld a, [BattleMonSpecies]
	ld [wCurPartySpecies], a
	ld de, VTiles2 tile $31
	predef GetBackpic
	pop af
	ld [wCurPartySpecies], a
	ret

GetBackpic_DoAnim:
	ld a, [hBattleTurn]
	push af
	xor a
	ld [hBattleTurn], a
	ld a, BANK(BattleAnimCommands)
	call FarCall_hl
	pop af
	ld [hBattleTurn], a
	ret

GetMonFrontpic:
	ld a, [wEnemySubStatus4]
	bit SUBSTATUS_SUBSTITUTE, a
	ld hl, BattleAnimCmd_RaiseSub
	jr nz, GetFrontpic_DoAnim

DropEnemySub:
	ld a, [wEnemyMinimized]
	and a
	ld hl, BattleAnimCmd_MinimizeOpp
	jr nz, GetFrontpic_DoAnim

	ld a, [wCurPartySpecies]
	push af
	ld a, [EnemyMonSpecies]
	ld [wCurSpecies], a
	ld [wCurPartySpecies], a
	call GetBaseData
	ld de, VTiles2
	predef GetAnimatedFrontpic
	pop af
	ld [wCurPartySpecies], a
	ret

GetFrontpic_DoAnim:
	ld a, [hBattleTurn]
	push af
	call SetEnemyTurn
	ld a, BANK(BattleAnimCommands)
	call FarCall_hl
	pop af
	ld [hBattleTurn], a
	ret

StartBattle:
; This check prevents you from entering a battle without any Pokemon.
; Those using walk-through-walls to bypass getting a Pokemon experience
; the effects of this check.
	call CancelMapSign
	ld a, [wPartyCount]
	and a
	ret z

	ld a, [TimeOfDayPal]
	push af
	call BattleIntro
	ld c, STOPWATCH_BATTLE
	callba RestartStopwatch
	call DoBattle
	ld hl, wStopwatchControl
	res STOPWATCH_BATTLE, [hl]
	call ExitBattle
	pop af
	ld [TimeOfDayPal], a
	call .UpdateBattleCounter
	call .UpdateBattleTotalTime
	scf
	ret
.UpdateBattleCounter:
	ld a, [wBattleResult]
	and 15
	ret nz
	ld hl, wBattlesWonCounter
	inc [hl]
	ret nz
	rept 2
		inc hl
		inc [hl]
		ret nz
	endr
	ld a, $ff
	ld [hld], a
	ld [hld], a
	ld [hl], a
	ret
.UpdateBattleTotalTime:
	lb bc, STOPWATCH_READ_FORMATTED, STOPWATCH_BATTLE
	callba ReadStopwatch
	ld hl, wTotalBattleTime + 5
	ld a, [hl]
	add a, e
	cp 100
	jr c, .noCarryHundredths
	sub 100
.noCarryHundredths
	ccf
	ld [hld], a
	ld a, [hl]
	adc d
	cp 60
	jr c, .noCarrySeconds
	sub 60
.noCarrySeconds
	ccf
	ld [hld], a
	ld a, [hl]
	adc c
	cp 60
	jr c, .noCarryMinutes
	sub 60
.noCarryMinutes
	ccf
	ld [hld], a
	ld a, [hLongQuotient + 3]
	adc [hl]
	ld [hld], a
	ld a, [hLongQuotient + 2]
	adc [hl]
	ld [hld], a
	ret nc
	inc [hl]
	ret

BattleIntro:
	call LoadTrainerOrWildMonPic
	xor a
	ld [TempBattleMonSpecies], a
	ld [wd0d2], a
	ld [hMapAnims], a
	callba DoBattleStartFunctions
	call InitEnemy
	call BackUpVBGMap2
	ld b, SCGB_BATTLE_GRAYSCALE
	predef GetSGBLayout
	ld hl, rLCDC
	res 6, [hl]
	call InitBattleDisplay
	call BattleStartMessage
	ld hl, rLCDC
	set 6, [hl]
	xor a
	ld [hBGMapMode], a
	call EmptyBattleTextBox
	hlcoord 9, 7
	lb bc, 5, 11
	call ClearBox
	hlcoord 1, 0
	lb bc, 4, 10
	call ClearBox
	call ClearSprites
	ld a, [wBattleMode]
	cp WILD_BATTLE
	call z, UpdateEnemyHUD
	ld a, $1
	ld [hBGMapMode], a
	ret

LoadTrainerOrWildMonPic:
	ld a, [OtherTrainerClass]
	and a
	jr nz, .Trainer
	ld a, [TempWildMonSpecies]
	ld [wCurPartySpecies], a

.Trainer
	ld [TempEnemyMonSpecies], a
	ret

InitEnemy:
	ld a, [OtherTrainerClass]
	and a
	jp nz, InitEnemyTrainer ; trainer
	jp InitEnemyWildmon ; wild

BackUpVBGMap2:
	ld a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ld [rSVBK], a
	ld hl, wDecompressScratch
	ld bc, $40 tiles ; VBGMap3 - VBGMap2
	ld a, $2
	call ByteFill
	ld a, [rVBK]
	push af
	ld a, $1
	ld [rVBK], a
	ld de, wDecompressScratch
	hlbgcoord 0, 0 ; VBGMap2
	lb bc, BANK(BackUpVBGMap2), $40
	call Request2bpp
	pop af
	ld [rVBK], a
	pop af
	ld [rSVBK], a
	ret

InitEnemyTrainer:
	ld [TrainerClass], a
	xor a
	ld [TempEnemyMonSpecies], a
	callba GetTrainerAttributes
	callba ReadTrainerParty

	ld a, [TrainerClass]
	cp RIVAL1
	jr nz, .ok
	xor a
	ld [OTPartyMon1Item], a
.ok

	ld de, VTiles2
	predef GetTrainerPic
	xor a
	ld [hGraphicStartTile], a
	dec a
	ld [wEnemyItemState], a
	hlcoord 12, 0
	lb bc, 7, 7
	predef PlaceGraphic
	ld a, -1
	ld [CurOTMon], a
	ld a, TRAINER_BATTLE
	ld [wBattleMode], a

	call IsJohtoGymLeader
	ret nc
	xor a
	ld [wCurPartyMon], a
	ld a, [wPartyCount]
	ld b, a
.partyloop
	push bc
	ld a, MON_HP
	call GetPartyParamLocation
	ld a, [hli]
	or [hl]
	jr z, .skipfaintedmon
	ld c, HAPPINESS_GYMBATTLE
	callba ChangeHappiness
.skipfaintedmon
	pop bc
	dec b
	ret z
	ld hl, wCurPartyMon
	inc [hl]
	jr .partyloop

InitEnemyWildmon:
	ld a, WILD_BATTLE
	ld [wBattleMode], a
	call LoadEnemyMon
	ld hl, EnemyMonMoves
	ld de, wWildMonMoves
	ld bc, NUM_MOVES
	rst CopyBytes
	ld hl, EnemyMonPP
	ld de, wWildMonPP
	ld bc, NUM_MOVES
	rst CopyBytes
	ld a, [wCurPartySpecies]
	ld de, VTiles2
	predef GetAnimatedFrontpic
	xor a
	ld [TrainerClass], a
	ld [hGraphicStartTile], a
	hlcoord 12, 0
	lb bc, 7, 7
	predef_jump PlaceGraphic

ExitBattle:
	call .HandleEndOfBattle
	call BattleEnd_HandleRoamMons
	xor a
	ld [Danger], a
	ld [wBattleMode], a
	ld [wBattleType], a
	ld [AttackMissed], a
	ld [TempWildMonSpecies], a
	ld [OtherTrainerClass], a
	ld [wFailedToFlee], a
	ld [wNumFleeAttempts], a
	ld [wForcedSwitch], a
	ld [wPartyMenuCursor], a
	ld [wKeyItemsPocketCursor], a
	ld [wItemsPocketCursor], a
	ld [wd0d2], a
	ld [CurMoveNum], a
	ld [wBallsPocketCursor], a
	ld [wLastPocket], a
	ld [wMenuScrollPosition], a
	ld [wKeyItemsPocketScrollPosition], a
	ld [wItemsPocketScrollPosition], a
	ld [wBallsPocketScrollPosition], a
	ld hl, wPlayerSubStatus1
	ld b, EnemyFuryCutterCount - wPlayerSubStatus1
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	jp WaitSFX

.HandleEndOfBattle
	ld a, [wLinkMode]
	and a
	jr z, .notLinked
	call ShowLinkBattleParticipantsAfterEnd
	ld c, 150
	call DelayFrames
	jp DetermineLinkBattleResult

.notLinked
	ld a, [wBattleResult]
	and $f
	ret nz
	call CheckPayDay
	call NaturalCure_HealPartyStatus
	xor a
	ld [wForceEvolution], a
	callba EvolveAfterBattle
	jpba GivePokerusAndConvertBerries

CheckPayDay:
	ld hl, wPayDayMoney
	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	ret z
	ld a, [wAmuletCoin]
	and a
	jr z, .okay
	ld hl, wPayDayMoney + 2
	sla [hl]
	dec hl
	rl [hl]
	dec hl
	rl [hl]
	jr nc, .okay
	ld a, $ff
	ld [hli], a
	ld [hli], a
	ld [hl], a

.okay
	ld hl, wPayDayMoney + 2
	ld de, Money + 2
	call AddBattleMoneyToAccount
	ld hl, BattleText_PlayerPickedUpPayDayMoney
	call StdBattleTextBox
	ld a, [InBattleTowerBattle]
	and 5
	ret z
	call ClearTileMap
	jp ClearBGPalettes

NaturalCure_HealPartyStatus:
	ld hl, wPartyMon1
	ld a, [wPartyCount]
	ld c, a
.loop
	call CalcPartyMonAbility
	cp ABILITY_NATURAL_CURE
	jr nz, .next
	push hl
	ld de, MON_STATUS
	add hl, de
	ld [hl], 0
	pop hl
.next
	ld de, PARTYMON_STRUCT_LENGTH
	add hl, de
	dec c
	jr nz, .loop
	ret

ShowLinkBattleParticipantsAfterEnd:
	ld a, [CurOTMon]
	ld hl, OTPartyMon1Status
	call GetPartyLocation
	ld a, [EnemyMonStatus]
	ld [hl], a
	call ClearTileMap
	jpba _ShowLinkBattleParticipants

DetermineLinkBattleResult:
	callba _DetermineLinkBattleResult

	ld a, [wBattleResult]
	and $f
	cp $1
	jr c, .victory
	jr z, .loss
	ld de, .Draw
	jr .storeResult

.victory
	ld de, .Win
	jr .storeResult

.loss
	ld de, .Lose

.storeResult
	hlcoord 6, 8
	call PlaceText
	ld c, 200
	call DelayFrames

	ld a, BANK(sLinkBattleStats)
	call GetSRAMBank

	call AddLastLinkBattleToLinkRecord
	call ReadAndPrintLinkBattleRecord

	call CloseSRAM
	call WaitPressAorB_BlinkCursor
	jp ClearTileMap

.Win
	text "YOU WIN"
	done
.Lose
	text "YOU LOSE"
	done
.Draw
	text "  DRAW"
	done

DisplayLinkRecord:
	ld a, BANK(sLinkBattleStats)
	call GetSRAMBank

	call ReadAndPrintLinkBattleRecord

	call CloseSRAM
	hlcoord 0, 0, AttrMap
	xor a
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	call ByteFill
	call ApplyAttrAndTilemapInVBlank
	ld b, SCGB_SCROLLINGMENU
	predef GetSGBLayout
	call SetPalettes
	ld c, 8
	call DelayFrames
	jp WaitPressAorB_BlinkCursor

ReadAndPrintLinkBattleRecord:
	call ClearTileMap
	call ClearSprites
	call .PrintBattleRecord
	hlcoord 0, 8
	ld b, 5
	ld de, sLinkBattleRecord + 2
.loop
	push bc
	push hl
	push de
	ld a, [de]
	and a
	jr z, .PrintFormatString
	ld a, [wSavedAtLeastOnce]
	and a
	jr z, .PrintFormatString
	push hl
	push hl
	ld h, d
	ld l, e
	ld de, wBufferMonNick
	ld bc, 10
	rst CopyBytes
	ld a, "@"
	ld [de], a
	inc de
	ld bc, 6
	rst CopyBytes
	ld de, wBufferMonNick
	pop hl
	call PlaceString
	pop hl
	ld de, 26
	add hl, de
	push hl
	ld de, wBufferMonOT
	lb bc, 2, 4
	push bc
	call PrintNum
	pop bc
	pop hl
	ld de, 5
	add hl, de
	push hl
	ld de, wBufferMonOT + 2
	push bc
	call PrintNum
	pop bc
	pop hl
	ld de, 5
	add hl, de
	ld de, wBufferMonOT + 4
	call PrintNum
	jr .next

.PrintFormatString
	ld de, .Format
	call PlaceText
.next
	pop hl
	ld bc, 18
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld bc, 2 * SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .loop
	ret

.PrintBattleRecord
	hlcoord 1, 0
	ld de, .Record
	call PlaceText

	hlcoord 0, 6
	ld de, .Result
	call PlaceText

	hlcoord 0, 2
	ld de, .Total
	call PlaceText

	hlcoord 6, 4
	ld de, sLinkBattleWins
	call .PrintZerosIfNoSaveFileExists
	ret c

	lb bc, 2, 4
	push bc
	call PrintNum

	hlcoord 11, 4
	ld de, sLinkBattleLosses
	call .PrintZerosIfNoSaveFileExists

	pop bc
	push bc
	call PrintNum

	hlcoord 16, 4
	ld de, sLinkBattleDraws
	call .PrintZerosIfNoSaveFileExists

	pop bc
	jp PrintNum

.PrintZerosIfNoSaveFileExists
	ld a, [wSavedAtLeastOnce]
	and a
	ret nz
	ld de, .zero_scores
	call PlaceText
	scf
	ret

.zero_scores
	ctxt "   0    0    0"
	done

.Format
	ctxt "  ---  "
	nl   "         -    -    -"
	done
.Record
	text "<PLAYER>'s RECORD"
	done
.Result
	text "RESULT WIN LOSE DRAW"
	done
.Total
	text "TOTAL  WIN LOSE DRAW"
	done

BattleEnd_HandleRoamMons:
	ld a, [wBattleType]
	cp BATTLETYPE_ROAMING
	jr nz, .not_roaming
	ld a, [wBattleResult]
	and $f
	jr z, .caught_or_defeated_roam_mon
	ld hl, wRoamMon1HP
	ld a, [EnemyMonHP]
	ld [hli],  a
	ld a, [EnemyMonHP + 1]
	ld [hl], a
	jr .update_roam_mons

.caught_or_defeated_roam_mon
	ld hl, wRoamMon1HP
	xor a
	ld [hli], a
	ld [hl], a
	dec a
	ld hl, wRoamMon1MapGroup
	ld [hl], a
	ld hl, wRoamMon1MapNumber
	ld [hl], a
	inc a
	ld hl, wRoamMon1Species
	ld [hl], a
	ret

.not_roaming
	call BattleRandom
	and $f
	ret nz

.update_roam_mons
	jpba UpdateRoamMons

AddLastLinkBattleToLinkRecord:
	ld hl, OTPlayerID
	ld de, wStringBuffer1
	ld bc, 2
	rst CopyBytes
	ld hl, OTPlayerName
	ld bc, NAME_LENGTH - 1
	rst CopyBytes
	ld hl, sLinkBattleResults
	call .StoreResult
	ld hl, sLinkBattleRecord
	ld d, 5
.loop
	push hl
	inc hl
	inc hl
	ld a, [hld]
	dec hl
	and a
	jr z, .copy
	push de
	ld c, 12
	ld de, wStringBuffer1
	call StringCmp
	pop de
	pop hl
	jr z, .done
	ld bc, 18
	add hl, bc
	dec d
	jr nz, .loop
	ld bc, -18
	add hl, bc
	push hl

.copy
	ld d, h
	ld e, l
	ld hl, wStringBuffer1
	ld bc, 12
	rst CopyBytes
	ld b, 6
	xor a
.loop2
	ld [de], a
	inc de
	dec b
	jr nz, .loop2
	pop hl

.done
	call .StoreResult
	jp .FindOpponentAndAppendRecord

.StoreResult
	ld a, [wBattleResult]
	and $f
	cp $1
	ld bc, sLinkBattleWins + 1 - sLinkBattleResults
	jr c, .okay
	ld bc, sLinkBattleLosses + 1 - sLinkBattleResults
	jr z, .okay
	ld bc, sLinkBattleDraws + 1 - sLinkBattleResults
.okay
	add hl, bc
	call .CheckOverflow
	ret nc
	inc [hl]
	ret nz
	dec hl
	inc [hl]
	ret

.CheckOverflow
	dec hl
	ld a, [hl]
	inc hl
	cp 9999 / $100
	ret c
	ld a, [hl]
	cp 9999 % $100
	ret

.FindOpponentAndAppendRecord
	ld b, 5
	ld hl, sLinkBattleRecord + 17
	ld de, wd002
.loop3
	push bc
	push de
	push hl
	call .LoadPointer
	pop hl
	ld a, e
	pop de
	ld [de], a
	inc de
	ld a, b
	ld [de], a
	inc de
	ld a, c
	ld [de], a
	inc de
	ld bc, 18
	add hl, bc
	pop bc
	dec b
	jr nz, .loop3
	lb bc, $0, $1
.loop4
	ld a, b
	add b
	add b
	ld e, a
	ld d, $0
	ld hl, wd002
	add hl, de
	push hl
	ld a, c
	add c
	add c
	ld e, a
	ld hl, wd002
	add hl, de
	ld d, h
	ld e, l
	pop hl
	push bc
	ld c, 3
	call StringCmp
	pop bc
	jr z, .equal
	jr nc, .done2

.equal
	inc c
	ld a, c
	cp $5
	jr nz, .loop4
	inc b
	ld c, b
	inc c
	ld a, b
	cp $4
	jr nz, .loop4
	ret

.done2
	push bc
	ld a, b
	ld bc, 18
	ld hl, sLinkBattleRecord
	rst AddNTimes
	push hl
	ld de, wd002
	ld bc, 18
	rst CopyBytes
	pop hl
	pop bc
	push hl
	ld a, c
	ld bc, 18
	ld hl, sLinkBattleRecord
	rst AddNTimes
	pop de
	push hl
	ld bc, 18
	rst CopyBytes
	ld hl, wd002
	ld bc, 18
	pop de
	rst CopyBytes
	ret

.LoadPointer
	ld e, $0
	ld a, [hld]
	ld c, a
	ld a, [hld]
	ld b, a
	ld a, [hld]
	add c
	ld c, a
	ld a, [hld]
	adc b
	ld b, a
	jr nc, .okay2
	inc e

.okay2
	ld a, [hld]
	add c
	ld c, a
	ld a, [hl]
	adc b
	ld b, a
	ret nc
	inc e
	ret

InitBattleDisplay:
	call .InitBackPic
	hlcoord 0, 12
	lb bc, 4, 18
	call TextBox
	hlcoord 1, 5
	lb bc, 3, 7
	call ClearBox
	call LoadStandardFont
	call _LoadBattleFontsHPBar
	call .BlankBGMap
	xor a
	ld [hMapAnims], a
	ld [hSCY], a
	ld a, $90
	ld [hWY], a
	ld [rWY], a
	call ApplyTilemapInVBlank
	xor a
	ld [hBGMapMode], a
	callba BattleIntroSlidingPics
	ld a, $1
	ld [hBGMapMode], a
	ld a, $31
	ld [hGraphicStartTile], a
	hlcoord 2, 6
	lb bc, 6, 6
	predef PlaceGraphic
	xor a
	ld [hWY], a
	ld [rWY], a
	call ApplyTilemapInVBlank
	call HideSprites
	ld b, SCGB_BATTLE_COLORS
	predef GetSGBLayout
	call SetPalettes
	ld a, $90
	ld [hWY], a
	xor a
	ld [hSCX], a
	ret

.BlankBGMap
	ld a, [rSVBK]
	push af
	ld a, $6
	ld [rSVBK], a

	ld hl, wDecompressScratch
	ld bc, wBackupAttrMap - wDecompressScratch
	ld a, " "
	call ByteFill

	ld de, wDecompressScratch
	hlbgcoord 0, 0
	lb bc, BANK(InitBattleDisplay), $40
	call Request2bpp

	pop af
	ld [rSVBK], a
	ret

.InitBackPic
	CheckEngine ENGINE_POKEMON_MODE
	jr z, .playerBackpic

	ld hl, PartyMon1HP
	ld de, PARTYMON_STRUCT_LENGTH - 1
	ld c, 0
	jr .handleLoop
.loop
	add hl, de
	inc c
.handleLoop
	ld a, [hli]
	or [hl]
	jr z, .loop
	ld b, $0
	ld hl, wPartySpecies
	add hl, bc
	ld a, [wCurPartySpecies]
	push af
	ld a, [hl]
	ld [wCurPartySpecies], a
	ld [TempBattleMonSpecies], a
	ld de, VTiles2 tile $31
	predef GetBackpic
	pop af
	ld [wCurPartySpecies], a
	jr .continue

.playerBackpic
	callba GetTrainerBackpic
.continue
	ld a, [rSVBK]
	push af
	ld a, $6
	ld [rSVBK], a
	ld hl, VTiles0
	ld de, VTiles2 tile $31
	lb bc, BANK(InitBattleDisplay), 7 * 7
	call Get2bpp
	pop af
	ld [rSVBK], a
	call .LoadTrainerBackpicAsOAM
	ld a, $31
	ld [hGraphicStartTile], a
	hlcoord 2, 6
	lb bc, 6, 6
	predef_jump PlaceGraphic

.LoadTrainerBackpicAsOAM
	ld hl, Sprites
	xor a
	ld [hMapObjectIndexBuffer], a
	ld b, $6
	ld e, 21 * 8
.outer_loop
	ld c, $3
	ld d, 8 * 8
.inner_loop
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, [hMapObjectIndexBuffer]
	ld [hli], a
	inc a
	ld [hMapObjectIndexBuffer], a
	ld a, $1
	ld [hli], a
	ld a, d
	add $8
	ld d, a
	dec c
	jr nz, .inner_loop
	ld a, [hMapObjectIndexBuffer]
	add $3
	ld [hMapObjectIndexBuffer], a
	ld a, e
	add $8
	ld e, a
	dec b
	jr nz, .outer_loop
	ret

BattleStartMessage:
	ld a, [wBattleMode]
	dec a
	jr z, .wild

	ld de, SFX_SHINE
	call PlayWaitSFX

	ld c, 20
	call DelayFrames

	callba Battle_GetTrainerName

	ld hl, WantsToBattleText
	jr .PlaceBattleStartText

.wild
	call BattleCheckEnemyShininess
	jr nc, .not_shiny

	xor a
	ld [wNumHits], a
	ld a, 1
	ld [hBattleTurn], a
	ld [wBattleAnimParam], a
	ld de, ANIM_SEND_OUT_MON
	call Call_PlayBattleAnim

.not_shiny
	callba CheckSleepingTreeMon
	jr c, .skip_cry

	;call CheckBattleScene
	;jr c, .cry_no_anim

	hlcoord 12, 0
	lb de, $0, ANIM_MON_NORMAL
	predef AnimateFrontpic
	jr .skip_cry ; cry is played during the animation

.cry_no_anim
	call DelayFrame
	ld a, $0f
	ld [CryTracks], a
	ld a, [TempEnemyMonSpecies]
	call PlayStereoCry

.skip_cry
	ld a, [wBattleType]
	cp BATTLETYPE_FISH
	jr nz, .NotFishing

	ld hl, HookedPokemonAttackedText
	jr .PlaceBattleStartText

.NotFishing
	ld hl, PokemonFellFromTreeText
	cp BATTLETYPE_TREE
	jr z, .PlaceBattleStartText
	ld hl, WildPokemonAppearedText

.PlaceBattleStartText
	push hl
	callba BattleStart_TrainerHuds
	pop hl
	jp StdBattleTextBox

AbilityOnMonEntrance:
	ld a, [hLinkPlayerNumber]
	cp $1
	jr z, .reverse

	call PlayerAbilityOnMonEntrance
	jr EnemyAbilityOnMonEntrance

.reverse
	call EnemyAbilityOnMonEntrance
PlayerAbilityOnMonEntrance:
	call SetPlayerTurn
	ld hl, wPlayerJustSentMonOut
	jr CheckAbilityOnMonEntrance

EnemyAbilityOnMonEntrance:
	call SetEnemyTurn
	ld hl, wEnemyJustSentMonOut

CheckAbilityOnMonEntrance:
	ld a, [hl]
	and a
	ld [hl], 0
	ret z
	call GetUserAbility_IgnoreMoldBreaker
	ld [wMoveIsAnAbility], a
.DoTraceAbility:
	ld hl, .Abilities
	ld e, 3
	call IsInArray
	jr nc, .skip
	call CallLocalPointer_AfterIsInArray
.skip
	xor a
	ld [wMoveIsAnAbility], a
	ret

.Abilities
	dbw ABILITY_INTIMIDATE, .Intimidate
	dbw ABILITY_PRESSURE, .Pressure
	dbw ABILITY_DRIZZLE, .Drizzle
	dbw ABILITY_DROUGHT, .Drought
	dbw ABILITY_SAND_STREAM, .SandStream
	dbw ABILITY_SNOW_WARNING, .SnowWarning
	dbw ABILITY_TRACE, .Trace
	dbw ABILITY_MOLD_BREAKER, .MoldBreaker
	dbw ABILITY_FRISK, .Frisk
	dbw ABILITY_DOWNLOAD, .Download
	dbw ABILITY_AIR_LOCK, .AirLock
	dbw ABILITY_NATURAL_CURE, .NaturalCure
	db -1

.NaturalCure
	ld a, BATTLE_VARS_STATUS
	call GetBattleVarAddr
	ld [hl], 0
	jp UpdateUserInParty

.Intimidate
	ld a, [hBattleTurn]
	and a
	ld hl, wPlayerMoveStructEffect
	jr z, .okay
	ld hl, wEnemyMoveStructEffect
.okay
	ld [hl], EFFECT_ATTACK_DOWN
	callba BattleCommand_AttackDown
	callba BattleCommand_StatDownMessage
	jpba BattleCommand_StatDownFailText

.Pressure
	ld hl, PressureText
	jp StdBattleTextBox

.Drizzle
	jpba DrizzleFunction

.Drought
	jpba DroughtFunction

.SandStream
	jpba SandStreamFunction

.SnowWarning
	jpba SnowWarningFunction

.Trace
	ld a, BATTLE_VARS_SUBSTATUS2
	call GetBattleVarAddr
	bit SUBSTATUS_TRACED, [hl]
	set SUBSTATUS_TRACED, [hl]
	ret nz
	ld hl, PlayerAbility
	ld de, EnemyAbility
	ld a, [hBattleTurn]
	and a
	jr z, .got_trace_ability
	push hl
	ld h, d
	ld l, e
	pop de
.got_trace_ability
	ld a, [de]
	and a
	call z, CalcTargetAbility
	ld [hl], a
	ld [wd265], a
	ld [wMoveIsAnAbility], a
	call GetAbilityName
	ld hl, TraceText
	call StdBattleTextBox
	jp .DoTraceAbility

.MoldBreaker
	ld hl, BreaksTheMoldText
	jp StdBattleTextBox

.Frisk
	call GetOpponentItem
	ld a, [hl]
	and a
	ret z
	ld [wd265], a
	call GetItemName
	ld hl, FriskText
	jp StdBattleTextBox

.Download
	ld hl, EnemyMonDefense + 1
	ld de, EnemyMonSpclDef + 1
	ld a, [hBattleTurn]
	and a
	jr z, .got_enemy_defs
	ld hl, BattleMonDefense + 1
	ld de, BattleMonSpclDef + 1
.got_enemy_defs
	ld a, [de]
	cp [hl]
	jr c, .boost_special
	jr nz, .boost_physical
	dec de
	dec hl
	ld a, [de]
	cp [hl]
	jr c, .boost_special
	jr nz, .boost_physical
.boost_special
	callba BattleCommand_SpecialAttackUp
	jr .afterFarCall
.boost_physical
	callba BattleCommand_AttackUp
.afterFarCall
	ld a, [FailedMessage]
	and a
	ret nz
	ld a, [wMoveIsAnAbility]
	ld [wd265], a
	call GetAbilityName
	ld hl, DownloadText
	call StdBattleTextBox
	jpba BattleCommand_StatUpMessage

.AirLock
	ld hl, AirLockText
	jp StdBattleTextBox

CheckPlayerArenaTrap:
	ld a, [PlayerAbility]
	cp ABILITY_MAGNET_PULL
	jr z, CheckEnemyIsSteelTypeForMagnetPull
	cp ABILITY_ARENA_TRAP
	jr nz, _NotArenaTrap
	ld a, [EnemyAbility]
	cp ABILITY_LEVITATE
	ret z
	ld hl, EnemyMonType
	jr ArenaTrapTypeCheck

CheckEnemyArenaTrap:
	ld a, [EnemyAbility]
	cp ABILITY_MAGNET_PULL
	jr z, CheckPlayerIsSteelTypeForMagnetPull
	cp ABILITY_ARENA_TRAP
	jr nz, _NotArenaTrap
	ld a, [PlayerAbility]
	cp ABILITY_LEVITATE
	ret z
	ld hl, BattleMonType
	jr ArenaTrapTypeCheck

_NotArenaTrap:
	and a
	ret

ArenaTrapTypeCheck:
	ld a, [hli]
	call .TypeCheck
	ret z
	ld a, [hl]
.TypeCheck
	cp FLYING
	ret z
	cp BIRD
	ret z
	cp GHOST
	ret z
	scf
	ret

CheckEnemyIsSteelTypeForMagnetPull:
	ld hl, EnemyMonType
	jr CheckOpponentIsSteelTypeForMagnetPull

CheckPlayerIsSteelTypeForMagnetPull:
	ld hl, BattleMonType
CheckOpponentIsSteelTypeForMagnetPull:
	ld a, [hli]
	cp STEEL
	jr z, .steel
	ld a, [hl]
	cp STEEL
	jr z, .steel
	and a
	ret

.steel
	scf
	ret

HandleBetweenTurnsAbilities:
	ld a, [hLinkPlayerNumber]
	dec a
	jr z, .player_1
	call SetPlayerTurn
	call .HandleAbility
	call SetEnemyTurn
	jr .HandleAbility

.player_1
	call SetEnemyTurn
	call .HandleAbility
	call SetPlayerTurn
.HandleAbility
	call GetUserAbility_IgnoreMoldBreaker
	and a
	ret z
	ld [wMoveIsAnAbility], a
	ld hl, .Abilities
	ld e, 4
	call IsInArray
	jr nc, .nope
	call FarPointerCall_AfterIsInArray
.nope
	xor a
	ld [wMoveIsAnAbility], a
	ret

.Abilities
	db ABILITY_MOODY
	dba BattleCommand_Moody
	db ABILITY_SPEED_BOOST
	dba BattleCommand_SpeedUp
	db $ff
