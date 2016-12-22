PlaceBallItemNameAndIcon::
	ld a, [wMenuSelection]
	cp $FF
	jr z, PlaceBallItemNameAndIcon_Cancel
	push bc
	call _PlaceBallItemNameAndIcon
	pop bc
	inc c
	ld a, b
	cp c
	jr z, UpdateFirstFourOBPals
	ret

_PlaceBallItemNameAndIcon:
	push de
	ld a, [wMenuScrollPosition]
	ld b, a
	ld a, [wScrollingMenuCursorPosition]
	sub b
	swap a
	push af
	add a
	ld l, a
	ld h, $80
	callba BagMenu_GetBallGFX
	callba LoadBallPocketOAM
	pop af
	srl a
	add UnknOBPals % $100
	ld e, a
	ld d, UnknOBPals / $100
	callba GetBallPackPal
	pop de
; fallthrough
PlaceMenuItemName::
	push de
	ld a, [wMenuSelection]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	pop hl
	jp PlaceString

PlaceBallItemNameAndIcon_Cancel:
	push de
	ld a, [wMenuScrollPosition]
	ld b, a
	ld a, [wScrollingMenuCursorPosition]
	sub b
	swap a
	ld l, a
	ld h, Sprites >> 8
	ld bc, $10
	xor a
	call ByteFill
	ld de, PlaceBallItemNameAndIcon_CancelString
	pop hl
	call PlaceString

; fallthrough
UpdateFirstFourOBPals:
	ld a, [rSVBK]
	push af
	ld a, BANK(OBPals)
	ld [rSVBK], a
	ld hl, UnknOBPals
	ld de, OBPals
	ld bc, 5 palettes
	rst CopyBytes
; now to update the first four palettes in hblank
	ld hl, OBPals
	lb bc, 5, rOBPI & $ff
	ld de, rSTAT
	ld a, $80
	ld [$ff00+c], a
	inc c
	di
.waitNoHBlankLoop
	ld a, [de]
	and 3
	jr z, .waitNoHBlankLoop
.waitHBlankLoop
	ld a, [de]
	and 3
	jr nz, .waitHBlankLoop
rept 1 palettes
	ld a, [hli]
	ld [$ff00+c], a
endr
	dec b
	jr nz, .waitNoHBlankLoop
	pop af
	ld [rSVBK], a
	reti

PlaceBallItemNameAndIcon_CancelString:
	db "Cancel@"

PlaceMenuItemQuantity:
	push de
	ld a, [wMenuSelection]
	ld [wCurItem], a
	callba CheckItemPocket
	pop hl
	ld a, [wItemAttributeParamBuffer]
	cp KEY_ITEM
	ret z

	ld de, $15
	add hl, de
	ld [hl], "×"
	inc hl
	ld de, MenuSelectionQuantity
	lb bc, 1, 2
	jp PrintNum

PlaceBattlePointsTopRight:
	ld hl, MenuDataHeader_TopRightBox
	call CopyMenuDataHeader
	call MenuBox
	call MenuBoxCoord2Tile
	ld de, SCREEN_WIDTH + 1
	add hl, de
	ld de, .BPString
	call PlaceString
	ld h, b
	ld l, c
	ld de, BattlePoints
	lb bc, PRINTNUM_LEADINGZEROS | 2, 3
	call PrintNum
	jr PlaceItemQuantityTopLeft

.BPString:
	db "BP: @"

Mart_PlaceMoneyTopRight:
	call PlaceMoneyTopRight
PlaceItemQuantityTopLeft:
	ld hl, MenuDataHeader_TopLeftBox
	call CopyMenuDataHeader
	call MenuBox
	call MenuBoxCoord2Tile
	ld de, SCREEN_WIDTH + 1
	add hl, de
	ld de, .InBagStr
	jp PlaceString

.InBagStr db "Bag ×@"

PlaceMoneyTopRight:
	ld hl, MenuDataHeader_TopRightBox
	call CopyMenuDataHeader
	jr PlaceMoneyDataHeader

PlaceMoneyBottomLeft:
	ld hl, MenuDataHeader_BottomLeftBox
	call CopyMenuDataHeader
	jr PlaceMoneyDataHeader

PlaceMoneyAtTopLeftOfTextbox:
	ld hl, MenuDataHeader_TopRightBox
	lb de, 0, 11
	call OffsetMenuDataHeader

PlaceMoneyDataHeader:
	call MenuBox
	call MenuBoxCoord2Tile
	ld de, SCREEN_WIDTH + 1
	add hl, de
	ld de, Money
	lb bc, PRINTNUM_MONEY | 3, 6
	jp PrintNum

MenuDataHeader_TopRightBox:
	db $40 ; flags
	db 00, 11 ; start coords
	db 02, 19 ; end coords
	dw NULL
	db 1 ; default option

MenuDataHeader_BottomLeftBox:
	db $40 ; flags
	db 11, 00 ; start coords
	db 13, 08 ; end coords
	dw NULL
	db 1 ; default option

MenuDataHeader_TopLeftBox:
	db $40 ; flags
	db 00, 00 ; start coords
	db 02, 10 ; end coords
	dw NULL
	db 1 ; default option

Special_DisplayCoinCaseBalance:
	; Place a text box of size 1x7 at 11, 0.
	hlcoord 11, 0
	lb bc, 1, 7
	call TextBox
	hlcoord 12, 0
	ld de, CoinString
	call PlaceString
	ld de, Coins
	lb bc, 2, 4
	hlcoord 13, 1
	jp PrintNum

Special_DisplayMoneyAndCoinBalance:
	hlcoord 5, 0
	lb bc, 3, 13
	call TextBox
	hlcoord 6, 1
	ld de, MoneyString
	call PlaceString
	hlcoord 12, 1
	ld de, Money
	lb bc, PRINTNUM_MONEY | 3, 6
	call PrintNum
	hlcoord 6, 3
	ld de, CoinString
	call PlaceString
	hlcoord 15, 3
	ld de, Coins
	lb bc, 2, 4
	jp PrintNum

MoneyString:
	db "Money@"
CoinString:
	db "Coin@"
