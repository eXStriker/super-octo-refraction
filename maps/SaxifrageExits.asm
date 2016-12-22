SaxifrageExits_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SaxifrageExitsNPC1:
	jumptextfaceplayer SaxifrageExitsNPC1_Text_110d3b

SaxifrageExitsNPC2:
	jumptextfaceplayer SaxifrageExitsNPC2_Text_110cd4

SaxifrageExits_Item_1:
	db MINING_PICK, 2

SaxifrageExitsNPC1_Text_110d3b:
	ctxt "I've finally"
	line "escaped this"
	cont "wretched town!"

	para "Now if only I had"
	line "a #mon that"
	cont "could learn Surf!"
	done

SaxifrageExitsNPC2_Text_110cd4:
	ctxt "If you don't have"
	line "some form of ID,"

	para "you'll get into"
	line "real trouble if"
	cont "you go eastward."
	done

SaxifrageExits_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $5, $3, 6, SAXIFRAGE_ISLAND
	warp_def $5, $11, 5, ROUTE_80
	warp_def $f, $3, 2, ROUTE_79
	warp_def $f, $11, 5, SAXIFRAGE_ISLAND

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 4
	person_event SPRITE_SAILOR, 2, 13, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 3, SaxifrageExitsNPC1, -1
	person_event SPRITE_YOUNGSTER, 12, 10, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 4, SaxifrageExitsNPC2, -1
	person_event SPRITE_POKE_BALL, 3, 5, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BLUE, 3, TM_IRON_TAIL, 0, EVENT_SAXIFRAGE_EXITS_NPC_3
	person_event SPRITE_POKE_BALL, 15, 7, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 1, 0, SaxifrageExits_Item_1, EVENT_SAXIFRAGE_EXITS_ITEM_1
