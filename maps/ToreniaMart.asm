ToreniaMart_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

ToreniaMartHiddenItem_1:
	dw EVENT_TORENIA_MART_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

ToreniaMartNPC1:
	faceplayer
	opentext
	pokemart 0, 8
	closetext
	end

ToreniaMartNPC2:
	jumptextfaceplayer ToreniaMartNPC2_Text_15800f

ToreniaMartNPC3:
	jumptextfaceplayer ToreniaMartNPC3_Text_158090

ToreniaMartNPC2_Text_15800f:
	ctxt "Construction is on"
	line "hiatus for now."

	para "Good thing!"

	para "The noise was"
	line "very annoying."
	done

ToreniaMartNPC3_Text_158090:
	ctxt "I just can't make"
	line "my mind up<...>"

	para "So much to buy,"
	line "so little money!"
	done

ToreniaMart_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $6, 1, TORENIA_CITY
	warp_def $7, $7, 1, TORENIA_CITY

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 1, 11, SIGNPOST_ITEM, ToreniaMartHiddenItem_1

	;people-events
	db 3
	person_event SPRITE_CLERK, 3, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, ToreniaMartNPC1, -1
	person_event SPRITE_GRANNY, 6, 10, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, ToreniaMartNPC2, -1
	person_event SPRITE_COOLTRAINER_M, 2, 0, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 0, 0, 0, ToreniaMartNPC3, -1
