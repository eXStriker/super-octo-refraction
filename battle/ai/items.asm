AI_SwitchOrTryItem:
	and a

	ld a, [wBattleMode]
	dec a
	ret z

	ld a, [wLinkMode]
	and a
	ret nz

	callba CheckSubStatus_RechargeChargedRampageBideRollout
	ret nz

	ld a, [wPlayerSubStatus5]
	bit SUBSTATUS_CANT_RUN, a
	jr nz, .dont_switch

	ld a, [wEnemySubStatus2]
	bit SUBSTATUS_FINAL_CHANCE, a
	jr nz, .dont_switch

	ld a, [wEnemyWrapCount]
	and a
	jr nz, .dont_switch

	callba CheckPlayerArenaTrap
	jr z, .dont_switch

	ld hl, TrainerClassAttributes + TRNATTR_AI_ITEM_SWITCH
	ld a, [InBattleTowerBattle] ; Load always the first TrainerClass for BattleTower-Trainers
	bit 0, a
	jr nz, .ok

	ld a, [TrainerClass]
	dec a
	ld bc, 7
	rst AddNTimes
.ok
	bit SWITCH_OFTEN_F, [hl]
	jr nz, SwitchOften
	bit SWITCH_RARELY_F, [hl]
	jr nz, SwitchRarely
	bit SWITCH_SOMETIMES_F, [hl]
	jr nz, SwitchSometimes
.dont_switch
	jp AI_TryItem

SwitchOften:
	call AI_GetSwitchParam
	jp z, AI_TryItem

	dec a
	jr nz, .not_10
	call Random
	add a, a
	jr AI_CheckSwitch
.not_10

	dec a
	jr nz, .not_20
	call Random
	cp 1 + 20 percent
	jr AI_CheckSwitch
.not_20

	; $30
	call Random
	cp 4 percent
	jr AI_CheckSwitch

SwitchRarely:
	call AI_GetSwitchParam
	jr z, AI_TryItem

	dec a
	jr nz, .not_10
	call Random
	cp 92 percent
	jr AI_CheckSwitch
.not_10

	dec a
	jr nz, .not_20
	call Random
	cp 88 percent
	jr AI_CheckSwitch
.not_20

	; $30
	call Random
	cp -1 + 79 percent
	jr AI_CheckSwitch

AI_GetSwitchParam:
	callba CheckAbleToSwitch
	ld a, [wEnemySwitchMonParam]
	swap a
	and $f
	ret

SwitchSometimes:
	call AI_GetSwitchParam
	jr z, AI_TryItem

	dec a
	jr nz, .not_10
	call Random
	cp 1 + 80 percent
	jr AI_CheckSwitch
.not_10

	dec a
	jr nz, .not_20
	call Random
	add a, a
	jr AI_CheckSwitch
.not_20

	; $30
	call Random
	cp -1 + 20 percent
	; fallthrough

AI_CheckSwitch:
	jr c, AI_TryItem

	ld a, [wEnemySwitchMonParam]
	and $f
	inc a
	; In register 'a' is the number (1-6) of the Pkmn to switch to
	ld [wEnemySwitchMonIndex], a
	jp AI_TrySwitch

CheckSubStatusCantRun:
	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_CANT_RUN, a
	ret nz
	ld a, [wPlayerSubStatus2]
	bit SUBSTATUS_FINAL_CHANCE, a
	ret

AI_TryItem:
	; items are not allowed in the BattleTower
	ld a, [InBattleTowerBattle]
	and 5
	ret nz

	ld a, [wEnemyTrainerItem1]
	ld b, a
	ld a, [wEnemyTrainerItem2]
	or b
	ret z

	call .IsHighestLevel
	ret nc

	ld a, [TrainerClass]
	dec a
	ld hl, TrainerClassAttributes + 5
	ld bc, 7
	rst AddNTimes
	ld b, h
	ld c, l
	ld hl, AI_Items
	ld de, wEnemyTrainerItem1
.loop
	ld a, [hl]
	and a
	inc a
	ret z

	ld a, [de]
	cp [hl]
	jr z, .has_item
	inc de
	ld a, [de]
	cp [hl]
	jr z, .has_item

	dec de
	inc hl
	inc hl
	inc hl
	jr .loop

.has_item
	inc hl

	push hl
	push de
	call CallLocalPointer
	pop de
	pop hl

	inc hl
	inc hl
	jr c, .loop

.used_item
	xor a
	ld [de], a
	ld [EnemyFuryCutterCount], a
	ld [EnemyProtectCount], a
	ld [LastPlayerCounterMove], a
	inc a
	ld [wEnemyGoesFirst], a

	ld hl, wEnemySubStatus4
	res SUBSTATUS_RAGE, [hl]

	scf
	ret

.IsHighestLevel
	ld a, [OTPartyCount]
	ld d, a
	ld e, 0
	ld hl, OTPartyMon1Level
	ld bc, PARTYMON_STRUCT_LENGTH
.next
	ld a, [hl]
	cp e
	jr c, .ok
	ld e, a
.ok
	add hl, bc
	dec d
	jr nz, .next

	ld a, [CurOTMon]
	ld hl, OTPartyMon1Level
	rst AddNTimes
	ld a, [hl]
	cp e
	ccf
	ret

AI_Items:
	dbw FULL_RESTORE, .FullRestore
	dbw MAX_POTION,   .MaxPotion
	dbw HYPER_POTION, .HyperPotion
	dbw SUPER_POTION, .SuperPotion
	dbw POTION,       .Potion
	dbw X_ACCURACY,   .XAccuracy
	dbw FULL_HEAL,    .FullHeal
	dbw GUARD_SPEC,   .GuardSpec
	dbw DIRE_HIT,     .DireHit
	dbw X_ATTACK,     .XAttack
	dbw X_DEFEND,     .XDefend
	dbw X_SPEED,      .XSpeed
	dbw X_SPECIAL,    .XSpecial
	db $ff

.FullHeal
	call .Status
	ret c
	call EnemyUsedFullHeal
	and a
	ret

.Status
	ld a, [EnemyMonStatus]
	and a
	scf
	ret z

	ld a, [bc]
	bit CONTEXT_USE_F, a
	jr nz, .StatusCheckContext
	ld a, [bc]
	bit ALWAYS_USE_F, a
	jr nz, .use_2
	call Random
	cp -1 + 20 percent
	ccf
	ret

.StatusCheckContext
	ld a, [EnemyMonSemistatus]
	bit SEMISTATUS_TOXIC, a
	jr z, .FailToxicCheck
	ld a, [EnemyToxicCount]
	cp 4
	jr c, .FailToxicCheck
	call Random
	add a, a
	ret c
.FailToxicCheck
	ld a, [EnemyMonStatus]
	and 1 << FRZ | SLP
	ret nz ;and clears carry
	scf
	ret

.FullRestore
	call .HealItem
	jr nc, .UseFullRestore
	ld a, [bc]
	bit CONTEXT_USE_F, a
	scf
	ret z
	call .Status
	ret c

.UseFullRestore
	call EnemyUsedFullRestore
	and a
	ret

.MaxPotion
	call .HealItem
	ret c
	call EnemyUsedMaxPotion
	and a
	ret

.HealItem
	ld a, [bc]
	bit CONTEXT_USE_F, a
	jr nz, .CheckHalfOrQuarterHP
	callba AICheckEnemyHalfHP
	ret c
	ld a, [bc]
	bit UNKNOWN_USE_F, a
	jr nz, .CheckQuarterHP
	callba AICheckEnemyQuarterHP
	ret nc
	call Random
	add a, a
	ccf
	ret

.CheckQuarterHP
	callba AICheckEnemyQuarterHP
	ret c
	call Random
	cp -1 + 20 percent
	ret

.CheckHalfOrQuarterHP
	callba AICheckEnemyHalfHP
	ret c
	callba AICheckEnemyQuarterHP
	ret nc
	call Random
	cp -1 + 20 percent
	ccf
	ret

.HyperPotion
	call .HealItem
	ret c
	ld b, 200
	call EnemyUsedHyperPotion
.use_2
	jr .Use

.SuperPotion
	call .HealItem
	ret c
	ld b, 50
	call EnemyUsedSuperPotion
	jr .Use

.Potion
	call .HealItem
	ret c
	ld b, 20
	call EnemyUsedPotion
	jr .Use

.XAccuracy
	call .XItem
	ret c
	call EnemyUsedXAccuracy
	jr .Use

.GuardSpec
	call .XItem
	ret c
	call EnemyUsedGuardSpec
	jr .Use

.DireHit
	call .XItem
	ret c
	call EnemyUsedDireHit
	jr .Use

.XAttack
	call .XItem
	ret c
	call EnemyUsedXAttack
	jr .Use

.XDefend
	call .XItem
	ret c
	call EnemyUsedXDefend
	jr .Use

.XSpeed
	call .XItem
	ret c
	call EnemyUsedXSpeed
	jr .Use

.XSpecial
	call .XItem
	ret c
	call EnemyUsedXSpecial
	jr .Use

.XItem
	ld a, [EnemyTurnsTaken]
	and a
	jr nz, .notfirstturnout
	ld a, [bc]
	bit ALWAYS_USE_F, a
	ret nz ;carry is cleared here (due to and a)
	call Random
	add a, a
	ret c
	ld a, [bc]
	bit CONTEXT_USE_F, a
	ret nz ;carry is cleared here (due to ret c above)
	call Random
	add a, a
	ret
.notfirstturnout
	ld a, [bc]
	bit ALWAYS_USE_F, a
	jr z, .complement_carry ;carry is cleared here (due to and a)
	call Random
	cp -1 + 20 percent
.complement_carry
	ccf
	ret

.Use
	and a
	ret

AIUpdateHUD:
	call UpdateEnemyMonInParty
	callba UpdateEnemyHUD
	ld a, $1
	ld [hBGMapMode], a
	ld hl, wEnemyItemState
	dec [hl]
	scf
	ret

AIUsedItemSound:
	push de
	ld de, SFX_FULL_HEAL
	call PlaySFX
	pop de
	ret

EnemyUsedFullHeal:
	call AIUsedItemSound
	call AI_HealStatus
	ld a, FULL_HEAL
	jp PrintText_UsedItemOn_AND_AIUpdateHUD

EnemyUsedMaxPotion:
	ld a, MAX_POTION
	ld [wAI_CurrentItem], a
	jr FullRestoreContinue

EnemyUsedFullRestore:
	call AI_HealStatus
	ld a, FULL_RESTORE
	ld [wAI_CurrentItem], a
	ld hl, wEnemySubStatus3
	res SUBSTATUS_CONFUSED, [hl]
	xor a
	ld [EnemyConfuseCount], a

FullRestoreContinue:
	ld de, wCurHPAnimOldHP
	ld hl, EnemyMonHP + 1
	ld a, [hld]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	ld hl, EnemyMonMaxHP + 1
	ld a, [hld]
	ld [de], a
	inc de
	ld [wCurHPAnimMaxHP], a
	ld [EnemyMonHP + 1], a
	ld a, [hl]
	ld [de], a
	ld [wCurHPAnimMaxHP + 1], a
	ld [EnemyMonHP], a
	jr EnemyPotionFinish

EnemyUsedPotion:
	ld a, POTION
	ld b, 20
	jr EnemyPotionContinue

EnemyUsedSuperPotion:
	ld a, SUPER_POTION
	ld b, 50
	jr EnemyPotionContinue

EnemyUsedHyperPotion:
	ld a, HYPER_POTION
	ld b, 200

EnemyPotionContinue:
	ld [wAI_CurrentItem], a
	ld hl, EnemyMonHP + 1
	ld a, [hl]
	ld [wCurHPAnimOldHP], a
	add b
	ld [hld], a
	ld [wCurHPAnimNewHP], a
	ld a, [hl]
	ld [wCurHPAnimOldHP + 1], a
	ld [wCurHPAnimNewHP + 1], a
	jr nc, .ok
	inc a
	ld [hl], a
	ld [wCurHPAnimNewHP + 1], a
.ok
	inc hl
	ld a, [hld]
	ld b, a
	ld de, EnemyMonMaxHP + 1
	ld a, [de]
	dec de
	ld [wCurHPAnimMaxHP], a
	sub b
	ld a, [hli]
	ld b, a
	ld a, [de]
	ld [wCurHPAnimMaxHP + 1], a
	sbc b
	jr nc, EnemyPotionFinish
	inc de
	ld a, [de]
	dec de
	ld [hld], a
	ld [wCurHPAnimNewHP], a
	ld a, [de]
	ld [hl], a
	ld [wCurHPAnimNewHP + 1], a

EnemyPotionFinish:
	call PrintText_UsedItemOn
	hlcoord 2, 2
	xor a
	ld [wWhichHPBar], a
	call AIUsedItemSound
	predef AnimateHPBar
	jp AIUpdateHUD

AI_TrySwitch:
; Determine whether the AI can switch based on how many Pokemon are still alive.
; If it can switch, it will.
	ld a, [OTPartyCount]
	ld c, a
	ld hl, OTPartyMon1HP
	ld d, 0
.SwitchLoop
	ld a, [hli]
	ld b, a
	ld a, [hld]
	or b
	jr z, .fainted
	inc d
.fainted
	push bc
	ld bc, PARTYMON_STRUCT_LENGTH
	add hl, bc
	pop bc
	dec c
	jr nz, .SwitchLoop

	ld a, d
	cp 2
	ccf
	ret nc
	; fallthrough

AI_Switch:
	ld a, $1
	ld [wEnemyIsSwitching], a
	ld [wEnemyGoesFirst], a
	ld hl, wEnemySubStatus4
	res SUBSTATUS_RAGE, [hl]
	xor a
	ld [hBattleTurn], a
	callba PursuitSwitch

	push af
	ld a, [CurOTMon]
	ld hl, OTPartyMon1Status
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld d, h
	ld e, l
	ld hl, EnemyMonStatus
	ld bc, MON_MAXHP - MON_STATUS
	rst CopyBytes
	pop af

	jr c, .skiptext
	ld hl, TextJump_EnemyWithdrew
	call PrintText

.skiptext
	ld a, 1
	ld [wBattleHasJustStarted], a
	callba NewEnemyMonStatus
	callba ResetEnemyStatLevels
	ld hl, wPlayerSubStatus1
	res SUBSTATUS_IN_LOVE, [hl]
	callba EnemySwitch
	callba ResetBattleParticipants
	xor a
	ld [wBattleHasJustStarted], a
	ld a, [wLinkMode]
	and a
	ret nz
	scf
	ret

TextJump_EnemyWithdrew:
	text_jump Text_EnemyWithdrew

AI_HealStatus:
	ld a, [CurOTMon]
	ld hl, OTPartyMon1Status
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	xor a
	ld [hl], a
	ld [EnemyMonStatus], a
	ld hl, EnemyMonSemistatus
	res SEMISTATUS_TOXIC, [hl]
	ret

EnemyUsedXAccuracy:
	call AIUsedItemSound
	ld hl, wEnemySubStatus4
	set SUBSTATUS_X_ACCURACY, [hl]
	ld a, X_ACCURACY
	jr PrintText_UsedItemOn_AND_AIUpdateHUD

EnemyUsedGuardSpec:
	call AIUsedItemSound
	ld hl, wEnemySubStatus4
	set SUBSTATUS_MIST, [hl]
	ld a, GUARD_SPEC
	jr PrintText_UsedItemOn_AND_AIUpdateHUD

EnemyUsedDireHit:
	call AIUsedItemSound
	ld hl, wEnemySubStatus4
	set SUBSTATUS_FOCUS_ENERGY, [hl]
	ld a, DIRE_HIT
	jr PrintText_UsedItemOn_AND_AIUpdateHUD

EnemyUsedXAttack:
	ld b, ATTACK
	ld a, X_ATTACK
	jr EnemyUsedXItem

EnemyUsedXDefend:
	ld b, DEFENSE
	ld a, X_DEFEND
	jr EnemyUsedXItem

EnemyUsedXSpeed:
	ld b, SPEED
	ld a, X_SPEED
	jr EnemyUsedXItem

EnemyUsedXSpecial:
	ld b, SP_ATTACK
	ld a, X_SPECIAL

; Parameter
; a = ITEM_CONSTANT
; b = BATTLE_CONSTANT (ATTACK, DEFENSE, SPEED, SP_ATTACK, SP_DEFENSE, ACCURACY, EVASION)
EnemyUsedXItem:
	ld [wAI_CurrentItem], a
	push bc
	call PrintText_UsedItemOn
	pop bc
	callba CheckIfStatCanBeRaised
	jp AIUpdateHUD

; Parameter
; a = ITEM_CONSTANT
PrintText_UsedItemOn_AND_AIUpdateHUD:
	ld [wAI_CurrentItem], a
	call PrintText_UsedItemOn
	jp AIUpdateHUD

PrintText_UsedItemOn:
	ld a, [wAI_CurrentItem]
	ld [wd265], a
	call GetItemName
	ld hl, wStringBuffer1
	ld de, wMonOrItemNameBuffer
	ld bc, ITEM_NAME_LENGTH
	rst CopyBytes
	ld hl, TextJump_EnemyUsedOn
	jp PrintText

TextJump_EnemyUsedOn:
	text_jump Text_EnemyUsedOn
