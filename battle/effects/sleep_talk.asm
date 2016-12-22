BattleCommand_SleepTalk:
; sleeptalk

	call ClearLastMove
	ld a, [AttackMissed]
	and a
	jr nz, .fail
	ld a, [hBattleTurn]
	and a
	ld hl, BattleMonMoves + 1
	ld a, [DisabledMove]
	ld d, a
	jr z, .got_moves
	ld hl, EnemyMonMoves + 1
	ld a, [EnemyDisabledMove]
	ld d, a
.got_moves
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and SLP
	jr z, .fail
	ld a, [hl]
	and a
	jr z, .fail
	call SleepTalk_ProtectedCheckUsableMove
	jr c, .fail
	dec hl
.sample_move
	push hl
	call BattleRandom
	and 3 ; TODO factor in NUM_MOVES
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	pop hl
	and a
	jr z, .sample_move
	ld e, a
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp e
	jr z, .sample_move
	ld a, e
	cp d
	jr z, .sample_move
	call SleepTalk_CheckTwoTurnMove
	jr z, .sample_move
	ld a, BATTLE_VARS_MOVE
	call GetBattleVarAddr
	ld a, e
	ld [hl], a
	call CheckUserIsCharging
	jr nz, .charging
	ld a, [wBattleAnimParam]
	push af
	callba BattleCommand_LowerSub
	pop af
	ld [wBattleAnimParam], a
.charging
	callba LoadMoveAnim
	jp UpdateMoveDataAndResetTurn
.fail
	callba AnimateFailedMove
	jp TryPrintButItFailed

SleepTalk_ProtectedCheckUsableMove:
	push hl
	push de
	push bc
	call SleepTalk_CheckUsableMove
	pop bc
	pop de
	pop hl
	ret

SleepTalk_CheckUsableMove:
	ld a, [hBattleTurn]
	and a
	ld a, [DisabledMove]
	jr z, .gotPlayerMove

	ld a, [EnemyDisabledMove]
.gotPlayerMove
	ld b, a
	ld a, BATTLE_VARS_MOVE
	call GetBattleVar
	ld c, a
	dec hl
	ld d, NUM_MOVES
; b = disabled move
; c = cur player move (always sleep talk)?
.loop
	ld a, [hl]
	and a
	jr z, .failure

	cp c
	jr z, .nope
	cp b
	jr z, .nope

	call SleepTalk_CheckTwoTurnMove
	jr nz, .success
.nope
	inc hl
	dec d
	jr nz, .loop
.failure
	scf
	ret
.success
	and a
	ret

SleepTalk_CheckTwoTurnMove:
	push hl
	push de
	push bc

	ld b, a
	callba GetMoveEffect
	ld a, b

	pop bc
	pop de
	pop hl

	cp EFFECT_RAZOR_WIND
	ret z
	cp EFFECT_SKY_ATTACK
	ret z
	cp EFFECT_SOLARBEAM
	ret z
	cp EFFECT_FLY
	ret
