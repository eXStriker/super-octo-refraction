ConsumeHeldItem: ; 27192
	push hl
	push de
	push bc
	call .ConsumeHeldItem
	pop bc
	pop de
	pop hl
	ret
	
.ConsumeHeldItem:
	ld a, [hBattleTurn]
	and a
	ld bc, OTPartyMon1Item
	ld hl, EnemyMonItem
	ld de, EnemyAbility
	ld a, [CurOTMon]
	jr z, .theirturn
	ld bc, PartyMon1Item
	ld hl, BattleMonItem
	ld de, PlayerAbility
	ld a, [CurBattleMon]

.theirturn
	push bc
	push af
	push hl
	call GetItemHeldEffect ; this is in ROM0
	ld a, b
	ld hl, .ConsumableEffects
	call IsInSingularArray
	jr nc, .nonConsumable
	pop hl
	ld [hl], $0
	pop af
	pop hl
	call GetPartyLocation
	ld a, [hBattleTurn]
	and a
	jr nz, .ourturn
	ld a, [wBattleMode]
	dec a
	ret z

.ourturn
	ld [hl], $0
	ret

.nonConsumable
	add sp, $6
	ret

.ConsumableEffects: ; 271de
; Consumable items?
	db HELD_BERRY
	db HELD_2
	db HELD_5
	db HELD_HEAL_POISON
	db HELD_HEAL_FREEZE
	db HELD_HEAL_BURN
	db HELD_HEAL_SLEEP
	db HELD_HEAL_PARALYZE
	db HELD_HEAL_STATUS
	db HELD_30
	db HELD_ATTACK_UP
	db HELD_DEFENSE_UP
	db HELD_SPEED_UP
	db HELD_SP_ATTACK_UP
	db HELD_SP_DEFENSE_UP
	db HELD_ACCURACY_UP
	db HELD_EVASION_UP
	db HELD_38
	db HELD_71
	db HELD_ESCAPE
	db HELD_CRITICAL_UP
	db $ff
