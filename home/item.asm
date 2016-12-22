DoItemEffect::
	jpba _DoItemEffect

CheckTossableItem::
	push hl
	push de
	push bc
	callba _CheckTossableItem
	pop bc
	pop de
	pop hl
	ret

TossItem::
	push hl
	push de
	push bc
	callba _TossItem
	pop bc
	pop de
	pop hl
	ret

ReceiveItem::
	push hl
	push de
	push bc
	callba _ReceiveItem
	pop bc
	pop de
	pop hl
	ret

CheckItem::
	push hl
	push de
	push bc
	callba _CheckItem
	pop bc
	pop de
	pop hl
	ret

GetItemPocket::
	; in: a: item
	; out: a: pocket
	inc a
	ret z
	dec a
	ret z
	anonbankpush ItemAttributes

	push hl
	push bc
	ld hl, ItemAttributes + ITEMATTR_POCKET - NUM_ITEMATTRS
	ld bc, NUM_ITEMATTRS
	rst AddNTimes
	ld a, [hl]
	pop bc
	pop hl
	ret