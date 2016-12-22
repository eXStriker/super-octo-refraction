HiddenPowerDamage:
; Override Hidden Power's type and power based on the user's DVs.

	ld hl, BattleMonDVs
	ld a, [hBattleTurn]
	and a
	jr z, .got_dvs
	ld hl, EnemyMonDVs
.got_dvs

; Type:

	; Def & 3
	ld a, [hl]
	and 3
	ld b, a

	; + (Atk & 3) << 2
	ld a, [hl]
	and 3 << 4
	rrca
	rrca
	or b

; Skip Normal
	inc a

; Skip Bird
	cp BIRD
	jr c, .done
	inc a

; Skip unused types
	cp UNUSED_TYPES
	jr c, .done
	add UNUSED_TYPES_END - UNUSED_TYPES

.done

; Overwrite the current move type.
	push af
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVarAddr
	and $3f
	pop af
	ld [hl], a

; Get the rest of the damage formula variables
; based on the new type, but keep base power.
	push af
	callba BattleCommand_DamageStats ; damagestats
	pop af
	ld hl, wCurDamageMovePowerNumerator
	xor a
	ld [hli], a
	ld a, 60 ;constant power 60, no longer calculated
	ld [hli], a
	; hl = wCurDamageMovePowerDenominator
	ld [hl], 1
	jp SetDamageDirtyFlag
