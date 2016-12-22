CheckRegisteredItem::
	ld a, [WhichRegisteredItem]
	and a
	jr z, .NoRegisteredItem
	and REGISTERED_POCKET
	rlca
	rlca
	jumptable

.Pockets
	dw .CheckItem
	dw .CheckBall
	dw .CheckKeyItem

.CheckItem
	ld hl, NumItems
	call .CheckRegisteredNo
	jr c, .NoRegisteredItem
	inc hl
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	call .IsSameItem
	jr c, .NoRegisteredItem
	and a
	ret

.CheckKeyItem
	ld a, [RegisteredItem]
	ld hl, KeyItems
	call IsInSingularArray
	jr nc, .NoRegisteredItem
	ld a, [RegisteredItem]
	ld [wCurItem], a
	and a
	ret

.CheckBall
	ld hl, NumBalls
	call .CheckRegisteredNo
	jr nc, .NoRegisteredItem
	inc hl
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	call .IsSameItem
	ret nc
.NoRegisteredItem
	xor a
	ld [WhichRegisteredItem], a
	ld [RegisteredItem], a
	scf
	ret

.CheckRegisteredNo
	ld a, [WhichRegisteredItem]
	and REGISTERED_NUMBER
	dec a
	cp [hl]
	jr nc, .NotEnoughItems
	ld [wCurItemQuantity], a
	and a
	ret

.NotEnoughItems
	scf
	ret

.IsSameItem
	ld a, [RegisteredItem]
	cp [hl]
	jr nz, .NotSameItem
	ld [wCurItem], a
	and a
	ret

.NotSameItem
	scf
	ret

SelectMenu::
UseRegisteredItem:

	callba CheckItemMenu
	ld a, [wItemAttributeParamBuffer]
	jumptable

.SwitchTo
	dw .CantUse
	dw .NoFunction
	dw .NoFunction
	dw .NoFunction
	dw .Current
	dw .Party
	dw .Overworld

.Current
	call OpenText
	call DoItemEffect
	call CloseText
	and a
.NoFunction
	ret

.Party
	call RefreshScreen
	call FadeToMenu
	call DoItemEffect
	call CloseSubmenu
	call CloseText
	and a
	ret

.Overworld
	call RefreshScreen
	ld a, 1
	ld [wUsingItemWithSelect], a
	call DoItemEffect
	xor a
	ld [wUsingItemWithSelect], a
	ld a, [wItemEffectSucceeded]
	cp 1
	jr nz, ._cantuse
	scf
	ld a, HMENURETURN_SCRIPT
	ld [hMenuReturn], a
	ret

.CantUse
	call RefreshScreen

._cantuse
	call CloseText
	and a
	ret
