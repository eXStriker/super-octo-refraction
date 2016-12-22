BattleCommand_MirrorMove:
; mirrormove

	call ClearLastMove

	ld a, BATTLE_VARS_MOVE
	call GetBattleVarAddr

	ld a, BATTLE_VARS_LAST_COUNTER_MOVE_OPP
	call GetBattleVar
	and a
	jr z, .failed

	call CheckUserMove
	jr z, .failed
	ld a, b
	ld [hl], a
	ld [wd265], a

	push af
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVarAddr
	ld d, h
	ld e, l
	pop af

	dec a
	ld b, a
	callba GetMoveData
	call GetMoveName
	call CopyName1
	call CheckUserIsCharging
	jr nz, .done

	ld a, [wBattleAnimParam]
	push af
	callba BattleCommand_LowerSub
	pop af
	ld [wBattleAnimParam], a

.done
	call BattleCommand_MoveDelay
	jp ResetTurn

.failed
	callba AnimateFailedMove

	ld hl, MirrorMoveFailedText
	call StdBattleTextBox
	jp EndMoveEffect
