BattleCommand_Vaporize:
; vaporize
	ld b, WATER
	ld a, 1
	jr BattleCommand_ChangeType

BattleCommand_Metallurgy:
; metallurgy
	ld b, STEEL
	xor a
BattleCommand_ChangeType:
; a: target (0=USER, 1=TARGET)
; b: type

; If not part (type b), change second type to (type b)
; If part (type b), change to pure (type b)
; If pure (type b), the move fails
	push af
	ld hl, hBattleTurn
	xor [hl]
	ld hl, BattleMonType1
	jr z, .ok
	ld hl, EnemyMonType1
.ok
	ld a, [hli]
	cp b
	jr z, .is_primary_steel
	ld a, [hl]
	cp b
	jr nz, .make_secondary_steel
.make_primary_steel
	dec hl
	jr .print_whole

.is_primary_steel
	ld a, [hl]
	cp b
	jr z, .failed
.print_whole
	ld de, 0
	jr .change_type

.make_secondary_steel
	ld de, .PartialTypeTexts - .WholeTypeTexts
.change_type
	ld a, b
	ld [hl], a
	ld [wd265], a
	push de
	predef GetTypeName
	call AnimateCurrentMove
	pop de
	ld hl, .WholeTypeTexts
	add hl, de
	pop af
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp StdBattleTextBox

.failed:
	pop af
	call AnimateFailedMove
	jp PrintButItFailed

.WholeTypeTexts
	dw UserBecameTypeText
	dw TargetBecameTypeText
.PartialTypeTexts
	dw UserBecameTypePartialText
	dw TargetBecameTypePartialText
