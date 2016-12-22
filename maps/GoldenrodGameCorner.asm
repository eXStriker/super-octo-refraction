GoldenrodGameCorner_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

GoldenrodGameCornerPoker:
	farjump GameCornerPoker

GoldenrodGameCornerNPC1:
	jumptextfaceplayer GoldenrodGameCornerNPC1_Text

GoldenrodGameCornerNPC2:
	jumptextfaceplayer GoldenrodGameCornerNPC2_Text

GoldenrodGameCornerNPC3:
	jumptextfaceplayer GoldenrodGameCornerNPC3_Text

GoldenrodGameCornerNPC4:
	jumptextfaceplayer GoldenrodGameCornerNPC4_Text

GoldenrodGameCornerMonExchange:
	faceplayer
	opentext
	special Special_DisplayCoinCaseBalance
	farwritetext OwsauriGameCorner_Text_ExchangeGameCoins
	waitbutton
	farwritetext OwsauriGameCornerMonExchange_Text_WhichMon
	loadmenudata GoldenrodGameCornerPokemonMenu
	verticalmenu
	closewindow
	anonjumptable
	dw .done
	dw GoldenrodGameCorner_MonExchange_GetEevee
	dw GoldenrodGameCorner_MonExchange_GetBagon
	dw GoldenrodGameCorner_MonExchange_GetPorygon
.done
	closetext
	end

GoldenrodGameCornerTMExchange:
	faceplayer
	opentext
	special Special_DisplayCoinCaseBalance
	farwritetext OwsauriGameCorner_Text_ExchangeGameCoins
	waitbutton
	farwritetext OwsauriGameCornerTMExchange_Text_WhichTM
	loadmenudata GoldenrodGameCornerTMMenu
	verticalmenu
	closewindow
	anonjumptable
	dw .done
	dw GoldenrodGameCorner_TMExchange_GetTM72
	dw GoldenrodGameCorner_TMExchange_GetTM73
	dw GoldenrodGameCorner_TMExchange_GetTM74
.done
	closetext
	end

GoldenrodGameCornerCoinVendor:
	jumpstd gamecornercoinvendor

GoldenrodGameCornerSlots:
	farjump OwsauriSlots

GoldenrodGameCornerBlackjack:
	farjump GameCornerBlackjack

GoldenrodGameCornerMemory:
	farjump SpurgeGameCornerMemory

GoldenrodGameCornerCardFlip:
	farjump SpurgeGameCornerCardFlip

GoldenrodGameCorner_MonExchange_GetEevee:
	pokenamemem EEVEE, 0
	writetext GoldenrodGameCorner_MonExchange_Text_AreYouSure
	yesorno
	iffalse .done
	checkcode VAR_PARTYCOUNT
	sif >, 5
		farjumptext OwsauriGameCorner_Text_NoRoomInParty
	checkcoins 1000
	sif =, 2
		farjumptext OwsauriGameCorner_Text_NeedMoreCoins
	takecoins 1000
	farwritetext OwsauriGameCorner_Text_HereYouGo
	waitbutton
	farwritetext OwsauriGameCorner_MonExchange_Text_ReceivedMon
	playwaitsfx SFX_DEX_FANFARE_80_109
	givepoke EEVEE, 21, NO_ITEM, 0
.done
	closetext
	end

GoldenrodGameCorner_MonExchange_GetBagon:
	pokenamemem BAGON, 0
	writetext GoldenrodGameCorner_MonExchange_Text_AreYouSure
	yesorno
	iffalse .done
	checkcode VAR_PARTYCOUNT
	sif >, 5
		farjumptext OwsauriGameCorner_Text_NoRoomInParty
	checkcoins 3000
	sif =, 2
		farjumptext OwsauriGameCorner_Text_NeedMoreCoins
	takecoins 3000
	farwritetext OwsauriGameCorner_Text_HereYouGo
	waitbutton
	farwritetext OwsauriGameCorner_MonExchange_Text_ReceivedMon
	playwaitsfx SFX_DEX_FANFARE_80_109
	givepoke BAGON, 15, NO_ITEM, 0
.done
	closetext
	end

GoldenrodGameCorner_MonExchange_GetPorygon:
	pokenamemem PORYGON, 0
	writetext GoldenrodGameCorner_MonExchange_Text_AreYouSure
	yesorno
	iffalse .done
	checkcode VAR_PARTYCOUNT
	sif >, 5
		farjumptext OwsauriGameCorner_Text_NoRoomInParty
	checkcoins 5000
	sif =, 2
		farjumptext OwsauriGameCorner_Text_NeedMoreCoins
	takecoins 5000
	farwritetext OwsauriGameCorner_Text_HereYouGo
	waitbutton
	farwritetext OwsauriGameCorner_MonExchange_Text_ReceivedMon
	playwaitsfx SFX_DEX_FANFARE_80_109
	givepoke PORYGON, 21, NO_ITEM, 0
.done
	closetext
	end

GoldenrodGameCorner_TMExchange_GetTM72:
	writebyte 72
	farjump OwsauriGameCorner_TMExchange_DoExchange

GoldenrodGameCorner_TMExchange_GetTM73:
	writebyte 73
	farjump OwsauriGameCorner_TMExchange_DoExchange

GoldenrodGameCorner_TMExchange_GetTM74:
	writebyte 74
	farjump OwsauriGameCorner_TMExchange_DoExchange

GoldenrodGameCornerTMMenu:
	db $40 ; flags
	db 03, 05 ; start coords
	db 11, 19 ; end coords
	dw GoldenrodGameCornerTMOptions
	db 1 ; default option

GoldenrodGameCornerTMOptions:
	db $80
	db $3
	db "TM72    5500@"
	db "TM73    5500@"
	db "TM74    5500@"

GoldenrodGameCornerPokemonMenu:
	db $40 ; flags
	db 03, 00 ; start coords
	db 11, 19 ; end coords
	dw GoldenrodGameCornerPokemonOptions
	db 1 ; default option

GoldenrodGameCornerPokemonOptions:
	db $80
	db $3
	db "Eevee        1000@"
	db "Bagon        3000@"
	db "Porygon      5000@"

GoldenrodGameCornerNPC1_Text:
	ctxt "Hi, they call me"
	line "DJ Ben!"

	para "I used to host a"
	line "rockin' #mon"

	para "music show before"
	line "that quake ruined"
	cont "the Radio Tower."

	para "Now I spend most"
	line "of my time"

	para "playing this"
	line "card game."

	para "I'll continue to"
	line "do so until I"

	para "can start DJing"
	line "again!"
	done

GoldenrodGameCornerNPC2_Text:
	ctxt "The TMs they"
	line "offer here are"
	cont "phenomenal!"

	para "Make sure to grab"
	line "them when you"
	cont "get the chance."
	done

GoldenrodGameCornerNPC3_Text:
	ctxt "I finally found"
	line "my game:"
	cont "Blackjack!"

	para "If you're looking"
	line "for a Coin Case,"

	para "a person in a"
	line "faraway city"

	para "sells them right"
	line "in their Game"
	cont "Corner."

	para "But you didn't hear"
	line "that from me."
	done

GoldenrodGameCornerNPC4_Text:
	ctxt "You can't beat the"
	line "classic one armed"
	cont "bandit game."
	done

GoldenrodGameCorner_MonExchange_Text_AreYouSure:
	ctxt "Are you sure you"
	line "want <STRBF3>?"
	done

GoldenrodGameCorner_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $d, $2, 11, GOLDENROD_CITY
	warp_def $d, $3, 11, GOLDENROD_CITY

	;xy triggers
	db 0

	;signposts
	db 32
	signpost 6, 1, SIGNPOST_READ, GoldenrodGameCornerSlots
	signpost 8, 1, SIGNPOST_READ, GoldenrodGameCornerSlots
	signpost 9, 1, SIGNPOST_READ, GoldenrodGameCornerSlots
	signpost 10, 1, SIGNPOST_READ, GoldenrodGameCornerSlots
	signpost 11, 1, SIGNPOST_READ, GoldenrodGameCornerSlots
	signpost 6, 6, SIGNPOST_READ, GoldenrodGameCornerSlots
	signpost 7, 6, SIGNPOST_READ, GoldenrodGameCornerSlots
	signpost 8, 6, SIGNPOST_READ, GoldenrodGameCornerSlots
	signpost 10, 6, SIGNPOST_READ, GoldenrodGameCornerSlots
	signpost 11, 6, SIGNPOST_READ, GoldenrodGameCornerSlots
	signpost 6, 7, SIGNPOST_READ, GoldenrodGameCornerPoker
	signpost 7, 7, SIGNPOST_READ, GoldenrodGameCornerPoker
	signpost 8, 7, SIGNPOST_READ, GoldenrodGameCornerPoker
	signpost 9, 7, SIGNPOST_READ, GoldenrodGameCornerPoker
	signpost 10, 7, SIGNPOST_READ, GoldenrodGameCornerPoker
	signpost 11, 7, SIGNPOST_READ, GoldenrodGameCornerPoker
	signpost 6, 12, SIGNPOST_READ, GoldenrodGameCornerBlackjack
	signpost 7, 12, SIGNPOST_READ, GoldenrodGameCornerBlackjack
	signpost 6, 13, SIGNPOST_READ, GoldenrodGameCornerBlackjack
	signpost 9, 12, SIGNPOST_READ, GoldenrodGameCornerBlackjack
	signpost 10, 12, SIGNPOST_READ, GoldenrodGameCornerBlackjack
	signpost 11, 12, SIGNPOST_READ, GoldenrodGameCornerBlackjack
	signpost 7, 13, SIGNPOST_READ, GoldenrodGameCornerMemory
	signpost 8, 13, SIGNPOST_READ, GoldenrodGameCornerMemory
	signpost 9, 13, SIGNPOST_READ, GoldenrodGameCornerMemory
	signpost 10, 13, SIGNPOST_READ, GoldenrodGameCornerMemory
	signpost 11, 13, SIGNPOST_READ, GoldenrodGameCornerMemory
	signpost 6, 18, SIGNPOST_READ, GoldenrodGameCornerCardFlip
	signpost 8, 18, SIGNPOST_READ, GoldenrodGameCornerCardFlip
	signpost 9, 18, SIGNPOST_READ, GoldenrodGameCornerCardFlip
	signpost 10, 18, SIGNPOST_READ, GoldenrodGameCornerCardFlip
	signpost 11, 18, SIGNPOST_READ, GoldenrodGameCornerCardFlip

	;people-events
	db 7
	person_event SPRITE_ROCKER, 7, 17, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, 0, 0, GoldenrodGameCornerNPC1, -1
	person_event SPRITE_PHARMACIST, 9, 5, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, GoldenrodGameCornerNPC2, -1
	person_event SPRITE_POKEFAN_M, 8, 11, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, GoldenrodGameCornerNPC3, -1
	person_event SPRITE_GRANNY, 7, 2, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_PURPLE, 0, 0, GoldenrodGameCornerNPC4, -1
	person_event SPRITE_RECEPTIONIST, 2, 18, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 0, 0, GoldenrodGameCornerMonExchange, -1
	person_event SPRITE_RECEPTIONIST, 2, 16, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 0, 0, GoldenrodGameCornerTMExchange, -1
	person_event SPRITE_CLERK, 2, 3, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 0, 0, GoldenrodGameCornerCoinVendor, -1
