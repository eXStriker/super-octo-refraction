IlexForest_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

IlexForestHiddenItem_1:
	dw EVENT_ILEX_FOREST_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

IlexForestSignpost1:
	jumptext IlexForestSignpost1_Text_323860

IlexForestSignpost2:
	signpostheader 2

	ctxt "Ilex Forest's"
	next "overgrown trees"
	next "block sunlight!"
	nl   ""
	next "Watch out for"
	next "dropped items!"
	done

IlexForest_Item_2:
	db GREEN_FLUTE, 1

IlexForest_Item_3:
	db PP_UP, 2

IlexForestSignpost1_Text_323860:
	ctxt "Ilex Forest"
	line "Shrine<...>"

	para "It's in honor of"
	line "the forest's"
	cont "protector<...>"
	done

IlexForest_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $5, $1, 5, ROUTE_34_GATE
	warp_def $2a, $3, 1, ILEX_FOREST_GATE
	warp_def $2b, $3, 2, ILEX_FOREST_GATE

	;xy triggers
	db 0

	;signposts
	db 3
	signpost 22, 8, SIGNPOST_READ, IlexForestSignpost1
	signpost 17, 3, SIGNPOST_LOAD, IlexForestSignpost2
	signpost 6, 17, SIGNPOST_ITEM, IlexForestHiddenItem_1

	;people-events
	db 2
	person_event SPRITE_POKE_BALL, 22, 26, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_GREEN, 1, 0, IlexForest_Item_2, EVENT_ILEX_FOREST_ITEM_2
	person_event SPRITE_POKE_BALL, 1, 27, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_PURPLE, 1, 0, IlexForest_Item_3, EVENT_ILEX_FOREST_ITEM_3
