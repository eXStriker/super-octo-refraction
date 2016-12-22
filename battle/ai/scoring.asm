typeAbilityCheck: macro
	db \1 ;Type
	db \2 ;Ability
	dw \3 ;Effect
	endm

AI_Basic:
; Don't do anything redundant:
;  -Using status-only moves if the player can't be statused
;  -Using moves that fail if they've already been used

	ld hl, wAIMoveScores - 1
	ld de, EnemyMonMoves
	ld b, EnemyMonMovesEnd - EnemyMonMoves + 1
.checkmove
	dec b
	ret z

	inc hl
	ld a, [de]
	and a
	ret z

	inc de
	call AIGetEnemyMove

	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	ld c, a

; Dismiss moves with special effects if they are
; useless or not a good choice right now.
; For example, healing moves, weather moves, Dream Eater...
	push hl
	push de
	push bc
	callba AI_Redundant
	pop bc
	pop de
	pop hl
	jr nz, .discourage

; Dismiss status-only moves if the player can't be statused.
	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	push hl
	push de
	push bc
	ld hl, .statusonlyeffects
	call IsInSingularArray

	pop bc
	pop de
	pop hl
	jr nc, .checkmove

	ld a, [BattleMonStatus]
	and a
	jr nz, .discourage

; Dismiss Safeguard if it's already active.
	ld a, [wPlayerScreens]
	bit SCREENS_SAFEGUARD, a
	jr z, .checkmove

.discourage
	call AIDiscourageMove
	jr .checkmove
; 385db

.statusonlyeffects
	db EFFECT_SLEEP
	db EFFECT_TOXIC
	db EFFECT_POISON
	db EFFECT_PARALYZE
	db EFFECT_WILL_O_WISP
	db $ff

AI_Setup:
; Use stat-modifying moves on turn 1.

; 50% chance to greatly encourage stat-up moves during the first turn of enemy's Pokemon.
; 50% chance to greatly encourage stat-down moves during the first turn of player's Pokemon.
; Almost 90% chance to greatly discourage stat-modifying moves otherwise.

	ld hl, wAIMoveScores - 1
	ld de, EnemyMonMoves
	ld b, EnemyMonMovesEnd - EnemyMonMoves + 1
.checkmove
	dec b
	ret z

	inc hl
	ld a, [de]
	and a
	ret z

	inc de
	call AIGetEnemyMove

	ld a, [wEnemyMoveStruct + MOVE_EFFECT]

	cp EFFECT_ATTACK_UP
	jr c, .checkmove
	cp EFFECT_EVASION_UP + 1
	jr c, .statup

;	cp EFFECT_ATTACK_DOWN - 1
	jr z, .checkmove
	cp EFFECT_EVASION_DOWN + 1
	jr c, .statdown

	cp EFFECT_ATTACK_UP_2
	jr c, .checkmove
	cp EFFECT_EVASION_UP_2 + 1
	jr c, .statup

;	cp EFFECT_ATTACK_DOWN_2 - 1
	jr z, .checkmove
	cp EFFECT_EVASION_DOWN_2 + 1
	jr c, .statdown

	jr .checkmove

.statup
	ld a, [EnemyTurnsTaken]
	and a
	jr nz, .discourage

	jr .encourage

.statdown
	ld a, [PlayerTurnsTaken]
	and a
	jr nz, .discourage

.encourage
	call AI_50_50
	jr c, .checkmove

	dec [hl]
	dec [hl]
	jr .checkmove

.discourage
	call Random
	cp 30
	jr c, .checkmove
	inc [hl]
	inc [hl]
	jr .checkmove

AI_Types:
; Dismiss any move that the player is immune to.
; Encourage super-effective moves.
; Discourage not very effective moves unless
; all damaging moves are of the same type.

	ld hl, wAIMoveScores - 1
	ld de, EnemyMonMoves
	ld b, EnemyMonMovesEnd - EnemyMonMoves + 1
.checkmove
	dec b
	ret z

	inc hl
	ld a, [de]
	and a
	ret z

	inc de
	call AIGetEnemyMove

	push hl
	push bc
	push de
	ld a, 1
	ld [hBattleTurn], a
	predef BattleCheckTypeMatchup
	pop de
	pop bc
	pop hl

	ld a, [wd265]
	and a
	jr nz, .notImmune
	call AIDiscourageMove
	jr .checkmove
.notImmune
	cp 10 ; 1.0
	jp z, .checkInAPinchAbility
	jr c, .noteffective

; effective
	ld a, [wEnemyMoveStruct + MOVE_POWER]
	and a
	jr z, .checkInAPinchAbility
	
.super
	dec [hl]
	jr .checkInAPinchAbility

.noteffective
; Discourage this move if there are any moves
; that do damage of a different type.
	push hl
	push de
	push bc
	call GetEnemyMoveType
	ld d, a
	ld hl, EnemyMonMoves
	ld b, EnemyMonMovesEnd - EnemyMonMoves + 1
	ld c, 0
.checkmove2
	dec b
	jr z, .doneCheckingNotEffectiveMove

	ld a, [hli]
	and a
	jr z, .doneCheckingNotEffectiveMove

	call AIGetEnemyMove
	call GetEnemyMoveType
	cp d
	jr z, .checkmove2
	ld a, [wEnemyMoveStruct + MOVE_POWER]
	and a
	jr nz, .storeNonZeroMovePower
	jr .checkmove2

.storeNonZeroMovePower
	ld c, a
.doneCheckingNotEffectiveMove
	ld a, c
	pop bc
	pop de
	pop hl
	and a
	jr z, .checkInAPinchAbility
	inc [hl]

.checkInAPinchAbility
	push hl
	push de
	push bc
	dec de
	ld a, [de]
	call AIGetEnemyMove
	call GetEnemyMoveType
	ld b, a
	ld a, [EnemyAbility]
	ld c, a
	ld hl, .typeBoostAbilities
	jr .boostLoop
.wrongAbility
	inc hl
.boostLoop
	ld a, [hli]
	cp -1
	jr z, .noMoreAbilities
	
	cp c
	jr nz, .wrongAbility ;Wrong ability
	
	ld a, [hli]
	cp b 
	jr nz, .boostLoop ;Wrong move type
	
	;Pokemon is using a move that will have its power boosted if under 
	callba GetThirdMaxHP
	ld hl, EnemyMonHP + 1
	ld a, [hld]
	ld d, [hl]
	sub c
	ld a, d
	sbc b
.noMoreAbilities
	pop bc
	pop de
	pop hl
	jr nc, .checkmove_jr
	inc [hl]
.checkmove_jr
	jp .checkmove
	
.typeBoostAbilities
	db ABILITY_OVERGROW, GRASS
	db ABILITY_BLAZE,    FIRE
	db ABILITY_TORRENT,  WATER
	db ABILITY_SWARM,    BUG
	db $ff

AI_Offensive:
; Greatly discourage non-damaging moves.

	ld hl, wAIMoveScores - 1
	ld de, EnemyMonMoves
	ld b, EnemyMonMovesEnd - EnemyMonMoves + 1
.checkmove
	dec b
	ret z

	inc hl
	ld a, [de]
	and a
	ret z

	inc de
	call AIGetEnemyMove

	ld a, [wEnemyMoveStruct + MOVE_POWER]
	and a
	jr nz, .checkmove

	inc [hl]
	inc [hl]
	jr .checkmove

AI_Smart:
; Context-specific scoring.

	ld hl, wAIMoveScores
	ld de, EnemyMonMoves
	ld b, EnemyMonMovesEnd - EnemyMonMoves + 1
.checkmove
	dec b
	ret z

	ld a, [de]
	inc de
	and a
	ret z

	push de
	push bc
	push hl
	call AIGetEnemyMove
	
	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	ld hl, .table_386f2
	ld e, 3
	call IsInArray

	inc hl
	jr nc, .nextmove

	ld a, [hli]
	ld e, a
	ld d, [hl]

	pop hl
	push hl

	ld bc, .nextmove
	push bc

	push de
	ret

.nextmove
	pop hl
	pop bc
	pop de
	inc hl
	jr .checkmove

.table_386f2
	dbw EFFECT_SLEEP,            AI_Smart_Sleep
	dbw EFFECT_LEECH_HIT,        AI_Smart_LeechHit
	dbw EFFECT_EXPLOSION,        AI_Smart_Explosion
	dbw EFFECT_DREAM_EATER,      AI_Smart_DreamEater
	dbw EFFECT_MIRROR_MOVE,      AI_Smart_MirrorMove
	dbw EFFECT_EVASION_UP,       AI_Smart_EvasionUp
	dbw EFFECT_ALWAYS_HIT,       AI_Smart_AlwaysHit
	dbw EFFECT_ACCURACY_DOWN,    AI_Smart_AccuracyDown
	dbw EFFECT_HAZE,             AI_Smart_Haze
	dbw EFFECT_WHIRLWIND,        AI_Smart_Whirlwind
	dbw EFFECT_HEAL,             AI_Smart_Heal
	dbw EFFECT_TOXIC,            AI_Smart_Toxic
	dbw EFFECT_LIGHT_SCREEN,     AI_Smart_LightScreen
	dbw EFFECT_RAZOR_WIND,       AI_Smart_RazorWind
	dbw EFFECT_BIND,             AI_Smart_Bind
	dbw EFFECT_TORNADO,          AI_Smart_DustDevil
	dbw EFFECT_CONFUSE,          AI_Smart_Confuse
	dbw EFFECT_SP_DEF_UP_2,      AI_Smart_SpDefenseUp2
	dbw EFFECT_REFLECT,          AI_Smart_Reflect
	dbw EFFECT_PARALYZE,         AI_Smart_Paralyze
	dbw EFFECT_SPEED_DOWN_HIT,   AI_Smart_SpeedDownHit
	dbw EFFECT_SUBSTITUTE,       AI_Smart_Substitute
	dbw EFFECT_HYPER_BEAM,       AI_Smart_HyperBeam
	dbw EFFECT_LEECH_SEED,       AI_Smart_LeechSeed
	dbw EFFECT_DISABLE,          AI_Smart_Disable
	dbw EFFECT_COUNTER,          AI_Smart_Counter
	dbw EFFECT_ENCORE,           AI_Smart_Encore
	dbw EFFECT_CONVERSION2,      AI_Smart_Conversion2
	dbw EFFECT_LOCK_ON,          AI_Smart_LockOn
	dbw EFFECT_DEFROST_OPPONENT, AI_Smart_DefrostOpponent
	dbw EFFECT_SLEEP_TALK,       AI_Smart_SleepTalk
	dbw EFFECT_DESTINY_BOND,     AI_Smart_DestinyBond
	dbw EFFECT_REVERSAL,         AI_Smart_Reversal
	dbw EFFECT_SPITE,            AI_Smart_Spite
	dbw EFFECT_HEAL_BELL,        AI_Smart_HealBell
	dbw EFFECT_PRIORITY_HIT,     AI_Smart_PriorityHit
	dbw EFFECT_THIEF,            AI_Smart_Thief
	dbw EFFECT_MEAN_LOOK,        AI_Smart_MeanLook
	dbw EFFECT_NIGHTMARE,        AI_Smart_Nightmare
	dbw EFFECT_FLAME_WHEEL,      AI_Smart_FlameWheel
	dbw EFFECT_CURSE,            AI_Smart_Curse
	dbw EFFECT_PROTECT,          AI_Smart_Protect
	dbw EFFECT_FORESIGHT,        AI_Smart_Foresight
	dbw EFFECT_PERISH_SONG,      AI_Smart_PerishSong
	dbw EFFECT_SANDSTORM,        AI_Smart_Sandstorm
	dbw EFFECT_HAIL,             AI_Smart_Hail
	dbw EFFECT_ENDURE,           AI_Smart_Endure
	dbw EFFECT_ROLLOUT,          AI_Smart_Rollout
	dbw EFFECT_SWAGGER,          AI_Smart_Swagger
	dbw EFFECT_FURY_CUTTER,      AI_Smart_FuryCutter
	dbw EFFECT_ATTRACT,          AI_Smart_Attract
	dbw EFFECT_SAFEGUARD,        AI_Smart_Safeguard
	dbw EFFECT_MAGNITUDE,        AI_Smart_Magnitude
	dbw EFFECT_BATON_PASS,       AI_Smart_BatonPass
	dbw EFFECT_PURSUIT,          AI_Smart_Pursuit
	dbw EFFECT_RAPID_SPIN,       AI_Smart_RapidSpin
	dbw EFFECT_MORNING_SUN,      AI_Smart_MorningSun
	dbw EFFECT_SYNTHESIS,        AI_Smart_Synthesis
	dbw EFFECT_MOONLIGHT,        AI_Smart_Moonlight
	dbw EFFECT_HIDDEN_POWER,     AI_Smart_HiddenPower
	dbw EFFECT_RAIN_DANCE,       AI_Smart_RainDance
	dbw EFFECT_SUNNY_DAY,        AI_Smart_SunnyDay
	dbw EFFECT_TWISTER,          AI_Smart_Twister
	dbw EFFECT_EARTHQUAKE,       AI_Smart_Earthquake
	dbw EFFECT_FUTURE_SIGHT,     AI_Smart_FutureSight
	dbw EFFECT_GUST,             AI_Smart_Gust
	dbw EFFECT_STOMP,            AI_Smart_Stomp
	dbw EFFECT_SOLARBEAM,        AI_Smart_Solarbeam
	dbw EFFECT_THUNDER,          AI_Smart_Thunder
	dbw EFFECT_FLY,              AI_Smart_Fly
	dbw EFFECT_FINAL_CHANCE,     AI_Final_Chance
	dbw EFFECT_METALLURGY,       AI_Metallurgy
	dbw EFFECT_VAPORIZE,         AI_Vaporize 
	dbw EFFECT_NATURE_POWER,     AI_NaturePower
	dbw EFFECT_FLARE_BLITZ,      AI_FlareBlitz
	db $ff
	
AI_FlareBlitz: ;Discourage if health is below 25%
	call AICheckEnemyQuarterHP
	ret c
	dec [hl]
	ret
	
AI_NaturePower:
	push hl
	
	ld hl, NaturePowerMoves
	ld a, [wTileset]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, BANK(NaturePowerMoves)
	call GetFarByte
	and a
	call z, .tileset2
	
	dec a
	ld hl, Moves + MOVE_TYPE
	ld bc, MOVE_LENGTH
	rst AddNTimes

	ld a, BANK(Moves) ;Get move type
	call GetFarByte
	and $3f
	
	ld [wEnemyMoveStruct + MOVE_TYPE], a
	ld a, 1
	ld [hBattleTurn], a
	predef BattleCheckTypeMatchup 
	ld a, [wd265] ;Get effectiveness
	
	pop hl
	and a
	jp z, AIDiscourageMove
	
	cp 10
	jr z, .neutral
	jr c, .discourage
	dec [hl]
	ret
	
.discourage
	inc [hl]
.neutral
	ret
	
.tileset2
	ld a, [MapGroup]
	cp GROUP_ROUTE_70
	jr z, .snowroute
	cp GROUP_ROUTE_84
	jr z, .snowroute
	cp GROUP_ROUTE_85
	jr z, .fireroute
; any other route
	ld a, ENERGY_BALL
	ret

.snowroute
	ld a, ICE_BEAM
	ret

.fireroute
	ld a, FLAMETHROWER
	ret
	
AI_Vaporize:
	ld a, [BattleMonType1]
	cp WATER
	jr nz, .ok
	
	ld a, [BattleMonType2]
	cp WATER
	jp z, AIDiscourageMove
	
.ok ;Encourage if the Pokemon's type is super effective against the player's
	ld a, [EnemyMonType1]
	call .checkType
	ld a, [EnemyMonType2]

.checkType
	push hl
	
	ld [wEnemyMoveStruct + MOVE_TYPE], a
	ld a, 1
	ld [hBattleTurn], a
	predef BattleCheckTypeMatchup 
	ld a, [wd265]
	ld c, a
	
	ld hl, BattleMonType1
	ld a, [hli]
	ld d, a
	ld a, [hl]
	ld e, a
	
	ld a, WATER
	ld [BattleMonType1], a
	ld [BattleMonType2], a
	
	push bc
	push de
	predef BattleCheckTypeMatchup 
	pop de
	pop bc
	
	ld hl, BattleMonType1
	ld a, d
	ld [hli], a
	ld a, e
	ld [hl], a
	
	pop hl
	ld a, [wd265]
	cp c
	jr z, .doNothing
	jr nc, .discourage
	;encourage
	dec [hl]
	dec [hl]
.doNothing
	ret
	
.discourage
	inc [hl]
	inc [hl]
	ret
	
AI_Metallurgy:
	;Dismiss if you're already fully steel type
	ld a, [EnemyMonType1]
	cp STEEL
	jr nz, .ok
	
	ld a, [EnemyMonType2]
	cp STEEL
	jp z, AIDiscourageMove
	
.ok
	;Encourage if this change will improve the defenses from the player's last attack
	ld a, [LastPlayerMove]
	and a
	jr z, .doNothing

	push hl ;;;;;;;;;;;;;;;;
	
	dec a
	ld hl, Moves + MOVE_TYPE
	ld bc, MOVE_LENGTH
	rst AddNTimes

	ld a, BANK(Moves)
	call GetFarByte
	and $3f
	ld [wPlayerMoveStruct + MOVE_TYPE], a

	xor a
	ld [hBattleTurn], a
	predef BattleCheckTypeMatchup 
	ld a, [wd265]
	
	ld c, a ;Current Matchup value
	ld hl, EnemyMonType1
	ld a, [hli]
	ld d, a
	ld a, [hl]
	ld e, a

	push bc
	push de
	dec hl
	ld a, STEEL
	ld [hli], a
	ld [hl], a
	predef BattleCheckTypeMatchup 
	pop de
	pop bc
	
	ld hl, EnemyMonType1
	ld a, d
	ld [hli], a
	ld a, e
	ld [hl], a
	
	pop hl
	
	ld a, [wd265]
	cp c
	jr z, .doNothing
	jr nc, .discourage
	;encourage
	dec [hl]
	dec [hl]
	ret

.doNothing
	ret
	
.discourage
	inc [hl]
	inc [hl]
	ret
	
AI_Final_Chance:
	;Dismiss if already under the effects of perish song
	ld a, [wPlayerSubStatus1]
	bit SUBSTATUS_PERISH, a
	jp nz, AIDiscourageMove

	;Greatly discourage if above 25% health. Else, greatly encourage
	call AICheckEnemyQuarterHP
	jr c, .discourage
	dec [hl]
	dec [hl]
	dec [hl]
	ret
	
.discourage
	inc [hl]
	inc [hl]
	inc [hl]
	ret

AI_Smart_Sleep:
	;Greatly discourage if an ability prevents it
	ld a, [PlayerAbility]
	cp ABILITY_VITAL_SPIRIT
	jr z, .discourage
	cp ABILITY_INSOMNIA
	jr z, .discourage

; Greatly encourage sleep inducing moves if the enemy has either Dream Eater or Nightmare.
; 50% chance to greatly encourage sleep inducing moves otherwise.
	ld a, [wEnemyMoveStructAnimation]
	cp SLEEP_POWDER
	jr nz, .skip_powder_check
	ld b, GRASS
	call AI_CheckPlayerTypeMatchesB
	jr z, .discourage
.skip_powder_check
	ld b, EFFECT_DREAM_EATER
	call AIHasMoveEffect
	jr c, .asm_387f0

	ld b, EFFECT_NIGHTMARE
	call AIHasMoveEffect
	ret nc

.asm_387f0
	call AI_50_50
	ret c
	dec [hl]
	dec [hl]
	ret

.discourage
	inc [hl]
	ret

AI_Smart_LeechHit:
	push hl
	ld a, 1
	ld [hBattleTurn], a
	predef BattleCheckTypeMatchup
	pop hl

; 60% chance to discourage this move if not very effective.
	ld a, [wd265]
	cp 10 ; 1.0
	jr c, .asm_38815

; Do nothing if effectiveness is neutral.
	ret z

; Discourage the move if the player has Liquid Ooze.
	ld a, [PlayerAbility]
	cp ABILITY_LIQUID_OOZE
	ret z

; Do nothing if enemy's HP is full.
	call AICheckEnemyMaxHP
	ret c

; 80% chance to encourage this move otherwise.
	call AI_80_20
	ret c

	dec [hl]
	ret

.asm_38815
	call Random
	cp 100
	ret c

	inc [hl]
	ret

AI_Smart_LockOn:
	ld a, [wPlayerSubStatus5]
	bit SUBSTATUS_LOCK_ON, a
	jr nz, .asm_38882

	push hl
	call AICheckEnemyQuarterHP
	jr nc, .asm_38877

	call AICheckEnemyHalfHP
	jr c, .asm_38834

	call AICompareSpeed
	jr nc, .asm_38877

.asm_38834
	ld a, [PlayerEvaLevel]
	cp $a
	jr nc, .asm_3887a
	cp $8
	jr nc, .asm_38875

	ld a, [EnemyAccLevel]
	cp $5
	jr c, .asm_3887a
	cp $7
	jr c, .asm_38875

	ld hl, EnemyMonMoves
	ld c, EnemyMonMovesEnd - EnemyMonMoves + 1
.asm_3884f
	dec c
	jr z, .asm_38877

	ld a, [hli]
	and a
	jr z, .asm_38877

	call AIGetEnemyMove

	ld a, [wEnemyMoveStruct + MOVE_ACC]
	cp 180
	jr nc, .asm_3884f

	ld a, $1
	ld [hBattleTurn], a

	push hl
	push bc
	predef BattleCheckTypeMatchup
	ld a, [wd265]
	cp $a
	pop bc
	pop hl
	jr c, .asm_3884f

.asm_38875
	pop hl
	ret

.asm_38877
	pop hl
	inc [hl]
	ret

.asm_3887a
	pop hl
	call AI_50_50
	ret c

	dec [hl]
	dec [hl]
	ret

.asm_38882
	push hl
	ld hl, wAIMoveScores - 1
	ld de, EnemyMonMoves
	ld c, EnemyMonMovesEnd - EnemyMonMoves + 1

.asm_3888b
	inc hl
	dec c
	jr z, .asm_388a2

	ld a, [de]
	and a
	jr z, .asm_388a2

	inc de
	call AIGetEnemyMove

	ld a, [wEnemyMoveStruct + MOVE_ACC]
	cp 180
	jr nc, .asm_3888b

	dec [hl]
	dec [hl]
	jr .asm_3888b

.asm_388a2
	pop hl
	jp AIDiscourageMove

AI_Smart_Explosion:
; Selfdestruct, Explosion

; Greatly discourage if foe is under the effects of final chance
	ld a, [wPlayerSubStatus1]
	bit SUBSTATUS_FINAL_CHANCE, a
	jr z, .score_down_3

; Unless this is the enemy's last Pokemon...
	push hl
	callba FindAliveEnemyMons
	pop hl
	jr nc, .asm_388b7

; ...greatly discourage this move unless this is the player's last Pokemon too.
	push hl
	call AICheckLastPlayerMon
	pop hl
	jr nz, .score_down_3

.asm_388b7
; Greatly discourage this move if enemy's HP is above 50%.
	call AICheckEnemyHalfHP
	jr c, .score_down_3

; Do nothing if enemy's HP is below 25%.
	call AICheckEnemyQuarterHP
	ret nc

; If enemy's HP is between 25% and 50%,
; over 90% chance to greatly discourage this move.
	call Random
	cp 20
	ret c

.score_down_3
	inc [hl]
	inc [hl]
	inc [hl]
	ret

AI_Smart_DreamEater:
; The AI_Basic layer will make sure that
; Dream Eater is only used against sleeping targets.

; Discourage if player has Liquid Ooze
	ld a, [PlayerAbility]
	cp ABILITY_LIQUID_OOZE
	jr z, .discourage
; 90% chance to greatly encourage this move.
	call Random
	cp 25
	ret c
	dec [hl]
	dec [hl]
	dec [hl]
	ret

.discourage
	inc [hl]
	ret

AI_Smart_EvasionUp:

; Dismiss this move if enemy's evasion can't raise anymore.
	ld a, [EnemyEvaLevel]
	cp $d
	jp nc, AIDiscourageMove

; If enemy's HP is full...
	call AICheckEnemyMaxHP
	jr nc, .asm_388f2

; ...greatly encourage this move if player is badly poisoned.
	ld a, [BattleMonSemistatus]
	bit SEMISTATUS_TOXIC, a
	jr nz, .asm_388ef

; ...70% chance to greatly encourage this move if player is not badly poisoned.
	call Random
	cp $b2
	jr nc, .asm_38911

.asm_388ef
	dec [hl]
	dec [hl]
	ret

.asm_388f2

; Greatly discourage this move if enemy's HP is below 25%.
	call AICheckEnemyQuarterHP
	jr nc, .asm_3890f

; If enemy's HP is above 25% but not full, 4% chance to greatly encourage this move.
	call Random
	cp $a
	jr c, .asm_388ef

; If enemy's HP is between 25% and 50%,...
	call AICheckEnemyHalfHP
	jr nc, .asm_3890a

; If enemy's HP is above 50% but not full, 20% chance to greatly encourage this move.
	call AI_80_20
	jr c, .asm_388ef
	jr .asm_38911

.asm_3890a
; ...50% chance to greatly discourage this move.
	call AI_50_50
	jr c, .asm_38911

.asm_3890f
	inc [hl]
	inc [hl]

; 30% chance to end up here if enemy's HP is full and player is not badly poisoned.
; 77% chance to end up here if enemy's HP is above 50% but not full.
; 96% chance to end up here if enemy's HP is between 25% and 50%.
; 100% chance to end up here if enemy's HP is below 25%.
; In other words, we only end up here if the move has not been encouraged or dismissed.
.asm_38911
	ld a, [BattleMonSemistatus]
	bit SEMISTATUS_TOXIC, a
	jr nz, .asm_38938

	ld a, [wPlayerSubStatus4]
	bit SUBSTATUS_LEECH_SEED, a
	jr nz, .asm_38941

; Discourage this move if enemy's evasion level is higher than player's accuracy level.
	ld a, [EnemyEvaLevel]
	ld b, a
	ld a, [PlayerAccLevel]
	cp b
	jr c, .asm_38936

; Greatly encourage this move if the player is in the middle of Fury Cutter or Rollout.
	ld a, [PlayerFuryCutterCount]
	and a
	jr nz, .asm_388ef

	ld a, [wPlayerSubStatus1]
	bit SUBSTATUS_ROLLOUT, a
	jr nz, .asm_388ef


.asm_38936
	inc [hl]
	ret

; Player is badly poisoned.
; 80% chance to greatly encourage this move.
; This would counter any previous discouragement.
.asm_38938
	call Random
	cp $50
	ret c
	dec [hl]
	dec [hl]
	ret

; Player is seeded.
; 50% chance to encourage this move.
; This would partly counter any previous discouragement.
.asm_38941
	call AI_50_50
	ret c

	dec [hl]
	ret

AI_Smart_AlwaysHit:
; 80% chance to greatly encourage this move if either...

; ...enemy's accuracy level has been lowered three or more stages
	ld a, [EnemyAccLevel]
	cp $5
	jr c, .asm_38954

; ...or player's evasion level has been raised three or more stages.
	ld a, [PlayerEvaLevel]
	cp $a
	ret c

.asm_38954
	call AI_80_20
	ret c

	dec [hl]
	dec [hl]
	ret

AI_Smart_MirrorMove:

; If the player did not use any move last turn...
	ld a, [LastEnemyCounterMove]
	and a
	jr nz, .asm_38968

; ...do nothing if enemy is slower than player
	call AICompareSpeed
	ret nc

; ...or dismiss this move if enemy is faster than player.
	jp AIDiscourageMove

; If the player did use a move last turn...
.asm_38968
	push hl
	ld hl, UsefulMoves
	call IsInSingularArray
	pop hl

; ...do nothing if he didn't use a useful move.
	ret nc

; If he did, 50% chance to encourage this move...
	call AI_50_50
	ret c

	dec [hl]

; ...and 90% chance to encourage this move again if the enemy is faster.
	call AICompareSpeed
	ret nc

	call Random
	cp $19
	ret c

	dec [hl]
	ret

AI_Smart_AccuracyDown:

; If player's HP is full...
	call AICheckPlayerMaxHP
	jr nc, .asm_389a0

; ...and enemy's HP is above 50%...
	call AICheckEnemyHalfHP
	jr nc, .asm_389a0

; ...greatly encourage this move if player is badly poisoned.
	ld a, [BattleMonSemistatus]
	bit SEMISTATUS_TOXIC, a
	jr nz, .asm_3899d

; ...70% chance to greatly encourage this move if player is not badly poisoned.
	call Random
	cp $b2
	jr nc, .asm_389bf

.asm_3899d
	dec [hl]
	dec [hl]
	ret

.asm_389a0

; Greatly discourage this move if player's HP is below 25%.
	call AICheckPlayerQuarterHP
	jr nc, .asm_389bd

; If player's HP is above 25% but not full, 4% chance to greatly encourage this move.
	call Random
	cp $a
	jr c, .asm_3899d

; If player's HP is between 25% and 50%,...
	call AICheckPlayerHalfHP
	jr nc, .asm_389b8

; If player's HP is above 50% but not full, 20% chance to greatly encourage this move.
	call AI_80_20
	jr c, .asm_3899d
	jr .asm_389bf

; ...50% chance to greatly discourage this move.
.asm_389b8
	call AI_50_50
	jr c, .asm_389bf

.asm_389bd
	inc [hl]
	inc [hl]

; We only end up here if the move has not been already encouraged.
.asm_389bf
	ld a, [BattleMonSemistatus]
	bit SEMISTATUS_TOXIC, a
	jr nz, .asm_389e6

	ld a, [wPlayerSubStatus4]
	bit SUBSTATUS_LEECH_SEED, a
	jr nz, .asm_389ef

; Discourage this move if enemy's evasion level is higher than player's accuracy level.
	ld a, [EnemyEvaLevel]
	ld b, a
	ld a, [PlayerAccLevel]
	cp b
	jr c, .asm_389e4

; Greatly encourage this move if the player is in the middle of Fury Cutter or Rollout.
	ld a, [PlayerFuryCutterCount]
	and a
	jr nz, .asm_3899d

	ld a, [wPlayerSubStatus1]
	bit SUBSTATUS_ROLLOUT, a
	jr nz, .asm_3899d

.asm_389e4
	inc [hl]
	ret

; Player is badly poisoned.
; 80% chance to greatly encourage this move.
; This would counter any previous discouragement.
.asm_389e6
	call Random
	cp $50
	ret c
	dec [hl]
	dec [hl]
	ret

; Player is seeded.
; 50% chance to encourage this move.
; This would partly counter any previous discouragement.
.asm_389ef
	call AI_50_50
	ret c

	dec [hl]
	ret

AI_Smart_Haze:

; 85% chance to encourage this move if any of enemy's stat levels is lower than -2.
	push hl
	ld hl, EnemyAtkLevel
	ld c, $8
.asm_389fb
	dec c
	jr z, .asm_38a05
	ld a, [hli]
	cp $5
	jr c, .asm_38a12
	jr .asm_389fb

; 85% chance to encourage this move if any of player's stat levels is higher than +2.
.asm_38a05
	ld hl, PlayerAtkLevel
	ld c, $8
.asm_38a0a
	dec c
	jr z, .asm_38a1b
	ld a, [hli]
	cp $a
	jr c, .asm_38a0a

.asm_38a12
	pop hl
	call Random
	cp $28
	ret c
	dec [hl]
	ret

; Discourage this move if neither:
; Any of enemy's stat levels is	lower than -2.
; Any of player's stat levels is higher than +2.
.asm_38a1b
	pop hl
	inc [hl]
	ret

AI_Smart_Whirlwind:
; Whirlwind, Roar.

; Discourage this move if the player has not shown
; a super-effective move against the enemy.
; Consider player's type(s) if its moves are unknown.

	push hl
	callba CheckPlayerMoveTypeMatchups
	ld a, [wEnemyAISwitchScore]
	cp 10 ; neutral
	pop hl
	ret c
	inc [hl]
	ret

AI_Smart_Heal:
AI_Smart_MorningSun:
AI_Smart_Synthesis:
AI_Smart_Moonlight:
; 90% chance to greatly encourage this move if enemy's HP is below 25%.
; Discourage this move if enemy's HP is higher than 50%.
; Do nothing otherwise.

	call AICheckEnemyQuarterHP
	jr nc, .asm_38a45
	call AICheckEnemyHalfHP
	ret nc
	inc [hl]
	ret

.asm_38a45
	call Random
	cp $19
	ret c
	dec [hl]
	dec [hl]
	ret
; 38a4e

AI_CheckPlayerTypeMatchesB:
	ld a, [BattleMonType1]
	cp b
	ret z
	ld a, [BattleMonType2]
	cp b
	ret

AI_Smart_LeechSeed:
; Discourage this move if player has Liquid Ooze

	ld a, [PlayerAbility]
	cp ABILITY_LIQUID_OOZE
	jr z, AI_Smart_Toxic_LeechSeed_Discourage
AI_Smart_Toxic:
; Discourage this move if player's HP is below 50%.

	call AICheckPlayerHalfHP
	ret c
AI_Smart_Toxic_LeechSeed_Discourage:
	inc [hl]
	ret

AI_Smart_LightScreen:
AI_Smart_Reflect:
; Over 90% chance to discourage this move unless enemy's HP is full.

	call AICheckEnemyMaxHP
	ret c
	call Random
	cp $14
	ret c
	inc [hl]
	ret

AI_Smart_Bind:
; Bind, Wrap, Fire Spin, Clamp

; 50% chance to discourage this move if the player is already trapped.
	ld a, [wPlayerWrapCount]
	and a
	jr nz, .asm_38a8b

; 50% chance to greatly encourage this move if player is either
; badly poisoned, in love, identified, stuck in Rollout, or has a Nightmare.
	ld a, [BattleMonSemistatus]
	bit SEMISTATUS_TOXIC, a
	jr nz, .asm_38a91

	ld a, [wPlayerSubStatus1]
	and 1<<SUBSTATUS_IN_LOVE | 1<<SUBSTATUS_ROLLOUT | 1<<SUBSTATUS_IDENTIFIED | 1<<SUBSTATUS_NIGHTMARE
	jr nz, .asm_38a91

; Else, 50% chance to greatly encourage this move if it's the player's Pokemon first turn.
	ld a, [PlayerTurnsTaken]
	and a
	jr z, .asm_38a91

; 50% chance to discourage this move otherwise.
.asm_38a8b
	call AI_50_50
	ret c
	inc [hl]
	ret

.asm_38a91
	call AICheckEnemyQuarterHP
	ret nc
	call AI_50_50
	ret c
	dec [hl]
	dec [hl]
	ret

AI_Smart_RazorWind:
AI_Smart_DustDevil:
	ld a, [wEnemySubStatus1]
	bit SUBSTATUS_PERISH, a
	jr z, .asm_38aaa

	ld a, [EnemyPerishCount]
	cp 3
	jr c, .asm_38ad3

.asm_38aaa
	push hl
	ld hl, PlayerUsedMoves
	ld c, 4

.asm_38ab0
	ld a, [hli]
	and a
	jr z, .asm_38ac1

	call AIGetEnemyMove

	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	cp EFFECT_PROTECT
	jr z, .asm_38ad5
	dec c
	jr nz, .asm_38ab0

.asm_38ac1
	pop hl
	ld a, [wEnemySubStatus3]
	bit SUBSTATUS_CONFUSED, a
	jr nz, .asm_38acd

	call AICheckEnemyHalfHP
	ret c

.asm_38acd
	call Random
	cp $c8
	ret c

.asm_38ad3
	inc [hl]
	ret

.asm_38ad5
	pop hl
	ld a, [hl]
	add 6
	ld [hl], a
	ret

AI_Smart_Confuse:

; 90% chance to discourage this move if player's HP is between 25% and 50%.
	call AICheckPlayerHalfHP
	ret c
	call Random
	cp $19
	jr c, .asm_38ae7
	inc [hl]

.asm_38ae7
; Discourage again if player's HP is below 25%.
	call AICheckPlayerQuarterHP
	ret c
	inc [hl]
	ret

AI_Smart_SpDefenseUp2:

; Discourage this move if enemy's HP is lower than 50%.
	call AICheckEnemyHalfHP
	jr nc, .asm_38b10

; Discourage this move if enemy's special defense level is higher than +3.
	ld a, [EnemySDefLevel]
	cp $b
	jr nc, .asm_38b10

; 80% chance to greatly encourage this move if
; enemy's Special Defense level is lower than +2, and the player has a special move
	cp $9
	ret nc

	push hl
	ld hl, BattleMonMoves
	ld c, 0
	ld b, NUM_MOVES
.loop
	ld a, [hli]
	and a
	jr z, .done
	push hl
	push bc
	ld hl, Moves + MOVE_TYPE
	ld bc, MOVE_LENGTH
	dec a
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	pop bc
	pop hl
	bit 6, a
	jr z, .next
	inc c
.next
	dec b
	jr nz, .loop
.done
	pop hl
	ld a, c
	and a
	ret z
	call AI_80_20
	ret c
	dec [hl]
	dec [hl]
	ret

.asm_38b10
	inc [hl]
	ret

AI_Smart_Fly:
; Fly, Dig

; Greatly encourage this move if the player is
; flying or underground, and slower than the enemy.

	ld a, [wPlayerSubStatus3]
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	ret z

	call AICompareSpeed
	ret nc

	dec [hl]
	dec [hl]
	dec [hl]
	ret

AI_Smart_SuperFang:
; Discourage this move if player's HP is below 25%.

	call AICheckPlayerQuarterHP
	ret c
	inc [hl]
	ret

AI_Smart_Paralyze:
	ld a, [wEnemyMoveStructAnimation]
	cp STUN_SPORE
	jr nz, .skip_powder_check
	ld b, GRASS
	call AI_CheckPlayerTypeMatchesB
	jr z, .discourage
.skip_powder_check

; 50% chance to discourage this move if player's HP is below 25%.
	call AICheckPlayerQuarterHP
	jr nc, .asm_38b3a

; 80% chance to greatly encourage this move
; if enemy is slower than player and its HP is above 25%.
	call AICompareSpeed
	ret c
	call AICheckEnemyQuarterHP
	ret nc
	call AI_80_20
	ret c
	dec [hl]
	dec [hl]
	ret

.asm_38b3a
	call AI_50_50
	ret c
.discourage
	inc [hl]
	ret

AI_Smart_SpeedDownHit:
; Icy Wind

; Almost 90% chance to greatly encourage this move if the following conditions all meet:
; Enemy's HP is higher than 25%.
; It's the first turn of player's Pokemon.
; Player is faster than enemy.

	ld a, [wEnemyMoveStruct + MOVE_ANIM]
	cp ICY_WIND
	ret nz
	call AICheckEnemyQuarterHP
	ret nc
	ld a, [PlayerTurnsTaken]
	and a
	ret nz
	call AICompareSpeed
	ret c
	call Random
	cp 30
	ret c
	dec [hl]
	dec [hl]
	ret

AI_Smart_Substitute:
; Dismiss this move if enemy's HP is below 50%.

	call AICheckEnemyHalfHP
	ret c
	jp AIDiscourageMove

AI_Smart_HyperBeam:
	call AICheckEnemyHalfHP
	jr c, .asm_38b72

; 50% chance to encourage this move if enemy's HP is below 25%.
	call AICheckEnemyQuarterHP
	ret c
	call AI_50_50
	ret c
	dec [hl]
	ret

.asm_38b72
; If enemy's HP is above 50%, discourage this move at random
	call Random
	cp 40
	ret c
	inc [hl]
	call AI_50_50
	ret c
	inc [hl]
	ret

AI_Smart_Counter:
	push hl
	ld hl, PlayerUsedMoves
	lb bc, 0, 4

.asm_38bf9
	ld a, [hli]
	and a
	jr z, .asm_38c0e

	call AIGetEnemyMove

	ld a, [wEnemyMoveStruct + MOVE_POWER]
	and a
	jr z, .asm_38c0e

	ld a, [wEnemyMoveStruct + MOVE_TYPE]
	bit 6, a
	jr nz, .asm_38c0e

	inc b

.asm_38c0e
	dec c
	jr nz, .asm_38bf9

	pop hl
	ld a, b
	and a
	jr z, .asm_38c39

	cp $3
	jr nc, .asm_38c30

	ld a, [LastEnemyCounterMove]
	and a
	ret z

	call AIGetEnemyMove

	ld a, [wEnemyMoveStruct + MOVE_POWER]
	and a
	ret z

	ld a, [wEnemyMoveStruct + MOVE_TYPE]
	bit 6, a
	ret nz

.asm_38c30
	call Random
	cp $64
	ret c

	dec [hl]
	ret

.asm_38c39
	inc [hl]
	ret

AI_Smart_Encore:
	call AICompareSpeed
	jr nc, .asm_38c81

	ld a, [LastPlayerMove]
	and a
	jp z, AIDiscourageMove

	call AIGetEnemyMove

	ld a, [wEnemyMoveStruct + MOVE_POWER]
	and a
	jr z, .asm_38c68

	push hl
	ld a, 1
	ld [hBattleTurn], a
	predef BattleCheckTypeMatchup

	pop hl
	ld a, [wd265]
	cp $a
	jr nc, .asm_38c68

	and a
	ret nz
	jr .asm_38c78

.asm_38c68
	push hl
	ld a, [LastEnemyCounterMove]
	ld hl, .EncoreMoves
	call IsInSingularArray
	pop hl
	jr nc, .asm_38c81

.asm_38c78
	call Random
	cp $46
	ret c
	dec [hl]
	dec [hl]
	ret

.asm_38c81
	inc [hl]
	inc [hl]
	inc [hl]
	ret

.EncoreMoves:
	db SWORDS_DANCE
	db WHIRLWIND
	db LEER
	db ROAR
	db DISABLE
	db MIST
	db LEECH_SEED
	db GROWTH
	db POISONPOWDER
	db STRING_SHOT
	db AGILITY
	db TELEPORT
	db SCREECH
	db HAZE
	db FOCUS_ENERGY
	db DREAM_EATER
	db POISON_GAS
	db SPLASH
	db CONVERSION
	db SUBSTITUTE
	db MIND_READER
	db FLAME_WHEEL
	db AEROBLAST
	db COTTON_SPORE
	db POWDER_SNOW
	db ASTONISH
	db LAVA_POOL
	db FINAL_CHANCE
	db LIGHT_SCREEN
	db METALLURGY
	db PROTECT
	db SWAGGER
	db WILL_O_WISP
	db FUTURE_SIGHT
	db HEAL_BELL
	db PERISH_SONG
	db BELLY_DRUM
	db METRONOME
	db $ff

AI_Smart_PainSplit:
; Discourage this move if [enemy's current HP * 2 > player's current HP].

	push hl
	ld hl, EnemyMonHP
	ld b, [hl]
	inc hl
	ld c, [hl]
	sla c
	rl b
	ld hl, BattleMonHP + 1
	ld a, [hld]
	cp c
	ld a, [hl]
	sbc b
	pop hl
	ret nc
	inc [hl]
	ret

AI_Smart_SleepTalk:
; Greatly encourage this move if enemy is fast asleep.
; Greatly discourage this move otherwise.

	ld a, [EnemyMonStatus]
	and $7
	cp $1
	jr z, .asm_38cc7

	dec [hl]
	dec [hl]
	dec [hl]
	ret

.asm_38cc7
	inc [hl]
	inc [hl]
	inc [hl]
	ret

AI_Smart_DefrostOpponent:
; Greatly encourage this move if enemy is frozen.
; No move has EFFECT_DEFROST_OPPONENT, so this layer is unused.

	ld a, [EnemyMonStatus]
	and $20
	ret z
	dec [hl]
	dec [hl]
	dec [hl]
	ret

AI_Smart_Spite:
	ld a, [LastEnemyCounterMove]
	and a
	jr nz, .asm_38ce7

	call AICompareSpeed
	jp c, AIDiscourageMove

	call AI_50_50
	ret c
	inc [hl]
	ret

.asm_38ce7
	push hl
	ld b, a
	ld c, 4
	ld hl, BattleMonMoves
	ld de, BattleMonPP

.asm_38cf1
	ld a, [hli]
	cp b
	jr z, .asm_38cfb

	inc de
	dec c
	jr nz, .asm_38cf1

	pop hl
	ret

.asm_38cfb
	pop hl
	ld a, [de]
	cp $6
	jr c, .asm_38d0d
	cp $f
	jr nc, .asm_38d0b

	call Random
	cp $64
	ret nc

.asm_38d0b
	inc [hl]
	ret

.asm_38d0d
	call Random
	cp $64
	ret c
	dec [hl]
	dec [hl]
	ret

AI_Smart_DestinyBond:
AI_Smart_Reversal:
; Discourage this move if enemy's HP is above 25%.

	call AICheckEnemyQuarterHP
	ret nc
	inc [hl]
	ret

AI_Smart_HealBell:
; Dismiss this move if none of the opponent's Pokemon is statused.
; Encourage this move if the enemy is statused.
; 50% chance to greatly encourage this move if the enemy is neither fast asleep nor frozen.

	push hl
	ld a, [OTPartyCount]
	ld b, a
	ld c, 0
	ld hl, OTPartyMon1HP
	ld de, PARTYMON_STRUCT_LENGTH

.loop
	push hl
	ld a, [hli]
	or [hl]
	jr z, .next

	; status
	dec hl
	dec hl
	dec hl
	ld a, [hl]
	or c
	ld c, a

.next
	pop hl
	add hl, de
	dec b
	jr nz, .loop

	pop hl
	ld a, c
	and a
	jr z, .no_status

	ld a, [EnemyMonStatus]
	and a
	ret z
	dec [hl]
	and (1 << FRZ) | SLP
	ret nz
	call AI_50_50
	ret c
	dec [hl]
	dec [hl]
	ret

.no_status
	ld a, [EnemyMonStatus]
	and a
	ret nz
	jp AIDiscourageMove

AI_Smart_PriorityHit:
	call AICompareSpeed
	ret c

; Dismiss this move if the player is flying or underground.
	ld a, [wPlayerSubStatus3]
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	jp nz, AIDiscourageMove

; Greatly encourage this move if it will KO the player.
	ld a, $1
	ld [hBattleTurn], a
	push hl
	callba EnemyAttackDamage
	callba BattleCommand_DamageCalc
	callba BattleCommand_TypeMatchup
	pop hl
	call GetCurrentDamage
	ld a, [wCurDamage + 1]
	ld c, a 
	ld a, [wCurDamage]
	ld b, a
	ld a, [BattleMonHP + 1]
	cp c
	ld a, [BattleMonHP]
	sbc b
	ret nc
	dec [hl]
	dec [hl]
	dec [hl]
	ret

AI_Smart_Thief:
; Don't use Thief unless it's the only move available.

	ld a, [hl]
	add $1e
	ld [hl], a
	ret

AI_Smart_Conversion2:
	ld a, [LastPlayerMove]
	and a
	jr nz, .asm_38dc9

	push hl
	dec a
	ld hl, Moves + MOVE_TYPE
	ld bc, MOVE_LENGTH
	rst AddNTimes

	ld a, BANK(Moves)
	call GetFarByte
	ld [wPlayerMoveStruct + MOVE_TYPE], a

	xor a
	ld [hBattleTurn], a

	predef BattleCheckTypeMatchup

	ld a, [wd265]
	cp $a
	pop hl
	jr c, .asm_38dc9
	ret z

	call AI_50_50
	ret c

	dec [hl]
	ret

.asm_38dc9
	call Random
	cp 25
	ret c
	inc [hl]
	ret

AI_Smart_Disable:
	call AICompareSpeed
	jr nc, .asm_38df3

	push hl
	ld a, [LastEnemyCounterMove]
	ld hl, UsefulMoves
	call IsInSingularArray

	pop hl
	jr nc, .asm_38dee

	call Random
	cp 100
	ret c
	dec [hl]
	ret

.asm_38dee
	ld a, [wEnemyMoveStruct + MOVE_POWER]
	and a
	ret nz

.asm_38df3
	call Random
	cp 20
	ret c
	inc [hl]
	ret

AI_Smart_MeanLook:
	call AICheckEnemyHalfHP
	jr nc, .asm_38e24

	push hl
	call AICheckLastPlayerMon
	pop hl
	jp z, AIDiscourageMove

; 80% chance to greatly encourage this move if the enemy is badly poisoned (weird).
	ld a, [EnemyMonSemistatus]
	bit SEMISTATUS_TOXIC, a
	jr nz, .asm_38e26

; 80% chance to greatly encourage this move if the player is either
; in love, identified, stuck in Rollout, or has a Nightmare.
	ld a, [wPlayerSubStatus1]
	and 1<<SUBSTATUS_IN_LOVE | 1<<SUBSTATUS_ROLLOUT | 1<<SUBSTATUS_IDENTIFIED | 1<<SUBSTATUS_NIGHTMARE
	jr nz, .asm_38e26

; Otherwise, discourage this move unless the player only has not very effective moves against the enemy.
	push hl
	callba CheckPlayerMoveTypeMatchups
	ld a, [wEnemyAISwitchScore]
	cp $b ; not very effective
	pop hl
	ret nc

.asm_38e24
	inc [hl]
	ret

.asm_38e26
	call AI_80_20
	ret c
	dec [hl]
	dec [hl]
	dec [hl]
	ret

AICheckLastPlayerMon:
	ld a, [wPartyCount]
	ld b, a
	ld c, 0
	ld hl, PartyMon1HP
	ld de, PARTYMON_STRUCT_LENGTH

.loop
	ld a, [CurBattleMon]
	cp c
	jr z, .asm_38e44

	ld a, [hli]
	or [hl]
	ret nz
	dec hl

.asm_38e44
	add hl, de
	inc c
	dec b
	jr nz, .loop

	ret

AI_Smart_Nightmare:
; 50% chance to encourage this move.
; The AI_Basic layer will make sure that
; Dream Eater is only used against sleeping targets.

	call AI_50_50
	ret c
	dec [hl]
	ret

AI_Smart_FlameWheel:
; Use this move if the enemy is frozen.

	ld a, [EnemyMonStatus]
	bit FRZ, a
	ret z
rept 5
	dec [hl]
endr
	ret

AI_Smart_Curse:
	ld a, [EnemyMonType1]
	cp GHOST
	jr z, .ghostcurse
	ld a, [EnemyMonType2]
	cp GHOST
	jr z, .ghostcurse

	call AICheckEnemyHalfHP
	jr nc, .asm_38e93

	ld a, [EnemyAtkLevel]
	cp $b
	jr nc, .asm_38e93
	cp $9
	ret nc

	ld a, [BattleMonType1]
	cp GHOST
	jr z, .asm_38e92
	bit 6, a
	ret nz
	ld a, [BattleMonType2]
	bit 6, a
	ret nz
	call AI_80_20
	ret c
	dec [hl]
	dec [hl]
	ret

.asm_38e90
	inc [hl]
	inc [hl]
.asm_38e92
	inc [hl]
.asm_38e93
	inc [hl]
	ret

.ghostcurse
	ld a, [wPlayerSubStatus1]
	bit SUBSTATUS_CURSE, a
	jp nz, AIDiscourageMove

	push hl
	callba FindAliveEnemyMons
	pop hl
	jr nc, .asm_38eb0

	push hl
	call AICheckLastPlayerMon
	pop hl
	jr nz, .asm_38e90

	jr .asm_38eb7


.asm_38eb0
	push hl
	call AICheckLastPlayerMon
	pop hl
	jr z, .asm_38ecb


.asm_38eb7
	call AICheckEnemyQuarterHP
	jp nc, .asm_38e90

	call AICheckEnemyHalfHP
	jr nc, .asm_38e92

	call AICheckEnemyMaxHP
	ret nc

	ld a, [PlayerTurnsTaken]
	and a
	ret nz

.asm_38ecb
	call AI_50_50
	ret c

	dec [hl]
	dec [hl]
	ret

AI_Smart_Protect:
	ld a, [EnemyProtectCount]
	and a
	jr nz, .asm_38f13

	ld a, [wPlayerSubStatus5]
	bit SUBSTATUS_LOCK_ON, a
	jr nz, .asm_38f14

	ld a, [PlayerFuryCutterCount]
	cp 3
	jr nc, .asm_38f0d

	ld a, [wPlayerSubStatus3]
	bit SUBSTATUS_CHARGED, a
	jr nz, .asm_38f0d

	ld a, [BattleMonSemistatus]
	bit SEMISTATUS_TOXIC, a
	jr nz, .asm_38f0d
	ld a, [wPlayerSubStatus4]
	bit SUBSTATUS_LEECH_SEED, a
	jr nz, .asm_38f0d
	ld a, [wPlayerSubStatus1]
	bit SUBSTATUS_CURSE, a
	jr nz, .asm_38f0d

	bit SUBSTATUS_ROLLOUT, a
	jr z, .asm_38f14

	ld a, [PlayerRolloutCount]
	cp 3
	jr c, .asm_38f14

.asm_38f0d
	call AI_80_20
	ret c
	dec [hl]
	ret

.asm_38f13
	inc [hl]

.asm_38f14
	call Random
	cp 20
	ret c
	inc [hl]
	inc [hl]
	ret

AI_Smart_Foresight:
	ld a, [EnemyAccLevel]
	cp $5
	jr c, .asm_38f41
	ld a, [PlayerEvaLevel]
	cp $a
	jr nc, .asm_38f41

	ld a, [BattleMonType1]
	cp GHOST
	jr z, .asm_38f41
	ld a, [BattleMonType2]
	cp GHOST
	jr z, .asm_38f41

	call Random
	cp 20
	ret c
	inc [hl]
	ret

.asm_38f41
	call Random
	cp 100
	ret c
	dec [hl]
	dec [hl]
	ret

AI_Smart_PerishSong:
	push hl
	callba FindAliveEnemyMons
	pop hl
	jr c, .no

	ld a, [wPlayerSubStatus5]
	bit SUBSTATUS_CANT_RUN, a
	jr nz, .yes

	push hl
	callba CheckPlayerMoveTypeMatchups
	ld a, [wEnemyAISwitchScore]
	cp 10 ; 1.0
	pop hl
	ret c

	call AI_50_50
	ret c

	inc [hl]
	ret

.yes
	call AI_50_50
	ret c

	dec [hl]
	ret

.no
	ld a, [hl]
	add 5
	ld [hl], a
	ret

AI_Smart_Sandstorm:

; Greatly discourage this move if the player is immune to Sandstorm damage.
	ld a, [BattleMonType1]
	push hl
	ld hl, .SandstormImmuneTypes
	call IsInSingularArray
	pop hl
	jr c, .asm_38fa5

	ld a, [BattleMonType2]
	push hl
	ld hl, .SandstormImmuneTypes
	call IsInSingularArray
	pop hl
	jr c, .asm_38fa5
	
;Discourage if the player has an ability that prevents damage
	ld a, [PlayerAbility]
	cp ABILITY_SAND_VEIL
	jr z, .asm_38fa6

; Discourage this move if player's HP is below 50%.
	call AICheckPlayerHalfHP
	jr nc, .asm_38fa6

; 50% chance to encourage this move otherwise.
	call AI_50_50
	ret c

	dec [hl]
	ret

.asm_38fa5
	inc [hl]

.asm_38fa6
	inc [hl]
	ret
	
.SandstormImmuneTypes
	db ROCK
	db GROUND
	db STEEL
	db $ff

AI_Smart_Hail:
; Greatly discourage this move if the player is ice
	ld a, [BattleMonType1]
	cp ICE
	jr z, .reallyDiscourage

	ld a, [BattleMonType2]
	cp ICE
	jr z, .discourage
	
;Discourage if the player has an ability that prevents damage
	ld a, [PlayerAbility]
	push hl
	ld hl, .hailBlockingAbilities
	call IsInSingularArray
	pop hl
	jr c, .discourage

; Discourage this move if player's HP is below 50%.
	call AICheckPlayerHalfHP
	jr nc, .discourage

; 50% chance to encourage this move otherwise.
	call AI_50_50
	ret c

	dec [hl]
	ret

.reallyDiscourage
	inc [hl]

.discourage
	inc [hl]
	ret
	
.hailBlockingAbilities
	db ABILITY_SNOW_CLOAK
	db ABILITY_ICE_BODY
	db $ff
	
AI_Smart_Endure:
	ld a, [EnemyProtectCount]
	and a
	jr nz, .asm_38fd8

	call AICheckEnemyMaxHP
	jr c, .asm_38fd8

	call AICheckEnemyQuarterHP
	jr c, .asm_38fd9

	ld b, EFFECT_REVERSAL
	call AIHasMoveEffect
	jr nc, .asm_38fcb

	call AI_80_20
	ret c

	dec [hl]
	dec [hl]
	dec [hl]
	ret

.asm_38fcb
	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_LOCK_ON, a
	ret z

	call AI_50_50
	ret c

	dec [hl]
	dec [hl]
	ret

.asm_38fd8
	inc [hl]

.asm_38fd9
	inc [hl]
	ret

AI_Smart_FuryCutter:
; Encourage this move based on Fury Cutter's count.

	ld a, [EnemyFuryCutterCount]
	and a
	jr z, .end
	dec [hl]

	cp 2
	jr c, .end
	dec [hl]
	dec [hl]

	cp 3
	jr c, .end
	dec [hl]
	dec [hl]
	dec [hl]

.end
	; fallthrough

AI_Smart_Rollout:
; Rollout, Fury Cutter

; 80% chance to discourage this move if the enemy is in love, confused, or paralyzed.
	ld a, [wEnemySubStatus1]
	bit SUBSTATUS_IN_LOVE, a
	jr nz, .asm_39020

	ld a, [wEnemySubStatus3]
	bit SUBSTATUS_CONFUSED, a
	jr nz, .asm_39020

	ld a, [EnemyMonStatus]
	bit PAR, a
	jr nz, .asm_39020

; 80% chance to discourage this move if the enemy's HP is below 25%,
; or if accuracy or evasion modifiers favour the player.
	call AICheckEnemyQuarterHP
	jr nc, .asm_39020

	ld a, [EnemyAccLevel]
	cp 7
	jr c, .asm_39020
	ld a, [PlayerEvaLevel]
	cp 8
	jr nc, .asm_39020

; Otherwise, 80% chance to greatly encourage this move.
	call Random
	cp 200
	ret nc
	dec [hl]
	dec [hl]
	ret

.asm_39020
	call AI_80_20
	ret c
	inc [hl]
	ret

AI_Smart_Swagger:
AI_Smart_Attract:
; 80% chance to encourage this move during the first turn of player's Pokemon.
; 80% chance to discourage this move otherwise.

	ld a, [PlayerTurnsTaken]
	and a
	jr z, .first_turn

	call AI_80_20
	ret c
	inc [hl]
	ret

.first_turn
	call Random
	cp 200
	ret nc
	dec [hl]
	ret

AI_Smart_Safeguard:
; 80% chance to discourage this move if player's HP is below 50%.

	call AICheckPlayerHalfHP
	ret c
	call AI_80_20
	ret c
	inc [hl]
	ret

AI_Smart_Magnitude:
AI_Smart_Earthquake:

; Greatly encourage this move if the player is underground and the enemy is faster.
	ld a, [LastEnemyCounterMove]
	cp DIG
	ret nz

	ld a, [wPlayerSubStatus3]
	bit SUBSTATUS_UNDERGROUND, a
	jr z, .could_dig

	call AICompareSpeed
	ret nc
	dec [hl]
	dec [hl]
	ret

.could_dig
	; Try to predict if the player will use Dig this turn.

	; 50% chance to encourage this move if the enemy is slower than the player.
	call AICompareSpeed
	ret c

	call AI_50_50
	ret c

	dec [hl]
	ret

AI_Smart_BatonPass:
; Discourage this move if the player hasn't shown super-effective moves against the enemy.
; Consider player's type(s) if its moves are unknown.

	push hl
	callba CheckPlayerMoveTypeMatchups
	ld a, [wEnemyAISwitchScore]
	cp 10 ; neutral
	pop hl
	ret c
	inc [hl]
	ret

AI_Smart_Pursuit:
; 50% chance to greatly encourage this move if player's HP is below 25%.
; 80% chance to discourage this move otherwise.

	call AICheckPlayerQuarterHP
	jr nc, .asm_3907d
	call AI_80_20
	ret c
	inc [hl]
	ret

.asm_3907d
	call AI_50_50
	ret c
	dec [hl]
	dec [hl]
	ret

AI_Smart_RapidSpin:
; 80% chance to greatly encourage this move if the enemy is
; trapped (Bind effect), seeded, or scattered with spikes.

	ld a, [wEnemyWrapCount]
	and a
	jr nz, .asm_39097

	ld a, [wEnemySubStatus4]
	bit SUBSTATUS_LEECH_SEED, a
	jr nz, .asm_39097

	ld a, [wEnemyScreens]
	bit SCREENS_SPIKES, a
	ret z

.asm_39097
	call AI_80_20
	ret c

	dec [hl]
	dec [hl]
	ret

AI_Smart_HiddenPower:
	push hl
	ld a, 1
	ld [hBattleTurn], a

; Calculate Hidden Power's type and base power based on enemy's DVs.
	callba HiddenPowerDamage
	predef BattleCheckTypeMatchup
	pop hl

; Discourage Hidden Power if not very effective.
	ld a, [wd265]
	cp 10
	jr c, .bad

; Discourage Hidden Power if its base power	is lower than 50.
	ld a, d
	cp 50
	jr c, .bad

; Encourage Hidden Power if super-effective.
	ld a, [wd265]
	cp 11
	jr nc, .good

; Encourage Hidden Power if its base power is 70.
	ld a, d
	cp 70
	ret c

.good
	dec [hl]
	ret

.bad
	inc [hl]
	ret

AI_Smart_RainDance:

; Greatly discourage this move if it would favour the player type-wise.
; Particularly, if the player is a Water-type.
	ld a, [BattleMonType1]
	cp WATER
	jr z, AIBadWeatherType
	cp FIRE
	jr z, AIGoodWeatherType

	ld a, [BattleMonType2]
	cp WATER
	jr z, AIBadWeatherType
	cp FIRE
	jr z, AIGoodWeatherType

	push hl
	ld hl, RainDanceMoves
	jr AI_Smart_WeatherMove

RainDanceMoves:
	db WATER_GUN
	db HYDRO_PUMP
	db SURF
	db BUBBLEBEAM
	db THUNDER
	db WATERFALL
	db BUBBLE
	db AQUA_JET
	db $ff

AI_Smart_SunnyDay:
	;It's a good idea if you have dry skin
	ld a, [EnemyAbility]
	cp ABILITY_DRY_SKIN
	jp z, AIGoodWeatherType

; Greatly discourage this move if it would favour the player type-wise.
; Particularly, if the player is a Fire-type.
	ld a, [BattleMonType1]
	cp FIRE
	jr z, AIBadWeatherType
	cp WATER
	jr z, AIGoodWeatherType

	ld a, [BattleMonType2]
	cp FIRE
	jr z, AIBadWeatherType
	cp WATER
	jr z, AIGoodWeatherType

	push hl
	ld hl, SunnyDayMoves

	; fallthrough

AI_Smart_WeatherMove:
; Rain Dance, Sunny Day

; Greatly discourage this move if the enemy doesn't have
; one of the useful Rain Dance or Sunny Day moves.
	call AIHasMoveInArray
	pop hl
	jr nc, AIBadWeatherType

; Greatly discourage this move if player's HP is below 50%.
	call AICheckPlayerHalfHP
	jr nc, AIBadWeatherType

; 50% chance to encourage this move otherwise.
	call AI_50_50
	ret c

	dec [hl]
	ret

AIBadWeatherType:
	inc [hl]
	inc [hl]
	inc [hl]
	ret

AIGoodWeatherType:
; Rain Dance, Sunny Day

; Greatly encourage this move if it would disfavour the player type-wise and player's HP is above 50%...
	call AICheckPlayerHalfHP
	ret nc

; ...as long as one of the following conditions meet:
; It's the first turn of the player's Pokemon.
	ld a, [PlayerTurnsTaken]
	and a
	jr z, .good

; Or it's the first turn of the enemy's Pokemon.
	ld a, [EnemyTurnsTaken]
	and a
	ret nz

.good
	dec [hl]
	dec [hl]
	ret

SunnyDayMoves:
	db FIRE_PUNCH
	db EMBER
	db FLAMETHROWER
	db FIRE_SPIN
	db FIRE_BLAST
	db SACRED_FIRE
	db MORNING_SUN
	db SYNTHESIS
	db FLARE_BLITZ
	db BOIL
	db $ff

AI_Smart_Twister:
AI_Smart_Gust:

; Greatly encourage this move if the player is flying and the enemy is faster.
	ld a, [LastEnemyCounterMove]
	cp FLY
	ret nz

	ld a, [wPlayerSubStatus3]
	bit SUBSTATUS_FLYING, a
	jr z, .couldFly

	call AICompareSpeed
	ret nc

	dec [hl]
	dec [hl]
	ret

; Try to predict if the player will use Fly this turn.
.couldFly

; 50% chance to encourage this move if the enemy is slower than the player.
	call AICompareSpeed
	ret c
	call AI_50_50
	ret c
	dec [hl]
	ret

AI_Smart_FutureSight:
; Greatly encourage this move if the player is
; flying or underground, and slower than the enemy.

	call AICompareSpeed
	ret nc

	ld a, [wPlayerSubStatus3]
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	ret z

	dec [hl]
	dec [hl]
	ret

AI_Smart_Stomp:
; 80% chance to encourage this move if the player has used Minimize.

	ld a, [wPlayerMinimized]
	and a
	ret z

	call AI_80_20
	ret c

	dec [hl]
	ret

AI_Smart_Solarbeam:
; 80% chance to encourage this move when it's sunny.
; 90% chance to discourage this move when it's raining.

	ld a, [Weather]
	cp WEATHER_SUN
	jr z, .asm_3921e

	cp WEATHER_RAIN
	ret nz

	call Random
	cp 25 ; 1/10
	ret c

	inc [hl]
	inc [hl]
	ret

.asm_3921e
	call AI_80_20
	ret c

	dec [hl]
	dec [hl]
	ret

AI_Smart_Thunder:
; 90% chance to discourage this move when it's sunny.

	ld a, [Weather]
	cp WEATHER_SUN
	ret nz

	call Random
	cp 25 ; 1/10
	ret c

	inc [hl]
	ret

AICompareSpeed:
; Return carry if enemy is faster than player.

	push bc
	ld a, [EnemyMonSpeed + 1]
	ld b, a
	ld a, [BattleMonSpeed + 1]
	cp b
	ld a, [EnemyMonSpeed]
	ld b, a
	ld a, [BattleMonSpeed]
	sbc b
	pop bc
	ret

AICheckPlayerMaxHP:
	push hl
	push de
	push bc
	ld de, BattleMonHP
	ld hl, BattleMonMaxHP
	jr AICheckMaxHP

AICheckEnemyMaxHP:
	push hl
	push de
	push bc
	ld de, EnemyMonHP
	ld hl, EnemyMonMaxHP
	; fallthrough

AICheckMaxHP:
; Return carry if hp at de matches max hp at hl.

	ld a, [de]
	inc de
	cp [hl]
	jr nz, .asm_39269

	inc hl
	ld a, [de]
	cp [hl]
	jr nz, .asm_39269

	pop bc
	pop de
	pop hl
	scf
	ret

.asm_39269
	pop bc
	pop de
	pop hl
	and a
	ret

AICheckPlayerHalfHP:
	push de
	push bc
	push hl
	ld hl, BattleMonHP
	jr AICheckHalfHP

AICheckEnemyHalfHP:
	push de
	push bc
	push hl
	ld hl, EnemyMonHP
	; fallthrough
	
AICheckHalfHP:
	ld b, [hl]
	inc hl
	ld c, [hl]
	sla c
	rl b
	jr AICheckHP

AICheckEnemyQuarterHP:
	push de
	push bc
	push hl
	ld hl, EnemyMonHP
	jr AICheckQuarterHP

AICheckPlayerQuarterHP:
	push de
	push bc
	push hl
	ld hl, BattleMonHP
	; fallthrough

AICheckQuarterHP:
	ld b, [hl]
	inc hl
	ld c, [hl]
	sla c
	rl b
	sla c
	rl b
	; fallthrough

AICheckHP:
	inc hl
	inc hl
	ld a, [hld]
	cp c
	ld a, [hl]
	sbc b
	pop hl
	pop bc
	pop de
	ret

AIHasMoveEffect:
; Return carry if the enemy has move b.

	push hl
	ld hl, EnemyMonMoves
	ld c, EnemyMonMovesEnd - EnemyMonMoves

.checkmove
	ld a, [hli]
	and a
	jr z, .no

	call AIGetEnemyMove

	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	cp b
	jr z, .yes

	dec c
	jr nz, .checkmove

.no
	pop hl
	and a
	ret

.yes
	pop hl
	scf
	ret

AIHasMoveInArray:
; Return carry if the enemy has a move in array hl.

	push hl
	push de
	push bc

.next
	ld a, [hli]
	cp $ff
	jr z, .done

	ld b, a
	ld c, EnemyMonMovesEnd - EnemyMonMoves + 1
	ld de, EnemyMonMoves

.check
	dec c
	jr z, .next

	ld a, [de]
	inc de
	cp b
	jr nz, .check

	scf

.done
	pop bc
	pop de
	pop hl
	ret

UsefulMoves:
; Moves that are usable all-around.
	db DOUBLE_EDGE
	db SING
	db FLAMETHROWER
	db HYDRO_PUMP
	db SURF
	db ICE_BEAM
	db BLIZZARD
	db HYPER_BEAM
	db SLEEP_POWDER
	db THUNDERBOLT
	db THUNDER
	db EARTHQUAKE
	db TOXIC
	db PSYCHIC_M
	db HYPNOSIS
	db RECOVER
	db FIRE_BLAST
	db SOFTBOILED
	db NOISE_PULSE
	db AIR_SLASH
	db $ff

AI_Opportunist:
; Discourage stall moves when the enemy's HP is low.

; Do nothing if enemy's HP is above 50%.
	call AICheckEnemyHalfHP
	ret c

; Discourage stall moves if enemy's HP is below 25%.
	call AICheckEnemyQuarterHP
	jr nc, .asm_39322

; 50% chance to discourage stall moves if enemy's HP is between 25% and 50%.
	call AI_50_50
	ret c

.asm_39322
	ld hl, wAIMoveScores
	ld de, EnemyMonMoves
	ld c, EnemyMonMovesEnd - EnemyMonMoves
.loop
	ld a, [de]
	inc de
	and a
	ret z
	push hl
	push de
	push bc
	ld hl, .stallmoves
	call IsInSingularArray

	pop bc
	pop de
	pop hl
	jr nc, .next
	inc [hl]
.next

	inc hl
	dec c
	jr nz, .loop
	ret

.stallmoves
	db SWORDS_DANCE
	db TAIL_WHIP
	db LEER
	db GROWL
	db DISABLE
	db MIST
	db COUNTER
	db LEECH_SEED
	db GROWTH
	db STRING_SHOT
	db AGILITY
	db RAGE
	db SCREECH
	db HARDEN
	db DEFENSE_CURL
	db BARRIER
	db LIGHT_SCREEN
	db HAZE
	db REFLECT
	db FOCUS_ENERGY
	db AMNESIA
	db TRANSFORM
	db SPLASH
	db ACID_ARMOR
	db CONVERSION
	db SUBSTITUTE
	db FLAME_WHEEL
	db BULK_UP
	db LAVA_POOL
	db DRAGON_DANCE
	db WILL_O_WISP
	db VAPORIZE
	db $ff

AI_Aggressive:
; Use whatever does the most damage.

; Discourage all damaging moves but the one that does the most damage.
; If no damaging move deals damage to the player (immune),
; no move will be discouraged

; Figure out which attack does the most damage and put it in c.
	ld hl, EnemyMonMoves
	ld bc, 0
	ld de, 0
.checkmove
	inc b
	ld a, b
	cp EnemyMonMovesEnd - EnemyMonMoves + 1
	jr z, .gotstrongestmove

	ld a, [hli]
	and a
	jr z, .gotstrongestmove

	push hl
	push de
	push bc
	call AIGetEnemyMove
	ld a, [wEnemyMoveStruct + MOVE_POWER]
	and a
	jr z, .nodamage
	call AIDamageCalc
	pop bc
	pop de
	pop hl

; Update current move if damage is highest so far
	call GetCurrentDamage
	ld a, [wCurDamage + 1]
	cp e
	ld a, [wCurDamage]
	sbc d
	jr c, .checkmove

	call GetCurrentDamage
	ld a, [wCurDamage + 1]
	ld e, a
	ld a, [wCurDamage]
	ld d, a
	ld c, b
	jr .checkmove

.nodamage
	pop bc
	pop de
	pop hl
	jr .checkmove

.gotstrongestmove
; Nothing we can do if no attacks did damage.
	ld a, c
	and a
	ret z

; Discourage moves that do less damage unless they're reckless too.
	ld hl, wAIMoveScores - 1
	ld de, EnemyMonMoves
	ld b, 0
	jr .checkmove2

; Ignore this move if it is the highest damaging one.
.loop
	cp c
	ld a, [de]
	inc de
	inc hl
	jr z, .checkmove2

	call AIGetEnemyMove

; Ignore this move if its power is 0 or 1.
; Moves such as Seismic Toss, Hidden Power,
; Counter and Fissure have a base power of 1.
	ld a, [wEnemyMoveStruct + MOVE_POWER]
	cp 2
	jr c, .checkmove2

; Ignore this move if it is reckless.
	push hl
	push de
	push bc
	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	ld hl, .RecklessMoves
	call IsInSingularArray
	pop bc
	pop de
	pop hl
	jr c, .checkmove2

; If we made it this far, discourage this move.
	inc [hl]

.checkmove2
	inc b
	ld a, b
	cp EnemyMonMovesEnd - EnemyMonMoves + 1
	jr nz, .loop
	ret

.RecklessMoves:
	db EFFECT_EXPLOSION
	db EFFECT_RAMPAGE
	db EFFECT_MULTI_HIT
	db EFFECT_DOUBLE_HIT
	db $ff

AIDamageCalc:
	ld a, 1
	ld [hBattleTurn], a
	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	ld hl, .ConstantDamageEffects
	call IsInSingularArray
	jr nc, .asm_39400
	jpba BattleCommand_ConstantDamage

.asm_39400
	callba EnemyAttackDamage
	callba BattleCommand_DamageCalc
	jpba BattleCommand_TypeMatchup

.ConstantDamageEffects
	db EFFECT_STATIC_DAMAGE
	db EFFECT_LEVEL_DAMAGE
	db EFFECT_PSYWAVE
	db $ff

AI_Cautious:
; 90% chance to discourage moves with residual effects after the first turn.

	ld a, [EnemyTurnsTaken]
	and a
	ret z

	ld hl, wAIMoveScores - 1
	ld de, EnemyMonMoves
	ld c, EnemyMonMovesEnd - EnemyMonMoves + 1
.asm_39425
	inc hl
	dec c
	ret z

	ld a, [de]
	inc de
	and a
	ret z

	push hl
	push de
	push bc
	ld hl, .residualmoves
	call IsInSingularArray

	pop bc
	pop de
	pop hl
	jr nc, .asm_39425

	call Random
	cp 230
	ret nc

	inc [hl]
	jr .asm_39425

.residualmoves
	db MIST
	db LEECH_SEED
	db POISONPOWDER
	db STUN_SPORE
	db THUNDER_WAVE
	db FOCUS_ENERGY
	db POISON_GAS
	db TRANSFORM
	db CONVERSION
	db SUBSTITUTE
	db SPIKES
	db LAVA_POOL
	db $ff

AI_Status:
; Dismiss status moves that don't affect the player.

	ld hl, wAIMoveScores - 1
	ld de, EnemyMonMoves
	ld b, EnemyMonMovesEnd - EnemyMonMoves + 1
.checkmove
	dec b
	ret z

	inc hl
	ld a, [de]
	and a
	ret z

	inc de
	call AIGetEnemyMove

	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	cp EFFECT_WILL_O_WISP
	jr z, .burnimmunity
	cp EFFECT_TOXIC
	jr z, .poisonimmunity
	cp EFFECT_POISON
	jr z, .poisonimmunity
	cp EFFECT_SLEEP
	jr z, .sleep_immunity
	cp EFFECT_PARALYZE
	jr z, .electricimmunity

	ld a, [wEnemyMoveStruct + MOVE_POWER]
	and a
	jr z, .checkmove

	jr .typeimmunity

.burnimmunity
	ld a, [PlayerAbility]
	cp ABILITY_WATER_VEIL
	jr z, .immune
	call AI_CheckLeafGuard
	jr z, .immune
	push bc
	ld b, FIRE
	jr .check_specific_immunity

.sleep_immunity
	ld a, [PlayerAbility]
	cp ABILITY_VITAL_SPIRIT
	jr z, .immune
	cp ABILITY_INSOMNIA
	jr z, .immune
	call AI_CheckLeafGuard
	jr z, .immune
	jr .typeimmunity

.poisonimmunity
	ld a, [PlayerAbility]
	cp ABILITY_IMMUNITY
	jr z, .immune
	call AI_CheckLeafGuard
	jr z, .immune
	push bc
	ld b, POISON
	jr .check_specific_immunity

.electricimmunity
	ld a, [PlayerAbility]
	cp ABILITY_LIMBER
	jr z, .immune
	call AI_CheckLeafGuard
	jr z, .immune
	push bc
	ld b, ELECTRIC

.check_specific_immunity
	call AI_CheckPlayerTypeMatchesB
	pop bc
	jr z, .immune

.typeimmunity
	push hl
	push bc
	push de
	ld a, 1
	ld [hBattleTurn], a
	callba PowderCheck
	jr c, .check_failed
	predef BattleCheckTypeMatchup
	pop de
	pop bc
	pop hl

	ld a, [wd265]
	and a
	jp nz, .checkmove
	jr .immune

.check_failed
	pop de
	pop bc
	pop hl
.immune
	call AIDiscourageMove
	jp .checkmove
; 394a9
AI_CheckLeafGuard:
; Assumes the player's ability is in a.
; Overloads a with the weather if the player has leaf guard.
	cp ABILITY_LEAF_GUARD
	ret nz
	ld a, [Weather]
	cp WEATHER_SUN
	ret

AI_Risky:
; Use any move that will KO the target.
; Risky moves will often be an exception (see below).

	ld hl, wAIMoveScores - 1
	ld de, EnemyMonMoves
	ld c, EnemyMonMovesEnd - EnemyMonMoves + 1
.checkmove
	inc hl
	dec c
	ret z

	ld a, [de]
	inc de
	and a
	ret z

	push de
	push bc
	push hl
	call AIGetEnemyMove

	ld a, [wEnemyMoveStruct + MOVE_POWER]
	and a
	jr z, .nextmove

; Don't use risky moves at max hp.
	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	cp EFFECT_EXPLOSION
	jr nz, .checkko

	call AICheckEnemyMaxHP
	jr c, .nextmove

; Else, 80% chance to exclude them.
	call Random
	cp 200 ; 1/5
	jr c, .nextmove

.checkko
	call AIDamageCalc

	call GetCurrentDamage
	ld a, [wCurDamage + 1]
	ld e, a
	ld a, [wCurDamage]
	ld d, a
	ld a, [BattleMonHP + 1]
	cp e
	ld a, [BattleMonHP]
	sbc d
	jr nc, .nextmove

	pop hl
rept 5
	dec [hl]
endr
	push hl

.nextmove
	pop hl
	pop bc
	pop de
	jr .checkmove

AIDiscourageMove:
	ld a, [hl]
	add 10
	ld [hl], a
AI_None:
	ret

AIGetEnemyMove:
; Load attributes of move a into ram

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

	pop bc
	pop de
	pop hl
	ret

AI_80_20:
	call Random
	cp 51 ; 1/5
	ret

AI_50_50:
	call Random
	rra ; 1/2
	ret
	
GetPlayerMoveType:
	ld a, [wPlayerMoveStruct + MOVE_TYPE]
	and $3f
	ret

GetEnemyMoveType:
	ld a, [wEnemyMoveStruct + MOVE_TYPE]
	and $3f
	ret