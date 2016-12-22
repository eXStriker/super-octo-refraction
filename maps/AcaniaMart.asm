AcaniaMart_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

AcaniaMartNPC1:
	jumptextfaceplayer AcaniaMartNPC1_Text

AcaniaMartShopAttendantNPC:
	faceplayer
	opentext
	pokemart 0, 12
	closetext
	end

AcaniaMartGoldTokenExchangeNPC:
	faceplayer
	opentext
	writetext AcaniaMartGoldTokenExchangeNPC_Text_Intro
	loadmenudata AcaniaGoldTokenMenu
	verticalmenu
	closewindow
	anonjumptable
	dw AcaniaMartClose
	dw AcaniaMart_GoldTokenExchange_SelectedPPUp
	dw AcaniaMart_GoldTokenExchange_SelectedEther
	dw AcaniaMart_GoldTokenExchange_SelectedMetalPowder
	dw AcaniaMart_GoldTokenExchange_SelectedQuickClaw
	dw AcaniaMart_GoldTokenExchange_SelectedMaxEther
	dw AcaniaMart_GoldTokenExchange_SelectedQRScanner

AcaniaMartClose:
	closetext
	end

AcaniaGoldTokenMenu:
	db $40 ; flags
	db 00, 00 ; start coords
	db 12, 19 ; end coords
	dw .AcaniaGoldTokenMenuText
	db 1 ; default option

.AcaniaGoldTokenMenuText:
	db $c0 ; flags
	db 6 ; items
	db "PP Up           3@"
	db "Ether           3@"
	db "Metal Powder    5@"
	db "Quick Claw      5@"
	db "Max Ether       5@"
	db "QR Reader      10@"

AcaniaMart_GoldTokenExchange_SelectedPPUp:
	writetext AcaniaMartGoldTokenExchangeNPC_Text_WantPPUp
	yesorno
	iffalse AcaniaMartClose
	writebyte PP_UP
	jump AcaniaMart_ThreeTokenReward

AcaniaMart_GoldTokenExchange_SelectedEther:
	writetext AcaniaMartGoldTokenExchangeNPC_Text_WantEther
	yesorno
	iffalse AcaniaMartClose
	writebyte ETHER
	; fallthrough

AcaniaMart_ThreeTokenReward:
	pushvar
	writebyte 3
	jump AcaniaMart_Reward

AcaniaMart_GoldTokenExchange_SelectedMetalPowder:
	writetext AcaniaMartGoldTokenExchangeNPC_Text_WantMetalPowder
	yesorno
	iffalse AcaniaMartClose
	writebyte METAL_POWDER
	jump AcaniaMart_FiveTokenReward

AcaniaMart_GoldTokenExchange_SelectedQuickClaw:
	writetext AcaniaMartGoldTokenExchangeNPC_Text_WantQuickClaw
	yesorno
	iffalse AcaniaMartClose
	writebyte QUICK_CLAW
	jump AcaniaMart_FiveTokenReward

AcaniaMart_GoldTokenExchange_SelectedMaxEther:
	writetext AcaniaMartGoldTokenExchangeNPC_Text_WantMaxEther
	yesorno
	iffalse AcaniaMartClose
	writebyte MAX_ETHER
	; fallthrough

AcaniaMart_FiveTokenReward:
	pushvar
	writebyte 5
	jump AcaniaMart_Reward

AcaniaMart_GoldTokenExchange_SelectedQRScanner:
	writetext AcaniaMartGoldTokenExchangeNPC_Text_WantQRScanner
	yesorno
	iffalse AcaniaMartClose
	writebyte QR_READER
	pushvar
	writebyte 10

AcaniaMart_Reward:
	scriptstartasm
	ld a, GOLD_TOKEN
	ld [wCurItem], a
	ld a, [hScriptVar]
	ld [wItemQuantityChangeBuffer], a
	ld a, -1
	ld [wCurItemQuantity], a
	ld hl, NumItems
	call TossItem
	ld hl, .not_enough_tokens
	ret nc
	scriptstopasm
	swapvar
	verbosegiveitem ITEM_FROM_MEM, 1
	sif true, then
		popvar
		endtext
	sendif
	popvar
	scriptstartasm
	ld a, GOLD_TOKEN
	ld [wCurItem], a
	ld a, [hScriptVar]
	ld [wItemQuantityChangeBuffer], a
	ld hl, NumItems
	call ReceiveItem
	scriptstopasm
	jumptext AcaniaMartGoldTokenExchangeNPC_Text_NotEnoughSpace
.not_enough_tokens
	jumptext AcaniaMartGoldTokenExchangeNPC_Text_NotEnoughTokens

AcaniaMartNPC1_Text:
	ctxt "The Gold Tokens"
	line "are too cleverly"
	cont "hidden for me!"
	done

AcaniaMartGoldTokenExchangeNPC_Text_Intro:
	ctxt "Hi there."

	para "I'll trade your"
	line "Gold Tokens for"
	cont "prizes!"

	para "Which item would"
	line "you like?"
	done

AcaniaMartGoldTokenExchangeNPC_Text_WantPPUp:
	ctxt "You want PP Up?"
	done

AcaniaMartGoldTokenExchangeNPC_Text_WantEther:
	ctxt "You want Ether?"
	done

AcaniaMartGoldTokenExchangeNPC_Text_WantMetalPowder:
	ctxt "You want Metal"
	line "Powder?"
	done

AcaniaMartGoldTokenExchangeNPC_Text_WantQuickClaw:
	ctxt "You want Quick"
	line "Claw?"
	done

AcaniaMartGoldTokenExchangeNPC_Text_WantMaxEther:
	ctxt "You want Max"
	line "Ether?"
	done

AcaniaMartGoldTokenExchangeNPC_Text_WantQRScanner:
	ctxt "You want the"
	line "QR Scanner?"
	done

AcaniaMartGoldTokenExchangeNPC_Text_NotEnoughTokens:
	ctxt "You don't have"
	line "enough tokens."
	done

AcaniaMartGoldTokenExchangeNPC_Text_NotEnoughSpace:
	ctxt "Free up some"
	line "space!"
	done

AcaniaMart_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $6, 2, ACANIA_DOCKS
	warp_def $7, $7, 2, ACANIA_DOCKS

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_TEACHER, 5, 9, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, AcaniaMartNPC1, -1
	person_event SPRITE_CLERK, 3, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, AcaniaMartShopAttendantNPC, -1
	person_event SPRITE_CLERK, 3, 7, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, AcaniaMartGoldTokenExchangeNPC, -1
