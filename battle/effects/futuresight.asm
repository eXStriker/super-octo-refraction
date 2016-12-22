BattleCommand_CheckFutureSight: ; 37d0d
; checkfuturesight

	ld hl, wPlayerFutureSightCount
	ld de, wPlayerFutureSightUsersSpAtk
	ld a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wEnemyFutureSightCount
	ld de, wEnemyFutureSightUsersSpAtk
.ok

	ld a, [hl]
	and a
	ret z
	cp 1
	ret nz

	ld [hl], 0
	ld a, [de]
	inc de
	ld [wCurDamageFixedValue], a
	ld a, [de]
	ld [wCurDamageFixedValue + 1], a
	ld a, $c0 ;fixed damage, dirty
	ld [wCurDamageFlags], a
	ld b, futuresight_command
	jp SkipToBattleCommand

; 37d34

BattleCommand_FutureSight: ; 37d34
; futuresight

	call CheckUserIsCharging
	jr nz, .AlreadyChargingFutureSight
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld b, a
	ld a, BATTLE_VARS_LAST_COUNTER_MOVE
	call GetBattleVarAddr
	ld [hl], b
	ld a, BATTLE_VARS_LAST_MOVE
	call GetBattleVarAddr
	ld [hl], b
.AlreadyChargingFutureSight:
	ld hl, wPlayerFutureSightCount
	ld de, BattleMonLevel
	ld a, [hBattleTurn]
	and a
	jr z, .GotFutureSightCount
	ld hl, wEnemyFutureSightCount
	ld de, EnemyMonLevel
.GotFutureSightCount:
	ld a, [hl]
	and a
	jr nz, .failed
	ld a, 4
	ld [hli], a
	ld a, [de]
	ld [hl], a
	ld de, BattleMonType1
	ld a, [hBattleTurn]
	and a
	jr z, .got_types
	ld de, EnemyMonType1
.got_types
	ld a, [de]
	cp PSYCHIC
	jr z, .stab
	inc de
	ld a, [de]
	cp PSYCHIC
	jr nz, .no_stab
.stab
	set 7, [hl]
.no_stab
	call BattleCommand_LowerSub
	call BattleCommand_MoveDelay
	ld hl, ForesawAttackText
	call StdBattleTextBox
	call BattleCommand_RaiseSub
	ld hl, BattleMonSpclAtk
	ld de, wPlayerFutureSightUsersSpAtk
	ld a, [hBattleTurn]
	and a
	jr z, .StoreDamage
	ld hl, EnemyMonSpclAtk
	ld de, wEnemyFutureSightUsersSpAtk
.StoreDamage:
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	jp EndMoveEffect

.failed
	pop bc
	call ResetDamage
	call AnimateFailedMove
	call PrintButItFailed
	jp EndMoveEffect

; 37d94
