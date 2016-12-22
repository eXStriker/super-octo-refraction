BattleCommand_UsedMoveText:
; battle command 03
	ld hl, UsedMoveText
	call BattleTextBox
	jp ApplyTilemapInVBlank

UsedMoveText:
; this is a stream of text and asm
	text_far _ActorNameText
	start_asm
	ld a, [hBattleTurn]
	and a
	jr nz, .start

	ld a, [wPlayerMoveStruct + MOVE_ANIM]
	call UpdateUsedMoves

.start
	ld a, BATTLE_VARS_LAST_MOVE
	call GetBattleVarAddr
	ld d, h
	ld e, l

	ld a, BATTLE_VARS_LAST_COUNTER_MOVE
	call GetBattleVarAddr

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld [wd265], a

	push hl
	call CheckUserIsCharging
	pop hl
	jr nz, .userIsCharging

	; update last move
	ld a, [wd265]
	ld [hl], a
	ld [de], a
.userIsCharging
; no more useless grammar code

; check obedience
	ld a, [AlreadyDisobeyed]
	and a
	ld hl, .MoveNameText
	ret z
	ld hl, .UsedInsteadText
	ret

.UsedInsteadText
	text_jump _UsedInsteadText

.MoveNameText
	text_jump _MoveNameText

UpdateUsedMoves:
; append move a to PlayerUsedMoves unless it has already been used

	push bc
; start of list
	ld hl, PlayerUsedMoves
; get move id
	ld b, a
; next count
	ld c, NUM_MOVES

.loop
; get move from the list
	ld a, [hli]
; not used yet?
	and a
	jr z, .add
; already used?
	cp b
	jr z, .quit
; next byte
	dec c
	jr nz, .loop

; if the list is full and the move hasn't already been used
; shift the list back one byte, deleting the first move used
; this can occur with struggle or a new learned move
	ld hl, PlayerUsedMoves + 1
; 1 = 2
	ld a, [hld]
	ld [hli], a
; 2 = 3
	inc hl
	ld a, [hld]
	ld [hli], a
; 3 = 4
	inc hl
	ld a, [hld]
	ld [hli], a
; 4 = new move
	ld [hl], b
	jr .quit

.add
; go back to the byte we just inced from
	dec hl
; add the new move
	ld [hl], b

.quit
; list updated
	pop bc
	ret
