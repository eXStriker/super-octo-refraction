BattleCommand_Burn:
; burn
	ld hl, DoesntAffectText
	ld a, [TypeModifier]
	and $7f
	jr z, .failed

	call CheckIfTargetIsFireType
	jr z, .failed

	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	ld b, a
	ld hl, AlreadyBurnedText
	and 1 << BRN
	jr nz, .failed

	call GetOpponentItem
	ld a, b
	cp HELD_PREVENT_BURN
	jr nz, .do_burn
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	ld hl, ProtectedByText
.failed
	push hl
	callba AnimateFailedMove
	pop hl
	jp StdBattleTextBox

.do_burn
	ld hl, DidntAffect1Text
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and a
	jr nz, .failed
	call CheckSubstituteOpp
	jr nz, .failed
	ld a, [AttackMissed]
	and a
	jr nz, .failed
	call GetTargetAbility
	cp ABILITY_WATER_VEIL
	jr z, .failed
	cp ABILITY_LEAF_GUARD
	jr nz, .not_leaf_guard
	call CheckAbilityNegatesWeather
	jr z, .not_leaf_guard
	ld a, [Weather]
	cp WEATHER_SUN
	jr z, .failed
.not_leaf_guard

	callba AnimateCurrentMove
	call BurnOpponent
	call RefreshBattleHuds
	ld hl, WasBurnedText
	call StdBattleTextBox
	jpba BattleCommand_Synchronize

CheckIfTargetIsFireType:
	ld de, EnemyMonType1
	ld a, [hBattleTurn]
	and a
	jr z, .ok
	ld de, BattleMonType1
.ok
	ld a, [de]
	inc de
	cp FIRE
	ret z
	ld a, [de]
	cp FIRE
	ret

BurnOpponent:
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	set BRN, [hl]
	jp UpdateOpponentInParty
