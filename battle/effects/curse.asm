BattleCommand_Curse: ; 37588
; curse

	ld de, BattleMonType1
	ld bc, PlayerStatLevels
	ld a, [hBattleTurn]
	and a
	jr z, .go
	ld de, EnemyMonType1
	ld bc, EnemyStatLevels

.go

; Curse is different for Ghost-types.

	ld a, [de]
	cp GHOST
	jr z, .ghost
	inc de
	ld a, [de]
	cp GHOST
	jr z, .ghost


; If no stats can be increased, don't.

; Attack
	ld a, [bc]
	cp MAX_STAT_LEVEL
	jr c, .raise

; Defense
	inc bc
	ld a, [bc]
	cp MAX_STAT_LEVEL
	jr nc, .cantraise

.raise

; Raise Attack and Defense, and lower Speed.

	ld a, $1
	ld [wBattleAnimParam], a
	call AnimateCurrentMove
	call SwitchTurn
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVarAddr
	ld [hl], CURSE
	call BattleCommand_SpeedDown
	call BattleCommand_StatDownMessage
	call ResetMiss
	call SwitchTurn
	call BattleCommand_AttackUp
	call BattleCommand_StatUpMessage
	call ResetMiss
	call BattleCommand_DefenseUp
	jp BattleCommand_StatUpMessage


.ghost

; Cut HP in half and put a curse on the opponent.

	call CheckHiddenOpponent
	jr nz, .failed

	call CheckSubstituteOpp
	jr nz, .failed

	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVarAddr
	bit SUBSTATUS_CURSE, [hl]
	jr nz, .failed

	set SUBSTATUS_CURSE, [hl]
	call AnimateCurrentMove
	callba GetHalfMaxHP
	callba SubtractHPFromUser
	call UpdateUserInParty
	ld hl, PutACurseText
	jp StdBattleTextBox

.failed
	call AnimateFailedMove
	jp PrintButItFailed


.cantraise

; Can't raise either stat.

	ld b, ABILITY + 1
	call GetStatName
	call AnimateFailedMove
	ld hl, WontRiseAnymoreText
	jp StdBattleTextBox
; 37618