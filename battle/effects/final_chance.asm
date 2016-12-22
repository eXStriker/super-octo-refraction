BattleCommand_FinalChance:
; finalchance

	ld hl, wPlayerSubStatus1
	ld de, PlayerPerishCount
	ld a, [hBattleTurn]
	and a
	jr z, .got_addrs
	ld hl, wEnemySubStatus1
	ld de, EnemyPerishCount
.got_addrs
	bit SUBSTATUS_PERISH, [hl]
	jr nz, .failed
	inc hl
	bit SUBSTATUS_FINAL_CHANCE, [hl]
	jr nz, .failed
	set SUBSTATUS_FINAL_CHANCE, [hl]
	dec hl
	set SUBSTATUS_PERISH, [hl]
	
	ld a, 4
	ld [de], a
	call AnimateCurrentMove
	ld hl, StartFinalChanceText
	jp StdBattleTextBox

.failed
	call AnimateFailedMove
	jp PrintButItFailed
