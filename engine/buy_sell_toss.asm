SelectQuantityToToss: ; 24fbf
	ld hl, TossItem_MenuDataHeader
	call LoadMenuDataHeader
	jp Toss_Sell_Loop
; 24fc9

SelectQuantityToBuy: ; 24fc9
	callba GetItemPrice
RooftopSale_SelectQuantityToBuy: ; 24fcf
	ld a, d
	ld [wCurItemPrice], a
	ld a, e
	ld [wCurItemPrice + 1], a
	ld hl, BuyItem_MenuDataHeader
	call LoadMenuDataHeader
	jp Toss_Sell_Loop
; 24fe1

SelectQuantityToSell: ; 24fe1
	callba GetItemPrice
	ld a, d
	ld [wCurItemPrice], a
	ld a, e
	ld [wCurItemPrice + 1], a
	ld hl, SellItem_MenuDataHeader
	call LoadMenuDataHeader
	jp Toss_Sell_Loop
; 24ff9

Toss_Sell_Loop: ; 24ff9
	ld a, 1
	ld [wItemQuantityChangeBuffer], a
	ld [hBGMapMode], a
.loop
	call BuySellToss_UpdateQuantityDisplay ; update display
	call BuySellToss_InterpretJoypad       ; joy action
	jr nc, .loop
	cp -1
	jr nz, .nope ; pressed B
	scf
	ret

.nope
	and a
	ret
; 2500e

BuySellToss_InterpretJoypad: ; 2500e
	call GetJoypadForQuantitySelectionMenus ; get joypad
	bit B_BUTTON_F, c
	jr nz, .b
	bit A_BUTTON_F, c
	jr nz, .a
	bit D_DOWN_F, c
	jr nz, .down
	bit D_UP_F, c
	jr nz, .up
	bit D_LEFT_F, c
	jr nz, .left
	bit D_RIGHT_F, c
	jr nz, .right
	and a
	ret

.b
	ld a, -1
	scf
	ret

.a
	xor a
	scf
	ret

.down
	ld hl, wItemQuantityChangeBuffer
	dec [hl]
	jr nz, .finish_down
	ld a, [wItemQuantityBuffer]
	ld [hl], a

.finish_down
	and a
	ret

.up
	ld hl, wItemQuantityChangeBuffer
	inc [hl]
	ld a, [wItemQuantityBuffer]
	cp [hl]
	jr nc, .finish_up
	ld [hl], 1

.finish_up
	and a
	ret

.left
	ld a, [wItemQuantityChangeBuffer]
	sub 10
	jr c, .load_1
	jr z, .load_1
	jr .finish_left

.load_1
	ld a, 1

.finish_left
	ld [wItemQuantityChangeBuffer], a
	and a
	ret

.right
	ld a, [wItemQuantityChangeBuffer]
	add 10
	ld b, a
	ld a, [wItemQuantityBuffer]
	cp b
	jr nc, .finish_right
	ld b, a

.finish_right
	ld a, b
	ld [wItemQuantityChangeBuffer], a
	and a
	ret
; 25072

BuySellToss_UpdateQuantityDisplay: ; 25072
	call MenuBox
	call MenuBoxCoord2Tile
	ld de, SCREEN_WIDTH + 1
	add hl, de
	ld [hl], "×"
	inc hl
	ld de, wItemQuantityChangeBuffer
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	call PrintNum
	ld a, [wMenuData2Pointer]
	ld c, a
	ld a, [wMenuData2Pointer + 1]
	ld b, a
	or b
	ret z
	push hl
	ld h, b
	ld l, c
	ld a, [wMenuDataBank]
	call FarCall_hl
	ld hl, hMoneyTemp
	ld a, [hProduct + 1]
	ld [hli], a
	ld a, [hProduct + 2]
	ld [hli], a
	ld a, [hProduct + 3]
	ld [hl], a
	pop hl
	inc hl
	ld de, hMoneyTemp
	lb bc, PRINTNUM_MONEY | 3, 6
	jp PrintNum
; 250ed

BuySell_MultiplyPrice: ; 250a9
	xor a
	ld [hMultiplicand + 0], a
	ld a, [wCurItemPrice]
	ld [hMultiplicand + 1], a
	ld a, [wCurItemPrice + 1]
	ld [hMultiplicand + 2], a
	ld a, [wItemQuantityChangeBuffer]
	ld [hMultiplier], a
	predef_jump Multiply

DisplaySellingPrice: ; 2509f
	call BuySell_MultiplyPrice
	ld hl, hProduct + 1
	ld a, [hl]
	srl a
	ld [hli], a
	ld a, [hl]
	rra
	ld [hli], a
	ld a, [hl]
	rra
	ld [hl], a
	ret
; 250d1

TossItem_MenuDataHeader: ; 0x250ed
	db $40 ; flags
	db 09, 15 ; start coords
	db 11, 19 ; end coords
	dw NULL
	db 0 ; default option
; 0x250f5

BuyItem_MenuDataHeader: ; 0x250f5
	db $40 ; flags
	db 15, 07 ; start coords
	db 17, 19 ; end coords
	dw BuySell_MultiplyPrice
	db -1 ; default option
; 0x250fd

SellItem_MenuDataHeader: ; 0x250fd
	db $40 ; flags
	db 15, 07 ; start coords
	db 17, 19 ; end coords
	dw DisplaySellingPrice
	db 0 ; default option
; 0x25105
