	const_def
	const MARTTEXT_HOW_MANY
	const MARTTEXT_COSTS_THIS_MUCH
	const MARTTEXT_NOT_ENOUGH_MONEY
	const MARTTEXT_BAG_FULL
	const MARTTEXT_HERE_YOU_GO
	const MARTTEXT_SOLD_OUT

OpenMartDialog::
	call GetMart
	ld a, c
	ld [EngineBuffer1], a
	call LoadMartPointer
	ld a, [EngineBuffer1]
	jumptable
.dialogs
	dw MartDialog
	dw HerbShop
	dw BargainShop
	dw Pharmacist
	dw RooftopSale
	dw BattleTowerExchangeCorner

BattleTowerExchangeCorner:
	call FarReadBattleTowerMart
	call LoadStandardMenuDataHeader
	ld hl, Text_BattleTowerExchange_Intro
	call MartTextBox
	call BattleTowerBuyMenu
	ld hl, Text_BattleTowerExchange_Outro
	jp MartTextBox

MartDialog:
	xor a
	ld [EngineBuffer1], a
	ld [EngineBuffer5], a
	jp StandardMart

HerbShop:
	call FarReadMart
	call LoadStandardMenuDataHeader
	ld hl, Text_HerbShop_Intro
	call MartTextBox
	call BuyMenu
	ld hl, Text_HerbShop_ComeAgain
	jp MartTextBox

BargainShop:
	ld b, BANK(BargainShopData)
	ld de, BargainShopData
	call LoadMartPointer
	call ReadMart
	call LoadStandardMenuDataHeader
	ld hl, Text_BargainShop_Intro
	call MartTextBox
	call BuyMenu
	ld hl, wBargainShopFlags
	ld a, [hli]
	or [hl]
	jr z, .skip_set
	ld hl, DailyFlags
	set 6, [hl]

.skip_set
	ld hl, Text_BargainShop_ComeAgain
	jp MartTextBox

Pharmacist:
	call FarReadMart
	call LoadStandardMenuDataHeader
	ld hl, Text_Pharmacist_Intro
	call MartTextBox
	call BuyMenu
	ld hl, Text_Pharmacist_ComeAgain
	jp MartTextBox

RooftopSale: ; 15ac4
	ld b, BANK(RooftopSaleData1)
	ld de, RooftopSaleData1
	ld hl, wStatusFlags
	bit 6, [hl] ; hall of fame
	jr z, .ok
	ld b, BANK(RooftopSaleData2)
	ld de, RooftopSaleData2

.ok
	call LoadMartPointer
	call ReadMart
	call LoadStandardMenuDataHeader
	ld hl, Text_Mart_HowMayIHelpYou
	call MartTextBox
	call BuyMenu
	ld hl, Text_Mart_ComeAgain
	jp MartTextBox

RooftopSaleData1:
	db 5
	dbw POKE_BALL,     150
	dbw GREAT_BALL,    500
	dbw SUPER_POTION,  500
	dbw FULL_HEAL,     500
	dbw REVIVE,       1200
	db -1
RooftopSaleData2:
	db 5
	dbw HYPER_POTION, 1000
	dbw FULL_RESTORE, 2000
	dbw FULL_HEAL,     500
	dbw ULTRA_BALL,   1000
	dbw PROTEIN,      7800
	db -1

LoadMartPointer:
	ld a, b
	ld [MartPointerBank], a
	ld a, e
	ld [MartPointer], a
	ld a, d
	ld [MartPointer + 1], a
	ld hl, CurMart
	xor a
	ld bc, 16
	call ByteFill
	xor a
	ld [EngineBuffer5], a
	ld [wBargainShopFlags], a
	ld [FacingDirection], a
	ret

GetMart:
	ld b, BANK(DefaultMart)
	ld a, c
	cp 5 ; Battle Tower
	jr z, .battleTower
	ld a, e
	cp (MartsEnd - Marts) / 2
	jr c, .IsAMart
	ld de, DefaultMart
	ret

.IsAMart
	ld d, 0
	ld hl, Marts
	add hl, de
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ret

.battleTower
	ld de, BattleTowerMart
	ret

StandardMart:
.loop
	ld a, [EngineBuffer5]
	jumptable .MartFunctions
	ld [EngineBuffer5], a
	cp $ff
	jr nz, .loop
	ret

.MartFunctions
	dw .HowMayIHelpYou
	dw .TopMenu
	dw .Buy
	dw .Sell
	dw .Quit
	dw .AnythingElse

.HowMayIHelpYou
	call LoadStandardMenuDataHeader
	ld hl, Text_Mart_HowMayIHelpYou
	call PrintText
	ld a, $1 ; top menu
	ret

.TopMenu
	ld hl, MenuDataHeader_BuySell
	call CopyMenuDataHeader
	call VerticalMenu
	jr c, .quit
	ld a, [wMenuCursorY]
	cp $1
	jr z, .buy
	cp $2
	jr z, .sell
.quit
	ld a, $4 ;  Come again!
	ret
.buy
	ld a, $2 ; buy
	ret
.sell
	ld a, $3 ; sell
	ret

.Buy
	call ExitMenu
	call FarReadMart
	call BuyMenu
	and a
	ld a, $5 ; Anything else?
	ret

.Sell
	call ExitMenu
	call SellMenu
	ld a, $5 ; Anything else?
	ret

.Quit
	call ExitMenu
	ld hl, Text_Mart_ComeAgain
	call MartTextBox
	ld a, $ff ; exit
	ret

.AnythingElse
	call LoadStandardMenuDataHeader
	ld hl, Text_Mart_AnythingElse
	call PrintText
	ld a, $1 ; top menu
	ret

FarReadBattleTowerMart:
	ld hl, MartPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, CurMart
	ld bc, wMartItem1BCD
	call GetFarMartByte
	ld [de], a
	inc de
	jr .handleLoop

.getPrice
	push de
	call GetFarMartByte
	push hl
	ld e, a
	ld d, 0
	ld h, b
	ld l, c
	call GetMartPrice
	ld b, h
	ld c, l
	pop hl
	pop de
.handleLoop
	call GetFarMartByte
	ld [de], a
	inc de
	cp -1
	jr nz, .getPrice
	ret

FarReadMart:
	ld hl, MartPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, CurMart
.CopyMart
	call GetFarMartByte
	ld [de], a
	inc de
	cp -1
	jr nz, .CopyMart
	ld hl, wMartItem1BCD
	ld de, CurMart + 1
	jr .handleLoop
.ReadMartItem
	push de
	call GetMartItemPrice
	pop de
.handleLoop
	ld a, [de]
	inc de
	cp -1
	jr nz, .ReadMartItem
	ret

GetMartItemPrice:
; Return the price of item a in BCD at hl and in tiles at wStringBuffer1.
	push hl
	ld [wCurItem], a
	callba GetItemPrice
	pop hl

GetMartPrice:
; Return price de in BCD at hl and in tiles at wStringBuffer1.
	push hl
	ld a, d
	ld [wStringBuffer2], a
	ld a, e
	ld [wStringBuffer2 + 1], a
	ld hl, wStringBuffer1
	ld de, wStringBuffer2
	lb bc, PRINTNUM_LEADINGZEROS | 2, 6 ; 6 digits
	call PrintNum
	pop hl

	ld de, wStringBuffer1
	ld c, 6 / 2 ; 6 digits
.loop
	call .CharToNybble
	swap a
	ld b, a
	call .CharToNybble
	or b
	ld [hli], a
	dec c
	jr nz, .loop
	ret

.CharToNybble
	ld a, [de]
	inc de
	cp " "
	jr nz, .not_space
	ld a, "0"

.not_space
	sub "0"
	ret

ReadMart:
; Load the mart pointer.  Mart data is local (no need for bank).
	ld hl, MartPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
; set hl to the first item
	inc hl
	ld bc, wMartItem1BCD
	ld de, CurMart + 1
.loop
; copy the item to CurMart + (ItemIndex)
	ld a, [hli]
	ld [de], a
	inc de
; -1 is the terminator
	cp -1
	jr z, .done

	push de
; copy the price to de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
; convert the price to 3-byte BCD at [bc]
	push hl
	ld h, b
	ld l, c
	call GetMartPrice
	ld b, h
	ld c, l
	pop hl

	pop de
	jr .loop

.done
	pop hl
	ld a, [hl]
	ld [CurMart], a
	ret

BargainShopData:
	db 5
	dbw NUGGET,     4500
	dbw PEARL,       650
	dbw BIG_PEARL,  3500
	dbw STARDUST,    900
	dbw STAR_PIECE, 4600
	db -1

BattleTowerBuyMenu:
	call FadeToMenu
	callba BlankScreen
	xor a
	ld [wMartMenuScrollPosition], a
	inc a
	ld [wMartMenuCursorBuffer], a
.loop
	call BattleTowerBuyMenuLoop ; menu loop
	jr nc, .loop
	jp CloseSubmenu

BuyMenu:
	call FadeToMenu
	callba BlankScreen
	xor a
	ld [wMartMenuScrollPosition], a
	inc a
	ld [wMartMenuCursorBuffer], a
.loop
	call BuyMenuLoop ; menu loop
	jr nc, .loop
	jp CloseSubmenu

LoadBuyMenuText:
; load text from a nested table
; which table is in EngineBuffer1
; which entry is in register a
	push af
	call GetMartDialogGroup ; gets a pointer from GetMartDialogGroup.MartTextFunctionPointers
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp PrintText

MartAskPurchaseQuantity:
	call GetMartDialogGroup ; gets a pointer from GetMartDialogGroup.MartTextFunctionPointers
	inc hl
	inc hl
	ld a, [hl]
	jumptable

	dw StandardMartAskPurchaseQuantity
	dw BargainShopAskPurchaseQuantity
	dw RooftopSaleAskPurchaseQuantity
	dw BattleTowerAskPurchaseQuantity

GetMartDialogGroup:
	ld a, [EngineBuffer1]
	ld e, a
	ld d, 0
	ld hl, .MartTextFunctionPointers
	add hl, de
	add hl, de
	add hl, de
	ret

.MartTextFunctionPointers
	dwb .StandardMartPointers, 0
	dwb .HerbShopPointers, 0
	dwb .BargainShopPointers, 1
	dwb .PharmacyPointers, 0
	dwb .StandardMartPointers, 2
	dwb .BattleTowerPointers, 3

.BattleTowerPointers
	dw BattleTowerBuyMenuLoop
	dw Text_BattleTower_CostsThisMuch
	dw Text_BattleTower_InsufficientFunds
	dw Text_Mart_BagFull
	dw Text_Mart_HereYouGo
	dw BattleTowerBuyMenuLoop

.StandardMartPointers
	dw Text_Mart_HowMany
	dw Text_Mart_CostsThisMuch
	dw Text_Mart_InsufficientFunds
	dw Text_Mart_BagFull
	dw Text_Mart_HereYouGo
	dw BuyMenuLoop

.HerbShopPointers
	dw Text_HerbShop_HowMany
	dw Text_HerbShop_CostsThisMuch
	dw Text_HerbShop_InsufficientFunds
	dw Text_HerbShop_BagFull
	dw Text_HerbShop_HereYouGo
	dw BuyMenuLoop

.BargainShopPointers
	dw BuyMenuLoop
	dw Text_BargainShop_CostsThisMuch
	dw Text_BargainShop_InsufficientFunds
	dw Text_BargainShop_BagFull
	dw Text_BargainShop_HereYouGo
	dw Text_BargainShop_SoldOut

.PharmacyPointers
	dw Text_Pharmacy_HowMany
	dw Text_Pharmacy_CostsThisMuch
	dw Text_Pharmacy_InsufficientFunds
	dw Text_Pharmacy_BagFull
	dw Text_Pharmacy_HereYouGo
	dw BuyMenuLoop

BattleTowerBuyMenuLoop:
	callba PlaceBattlePointsTopRight
	call UpdateSprites
	ld hl, MenuDataHeader_BTBuy
	call CopyMenuDataHeader
	ld a, [wMartMenuCursorBuffer]
	ld [wMenuCursorBuffer], a
	ld a, [wMartMenuScrollPosition]
	ld [wMenuScrollPosition], a
	call ScrollingMenu
	ld a, [wMenuScrollPosition]
	ld [wMartMenuScrollPosition], a
	ld a, [wMenuCursorY]
	ld [wMartMenuCursorBuffer], a
	call SpeechTextBox
	ld a, [wMenuJoypad]
	cp B_BUTTON
	jr z, .set_carry
	call MartAskPurchaseQuantity
	and a
	jr z, .insufficient_funds
	call MartConfirmPurchase
	jr c, .cancel
	ld hl, NumItems
	call ReceiveItem
	jr nc, .insufficient_bag_space
	call PlayTransactionSound
	ld bc, hMoneyTemp
	call TakeBattlePoints
	ld a, MARTTEXT_HERE_YOU_GO
	call LoadBuyMenuText
	call JoyWaitAorB

.cancel
	call SpeechTextBox
	and a
	ret

.set_carry
	scf
	ret

.insufficient_bag_space
	ld a, MARTTEXT_BAG_FULL
	call LoadBuyMenuText
	call JoyWaitAorB
	and a
	ret

.insufficient_funds
	ld a, MARTTEXT_NOT_ENOUGH_MONEY
	call LoadBuyMenuText
	call JoyWaitAorB
	and a
	ret

BuyMenuLoop:
	callba Mart_PlaceMoneyTopRight
	call UpdateSprites
	ld hl, MenuDataHeader_Buy
	call CopyMenuDataHeader
	ld a, [wMartMenuCursorBuffer]
	ld [wMenuCursorBuffer], a
	ld a, [wMartMenuScrollPosition]
	ld [wMenuScrollPosition], a
	call ScrollingMenu
	ld a, [wMenuScrollPosition]
	ld [wMartMenuScrollPosition], a
	ld a, [wMenuCursorY]
	ld [wMartMenuCursorBuffer], a
	call SpeechTextBox
	ld a, [wMenuJoypad]
	cp B_BUTTON
	jr z, .set_carry
	call MartAskPurchaseQuantity
	jr c, .cancel
	and a
	jr z, .insufficient_funds
	call MartConfirmPurchase
	jr c, .cancel
	ld de, Money
	ld bc, hMoneyTemp
	call CompareMoney
	jr c, .insufficient_funds
	ld hl, NumItems
	call ReceiveItem
	jr nc, .insufficient_bag_space
	ld a, [wMartItemID]
	ld c, a
	ld b, SET_FLAG
	ld hl, wBargainShopFlags
	predef FlagAction
	call PlayTransactionSound
	ld de, Money
	ld bc, hMoneyTemp
	call TakeMoney
	ld a, MARTTEXT_HERE_YOU_GO
	call LoadBuyMenuText
	call JoyWaitAorB

.cancel
	call SpeechTextBox
	and a
	ret

.set_carry
	scf
	ret

.insufficient_bag_space
	ld a, MARTTEXT_BAG_FULL
	call LoadBuyMenuText
	call JoyWaitAorB
	and a
	ret

.insufficient_funds
	ld a, MARTTEXT_NOT_ENOUGH_MONEY
	call LoadBuyMenuText
	call JoyWaitAorB
	and a
	ret

StandardMartAskPurchaseQuantity:
	callba GetItemPrice
	call Mart_GetNumberYouCanBuy
	and a
	ret z
	ld [wItemQuantityBuffer], a
	ld a, MARTTEXT_HOW_MANY
	call LoadBuyMenuText
	callba SelectQuantityToBuy
	call ExitMenu
	ld a, 1
	ret

MartConfirmPurchase:
	predef PartyMonItemName
	ld a, MARTTEXT_COSTS_THIS_MUCH
	call LoadBuyMenuText
	jp YesNoBox

BattleTowerAskPurchaseQuantity:
	ld a, 1
	ld [wItemQuantityChangeBuffer], a
	ld a, [wMartItemID]
	ld e, a
	ld d, $0
	ld hl, MartPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	add hl, de
	add hl, de
	inc hl
	ld a, [hl]
	ld [hMoneyTemp + 1], a
	xor a
	ld [hMoneyTemp + 0], a
	ld bc, hMoneyTemp
	call CheckBattlePoints
	jr c, .not_enough
	ld a, 1
	ret

.not_enough
	xor a
	ret

BargainShopAskPurchaseQuantity:
	ld a, 1
	ld [wItemQuantityChangeBuffer], a
	ld a, [wMartItemID]
	ld c, a
	ld b, CHECK_FLAG
	ld hl, wBargainShopFlags
	predef FlagAction
	ld a, c
	and a
	jr nz, .SoldOut
	ld a, [wMartItemID]
	ld e, a
	ld d, $0
	ld hl, MartPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	add hl, de
	add hl, de
	add hl, de
	inc hl
	ld a, [hli]
	ld [hMoneyTemp + 2], a
	ld a, [hl]
	ld [hMoneyTemp + 1], a
	xor a
	ld [hMoneyTemp], a
	ld bc, hMoneyTemp
	ld de, Money
	callba CompareMoney
	jr c, .not_enough
	ld a, 1
	ret

.not_enough
	xor a
	ret

.SoldOut
	ld a, MARTTEXT_SOLD_OUT
	call LoadBuyMenuText
	call JoyWaitAorB
	scf
	ret

RooftopSaleAskPurchaseQuantity:
	call .GetSalePrice
	call Mart_GetNumberYouCanBuy
	and a
	ret z
	ld [wItemQuantityBuffer], a
	ld a, MARTTEXT_HOW_MANY
	call LoadBuyMenuText
	callba RooftopSale_SelectQuantityToBuy
	call ExitMenu
	ld a, 1
	ret

.GetSalePrice
	ld a, [wMartItemID]
	ld e, a
	ld d, 0
	ld hl, MartPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	add hl, de
	add hl, de
	add hl, de
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	ret

Text_Mart_HowMany:
	; How many?
	text_jump UnknownText_0x1c4bfd

Text_HerbShop_CostsThisMuch:
Text_Pharmacy_CostsThisMuch:
Text_Mart_CostsThisMuch:
	; @ (S) will be ¥@ .
	text_jump UnknownText_0x1c4c08

MenuDataHeader_BTBuy:
	db $40 ; flags
	db 03, 01 ; start coords
	db 11, 19 ; end coords
	dw .menudata2
	db 1 ; default option

.menudata2
	db $30 ; pointers
	db 4, 8 ; rows, columns
	db 1 ; horizontal spacing
	dbw 0, CurMart
	dba PlaceMenuItemName
	dba .PrintBCDPrices
	dba Mart_UpdateItemDescription

.PrintBCDPrices
	ld a, [wScrollingMenuCursorPosition]
	ld c, a
	ld b, 0
	ld hl, wMartItem1BCD
	add hl, bc
	add hl, bc
	add hl, bc
	push de
	ld d, h
	ld e, l
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld c, PRINTNUM_LEADINGZEROS | 3
	call PrintBCDNumber
	ld de, .BPString
	jp PlaceString

.BPString:
	db " BP@"

MenuDataHeader_Buy:
	db $40 ; flags
	db 03, 01 ; start coords
	db 11, 19 ; end coords
	dw .menudata2
	db 1 ; default option

.menudata2
	db $30 ; pointers
	db 4, 8 ; rows, columns
	db 1 ; horizontal spacing
	dbw 0, CurMart
	dba PlaceMenuItemName
	dba .PrintBCDPrices
	dba Mart_UpdateItemDescription

.PrintBCDPrices
	ld a, [wScrollingMenuCursorPosition]
	ld c, a
	ld b, 0
	ld hl, wMartItem1BCD
	add hl, bc
	add hl, bc
	add hl, bc
	push de
	ld d, h
	ld e, l
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld c, PRINTNUM_LEADINGZEROS | PRINTNUM_MONEY | 3
	jp PrintBCDNumber

Text_HerbShop_Intro:
	; Hello, dear. I sell inexpensive herbal medicine. They're good, but a trifle bitter. Your #mon may not like them. Hehehehe…
	text_jump UnknownText_0x1c4c28

Text_HerbShop_HowMany:
	; How many?
	text_jump UnknownText_0x1c4ca3

Text_HerbShop_HereYouGo:
	; Thank you, dear. Hehehehe…
	text_jump UnknownText_0x1c4cce

Text_HerbShop_BagFull:
	; Oh? Your PACK is full, dear.
	text_jump UnknownText_0x1c4cea

Text_HerbShop_InsufficientFunds:
	; Hehehe… You don't have the money.
	text_jump UnknownText_0x1c4d08

Text_HerbShop_ComeAgain:
	; Come again, dear. Hehehehe…
	text_jump UnknownText_0x1c4d2a

Text_BargainShop_Intro:
	; Hiya! Care to see some bargains? I sell rare items that nobody else carries--but only one of each item.
	text_jump UnknownText_0x1c4d47

Text_BargainShop_CostsThisMuch:
	; costs ¥@ . Want it?
	text_jump UnknownText_0x1c4db0

Text_BargainShop_HereYouGo:
	; Thanks.
	text_jump UnknownText_0x1c4dcd

Text_BargainShop_BagFull:
	; Uh-oh, your PACK is chock-full.
	text_jump UnknownText_0x1c4dd6

Text_BargainShop_SoldOut:
	; You bought that already. I'm all sold out of it.
	text_jump UnknownText_0x1c4df7

Text_BargainShop_InsufficientFunds:
	; Uh-oh, you're short on funds.
	text_jump UnknownText_0x1c4e28

Text_BargainShop_ComeAgain:
	; Come by again sometime.
	text_jump UnknownText_0x1c4e46

Text_Pharmacist_Intro:
	; What's up? Need some medicine?
	text_jump UnknownText_0x1c4e5f

Text_Pharmacy_HereYouGo:
	; Thanks much!
	text_jump UnknownText_0x1c4eab

Text_Pharmacy_BagFull:
	; You don't have any more space.
	text_jump UnknownText_0x1c4eb9

Text_Pharmacy_InsufficientFunds:
	; Huh? That's not enough money.
	text_jump UnknownText_0x1c4ed8

Text_Pharmacist_ComeAgain:
	; All right. See you around.
	text_jump UnknownText_0x1c4ef6

SellMenu:
	call DisableSpriteUpdates
	callba DepositSellInitPackBuffers
.loop
	callba DepositSellPack
	ld a, [wcf66]
	and a
	jp z, .quit
	call .TryToSellItem
	jr .loop

.quit
	call ReturnToMapWithSpeechTextbox
	and a
	ret

.TryToSellItem:
	callba CheckItemMenu
	ld a, [wItemAttributeParamBuffer]
	cp 4
	jr nc, .try_sell
	and a
	ret nz

.try_sell
	callba GetItemPrice
	ld a, d
	or e
	jr z, .cantsell
	callba _CheckTossableItem
	ld a, [wItemAttributeParamBuffer]
	and a
	jr z, .okay_to_sell
.cantsell
	ld hl, TextMart_CantBuyFromYou
	call PrintText
	and a
.cant_buy
	ret

.okay_to_sell
	ld hl, Text_Mart_SellHowMany
	call PrintText
	callba PlaceMoneyAtTopLeftOfTextbox
	callba SelectQuantityToSell
	call ExitMenu
	jr c, .declined
	hlcoord 1, 14
	lb bc, 3, 18
	call ClearBox
	ld hl, Text_Mart_ICanPayThisMuch
	call PrintTextBoxText
	call YesNoBox
	jr c, .declined
	ld de, Money
	ld bc, hMoneyTemp
	call GiveMoney
	ld a, [wMartItemID]
	ld hl, NumItems
	call TossItem
	predef PartyMonItemName
	hlcoord 1, 14
	lb bc, 3, 18
	call ClearBox
	ld hl, Text_Mart_SoldForAmount
	call PrintTextBoxText
	call PlayTransactionSound
	callba PlaceMoneyBottomLeft
	call JoyWaitAorB

.declined
	call ExitMenu
	and a
	ret

Text_Pharmacy_HowMany:
Text_Mart_SellHowMany:
	; How many?
	text_jump UnknownText_0x1c4f33

Text_Mart_ICanPayThisMuch:
	; I can pay you ¥@ . Is that OK?
	text_jump UnknownText_0x1c4f3e

Text_Mart_HowMayIHelpYou:
	; Welcome! How may I help you?
	text_jump UnknownText_0x1c4f62

MenuDataHeader_BuySell:
	db $40 ; flags
	db 00, 00 ; start coords
	db 08, 07 ; end coords
	dw .menudata2
	db 1 ; default option

.menudata2
	db $80 ; strings
	db 3 ; items
	db "Buy@"
	db "Sell@"
	db "Quit@"

Text_Mart_HereYouGo:
	; Here you are. Thank you!
	text_jump UnknownText_0x1c4f80

Text_BattleTower_InsufficientFunds:
	text_jump Text_BattleTower_InsufficientFunds_

Text_BattleTower_CostsThisMuch:
	text_jump Text_BattleTower_CostsThisMuch_

Text_Mart_InsufficientFunds:
	; You don't have enough money.
	text_jump UnknownText_0x1c4f9a

Text_Mart_BagFull:
	; You can't carry any more items.
	text_jump UnknownText_0x1c4fb7

TextMart_CantBuyFromYou:
	; Sorry, I can't buy that from you.
	text_jump UnknownText_0x1c4fd7

Text_Mart_ComeAgain:
	; Please come again!
	text_jump UnknownText_0x1c4ff9

Text_Mart_AnythingElse:
	text_jump UnknownText_0x1c500d

Text_Mart_SoldForAmount:
	text_jump UnknownText_0x1c502e

Text_BattleTowerExchange_Intro:
	text_jump Text_BattleTowerExchange_Intro_

Text_BattleTowerExchange_Outro:
	text_jump Text_BattleTowerExchange_Outro_

PlayTransactionSound:
	call WaitSFX
	ld de, SFX_TRANSACTION
	jp PlaySFX

MartTextBox:
	call MenuTextBox
	call JoyWaitAorB
	jp ExitMenu

Mart_GetNumberYouCanBuy:
	ld a, d
	ld [hDivisor], a
	ld a, e
	ld [hDivisor + 1], a
	xor a
	ld [hDividend], a
	ld hl, Money
	ld a, [hli]
	ld [hDividend + 1], a
	ld a, [hli]
	ld [hDividend + 2], a
	ld a, [hl]
	ld [hDividend + 3], a
	predef DivideLong
	ld a, [hLongQuotient + 2]
	and a
	jr nz, .max
	ld a, [hLongQuotient + 3]
	cp 99
	ret c
.max
	ld a, 99
	ret

GetFarMartByte:
	ld a, [MartPointerBank]
	jp GetFarByteAndIncrement
