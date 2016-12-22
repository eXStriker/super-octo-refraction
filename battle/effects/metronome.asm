BattleCommand_Metronome:
; metronome

	call ClearLastMove
	call CheckUserIsCharging
	jr nz, .userIsCharging

	ld a, [wBattleAnimParam]
	push af
	callba BattleCommand_LowerSub
	pop af
	ld [wBattleAnimParam], a

.userIsCharging
	callba LoadMoveAnim

.GetMove
	call BattleRandom

; No invalid moves.
	cp NUM_ATTACKS + 1
	jr nc, .GetMove

; None of the moves in MetronomeExcepts.
	push af
	ld hl, MetronomeExcepts
	call IsInSingularArray
	pop bc
	jr c, .GetMove

; No moves the user already has.
	ld a, b
	call CheckUserMove
	jr z, .GetMove

	ld a, BATTLE_VARS_MOVE
	call GetBattleVarAddr
	ld [hl], b
	jp UpdateMoveDataAndResetTurn

MetronomeExcepts:
	db NO_MOVE
	db METRONOME
	db STRUGGLE
	db COUNTER
	db PROTECT
	db ENDURE
	db DESTINY_BOND
	db SLEEP_TALK
	db THIEF
	db -1
