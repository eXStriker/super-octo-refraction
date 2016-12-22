BattleCommand_PrismSpray:
; prismspray
	ld c, 40
	call DelayFrames

.rejection_sampling
	call BattleRandom
	and $1f
	cp TYPES_END
	jr nc, .rejection_sampling
	cp UNUSED_TYPES
	jr c, .okay
	cp UNUSED_TYPES_END
	jr c, .rejection_sampling
	cp BIRD
	jr z, .rejection_sampling
.okay
	ld b, a
	ld hl, wPlayerMoveStructType
	ld a, [hBattleTurn]
	and a
	jr z, .got_addr
	ld hl, wEnemyMoveStructType
.got_addr
	ld a, b
	ld [hl], a
	ld [wd265], a
	predef GetTypeName
	ld hl, PrismSprayText
	jp StdBattleTextBox
