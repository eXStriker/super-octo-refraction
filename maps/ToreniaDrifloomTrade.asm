ToreniaDrifloomTrade_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

ToreniaDrifloomTradeNPC1:
	jumptextfaceplayer ToreniaDrifloomTradeNPC1_Text_159628

ToreniaDrifloomTradeNPC2:
	faceplayer
	opentext
	trade 1
	endtext

ToreniaDrifloomTradeNPC1_Text_159628:
	ctxt "Those people in"
	line "Botan City are"
	cont "sure rude."
	done

ToreniaDrifloomTrade_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 7, TORENIA_CITY
	warp_def $7, $3, 7, TORENIA_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_POKEFAN_M, 3, 2, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 0, 0, ToreniaDrifloomTradeNPC1, -1
	person_event SPRITE_YOUNGSTER, 5, 6, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 0, -1, -1, 0, 0, 0, ToreniaDrifloomTradeNPC2, -1
