PokemonCenterPC:
	call PC_CheckPartyForPokemon
	ret c
	call PC_PlayBootSound
	ld hl, UnknownText_0x15a27
	call PC_DisplayText
	ld hl, UnknownText_0x15a2c
	call PC_DisplayTextWaitMenu
	ld hl, .TopMenu
	call LoadMenuDataHeader
.loop
	xor a
	ld [hBGMapMode], a
	call .ChooseWhichPCListToUse
	ld [wWhichIndexSet], a
	call DoNthMenu
	jr c, .shutdown
	ld a, [wMenuSelection]
	ld hl, .JumpTable
	call MenuJumptable
	jr nc, .loop

.shutdown
	call PC_PlayShutdownSound
	call ExitMenu
	jp CloseWindow

.TopMenu
	db $48 ; flags
	db 00, 00 ; start coords
	db 12, 15 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2
	db $a0 ; flags
	db 0 ; items
	dw .WhichPC
	dw PlaceNthMenuStrings
	dw .JumpTable

.JumpTable
	dw PlayersPC, .String_PlayersPC
	dw BillsPC, .String_BillsPC
	dw OaksPC, .String_OaksPC
	dw HallOfFamePC, .String_HallOfFame
	dw TurnOffPC, .String_TurnOff

.String_PlayersPC:	db "<PLAYER>'s PC@"
.String_BillsPC:	db "Bill's PC@"
.String_OaksPC:	    db "Prof.Oak's PC@"
.String_HallOfFame:	db "Hall of Fame@"
.String_TurnOff:	db "Turn off@"

.WhichPC
	; before pokedex
	db  3 ; items
	db  1, 0, 4 ; bill's, player's, turn off
	db -1

	; before Hall Of Fame
	db  4 ; items
	db  1, 0, 2, 4 ; bill's, player's, oak's, turn off
	db -1

	; postgame
	db  5 ; items
	db  1, 0, 2, 3, 4 ; bill's, player's, oak's, hall of fame, turn off
	db -1

.ChooseWhichPCListToUse
	CheckEngine ENGINE_POKEDEX
	jr nz, .got_dex
	xor a
	ret

.got_dex
	ld a, [wHallOfFameCount]
	and a
	jr nz, .got_count
	ld a, [wHallOfFameCount + 1]
	and a
.got_count
	ld a, $1
	ret z
	inc a
	ret

PC_CheckPartyForPokemon:
	ld a, [wPartyCount]
	and a
	ret nz
	ld de, SFX_CHOOSE_PC_OPTION
	call PlaySFX
	ld hl, UnknownText_0x15663
	call PC_DisplayText
	scf
	ret

PCMaintenance:
	text_jump _PCMaintenance

UnknownText_0x15663:
	; Bzzzzt! You must have a #mon to use this!
	text_jump UnknownText_0x1c1328

BillsPC:
	call PC_PlayChoosePCSound
	ld hl, UnknownText_0x15a31
	call PC_DisplayText
	callba _BillsPC
	and a
	ret

PlayersPC:
	call PC_PlayChoosePCSound
	ld hl, UnknownText_0x15a36
	call PC_DisplayText
	ld b, $0
	call _PlayersPC
	and a
	ret

OaksPC:
	call PC_PlayChoosePCSound
	ld hl, UnknownText_0x15a3b
	call PC_DisplayText
	callba ProfOaksPC
	and a
	ret

HallOfFamePC:
	call PC_PlayChoosePCSound
	call FadeToMenu
	callba _HallOfFamePC
	call CloseSubmenu
	and a
	ret

TurnOffPC:
	ld hl, UnknownText_0x15a40
	call PrintText
	scf
	ret

PC_PlayBootSound:
	ld de, SFX_BOOT_PC
	jr PC_WaitPlaySFX

PC_PlayShutdownSound:
	ld de, SFX_SHUT_DOWN_PC
	call PC_WaitPlaySFX
	jp WaitSFX

PC_PlayChoosePCSound:
	ld de, SFX_CHOOSE_PC_OPTION
	jr PC_WaitPlaySFX

SwapItemsInPC_PlaySFX:
	ld de, SFX_SWITCH_POKEMON
	call PC_WaitPlaySFX
	ld de, SFX_SWITCH_POKEMON

PC_WaitPlaySFX:
	push de
	call WaitSFX
	pop de
	jp PlaySFX

_KrissHousePC:
	call PC_PlayBootSound
	ld hl, UnknownText_0x156ff
	call PC_DisplayText
	ld b, $1
	call _PlayersPC
	and a
	jr nz, .asm_156f9
	call OverworldTextModeSwitch
	call ApplyTilemap
	call UpdateSprites
	call PC_PlayShutdownSound
	ld c, $0
	ret

.asm_156f9
	call ClearBGPalettes
	ld c, $1
	ret

UnknownText_0x156ff:
	; turned on the PC.
	text_jump UnknownText_0x1c1353

_PlayersPC:
	ld a, b
	ld [wWhichIndexSet], a
	ld hl, UnknownText_0x157cc
	call PC_DisplayTextWaitMenu
	call Function15715
	jp ExitMenu

Function15715:
	xor a
	ld [wPCItemMenuCursor], a
	ld [wPCItemScrollPosition], a
	ld hl, KrissPCMenuData
	call LoadMenuDataHeader
.asm_15722
	call UpdateTimePals
	call DoNthMenu
	jr c, .asm_15731
	call MenuJumptable
	jr nc, .asm_15722
	jr .asm_15732

.asm_15731
	xor a

.asm_15732
	jp ExitMenu

KrissPCMenuData:
	db %01000000
	db  0,  0 ; top left corner coords (y, x)
	db 12, 15 ; bottom right corner coords (y, x)
	dw .KrissPCMenuData2
	db 1 ; default selected option

.KrissPCMenuData2
	db %10100000 ; bit7
	db 0 ; # items?
	dw .KrissPCMenuList1
	dw PlaceNthMenuStrings
	dw .KrissPCMenuPointers

.KrissPCMenuPointers
	dw KrisWithdrawItemMenu, .WithdrawItem
	dw KrisDepositItemMenu,  .DepositItem
	dw KrisTossItemMenu,     .TossItem
	dw KrisLogOffMenu,       .LogOff
	dw KrisLogOffMenu,       .TurnOff

.WithdrawItem db "Withdraw Item@"
.DepositItem  db "Deposit Item@"
.TossItem     db "Toss Item@"
.TurnOff      db "Turn Off@"
.LogOff       db "Log Off@"

	const_def
	const WITHDRAW_ITEM
	const DEPOSIT_ITEM
	const TOSS_ITEM
	const TURN_OFF
	const LOG_OFF

.KrissPCMenuList1
	db 4
	db WITHDRAW_ITEM
	db DEPOSIT_ITEM
	db TOSS_ITEM
	db TURN_OFF
	db -1

.KrissPCMenuList2
	db 4
	db WITHDRAW_ITEM
	db DEPOSIT_ITEM
	db TOSS_ITEM
	db LOG_OFF
	db -1

PC_DisplayTextWaitMenu:
	ld a, [wOptions]
	push af
	set NO_TEXT_SCROLL, a
	ld [wOptions], a
	call MenuTextBox
	pop af
	ld [wOptions], a
	ret

UnknownText_0x157cc:
	; What do you want to do?
	text_jump UnknownText_0x1c1368

KrisWithdrawItemMenu:
	call LoadStandardMenuDataHeader
	callba ClearPCItemScreen
.loop
	call PlayerItemPCMenu
	jr c, .quit
	call WithdrawItemFromPC
	jr .loop

.quit
	call CloseSubmenu
	xor a
	ret

WithdrawItemFromPC:
	; check if the item has a quantity
	callba CheckItemPocket
	ld a, [wItemAttributeParamBuffer]
	cp KEY_ITEM
	jr nz, .askquantity

	; items without quantity are always ×1
	ld a, 1
	ld [wItemQuantityChangeBuffer], a
	jr .withdraw

.askquantity
	ld hl, .HowManyText
	call MenuTextBox
	callba SelectQuantityToToss
	call ExitMenu
	call ExitMenu
	ret c

.withdraw
	ld a, [wItemQuantityChangeBuffer]
	ld [wItemPCQuantityDeltaBackup], a ; quantity
	ld a, [wCurItemQuantity]
	ld [wItemPCQuantityBackup], a
	ld hl, NumItems
	call ReceiveItem
	jr nc, .PackFull
	ld a, [wItemPCQuantityDeltaBackup]
	ld [wItemQuantityChangeBuffer], a
	ld a, [wItemPCQuantityBackup]
	ld [wCurItemQuantity], a
	ld hl, PCItems
	call TossItem
	predef PartyMonItemName
	ld hl, .WithdrewText
	call MenuTextBox
	xor a
	ld [hBGMapMode], a
	jp ExitMenu

.PackFull
	ld hl, .NoRoomText
	jp MenuTextBoxBackup

.HowManyText
	text_jump _KrissPCHowManyWithdrawText

.WithdrewText
	text_jump _KrissPCWithdrewItemsText

.NoRoomText
	text_jump _KrissPCNoRoomWithdrawText

KrisTossItemMenu:
	call LoadStandardMenuDataHeader
	callba ClearPCItemScreen
	jr .handleLoop

.loop
	ld de, PCItems
	callba TossItemSubmenu
.handleLoop
	call PlayerItemPCMenu
	jr nc, .loop
	call CloseSubmenu
	xor a
	ret

KrisLogOffMenu:
	xor a
	scf
	ret

KrisDepositItemMenu:
	call CheckPlayerHasItemsToDeposit
	jr c, .exit
	call DisableSpriteUpdates
	call LoadStandardMenuDataHeader
	callba DepositSellInitPackBuffers
.loop
	callba DepositSellPack
	ld a, [wcf66]
	and a
	jr z, .no_selection
	call PCDeposit_TryDepositItem
	callba CheckRegisteredItem
	jr .loop

.no_selection
	call CloseSubmenu

.exit
	xor a
	ret

CheckPlayerHasItemsToDeposit:
	callba HasNoItems
	ret nc
	ld hl, .Text
	call MenuTextBoxBackup
	scf
	ret

.Text
	; No items here!
	text_jump UnknownText_0x1c13df

PCDeposit_TryDepositItem:
	ld a, [wSpriteUpdatesEnabled]
	push af
	ld a, $0
	ld [wSpriteUpdatesEnabled], a
	callba CheckItemMenu
	ld a, [wItemAttributeParamBuffer]
	jumptable .dw
	pop af
	ld [wSpriteUpdatesEnabled], a
	ret

.dw
	dw .tossable
	dw .no_toss
	dw .no_toss
	dw .no_toss
	dw .tossable
	dw .tossable
	dw .tossable

.tossable
	ld a, [wItemPCQuantityDeltaBackup]
	push af
	ld a, [wItemPCQuantityBackup]
	push af
	call .DepositItem
	pop af
	ld [wItemPCQuantityBackup], a
	pop af
	ld [wItemPCQuantityDeltaBackup], a
.no_toss
	ret

.DepositItem
	callba CheckItemPocket
	ld a, [wItemAttributeParamBuffer]
	cp KEY_ITEM
	jr nz, .ask_how_many
	ld a, $1
	ld [wItemQuantityChangeBuffer], a
	jr .deposit_into_pc

.ask_how_many
	ld hl, .HowManyText
	call MenuTextBox
	callba SelectQuantityToToss
	push af
	call ExitMenu
	call ExitMenu
	pop af
	jr c, .done

.deposit_into_pc
	ld a, [wItemQuantityChangeBuffer]
	ld [wItemPCQuantityDeltaBackup], a
	ld a, [wCurItemQuantity]
	ld [wItemPCQuantityBackup], a
	ld hl, PCItems
	call ReceiveItem
	jr nc, .no_room
	ld a, [wItemPCQuantityDeltaBackup]
	ld [wItemQuantityChangeBuffer], a
	ld a, [wItemPCQuantityBackup]
	ld [wCurItemQuantity], a
	ld hl, NumItems
	call TossItem
	predef PartyMonItemName
	ld hl, .DepositText
	jp PrintText

.no_room
	ld hl, .NoRoomText
	jp PrintText

.done
	and a
	ret

.HowManyText
	text_jump _KrissPCHowManyDepositText

.DepositText
	text_jump _KrissPCDepositItemsText

.NoRoomText
	text_jump _KrissPCNoRoomDepositText

PlayerItemPCMenu:
	xor a
	ld [wSwitchItem], a
.loop
	ld a, [wSpriteUpdatesEnabled]
	push af
	ld a, $0
	ld [wSpriteUpdatesEnabled], a
	ld hl, PlayerItemPCMenuDataHeader
	call CopyMenuDataHeader
	hlcoord 0, 0
	lb bc, 10, 18
	call TextBox
	ld a, [wPCItemMenuCursor]
	ld [wMenuCursorBuffer], a
	ld a, [wPCItemScrollPosition]
	ld [wMenuScrollPosition], a
	call ScrollingMenu
	ld a, [wMenuScrollPosition]
	ld [wPCItemScrollPosition], a
	ld a, [wMenuCursorY]
	ld [wPCItemMenuCursor], a
	pop af
	ld [wSpriteUpdatesEnabled], a
	ld a, [wSwitchItem]
	and a
	jr nz, .swapping
	ld a, [wMenuJoypad]
	cp B_BUTTON
	jr z, .exit_pc
	cp A_BUTTON
	jr z, .select_item
	cp SELECT
	jr z, .init_swap
	jr .loop

.swapping
	ld a, [wMenuJoypad]
	cp B_BUTTON
	jr z, .cancel_swap
	cp A_BUTTON
	jr z, .confirm_swap
	cp SELECT
	jr z, .confirm_swap
	jr .loop

.cancel_swap
	xor a
	ld [wSwitchItem], a
	jr .loop

.confirm_swap
	call SwapItemsInPC_PlaySFX

.init_swap
	callba SwitchItemsInBag

.exit_pc
	scf
	ret

.select_item
	call MenuBoxCoord2Tile
	ld de, SCREEN_WIDTH
	add hl, de
	ld de, 2 * SCREEN_WIDTH
	ld a, [wMenuData2_ScrollingMenuHeight]
.clear_loop
	ld [hl], " "
	add hl, de
	dec a
	jr nz, .clear_loop
	call PlaceHollowCursor
	and a
	ret

PlayerItemPCMenuDataHeader:
	db %01000000
	db  1,  4 ; start coords
	db 10, 18 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2
	db %10110000
	db 4, 8 ; rows/cols?
	db 2 ; horizontal spacing?
	dbw 0, PCItems
	dba PlaceMenuItemName
	dba PlaceMenuItemQuantity
	dba UpdateItemDescription

PC_DisplayText:
	call MenuTextBox
	jp ExitMenu

UnknownText_0x15a27:
	; turned on the PC.
	text_jump UnknownText_0x1c144d

UnknownText_0x15a2c:
	; Access whose PC?
	text_jump UnknownText_0x1c1462

UnknownText_0x15a31:
	; BILL's PC accessed. #mon Storage System opened.
	text_jump UnknownText_0x1c1474

UnknownText_0x15a36:
	; Accessed own PC. Item Storage System opened.
	text_jump UnknownText_0x1c14a4

UnknownText_0x15a3b:
	; PROF.OAK's PC accessed. #dex Rating System opened.
	text_jump UnknownText_0x1c14d2

UnknownText_0x15a40:
	; … Link closed…
	text_jump UnknownText_0x1c1505
