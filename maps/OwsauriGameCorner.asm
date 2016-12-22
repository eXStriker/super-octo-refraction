OwsauriGameCorner_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

OwsauriGameCornerHiddenItem:
	dw EVENT_OWSAURI_GAME_CORNER_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

OwsauriBlackjack:
	farjump GameCornerBlackjack

OwsauriPoker:
	farjump GameCornerPoker

OwsauriGameCornerMonExchange:
	faceplayer
	opentext
	special Special_DisplayCoinCaseBalance
	writetext OwsauriGameCorner_Text_ExchangeGameCoins
	waitbutton
	writetext OwsauriGameCornerMonExchange_Text_WhichMon
	loadmenudata OwsauriGameCornerPokemonMenu
	verticalmenu
	closewindow
	anonjumptable
	dw .done
	dw OwsauriGameCorner_MonExchange_GetSneasel
	dw OwsauriGameCorner_MonExchange_GetAbsol
	dw OwsauriGameCorner_MonExchange_GetSpiritomb
.done
	closetext
	end

OwsauriGameCornerTMExchange:
	faceplayer
	opentext
	special Special_DisplayCoinCaseBalance
	writetext OwsauriGameCorner_Text_ExchangeGameCoins
	waitbutton
	writetext OwsauriGameCornerTMExchange_Text_WhichTM
	loadmenudata OwsauriGameCornerTMMenu
	verticalmenu
	closewindow
	anonjumptable
	dw .done
	dw OwsauriGameCorner_TMExchange_GetTM84
	dw OwsauriGameCorner_TMExchange_GetTM85
	dw OwsauriGameCorner_TMExchange_GetTM86
.done
	closetext
	end

OwsauriGameCornerTMMenu:
	db $40 ; flags
	db 03, 05 ; start coords
	db 11, 19 ; end coords
	dw OwsauriGameCornerTMOptions
	db 1 ; default option

OwsauriGameCornerTMOptions:
	db $80
	db $3
	db "TM84    3000@"
	db "TM85    3000@"
	db "TM86    3000@"

OwsauriGameCornerPokemonMenu:
	db $40 ; flags
	db 03, 00 ; start coords
	db 11, 19 ; end coords
	dw OwsauriGameCornerPokemonOptions
	db 1 ; default option

OwsauriGameCornerPokemonOptions:
	db $80
	db $3
	db "Sneasel      2500@"
	db "Absol        5000@"
	db "Spiritomb    7500@"

OwsauriGameCornerCoinVendor:
	jumpstd gamecornercoinvendor

OwsauriGameCornerNPC1:
	jumptextfaceplayer OwsauriGameCornerNPC1_Text

OwsauriGameCornerNPC2:
	jumptextfaceplayer OwsauriGameCornerNPC2_Text

OwsauriGameCornerNPC3:
	jumptextfaceplayer OwsauriGameCornerNPC3_Text

OwsauriGameCornerNPC4:
	jumptextfaceplayer OwsauriGameCornerNPC4_Text

OwsauriGameCornerNPC5:
	jumptextfaceplayer OwsauriGameCornerNPC5_Text

OwsauriGameCornerNPC6:
	jumptextfaceplayer OwsauriGameCornerNPC6_Text

OwsauriMemoryGame:
	farjump SpurgeGameCornerMemory

OwsauriSlots::
	random 6
	sif >, 1
		writebyte 0
	refreshscreen 0
	special Special_SlotMachine
	closetext
	end

OwsauriCardFlip:
	random 6
	sif >, 1
		writebyte 0
	refreshscreen 0
	special Special_CardFlip
	closetext
	end

OwsauriGameCorner_MonExchange_GetSneasel:
	writebyte SNEASEL
	copyvartobyte TempBattleMonSpecies
	pokenamemem 0, 0
	writetext OwsauriGameCorner_MonExchange_Text_WantThisMon
	yesorno
	sif false, then
		closetext
		end
	sendif
	checkcode VAR_PARTYCOUNT
	sif >, 5
		jumptext OwsauriGameCorner_Text_NoRoomInParty
	checkcoins 2500
	sif =, 2
		jumptext OwsauriGameCorner_Text_NeedMoreCoins
	takecoins 2500
	; fallthrough

OwsauriGameCorner_MonExchange_ReceiveMon:
	writetext OwsauriGameCorner_Text_HereYouGo
	waitbutton
	writetext OwsauriGameCorner_MonExchange_Text_ReceivedMon
	playwaitsfx SFX_DEX_FANFARE_80_109
	copybytetovar TempBattleMonSpecies
	givepoke 0, 21, NO_ITEM, 0
	closetext
	end

OwsauriGameCorner_MonExchange_GetAbsol:
	writebyte ABSOL
	copyvartobyte TempBattleMonSpecies
	pokenamemem 0, 0
	writetext OwsauriGameCorner_MonExchange_Text_WantThisMon
	yesorno
	sif false, then
		closetext
		end
	sendif
	checkcode VAR_PARTYCOUNT
	sif >, 5
		jumptext OwsauriGameCorner_Text_NoRoomInParty
	checkcoins 5000
	sif =, 2
		jumptext OwsauriGameCorner_Text_NeedMoreCoins
	takecoins 5000
	jump OwsauriGameCorner_MonExchange_ReceiveMon

OwsauriGameCorner_MonExchange_GetSpiritomb:
	writebyte SPIRITOMB
	copyvartobyte TempBattleMonSpecies
	pokenamemem 0, 0
	writetext OwsauriGameCorner_MonExchange_Text_WantThisMon
	yesorno
	sif false, then
		closetext
		end
	sendif
	checkcode VAR_PARTYCOUNT
	sif >, 5
		jumptext OwsauriGameCorner_Text_NoRoomInParty
	checkcoins 7500
	sif =, 2
		jumptext OwsauriGameCorner_Text_NeedMoreCoins
	takecoins 7500
	jump OwsauriGameCorner_MonExchange_ReceiveMon

OwsauriGameCorner_TMExchange_GetTM84:
	writebyte 84
	; fallthrough

OwsauriGameCorner_TMExchange_DoExchange::
	scriptstartasm
	ld a, [hScriptVar]
	ld [TempNumber], a
	ld [wCurTMHM], a
	ld hl, TMsHMs
	ld c, a
	dec c
	ld b, CHECK_FLAG
	call FlagAction
	ld hl, .got_TM
	ret nz
	callba GetTMHMMove
	call GetMoveName
	scriptstopasm
	writetext OwsauriGameCorner_TMExchange_Text_ThisTMIs
	yesorno
	iffalse .done
	checkcoins 3000
	sif =, 2
		jumptext OwsauriGameCorner_Text_NeedMoreCoins
	takecoins 3000
	writetext OwsauriGameCorner_Text_HereYouGo
	waitbutton
	copybytetovar TempNumber
	givetm 0 + RECEIVED_TM
.done
	closetext
	end
.got_TM
	jumptext OwsauriGameCorner_Text_AlreadyGotTM

OwsauriGameCorner_TMExchange_GetTM85:
	writebyte 85
	jump OwsauriGameCorner_TMExchange_DoExchange

OwsauriGameCorner_TMExchange_GetTM86:
	writebyte 86
	jump OwsauriGameCorner_TMExchange_DoExchange

OwsauriGameCorner_Text_ExchangeGameCoins::
	ctxt "Welcome!"

	para "We exchange your"
	line "game coins for"
	cont "fabulous prizes!"
	done

OwsauriGameCornerMonExchange_Text_WhichMon::
	ctxt "Which #mon"
	line "would you like?"
	done

OwsauriGameCornerTMExchange_Text_WhichTM::
	ctxt "Which TM would"
	line "you like?"
	done

OwsauriGameCornerNPC1_Text:
	ctxt "I make a living"
	line "with this!"

	para "I found a guy"
	line "who'll exchange"

	para "coins for real"
	line "money."

	para "They'd kick me"
	line "out of here if"

	para "they knew I did"
	line "that though."
	done

OwsauriGameCornerNPC2_Text:
	ctxt "A royal flush"
	line "will give you"
	cont "2500 coins."

	para "If you think you"
	line "have a shot at a"

	para "royal flush,"
	line "go for that no"
	cont "matter what."
	done

OwsauriGameCornerNPC3_Text:
	ctxt "If you don't have"
	line "a Coin Case"

	para "already, get one"
	line "in Spurge City"
	cont "in Naljo."

	para "Some shady guy"
	line "sells them there."
	done

OwsauriGameCornerNPC4_Text:
	ctxt "Watching the reels"
	line "close enough will"

	para "help you reach"
	line "your goal."
	done

OwsauriGameCornerNPC5_Text:
	ctxt "These new card"
	line "games are so"
	cont "addicting!"

	para "It's absolutely"
	line "crazy!"
	done

OwsauriGameCornerNPC6_Text:
	ctxt "Some people say"
	line "that different"

	para "game corners have"
	line "different odds,"

	para "but I don't believe"
	line "it."
	done

OwsauriGameCorner_MonExchange_Text_WantThisMon:
	ctxt "Do you want this"
	line "<STRBF3>?"
	done

OwsauriGameCorner_Text_HereYouGo::
	ctxt "Here you go!"
	done

OwsauriGameCorner_MonExchange_Text_ReceivedMon::
	ctxt "<PLAYER> received"
	line "<STRBF3>!"
	done

OwsauriGameCorner_TMExchange_Text_ThisTMIs:
	ctxt "This TM is"
	line "<STRBF1>!"

	para "Want it?"
	done

OwsauriGameCorner_Text_NoRoomInParty::
	ctxt "Free up some"
	line "space in your"
	cont "party first!"
	done

OwsauriGameCorner_Text_NeedMoreCoins::
	ctxt "Looks like you"
	line "need more coins"
	cont "for that."
	done

OwsauriGameCorner_Text_AlreadyGotTM:
	ctxt "You already have"
	line "this TM!"
	done

OwsauriGameCorner_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $11, $2, 7, OWSAURI_CITY
	warp_def $11, $3, 7, OWSAURI_CITY
	warp_def $0, $6, 1, CAPER_CITY

	;xy triggers
	db 0

	;signposts
	db 48
	signpost 8, 1, SIGNPOST_READ, OwsauriMemoryGame
	signpost 9, 1, SIGNPOST_READ, OwsauriMemoryGame
	signpost 10, 1, SIGNPOST_READ, OwsauriMemoryGame
	signpost 11, 1, SIGNPOST_READ, OwsauriMemoryGame
	signpost 12, 1, SIGNPOST_READ, OwsauriMemoryGame
	signpost 13, 1, SIGNPOST_READ, OwsauriMemoryGame
	signpost 14, 1, SIGNPOST_READ, OwsauriMemoryGame
	signpost 15, 1, SIGNPOST_READ, OwsauriMemoryGame
	signpost 8, 6, SIGNPOST_READ, OwsauriSlots
	signpost 9, 6, SIGNPOST_READ, OwsauriSlots
	signpost 10, 6, SIGNPOST_READ, OwsauriSlots
	signpost 11, 6, SIGNPOST_READ, OwsauriSlots
	signpost 12, 6, SIGNPOST_READ, OwsauriSlots
	signpost 13, 6, SIGNPOST_READ, OwsauriSlots
	signpost 14, 6, SIGNPOST_READ, OwsauriSlots
	signpost 15, 6, SIGNPOST_READ, OwsauriSlots
	signpost 8, 7, SIGNPOST_READ, OwsauriSlots
	signpost 9, 7, SIGNPOST_READ, OwsauriSlots
	signpost 10, 7, SIGNPOST_READ, OwsauriSlots
	signpost 11, 7, SIGNPOST_READ, OwsauriSlots
	signpost 12, 7, SIGNPOST_READ, OwsauriSlots
	signpost 13, 7, SIGNPOST_READ, OwsauriSlots
	signpost 14, 7, SIGNPOST_READ, OwsauriSlots
	signpost 15, 7, SIGNPOST_READ, OwsauriSlots
	signpost 8, 12, SIGNPOST_READ, OwsauriPoker
	signpost 9, 12, SIGNPOST_READ, OwsauriPoker
	signpost 10, 12, SIGNPOST_READ, OwsauriPoker
	signpost 11, 12, SIGNPOST_READ, OwsauriPoker
	signpost 12, 12, SIGNPOST_READ, OwsauriPoker
	signpost 13, 12, SIGNPOST_READ, OwsauriPoker
	signpost 14, 12, SIGNPOST_READ, OwsauriPoker
	signpost 8, 13, SIGNPOST_READ, OwsauriBlackjack
	signpost 9, 13, SIGNPOST_READ, OwsauriBlackjack
	signpost 10, 13, SIGNPOST_ITEM, OwsauriGameCornerHiddenItem
	signpost 11, 13, SIGNPOST_READ, OwsauriBlackjack
	signpost 12, 13, SIGNPOST_READ, OwsauriBlackjack
	signpost 13, 13, SIGNPOST_READ, OwsauriBlackjack
	signpost 14, 13, SIGNPOST_READ, OwsauriBlackjack
	signpost 15, 12, SIGNPOST_READ, OwsauriPoker
	signpost 15, 13, SIGNPOST_READ, OwsauriBlackjack
	signpost 8, 18, SIGNPOST_READ, OwsauriCardFlip
	signpost 9, 18, SIGNPOST_READ, OwsauriCardFlip
	signpost 10, 18, SIGNPOST_READ, OwsauriCardFlip
	signpost 11, 18, SIGNPOST_READ, OwsauriCardFlip
	signpost 12, 18, SIGNPOST_READ, OwsauriCardFlip
	signpost 13, 18, SIGNPOST_READ, OwsauriCardFlip
	signpost 14, 18, SIGNPOST_READ, OwsauriCardFlip
	signpost 15, 18, SIGNPOST_READ, OwsauriCardFlip

	;people-events
	db 9
	person_event SPRITE_RECEPTIONIST, 4, 16, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, OwsauriGameCornerMonExchange, -1
	person_event SPRITE_RECEPTIONIST, 4, 14, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, OwsauriGameCornerTMExchange, -1
	person_event SPRITE_CLERK, 4, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, OwsauriGameCornerCoinVendor, -1
	person_event SPRITE_BUENA, 14, 2, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, OwsauriGameCornerNPC1, -1
	person_event SPRITE_TEACHER, 11, 14, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, OwsauriGameCornerNPC2, -1
	person_event SPRITE_LASS, 10, 11, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, OwsauriGameCornerNPC3, -1
	person_event SPRITE_COOLTRAINER_M, 13, 17, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, OwsauriGameCornerNPC4, -1
	person_event SPRITE_FISHER, 12, 5, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, OwsauriGameCornerNPC5, -1
	person_event SPRITE_ROCKER, 9, 2, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, OwsauriGameCornerNPC6, -1
