SpurgeGameCorner_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SpurgeGameCornerSlotMachine:
	farjump OwsauriSlots

SpurgeGameCornerMemory::
	opentext
	checkcoins 25
	sif =, 2
		jumptext SpurgeGameCorner_Text_NeedTwentyFiveCoins
	refreshscreen 0
	special Special_DummyNonfunctionalGameCornerGame
	iffalse .end
	writetext TextSpurgeMemoryGetPrizes
	waitbutton

.itemloop
	callasm SpurgeProcessItem
	iffalse .end
	verbosegiveitem ITEM_FROM_MEM, 1
	waitbutton
	jump .itemloop

.end
	closetext
	end

SpurgeProcessItem:
	xor a
	ld [hScriptVar], a
	ld hl, wDummyGameLastMatches
	ld a, [hl]
	dec a
	cp $ff
	ret z
	ld hl, SpurgeMemoryItems
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	ld [hScriptVar], a

	ld hl, wDummyGameLastMatches + 1
	ld de, wDummyGameLastMatches
	ld bc, 4
	rst CopyBytes
	xor a
	ld [wDummyGameLastMatches + 4], a
	ret

SpurgeMemoryItems:
	db ANTIDOTE
	db RARE_CANDY
	db POKE_DOLL
	db REPEL
	db POTION
	db POKE_BALL
	db GREAT_BALL
	db NUGGET

SpurgeGameCornerCardFlip::
	refreshscreen 0
	special Special_CardFlip
	closetext
	end

SpurgeGameCornerPoker:
	farjump GameCornerPoker

SpurgeGameCornerBlackjack:
	farjump GameCornerBlackjack

SpurgeGameCornerCoinVendor:
	jumpstd gamecornercoinvendor

SpurgeGameCornerMonExchange:
	faceplayer
	opentext
	farwritetext OwsauriGameCorner_Text_ExchangeGameCoins
	waitbutton
	checkitem COIN_CASE
	sif false
		jumptext SpurgeGameCorner_Text_DontHaveCoinCase
	farwritetext OwsauriGameCornerMonExchange_Text_WhichMon
	special Special_DisplayCoinCaseBalance
	loadmenudata SpurgeGameCornerPokemonMenu
	verticalmenu
	closewindow
	if_equal 1, SpurgeGameCorner_MonExchange_GetKangaskhan
	if_equal 2, SpurgeGameCorner_MonExchange_GetEevee
	if_equal 3, SpurgeGameCorner_MonExchange_GetPorygon
	jumptext SpurgeGameCorner_Text_SaveYourCoinsComeAgain

SpurgeGameCornerTMExchange:
	faceplayer
	opentext
	farwritetext OwsauriGameCorner_Text_ExchangeGameCoins
	waitbutton
	checkitem COIN_CASE
	sif false
		jumptext SpurgeGameCorner_Text_DontHaveCoinCase
	farwritetext OwsauriGameCornerTMExchange_Text_WhichTM
	special Special_DisplayCoinCaseBalance
	loadmenudata SpurgeGameCornerTMMenu
	verticalmenu
	closewindow
	if_equal 1, SpurgeGameCorner_TMExchange_GetTM33
	if_equal 2, SpurgeGameCorner_TMExchange_GetTM41
	if_equal 3, SpurgeGameCorner_TMExchange_GetTM48
	jumptext SpurgeGameCorner_Text_SaveYourCoinsComeAgain

SpurgeGameCornerTMMenu:
	db $40 ; flags
	db 03, 05 ; start coords
	db 11, 19 ; end coords
	dw SpurgeGameCornerTMOptions
	db 1 ; default option

SpurgeGameCornerTMOptions:
	db $80
	db $3
	db "TM33    3000@"
	db "TM41    3000@"
	db "TM48    3000@"

SpurgeGameCornerPokemonMenu:
	db $40 ; flags
	db 03, 00 ; start coords
	db 11, 19 ; end coords
	dw SpurgeGameCornerPokemonOptions
	db 1 ; default option

SpurgeGameCornerPokemonOptions:
	db $80
	db $3
	db "Kangaskhan   1000@"
	db "Eevee        3000@"
	db "Porygon      5000@"

SpurgeGameCornerNPC1:
	jumptextfaceplayer SpurgeGameCornerNPC1_Text

SpurgeGameCornerNPC2:
	jumptextfaceplayer SpurgeGameCornerNPC2_Text

SpurgeGameCornerNPC3:
	jumptextfaceplayer SpurgeGameCornerNPC3_Text

SpurgeGameCornerNPC4:
	jumptextfaceplayer SpurgeGameCornerNPC4_Text

SpurgeGameCornerNPC5:
	jumptextfaceplayer SpurgeGameCornerNPC5_Text

SpurgeGameCornerNPC6:
	jumptextfaceplayer SpurgeGameCornerNPC6_Text

SpurgeGameCornerNPC7:
	jumptextfaceplayer SpurgeGameCornerNPC7_Text

SpurgeGameCornerNPC8:
	jumptextfaceplayer SpurgeGameCornerNPC8_Text

SpurgeGameCornerNPC9:
	jumptextfaceplayer SpurgeGameCornerNPC9_Text

SpurgeGameCornerNPC10:
	jumptextfaceplayer SpurgeGameCornerNPC10_Text

SpurgeGameCorner_MonExchange_GetKangaskhan:
	checkcoins 1000
	sif =, 2
		jumptext SpurgeGameCorner_Text_NeedMoreCoins
	checkcode VAR_PARTYCOUNT
	sif >, 5
		jumptext SpurgeGameCorner_Text_NoRoomForMon
	pokenamemem KANGASKHAN, 0
	scall SpurgeGameCorner_MonExchange_IsThatRight
	sif false
		jumptext SpurgeGameCorner_Text_SaveYourCoinsComeAgain
	waitsfx
	playsound SFX_TRANSACTION
	farwritetext OwsauriGameCorner_Text_HereYouGo
	waitbutton
	writebyte KANGASKHAN
	special Special_GameCornerPrizeMonCheckDex
	givepoke KANGASKHAN, 20, NO_ITEM, 0
	takecoins 1000
	closetext
	end

SpurgeGameCorner_MonExchange_GetEevee:
	checkcoins 3000
	sif =, 2
		jumptext SpurgeGameCorner_Text_NeedMoreCoins
	checkcode VAR_PARTYCOUNT
	sif >, 5
		jumptext SpurgeGameCorner_Text_NoRoomForMon
	pokenamemem EEVEE, 0
	scall SpurgeGameCorner_MonExchange_IsThatRight
	sif false
		jumptext SpurgeGameCorner_Text_SaveYourCoinsComeAgain
	waitsfx
	playsound SFX_TRANSACTION
	farwritetext OwsauriGameCorner_Text_HereYouGo
	waitbutton
	writebyte EEVEE
	special Special_GameCornerPrizeMonCheckDex
	givepoke EEVEE, 20, NO_ITEM, 0
	takecoins 3000
	closetext
	end

SpurgeGameCorner_MonExchange_GetPorygon:
	checkcoins 5000
	sif =, 2
		jumptext SpurgeGameCorner_Text_NeedMoreCoins
	checkcode VAR_PARTYCOUNT
	sif >, 5
		jumptext SpurgeGameCorner_Text_NoRoomForMon
	pokenamemem PORYGON, 0
	scall SpurgeGameCorner_MonExchange_IsThatRight
	sif false
		jumptext SpurgeGameCorner_Text_SaveYourCoinsComeAgain
	waitsfx
	playsound SFX_TRANSACTION
	farwritetext OwsauriGameCorner_Text_HereYouGo
	waitbutton
	writebyte PORYGON
	special Special_GameCornerPrizeMonCheckDex
	givepoke PORYGON, 25, NO_ITEM, 0
	takecoins 5000
	closetext
	end

SpurgeGameCorner_TMExchange_GetTM33:
	writebyte 33
	farjump OwsauriGameCorner_TMExchange_DoExchange

SpurgeGameCorner_TMExchange_GetTM41:
	writebyte 41
	farjump OwsauriGameCorner_TMExchange_DoExchange

SpurgeGameCorner_TMExchange_GetTM48:
	writebyte 48
	farjump OwsauriGameCorner_TMExchange_DoExchange

SpurgeGameCornerCoinCaseSeller:
	faceplayer
	checkevent EVENT_GET_COIN_CASE
	sif true
		jumptext SpurgeGameCorner_CoinCaseSeller_Text_AfterSale
	opentext
	special PlaceMoneyTopRight
	writetext SpurgeGameCorner_CoinCaseSeller_Text_CanSell
	yesorno
	sif false
		jumptext SpurgeGameCorner_CoinCaseSeller_Text_GoAway
	checkmoney 0, 1000
	sif =, 2
		jumptext SpurgeGameCorner_CoinCaseSeller_Text_NotEnoughMoney
	takemoney 0, 1000
	special PlaceMoneyTopRight
	setevent EVENT_GET_COIN_CASE
	opentext
	writetext SpurgeGameCorner_CoinCaseSeller_Text_ConfirmPurchase
	waitbutton
	verbosegiveitem COIN_CASE, 1
	closetext
	end

SpurgeGameCorner_MonExchange_IsThatRight:
	writetext SpurgeGameCorner_MonExchange_IsThatRight_Text
	yesorno
	closetext
	end

SpurgeGameCornerNPC1_Text:
	ctxt "24x on the first"
	line "try!"

	para "Go me!"
	done

SpurgeGameCornerNPC2_Text:
	ctxt "This row is all"
	line "card memory!"

	para "Match two cards"
	line "and win a prize."

	para "You have five"
	line "chances to match"
	para "pairs, which means"
	line "you can win up to"
	para "five prizes each"
	line "time playing!"

	para "Be careful though,"
	line "it costs 25 coins"
	cont "to play<...>"
	done

SpurgeGameCornerNPC3_Text:
	ctxt "These are the"
	line "slot machines."

	para "I sure hope you"
	line "know how these"
	cont "work by now<...>"
	done

SpurgeGameCornerNPC4_Text:
	ctxt "This row is the"
	line "classic card game."
	done

SpurgeGameCornerNPC5_Text:
	ctxt "Blackjack!"

	para "Get as close to"
	line "21 as you can."

	para "If you go over,"
	line "you lose!"
	done

SpurgeGameCornerNPC6_Text:
	ctxt "Video Poker!"

	para "Ten coins per try!"
	done

SpurgeGameCornerNPC7_Text:
	ctxt "Why aren't these"
	line "deuces wild?"
	done

SpurgeGameCornerNPC8_Text:
	ctxt "I heard you can"
	line "win Rare Candies"
	cont "with this."

	para "But of course, I"
	line "have bad luck<...>"
	done

SpurgeGameCornerNPC9_Text:
	ctxt "If I keep playing"
	line "these slot games,"

	para "it's gonna take me"
	line "forever to win a"
	para "TM33, Ice Punch,"
	line "for my Snorunt."
	done

SpurgeGameCornerNPC10_Text:
	ctxt "I bet 100, had a"
	line "good hand, doubled"
	cont "down, then lost."

	para "Oh well, try"
	line "again<...>"
	done

SpurgeGameCorner_Text_NeedTwentyFiveCoins:
	ctxt "You need 25 coins"
	line "to play this."
	done

SpurgeGameCorner_Text_DontHaveCoinCase:
	ctxt "Oh? You don't have"
	line "a Coin Case."
	done

SpurgeGameCorner_Text_SaveYourCoinsComeAgain:
	ctxt "OK. Please save"
	line "your coins and"
	cont "come again!"
	done

SpurgeGameCorner_CoinCaseSeller_Text_CanSell:
	ctxt "Psst<...>"

	para "I'll sell you"
	line "a Coin Case."

	para "I just need"
	line "¥1000 in return."

	para "Deal?"
	done

SpurgeGameCorner_CoinCaseSeller_Text_AfterSale:
	ctxt "Coin Case?"

	para "What Coin Case?"
	done

SpurgeGameCorner_Text_NeedMoreCoins:
	ctxt "Sorry! You need"
	line "more coins."
	done

SpurgeGameCorner_Text_NoRoomForMon:
	ctxt "Sorry. You can't"
	line "carry any more."
	done

SpurgeGameCorner_MonExchange_IsThatRight_Text:
	ctxt "<STRBF1>."
	line "Is that right?"
	done

SpurgeGameCorner_CoinCaseSeller_Text_GoAway:
	ctxt "Then go away."
	done

SpurgeGameCorner_CoinCaseSeller_Text_ConfirmPurchase:
	ctxt "I thought so."
	done

SpurgeGameCorner_CoinCaseSeller_Text_NotEnoughMoney:
	ctxt "<...>"

	para "Let me know when"
	line "you actually have"
	cont "money."
	done

TextSpurgeMemoryGetPrizes:
	ctxt "Congratulations!"

	line "You have won<...>"
	done

SpurgeGameCorner_MapEventHeader:: db 0, 0

.Warps: db 2
	warp_def 13, 14, 3, SPURGE_CITY
	warp_def 13, 15, 3, SPURGE_CITY

.CoordEvents: db 0

.BGEvents: db 36
	signpost 4, 6, SIGNPOST_READ, SpurgeGameCornerSlotMachine
	signpost 5, 6, SIGNPOST_READ, SpurgeGameCornerSlotMachine
	signpost 2, 6, SIGNPOST_READ, SpurgeGameCornerSlotMachine
	signpost 3, 6, SIGNPOST_READ, SpurgeGameCornerSlotMachine
	signpost 4, 7, SIGNPOST_READ, SpurgeGameCornerSlotMachine
	signpost 5, 7, SIGNPOST_READ, SpurgeGameCornerSlotMachine
	signpost 2, 7, SIGNPOST_READ, SpurgeGameCornerSlotMachine
	signpost 3, 7, SIGNPOST_READ, SpurgeGameCornerSlotMachine
	signpost 2, 14, SIGNPOST_READ, SpurgeGameCornerMemory
	signpost 3, 14, SIGNPOST_READ, SpurgeGameCornerMemory
	signpost 4, 14, SIGNPOST_READ, SpurgeGameCornerMemory
	signpost 5, 14, SIGNPOST_READ, SpurgeGameCornerMemory
	signpost 2, 15, SIGNPOST_READ, SpurgeGameCornerMemory
	signpost 3, 15, SIGNPOST_READ, SpurgeGameCornerMemory
	signpost 4, 15, SIGNPOST_READ, SpurgeGameCornerMemory
	signpost 5, 15, SIGNPOST_READ, SpurgeGameCornerMemory
	signpost 5, 22, SIGNPOST_READ, SpurgeGameCornerCardFlip
	signpost 4, 22, SIGNPOST_READ, SpurgeGameCornerCardFlip
	signpost 2, 22, SIGNPOST_READ, SpurgeGameCornerCardFlip
	signpost 3, 22, SIGNPOST_READ, SpurgeGameCornerCardFlip
	signpost 5, 23, SIGNPOST_READ, SpurgeGameCornerCardFlip
	signpost 4, 23, SIGNPOST_READ, SpurgeGameCornerCardFlip
	signpost 2, 23, SIGNPOST_READ, SpurgeGameCornerCardFlip
	signpost 3, 23, SIGNPOST_READ, SpurgeGameCornerCardFlip
	signpost 6, 1, SIGNPOST_READ, SpurgeGameCornerPoker
	signpost 7, 1, SIGNPOST_READ, SpurgeGameCornerPoker
	signpost 8, 1, SIGNPOST_READ, SpurgeGameCornerPoker
	signpost 9, 1, SIGNPOST_READ, SpurgeGameCornerPoker
	signpost 10, 1, SIGNPOST_READ, SpurgeGameCornerPoker
	signpost 11, 1, SIGNPOST_READ, SpurgeGameCornerPoker
	signpost 6, 28, SIGNPOST_READ, SpurgeGameCornerBlackjack
	signpost 7, 28, SIGNPOST_READ, SpurgeGameCornerBlackjack
	signpost 8, 28, SIGNPOST_READ, SpurgeGameCornerBlackjack
	signpost 9, 28, SIGNPOST_READ, SpurgeGameCornerBlackjack
	signpost 10, 28, SIGNPOST_READ, SpurgeGameCornerBlackjack
	signpost 11, 28, SIGNPOST_READ, SpurgeGameCornerBlackjack

.ObjectEvents: db 14
	person_event SPRITE_CLERK, 2, 1, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SpurgeGameCornerCoinVendor, -1
	person_event SPRITE_RECEPTIONIST, 2, 27, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SpurgeGameCornerMonExchange, -1
	person_event SPRITE_RECEPTIONIST, 2, 29, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SpurgeGameCornerTMExchange, -1
	person_event SPRITE_FISHING_GURU, 5, 21, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SpurgeGameCornerNPC1, -1
	person_event SPRITE_RECEPTIONIST, 1, 13, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, SpurgeGameCornerNPC2, -1
	person_event SPRITE_RECEPTIONIST, 1, 5, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, SpurgeGameCornerNPC3, -1
	person_event SPRITE_RECEPTIONIST, 1, 21, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SpurgeGameCornerNPC4, -1
	person_event SPRITE_RECEPTIONIST, 5, 27, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, SpurgeGameCornerNPC5, -1
	person_event SPRITE_RECEPTIONIST, 5, 2, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 0, 0, SpurgeGameCornerNPC6, -1
	person_event SPRITE_FISHER, 8, 2, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SpurgeGameCornerNPC7, -1
	person_event SPRITE_POKEFAN_M, 4, 16, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SpurgeGameCornerNPC8, -1
	person_event SPRITE_POKEFAN_F, 4, 5, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SpurgeGameCornerNPC9, -1
	person_event SPRITE_PHARMACIST, 10, 19, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_PLAYER, 0, 0, SpurgeGameCornerCoinCaseSeller, -1
	person_event SPRITE_COOLTRAINER_M, 11, 27, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SpurgeGameCornerNPC10, -1
