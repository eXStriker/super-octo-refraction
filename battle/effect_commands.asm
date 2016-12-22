EffectCommands1::

DoPlayerTurn:
	call SetPlayerTurn

	ld a, [wPlayerAction]
	and a
	ret nz

	jr DoTurn

DoEnemyTurn:
	call SetEnemyTurn

	ld a, [wLinkMode]
	and a
	jr z, DoTurn

	ld a, [wBattleAction]
	cp BATTLEACTION_E
	jr z, DoTurn
	cp BATTLEACTION_SWITCH1
	ret nc

	; fallthrough

DoTurn:
; Read in and execute the user's move effects for this turn.

	xor a
	ld [wTurnEnded], a
	ld [wMoveIsAnAbility], a

	; Effect command checkturn is called for every move.
	call CheckTurn

	ld a, [wTurnEnded]
	and a
	ret nz

UpdateMoveDataAndDoMove:
	call UpdateMoveData

DoMove:
; Get the user's move effect.
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	ld c, a
	ld b, 0
	ld hl, MoveEffectsPointers
	add hl, bc
	add hl, bc
	ld a, BANK(MoveEffectsPointers)
	call GetFarHalfword

	ld de, BattleScriptBuffer

.GetMoveEffect
	ld a, BANK(MoveEffects)
	call GetFarByteAndIncrement
	ld [de], a
	inc de
	cp $ff
	jr nz, .GetMoveEffect

; Start at the first command.
	ld hl, BattleScriptBuffer
	ld a, l
	ld [BattleScriptBufferLoc], a
	ld a, h
	ld [BattleScriptBufferLoc + 1], a

.ReadMoveEffectCommand:

; ld a, [BattleScriptBufferLoc++]
	ld hl, BattleScriptBufferLoc
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [hli]

	push af
	ld a, l
	ld [BattleScriptBufferLoc], a
	ld a, h
	ld [BattleScriptBufferLoc + 1], a
	pop af

; endturn_command (-2) is used to terminate branches without ending the read cycle.
	cp endturn_command
	ret nc

; The rest of the commands (01-af) are read from BattleCommandPointers.
	push bc
	dec a
	ld c, a
	ld b, 0
	ld hl, BattleCommandPointers
	add hl, bc
	add hl, bc
; 3-byte pointers
	add hl, bc
	ld a, BANK(BattleCommandPointers)
	call GetFarByteHalfword
	pop bc
	call .CallEffectCommand
	jr .ReadMoveEffectCommand

.CallEffectCommand:
	cp EFFECT_COMMANDS
	jp z, _hl_
	jp FarCall_hl

CheckTurn:
BattleCommand_CheckTurn:
; checkturn

; Repurposed as hardcoded turn handling. Useless as a command.

; Move $ff immediately ends the turn.
	ld a, BATTLE_VARS_MOVE
	call GetBattleVar
	inc a
	jp z, EndTurn

	xor a
	ld [AttackMissed], a
	ld [EffectFailed], a
	ld [wBattleAnimParam], a
	ld [AlreadyDisobeyed], a
	ld [AlreadyFailed], a
	ld [wSomeoneIsRampaging], a

	ld a, 10 ; 1.0
	ld [TypeModifier], a

	ld a, [hBattleTurn]
	and a
	jp nz, CheckEnemyTurn

CheckPlayerTurn:
	ld hl, wPlayerSubStatus4
	bit SUBSTATUS_RECHARGE, [hl]
	jr z, .no_recharge

	res SUBSTATUS_RECHARGE, [hl]
	ld hl, MustRechargeText
	call StdBattleTextBox
	call CantMove
	jp EndTurn

.no_recharge
	ld hl, BattleMonStatus
	ld a, [hl]
	and SLP
	jr z, .not_asleep

	dec a
	ld [hl], a
	and SLP
	jr z, .woke_up
	ld a, [PlayerAbility]
	cp ABILITY_EARLY_BIRD
	jr nz, .skip_early_bird
	dec [hl]
	ld a, [hl]
	and SLP
	jr z, .woke_up
.skip_early_bird

	xor a
	ld [wNumHits], a
	ld de, ANIM_SLP
	call PlayFXAnimIDIfNotSemiInvulnerable
	jr .fast_asleep

.woke_up
	ld hl, WokeUpText
	call StdBattleTextBox
	call CantMove
	call UpdateBattleMonInParty
	callba UpdatePlayerHUD
	ld a, $1
	ld [hBGMapMode], a
	ld hl, wPlayerSubStatus1
	res SUBSTATUS_NIGHTMARE, [hl]
	jr .not_asleep

.fast_asleep
	ld hl, FastAsleepText
	call StdBattleTextBox

	; Snore and Sleep Talk bypass sleep.
	ld a, [CurPlayerMove]
	cp SLEEP_TALK
	jr z, .not_asleep

	call CantMove
	jp EndTurn

.not_asleep
	ld hl, BattleMonStatus
	bit FRZ, [hl]
	jr z, .not_frozen

	; Flame Wheel and Sacred Fire thaw the user.
	ld a, [CurPlayerMove]
	cp FLAME_WHEEL
	jr z, .not_frozen
	cp FLARE_BLITZ
	jr z, .not_frozen
	cp SACRED_FIRE
	jr z, .not_frozen

	ld hl, FrozenSolidText
	call StdBattleTextBox

	call CantMove
	jp EndTurn

.not_frozen
	ld hl, wPlayerSubStatus3
	bit SUBSTATUS_FLINCHED, [hl]
	jr z, .not_flinched

	res SUBSTATUS_FLINCHED, [hl]
	call GetPlayerAbility
	cp ABILITY_INNER_FOCUS
	ld hl, FlinchedText
	jr z, .inner_focus
	push af
	call StdBattleTextBox

	call CantMove
	pop af
	cp ABILITY_STEADFAST
	call z, BattleCommand_SpeedUp
	jp EndTurn

.inner_focus
	ld hl, InnerFocusText
	call StdBattleTextBox
.not_flinched

	ld hl, PlayerDisableCount
	ld a, [hl]
	and a
	jr z, .not_disabled

	dec a
	ld [hl], a
	and $f
	jr nz, .not_disabled

	ld [hl], a
	ld [DisabledMove], a
	ld hl, DisabledNoMoreText
	call StdBattleTextBox

.not_disabled
	ld a, [wPlayerSubStatus3]
	add a
	jr nc, .not_confused
	ld hl, PlayerConfuseCount
	dec [hl]
	jr nz, .confused

	ld hl, wPlayerSubStatus3
	res SUBSTATUS_CONFUSED, [hl]
	ld hl, ConfusedNoMoreText
	call StdBattleTextBox
	jr .not_confused

.confused
	ld hl, IsConfusedText
	call StdBattleTextBox
	xor a
	ld [wNumHits], a
	ld de, ANIM_CONFUSED
	call PlayFXAnimIDIfNotSemiInvulnerable

	; 50% chance of hitting itself
	call BattleRandom
	and 1
	jr nz, .not_confused

	; clear confusion-dependent substatus
	ld hl, wPlayerSubStatus3
	ld a, [hl]
	and 1 << SUBSTATUS_CONFUSED
	ld [hl], a

	call HitConfusion
	call CantMove
	jp EndTurn

.not_confused
	ld a, [wPlayerSubStatus1]
	add a ; bit SUBSTATUS_ATTRACT
	jr nc, .not_infatuated

	ld hl, InLoveWithText
	call StdBattleTextBox
	xor a
	ld [wNumHits], a
	ld de, ANIM_IN_LOVE
	call PlayFXAnimIDIfNotSemiInvulnerable

	; 50% chance of infatuation
	call BattleRandom
	and 1
	jr z, .not_infatuated

	ld hl, InfatuationText
	call StdBattleTextBox
	call CantMove
	jp EndTurn

.not_infatuated
	; We can't disable a move that doesn't exist.
	ld a, [DisabledMove]
	and a
	jr z, .no_disabled_move

	; Are we using the disabled move?
	ld hl, CurPlayerMove
	cp [hl]
	jr nz, .no_disabled_move

	call MoveDisabled
	call CantMove
	jp EndTurn

.no_disabled_move
	ld hl, BattleMonStatus
	bit PAR, [hl]
	jr z, .not_paralyzed

	; 25% chance to be fully paralyzed
	call BattleRandom
	and 3
	jr nz, .not_paralyzed

	ld hl, FullyParalyzedText
	call StdBattleTextBox
	call CantMove
	jp EndTurn

.not_paralyzed
	ld hl, wPlayerSubStatus2
	bit SUBSTATUS_GUARDING, [hl]
	ret z
	ld hl, IsGuardingText
	call StdBattleTextBox
	call CantMove
	jp EndTurn

CantMove:
	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	res SUBSTATUS_ROLLOUT, [hl]

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	ld a, [hl]
	and $ff ^ (1 << SUBSTATUS_RAMPAGE + 1 << SUBSTATUS_CHARGED)
	ld [hl], a

	call ResetFuryCutterCount

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp FLY
	jr z, .fly_dig

	cp DIG
	ret nz

.fly_dig
	res SUBSTATUS_UNDERGROUND, [hl]
	res SUBSTATUS_FLYING, [hl]
	jp AppearUserRaiseSub

OpponentCantMove:
	call SwitchTurn
	call CantMove
	jp SwitchTurn

CheckEnemyTurn:
	ld hl, wEnemySubStatus4
	bit SUBSTATUS_RECHARGE, [hl]
	jr z, .no_recharge

	res SUBSTATUS_RECHARGE, [hl]
	ld hl, MustRechargeText
	call StdBattleTextBox
	call CantMove
	jp EndTurn

.no_recharge

	ld hl, EnemyMonStatus
	ld a, [hl]
	and SLP
	jr z, .not_asleep

	dec a
	ld [hl], a
	and a
	jr z, .woke_up
	ld a, [EnemyAbility]
	cp ABILITY_EARLY_BIRD
	jr nz, .skip_early_bird
	dec [hl]
	ld a, [hl]
	and SLP
	jr z, .woke_up
.skip_early_bird

	ld hl, FastAsleepText
	call StdBattleTextBox
	xor a
	ld [wNumHits], a
	ld de, ANIM_SLP
	call PlayFXAnimIDIfNotSemiInvulnerable
	jr .fast_asleep

.woke_up
	ld hl, WokeUpText
	call StdBattleTextBox
	call CantMove
	call UpdateEnemyMonInParty
	callba UpdateEnemyHUD
	ld a, $1
	ld [hBGMapMode], a
	ld hl, wEnemySubStatus1
	res SUBSTATUS_NIGHTMARE, [hl]
	jr .not_asleep

.fast_asleep
	; Snore and Sleep Talk bypass sleep.
	ld a, [CurEnemyMove]
	cp SLEEP_TALK
	jr z, .not_asleep
	call CantMove
	jp EndTurn

.not_asleep
	ld hl, EnemyMonStatus
	bit FRZ, [hl]
	jr z, .not_frozen
	ld a, [CurEnemyMove]
	cp FLAME_WHEEL
	jr z, .not_frozen
	cp FLARE_BLITZ
	jr z, .not_frozen
	cp SACRED_FIRE
	jr z, .not_frozen

	ld hl, FrozenSolidText
	call StdBattleTextBox
	call CantMove
	jp EndTurn

.not_frozen
	ld hl, wEnemySubStatus3
	bit SUBSTATUS_FLINCHED, [hl]
	jr z, .not_flinched

	res SUBSTATUS_FLINCHED, [hl]
	call GetEnemyAbility
	cp ABILITY_INNER_FOCUS
	ld hl, FlinchedText
	jr z, .inner_focus

	push af
	ld hl, FlinchedText
	call StdBattleTextBox

	call CantMove
	pop af
	cp ABILITY_STEADFAST
	call z, BattleCommand_SpeedUp
	jp EndTurn

.inner_focus
	ld hl, InnerFocusText
	call StdBattleTextBox
.not_flinched

	ld hl, EnemyDisableCount
	ld a, [hl]
	and a
	jr z, .not_disabled

	dec a
	ld [hl], a
	and $f
	jr nz, .not_disabled

	ld [hl], a
	ld [EnemyDisabledMove], a

	ld hl, DisabledNoMoreText
	call StdBattleTextBox

.not_disabled
	ld a, [wEnemySubStatus3]
	add a ; bit SUBSTATUS_CONFUSED
	jr nc, .not_confused

	ld hl, EnemyConfuseCount
	dec [hl]
	jr nz, .confused

	ld hl, wEnemySubStatus3
	res SUBSTATUS_CONFUSED, [hl]
	ld hl, ConfusedNoMoreText
	call StdBattleTextBox
	jr .not_confused

.confused
	ld hl, IsConfusedText
	call StdBattleTextBox

	xor a
	ld [wNumHits], a
	ld de, ANIM_CONFUSED
	call PlayFXAnimIDIfNotSemiInvulnerable

	; 50% chance of hitting itself
	call BattleRandom
	and 1
	jr nz, .not_confused

	; clear status bits other than confusion
	ld a, 1 << SUBSTATUS_CONFUSED
	ld [wEnemySubStatus3], a

	ld hl, HurtItselfText
	call StdBattleTextBox
	call HitSelfInConfusion
	call BattleCommand_DamageCalc
	call BattleCommand_LowerSub
	xor a
	ld [wNumHits], a

	; Flicker the monster pic unless flying or underground.
	ld de, ANIM_HIT_CONFUSION
	ld a, [wEnemySubStatus3]
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	call z, PlayFXAnimID

	ld c, $1
	call EnemyHurtItself
	call BattleCommand_RaiseSub
	call CantMove
	jp EndTurn

.not_confused
	ld a, [wEnemySubStatus1]
	add a ; bit SUBSTATUS_ATTRACT
	jr nc, .not_infatuated

	ld hl, InLoveWithText
	call StdBattleTextBox
	xor a
	ld [wNumHits], a
	ld de, ANIM_IN_LOVE
	call PlayFXAnimIDIfNotSemiInvulnerable

	; 50% chance of infatuation
	call BattleRandom
	and 1
	jr z, .not_infatuated

	ld hl, InfatuationText
	call StdBattleTextBox
	call CantMove
	jp EndTurn

.not_infatuated
	; We can't disable a move that doesn't exist.
	ld a, [EnemyDisabledMove]
	and a
	jr z, .no_disabled_move

	; Are we using the disabled move?
	ld hl, CurEnemyMove
	cp [hl]
	jr nz, .no_disabled_move

	call MoveDisabled

	call CantMove
	jp EndTurn

.no_disabled_move
	ld hl, EnemyMonStatus
	bit PAR, [hl]
	ret z

	; 25% chance to be fully paralyzed
	call BattleRandom
	and 3
	ret nz

	ld hl, FullyParalyzedText
	call StdBattleTextBox
	call CantMove

	; fallthrough

EndTurn:
	ld a, $1
	ld [wTurnEnded], a
	jp ResetDamage

MoveDisabled:
	; Make sure any charged moves fail
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	res SUBSTATUS_CHARGED, [hl]

	ld a, BATTLE_VARS_MOVE
	call GetBattleVar
	ld [wNamedObjectIndexBuffer], a
	call GetMoveName

	ld hl, DisabledMoveText
	jp StdBattleTextBox

HitConfusion:
	ld hl, HurtItselfText
	call StdBattleTextBox

	xor a
	ld [wCriticalHitOrOHKO], a

	call HitSelfInConfusion
	call BattleCommand_DamageCalc
	call BattleCommand_LowerSub

	xor a
	ld [wNumHits], a

	; Flicker the monster pic unless flying or underground.
	ld de, ANIM_HIT_CONFUSION
	ld a, [wPlayerSubStatus3]
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	call z, PlayFXAnimID

	callba UpdatePlayerHUD
	ld a, $1
	ld [hBGMapMode], a
	ld c, $1
	call PlayerHurtItself
	jp BattleCommand_RaiseSub

BattleCommand_DoTurn:
	call CheckUserIsCharging
	ret nz

	ld hl, BattleMonPP
	ld de, wPlayerSubStatus3
	ld bc, PlayerTurnsTaken

	ld a, [hBattleTurn]
	ld [wBattleTurnTemp], a
	and a
	jr z, .proceed

	ld hl, EnemyMonPP
	ld de, wEnemySubStatus3
	ld bc, EnemyTurnsTaken

.proceed

; If we've gotten this far, this counts as a turn.
	ld a, [bc]
	inc a
	ld [bc], a

	ld a, BATTLE_VARS_MOVE
	call GetBattleVar
	cp STRUGGLE
	ret z

	ld a, [de]
	and 1 << SUBSTATUS_IN_LOOP | 1 << SUBSTATUS_RAMPAGE ;removed: | 1 << SUBSTATUS_BIDE
	ret nz

	call .consume_pp
	ld a, b
	and a
	jp nz, EndMoveEffect

	; SubStatus5
	inc de
	inc de

	ld a, [de]
	bit SUBSTATUS_TRANSFORMED, a
	ret nz

	ld a, [hBattleTurn]
	and a

	ld hl, PartyMon1PP
	ld a, [CurBattleMon]
	jr z, .getPartyMonOffset

; mimic this part entirely if wildbattle
	ld a, [wBattleMode]
	dec a
	jr z, .wild

	ld hl, OTPartyMon1PP
	ld a, [CurOTMon]
.getPartyMonOffset
	call GetPartyLocation
.consume_pp
	xor a
	push hl
	call .consume_pp_
	pop hl
	call GetTargetAbility
	cp ABILITY_PRESSURE
	ret nz
	ld a, 1
.consume_pp_
	push af
	ld a, [hBattleTurn]
	and a
	ld a, [CurMoveNum]
	jr z, .okay
	ld a, [CurEnemyMoveNum]
.okay
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	and $3f
	jr z, .out_of_pp
	dec [hl]
	ld b, 0
.pop_ret
	pop af
	ret

.wild
	ld hl, EnemyMonMoves
	ld a, [CurEnemyMoveNum]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld hl, wWildMonMoves
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, .pop_ret
	ld hl, wWildMonPP
	jr .consume_pp

.out_of_pp
	pop af
	and a
	ld b, 0
	ret nz
	call BattleCommand_MoveDelay
; get move effect
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
; continuous?
	ld hl, .continuousmoves
	call IsInSingularArray

; 'has no pp left for [move]'
	ld hl, HasNoPPLeftText
	jr nc, .print
; 'but no pp is left for the move'
	ld hl, NoPPLeftText
.print
	call StdBattleTextBox
	ld b, 1
	ret

.continuousmoves
	db EFFECT_RAZOR_WIND
	db EFFECT_SKY_ATTACK
	db EFFECT_SOLARBEAM
	db EFFECT_FLY
	db EFFECT_ROLLOUT
	db EFFECT_RAMPAGE
	db $ff

BattleCommand_TypeMatchup:
; STAB = Same Type Attack Bonus
; Also does the type matchup
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp STRUGGLE
	ret z
	cp FUTURE_SIGHT
	jr z, .future_sight

	ld hl, BattleMonType1
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, EnemyMonType1
	ld a, [hli]
	ld d, a
	ld e, [hl]

	ld a, [hBattleTurn]
	and a
	jr z, .go ; Who Attacks and who Defends

	push bc
	ld b, d
	ld c, e
	pop de
.go
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVarAddr
	and $3f
	ld [wTypeMatchup], a

	call CheckAbilityNegatesWeather
	jr z, .skip_weather_modifiers

	push hl
	push de
	push bc
	callba DoWeatherModifiers
	pop bc
	pop de
	pop hl

.skip_weather_modifiers
	push hl
	push de
	push bc
	callba DoBadgeTypeBoosts
	pop bc
	pop de
	pop hl

	ld a, [wTypeMatchup]
	cp b
	jr z, .stab
	cp c
	jr z, .stab

	jr .SkipStab

.future_sight
	ld a, PSYCHIC
	ld [wTypeMatchup], a
	ld hl, EnemyMonType1
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ld hl, wPlayerFutureSightLevel
	ld a, [hBattleTurn]
	and a
	jr z, .okay
	ld hl, BattleMonType1
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ld hl, wEnemyFutureSightLevel
.okay

	push de
	push hl
	callba DoBadgeTypeBoosts
	pop hl
	pop de

	bit 7, [hl]
	jr z, .SkipStab

.stab
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_ADAPTABILITY
	jr z, .double_damage
	push af
	call AddHalfDamage
	pop af
	cp ABILITY_NALJO_FURY
	jr nz, .done_stab
	push de
	callba RegionCheck
	ld a, e
	cp REGION_NALJO
	pop de
	jr nz, .done_stab
.double_damage
	ld hl, wCurDamageShiftCount
	inc [hl]
	call SetDamageDirtyFlag
.done_stab
	ld hl, TypeModifier
	set 7, [hl]

.SkipStab:
	call InAPinchBoost
	call GetAbilityDamageModifier
	jr nc, .SkipAbilityDamageModifier
	ld hl, wCurDamageShiftCount
	and a
	jr z, .no_effect
	dec a
	jr z, .half_ability_damage
	; double damage
	inc [hl]
	jr .load_ability_damage

.no_effect
	ld a, [TypeModifier]
	and $80
	ld [TypeModifier], a
	call ZeroDamage
	xor a
	ld [wTypeMatchup], a
	inc a
	ld [AttackMissed], a
	ret

.half_ability_damage
	dec [hl]
.load_ability_damage ;this doesn't "load" anything anymore, but the name is somewhat okay
	call SetDamageDirtyFlag
.SkipAbilityDamageModifier
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	and $3f
	ld b, a
	call GetTypeMatchupFromBitArray
	ld a, [wTypeMatchup]
	ld b, a
	push af
	ld a, [TypeModifier]
	and $80
	or b
	ld [TypeModifier], a
	pop af
	and a
	ret z
	cp 10
	jr c, .CheckTintedLens
	ret z
	call GetTargetAbility
	cp ABILITY_SOLID_ROCK
	ret nz
	; reducing damage by a quarter is equivalent to tripling it and quartering it
	ld hl, wCurDamageShiftCount
	dec [hl]
	dec [hl]
	jp TripleDamageModifier

.CheckTintedLens
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_TINTED_LENS
	ret nz
	ld hl, wCurDamageShiftCount
	inc [hl]
	jp SetDamageDirtyFlag

TypeBoostAbilities:
	db ABILITY_OVERGROW, GRASS
	db ABILITY_BLAZE,    FIRE
	db ABILITY_TORRENT,  WATER
	db ABILITY_SWARM,    BUG
	db $FF

BattleCheckTypeMatchup:
	ld hl, EnemyMonType1
	ld a, [hBattleTurn]
	and a
	jr z, CheckTypeMatchup
	ld hl, BattleMonType1
CheckTypeMatchup:
	push hl
	call GetAbilityDamageModifier
	pop hl
	jr nc, .okay
	and a
	jr nz, .okay
	ld [wTypeMatchup], a
	ret

.okay
	push hl
	push de
	push bc
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	and $3f
	ld b, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	call GetTypeMatchupFromBitArray
	pop bc
	pop de
	pop hl
	ret

GetTypeMatchupFromBitArray:
; attacking type b, defending types d, e
	ld a, 10
	ld [wTypeMatchup], a
	ld a, b
	push bc
	ld bc, MATCHUP_TABLE_WIDTH
	ld hl, TypeMatchup
	rst AddNTimes
	pop bc
	push hl
	push de
	push bc
	ld e, d
	call .GetMatchup
	pop bc
	pop de
	pop hl
	ret c
	ld a, d
	cp e
	ret z
.GetMatchup
	call .GetNonStandardTypeMatchup
	push de
	jr c, .got_bits
	ld a, e
	srl e
	srl e
	ld d, 0
	add hl, de
	ld e, [hl]
	and $3
	jr z, .got_bits
.bit_loop
	srl e
	srl e
	dec a
	jr nz, .bit_loop
.got_bits
	ld a, e
	pop de
	and $3
	call z, .ForesightCheck
	jr z, .immune
	cp NTL
	push af
	ld a, 10
	jr z, .got_damage_mod
	jr c, .not_very_effective
	add a
	jr .got_damage_mod

.not_very_effective
	srl a
.got_damage_mod
	ld b, a
	ld a, [TypeModifier]
	and %10000000
	add b
	ld [TypeModifier], a

	pop af
	ret z

	ld hl, wCurDamageShiftCount
	jr c, .halve
	inc [hl]
	call SetDamageDirtyFlag
	ld hl, wTypeMatchup
	sla [hl]
	and a
	ret

.halve
	dec [hl]
	call SetDamageDirtyFlag
	ld hl, wTypeMatchup
	srl [hl]
	and a
	ret

.immune
	call ZeroDamage
	xor a
	ld [wTypeMatchup], a
	inc a
	ld [AttackMissed], a
	ld a, [TypeModifier]
	and $80
	ld [TypeModifier], a
	scf
	ret

.ForesightCheck
	ld a, e
	cp GHOST
	jr nz, .not_foresight
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVar
	bit SUBSTATUS_IDENTIFIED, a
	jr nz, .foresight
	call GetUserAbility
	cp ABILITY_SCRAPPY
	jr nz, .not_foresight
.foresight
	ld a, NTL
	and a
	ret

.not_foresight
	xor a
	ret

.GetNonStandardTypeMatchup
	push hl
	push de
	push bc
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld hl, .NonStandardTypeMatchups
	ld e, 3
	call IsInArray
	pop bc
	pop de
	jr nc, .standard
	inc hl
	ld a, [hli]
	cp $80
	jr z, .nonstandard
	cp d
	jr z, .nonstandard
	cp e
	jr nz, .standard
.nonstandard
	ld e, [hl]
	pop hl
	and a
	ret

.standard
	pop hl
	and a
	ret

.NonStandardTypeMatchups
	db STEEL_EATER,  STEEL,  NTL
	db BOIL,         WATER,  SE_
	db CRYSTAL_BOLT, GROUND, NTL
	db VOID_SPHERE,  $80,    NTL
	db GHOST_HAMMER, $80,    NTL
	db $ff

GetAbilityDamageModifier:
	call GetTargetAbility
	ld b, a
	ld hl, .AbilityTypeMatchups
	jr .look_up_ability
.next
	inc hl
	inc hl
.look_up_ability
	ld a, [hli]
	cp $ff
	ret z
	cp b
	jr nz, .next
	cp ABILITY_SOUNDPROOF
	jr nz, .notSoundproof
	call IsSoundBasedMove
	jr nc, .next
	jr .done
.notSoundproof
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	and $3f
	cp [hl]
	jr nz, .next
.done
	inc hl
	ld a, [hl]
	scf
	ret

.AbilityTypeMatchups:
	db ABILITY_LEVITATE,     GROUND,   0
	db ABILITY_SOUNDPROOF,   SOUND,    0
	db ABILITY_LIGHTNINGROD, ELECTRIC, 0
	db ABILITY_MOTOR_DRIVE,  ELECTRIC, 0
	db ABILITY_FLASH_FIRE,   FIRE,     0
	db ABILITY_VOLT_ABSORB,  ELECTRIC, 0
	db ABILITY_WATER_ABSORB, WATER,    0
	db ABILITY_HEATPROOF,    FIRE,     1
	db ABILITY_THICK_FAT,    FIRE,     1
	db ABILITY_THICK_FAT,    ICE,      1
	db $ff

BattleCommand_ResetTypeMatchup:
; Reset the type matchup multiplier to 1.0, if the type matchup is not 0.
; If there is immunity in play, the move automatically misses.
	call BattleCheckTypeMatchup
	ld a, [wTypeMatchup]
	and a
	jr nz, .reset
	call ZeroDamage
	xor a
	ld [TypeModifier], a
	inc a
	ld [AttackMissed], a
	ret

.reset
	ld a, 10 ; 1.0
	ld [wTypeMatchup], a
	ret

TypeMatchup: INCLUDE "battle/type_matchup.asm"

BattleCommand_DamageVariation:
; damagevariation

; Modify the damage spread between 85% and 100%.
; There were a lot of comments here explaining the various details (and inaccuracies) of this process, but they no longer apply.

	call BattleRandom
	and 15
	ld [wCurDamageRandomVariance], a ;variance is stored complemented -- a value of 3 indicates taking 3% away (so the attack does 97% damage)
	call SetDamageDirtyFlag

; Guarding takes the final damage, which happens to be the result of damagevariation
; therefore put the guard check here
; update: this is no longer relevant (exact calculations imply that factors are commutative), but there's no point in moving this elsewhere
	ld a, [wPlayerSubStatus2]
	bit SUBSTATUS_GUARDING, a
	ret z
	ld a, [wCriticalHitOrOHKO]
	and a
	ret nz
	ld hl, wCurDamageShiftCount
	dec [hl]
	ret ;no need to call SetDamageDirtyFlag again

BattleCommand_CheckHit:
; checkhit

	call .DreamEater
	jp z, .Missed

	call .Protect
	jp nz, .Missed

	ld a, [PlayerAbility]
	cp ABILITY_NO_GUARD
	ret z
	ld a, [EnemyAbility]
	cp ABILITY_NO_GUARD
	ret z

	call .LockOn
	ret nz

	call .FlyDigMoves
	jp nz, .Missed

	call .ThunderRain
	ret z

	call .XAccuracy
	ret nz

	; Perfect-accuracy moves
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_ALWAYS_HIT
	ret z

	call .StatModifiers

	ld a, [wPlayerMoveStruct + MOVE_ACC]
	ld b, a
	ld a, [hBattleTurn]
	and a
	jr z, .BrightPowder
	ld a, [wEnemyMoveStruct + MOVE_ACC]
	ld b, a

.BrightPowder:
	push bc
	call GetOpponentItem
	ld a, b
	cp HELD_BRIGHTPOWDER
	ld a, c ; % miss
	pop bc
	jr nz, .skip_brightpowder

	ld c, a
	ld a, b
	sub c
	ld b, a
	jr nc, .skip_brightpowder
	ld b, 0

.skip_brightpowder
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_COMPOUNDEYES
	jr z, .compoundeyes
	cp ABILITY_HUSTLE
	jr nz, .accuracy_sample
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	and $c0
	jr nz, .accuracy_sample
	ld a, b
	sub 20 percent
	ld b, a
	jr nc, .accuracy_sample
	jr .Missed

.compoundeyes
	ld a, b
	cp $ff
	ret z
	add 30 percent
	ld b, a
	ret c
.accuracy_sample
	ld a, b
	cp $ff
	ret z
	call BattleRandom
	cp b
	ret c
.Missed:
	ld a, 1
	ld [AttackMissed], a
	ret

.DreamEater
; Return z if we're trying to eat the dream of
; a monster that isn't sleeping.
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_DREAM_EATER
	ret nz

	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and SLP
	ret

.Protect
; Return nz if the opponent is protected.
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVar
	bit SUBSTATUS_PROTECT, a
	ret z

	ld c, 40
	call DelayFrames

; 'protecting itself!'
	ld hl, ProtectingItselfText
	call StdBattleTextBox

	ld c, 40
	call DelayFrames

	ld a, 1
	and a
	ret

.LockOn
; Return nz if we are locked-on and aren't trying to use Earthquake,
; Fissure or Magnitude on a monster that is flying.
	ld a, BATTLE_VARS_SUBSTATUS5_OPP
	call GetBattleVarAddr
	bit SUBSTATUS_LOCK_ON, [hl]
	res SUBSTATUS_LOCK_ON, [hl]
	ret z

	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	bit SUBSTATUS_FLYING, a
	jr z, .LockedOn

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar

	cp EARTHQUAKE
	ret z
	cp MAGNITUDE
	ret z

.LockedOn
	ld a, 1
	and a
	ret

.FlyDigMoves
; Check for moves that can hit underground/flying opponents.
; Return z if the current move can hit the opponent.

	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	ret z

	bit SUBSTATUS_FLYING, a
	jr z, .DigMoves

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar

	cp GUST
	ret z
	cp WHIRLWIND
	ret z
	cp THUNDER
	ret z
	cp TWISTER
	ret

.DigMoves
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar

	cp EARTHQUAKE
	ret z
	cp MAGNITUDE
	ret

.ThunderRain
; Return z if the current move always hits in rain, and it is raining.
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_THUNDER
	ret nz

	ld a, [Weather]
	cp WEATHER_RAIN
	ret

.XAccuracy
	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVar
	bit SUBSTATUS_X_ACCURACY, a
	ret

.StatModifiers

	ld a, [hBattleTurn]
	and a

	; load the user's accuracy into b and the opponent's evasion into c.
	ld hl, wPlayerMoveStruct + MOVE_ACC
	ld a, [PlayerAccLevel]
	ld b, a
	ld a, [EnemyEvaLevel]
	ld c, a

	jr z, .got_acc_eva

	ld hl, wEnemyMoveStruct + MOVE_ACC
	ld a, [EnemyAccLevel]
	ld b, a
	ld a, [PlayerEvaLevel]
	ld c, a

.got_acc_eva
	call .KeenEyeMod
	cp b
	jr c, .skip_foresight_check

	; if the target's evasion is greater than the user's accuracy,
	; check the target's foresight status
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVar
	bit SUBSTATUS_IDENTIFIED, a
	ret nz

.skip_foresight_check
	; subtract evasion from 14
	ld a, 14
	sub c
	ld c, a
	; store the base move accuracy for math ops
	xor a
	ld [hMultiplicand + 0], a
	ld [hMultiplicand + 1], a
	ld a, [hl]
	ld [hMultiplicand + 2], a
	push hl
	lb de, 2, 1 ; do this twice, once for the user's accuracy and once for the target's evasion
	            ; store the divisor in e so we only do one division and avoid precision loss

.accuracy_loop
	; look up the multiplier from the table
	push bc
	ld hl, .AccProb
	dec b
	sla b
	ld c, b
	ld b, 0
	add hl, bc
	pop bc
	; multiply by the first byte in that row...
	ld a, [hli]
	ld [hMultiplier], a
	predef Multiply
	; ... and multiply the divisor by the second byte
	ld a, [hl]
	push bc
	ld c, e
	call SimpleMultiply
	ld e, a
	pop bc
	; do the same thing to the target's evasion
	ld b, c
	dec d
	jr nz, .accuracy_loop

	ld a, e
	ld [hDivisor], a
	ld b, 4
	predef Divide
	; minimum accuracy is $0001
	ld a, [hQuotient + 2]
	ld b, a
	ld a, [hQuotient + 1]
	or b
	jr nz, .not_min_accuracy
	ld [hQuotient + 1], a
	inc a
	ld [hQuotient + 2], a

.not_min_accuracy
	call GetTargetAbility
	cp ABILITY_TANGLED_FEET
	jr nz, .no_halve
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	bit SUBSTATUS_CONFUSED, a
	jr z, .no_halve
	ld a, [hQuotient + 1]
	srl a
	ld [hQuotient + 1], a
	ld a, [hQuotient + 2]
	rr a
	ld [hQuotient + 2], a

.no_halve
	call GetTargetAbility
	ld d, a
	ld hl, .WeatherEvasionAbilities
.loop
	ld a, [hli]
	cp $ff
	jr z, .check_16bit_accuracy
	cp d
	jr z, .check
	inc hl
	jr .loop

.check
	ld a, [Weather]
	cp [hl]
	jr nz, .check_16bit_accuracy
	ld a, 4
	ld [hMultiplier], a
	predef Multiply
	ld a, 5
	ld [hDivisor], a
	ld b, 4
	predef Divide
.check_16bit_accuracy
	; if the result is more than 2 bytes, max out at 100%
	ld a, [hQuotient + 1]
	and a
	ld a, [hQuotient + 2]
	jr z, .finish_accuracy
	ld a, $ff

.finish_accuracy
	pop hl
	ld [hl], a
	ret

.WeatherEvasionAbilities
	db ABILITY_SNOW_CLOAK, WEATHER_HAIL
	db ABILITY_SAND_VEIL,  WEATHER_SANDSTORM
	db $ff

.AccProb:
	db  1, 3 ;  33.3% -6
	db  3, 8 ;  37.5% -5
	db  3, 7 ;  42.9% -4
	db  1, 2 ;  50.0% -3
	db  3, 5 ;  60.0% -2
	db  3, 4 ;  75.0% -1
	db  1, 1 ; 100.0%  0
	db  4, 3 ; 133.3% +1
	db  5, 3 ; 166.7% +2
	db  2, 1 ; 200.0% +3
	db  7, 3 ; 233.3% +4
	db  8, 3 ; 266.7% +5
	db  3, 1 ; 300.0% +6

.KeenEyeMod
	call GetUserAbility
	cp ABILITY_KEEN_EYE
	ld a, c
	ret nz
	cp 7
	ret c
	ld a, 7
	ld c, a
	ret

BattleCommand_EffectChance:
; effectchance

	xor a
	ld [EffectFailed], a
	call CheckSubstituteOpp
	jr nz, .failed
	call GetTargetAbility
	cp ABILITY_SHIELD_DUST
	jr z, .failed

	push bc
	push hl
	ld hl, wPlayerMoveStruct + MOVE_CHANCE
	ld a, [hBattleTurn]
	and a
	jr z, .got_move_chance
	ld hl, wEnemyMoveStruct + MOVE_CHANCE
.got_move_chance
	ld b, [hl]
	pop hl
	call GetUserAbility
	cp ABILITY_SERENE_GRACE
	jr nz, .not_serene_grace
	sla b
	jr c, .skip_sample
.not_serene_grace
	call BattleRandom
	cp b
.skip_sample
	pop bc
	ret c

.failed
	ld a, 1
	ld [EffectFailed], a
	and a
	ret

BattleCommand_LowerSub:
; lowersub

	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVar
	bit SUBSTATUS_SUBSTITUTE, a
	ret z

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	bit SUBSTATUS_CHARGED, a
	jr nz, .already_charged

	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	ld hl, .charging_moves
	call IsInSingularArray
	jr c, .charge_turn

.already_charged
	call .Rampage
	jr z, .charge_turn

	call CheckUserIsCharging
	ret nz

.charge_turn
	call CheckBattleScene
	jr c, .mimic_anims

	xor a
	ld [wNumHits], a
	ld [FXAnimIDHi], a
	inc a
	ld [wBattleAnimParam], a
	ld a, SUBSTITUTE
	jp LoadAnim

.mimic_anims
	call BattleCommand_LowerSubNoAnim
	jp BattleCommand_MoveDelay

.Rampage
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_ROLLOUT
	jr z, .rollout_rampage
	cp EFFECT_RAMPAGE
	jr z, .rollout_rampage

	ld a, 1
	and a
	ret

.rollout_rampage
	ld a, [wSomeoneIsRampaging]
	and a
	ld a, 0
	ld [wSomeoneIsRampaging], a
	ret

.charging_moves
	db EFFECT_RAZOR_WIND
	db EFFECT_SKY_ATTACK
	db EFFECT_SOLARBEAM
	db EFFECT_FLY
	db -1

BattleCommand_HitTarget:
; hittarget
	call BattleCommand_LowerSub
	call BattleCommand_HitTargetNoSub
	jp BattleCommand_RaiseSub

SturdyCheck:
	call GetTargetAbility
	cp ABILITY_STURDY
	ret nz

	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	inc hl
	inc hl
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	cp b
	ret nz
	ld a, [hl]
	cp c
	ret nz

	ld a, BATTLE_VARS_SUBSTATUS2_OPP
	call GetBattleVarAddr
	set SUBSTATUS_STURDY, [hl]
	ret

BattleCommand_HitTargetNoSub:
	ld a, [AttackMissed]
	and a
	jp nz, BattleCommand_MoveDelay

	call SturdyCheck

	ld a, [hBattleTurn]
	and a
	ld de, PlayerRolloutCount
	ld a, BATTLEANIM_ENEMY_DAMAGE
	jr z, .got_rollout_count
	ld de, EnemyRolloutCount
	ld a, BATTLEANIM_PLAYER_DAMAGE

.got_rollout_count
	ld [wNumHits], a
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_MULTI_HIT
	jr z, .multihit
	cp EFFECT_CONVERSION
	jr z, .conversion
	cp EFFECT_DOUBLE_HIT
	jr z, .doublehit
	cp EFFECT_TWINEEDLE
	jr z, .twineedle
	xor a
	ld [wBattleAnimParam], a

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld e, a
	ld d, 0
	call PlayFXAnimID

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp FLY
	jr z, .fly_dig
	cp DIG
	ret nz

.fly_dig
; clear sprite
	jp AppearUserLowerSub

.multihit
.conversion
.doublehit
.twineedle
	ld a, [wBattleAnimParam]
	and 1
	xor 1
	ld [wBattleAnimParam], a
	ld a, [de]
	cp $1
	push af
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld e, a
	ld d, 0
	pop af
	jp z, PlayFXAnimID
	xor a
	ld [wNumHits], a
	jp PlayFXAnimID

BattleCommand_StatUpAnim:
	ld a, [AttackMissed]
	and a
	jp nz, BattleCommand_MoveDelay

	xor a
	jr BattleCommand_StatUpDownAnim

BattleCommand_StatDownAnim:
	ld a, [AttackMissed]
	and a
	jp nz, BattleCommand_MoveDelay

	ld a, [hBattleTurn]
	and a
	ld a, BATTLEANIM_ENEMY_STAT_DOWN
	jr z, BattleCommand_StatUpDownAnim
	ld a, BATTLEANIM_WOBBLE

	; fallthrough

BattleCommand_StatUpDownAnim:
	ld [wNumHits], a
	xor a
	ld [wBattleAnimParam], a
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld e, a
	ld d, 0
	jp PlayFXAnimID

BattleCommand_RaiseSub:
; raisesub

	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVar
	bit SUBSTATUS_SUBSTITUTE, a
	ret z

	call CheckBattleScene
	jp c, BattleCommand_RaiseSubNoAnim

	xor a
	ld [wNumHits], a
	ld [FXAnimIDHi], a
	ld a, $2
	ld [wBattleAnimParam], a
	ld a, SUBSTITUTE
	jp LoadAnim

BattleCommand_FailureText:
; failuretext
; If the move missed or failed, load the appropriate
; text, and end the effects of multi-turn or multi-
; hit moves.
	ld a, [AttackMissed]
	and a
	ret z

	call GetFailureResultText
	call .EndMultiturnMoves
	call .CheckLightningrod
	jp EndMoveEffect

.EndMultiturnMoves
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVarAddr

	cp FLY
	jr z, .fly_dig
	cp DIG
	jr z, .fly_dig

; Move effect:
	inc hl
	ld a, [hl]

	cp EFFECT_MULTI_HIT
	jr z, .multihit
	cp EFFECT_DOUBLE_HIT
	jr z, .multihit
	cp EFFECT_TWINEEDLE
	ret nz

.multihit
	jp BattleCommand_RaiseSub

.fly_dig
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	res SUBSTATUS_UNDERGROUND, [hl]
	res SUBSTATUS_FLYING, [hl]
	jp AppearUserRaiseSub

.CheckLightningrod
; Target has Lightningrod
	call GetTargetAbility
	cp ABILITY_FLASH_FIRE
	jr z, .FlashFire
	cp ABILITY_WATER_ABSORB
	jr z, .WaterAbsorb
	cp ABILITY_MOTOR_DRIVE
	jr z, .motor_drive_lightningrod
	cp ABILITY_VOLT_ABSORB
	jr z, .motor_drive_lightningrod
	cp ABILITY_LIGHTNINGROD
	ret nz
.motor_drive_lightningrod
; Last move was Electric
	ld b, a
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	and $3f
	cp ELECTRIC
	ret nz
; Target is not Ground-type
	ld hl, BattleMonType
	ld a, [hBattleTurn]
	and a
	jr nz, .got_mon_types
	ld hl, EnemyMonType
.got_mon_types
	ld a, GROUND
	cp [hl]
	ret z
	inc hl
	cp [hl]
	ret z
; Not using Protect
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVar
	bit SUBSTATUS_PROTECT, a
	ret nz
; Raise Special Attack (LR) or Speed (MD), or restore HP (VA)
	call SwitchTurn
	call ResetMiss
	xor a
	ld [EffectFailed], a
	ld a, b
	ld [wMoveIsAnAbility], a
	cp ABILITY_LIGHTNINGROD
	jr z, .lightningrod
	cp ABILITY_MOTOR_DRIVE
	jr z, .motor_drive
	; Volt Absorb
	call Ability_RestoreTargetHP
	jr .finish

.motor_drive
	call BattleCommand_SpeedUp
	call BattleCommand_StatUpMessage
	jr .finish

.lightningrod
	call BattleCommand_SpecialAttackUp
	call BattleCommand_StatUpMessage
.finish
	call SwitchTurn
	xor a
	ld [wMoveIsAnAbility], a
	ret

.FlashFire
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	and $3f
	cp FIRE
	ret nz
; Not using Protect
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVarAddr
	bit SUBSTATUS_PROTECT, [hl]
	ret nz
; Not already Flash-Fired
	inc hl
	bit SUBSTATUS_FLASH_FIRE, [hl]
	ret nz
	set SUBSTATUS_FLASH_FIRE, [hl]
	ld hl, FlashFireText
	jp StdBattleTextBox

.WaterAbsorb
	ld b, a
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVar
	bit SUBSTATUS_PROTECT, a
	ret nz
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	and $3f
	cp WATER
	ret nz
	call SwitchTurn
	ld a, b
	call Ability_RestoreTargetHP
	jp SwitchTurn

Ability_RestoreTargetHP:
	ld [wd265], a
	call GetAbilityName
	callba GetQuarterMaxHP
	callba RestoreUserHP
	ld hl, AbilityRestoreHPText
	jp StdBattleTextBox

BattleCommand_CheckFaint:
; checkfaint
; also does damage

	ld a, BATTLE_VARS_SUBSTATUS2_OPP
	call GetBattleVarAddr
	bit SUBSTATUS_STURDY, [hl]
	res SUBSTATUS_STURDY, [hl]
	jr nz, .sturdy

	dec hl
	bit SUBSTATUS_ENDURE, [hl]
	jr z, .not_enduring
	call BattleCommand_FalseSwipe
	ld b, 0
	jr nc, .okay
	inc b
	jr .okay

.sturdy
	call BattleCommand_FalseSwipe
	ld b, 0
	jr nc, .okay
	ld b, 3
	jr .okay

.not_enduring
	call GetOpponentItem
	ld a, b
	cp HELD_FOCUS_BAND
	ld b, 0
	jr nz, .okay
	call BattleRandom
	cp c
	jr nc, .okay
	call BattleCommand_FalseSwipe
	ld b, 0
	jr nc, .okay
	ld b, 2
.okay
	push bc
	call .check_sub
	ld c, 0
	ld a, [hBattleTurn]
	and a
	jr nz, .damage_player
	call EnemyHurtItself
	jr .done_damage

.damage_player
	call PlayerHurtItself

.done_damage
	call ShellBellCheck
	pop af
	and a
	ret z
	dec a
	ld hl, EnduredText
	jp z, StdBattleTextBox

	dec a
	jr nz, .ability_prevented_faint
	call GetOpponentItem
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName

	ld hl, HungOnText
	jp StdBattleTextBox

.ability_prevented_faint
	call GetTargetAbility
	ld [wNamedObjectIndexBuffer], a
	call GetAbilityName

	ld hl, HungOnText
	jp StdBattleTextBox

.check_sub
	call CheckSubstituteOpp
	ret nz

	ld hl, PlayerDamageTaken + 1
	ld a, [hBattleTurn]
	and a
	jr nz, .damage_taken
	ld hl, EnemyDamageTaken + 1

.damage_taken
	call GetCurrentDamage
	ld a, [wCurDamage + 1]
	add a, [hl]
	ld [hld], a
	ld a, [wCurDamage]
	adc [hl]
	ld [hl], a
	ret nc
	ld a, $ff
	ld [hli], a
	ld [hl], a
	ret

ShellBellCheck:
	call GetUserItem
	ld a, b
	cp HELD_SHELL_BELL
	ret nz

	call BattleCommand_MoveDelay

	call GetCurrentDamage
	ld hl, wCurDamage
	ld a, [hli]
	ld c, [hl]
	ld b, a
	or c
	ret z

	; Divide by 8
	srl b
	rr c
	srl b
	rr c
	srl b
	rr c

	; Floor at 1
	ld a, b
	or c
	jr nz, .okay_restore
	inc c
.okay_restore
	call SwitchTurn
	callba RestoreOpponentHP
	call SwitchTurn
	ld hl, HealedWithShellBellText
	jp StdBattleTextBox

GetFailureResultText:
	ld hl, DoesntAffectText
	ld de, DoesntAffectText
	ld a, [TypeModifier]
	and $7f
	jr z, .got_text
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_FUTURE_SIGHT
	ld hl, ButItFailedText
	ld de, ItFailedText
	jr z, .got_text
	ld hl, AttackMissedText
	ld de, AttackMissedText
	ld a, [wCriticalHitOrOHKO]
	cp $ff
	jr nz, .got_text
	ld hl, UnaffectedText
.got_text
	call FailText_CheckOpponentProtect
	xor a
	ld [wCriticalHitOrOHKO], a

	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_JUMP_KICK
	ret nz

	ld a, [TypeModifier]
	and $7f
	ret z

	callba GetHalfMaxHP
	ld hl, wCurDamageFixedValue
	ld [hl], b
	inc hl
	ld [hl], c
	ld hl, wCurDamageFlags
	set 7, [hl] ;fixed damage
	set 6, [hl] ;dirty
	ld hl, CrashedText
	call StdBattleTextBox
	ld a, $1
	ld [wBattleAnimParam], a
	call LoadMoveAnim
	ld c, $1
	ld a, [hBattleTurn]
	and a
	jp nz, EnemyHurtItself
	jp PlayerHurtItself

FailText_CheckOpponentProtect:
	ld a, [wMoveIsAnAbility]
	and a
	ret nz
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVar
	bit SUBSTATUS_PROTECT, a
	jr z, .not_protected
	ld h, d
	ld l, e
.not_protected
	jp StdBattleTextBox

BattleCommand_CriticalText:
; criticaltext
; Prints the message for critical hits.

; If there is no message to be printed, wait 20 frames.
	ld a, [wCriticalHitOrOHKO]
	and a
	jr z, .wait
	ld hl, CriticalHitText
	call StdBattleTextBox
	xor a
	ld [wCriticalHitOrOHKO], a
.wait
	ld c, 20
	jp DelayFrames

BattleCommand_StartLoop:
; startloop

	ld hl, PlayerRolloutCount
	ld a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, EnemyRolloutCount
.ok
	xor a
	ld [hl], a
	ret

BattleCommand_SuperEffectiveLoopText:
; supereffectivelooptext

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	bit SUBSTATUS_IN_LOOP, a
	ret nz

	; fallthrough

BattleCommand_SuperEffectiveText:
; supereffectivetext

	ld a, [TypeModifier]
	and $7f
	cp 10 ; 1.0
	ret z
	ld hl, SuperEffectiveText
	jr nc, .print
	ld hl, NotVeryEffectiveText
.print
	jp StdBattleTextBox

BattleCommand_CheckDestinyBond:
; checkdestinybond

; Faint the user if it fainted an opponent using Destiny Bond.

	ld hl, EnemyMonHP
	ld a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld hl, BattleMonHP

.got_hp
	ld a, [hli]
	or [hl]
	jp nz, ContactAbilityEffect

	ld a, BATTLE_VARS_SUBSTATUS5_OPP
	call GetBattleVar
	bit SUBSTATUS_DESTINY_BOND, a
	jr z, .no_dbond

	ld hl, EnemyMonMaxHP + 1
	bccoord 2, 2 ; hp bar
	ld a, [hBattleTurn]
	and a
	jr nz, .got_max_hp
	ld hl, BattleMonMaxHP + 1
	bccoord 10, 9 ; hp bar

.got_max_hp
	xor 1
	ld [wWhichHPBar], a
	ld a, [hld]
	ld [wCurHPAnimMaxHP], a
	or [hl]
	ld a, [hld]
	ld [wCurHPAnimMaxHP + 1], a
	jr z, .finish

	push bc
	push hl
	ld hl, TookDownWithItText
	call StdBattleTextBox
	pop hl

	ld a, [hl]
	ld [wCurHPAnimOldHP], a
	xor a
	ld [hld], a
	ld a, [hl]
	ld [wCurHPAnimOldHP + 1], a
	xor a
	ld [hl], a
	ld [wCurHPAnimNewHP], a
	ld [wCurHPAnimNewHP + 1], a
	pop hl
	predef AnimateHPBar
	call RefreshBattleHuds

	call SwitchTurn
	xor a
	ld [wNumHits], a
	ld [FXAnimIDHi], a
	inc a
	ld [wBattleAnimParam], a
	ld a, DESTINY_BOND
	call LoadAnim
	call SwitchTurn

	jr .finish

.no_dbond
	call ContactAbilityEffect
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_MULTI_HIT
	jr z, .multiple_hit_raise_sub
	cp EFFECT_DOUBLE_HIT
	jr z, .multiple_hit_raise_sub
	cp EFFECT_TWINEEDLE
	jr nz, .finish
.multiple_hit_raise_sub
	call BattleCommand_RaiseSub

.finish
	jp EndMoveEffect

ContactAbilityEffect:
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and a
	ret nz
	call CheckSubstituteOpp
	ret nz
	callba UsedContactMove
	ret nc
	call GetTargetAbility
	ld [wMoveIsAnAbility], a
	ld [wd265], a
	call GetAbilityName
	ld a, [wMoveIsAnAbility]
	ld hl, .ContactAbilities
	ld de, 3
	call IsInArray
	jr nc, .skip
	inc hl
	call BattleRandom ; preserves hl
	cp 30 percent
	jr nc, .skip
	push af
	call SwitchTurn
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	call _hl_
	call SwitchTurn
.skip
	xor a
	ld [wMoveIsAnAbility], a
	ret

.ContactAbilities:
	dbw ABILITY_STATIC, BattleCommand_ParalyzeTarget
	dbw ABILITY_FLAME_BODY, BattleCommand_BurnTarget
	dbw ABILITY_POISON_POINT, BattleCommand_PoisonTarget
	dbw ABILITY_CUTE_CHARM, BattleCommand_Attract
	dbw ABILITY_EFFECT_SPORE, .EffectSpore
	db -1

.EffectSpore:
	push af
	callba CheckForGrassTyping
	pop bc
	ld a, b
	ret c
	cp 9 percent
	jp c, BattleCommand_PoisonTarget
	cp 19 percent
	jp c, BattleCommand_ParalyzeTarget
	jp BattleCommand_SleepTarget

BattleCommand_BuildOpponentRage:
; buildopponentrage
	ld a, [AttackMissed]
	and a
	ret nz

	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVar
	bit SUBSTATUS_RAGE, a
	ret z

	call SwitchTurn
	call BattleCommand_AttackUp
	ld hl, RageBuildingText
	call StdBattleTextBox
	jp SwitchTurn

DittoMetalPowder:
	ld a, MON_SPECIES
	call BattlePartyAttr
	ld a, [hBattleTurn]
	and a
	ld a, [hl]
	jr nz, .check_ditto
	ld a, [TempEnemyMonSpecies]

.check_ditto
	cp DITTO
	ret nz

	call GetOpponentItem
	ld a, [hl]
	cp METAL_POWDER
	ret nz

	ld hl, wCurDamageDefense + 1
	sla [hl]
	dec hl
	rl [hl]
	jp SetDamageDirtyFlag

BattleCommand_DamageStats:
; damagestats

	ld a, [hBattleTurn]
	and a
	jp nz, EnemyAttackDamage

	; fallthrough

PlayerAttackDamage:
; Load level, move power, attack and defense for the player attacking and the enemy defending.

	call ResetDamage
	call SetDamageDirtyFlag

	ld hl, wPlayerMoveStructPower
	ld a, [hli]
	and a
	jp z, ZeroDamage
	push hl
	ld hl, wCurDamageMovePowerNumerator
	ld [hl], 0
	inc hl
	ld [hli], a
	ld [hl], 1

	ld a, [PlayerAbility]
	call AbilityBasePowerBoosts

	ld a, [wPlayerSubStatus2]
	bit SUBSTATUS_FLASH_FIRE, a
	call nz, FlashFireBuff

	pop hl
	ld a, [hl]
	bit 7, a
	jp nz, ZeroDamage
	bit 6, a
	jr nz, .special

.physical
	ld hl, EnemyMonDefense
	ld a, [hli]
	ld l, [hl]
	ld h, a

	ld a, [wEnemyScreens]
	bit SCREENS_REFLECT, a
	jr z, .no_physical_screen
	add hl, hl
.no_physical_screen
	ld a, h
	ld b, l
	ld hl, wCurDamageDefense
	ld [hli], a
	ld [hl], b

	ld hl, BattleMonAttack
	call CheckCriticalDiscardStatBoosts
	jr c, .load_attack

	ld a, e
	and a
	jr z, .physicaldefokay
	push hl
	ld hl, EnemyStats + DEFENSE * 2
	ld a, [hli]
	ld b, [hl]
	ld hl, wCurDamageDefense
	ld [hli], a
	ld [hl], b
	pop hl
.physicaldefokay
	ld a, d
	and a
	jr z, .load_attack
	ld hl, PlayerStats + ATTACK * 2
.load_attack
	ld a, [hli]
	ld b, [hl]
	ld hl, wCurDamageAttack
	ld [hli], a
	ld [hl], b
	call LightBallBoost
	call HustleBoost
	jr .done

.special
	ld hl, EnemyMonSpclDef
	ld a, [hli]
	ld l, [hl]
	ld h, a

	ld a, [wEnemyScreens]
	bit SCREENS_LIGHT_SCREEN, a
	jr z, .no_special_screen
	add hl, hl
.no_special_screen
	ld a, h
	ld b, l
	ld hl, wCurDamageDefense
	ld [hli], a
	ld [hl], b

	ld a, [wPlayerMoveStructAnimation]
	cp FUTURE_SIGHT
	ld hl, wPlayerFutureSightUsersSpAtk
	jr z, .got_sp_atk
	ld hl, BattleMonSpclAtk
.got_sp_atk
	call CheckCriticalDiscardStatBoosts
	jr c, .load_sp_atk

	ld a, e
	and a
	jr z, .specialdefokay
	push hl
	ld hl, EnemyStats + SP_DEFENSE * 2
	ld a, [hli]
	ld b, [hl]
	ld hl, wCurDamageDefense
	ld [hli], a
	ld [hl], b
	pop hl
.specialdefokay
	ld a, d
	and a
	jr z, .load_sp_atk
	ld hl, PlayerStats + SP_ATTACK * 2

.load_sp_atk
	ld a, [hli]
	ld b, [hl]
	ld hl, wCurDamageAttack
	ld [hli], a
	ld [hl], b
	call LightBallBoost
.done

	ld a, [wPlayerMoveStructAnimation]
	cp FUTURE_SIGHT
	ld a, [BattleMonLevel]
	jr nz, .got_level
	ld a, [wPlayerFutureSightLevel]
	and $7f
.got_level
	ld [wCurDamageLevel], a
	call DittoMetalPowder

	ld a, 1
	and a
	ret

FlashFireBuff:
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	and $3f
	cp FIRE
	ret nz
	ld hl, wCurDamageMovePowerDenominator
	sla [hl]
	;fallthrough

TripleMovePower:
	ld hl, wCurDamageMovePowerNumerator
	ld a, [hli]
	ld b, a
	ld c, [hl]
	push hl
	ld h, b
	ld l, c
	add hl, bc
	add hl, bc
	ld b, h
	ld a, l
	pop hl
	ld [hld], a
	ld [hl], b
	jp SetDamageDirtyFlag

AbilityBasePowerBoosts:
	ld hl, .Abilities
	ld e, 3
	call IsInArray
	jp c, CallLocalPointer_AfterIsInArray
	ret

.Abilities
	dbw ABILITY_TECHNICIAN, .Technician
	dbw ABILITY_RECKLESS,   .Reckless
	dbw ABILITY_IRON_FIST,  .IronFist
	dbw ABILITY_RIVALRY,    .Rivalry
	db $ff

.Rivalry
	call CheckOppositeGender
	jr nc, .TwentyFivePercentLess
	ret z ; genderless
	; Same gender: increase power
.TwentyFivePercentMore
	ld hl, wCurDamageMovePowerNumerator
	ld a, [hli]
	ld b, a
	ld c, [hl]
	push hl
	ld h, b
	ld l, c
	; x5
	add hl, hl
	add hl, hl
	add hl, bc
	ld a, l
	ld b, h
	pop hl
	ld [hld], a
	ld [hl], b
	call .QuarterMovePower
	jp SetDamageDirtyFlag

.TwentyFivePercentLess
	; Opposite gender: reduce power
	call .QuarterMovePower
	jp TripleMovePower

.QuarterMovePower
	ld hl, wCurDamageMovePowerDenominator
	sla [hl]
	sla [hl]
	ret

.IronFist
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld hl, .Moves
	call IsInSingularArray
	jr c, .TwentyPercentMore
	ret

.Moves
	db BULLET_PUNCH
	db DIZZY_PUNCH
	db DYNAMICPUNCH
	db FIRE_PUNCH
	db ICE_PUNCH
	db MACH_PUNCH
	db DRAIN_PUNCH
	db METEOR_MASH
	db THUNDERPUNCH
	db -1

.Technician
	ld hl, wCurDamageMovePowerNumerator
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	; hl = wCurDamageMovePowerDenominator
	ld e, [hl]
	ld d, 0
	call Divide16 ;no need to use Divide16 (as it will just call Divide), but it preloads the results into registers
	ld a, d
	and a
	ret nz
	ld a, e
	cp 60
	jr z, .check_remainder
	ret nc
.technician_ok
	sla [hl]
	call TripleMovePower
	ret

.check_remainder
	ld a, c
	and a
	jr z, .technician_ok
	ret

.Reckless
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_RECOIL_HIT
	ret nz
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp STRUGGLE
	ret z
.TwentyPercentMore
	ld hl, wCurDamageMovePowerNumerator
	ld a, [hli]
	ld b, a
	ld c, [hl]
	push hl
	; x6
	sla c
	rl b
	ld h, b
	ld l, c
	add hl, bc
	add hl, bc
	ld b, h
	ld a, l
	pop hl
	ld [hld], a
	ld [hl], b
	ld hl, wCurDamageMovePowerDenominator
	ld a, [hl]
	; x5
	add a, a
	add a, a
	add a, [hl]
	ld [hl], a
	jp SetDamageDirtyFlag

CheckCriticalDiscardStatBoosts:
; Return carry if non-critical
; d = 1: Attack is less than neutral
; e = 1: Defense is better than neutral

	ld a, [wCriticalHitOrOHKO]
	and a
	scf
	ret z

	push hl
	push bc
	ld a, [hBattleTurn]
	and a
	jr nz, .enemy
	ld a, [wPlayerMoveStructType]
	bit 7, a
	jr nz, .skip_atk
	bit 6, a
; special
	ld a, [PlayerSAtkLevel]
	ld b, a
	ld a, [EnemySDefLevel]
	jr nz, .end
; physical
	ld a, [PlayerAtkLevel]
	ld b, a
	ld a, [EnemyDefLevel]
	jr .end

.enemy
	ld a, [wEnemyMoveStructType]
	bit 7, a
	jr nz, .skip_atk
	bit 6, a
; special
	ld a, [EnemySAtkLevel]
	ld b, a
	ld a, [PlayerSDefLevel]
	jr nz, .end
; physical
	ld a, [EnemyAtkLevel]
	ld b, a
	ld a, [PlayerDefLevel]
.end
	cp 7
	ld e, 0
	jr c, .skip_def
	inc e
.skip_def
	ld a, b
	cp 7
	ld d, 0
	jr nc, .skip_atk
	inc d
.skip_atk
	pop bc
	pop hl
	and a
	ret

HustleBoost:
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_HUGE_POWER
	jr z, .double_attack
	cp ABILITY_HUSTLE
	jr z, .hustle
	call GetTargetAbility
	cp ABILITY_MARVEL_SCALE
	ret nz
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and a
	ret z
	ld hl, wCurDamageDefense + 1
.double
	sla [hl]
	dec hl
	rl [hl]
	jp SetDamageDirtyFlag
.hustle
	ld hl, wCurDamageFlags
	inc [hl]
	set 6, [hl] ;no point in calling SetDamageDirtyFlag when we can do this
	ret
.double_attack
	ld hl, wCurDamageAttack + 1
	jr .double

LightBallBoost:
; If the attacking monster is Pikachu and it's
; holding a Light Ball, double the attack stat.
	ld a, MON_SPECIES
	call BattlePartyAttr

	ld a, [hBattleTurn]
	and a
	ld a, [hl]
	jr z, .compare_species
	ld a, [TempEnemyMonSpecies]
.compare_species
	cp PIKACHU
	ret nz

	call GetUserItem
	ld a, [hl]
	cp LIGHT_BALL
	ret nz

; Double the stat
	ld hl, wCurDamageAttack + 1
	sla [hl]
	dec hl
	rl [hl]
	jp SetDamageDirtyFlag

EnemyAttackDamage:
; Load level, move power, attack and defense for the enemy attacking and the player defending.
	call ResetDamage
	call SetDamageDirtyFlag

; No damage dealt with 0 power.
	ld hl, wEnemyMoveStructPower
	ld a, [hli] ; hl = wEnemyMoveStructType
	ld d, a
	and a
	jp z, ZeroDamage
	push hl
	ld hl, wCurDamageMovePowerNumerator
	ld [hl], 0
	inc hl
	ld [hli], a
	ld [hl], 1

	ld a, [EnemyAbility]
	call AbilityBasePowerBoosts

	ld a, [wEnemySubStatus2]
	bit SUBSTATUS_FLASH_FIRE, a
	call nz, FlashFireBuff

	pop hl
	ld a, [hl]
	bit 7, a
	jp nz, ZeroDamage
	bit 6, a
	jr nz, .special

.physical
	ld hl, BattleMonDefense
	ld a, [hli]
	ld l, [hl]
	ld h, a

	ld a, [wPlayerScreens]
	bit SCREENS_REFLECT, a
	jr z, .no_physical_screen
	add hl, hl
.no_physical_screen
	ld a, h
	ld b, l
	ld hl, wCurDamageDefense
	ld [hli], a
	ld [hl], b

	ld hl, EnemyMonAttack

	call CheckCriticalDiscardStatBoosts
	jr c, .load_attack

	ld a, e
	and a
	jr z, .physicaldefokay
	push hl
	ld hl, PlayerStats + DEFENSE * 2
	ld a, [hli]
	ld b, [hl]
	ld hl, wCurDamageDefense
	ld [hli], a
	ld [hl], b
	pop hl
.physicaldefokay
	ld a, d
	and a
	jr z, .load_attack
	ld hl, EnemyStats + ATTACK * 2
.load_attack
	ld a, [hli]
	ld b, [hl]
	ld hl, wCurDamageAttack
	ld [hli], a
	ld [hl], b
	call LightBallBoost
	call HustleBoost
	jr .done

.special
	ld hl, BattleMonSpclDef
	ld a, [hli]
	ld l, [hl]
	ld h, a

	ld a, [wPlayerScreens]
	bit SCREENS_LIGHT_SCREEN, a
	jr z, .no_special_screen
	add hl, hl
.no_special_screen
	ld a, h
	ld b, l
	ld hl, wCurDamageDefense
	ld [hli], a
	ld [hl], b

	ld a, [wEnemyMoveStructAnimation]
	cp FUTURE_SIGHT
	ld hl, wEnemyFutureSightUsersSpAtk
	jr z, .got_sp_atk
	ld hl, EnemyMonSpclAtk
.got_sp_atk
	call CheckCriticalDiscardStatBoosts
	jr c, .load_sp_atk

	ld a, e
	and a
	jr z, .specialdefokay
	push hl
	ld hl, PlayerStats + SP_DEFENSE * 2
	ld a, [hli]
	ld b, [hl]
	ld hl, wCurDamageDefense
	ld [hli], a
	ld [hl], b
	pop hl
.specialdefokay
	ld a, d
	and a
	jr z, .load_sp_atk
	ld hl, EnemyStats + SP_ATTACK * 2

.load_sp_atk
	ld a, [hli]
	ld b, [hl]
	ld hl, wCurDamageAttack
	ld [hli], a
	ld [hl], b
	call LightBallBoost
.done

	ld a, [wEnemyMoveStructAnimation]
	cp FUTURE_SIGHT
	ld a, [EnemyMonLevel]
	jr nz, .got_level
	ld a, [wEnemyFutureSightLevel]
	and $7f
.got_level
	ld [wCurDamageLevel], a
	call DittoMetalPowder

	ld a, 1
	and a
	ret

HitSelfInConfusion:
	call ResetDamage
	ld a, [hBattleTurn]
	and a
	jr nz, .enemy
	ld a, [BattleMonLevel]
	push af
	ld a, [wPlayerScreens]
	ld hl, BattleMonAttack
	jr .go
.enemy
	ld a, [EnemyMonLevel]
	push af
	ld a, [wEnemyScreens]
	ld hl, EnemyMonAttack
.go
	bit SCREENS_REFLECT, a
	; bc = attack, de = defense
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	jr z, .no_screen
	sla e
	rl d
.no_screen
	ld hl, wCurDamageMovePowerNumerator
	xor a
	ld [hli], a
	ld [hl], 40
	inc hl ;wCurDamageMovePowerDenominator
	inc a
	ld [hli], a
	; hl = wCurDamageLevel
	pop af
	ld [hl], a
	ld hl, wCurDamageAttack
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	; hl = wCurDamageDefense
	ld a, d
	ld [hli], a
	ld [hl], e
	call SetDamageDirtyFlag
	call LightBallBoost
	call HustleBoost
	jp DittoMetalPowder

BattleCommand_DamageCalc:
; damagecalc

; Prepare damage calculations. (Actual damage calculations will be done when GetCurrentDamage is called with the dirty flag set.)

; Return 1 if successful, else 0.

	call SetDamageDirtyFlag

	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar

; Selfdestruct and Explosion double move power.
	cp EFFECT_EXPLOSION
	jr nz, .dont_explode

	ld hl, wCurDamageMovePowerNumerator + 1
	sla [hl]
	dec hl
	rl [hl]

.dont_explode

; Variable-hit moves and Conversion can have a power of 0.
	cp EFFECT_MULTI_HIT
	jr z, .skip_zero_damage_check

	cp EFFECT_CONVERSION
	jr z, .skip_zero_damage_check

; No damage if move power is 0.
	ld hl, wCurDamageMovePowerNumerator
	ld a, [hli]
	or [hl]
	jp z, ZeroDamage

.skip_zero_damage_check
	; damage = (level * 0.4 + 2) * attack * power / (defense * 50)
	; except that we don't calculate it here anymore

; Item boosts
	call GetUserItem

	ld a, b
	and a
	jr z, .DoneItem

	ld hl, TypeBoostItems

.NextItem
	ld a, [hli]
	cp $ff
	jr z, .DoneItem

; Item effect
	cp b
	ld a, [hli]
	jr nz, .NextItem

; Type
	ld b, a
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	and $3f
	cp b
	jr nz, .DoneItem

; * 100 + item effect amount
	ld a, c
	add a, 100
	ld [wCurDamageItemModifier], a
.DoneItem

; Critical hits
	call .CriticalMultiplier

	ld a, 1
	and a
	ret

.CriticalMultiplier
	ld a, [wCriticalHitOrOHKO]
	ld hl, wCurDamageFlags
	res 4, [hl]
	res 5, [hl]
	and a
	ret z

	call GetUserAbility
	cp ABILITY_SNIPER
	jr nz, .FiftyPercentMore
; x2.25
	set 5, [hl]
	ret
; x1.5
.FiftyPercentMore
	set 4, [hl]
	ret

TypeBoostItems:
	db HELD_NORMAL_BOOST,   NORMAL   ; Pink/Polkadot Bow
	db HELD_FIGHTING_BOOST, FIGHTING ; Blackbelt
	db HELD_FLYING_BOOST,   FLYING   ; Sharp Beak
	db HELD_POISON_BOOST,   POISON   ; Poison Barb
	db HELD_GROUND_BOOST,   GROUND   ; Soft Sand
	db HELD_ROCK_BOOST,     ROCK     ; Hard Stone
	db HELD_BUG_BOOST,      BUG      ; Silverpowder
	db HELD_GHOST_BOOST,    GHOST    ; Spell Tag
	db HELD_FIRE_BOOST,     FIRE     ; Charcoal
	db HELD_WATER_BOOST,    WATER    ; Mystic Water
	db HELD_GRASS_BOOST,    GRASS    ; Miracle Seed
	db HELD_ELECTRIC_BOOST, ELECTRIC ; Magnet
	db HELD_PSYCHIC_BOOST,  PSYCHIC  ; Twistedspoon
	db HELD_ICE_BOOST,      ICE      ; Nevermeltice
	db HELD_DRAGON_BOOST,   DRAGON   ; Dragon Scale
	db HELD_DARK_BOOST,     DARK     ; Blackglasses
	db HELD_STEEL_BOOST,    STEEL    ; Metal Coat
	db $ff

BattleCommand_ConstantDamage:
; constantdamage

	ld hl, BattleMonLevel
	ld a, [hBattleTurn]
	and a
	jr z, .got_turn
	ld hl, EnemyMonLevel

.got_turn
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_LEVEL_DAMAGE
	ld b, [hl]
	ld a, 0
	jr z, .got_power

	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_PSYWAVE
	jr z, .psywave

	cp EFFECT_REVERSAL
	jr z, .reversal

	ld a, BATTLE_VARS_MOVE_POWER
	call GetBattleVar
	ld b, a
	ld a, $0
	jr .got_power

.psywave
	ld a, b
	srl a
	add b
	ld b, a
.psywave_loop
	call BattleRandom
	and a
	jr z, .psywave_loop
	cp b
	jr nc, .psywave_loop
	ld b, a
	xor a

.got_power
	ld hl, wCurDamageFlags
	ld [hl], $c0 ;fixed damage, dirty
	inc hl ;hl = wCurDamageFixedValue
	ld [hli], a
	ld [hl], b
	ret

.reversal
	ld hl, BattleMonHP
	ld a, [hBattleTurn]
	and a
	jr z, .reversal_got_hp
	ld hl, EnemyMonHP
.reversal_got_hp
	xor a
	ld [hMultiplicand], a
	ld a, [hli]
	ld [hMultiplicand + 1], a
	ld a, [hli]
	ld [hMultiplicand + 2], a
	ld a, $30
	ld [hMultiplier], a
	predef Multiply
	ld a, [hli]
	ld [hDivisor], a
	ld a, [hl]
	ld [hDivisor + 1], a
	predef DivideLong
	ld a, [hLongQuotient + 3]
	ld b, a
	ld hl, .FlailPower

.reversal_loop
	ld a, [hli]
	cp b
	jr nc, .break_loop
	inc hl
	jr .reversal_loop

.break_loop
	ld a, [hBattleTurn]
	and a
	ld a, [hl]
	jr nz, .notPlayersTurn

	ld hl, wPlayerMoveStructPower
	ld [hl], a
	push hl
	call PlayerAttackDamage
	jr .notEnemysTurn

.notPlayersTurn
	ld hl, wEnemyMoveStructPower
	ld [hl], a
	push hl
	call EnemyAttackDamage

.notEnemysTurn
	call BattleCommand_DamageCalc
	pop hl
	ld [hl], 1
	ret

.FlailPower
	;  px,  bp
	db  1, 200
	db  4, 150
	db  9, 100
	db 16,  80
	db 32,  40
	db 48,  20

BattleCommand_Counter:
; counter

	ld a, 1
	ld [AttackMissed], a
	ld a, BATTLE_VARS_LAST_COUNTER_MOVE_OPP
	call GetBattleVar
	and a
	ret z

	ld b, a
	callba GetMoveEffect
	ld a, b
	cp EFFECT_COUNTER
	ret z

	call BattleCommand_ResetTypeMatchup
	ld a, [wTypeMatchup]
	and a
	ret z

	call CheckOpponentWentFirst
	ret z

	ld a, BATTLE_VARS_LAST_COUNTER_MOVE_OPP
	call GetBattleVar
	dec a
	ld de, wStringBuffer1
	call GetMoveData

	ld a, [wStringBuffer1 + 2]
	and a
	ret z

	ld a, [wStringBuffer1 + 3]
	and $c0
	ret nz

	call GetCurrentDamage
	ld hl, wCurDamage
	ld a, [hli]
	ld d, a
	or [hl]
	ret z

	ld e, [hl]
	ld hl, wCurDamageFlags
	ld a, $c0 ;fixed damage, dirty
	ld [hli], a
	; hl = wCurDamageFixedValue
	sla e
	rl d
	jr nc, .not_capped
	ld de, $ffff
.not_capped
	ld a, d
	ld [hli], a
	ld [hl], e
	xor a
	ld [AttackMissed], a
	ret

BattleCommand_Encore:
; encore

	ld hl, EnemyMonMoves
	ld de, EnemyEncoreCount
	ld a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, BattleMonMoves
	ld de, PlayerEncoreCount
.ok
	ld a, BATTLE_VARS_LAST_MOVE_OPP
	call GetBattleVar
	and a
	jp z, .failed
	cp STRUGGLE
	jp z, .failed
	cp ENCORE
	jp z, .failed
	cp MIRROR_MOVE
	jp z, .failed
	ld b, a

.got_move
	ld a, [hli]
	cp b
	jr nz, .got_move

	ld bc, BattleMonPP - BattleMonMoves - 1
	add hl, bc
	ld a, [hl]
	and $3f
	jp z, .failed
	ld a, [AttackMissed]
	and a
	jp nz, .failed
	ld a, BATTLE_VARS_SUBSTATUS5_OPP
	call GetBattleVarAddr
	bit SUBSTATUS_ENCORED, [hl]
	jp nz, .failed
	set SUBSTATUS_ENCORED, [hl]
	call BattleRandom
	and $3
	add 4
	ld [de], a
	call CheckOpponentWentFirst
	jr nz, .finish_move
	ld a, [hBattleTurn]
	and a
	jr z, .force_last_enemy_move

	push hl
	ld a, [LastPlayerMove]
	ld b, a
	ld c, 0
	ld hl, BattleMonMoves
.find_player_move
	ld a, [hli]
	cp b
	jr z, .got_player_move
	inc c
	ld a, c
	cp NUM_MOVES
	jr c, .find_player_move
	pop hl
	res SUBSTATUS_ENCORED, [hl]
	xor a
	ld [de], a
	jr .failed

.got_player_move
	pop hl
	ld a, c
	ld [CurMoveNum], a
	ld a, b
	ld [CurPlayerMove], a
	dec a
	ld de, wPlayerMoveStruct
	call GetMoveData
	jr .finish_move

.force_last_enemy_move
	push hl
	ld a, [LastEnemyMove]
	ld b, a
	ld c, 0
	ld hl, EnemyMonMoves
.find_enemy_move
	ld a, [hli]
	cp b
	jr z, .got_enemy_move
	inc c
	ld a, c
	cp NUM_MOVES
	jr c, .find_enemy_move
	pop hl
	res SUBSTATUS_ENCORED, [hl]
	xor a
	ld [de], a
.failed
	jp PrintDidntAffect

.got_enemy_move
	pop hl
	ld a, c
	ld [CurEnemyMoveNum], a
	ld a, b
	ld [CurEnemyMove], a
	dec a
	ld de, wEnemyMoveStruct
	call GetMoveData

.finish_move
	call AnimateCurrentMove
	ld hl, GotAnEncoreText
	jp StdBattleTextBox

BattleCommand_Conversion2:
; conversion2

	ld a, [AttackMissed]
	and a
	jr nz, .failed
	ld hl, BattleMonType1
	ld a, [hBattleTurn]
	and a
	jr z, .got_type
	ld hl, EnemyMonType1
.got_type
	ld a, BATTLE_VARS_LAST_COUNTER_MOVE_OPP
	call GetBattleVar
	and a
	jr z, .failed
	push hl
	dec a
	ld hl, Moves + MOVE_TYPE
	call GetMoveAttr
	and $3f
	ld d, a
	pop hl
	cp CURSE_T
	jr z, .failed
	call AnimateCurrentMove
	call SwitchTurn

.loop
	call BattleRandom
	and $1f
	cp UNUSED_TYPES
	jr c, .okay
	cp UNUSED_TYPES_END
	jr c, .loop
	cp TYPES_END
	jr nc, .loop
.okay
	ld [hli], a
	ld [hld], a
	push hl
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVarAddr
	and $3f
	push af
	push hl
	ld a, d
	ld [hl], a
	call BattleCheckTypeMatchup
	pop hl
	pop af
	ld [hl], a
	pop hl
	ld a, [wTypeMatchup]
	cp 10
	jr nc, .loop
	call SwitchTurn

	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	predef GetTypeName
	ld hl, TransformedTypeText
	jp StdBattleTextBox

.failed
	jp FailConversion2

BattleCommand_LockOn:
; lockon

	call CheckSubstituteOpp
	jr nz, .fail

	ld a, [AttackMissed]
	and a
	jr nz, .fail

	ld a, BATTLE_VARS_SUBSTATUS5_OPP
	call GetBattleVarAddr
	set SUBSTATUS_LOCK_ON, [hl]
	call AnimateCurrentMove

	ld hl, TookAimText
	jp StdBattleTextBox

.fail
	call AnimateFailedMove
	jp PrintDidntAffect

BattleCommand_DefrostOpponent:
; defrostopponent
; Thaw the opponent if frozen, and
; raise the user's Attack one stage.

	call AnimateCurrentMove

	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	call Defrost

	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVarAddr
	ld a, [hl]
	push hl
	push af

	ld a, EFFECT_ATTACK_UP
	ld [hl], a
	call BattleCommand_StatUp

	pop af
	pop hl
	ld [hl], a
	ret

BattleCommand_DestinyBond:
; destinybond

	ld a, BATTLE_VARS_SUBSTATUS5
	call GetBattleVarAddr
	set SUBSTATUS_DESTINY_BOND, [hl]
	call AnimateCurrentMove
	ld hl, DestinyBondEffectText
	jp StdBattleTextBox

BattleCommand_Spite:
; spite

	ld a, [AttackMissed]
	and a
	jp nz, .failed
	ld bc, PARTYMON_STRUCT_LENGTH ; ????
	ld hl, EnemyMonMoves
	ld a, [hBattleTurn]
	and a
	jr z, .got_moves
	ld hl, BattleMonMoves
.got_moves
	ld a, BATTLE_VARS_LAST_COUNTER_MOVE_OPP
	call GetBattleVar
	and a
	jr z, .failed
	cp STRUGGLE
	jr z, .failed
	ld b, a
	ld c, -1
.loop
	inc c
	ld a, [hli]
	cp b
	jr nz, .loop
	ld [wTypeMatchup], a
	dec hl
	ld b, 0
	push bc
	ld c, BattleMonPP - BattleMonMoves
	add hl, bc
	pop bc
	ld a, [hl]
	and $3f
	jr z, .failed
	push bc
	call GetMoveName
	ld b, 4 ;made spite non-random
	ld a, [hl]
	and $3f
	cp b
	jr nc, .deplete_pp
	ld b, a
.deplete_pp
	ld a, [hl]
	sub b
	ld [hl], a
	push af
	ld a, MON_PP
	call OpponentPartyAttr
	ld d, b
	pop af
	pop bc
	add hl, bc
	ld e, a
	ld a, BATTLE_VARS_SUBSTATUS5_OPP
	call GetBattleVar
	bit SUBSTATUS_TRANSFORMED, a
	jr nz, .transformed
	ld a, [hBattleTurn]
	and a
	jr nz, .not_wildmon
	ld a, [wBattleMode]
	dec a
	jr nz, .not_wildmon
	ld hl, wWildMonPP
	add hl, bc
.not_wildmon
	ld [hl], e
.transformed
	push de
	call AnimateCurrentMove
	pop de
	ld a, d
	ld [wTypeMatchup], a
	ld hl, SpiteEffectText
	jp StdBattleTextBox

.failed
	jp PrintDidntAffect

BattleCommand_FalseSwipe:
; falseswipe

	ld hl, EnemyMonHP
	ld a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld hl, BattleMonHP
.got_hp
	call GetCurrentDamage
	ld de, wCurDamage
	ld c, 2
	push hl
	call StringCmp
	pop de
	jr c, .done
	ld hl, wCurDamageFixedValue
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	sub 1 ;sets carry appropriately
	ld [hl], a
	jr nc, .okay
	dec hl
	dec [hl]
.okay
	ld hl, wCurDamageFlags
	set 7, [hl] ;fixed damage
	set 6, [hl] ;dirty
	xor a
	ld [wCriticalHitOrOHKO], a
	scf
	ret

.done
	and a
	ret

BattleCommand_HealBell:
; healbell

	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	res SUBSTATUS_NIGHTMARE, [hl]
	ld de, PartyMon1Status
	ld a, [hBattleTurn]
	and a
	jr z, .got_status
	ld de, OTPartyMon1Status
.got_status
	ld a, BATTLE_VARS_STATUS
	call GetBattleVarAddr
	xor a
	ld [hl], a
	ld h, d
	ld l, e
	ld bc, PARTYMON_STRUCT_LENGTH
	ld d, PARTY_LENGTH
.loop
	ld [hl], a
	add hl, bc
	dec d
	jr nz, .loop
	call AnimateCurrentMove

	ld hl, BellChimedText
	call StdBattleTextBox

	ld a, [hBattleTurn]
	and a
	jp z, CalcPlayerStats
	jp CalcEnemyStats

PlayFXAnimIDIfNotSemiInvulnerable:
; play animation de

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	ret nz

	; fallthrough

PlayFXAnimID:
	ld a, e
	ld [FXAnimIDLo], a
	ld a, d
	ld [FXAnimIDHi], a

	call Delay2

	jpba PlayBattleAnim

EnemyHurtItself:
	call GetCurrentDamage
	ld hl, wCurDamage
	ld a, [hli]
	ld b, a
	ld a, [hl]
	or b
	jr z, .did_no_damage

	ld a, c
	and a
	jr nz, .mimic_sub_check
	
	call IsSoundBasedMove
	jr c, .mimic_sub_check
	
	ld a, [wEnemySubStatus4]
	bit SUBSTATUS_SUBSTITUTE, a
	jp nz, SelfInflictDamageToSubstitute

.mimic_sub_check
	ld a, [hld]
	ld b, a
	ld a, [EnemyMonHP + 1]
	ld [wCurHPAnimOldHP], a
	sub b
	ld [EnemyMonHP + 1], a
	ld a, [hl]
	ld b, a
	ld a, [EnemyMonHP]
	ld [wCurHPAnimOldHP + 1], a
	sbc b
	ld [EnemyMonHP], a
	jr nc, .mimic_faint

	ld a, [wCurHPAnimOldHP + 1]
	ld [hli], a
	ld a, [wCurHPAnimOldHP]
	ld [hl], a

	xor a
	ld hl, EnemyMonHP
	ld [hli], a
	ld [hl], a

.mimic_faint
	ld hl, EnemyMonMaxHP
	ld a, [hli]
	ld [wCurHPAnimMaxHP + 1], a
	ld a, [hl]
	ld [wCurHPAnimMaxHP], a
	ld hl, EnemyMonHP
	ld a, [hli]
	ld [wCurHPAnimNewHP + 1], a
	ld a, [hl]
	ld [wCurHPAnimNewHP], a
	hlcoord 2, 2
	xor a
	ld [wWhichHPBar], a
	predef AnimateHPBar
.did_no_damage
	jp RefreshBattleHuds

PlayerHurtItself:
	call GetCurrentDamage
	ld hl, wCurDamage
	ld a, [hli]
	ld b, a
	ld a, [hl]
	or b
	jr z, .did_no_damage

	ld a, c
	and a
	jr nz, .mimic_sub_check
	
	call IsSoundBasedMove
	jr c, .mimic_sub_check

	ld a, [wPlayerSubStatus4]
	bit SUBSTATUS_SUBSTITUTE, a
	jr nz, SelfInflictDamageToSubstitute
.mimic_sub_check
	ld a, [hld]
	ld b, a
	ld a, [BattleMonHP + 1]
	ld [wCurHPAnimOldHP], a
	sub b
	ld [BattleMonHP + 1], a
	ld [wCurHPAnimNewHP], a
	ld b, [hl]
	ld a, [BattleMonHP]
	ld [wCurHPAnimOldHP + 1], a
	sbc b
	ld [BattleMonHP], a
	ld [wCurHPAnimNewHP + 1], a
	jr nc, .mimic_faint

	ld a, [wCurHPAnimOldHP + 1]
	ld [hli], a
	ld a, [wCurHPAnimOldHP]
	ld [hl], a
	xor a

	ld hl, BattleMonHP
	ld [hli], a
	ld [hl], a
	ld hl, wCurHPAnimNewHP
	ld [hli], a
	ld [hl], a

.mimic_faint
	ld hl, BattleMonMaxHP
	ld a, [hli]
	ld [wCurHPAnimMaxHP + 1], a
	ld a, [hl]
	ld [wCurHPAnimMaxHP], a
	hlcoord 10, 9
	ld a, $1
	ld [wWhichHPBar], a
	predef AnimateHPBar
.did_no_damage
	jp RefreshBattleHuds

SelfInflictDamageToSubstitute:
	ld hl, SubTookDamageText
	call StdBattleTextBox

	ld de, EnemySubstituteHP
	ld a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld de, PlayerSubstituteHP
.got_hp

	call GetCurrentDamage
	ld hl, wCurDamage
	ld a, [hli]
	and a
	jr nz, .broke

	ld a, [de]
	sub [hl]
	ld [de], a
	jr z, .broke
	jr nc, .done

.broke
	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVarAddr
	res SUBSTATUS_SUBSTITUTE, [hl]

	ld hl, SubFadedText
	call StdBattleTextBox

	call SwitchTurn
	call BattleCommand_LowerSubNoAnim
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	call z, AppearUserLowerSub
	call SwitchTurn

	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVarAddr
	cp EFFECT_MULTI_HIT
	jr z, .ok
	cp EFFECT_DOUBLE_HIT
	jr z, .ok
	cp EFFECT_TWINEEDLE
	jr z, .ok
	xor a
	ld [hl], a
.ok
	call RefreshBattleHuds
.done
	jp ZeroDamage

UpdateMoveData:
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVarAddr
	ld d, h
	ld e, l

	ld a, BATTLE_VARS_MOVE
	call GetBattleVar
	ld [wCurMove], a
	ld [wNamedObjectIndexBuffer], a

	dec a
	call GetMoveData
	call GetMoveName
	jp CopyName1

BattleCommand_SleepTarget:
; sleeptarget

	call GetOpponentItem
	ld a, b
	cp HELD_PREVENT_SLEEP
	jr nz, .not_protected_by_item

	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	ld hl, ProtectedByText
	jr .fail

.not_protected_by_item
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	ld d, h
	ld e, l
	ld a, [de]
	and SLP
	ld hl, AlreadyAsleepText
	jr nz, .fail

	ld a, [AttackMissed]
	and a
	jp nz, PrintDidntAffect

	ld a, [de]
	and a
	jr nz, .fail

	call CheckSubstituteOpp
	jr nz, .fail

	call .GetTargetAbility
	ld hl, AbilityCantSleepText
	cp ABILITY_VITAL_SPIRIT
	jr z, .fail
	cp ABILITY_INSOMNIA
	jr z, .fail
	cp ABILITY_LEAF_GUARD
	jr nz, .not_leaf_guard
	call CheckAbilityNegatesWeather
	jr z, .not_leaf_guard
	ld a, [Weather]
	cp WEATHER_SUN
	jr z, .fail
.not_leaf_guard

	push de
	call .GetUserAbility
	call AnimateCurrentMove
	ld de, ANIM_SLP
	call PlayOpponentBattleAnim
	ld b, $3

.random_loop
	call BattleRandom
	and b
	jr z, .random_loop ;1-3
	pop de
	inc a ;2-4
	ld [de], a
	call UpdateOpponentInParty
	call RefreshBattleHuds

	ld hl, FellAsleepText
	ld a, [wMoveIsAnAbility]
	and a
	jr z, .print
	ld hl, AbilitySleepText
.print
	call StdBattleTextBox

	callba UseHeldStatusHealingItem

	jp z, OpponentCantMove
	ret

.fail
	ld a, [wMoveIsAnAbility]
	and a
	ret nz
	push hl
	call AnimateFailedMove
	pop hl
	jp StdBattleTextBox

.GetUserAbility
	call GetUserAbility
	jr .GetAbility

.GetTargetAbility
	call GetTargetAbility
.GetAbility
	ld b, a
	ld a, [wd265]
	push af
	ld a, b
	ld [wd265], a
	push de
	call GetAbilityName
	pop de
	ld a, [wd265]
	ld b, a
	pop af
	ld [wd265], a
	ld a, b
	ret

BattleCommand_PoisonTarget:
; poisontarget

	call CheckSubstituteOpp
	ret nz
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	and a
	ret nz
	ld a, [TypeModifier]
	and $7f
	ret z
	call CheckIfTargetIsPoisonType
	ret z
	call GetOpponentItem
	ld a, b
	cp HELD_PREVENT_POISON
	ret z
	ld a, [EffectFailed]
	and a
	ret nz
	call SafeCheckSafeguard
	ret nz
	call GetTargetAbility
	cp ABILITY_IMMUNITY
	ret z
	cp ABILITY_LEAF_GUARD
	jr nz, .not_leaf_guard
	call CheckAbilityNegatesWeather
	jr z, .not_leaf_guard
	ld a, [Weather]
	cp WEATHER_SUN
	ret z
.not_leaf_guard

	call PoisonOpponent
	ld de, ANIM_PSN
	call PlayOpponentBattleAnim
	call RefreshBattleHuds

	ld hl, WasPoisonedText
	ld a, [wMoveIsAnAbility]
	and a
	jr z, .print
	ld hl, AbilityPoisonText
.print
	call StdBattleTextBox

	jp BattleCommand_Synchronize

BattleCommand_Poison:
; poison

	ld hl, DoesntAffectText
	ld a, [TypeModifier]
	and $7f
	jp z, .failed

	call CheckIfTargetIsPoisonType
	jp z, .failed

	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	ld b, a
	ld hl, AlreadyPoisonedText
	and 1 << PSN
	jp nz, .failed

	call GetOpponentItem
	ld a, b
	cp HELD_PREVENT_POISON
	jr nz, .do_poison
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	ld hl, ProtectedByText
	jr .failed

.do_poison
	ld hl, DidntAffect1Text
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and a
	jr nz, .failed
	call GetTargetAbility
	cp ABILITY_IMMUNITY
	jr z, .failed
	cp ABILITY_LEAF_GUARD
	jr nz, .not_leaf_guard
	call CheckAbilityNegatesWeather
	jr z, .not_leaf_guard
	ld a, [Weather]
	cp WEATHER_SUN
	jr z, .failed
.not_leaf_guard

	call CheckSubstituteOpp
	jr nz, .failed
	ld a, [AttackMissed]
	and a
	jr nz, .failed
	call .check_toxic
	jr z, .toxic

	call .apply_poison
	ld hl, WasPoisonedText
	jr .finished

.toxic
	set SEMISTATUS_TOXIC, [hl]
	xor a
	ld [de], a
	call .apply_poison

	ld hl, BadlyPoisonedText

.finished
	call StdBattleTextBox
	jp BattleCommand_Synchronize

.failed
	push hl
	call AnimateFailedMove
	pop hl
	jp StdBattleTextBox

.apply_poison
	call AnimateCurrentMove
	call PoisonOpponent
	jp RefreshBattleHuds

.check_toxic
	ld a, BATTLE_VARS_SEMISTATUS_OPP
	call GetBattleVarAddr
	ld a, [hBattleTurn]
	and a
	ld de, EnemyToxicCount
	jr z, .ok
	ld de, PlayerToxicCount
.ok
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_TOXIC
	ret

CheckIfTargetIsPoisonType:
	ld de, EnemyMonType1
	ld a, [hBattleTurn]
	and a
	jr z, .ok
	ld de, BattleMonType1
.ok
	ld a, [de]
	inc de
	cp POISON
	ret z
	ld a, [de]
	cp POISON
	ret

PoisonOpponent:
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	set PSN, [hl]
	jp UpdateOpponentInParty

BattleCommand_DrainTarget:
; draintarget
	call SapHealth
	ld hl, SuckedHealthText
	jp nz, StdBattleTextBox
	jr BattleCommand_LiquidOozeText

BattleCommand_EatDream:
; eatdream
	call SapHealth
	ld hl, DreamEatenText
	jp nz, StdBattleTextBox
BattleCommand_LiquidOozeText:
	ld hl, LiquidOozeText
	jp StdBattleTextBox

SapHealth:
	call GetCurrentDamage
	ld hl, wCurDamage
	ld a, [hli]
	srl a ;halve damage
	ld [hDividend], a
	ld b, a
	ld a, [hl]
	rr a
	ld [hDividend + 1], a

	ld a, BATTLE_VARS_MOVE
	call GetBattleVar
	cp DRAININGKISS
	ld a, [hDividend + 1]
	jr nz, .notkiss
	srl b
	rr a
	ld hl, hDividend + 1
	add a, [hl]
	ld [hDividend + 1], a
	ld a, b
	dec hl
	add a, [hl]
	ld [hDividend], a
	ld a, [hDividend + 1]
.notkiss
	or b
	jr nz, .ok1
	ld a, $1
	ld [hDividend + 1], a ;holds half of damage deal, min 1
.ok1
	ld hl, BattleMonHP
	ld de, BattleMonMaxHP
	ld a, [hBattleTurn]
	and a
	jr z, .battlemonhp
	ld hl, EnemyMonHP
	ld de, EnemyMonMaxHP
.battlemonhp
	ld bc, wCurHPAnimOldHP + 1
	ld a, [hli]
	ld [bc], a
	ld a, [hl]
	dec bc
	ld [bc], a ;place current HP in wCurHPAnimOldHP
	ld a, [de] ;place max hp into wCurHPAnimNewHP
	dec bc
	ld [bc], a
	inc de
	ld a, [de]
	dec bc
	ld [bc], a
	call GetTargetAbility
	cp ABILITY_LIQUID_OOZE
	push af
	jr z, .subtract
	ld a, [hDividend + 1]
	ld b, [hl]
	add b
	ld [hld], a
	ld [wCurHPAnimNewHP], a
	ld a, [hDividend]
	ld b, [hl]
	adc b
	ld [hli], a
	ld [wCurHPAnimNewHP + 1], a
	jr c, .max_hp
	ld a, [hld]
	ld b, a
	ld a, [de]
	dec de
	sub b
	ld a, [hli]
	ld b, a
	ld a, [de]
	inc de
	sbc b
	jr nc, .okay3
.max_hp
	ld a, [de]
	ld [hld], a
	ld [wCurHPAnimNewHP], a
	dec de
	ld a, [de]
	ld [hli], a
	ld [wCurHPAnimNewHP + 1], a
	inc de
	jr .okay3

.subtract
	ld a, [hDividend + 1]
	ld b, a
	ld a, [hl]
	sub b
	ld [hld], a
	ld [wCurHPAnimNewHP], a
	ld a, [hDividend]
	ld b, a
	ld a, [hl]
	sbc b
	ld [hli], a
	ld [wCurHPAnimNewHP + 1], a
	jr nc, .okay3
	; RIP
	xor a
	ld [hld], a
	ld [hl], a
	ld [wCurHPAnimNewHP], a
	ld [wCurHPAnimNewHP + 1], a
.okay3
	ld a, [hBattleTurn]
	and a
	hlcoord 10, 9
	ld a, $1
	jr z, .hp_bar
	hlcoord 2, 2
	xor a
.hp_bar
	ld [wWhichHPBar], a
	predef AnimateHPBar
	call RefreshBattleHuds
	call UpdateBattleMonInParty
	pop af ; restore the results from the Liquid Ooze check
	ret

BattleCommand_BurnTarget:
; burntarget

	xor a
	ld [wNumHits], a
	call CheckSubstituteOpp
	ret nz
	ld a, [TypeModifier]
	and $7f
	ret z
	ld hl, EnemyMonType1
	ld a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, BattleMonType1
.ok
	ld a, [hli]
	cp FIRE ; Don't burn a Fire-type
	ret z
	ld a, [hl]
	cp FIRE ; Don't burn a Fire-type
	ret z
	call GetOpponentItem
	ld a, b
	cp HELD_PREVENT_BURN
	ret z
	call GetTargetAbility
	cp ABILITY_WATER_VEIL
	ret z
	cp ABILITY_LEAF_GUARD
	jr nz, .not_leaf_guard
	call CheckAbilityNegatesWeather
	jr z, .not_leaf_guard
	ld a, [Weather]
	cp WEATHER_SUN
	ret z
.not_leaf_guard
	ld a, [EffectFailed]
	and a
	ret nz
	call SafeCheckSafeguard
	ret nz
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	ld a, [hl]
	and a
	ret nz
	set BRN, [hl]
	call UpdateOpponentInParty
	callba ApplyBrnEffectOnAttack
	ld de, ANIM_BRN
	call PlayOpponentBattleAnim
	call RefreshBattleHuds

	ld hl, WasBurnedText
	ld a, [wMoveIsAnAbility]
	and a
	jr z, .print
	ld hl, FlameBodyBurnedText
.print
	call StdBattleTextBox

BattleCommand_Synchronize:
	callba UseHeldStatusHealingItem
	ret nz
	; Only proceed if the statused target has Synchronize...
	call GetTargetAbility
	cp ABILITY_SYNCHRONIZE
	ret nz
	; ... the user isn't statused...
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and a
	ret nz
	; ... the user hasn't just fainted...
	ld a, [hBattleTurn]
	and a
	ld hl, BattleMonHP
	jr z, .got_hp
	ld hl, EnemyMonHP
.got_hp
	ld a, [hli]
	or [hl]
	ret z
	; ... and the target's status is either paralysis, poisoning, or burn.
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and (1 << PAR) | (1 << PSN) | (1 << BRN)
	ret z
	; Don't activate if, for whatever reason, the target has multiple statuses.
	; This should never happen.
	; This routine also gets the battle command that confers the new status
	; onto the user.
	ld hl, .Pointers
	ld e, 3
	call IsInArray
	ret nc
	; Tell the battle command that it's being called by an ability.
	ld a, ABILITY_SYNCHRONIZE
	ld [wMoveIsAnAbility], a
	ld [wd265], a
	call GetAbilityName
	call SwitchTurn
	call CallLocalPointer_AfterIsInArray
	xor a
	ld [wMoveIsAnAbility], a
	jp SwitchTurn

.Pointers:
	dbw (1 << PAR), BattleCommand_ParalyzeTarget
	dbw (1 << BRN), BattleCommand_BurnTarget
	dbw (1 << PSN), BattleCommand_PoisonTarget
	db $ff

Defrost:
	ld a, [wMoveIsAnAbility]
	and a
	ret nz

	bit FRZ, [hl]
	ret z
	ld [hl], 0

	ld a, [hBattleTurn]
	and a
	ld a, [CurOTMon]
	ld hl, OTPartyMon1Status
	jr z, .ok
	ld hl, PartyMon1Status
	ld a, [CurBattleMon]
.ok

	call GetPartyLocation
	xor a
	ld [hl], a
	call UpdateOpponentInParty

	ld hl, DefrostedOpponentText
	jp StdBattleTextBox

BattleCommand_FreezeTarget:
; freezetarget

	xor a
	ld [wNumHits], a
	call CheckSubstituteOpp
	ret nz
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	and a
	ret nz
	ld a, [TypeModifier]
	and $7f
	ret z
	call CheckAbilityNegatesWeather
	jr z, .skip_sun
	ld a, [Weather]
	cp WEATHER_SUN
	ret z
.skip_sun
	ld hl, EnemyMonType1
	ld a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, BattleMonType1
.ok
	ld a, [hli]
	cp ICE ; Don't freeze an ice type
	ret z
	ld a, [hl]
	cp ICE ; Don't freeze an ice type
	ret z
	call GetOpponentItem
	ld a, b
	cp HELD_PREVENT_FREEZE
	ret z
	ld a, [EffectFailed]
	and a
	ret nz
	call SafeCheckSafeguard
	ret nz
	call GetTargetAbility
	cp ABILITY_MAGMA_ARMOR
	ret z
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	set FRZ, [hl]
	call UpdateOpponentInParty
	ld de, ANIM_FRZ
	call PlayOpponentBattleAnim
	call RefreshBattleHuds

	ld hl, WasFrozenText
	call StdBattleTextBox

	callba UseHeldStatusHealingItem
	ret nz

	call OpponentCantMove
	call EndRechargeOpp
	ld hl, wEnemyJustGotFrozen
	ld a, [hBattleTurn]
	and a
	jr z, .finish
	ld hl, wPlayerJustGotFrozen
.finish
	ld [hl], $1
	ret

BattleCommand_ParalyzeTarget:
; paralyzetarget

	xor a
	ld [wNumHits], a
	call CheckSubstituteOpp
	ret nz
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	and a
	ret nz
	ld a, [TypeModifier]
	and $7f
	ret z
	call GetOpponentItem
	ld a, b
	cp HELD_PREVENT_PARALYZE
	ret z
	call GetTargetAbility
	cp ABILITY_LIMBER
	ret z
	cp ABILITY_LEAF_GUARD
	jr nz, .not_leaf_guard
	call CheckAbilityNegatesWeather
	jr z, .not_leaf_guard
	ld a, [Weather]
	cp WEATHER_SUN
	ret z
.not_leaf_guard
	ld a, [EffectFailed]
	and a
	ret nz
	call SafeCheckSafeguard
	ret nz
	ld hl, BattleMonType
	ld a, [hBattleTurn]
	and a
	jr nz, .got_types
	ld hl, EnemyMonType
.got_types
	ld a, [hli]
	cp ELECTRIC
	ret z
	ld a, [hl]
	cp ELECTRIC
	ret z
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	set PAR, [hl]
	call UpdateOpponentInParty
	callba ApplyPrzEffectOnSpeed
	ld de, ANIM_PAR
	call PlayOpponentBattleAnim
	call RefreshBattleHuds
	call PrintParalyze
	jp BattleCommand_Synchronize

BattleCommand_AttackUp:
; attackup
	ln b, 0, ATTACK
	jr BattleCommand_StatUp

BattleCommand_DefenseUp:
; defenseup
	ln b, 0, DEFENSE
	jr BattleCommand_StatUp

BattleCommand_SpeedUp:
; speedup
	ln b, 0, SPEED
	jr BattleCommand_StatUp

BattleCommand_SpecialAttackUp:
; specialattackup
	ln b, 0, SP_ATTACK
	jr BattleCommand_StatUp

BattleCommand_SpecialDefenseUp:
; specialdefenseup
	ln b, 0, SP_DEFENSE
	jr BattleCommand_StatUp

BattleCommand_AccuracyUp:
; accuracyup
	ln b, 0, ACCURACY
	jr BattleCommand_StatUp

BattleCommand_EvasionUp:
; evasionup
	ln b, 0, EVASION
	jr BattleCommand_StatUp

BattleCommand_AttackUp2:
; attackup2
	ln b, 1, ATTACK
	jr BattleCommand_StatUp

BattleCommand_DefenseUp2:
; defenseup2
	ln b, 1, DEFENSE
	jr BattleCommand_StatUp

BattleCommand_SpeedUp2:
; speedup2
	ln b, 1, SPEED
	jr BattleCommand_StatUp

BattleCommand_SpecialAttackUp2:
; specialattackup2
	ln b, 1, SP_ATTACK
	jr BattleCommand_StatUp

BattleCommand_SpecialDefenseUp2:
; specialdefenseup2
	ln b, 1, SP_DEFENSE
	jr BattleCommand_StatUp

BattleCommand_AccuracyUp2:
; accuracyup2
	ln b, 1, ACCURACY
	jr BattleCommand_StatUp

BattleCommand_EvasionUp2:
; evasionup2
	ln b, 1, EVASION
BattleCommand_StatUp:
; statup
	ld hl, DoStatUp
	ld de, DoStatDown
	jp ContraryCheckUser

DoStatUp:
	call CheckIfStatCanBeRaised
	ld a, [FailedMessage]
	and a
	ret nz
	jp StatUpAnimation

CheckIfStatCanBeRaised:
	call GetUserAbility
	cp ABILITY_SIMPLE
	jr nz, .not_simple
	bit 4, b
	set 4, b
	jr z, .not_simple
	set 5, b
.not_simple
	ld a, b
	ld [LoweredStat], a
	ld hl, PlayerStatLevels
	ld a, [hBattleTurn]
	and a
	jr z, .got_stat_levels
	ld hl, EnemyStatLevels
.got_stat_levels
	ld a, [AttackMissed]
	and a
	jp nz, .stat_raise_failed
	ld a, [EffectFailed]
	and a
	jp nz, .stat_raise_failed
	ld a, [RaisedStat]
	and $f
	ld c, a
	ld b, 0
	add hl, bc
	ld b, [hl]
	inc b
	ld a, 13
	cp b
	jp c, .cant_raise_stat
	push bc
	ld a, [RaisedStat]
	and $f0
	jr z, .got_num_stages
	swap a
	ld c, a
.stat_up_stage_loop
	inc b
	ld a, 13
	cp b
	jr c, .not_maxed
	dec c
	jr nz, .stat_up_stage_loop
	jr .got_num_stages

.not_maxed
	ld b, a
.got_num_stages
	ld [hl], b
	pop bc
	push hl
	ld a, c
	cp $5
	jr nc, .done_calcing_stats
	ld hl, BattleMonStats
	ld de, PlayerStats
	ld a, [hBattleTurn]
	and a
	jr z, .got_stats_pointer
	ld hl, EnemyMonStats
	ld de, EnemyStats
.got_stats_pointer
	push bc
	sla c
	ld b, 0
	add hl, bc
	ld a, c
	add e
	ld e, a
	jr nc, .no_carry
	inc d
.no_carry
	pop bc
	ld a, [hl]
	cp 16 ;limits in-battle stats to 4,095 (the legitimate maximum is 2,432 plus badge boosts, so this is purely a failsafe)
	jp nc, .stats_already_max
.not_already_max
	ld a, [hBattleTurn]
	and a
	jr z, .calc_player_stats
	call CalcEnemyStats
	jr .done_calcing_stats

.calc_player_stats
	call CalcPlayerStats
.done_calcing_stats
	pop hl
	xor a
	ld [FailedMessage], a
	ret

.stats_already_max
	pop hl
	dec [hl]
	; fallthrough

.cant_raise_stat
	ld a, $2
	ld [FailedMessage], a
	ld a, $1
	ld [AttackMissed], a
	ret

.stat_raise_failed
	ld a, $1
	ld [FailedMessage], a
	ret

StatUpAnimation:
	ld hl, wPlayerMinimized
	ld a, [hBattleTurn]
	and a
	jr z, .do_player
	ld hl, wEnemyMinimized
.do_player
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp MINIMIZE
	ret nz

	ld [hl], $1
	call CheckBattleScene
	ret nc

	xor a
	ld [hBGMapMode], a
	call BattleCommand_LowerSubNoAnim
	jp BattleCommand_MoveDelay

ContraryCheckUser:
	call GetUserAbility
	jr ContraryCheck

ContraryCheckOpp:
	call GetTargetAbility
ContraryCheck:
	cp ABILITY_CONTRARY
	jp nz, _hl_
	call SwitchTurn
	call _de_
	jp SwitchTurn

BattleCommand_AttackDown:
; attackdown
	ln b, 0, ATTACK
	jr BattleCommand_StatDown

BattleCommand_DefenseDown:
; defensedown
	ln b, 0, DEFENSE
	jr BattleCommand_StatDown

BattleCommand_SpeedDown:
; speeddown
	ln b, 0, SPEED
	jr BattleCommand_StatDown

BattleCommand_SpecialAttackDown:
; specialattackdown
	ln b, 0, SP_ATTACK
	jr BattleCommand_StatDown

BattleCommand_SpecialDefenseDown:
; specialdefensedown
	ln b, 0, SP_DEFENSE
	jr BattleCommand_StatDown

BattleCommand_AccuracyDown:
; accuracydown
	ln b, 0, ACCURACY
	jr BattleCommand_StatDown

BattleCommand_EvasionDown:
; evasiondown
	ln b, 0, EVASION
	jr BattleCommand_StatDown

BattleCommand_AttackDown2:
; attackdown2
	ln b, 1, ATTACK
	jr BattleCommand_StatDown

BattleCommand_DefenseDown2:
; defensedown2
	ln b, 1, DEFENSE
	jr BattleCommand_StatDown

BattleCommand_SpeedDown2:
; speeddown2
	ln b, 1, SPEED
	jr BattleCommand_StatDown

BattleCommand_SpecialAttackDown2:
; specialattackdown2
	ln b, 1, SP_ATTACK
	jr BattleCommand_StatDown

BattleCommand_SpecialDefenseDown2:
; specialdefensedown2
	ln b, 1, SP_DEFENSE
	jr BattleCommand_StatDown

BattleCommand_AccuracyDown2:
; accuracydown2
	ln b, 1, ACCURACY
	jr BattleCommand_StatDown

BattleCommand_EvasionDown2:
; evasiondown2
	ln b, 1, EVASION

BattleCommand_StatDown:
; statdown
	ld hl, DoStatDown
	ld de, DoStatUp
	jp ContraryCheckOpp

DoStatDown:
	call GetTargetAbility
	cp ABILITY_SIMPLE
	jr nz, .not_simple
	bit 4, b
	set 4, b
	jr z, .not_simple
	set 5, b
.not_simple
	ld a, b
	ld [LoweredStat], a
	and $f
	jr z, .hypercutter
	cp ACCURACY
	jr nz, .no_check
	call KeenEyeCheck
	jr .ability_check

.hypercutter
	call HyperCutterCheck
.ability_check
	jp z, StatDown_AbilityFail
.no_check
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp CURSE
	jr z, .curse

	call WhiteSmokeCheck
	jp z, StatDown_AbilityFail

	call CheckMist
	jp z, StatDown_MistFail

.curse
	ld hl, EnemyStatLevels
	ld a, [hBattleTurn]
	and a
	jr z, .GetStatLevel
	ld hl, PlayerStatLevels

.GetStatLevel
; Attempt to lower the stat.
	ld a, [LoweredStat]
	and $f
	ld c, a
	ld b, 0
	add hl, bc
	ld b, [hl]
	dec b
	jp z, .CantLower

; Sharply lower the stat if applicable.
	ld a, [LoweredStat]
	and $f0
	jr z, .DidntMiss
	swap a
.lower_loop
	dec b
	jr z, .min_stat
	dec a
	jr nz, .lower_loop
	jr .DidntMiss

.min_stat
	inc b
.DidntMiss

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp CURSE
	jr z, .curse2
	call CheckSubstituteOpp
	jr nz, StatDownFailed

	ld a, [AttackMissed]
	and a
	jr nz, StatDownFailed

	ld a, [EffectFailed]
	and a
	jr nz, StatDownFailed

	call CheckHiddenOpponent
	jr nz, StatDownFailed
.curse2

; Accuracy/Evasion reduction don't involve stats.
	ld [hl], b
	ld a, c
	cp ACCURACY
	jr nc, .Hit

	push hl
	ld hl, EnemyMonAttack + 1
	ld de, EnemyStats
	ld a, [hBattleTurn]
	and a
	jr z, .do_enemy
	ld hl, BattleMonAttack + 1
	ld de, PlayerStats
.do_enemy
	call TryLowerStat
	pop hl
	jr z, .CouldntLower

.Hit
	xor a
	ld [FailedMessage], a
	ret

.CouldntLower
	inc [hl]
.CantLower
	ld a, 3
	ld [FailedMessage], a
	ld a, 1
	ld [AttackMissed], a
	ret

HyperCutterCheck:
	call GetTargetAbility
	cp ABILITY_HYPER_CUTTER
	ret

KeenEyeCheck:
	call GetTargetAbility
	cp ABILITY_KEEN_EYE
	ret

WhiteSmokeCheck:
	call GetTargetAbility
	cp ABILITY_WHITE_SMOKE
	ret z
	cp ABILITY_CLEAR_BODY
	ret

StatDown_AbilityFail:
	ld a, 4
	ld [FailedMessage], a
	ld a, 1
	ld [AttackMissed], a
	ret

StatDown_MistFail:
	ld a, 2
	ld [FailedMessage], a
	dec a
	ld [AttackMissed], a
	ret

StatDownFailed:
	ld a, 1
	ld [FailedMessage], a
	ld [AttackMissed], a
	ret

CheckMist:
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_ATTACK_DOWN
	jr c, .dont_check_mist
	cp EFFECT_EVASION_DOWN + 1
	jr c, .check_mist
	cp EFFECT_ATTACK_DOWN_2
	jr c, .dont_check_mist
	cp EFFECT_EVASION_DOWN_2 + 1
	jr c, .check_mist
	cp EFFECT_ATTACK_DOWN_HIT
	jr c, .dont_check_mist
	cp EFFECT_EVASION_DOWN_HIT + 1
	jr c, .check_mist
.dont_check_mist
	ld a, 1
	and a
	ret

.check_mist
	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVar
	and (1 << SUBSTATUS_MIST)
	cp (1 << SUBSTATUS_MIST)
	ret

BattleCommand_StatUpMessage:
	ld a, [FailedMessage]
	and a
	ret nz
	ld hl, DoStatUpMessage
	ld de, DoStatDownMessage
	jp ContraryCheckUser

DoStatUpMessage:
	ld a, [LoweredStat]
	and $f
	ld b, a
	inc b
	call GetStatName
	ld hl, .stat
	jp BattleTextBox

.stat
	text_far UnknownText_0x1c0cc6
	start_asm
	ld hl, .up
	ld a, [LoweredStat]
	and $f0
	ret z
	swap a
	dec a
	ld hl, .wayup
	ret z
	ld hl, .drastically_up
	ret

.drastically_up
	text_jump Text_RoseDrastically

.wayup
	text_jump UnknownText_0x1c0cd0

.up
	text_jump UnknownText_0x1c0ce0

BattleCommand_StatDownMessage:
	ld a, [FailedMessage]
	and a
	ret nz
	ld hl, DoStatDownMessage
	ld de, DoStatUpMessage
	jp ContraryCheckOpp

DoStatDownMessage:
	call .Message
	ld a, [hBattleTurn]
	ld hl, wBattleTurnTemp
	cp [hl]
	ret nz
	call GetTargetAbility_IgnoreMoldBreaker
	cp ABILITY_COMPETITIVE
	ret nz
	ld [wMoveIsAnAbility], a
	call SwitchTurn
	call BattleCommand_SpecialAttackUp2
	call BattleCommand_StatUpMessage
	xor a
	ld [wMoveIsAnAbility], a
	jp SwitchTurn

.Message
	ld a, [LoweredStat]
	and $f
	ld b, a
	inc b
	call GetStatName
	ld hl, .stat
	ld a, [wMoveIsAnAbility]
	and a
	jp z, BattleTextBox
	cp ABILITY_MOODY
	jp z, BattleTextBox
	call GetUserAbility
	ld [wd265], a
	call GetAbilityName
	ld hl, AbilityStatDropText
	jp StdBattleTextBox

.stat
	text_far UnknownText_0x1c0ceb
	start_asm
	ld hl, .fell
	ld a, [LoweredStat]
	and $f0
	ret z
	swap a
	dec a
	ld hl, .sharplyfell
	ret z
	ld hl, .severelyfell
	ret

.severelyfell
	text_jump Text_SeverelyFell

.sharplyfell
	text_jump UnknownText_0x1c0cf5
.fell
	text_jump UnknownText_0x1c0d06

TryLowerStat:
; Lower stat c from stat struct hl (buffer de).

	push bc
	sla c
	ld b, 0
	add hl, bc
	; add de, c
	ld a, c
	add e
	ld e, a
	jr nc, .no_carry
	inc d
.no_carry
	pop bc

; The lowest possible stat is 1.
	ld a, [hld]
	sub 1
	jr nz, .not_min
	ld a, [hl]
	and a
	ret z

.not_min
	ld a, [hBattleTurn]
	and a
	jr z, .Player

	call SwitchTurn
	call CalcPlayerStats
	call SwitchTurn
	jr .end

.Player
	call SwitchTurn
	call CalcEnemyStats
	call SwitchTurn
.end
	ld a, 1
	and a
	ret

BattleCommand_StatUpFailText:
; statupfailtext
	ld a, [FailedMessage]
	and a
	ret z
	ld hl, DoStatUpFailText
	ld de, DoStatDownFailText
	jp ContraryCheckUser

DoStatUpFailText:
	call BattleCommand_MoveDelay
	ld a, [wMoveIsAnAbility]
	and a
	ret nz
	ld a, [FailedMessage]
	dec a
	jp z, TryPrintButItFailed
	ld a, [LoweredStat]
	and $f
	ld b, a
	inc b
	call GetStatName
	ld hl, WontRiseAnymoreText
	jp StdBattleTextBox

BattleCommand_StatDownFailText:
; statdownfailtext
	ld a, [FailedMessage]
	and a
	ret z ; 0
	ld hl, DoStatDownFailText
	ld de, DoStatUpFailText
	jp ContraryCheckOpp

DoStatDownFailText:
	call BattleCommand_MoveDelay
	ld a, [FailedMessage]
	cp 4
	jr z, .HyperCutterCheck
	ld a, [wMoveIsAnAbility]
	and a
	ret nz
	ld a, [FailedMessage]
	dec a
	jp z, TryPrintButItFailed ; 1
	dec a
	ld hl, ProtectedByMistText
	jp z, StdBattleTextBox ; 2
	dec a
	jr nz, .HyperCutterCheck ; 4
	ld a, [LoweredStat]
	and $f
	ld b, a
	inc b
	call GetStatName
	ld hl, WontDropAnymoreText
	jp StdBattleTextBox

.HyperCutterCheck
	call GetTargetAbility
	ld [wd265], a
	call GetAbilityName
	ld a, [LoweredStat]
	and $f
	ld b, a
	inc b
	call GetStatName
	ld hl, AbilityPreventsStatDownsText
	call StdBattleTextBox
	xor a
	ret

GetStatName:
	ld hl, .names
	ld c, "@"
.CheckName
	dec b
	jr z, .Copy
.GetName
	ld a, [hli]
	cp c
	jr z, .CheckName
	jr .GetName

.Copy
	ld de, wStringBuffer2
	ld bc, wStringBuffer3 - wStringBuffer2
	rst CopyBytes
	ret

.names
	db "Attack@"
	db "Defense@"
	db "Speed@"
	db "Spcl.Atk@"
	db "Spcl.Def@"
	db "Accuracy@"
	db "Evasion@"
	db "Ability@"

StatLevelMultipliers:
	db 1, 4 ; 0.25x
	db 2, 7 ; 0.29x
	db 1, 3 ; 0.33x
	db 2, 5 ; 0.40x
	db 1, 2 ; 0.50x
	db 2, 3 ; 0.67x
	db 1, 1 ; 1.00x
	db 3, 2 ; 1.50x
	db 2, 1 ; 2.00x
	db 5, 2 ; 2.50x
	db 3, 1 ; 3.00x
	db 7, 2 ; 3.50x
	db 4, 1 ; 4.00x

BattleCommand_AllStatsUp:
; allstatsup

; Attack
	call ResetMiss
	call BattleCommand_AttackUp
	call BattleCommand_StatUpMessage

; Defense
	call ResetMiss
	call BattleCommand_DefenseUp
	call BattleCommand_StatUpMessage

; Speed
	call ResetMiss
	call BattleCommand_SpeedUp
	call BattleCommand_StatUpMessage

; Special Attack
	call ResetMiss
	call BattleCommand_SpecialAttackUp
	call BattleCommand_StatUpMessage

; Special Defense
	call ResetMiss
	call BattleCommand_SpecialDefenseUp
	jp BattleCommand_StatUpMessage

ResetMiss:
	xor a
	ld [AttackMissed], a
	ret

BattleCommand_TriStatusChance:
; tristatuschance

	call BattleCommand_EffectChance

; 1/3 chance of each status
.loop
	call BattleRandom
	and 3
	jr z, .loop
; jump
	dec a
	jumptable TriAttackStatusPtrs
	ret

BattleCommand_FreezeBurnStatusChance:
; freezeburnchance
	call BattleCommand_EffectChance
	call BattleRandom
	and 1
	jumptable FreezeBurnStatusPtrs
	ret

TriAttackStatusPtrs:
	dw BattleCommand_ParalyzeTarget ; paralyze
FreezeBurnStatusPtrs:
	dw BattleCommand_FreezeTarget ; freeze
	dw BattleCommand_BurnTarget ; burn

BattleCommand_Curl:
; curl
	ld a, BATTLE_VARS_SUBSTATUS2
	call GetBattleVarAddr
	set SUBSTATUS_CURLED, [hl]
	ret

BattleCommand_LowerSubNoAnim:
	ld hl, DropPlayerSub
	ld a, [hBattleTurn]
	and a
	jr z, .playerTurn
	ld hl, DropEnemySub
.playerTurn
	xor a
	ld [hBGMapMode], a
	ld a, BANK(BattleCore)
	call FarCall_hl
	jp ApplyTilemapInVBlank

CalcPlayerStats:
	ld hl, PlayerAtkLevel
	ld de, PlayerStats
	ld bc, BattleMonAttack

	ld a, 5
	call CalcStats
	callba BadgeStatBoosts
	call SwitchTurn
	callba ApplyPrzEffectOnSpeed
	callba ApplyBrnEffectOnAttack
	jp SwitchTurn

CalcEnemyStats:
	ld hl, EnemyAtkLevel
	ld de, EnemyStats
	ld bc, EnemyMonAttack

	ld a, 5
	call CalcStats
	call SwitchTurn
	callba ApplyPrzEffectOnSpeed
	callba ApplyBrnEffectOnAttack
	jp SwitchTurn

CalcStats:
.loop
	push af
	ld a, [hli]
	push hl
	push bc

	ld c, a
	dec c
	ld b, 0
	ld hl, StatLevelMultipliers
	add hl, bc
	add hl, bc

	xor a
	ld [hMultiplicand + 0], a
	ld a, [de]
	ld [hMultiplicand + 1], a
	inc de
	ld a, [de]
	ld [hMultiplicand + 2], a
	inc de

	ld a, [hli]
	ld [hMultiplier], a
	predef Multiply

	ld a, [hl]
	ld [hDivisor], a
	ld b, 4
	predef Divide

	ld a, [hQuotient + 1]
	ld b, a
	ld a, [hQuotient + 2]
	or b
	jr nz, .check_maxed_out

	; purely a failsafe, as the lowest possible value this calculation would ever return is 1.25, floored to 1
	ld a, 1
	ld [hQuotient + 2], a
	jr .not_maxed_out

.check_maxed_out
	; limits in-battle stats to 4,095. This is purely a failsafe, as the legal maximum would be 2,432 plus badge boosts.
	ld a, [hQuotient + 1]
	cp 16
	jr c, .not_maxed_out
	ld a, 15
	ld [hQuotient + 1], a
	ld a, $ff
	ld [hQuotient + 2], a

.not_maxed_out
	pop bc
	ld a, [hQuotient + 1]
	ld [bc], a
	inc bc
	ld a, [hQuotient + 2]
	ld [bc], a
	inc bc
	pop hl
	pop af
	dec a
	jr nz, .loop

	ret

BattleCommand_CheckRampage:
; checkrampage

	ld de, PlayerRolloutCount
	ld a, [hBattleTurn]
	and a
	jr z, .player
	ld de, EnemyRolloutCount
.player
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	bit SUBSTATUS_RAMPAGE, [hl]
	ret z
	ld a, [de]
	dec a
	ld [de], a
	jr nz, .continue_rampage

	res SUBSTATUS_RAMPAGE, [hl]
	call SwitchTurn
	call SafeCheckSafeguard
	push af
	call SwitchTurn
	pop af
	jr nz, .continue_rampage

	call GetUserAbility ; preserves hl
	cp ABILITY_OWN_TEMPO
	jr z, .continue_rampage

	set SUBSTATUS_CONFUSED, [hl]
	call BattleRandom
	and 1
	add a, 2
	inc de ; ConfuseCount
	ld [de], a
.continue_rampage
	ld b, rampage_command
	jp SkipToBattleCommand

BattleCommand_Rampage:
; rampage

; No rampage during Sleep Talk.
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and SLP
	ret nz

	ld de, PlayerRolloutCount
	ld a, [hBattleTurn]
	and a
	jr z, .ok
	ld de, EnemyRolloutCount
.ok
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	set SUBSTATUS_RAMPAGE, [hl]
; Rampage for 1 or 2 more turns
	call BattleRandom
	and 1
	inc a
	ld [de], a
	ld a, 1
	ld [wSomeoneIsRampaging], a
	ret

BattleCommand_Teleport:
; teleport

	ld a, [wBattleType]
	cp BATTLETYPE_SHINY
	jr z, .failed
	cp BATTLETYPE_TRAP
	jr z, .failed
	cp BATTLETYPE_CELEBI
	jr z, .failed
	cp BATTLETYPE_SUICUNE
	jr z, .failed

	ld a, [hBattleTurn]
	and a
	ld hl, CheckEnemyArenaTrap
	jr z, .check_ability
	ld hl, CheckPlayerArenaTrap
.check_ability
	ld a, BANK(CheckPlayerArenaTrap)
	call FarCall_hl
	jr c, .failed

	ld a, BATTLE_VARS_SUBSTATUS5_OPP
	call GetBattleVar
	bit SUBSTATUS_CANT_RUN, a
	jr nz, .failed

	ld a, BATTLE_VARS_SUBSTATUS2
	call GetBattleVar
	bit SUBSTATUS_FINAL_CHANCE, a
	jr nz, .failed
; Only need to check these next things if it's your turn
	ld a, [hBattleTurn]
	and a
	jr nz, .enemy_turn
; Can't teleport from a trainer battle
	ld a, [wBattleMode]
	dec a
	jr nz, .failed
; If your level is greater than the opponent's, you run without fail.
	ld a, [CurPartyLevel]
	ld b, a
	ld a, [BattleMonLevel]
	cp b
	jr nc, .run_away
; Generate a number between 0 and (YourLevel + TheirLevel).
	add b
	ld c, a
	inc c
.loop_player
	call BattleRandom
	cp c
	jr nc, .loop_player
; If that number is greater than 4 times your level, run away.
	srl b
	srl b
	cp b
	jr nc, .run_away

.failed
	call AnimateFailedMove
	jp PrintButItFailed

.enemy_turn
	ld a, [wBattleMode]
	dec a
	jr nz, .failed
	ld a, [BattleMonLevel]
	ld b, a
	ld a, [CurPartyLevel]
	cp b
	jr nc, .run_away
	add b
	ld c, a
	inc c
.loop_enemy
	call BattleRandom
	cp c
	jr nc, .loop_enemy
	srl b
	srl b
	cp b
	jr nc, .run_away
.run_away
	call UpdateBattleMonInParty
	xor a
	ld [wNumHits], a
	inc a
	ld [wForcedSwitch], a
	ld [wBattleAnimParam], a
	call SetBattleDraw
	call BattleCommand_LowerSub
	call LoadMoveAnim
	ld c, 20
	call DelayFrames
	call SetBattleDraw

	ld hl, FledFromBattleText
	jp StdBattleTextBox

SetBattleDraw:
	ld a, [wBattleResult]
	and $c0
	or $2
	ld [wBattleResult], a
	ret

BattleCommand_ForceSwitch:
; forceswitch
	call GetTargetAbility
	cp ABILITY_SUCTION_CUPS
	jr z, .missed
	ld a, [wBattleType]
	cp BATTLETYPE_SHINY
	jr z, .missed
	cp BATTLETYPE_TRAP
	jr z, .missed
	cp BATTLETYPE_CELEBI
	jr z, .missed
	cp BATTLETYPE_SUICUNE
	jr z, .missed
	ld a, [hBattleTurn]
	and a
	jp nz, .force_player_switch
	ld a, [AttackMissed]
	and a
	jr nz, .missed
	ld a, [wBattleMode]
	dec a
	jr nz, .trainer
	ld a, [CurPartyLevel]
	ld b, a
	ld a, [BattleMonLevel]
	cp b
	jr nc, .wild_force_flee
	add b
	ld c, a
	inc c
.random_loop_wild
	call BattleRandom
	cp c
	jr nc, .random_loop_wild
	srl b
	srl b
	cp b
	jr nc, .wild_force_flee
.missed
	jp .fail

.wild_force_flee
	call UpdateBattleMonInParty
	xor a
	ld [wNumHits], a
	inc a
	ld [wForcedSwitch], a
	call SetBattleDraw
	ld a, [wPlayerMoveStructAnimation]
	jp .succeed

.trainer
	call FindAliveEnemyMons
	jr c, .switch_fail
	ld a, [wEnemyGoesFirst]
	and a
	jr z, .switch_fail
	call UpdateEnemyMonInParty
	ld a, $1
	ld [wBattleAnimParam], a
	call AnimateCurrentMove
	ld c, $14
	call DelayFrames
	hlcoord 1, 0
	lb bc, 4, 10
	call ClearBox
	ld c, 20
	call DelayFrames
	ld a, [OTPartyCount]
	ld b, a
	ld a, [CurOTMon]
	ld c, a
; select a random enemy mon to switch to
.random_loop_trainer
	call BattleRandom
	and $7
	cp b
	jr nc, .random_loop_trainer
	cp c
	jr z, .random_loop_trainer
	push af
	push bc
	ld hl, OTPartyMon1HP
	call GetPartyLocation
	ld a, [hli]
	or [hl]
	pop bc
	pop de
	jr z, .random_loop_trainer
	ld a, d
	inc a
	ld [wEnemySwitchMonIndex], a
	callba ForceEnemySwitch

	ld hl, DraggedOutText
	call StdBattleTextBox

	jpba SpikesDamage

.switch_fail
	jp .fail

.force_player_switch
	ld a, [AttackMissed]
	and a
	jr nz, .player_miss

	ld a, [wBattleMode]
	dec a
	jr nz, .vs_trainer

	ld a, [BattleMonLevel]
	ld b, a
	ld a, [CurPartyLevel]
	cp b
	jr nc, .wild_succeed_playeristarget

	add b
	ld c, a
	inc c
.wild_random_loop_playeristarget
	call BattleRandom
	cp c
	jr nc, .wild_random_loop_playeristarget

	srl b
	srl b
	cp b
	jr nc, .wild_succeed_playeristarget

.player_miss
	jr .fail

.wild_succeed_playeristarget
	call UpdateBattleMonInParty
	xor a
	ld [wNumHits], a
	inc a
	ld [wForcedSwitch], a
	call SetBattleDraw
	ld a, [wEnemyMoveStructAnimation]
	jr .succeed

.vs_trainer
	call CheckPlayerHasMonToSwitchTo
	jr c, .fail

	ld a, [wEnemyGoesFirst]
	cp $1
	jr z, .switch_fail

	call UpdateBattleMonInParty
	ld a, $1
	ld [wBattleAnimParam], a
	call AnimateCurrentMove
	ld c, 20
	call DelayFrames
	hlcoord 9, 7
	lb bc, 5, 11
	call ClearBox
	ld c, 20
	call DelayFrames
	ld a, [wPartyCount]
	ld b, a
	ld a, [CurBattleMon]
	ld c, a
.random_loop_trainer_playeristarget
	call BattleRandom
	and $7
	cp b
	jr nc, .random_loop_trainer_playeristarget

	cp c
	jr z, .random_loop_trainer_playeristarget

	push af
	push bc
	ld hl, PartyMon1HP
	call GetPartyLocation
	ld a, [hli]
	or [hl]
	pop bc
	pop de
	jr z, .random_loop_trainer_playeristarget

	ld a, d
	ld [wCurPartyMon], a
	callba SwitchPlayerMon

	ld hl, DraggedOutText
	call StdBattleTextBox

	jpba SpikesDamage

.fail
	call BattleCommand_LowerSub
	call BattleCommand_MoveDelay
	call BattleCommand_RaiseSub
	jp PrintButItFailed

.succeed
	push af
	call SetBattleDraw
	ld a, $1
	ld [wBattleAnimParam], a
	call AnimateCurrentMove
	ld c, 20
	call DelayFrames
	pop af

	ld hl, FledInFearText
	cp ROAR
	jr z, .do_text
	ld hl, BlownAwayText
.do_text
	jp StdBattleTextBox

CheckPlayerHasMonToSwitchTo:
	ld a, [wPartyCount]
	ld d, a
	ld e, 0
	ld bc, PARTYMON_STRUCT_LENGTH
.loop
	ld a, [CurBattleMon]
	cp e
	jr z, .next

	ld a, e
	ld hl, PartyMon1HP
	rst AddNTimes
	ld a, [hli]
	or [hl]
	jr nz, .not_fainted

.next
	inc e
	dec d
	jr nz, .loop

	scf
	ret

.not_fainted
	and a
	ret

BattleCommand_EndLoop:
; endloop

; Loop back to the command before 'critical'.

	ld de, PlayerRolloutCount
	ld bc, PlayerDamageTaken
	ld a, [hBattleTurn]
	and a
	jr z, .got_addrs
	ld de, EnemyRolloutCount
	ld bc, EnemyDamageTaken
.got_addrs

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	bit SUBSTATUS_IN_LOOP, [hl]
	jp nz, .in_loop
	set SUBSTATUS_IN_LOOP, [hl]

	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVarAddr
	ld a, [hl]
	cp EFFECT_TWINEEDLE
	jr z, .twineedle
	cp EFFECT_DOUBLE_HIT
	ld a, 1
	jr z, .double_hit
	ld a, [hl]

	call BattleRandom
	and $3
	cp 2
	jr c, .got_number_hits
	call BattleRandom
	and $3
.got_number_hits
	inc a
.double_hit
	ld [de], a
	inc a
	ld [bc], a
	jr .loop_back_to_critical

.twineedle
	ld a, 1
	jr .double_hit

.in_loop
	ld a, [de]
	dec a
	ld [de], a
	jr nz, .loop_back_to_critical
.done_loop
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	res SUBSTATUS_IN_LOOP, [hl]

	ld hl, PlayerHitTimesText
	ld a, [hBattleTurn]
	and a
	jr z, .got_hit_n_times_text
	ld hl, EnemyHitTimesText
.got_hit_n_times_text

	push bc
	call StdBattleTextBox

	pop bc
	xor a
	ld [bc], a
	ret

; Loop back to the command before 'critical'.
.loop_back_to_critical
	ld a, [BattleScriptBufferLoc + 1]
	ld h, a
	ld a, [BattleScriptBufferLoc]
	ld l, a
.not_critical
	ld a, [hld]
	cp critical_command
	jr nz, .not_critical
	inc hl
	ld a, h
	ld [BattleScriptBufferLoc + 1], a
	ld a, l
	ld [BattleScriptBufferLoc], a
	ret

BattleCommand_FlinchTarget:
	call CheckSubstituteOpp
	ret nz

	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and 1 << FRZ | SLP
	ret nz

	call CheckOpponentWentFirst
	ret nz

	ld a, [EffectFailed]
	and a
	ret nz

	; fallthrough

FlinchTarget:
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVarAddr
	set SUBSTATUS_FLINCHED, [hl]
	jp EndRechargeOpp

CheckOpponentWentFirst:
; Returns a=0, z if user went first
; Returns a=1, nz if opponent went first
	push bc
	ld a, [wEnemyGoesFirst] ; 0 if player went first
	ld b, a
	ld a, [hBattleTurn] ; 0 if it's the player's turn
	xor b ; 1 if opponent went first
	pop bc
	ret

BattleCommand_KingsRock:
; kingsrock

	ld a, [AttackMissed]
	and a
	ret nz

	call GetUserItem
	ld a, b
	cp HELD_FLINCH ; Only King's Rock has this effect
	ret nz

	call CheckSubstituteOpp
	ret nz
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVarAddr
	ld d, h
	ld e, l
	call GetUserItem
	call BattleRandom
	cp c
	ret nc
	call EndRechargeOpp
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVarAddr
	set SUBSTATUS_FLINCHED, [hl]
	ret

BattleCommand_Charge:
; charge

	call BattleCommand_ClearText
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and SLP
	jr z, .awake

	call BattleCommand_MoveDelay
	call BattleCommand_RaiseSub
	call PrintButItFailed
	jp EndMoveEffect

.awake
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	set SUBSTATUS_CHARGED, [hl]

	ld hl, IgnoredOrders2Text
	ld a, [AlreadyDisobeyed]
	and a
	call nz, StdBattleTextBox

	call BattleCommand_LowerSub
	xor a
	ld [wNumHits], a
	inc a
	ld [wBattleAnimParam], a
	call LoadMoveAnim
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp FLY
	jr z, .flying
	cp DIG
	jr z, .flying
	call BattleCommand_RaiseSub
	jr .not_flying

.flying
	call DisappearUser
.not_flying
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld b, a
	cp FLY
	jr z, .set_flying
	cp DIG
	jr nz, .dont_set_digging
	set SUBSTATUS_UNDERGROUND, [hl]
	jr .dont_set_digging

.set_flying
	set SUBSTATUS_FLYING, [hl]

.dont_set_digging
	call CheckUserIsCharging
	jr nz, .mimic
	ld a, BATTLE_VARS_LAST_COUNTER_MOVE
	call GetBattleVarAddr
	ld [hl], b
	ld a, BATTLE_VARS_LAST_MOVE
	call GetBattleVarAddr
	ld [hl], b

.mimic
	call ZeroDamage

	ld hl, .UsedText
	call BattleTextBox

	ld b, endturn_command
	jp EndMoveEffect

.UsedText
	text_far UnknownText_0x1c0d0e ; "[USER]"
	start_asm
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar

	cp SOLARBEAM
	ld hl, .Solarbeam
	ret z

	cp SKY_ATTACK
	ld hl, .SkyAttack
	ret z

	cp FLY
	ld hl, .Fly
	ret z

	cp DIG
	ld hl, .Dig
	ret

.Solarbeam
; 'took in sunlight!'
	text_jump UnknownText_0x1c0d26

.SkullBash
; 'lowered its head!'
	text_jump UnknownText_0x1c0d3a

.SkyAttack
; 'is glowing!'
	text_jump UnknownText_0x1c0d4e

.Fly
; 'flew up high!'
	text_jump UnknownText_0x1c0d5c

.Dig
; 'dug a hole!'
	text_jump UnknownText_0x1c0d6c

BattleCommand_TrapTarget:
; traptarget

	ld a, [AttackMissed]
	and a
	ret nz
	ld hl, wEnemyWrapCount
	ld de, wEnemyTrappingMove
	ld a, [hBattleTurn]
	and a
	jr z, .got_trap
	ld hl, wPlayerWrapCount
	ld de, wPlayerTrappingMove

.got_trap
	ld a, [hl]
	and a
	ret nz
	call CheckSubstituteOpp
	ret nz
	call BattleRandom
	and 3
	add 3
	ld [hl], a
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld [de], a
	ld b, a
	ld hl, .Traps

.find_trap_text
	ld a, [hli]
	cp b
	jr z, .found_trap_text
	inc hl
	inc hl
	jr .find_trap_text

.found_trap_text
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp StdBattleTextBox

.Traps
	dbw WRAP,      WrappedByText     ; 'was WRAPPED by'
	dbw FIRE_SPIN, WasTrappedText    ; 'was trapped!'

BattleCommand_Mist:
; mist

	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	bit SUBSTATUS_MIST, [hl]
	jr nz, .already_mist
	set SUBSTATUS_MIST, [hl]
	call AnimateCurrentMove
	ld hl, MistText
	jp StdBattleTextBox

.already_mist
	call AnimateFailedMove
	jp PrintButItFailed

BattleCommand_FocusEnergy:
; focusenergy

	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	bit SUBSTATUS_FOCUS_ENERGY, [hl]
	jr nz, .already_pumped
	set SUBSTATUS_FOCUS_ENERGY, [hl]
	call AnimateCurrentMove
	ld hl, GettingPumpedText
	jp StdBattleTextBox

.already_pumped
	call AnimateFailedMove
	jp PrintButItFailed

BattleCommand_ConfuseTarget:
; confusetarget

	call GetOpponentItem
	ld a, b
	cp HELD_PREVENT_CONFUSE
	ret z
	ld a, [EffectFailed]
	and a
	ret nz
	call SafeCheckSafeguard
	ret nz
	call CheckSubstituteOpp
	ret nz
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVarAddr
	bit SUBSTATUS_CONFUSED, [hl]
	ret nz

	call GetTargetAbility
	cp ABILITY_OWN_TEMPO
	ret z

	jr BattleCommand_FinishConfusingTarget

BattleCommand_Confuse:
; confuse

	call GetOpponentItem
	ld a, b
	cp HELD_PREVENT_CONFUSE
	jr nz, .no_item_protection
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	call AnimateFailedMove
	ld hl, ProtectedByText
	jp StdBattleTextBox

.no_item_protection
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVarAddr
	bit SUBSTATUS_CONFUSED, [hl]
	jr z, .not_already_confused
	call AnimateFailedMove
	ld hl, AlreadyConfusedText
	jp StdBattleTextBox

.not_already_confused
	call CheckSubstituteOpp
	jr nz, BattleCommand_Confuse_CheckSnore_Swagger_ConfuseHit
	ld a, [AttackMissed]
	and a
	jr nz, BattleCommand_Confuse_CheckSnore_Swagger_ConfuseHit

	call GetTargetAbility
	cp ABILITY_OWN_TEMPO
	jr z, BattleCommand_Confuse_CheckSnore_Swagger_ConfuseHit

BattleCommand_FinishConfusingTarget:
	ld bc, EnemyConfuseCount
	ld a, [hBattleTurn]
	and a
	jr z, .got_confuse_count
	ld bc, PlayerConfuseCount

.got_confuse_count
	set SUBSTATUS_CONFUSED, [hl]
	call BattleRandom
	and 3
	inc a
	inc a
	ld [bc], a

	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_CONFUSE_HIT
	jr z, .got_effect
	cp EFFECT_SWAGGER
	jr z, .got_effect
	call AnimateCurrentMove

.got_effect
	ld de, ANIM_CONFUSED
	call PlayOpponentBattleAnim

	ld hl, BecameConfusedText
	call StdBattleTextBox

	call GetOpponentItem
	ld a, b
	cp HELD_HEAL_STATUS
	jr z, .heal_confusion
	cp HELD_HEAL_CONFUSION
	ret nz
.heal_confusion
	jpba UseConfusionHealingItem

BattleCommand_Confuse_CheckSnore_Swagger_ConfuseHit:
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_CONFUSE_HIT
	ret z
	cp EFFECT_SWAGGER
	ret z
	jp PrintDidntAffect

BattleCommand_Paralyze:
; paralyze

	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	bit PAR, a
	jp nz, .paralyzed
	ld a, [TypeModifier]
	and $7f
	jp z, .didnt_affect
	call GetOpponentItem
	ld a, b
	cp HELD_PREVENT_PARALYZE
	jr nz, .no_item_protection
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	call AnimateFailedMove
	ld hl, ProtectedByText
	jp StdBattleTextBox

.no_item_protection
	call GetTargetAbility
	cp ABILITY_LIMBER
	jr z, .failed
	cp ABILITY_LEAF_GUARD
	jr nz, .not_leaf_guard
	ld a, [Weather]
	cp WEATHER_SUN
	jr z, .failed
.not_leaf_guard
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	and a
	jr nz, .failed
	ld a, [AttackMissed]
	and a
	jr nz, .failed
	call CheckSubstituteOpp
	jr nz, .failed
	ld hl, BattleMonType
	ld a, [hBattleTurn]
	and a
	jr nz, .got_types
	ld hl, EnemyMonType
.got_types
	ld a, [hli]
	cp ELECTRIC
	jr z, .failed
	ld a, [hl]
	cp ELECTRIC
	jr z, .failed
	ld c, 30
	call DelayFrames
	call AnimateCurrentMove
	ld a, $1
	ld [hBGMapMode], a
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	set PAR, [hl]
	call UpdateOpponentInParty
	callba ApplyPrzEffectOnSpeed
	call UpdateBattleHuds
	call PrintParalyze
	jp BattleCommand_Synchronize

.paralyzed
	call AnimateFailedMove
	ld hl, AlreadyParalyzedText
	jp StdBattleTextBox

.failed
	jp PrintDidntAffect

.didnt_affect
	call AnimateFailedMove
	jp PrintDoesntAffect

CheckMoveTypeMatchesTarget:
; Compare move type to opponent type.
; Return z if matching the opponent type,
; unless the move is Normal (Tri Attack).

	push hl

	ld hl, EnemyMonType1
	ld a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, BattleMonType1
.ok

	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	and $3f
	cp NORMAL
	jr z, .normal

	cp [hl]
	jr z, .return

	inc hl
	cp [hl]

.return
	pop hl
	ret

.normal
	ld a, 1
	and a
	pop hl
	ret

BattleCommand_Substitute:
; substitute

	call BattleCommand_MoveDelay
	ld hl, BattleMonMaxHP
	ld de, PlayerSubstituteHP
	ld a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld hl, EnemyMonMaxHP
	ld de, EnemySubstituteHP
.got_hp

	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVar
	bit SUBSTATUS_SUBSTITUTE, a
	jr nz, .already_has_sub

	ld a, [hli]
	ld b, [hl]
	srl a
	rr b
	srl a
	rr b
	dec hl
	dec hl
	ld a, b
	ld [de], a
	ld a, [hld]
	sub b
	ld e, a
	ld a, [hl]
	sbc 0
	ld d, a
	jr c, .too_weak_to_sub
	ld a, d
	or e
	jr z, .too_weak_to_sub
	ld [hl], d
	inc hl
	ld [hl], e

	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	set SUBSTATUS_SUBSTITUTE, [hl]

	ld hl, wPlayerWrapCount
	ld de, wPlayerTrappingMove
	ld a, [hBattleTurn]
	and a
	jr z, .player
	ld hl, wEnemyWrapCount
	ld de, wEnemyTrappingMove
.player

	xor a
	ld [hl], a
	ld [de], a
	call CheckBattleScene
	jr c, .no_anim

	xor a
	ld [wNumHits], a
	ld [FXAnimIDHi], a
	ld [wBattleAnimParam], a
	ld a, SUBSTITUTE
	call LoadAnim
	jr .finish

.no_anim
	call BattleCommand_RaiseSubNoAnim
.finish
	ld hl, MadeSubstituteText
	call StdBattleTextBox
	jp RefreshBattleHuds

.already_has_sub
	call CheckUserIsCharging
	call nz, BattleCommand_RaiseSub
	ld hl, HasSubstituteText
	jp StdBattleTextBox

.too_weak_to_sub
	call CheckUserIsCharging
	call nz, BattleCommand_RaiseSub
	ld hl, TooWeakSubText
	jp StdBattleTextBox

BattleCommand_RechargeNextTurn:
; rechargenextturn
	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	set SUBSTATUS_RECHARGE, [hl]
	ret

EndRechargeOpp:
	push hl
	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVarAddr
	res SUBSTATUS_RECHARGE, [hl]
	pop hl
	ret

BattleCommand_Rage:
; rage
	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	set SUBSTATUS_RAGE, [hl]
	ret

BattleCommand_DoubleFlyingDamage:
; doubleflyingdamage
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	bit SUBSTATUS_FLYING, a
	ret z
	jr DoubleDamage

BattleCommand_DoubleUndergroundDamage:
; doubleundergrounddamage
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	bit SUBSTATUS_UNDERGROUND, a
	ret z
	; fallthrough

DoubleDamage:
	ld hl, wCurDamageShiftCount
	inc [hl]
	jp SetDamageDirtyFlag

BattleCommand_LeechSeed:
; leechseed
	ld a, [EffectFailed]
	and a
	ret nz
	ld a, [AttackMissed]
	and a
	jr nz, .evaded
	call CheckSubstituteOpp
	jr nz, .evaded

	ld de, EnemyMonType1
	ld a, [hBattleTurn]
	and a
	jr z, .ok
	ld de, BattleMonType1
.ok

	ld a, [de]
	cp GRASS
	jr z, .grass
	inc de
	ld a, [de]
	cp GRASS
	jr z, .grass

	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVarAddr
	bit SUBSTATUS_LEECH_SEED, [hl]
	jr nz, .evaded
	set SUBSTATUS_LEECH_SEED, [hl]

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp SPRING_BUDS
	jr z, .no_anim
	call AnimateCurrentMove
.no_anim
	ld hl, WasSeededText
	jp StdBattleTextBox

.grass
	call AnimateFailedMove
	jp PrintDoesntAffect

.evaded
	call AnimateFailedMove
	ld a, [hBattleTurn]
	and a
	ld a, [wPlayerMoveStructPower]
	jr z, .enemy_evaded
	ld a, [wEnemyMoveStructPower]
.enemy_evaded
	and a
	ret nz ; if the move deals damage, don't print the "evaded the attack" text
	ld hl, EvadedText
	jp StdBattleTextBox

BattleCommand_Splash:
	call AnimateCurrentMove
	jp PrintNothingHappened

BattleCommand_Disable:
; disable

	ld a, [AttackMissed]
	and a
	jp nz, FailDisable

	ld de, EnemyDisableCount
	ld hl, EnemyMonMoves
	ld a, [hBattleTurn]
	and a
	jr z, .got_moves
	ld de, PlayerDisableCount
	ld hl, BattleMonMoves
.got_moves

	ld a, [de]
	and a
	jp nz, FailDisable

	ld a, BATTLE_VARS_LAST_COUNTER_MOVE_OPP
	call GetBattleVar
	and a
	jp z, FailDisable
	cp STRUGGLE
	jp z, FailDisable

	ld b, a
	ld c, $ff
.loop
	inc c
	ld a, [hli]
	cp b
	jr nz, .loop

	ld a, [hBattleTurn]
	and a
	ld hl, EnemyMonPP
	jr z, .got_pp
	ld hl, BattleMonPP
.got_pp
	ld b, 0
	add hl, bc
	ld a, [hl]
	and a
	jp z, FailDisable
	ld a, 5
	inc c
	swap c
	add c
	ld [de], a
	call AnimateCurrentMove
	ld hl, DisabledMove
	ld a, [hBattleTurn]
	and a
	jr nz, .got_disabled_move_pointer
	inc hl
.got_disabled_move_pointer
	ld a, BATTLE_VARS_LAST_COUNTER_MOVE_OPP
	call GetBattleVar
	ld [hl], a
	ld [wNamedObjectIndexBuffer], a
	call GetMoveName
	ld hl, WasDisabledText
	jp StdBattleTextBox

BattleCommand_Conversion:
; conversion

	ld hl, BattleMonMoves
	ld de, BattleMonType1
	ld a, [hBattleTurn]
	and a
	jr z, .got_moves
	ld hl, EnemyMonMoves
	ld de, EnemyMonType1
.got_moves
	push de
	ld c, 0
	ld de, wStringBuffer1
.loop
	push hl
	ld b, 0
	add hl, bc
	ld a, [hl]
	pop hl
	and a
	jr z, .okay
	push hl
	push bc
	dec a
	ld hl, Moves + MOVE_TYPE
	call GetMoveAttr
	and $3f
	ld [de], a
	inc de
	pop bc
	pop hl
	inc c
	ld a, c
	cp NUM_MOVES
	jr c, .loop
.okay
	ld a, $ff
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld [de], a
	pop de
	ld hl, wStringBuffer1
.loop2
	ld a, [hl]
	cp -1
	jr z, .fail
	cp CURSE_T
	jr z, .next
	ld a, [de]
	cp [hl]
	jr z, .next
	inc de
	ld a, [de]
	dec de
	cp [hl]
	jr nz, .done
.next
	inc hl
	jr .loop2

.fail
	call AnimateFailedMove
	jp PrintButItFailed

.done
.loop3
	call BattleRandom
	and 3 ; TODO factor in NUM_MOVES
	ld c, a
	ld b, 0
	ld hl, wStringBuffer1
	add hl, bc
	ld a, [hl]
	cp -1
	jr z, .loop3
	cp CURSE_T
	jr z, .loop3
	cp PRISM_T
	jr z, .loop3
	ld a, [de]
	cp [hl]
	jr z, .loop3
	inc de
	ld a, [de]
	dec de
	cp [hl]
	jr z, .loop3
	ld a, [hl]
	ld [de], a
	inc de
	ld [de], a
	ld [wNamedObjectIndexBuffer], a
	callba GetTypeName
	call AnimateCurrentMove
	ld hl, TransformedTypeText
	jp StdBattleTextBox

BattleCommand_ResetStats:
; resetstats
	ld a, 7 ; neutral
	ld hl, PlayerStatLevels
	call .Fill
	ld hl, EnemyStatLevels
	call .Fill

	ld a, [hBattleTurn]
	push af

	call SetPlayerTurn
	call CalcPlayerStats
	call SetEnemyTurn
	call CalcEnemyStats

	pop af
	ld [hBattleTurn], a

	call AnimateCurrentMove

	ld hl, EliminatedStatsText
	jp StdBattleTextBox

.Fill:
	ld b, PlayerStatLevelsEnd - PlayerStatLevels - 1
.next
	ld [hli], a
	dec b
	jr nz, .next
	ret

BattleCommand_Heal:
; heal

	ld de, BattleMonHP
	ld hl, BattleMonMaxHP
	ld a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld de, EnemyMonHP
	ld hl, EnemyMonMaxHP
.got_hp
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld b, a
	push hl
	push de
	push bc
	ld c, 2
	call StringCmp
	pop bc
	pop de
	pop hl
	jp z, .hp_full
	ld a, b
	cp REST
	jr nz, .not_rest
	call GetUserAbility
	cp ABILITY_INSOMNIA
	jp z, BattleEffect_ButItFailed

	push hl
	push de
	push af
	call BattleCommand_MoveDelay
	ld a, BATTLE_VARS_SEMISTATUS
	call GetBattleVarAddr
	res SEMISTATUS_TOXIC, [hl]
	ld a, BATTLE_VARS_STATUS
	call GetBattleVarAddr
	ld a, [hl]
	and SLP
	jp nz, .already_sleeping
	ld a, [hl]
	and a
	ld [hl], REST_TURNS + 1
	ld hl, WentToSleepText
	jr z, .no_status_to_heal
	ld hl, RestedText
.no_status_to_heal
	call StdBattleTextBox
	ld a, [hBattleTurn]
	and a
	jr nz, .calc_enemy_stats
	call CalcPlayerStats
	jr .got_stats

.calc_enemy_stats
	call CalcEnemyStats
.got_stats
	pop af
	pop de
	pop hl

	callba GetMaxHP
	jr .finish
.not_rest
	callba GetHalfMaxHP
.finish
	call AnimateCurrentMove
	call SwitchTurn
	callba RestoreOpponentHP
	call SwitchTurn
	call UpdateUserInParty
	call RefreshBattleHuds
	ld hl, RegainedHealthText
	jp StdBattleTextBox

.hp_full
	call AnimateFailedMove
	ld hl, HPIsFullText
	jp StdBattleTextBox

.already_sleeping
	pop af
	pop de
	pop hl
BattleEffect_ButItFailed:
	call AnimateFailedMove
	jp PrintButItFailed

ResetActorDisable:
	ld a, [hBattleTurn]
	and a
	ld a, 0
	jr z, .player

	ld [EnemyDisableCount], a
	ld [EnemyDisabledMove], a
	ret

.player
	ld [PlayerDisableCount], a
	ld [DisabledMove], a
	ret

BattleCommand_Screen:
; screen

	ld hl, wPlayerScreens
	ld bc, PlayerLightScreenCount
	ld a, [hBattleTurn]
	and a
	jr z, .got_screens_pointer
	ld hl, wEnemyScreens
	ld bc, EnemyLightScreenCount

.got_screens_pointer
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_LIGHT_SCREEN
	jr nz, .Reflect

	bit SCREENS_LIGHT_SCREEN, [hl]
	jr nz, .failed
	set SCREENS_LIGHT_SCREEN, [hl]
	call GetScreenCount
	ld [bc], a
	ld hl, LightScreenEffectText
	jr .good

.Reflect
	bit SCREENS_REFLECT, [hl]
	jr nz, .failed
	set SCREENS_REFLECT, [hl]

	; LightScreenCount -> ReflectCount
	inc bc

	call GetScreenCount
	ld [bc], a
	ld hl, ReflectEffectText

.good
	call AnimateCurrentMove
	jp StdBattleTextBox

.failed
	call AnimateFailedMove
	jp PrintButItFailed

GetScreenCount:
	push bc
	call GetUserItem
	ld a, b
	pop bc
	cp HELD_LIGHT_CLAY
	ld a, 5
	ret nz
	ld a, 8
	ret

PrintDoesntAffect:
; 'it doesn't affect'
	ld hl, DoesntAffectText
	jp StdBattleTextBox

PrintNothingHappened:
; 'but nothing happened!'
	ld hl, NothingHappenedText
	jp StdBattleTextBox

FailSnore:
FailDisable:
FailConversion2:
FailAttract:
FailForesight:
FailSpikes:
FailLavaPool:
	call AnimateFailedMove
	; fallthrough

PrintDidntAffect:
; 'it didn't affect'
	ld hl, DidntAffect1Text
	jp StdBattleTextBox

PrintParalyze:
; 'paralyzed! maybe it can't attack!'
	ld a, [wMoveIsAnAbility]
	and a
	ld hl, ParalyzedText
	jp z, StdBattleTextBox
	ld hl, PrzAbilityText
	jp StdBattleTextBox

BattleCommand_SelfDestruct:
	ld a, BATTLEANIM_PLAYER_DAMAGE
	ld [wNumHits], a
	ld c, 2
	call DelayFrames
	ld a, BATTLE_VARS_STATUS
	call GetBattleVarAddr
	xor a
	ld [hli], a
	inc hl
	ld [hli], a
	ld [hl], a
	ld a, $1
	ld [wBattleAnimParam], a
	call BattleCommand_LowerSub
	call LoadMoveAnim
	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	res SUBSTATUS_LEECH_SEED, [hl]
	ld a, BATTLE_VARS_SUBSTATUS5_OPP
	call GetBattleVarAddr
	res SUBSTATUS_DESTINY_BOND, [hl]
	call CheckBattleScene
	ret nc
	callba DrawPlayerHUD
	callba DrawEnemyHUD
	call ApplyTilemapInVBlank
	jp RefreshBattleHuds

BattleCommand_ArenaTrap:
; arenatrap

; Doesn't work on an absent opponent.

	call CheckHiddenOpponent
	jr nz, .failed

; Don't trap if the opponent is already trapped.

	ld a, BATTLE_VARS_SUBSTATUS2_OPP
	call GetBattleVar
	bit SUBSTATUS_FINAL_CHANCE, a
	jr nz, .failed

	ld a, BATTLE_VARS_SUBSTATUS5
	call GetBattleVarAddr
	bit SUBSTATUS_CANT_RUN, [hl]
	jr nz, .failed

; Otherwise trap the opponent.

	set SUBSTATUS_CANT_RUN, [hl]
	call AnimateCurrentMove
	ld hl, CantEscapeNowText
	jp StdBattleTextBox

.failed
	call AnimateFailedMove
	jp PrintButItFailed

BattleCommand_Defrost:
; defrost

; Thaw the user.

	ld a, BATTLE_VARS_STATUS
	call GetBattleVarAddr
	bit FRZ, [hl]
	ret z
	res FRZ, [hl]

; Don't update the enemy's party struct in a wild battle.

	ld a, [hBattleTurn]
	and a
	jr z, .party

	ld a, [wBattleMode]
	dec a
	jr z, .done

.party
	ld a, MON_STATUS
	call UserPartyAttr
	res FRZ, [hl]

.done
	call RefreshBattleHuds
	ld hl, WasDefrostedText
	jp StdBattleTextBox

BattleCommand_FuryCutter:
; furycutter

	ld hl, PlayerFuryCutterCount
	ld a, [hBattleTurn]
	and a
	jr z, .go
	ld hl, EnemyFuryCutterCount

.go
	ld a, [AttackMissed]
	and a
	jr nz, ResetFuryCutterCount

	inc [hl]

; Damage capped at 5 turns' worth (16x).
	ld a, [hl]
	cp 6
	jr c, .double
	ld a, 5

.double
	dec a
	ld hl, wCurDamageShiftCount
	add a, [hl]
	ld [hl], a
	jp SetDamageDirtyFlag

ResetFuryCutterCount:
	push hl

	ld hl, PlayerFuryCutterCount
	ld a, [hBattleTurn]
	and a
	jr z, .reset
	ld hl, EnemyFuryCutterCount

.reset
	xor a
	ld [hl], a

	pop hl
	ret

BattleCommand_FrustrationPower:
; frustrationpower

	push bc
	ld hl, BattleMonHappiness
	ld a, [hBattleTurn]
	and a
	jr z, .got_happiness
	ld hl, EnemyMonHappiness
.got_happiness
	ld a, [hl]
	cpl
	jr HappinessBasedPower

BattleCommand_HappinessPower:
; happinesspower
	push bc
	ld hl, BattleMonHappiness
	ld a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, EnemyMonHappiness
.ok
	ld a, [hl]
	;fallthrough

HappinessBasedPower:
	and a
	jr z, .zero_power
	ld hl, wCurDamageMovePowerNumerator
	ld b, a
	xor a
	sla b
	rla
	ld [hli], a
	ld a, b
	ld [hli], a
	;hl = wCurDamageMovePowerDenominator
	ld [hl], 5
	call SetDamageDirtyFlag
	pop bc
	ret
.zero_power
	; if the move would have zero power, deal 1 damage without calculations
	ld hl, wCurDamageFlags
	ld [hl], $c0 ; fixed damage, dirty
	inc hl ; hl = wCurDamageFixedValue
	ld [hli], a ; a = 0
	ld [hl], 1
	pop bc
	ret

BattleCommand_Safeguard:
; safeguard

	ld hl, wPlayerScreens
	ld de, PlayerSafeguardCount
	ld a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wEnemyScreens
	ld de, EnemySafeguardCount
.ok
	bit SCREENS_SAFEGUARD, [hl]
	jr nz, .failed
	set SCREENS_SAFEGUARD, [hl]
	ld a, 5
	ld [de], a
	call AnimateCurrentMove
	ld hl, CoveredByVeilText
	jp StdBattleTextBox

.failed
	call AnimateFailedMove
	jp PrintButItFailed

SafeCheckSafeguard:
	push hl
	ld hl, wEnemyScreens
	ld a, [hBattleTurn]
	and a
	jr z, .got_turn
	ld hl, wPlayerScreens

.got_turn
	bit SCREENS_SAFEGUARD, [hl]
	pop hl
	ret

BattleCommand_CheckSafeguard:
; checksafeguard
	ld hl, wEnemyScreens
	ld a, [hBattleTurn]
	and a
	jr z, .got_turn
	ld hl, wPlayerScreens
.got_turn
	bit SCREENS_SAFEGUARD, [hl]
	ret z
	ld a, 1
	ld [AttackMissed], a
	call BattleCommand_MoveDelay
	ld hl, SafeguardProtectText
	call StdBattleTextBox
	jp EndMoveEffect

BattleCommand_GetMagnitude:
; getmagnitude

	call BattleRandom
	ld b, a
	ld hl, .Magnitudes
.loop
	ld a, [hli]
	cp b
	jr nc, .ok
	inc hl
	inc hl
	jr .loop
.ok
	ld a, [hli]
	push hl
	ld hl, wCurDamageMovePowerNumerator
	ld [hl], 0
	inc hl
	ld [hli], a
	; hl = wCurDamageMovePowerDenominator
	ld [hl], 1
	pop hl
	ld a, [hl]
	ld [wTypeMatchup], a
	call BattleCommand_MoveDelay
	ld hl, MagnitudeText
	call StdBattleTextBox
	ret

.Magnitudes
	;     probability,  BP, magnitude
	db 1 +  5 percent,  10,  4
	db     15 percent,  30,  5
	db     35 percent,  50,  6
	db 1 + 65 percent,  70,  7
	db 1 + 85 percent,  90,  8
	db     95 percent, 110,  9
	db    100 percent, 150, 10

BattleCommand_BatonPass:
; batonpass

	ld a, [hBattleTurn]
	and a
	jp nz, .Enemy

; Need something to switch to
	call CheckAnyOtherAlivePartyMons
	jp z, FailedBatonPass

	call UpdateBattleMonInParty
	call AnimateCurrentMove

	ld c, 50
	call DelayFrames

; Transition into switchmon menu
	call LoadStandardMenuDataHeader
	callba SetUpBattlePartyMenu_NoLoop

	callba ForcePickSwitchMonInBattle

; Return to battle scene
	call ClearPalettes
	callba _LoadBattleFontsHPBar
	call CloseWindow
	call ClearSprites
	hlcoord 1, 0
	lb bc, 4, 10
	call ClearBox
	ld b, SCGB_BATTLE_COLORS
	predef GetSGBLayout
	call SetPalettes
	call BatonPass_LinkPlayerSwitch

	callba PassedBattleMonEntrance

	call ResetBatonPassStatus
	jp ApplyBattleMonRingEffect

.Enemy

; Wildmons don't have anything to switch to
	ld a, [wBattleMode]
	dec a ; WILDMON
	jp z, FailedBatonPass

	call CheckAnyOtherAliveEnemyMons
	jp z, FailedBatonPass

	call UpdateEnemyMonInParty
	call AnimateCurrentMove
	call BatonPass_LinkEnemySwitch

; Passed enemy PartyMon entrance
	xor a
	ld [wEnemySwitchMonIndex], a
	callba EnemySwitch_SetMode
	callba ResetBattleParticipants
	ld a, 1
	ld [wTypeMatchup], a
	callba ApplyStatLevelMultiplierOnAllStats

	callba SpikesDamage

	call ResetBatonPassStatus
	jp ApplyEnemyMonRingEffect

BatonPass_LinkPlayerSwitch:
	ld a, [wLinkMode]
	and a
	ret z

	ld a, 1
	ld [wPlayerAction], a

	call LoadStandardMenuDataHeader
	callba LinkBattleSendReceiveAction
	call CloseWindow

	xor a
	ld [wPlayerAction], a
	ret

BatonPass_LinkEnemySwitch:
	ld a, [wLinkMode]
	and a
	ret z

	call LoadStandardMenuDataHeader
	callba LinkBattleSendReceiveAction

	ld a, [OTPartyCount]
	add BATTLEACTION_SWITCH1
	ld b, a
	ld a, [wBattleAction]
	cp BATTLEACTION_SWITCH1
	jr c, .baton_pass
	cp b
	jp c, CloseWindow

.baton_pass
	ld a, [CurOTMon]
	add BATTLEACTION_SWITCH1
	ld [wBattleAction], a
	jp CloseWindow

FailedBatonPass:
	call AnimateFailedMove
	jp PrintButItFailed

ResetBatonPassStatus:
; Reset status changes that aren't passed by Baton Pass.

	; Nightmare isn't passed.
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and SLP
	jr nz, .ok

	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	res SUBSTATUS_NIGHTMARE, [hl]
.ok

	; Disable isn't passed.
	call ResetActorDisable

	; Attraction isn't passed.
	ld hl, wPlayerSubStatus1
	res SUBSTATUS_IN_LOVE, [hl]
	ld hl, wEnemySubStatus1
	res SUBSTATUS_IN_LOVE, [hl]
	ld hl, wPlayerSubStatus5

	ld a, BATTLE_VARS_SUBSTATUS5
	call GetBattleVarAddr
	res SUBSTATUS_TRANSFORMED, [hl]
	res SUBSTATUS_ENCORED, [hl]

	; New mon hasn't used a move yet.
	ld a, BATTLE_VARS_LAST_MOVE
	call GetBattleVarAddr
	xor a
	ld [hl], a
	ld [wPlayerWrapCount], a
	ld [wEnemyWrapCount], a
	ret

CheckAnyOtherAlivePartyMons:
	ld hl, PartyMon1HP
	ld a, [wPartyCount]
	ld d, a
	ld a, [CurBattleMon]
	ld e, a
	jr CheckAnyOtherAliveMons

CheckAnyOtherAliveEnemyMons:
	ld hl, OTPartyMon1HP
	ld a, [OTPartyCount]
	ld d, a
	ld a, [CurOTMon]
	ld e, a

	; fallthrough

CheckAnyOtherAliveMons:
; Check for nonzero HP starting from partymon
; HP at hl for d partymons, besides current mon e.

; Return nz if any are alive.

	xor a
	ld b, a
	ld c, a
.loop
	ld a, c
	cp d
	jr z, .done
	cp e
	jr z, .next

	ld a, [hli]
	or b
	ld b, a
	ld a, [hld]
	or b
	ld b, a

.next
	push bc
	ld bc, PARTYMON_STRUCT_LENGTH
	add hl, bc
	pop bc
	inc c
	jr .loop

.done
	ld a, b
	and a
	ret

BattleCommand_Pursuit:
; pursuit
; Double damage if the opponent is switching.

	ld hl, wEnemyIsSwitching
	ld a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wPlayerIsSwitching
.ok
	ld a, [hl]
	and a
	ret z
	jp DoubleDamage

BattleCommand_ClearHazards:
; clearhazards

	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	bit SUBSTATUS_LEECH_SEED, [hl]
	jr z, .not_leeched
	res SUBSTATUS_LEECH_SEED, [hl]
	ld hl, ShedLeechSeedText
	call StdBattleTextBox
.not_leeched

	ld hl, wPlayerScreens
	ld de, wPlayerWrapCount
	ld a, [hBattleTurn]
	and a
	jr z, .got_screens_wrap
	ld hl, wEnemyScreens
	ld de, wEnemyWrapCount
.got_screens_wrap
	bit SCREENS_SPIKES, [hl]
	jr z, .no_spikes
	res SCREENS_SPIKES, [hl]
	ld hl, BlewSpikesText
	push de
	call StdBattleTextBox
	pop de
.no_spikes

	ld a, [de]
	and a
	ret z
	xor a
	ld [de], a
	ld hl, ReleasedByText
	jp StdBattleTextBox

BattleCommand_HealMorn:
; healmorn
	ld b, MORN
	jr BattleCommand_TimeBasedHealContinue

BattleCommand_HealDay:
; healday
	ld b, DAY
	jr BattleCommand_TimeBasedHealContinue

BattleCommand_HealNite:
; healnite
	ld b, NITE
	; fallthrough

BattleCommand_TimeBasedHealContinue:
; Time- and weather-sensitive heal.

	ld hl, BattleMonMaxHP
	ld de, BattleMonHP
	ld a, [hBattleTurn]
	and a
	jr z, .start
	ld hl, EnemyMonMaxHP
	ld de, EnemyMonHP

.start
; Index for .Multipliers
; Default restores half max HP.
	ld c, 2

; Don't bother healing if HP is already full.
	push bc
	call StringCmp
	pop bc
	jr z, .Full

; Don't factor in time of day in link battles.
	ld a, [wLinkMode]
	and a
	jr nz, .Weather

	ld a, [TimeOfDay]
	cp b
	jr z, .Weather
	dec c ; double

.Weather:
	call CheckAbilityNegatesWeather
	jr z, .Heal
	ld a, [Weather]
	and a
	jr z, .Heal

; x2 in sun
; /2 in rain/sandstorm
	inc c
	cp WEATHER_SUN
	jr z, .Heal
	dec c
	dec c

.Heal:
	ld b, 0
	ld hl, .Multipliers
	add hl, bc
	add hl, bc

	ld a, BANK(GetMaxHP)
	call FarCall_Pointer

	call AnimateCurrentMove
	call SwitchTurn

	callba RestoreOpponentHP

	call SwitchTurn
	call UpdateUserInParty

; 'regained health!'
	ld hl, RegainedHealthText
	jp StdBattleTextBox

.Full
	call AnimateFailedMove

; 'hp is full!'
	ld hl, HPIsFullText
	jp StdBattleTextBox

.Multipliers
	dw GetEighthMaxHP
	dw GetQuarterMaxHP
	dw GetHalfMaxHP
	dw GetMaxHP

BattleCommand_HiddenPower:
; hiddenpower

	ld a, [AttackMissed]
	and a
	ret nz
	jpba HiddenPowerDamage

BattleCommand_DoubleMinimizeDamage:
; doubleminimizedamage

	ld hl, wEnemyMinimized
	ld a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wPlayerMinimized
.ok
	ld a, [hl]
	and a
	ret z
	jp DoubleDamage

BattleCommand_SkipSunCharge:
; mimicsuncharge

	call CheckAbilityNegatesWeather
	ret z
	ld a, [Weather]
	cp WEATHER_SUN
	ret nz
	ld b, charge_command
	jp SkipToBattleCommand

BattleCommand_ThunderAccuracy:
; thunderaccuracy

	call CheckAbilityNegatesWeather
	ret z
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVarAddr
	and $3f
	inc hl
	ld a, [Weather]
	cp WEATHER_RAIN
	jr z, .rain
	cp WEATHER_SUN
	ret nz
	ld [hl], 50 percent + 1
	ret

.rain
	ld [hl], 100 percent
	ret

AnimateCurrentMoveEitherSide:
	ld a, [wMoveIsAnAbility]
	and a
	ret nz
	push hl
	push de
	push bc
	ld a, [wBattleAnimParam]
	push af
	call BattleCommand_LowerSub
	pop af
	ld [wBattleAnimParam], a
	call PlayDamageAnim
	call BattleCommand_RaiseSub
	pop bc
	pop de
	pop hl
	ret

AnimateCurrentMove:
	ld a, [wMoveIsAnAbility]
	and a
	ret nz
	push hl
	push de
	push bc
	ld a, [wBattleAnimParam]
	push af
	call BattleCommand_LowerSub
	pop af
	ld [wBattleAnimParam], a
	call LoadMoveAnim
	call BattleCommand_RaiseSub
	pop bc
	pop de
	pop hl
	ret

PlayDamageAnim:
	xor a
	ld [FXAnimIDHi], a

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	and a
	ret z

	ld [FXAnimIDLo], a

	ld a, [hBattleTurn]
	and a
	ld a, BATTLEANIM_ENEMY_DAMAGE
	jr z, .player
	ld a, BATTLEANIM_PLAYER_DAMAGE

.player
	ld [wNumHits], a

	jp PlayUserBattleAnim

LoadMoveAnim:
	xor a
	ld [wNumHits], a
	ld [FXAnimIDHi], a

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	and a
	ret z

	; fallthrough

LoadAnim:

	ld [FXAnimIDLo], a

	; fallthrough

PlayUserBattleAnim:
	push hl
	push de
	push bc
	callba PlayBattleAnim
	pop bc
	pop de
	pop hl
	ret

PlayOpponentBattleAnim:
	ld a, e
	ld [FXAnimIDLo], a
	ld a, d
	ld [FXAnimIDHi], a
	xor a
	ld [wNumHits], a

	push hl
	push de
	push bc
	call SwitchTurn

	callba PlayBattleAnim

	call SwitchTurn
	pop bc
	pop de
	pop hl
	ret

AnimateFailedMove:
	call BattleCommand_LowerSub
	call BattleCommand_MoveDelay
	jp BattleCommand_RaiseSub

SkipToBattleCommand:
; Skip over commands until reaching command b.
	ld a, [BattleScriptBufferLoc + 1]
	ld h, a
	ld a, [BattleScriptBufferLoc]
	ld l, a
.loop
	ld a, [hli]
	cp b
	jr nz, .loop

	ld a, h
	ld [BattleScriptBufferLoc + 1], a
	ld a, l
	ld [BattleScriptBufferLoc], a
	ret

GetMoveAttr:
; Assuming hl = Moves + x, return attribute x of move a.
	push bc
	ld bc, MOVE_LENGTH
	rst AddNTimes
	call GetMoveByte
	pop bc
	ret

GetMoveData:
; Copy move struct a to de.
	ld hl, Moves
	ld bc, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	jp FarCopyBytes

GetMoveByte:
	ld a, BANK(Moves)
	jp GetFarByte

DisappearUser:
	jpba _DisappearUser

AppearUserLowerSub:
	jpba _AppearUserLowerSub

AppearUserRaiseSub:
	jpba _AppearUserRaiseSub

BattleCommand_Moody:
	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	ld a, [hl]
	push af
	push hl
	res SUBSTATUS_MIST, [hl]
	ld bc, -1
	call .Sample
	ld b, a
	call .Sample
	ld c, a
	call .Sample
	push bc
	ld b, a
	call SwitchTurn
	call BattleCommand_StatDown
	call BattleCommand_StatDownMessage
	call SwitchTurn
	pop bc
	push bc
	call BattleCommand_StatUp
	call BattleCommand_StatUpMessage
	pop bc
	ld b, c
	call BattleCommand_StatUp
	call BattleCommand_StatUpMessage
	pop hl
	pop af
	ld [hl], a
	ret

.Sample
	call BattleRandom
	and $7
	jr z, .Sample
	dec a
	cp b
	jr z, .Sample
	cp c
	jr z, .Sample
	ret

BattleCommand_PainSplit:
; painsplit

	ld a, [AttackMissed]
	and a
	jp nz, PrintDidntAffect
	call CheckSubstituteOpp
	jp nz, PrintDidntAffect
	call AnimateCurrentMove
	ld hl, BattleMonMaxHP + 1
	ld de, EnemyMonMaxHP + 1
	call .PlayerShareHP
	ld a, $1
	ld [wWhichHPBar], a
	hlcoord 10, 9
	predef AnimateHPBar
	ld hl, EnemyMonHP
	ld a, [hli]
	ld [wCurHPAnimOldHP + 1], a
	ld a, [hli]
	ld [wCurHPAnimOldHP], a
	ld a, [hli]
	ld [wCurHPAnimMaxHP + 1], a
	ld a, [hl]
	ld [wCurHPAnimMaxHP], a
	call .EnemyShareHP
	xor a
	ld [wWhichHPBar], a
	call ResetDamage
	call ZeroDamage
	hlcoord 2, 2
	predef AnimateHPBar
	callba UpdateBattleHUDs

	ld hl, SharedPainText
	jp StdBattleTextBox

.PlayerShareHP
	ld a, $c0 ;fixed damage, dirty
	ld [wCurDamageFlags], a
	ld a, [hld]
	ld [wCurHPAnimMaxHP], a
	ld a, [hld]
	ld [wCurHPAnimMaxHP + 1], a
	ld a, [hld]
	ld b, a
	ld [wCurHPAnimOldHP], a
	ld a, [hl]
	ld [wCurHPAnimOldHP + 1], a
	dec de
	dec de
	ld a, [de]
	dec de
	add b
	ld [wCurDamageFixedValue + 1], a
	ld b, [hl]
	ld a, [de]
	adc b
	srl a
	ld [wCurDamageFixedValue], a
	ld a, [wCurDamageFixedValue + 1]
	rr a
	ld [wCurDamageFixedValue + 1], a
	inc hl
	inc hl
	inc hl
	inc de
	inc de
	inc de

.EnemyShareHP
	call GetCurrentDamage
	ld c, [hl]
	dec hl
	ld a, [wCurDamage + 1]
	sub c
	ld b, [hl]
	dec hl
	ld a, [wCurDamage]
	sbc b
	jr nc, .skip

	ld a, [wCurDamage]
	ld b, a
	ld a, [wCurDamage + 1]
	ld c, a
.skip
	ld a, c
	ld [hld], a
	ld [wCurHPAnimNewHP], a
	ld a, b
	ld [hli], a
	ld [wCurHPAnimNewHP + 1], a
	ret

BattleCommand_BellyDrum:
; bellydrum
	ld a, [AttackMissed]
	and a
	jr nz, .failed

	callba GetHalfMaxHP
	callba CheckUserHasEnoughHP
	jr nc, .failed

	push bc
	call BattleCommand_AttackUp2
	pop bc
	ld a, [AttackMissed]
	and a
	jr nz, .failed

	call AnimateCurrentMove
	callba SubtractHPFromUser
	call UpdateUserInParty
	ld a, 5

.max_attack_loop
	push af
	call BattleCommand_AttackUp2
	pop af
	dec a
	jr nz, .max_attack_loop

	xor a
	ld [AttackMissed], a
	ld hl, BellyDrumText
	jp StdBattleTextBox

.failed
	call AnimateFailedMove
	jp PrintButItFailed

BattleCommand_DefrostFoe:
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	and $3f
	cp FIRE
	ret nz

	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	and a
	jp nz, Defrost
	ret

BattleCommand_LaughingGas:
	ld a, [AttackMissed]
	and a
	ret nz
	xor a
	ld [EffectFailed], a
	call ResetMiss
	call BattleCommand_AttackDown
	call BattleCommand_StatDownMessage

	call ResetMiss
	call BattleCommand_SpecialAttackDown
	jp BattleCommand_StatDownMessage

InAPinchBoost:
	call GetUserAbility
	ld b, a
	ld hl, TypeBoostAbilities
.loop
	ld a, [hli]
	cp -1
	ret z
	cp b
	jr z, .found
	inc hl
	jr .loop
.found
	ld a, [wTypeMatchup]
	cp [hl]
	ret nz
	callba GetThirdMaxHP
	ld hl, BattleMonHP
	ld a, [hBattleTurn]
	and a
	jr z, .okay
	ld hl, EnemyMonHP
.okay
	ld a, [hli]
	cp b
	jr c, AddHalfDamage
	ret nz
	ld a, [hl]
	cp c
	jr c, AddHalfDamage
	ret nz
AddHalfDamage:
	ld hl, wCurDamageShiftCount
	dec [hl]
TripleDamageModifier:
	; also easy to repurpose as x1.5 and x0.75 by decrementing wCurDamageShiftCount before or after the call
	push hl
	push de
	push bc
	ld hl, wCurDamageModifierNumerator
	ld a, [hli]
	ld d, a
	ld e, 0
	ld a, [hli]
	push hl
	ld l, [hl]
	ld h, a
	ld b, h
	ld c, l
	sla c
	rl b
	rl e
	add hl, bc
	ld b, h
	ld a, l
	pop hl
	ld [hld], a
	ld a, b
	ld [hld], a
	ld a, e
	adc d
	add a, d
	add a, d
	ld [hl], a
	pop bc
	pop de
	pop hl
	jp SetDamageDirtyFlag

INCLUDE "battle/ai/switch.asm"
INCLUDE "battle/effects/bulkup.asm"
INCLUDE "battle/effects/nightmare.asm"
INCLUDE "battle/effects/metallurgy.asm"
INCLUDE "battle/effects/prismspray.asm"
INCLUDE "battle/effects/attract.asm"
INCLUDE "battle/effects/curse.asm"
INCLUDE "battle/effects/protect.asm"
INCLUDE "battle/effects/endure.asm"
INCLUDE "battle/effects/spikes.asm"
INCLUDE "battle/effects/foresight.asm"
INCLUDE "battle/effects/perish_song.asm"
INCLUDE "battle/effects/final_chance.asm"
INCLUDE "battle/effects/sandstorm.asm"
INCLUDE "battle/effects/rollout.asm"
INCLUDE "battle/effects/futuresight.asm"
INCLUDE "battle/effects/thief.asm"
