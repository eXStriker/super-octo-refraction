CaperMart_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

CaperMartHiddenItem_1:
	dw EVENT_CAPER_MART_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

CaperMartNPC1:
	faceplayer
	checkevent EVENT_MET_ILK
	iffalse .caperMartClosed
	opentext
	pokemart 0, 0
	closetext
	end

.caperMartClosed:
	jumptext CaperMartClosedText

CaperMartNPC2:
	jumptextfaceplayer CaperMartNPC2_Text_15db26

CaperMartNPC3:
	jumptextfaceplayer CaperMartNPC3_Text_15dada

CaperMartNPC4:
	jumptextfaceplayer CaperMartNPC4_Text_15e270

CaperMartClosedText:
	ctxt "Sorry."

	para "We're stocking"
	line "up on inventory."

	para "Please come back"
	line "later."
	done

CaperMartNPC2_Text_15db26:
	ctxt "I was once accused"
	line "of shoplifting."

	para "I was just trying"
	line "to figure out what"
	cont "I wanted to buy!"
	done

CaperMartNPC3_Text_15dada:
	ctxt "It's waaay too"
	line "cold outside."

	para "I'm staying indoors"
	line "until things start"
	cont "warming up."
	done

CaperMartNPC4_Text_15e270:
	ctxt "Can't you see I'm"
	line "busy here?"
	done

CaperMart_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $6, 1, CAPER_CITY
	warp_def $7, $7, 1, CAPER_CITY

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 1, 10, SIGNPOST_ITEM, CaperMartHiddenItem_1

	;people-events
	db 4
	person_event SPRITE_CLERK, 3, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, CaperMartNPC1, -1
	person_event SPRITE_PSYCHIC, 6, 2, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 1, -1, -1, PAL_OW_RED, 0, 0, CaperMartNPC2, -1
	person_event SPRITE_BUG_CATCHER, 7, 10, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 1, -1, -1, PAL_OW_RED, 0, 0, CaperMartNPC3, -1
	person_event SPRITE_GAMEBOY_KID, 2, 3, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, CaperMartNPC4, -1
