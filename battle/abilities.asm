CalcMonAbility::
; species in [wCurSpecies]
; dvs pointer in hl

; If we're in a link battle with a non-Prism game, disable abilities.
	push bc
	call GetBaseData ; preserves hl
	; Determine the parity of the DVs
	; Use the DVs to determine which of the two abilities to use.
	ld b, 2
	call CountSetBits
	rra
	ld hl, wBaseAbilities ; First 2 bytes of the 4-byte padding
	jr nc, .load
	inc hl
.load
	ld a, [hl]
.single_ability
	pop bc
	ret

INCLUDE "battle/ability_names.asm"
INCLUDE "battle/pickup.asm"
