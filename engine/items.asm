Mart_UpdateItemDescription::
	hlcoord 6, 1
	ld a, " "
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, [wMenuSelection]
	cp $FF
	jp z, SpeechTextBox
	ld [wCurItem], a
	call CheckItemPocket
	ld a, [wItemAttributeParamBuffer]
	dec a
	jumptable
	dw .Item
	dw .KeyItem
	dw .Ball

.Ball
	ld hl, NumBalls
	jr .CountItem
.Item
	ld hl, NumItems
.CountItem
	ld a, [wCurItem]
	ld b, a
	ld de, 0
	inc hl
.loop
	ld a, [hli]
	cp $ff
	jr z, .done
	cp b
	jr nz, .next
	ld a, [hl]
	add e
	ld e, a
	jr nc, .next
	inc d
.next
	inc hl
	jr .loop

.KeyItem
	call CheckKeyItems
	ld de, 0
	jr nc, .done
	inc e
.done
	ld hl, wAmountOfCurItem
	ld a, d
	ld [hli], a
	ld [hl], e
	ld de, wAmountOfCurItem
	hlcoord 6, 1
	lb bc, 2, 4
	call PrintNum
	jpba UpdateItemDescription

_ReceiveItem::
	call .ReceiveItem
	ret nc
	ld a, [wCurItem]
	inc a
	ret z
	dec a
	ret z
	dec a
	ld c, a
	ld b, SET_FLAG
	ld hl, wItemsObtained
	predef_jump FlagAction

.ReceiveItem:
	CheckEngine ENGINE_USE_TREASURE_BAG
	jr nz, .pokemonOnlyMode
	call DoesHLEqualNumItems
	jp nz, PutItemInPocket
	push hl
	call CheckItemPocket
	pop de
	ld a, [wItemAttributeParamBuffer]
	dec a
	jumptable

.Pockets
	dw .Item
	dw ReceiveKeyItem
	dw .Ball

.Item
	ld h, d
	ld l, e
	jp PutItemInPocket

.Ball
	ld hl, NumBalls
	jp PutItemInPocket

.pokemonOnlyMode
	ld hl, wTreasureBagCount
	ld c, [hl]
	ld a, [wItemQuantityChangeBuffer]
	ld d, a
	add c
	cp TREASURE_BAG_CAPACITY + 1
	ret nc
	ld [hli], a
	ld b, 0
	add hl, bc
	ld a, [wCurItem]
.writeMultipleItemsLoop
	ld [hli], a
	dec d
	jr nz, .writeMultipleItemsLoop
	ld [hl], $ff
	scf
	ret

_TossItem::
	CheckEngine ENGINE_USE_TREASURE_BAG
	jr nz, .pokemonOnlyMode
	call DoesHLEqualNumItems
	jr nz, .remove
	push hl
	call CheckItemPocket
	pop de
	ld a, [wItemAttributeParamBuffer]
	dec a
	jumptable

.Pockets
	dw .Item
	dw TossKeyItem
	dw .Ball

.Ball
	ld hl, NumBalls
	jp RemoveItemFromPocket

.Item
	ld h, d
	ld l, e

.remove
	jp RemoveItemFromPocket

.pokemonOnlyMode:
	call CheckItem_Pokeonly
	ret nc

	ld hl, wTreasureBag
	ld a, [wItemQuantityChangeBuffer]
	ld c, a
	ld a, [wCurItem]
	ld b, a
.removeMultipleItemsLoop
	ld a, [hli]
	cp b
	jr nz, .removeMultipleItemsLoop
	push hl
	ld d, h
	ld e, l
	dec de
.shiftItemsLoop
	ld a, [hli]
	ld [de], a
	inc de
	inc a
	jr nz, .shiftItemsLoop
	ld hl, wTreasureBagCount
	dec [hl]
	pop hl
	dec hl
	dec c
	jr nz, .removeMultipleItemsLoop
	scf
	ret

_CheckItem::
	CheckEngine ENGINE_USE_TREASURE_BAG
	jr nz, CheckItem_Pokeonly
	call DoesHLEqualNumItems
	jr nz, .nope
	push hl
	call CheckItemPocket
	pop de
	ld a, [wItemAttributeParamBuffer]
	dec a
	jumptable

.Pockets
	dw .Item
	dw CheckKeyItems
	dw .Ball

.Ball
	ld hl, NumBalls
	jp CheckTheItem

.Item
	ld h, d
	ld l, e
.nope
	jp CheckTheItem

CheckItem_Pokeonly:
	ld a, [wCurItem]
	ld b, a
	ld a, [wItemQuantityChangeBuffer]
	ld c, a
	ld hl, wTreasureBag
.loop
	ld a, [hli]
	cp b
	jr z, .foundItem
	inc a
	jr nz, .loop
	and a
	ret

.foundItem
	dec c
	jr nz, .loop
	scf
	ret

DoesHLEqualNumItems:
	ld a, l
	cp NumItems % $100
	ret nz
	ld a, h
	cp NumItems / $100
	ret

GetPocketCapacity:
	ld c, MAX_ITEMS
	ld a, e
	cp NumItems % $100
	jr nz, .not_bag
	ld a, d
	cp NumItems / $100
	ret z

.not_bag
	ld c, MAX_PC_ITEMS
	ld a, e
	cp PCItems % $100
	jr nz, .not_pc
	ld a, d
	cp PCItems / $100
	ret z

.not_pc
	ld c, MAX_BALLS
	ret

PutItemInPocket:
	ld d, h
	ld e, l
	inc hl
	ld a, [wCurItem]
	ld c, a
	ld b, 0
.loop
	ld a, [hli]
	cp -1
	jr z, .terminator
	cp c
	jr nz, .next
	ld a, 99
	sub [hl]
	add b
	ld b, a
	ld a, [wItemQuantityChangeBuffer]
	cp b
	jr z, .ok
	jr c, .ok

.next
	inc hl
	jr .loop

.terminator
	call GetPocketCapacity
	ld a, [de]
	cp c
	jr c, .ok
	and a
	ret

.ok
	ld h, d
	ld l, e
	ld a, [wCurItem]
	ld c, a
	ld a, [wItemQuantityChangeBuffer]
	ld [wItemQuantityBuffer], a
.loop2
	inc hl
	ld a, [hli]
	cp -1
	jr z, .terminator2
	cp c
	jr nz, .loop2
	ld a, [wItemQuantityBuffer]
	add [hl]
	cp 100
	jr nc, .newstack
	ld [hl], a
	jr .done

.newstack
	ld [hl], 99
	sub 99
	ld [wItemQuantityBuffer], a
	jr .loop2

.terminator2
	dec hl
	ld a, [wCurItem]
	ld [hli], a
	ld a, [wItemQuantityBuffer]
	ld [hli], a
	ld [hl], -1
	ld h, d
	ld l, e
	inc [hl]

.done
	scf
	ret

RemoveItemFromPocket:
	ld d, h
	ld e, l
	ld a, [hli]
	ld c, a
	ld a, [wCurItemQuantity]
	cp c
	jr nc, .ok ; memory
	ld c, a
	ld b, $0
	add hl, bc
	add hl, bc
	ld a, [wCurItem]
	cp [hl]
	inc hl
	jr z, .skip
	ld h, d
	ld l, e
	inc hl

.ok
	ld a, [wCurItem]
	ld b, a
.loop
	ld a, [hli]
	cp b
	jr z, .skip
	cp -1
	jr z, .nope
	inc hl
	jr .loop

.skip
	ld a, [wItemQuantityChangeBuffer]
	ld b, a
	ld a, [hl]
	sub b
	jr c, .nope
	ld [hl], a
	ld [wItemQuantityBuffer], a
	and a
	jr nz, .yup
	dec hl
	ld b, h
	ld c, l
	inc hl
	inc hl
.loop2
	ld a, [hli]
	ld [bc], a
	inc bc
	cp -1
	jr nz, .loop2
	ld h, d
	ld l, e
	dec [hl]

.yup
	scf
	ret

.nope
	and a
	ret

CheckTheItem:
	ld a, [wCurItem]
	ld c, a
.loop
	inc hl
	ld a, [hli]
	cp -1
	jr z, .done
	cp c
	jr nz, .loop
	scf
	ret

.done
	and a
	ret

ReceiveKeyItem:
	ld hl, NumKeyItems
	ld a, [hli]
	cp MAX_KEY_ITEMS
	jr nc, .nope
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wCurItem]
	ld [hli], a
	ld [hl], -1
	ld hl, NumKeyItems
	inc [hl]
	scf
	ret

.nope
	and a
	ret

TossKeyItem:
	ld a, [wCurItemQuantity]
	ld e, a
	ld d, 0
	ld hl, NumKeyItems
	ld a, [hl]
	cp e
	jr nc, .ok
	call .Toss
	ret nc
	jr .ok2

.ok
	dec [hl]
	inc hl
	add hl, de

.ok2
	ld d, h
	ld e, l
	inc hl
.loop
	ld a, [hli]
	ld [de], a
	inc de
	cp -1
	jr nz, .loop
	scf
	ret

.Toss
	ld hl, NumKeyItems
	ld a, [wCurItem]
	ld c, a
.loop3
	inc hl
	ld a, [hl]
	cp c
	jr z, .ok3
	cp -1
	jr nz, .loop3
	xor a
	ret

.ok3
	ld a, [NumKeyItems]
	dec a
	ld [NumKeyItems], a
	scf
	ret

CheckKeyItems:
	ld a, [wCurItem]
	ld c, a
	ld hl, KeyItems
.loop
	ld a, [hli]
	cp c
	jr z, .done
	cp -1
	jr nz, .loop
	and a
	ret

.done
	scf
	ret

ReceiveTMHM:
	dec c
	push bc
	ld b, CHECK_FLAG
	ld hl, TMsHMs
	predef FlagAction
	pop bc
	ret nz
	ld b, SET_FLAG
	ld hl, TMsHMs
	predef FlagAction
	scf
	ret

_CheckTossableItem::
; Return 1 in wItemAttributeParamBuffer and carry if wCurItem can't be removed from the bag.
	ld a, ITEMATTR_PERMISSIONS
	call GetItemAttr
	bit 7, a
	jr nz, ItemAttr_ReturnCarry
	and a
	ret

CheckSelectableItem:
; Return 1 in wItemAttributeParamBuffer and carry if wCurItem can't be selected.
	ld a, ITEMATTR_PERMISSIONS
	call GetItemAttr
	bit 6, a
	jr nz, ItemAttr_ReturnCarry
	and a
	ret

CheckItemPocket::
; Return the pocket for wCurItem in wItemAttributeParamBuffer.
	ld a, ITEMATTR_POCKET
	call GetItemAttr
	and $f
	ld [wItemAttributeParamBuffer], a
	ret

CheckItemContext:
; Return the context for wCurItem in wItemAttributeParamBuffer.
	ld a, ITEMATTR_HELP
	call GetItemAttr
	and $f
	ld [wItemAttributeParamBuffer], a
	ret

CheckItemMenu:
; Return the menu for wCurItem in wItemAttributeParamBuffer.
	ld a, ITEMATTR_HELP
	call GetItemAttr
	swap a
	and $f
	ld [wItemAttributeParamBuffer], a
	ret

GetItemAttr:
; Get attribute a of wCurItem.

	push hl
	push bc

	ld hl, ItemAttributes
	ld c, a
	ld b, 0
	add hl, bc

	xor a
	ld [wItemAttributeParamBuffer], a

	ld a, [wCurItem]
	dec a
	ld c, a
	ld a, NUM_ITEMATTRS
	rst AddNTimes
	ld a, BANK(ItemAttributes)
	call GetFarByte

	pop bc
	pop hl
	ret

ItemAttr_ReturnCarry:
	ld a, 1
	ld [wItemAttributeParamBuffer], a
	scf
	ret

GetItemPrice:
; Return the price of wCurItem in de.
	push hl
	push bc
	ld a, ITEMATTR_PRICE
	call GetItemAttr
	ld e, a
	ld a, ITEMATTR_PRICE_HI
	call GetItemAttr
	ld d, a
	pop bc
	pop hl
	ret
