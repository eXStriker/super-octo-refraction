ToreniaCity_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1

	dbw 5, Torenia_SetFlyFlag

Torenia_SetFlyFlag:
	setflag ENGINE_FLYPOINT_TORENIA_CITY
	return

ToreniaCitySignpost1:
	ctxt "#mon Gym"
	next "Leader: Edison"
	done ;33

ToreniaCitySignpost2:
	ctxt "Magnet Train"
	done ;30

ToreniaCitySignpost3:
	ctxt "The region's"
	next "youngest city"
	done ;31

ToreniaCitySignpost4:
	jumpstd pokecentersign

ToreniaCitySignpost5:
	jumpstd martsign

ToreniaCitySignpost6:
	ctxt "Pachisi Hall"
	done ;29

ToreniaCityNPC2:
	jumptextfaceplayer ToreniaCityNPC2_Text_120ddf

ToreniaCityNPC3:
	jumptextfaceplayer ToreniaCityNPC3_Text_120e49

ToreniaCityNPC4:
	jumptextfaceplayer ToreniaCityNPC4_Text_120ea5

ToreniaCityNPC5:
	jumptextfaceplayer ToreniaCityNPC5_Text_120f1b

ToreniaCityNPC6:
	fruittree 18

ToreniaCity_Item_1:
	db PP_UP, 1

ToreniaCity_Item_2:
	db RARE_CANDY, 1

ToreniaCityNPC2_Text_120ddf:
	ctxt "The Pachisi board"
	line "is so much fun!"

	para "I actually caught"
	line "a new #mon"
	cont "there recently!"
	done

ToreniaCityNPC3_Text_120e49:
	ctxt "Living here at"
	line "a time like this<...>"

	para "It's like being a"
	line "part of history."
	done

ToreniaCityNPC4_Text_120ea5:
	ctxt "Last time I spoke"
	line "to the Gym Leader,"
	cont "he said he wished"
	cont "he could dream."

	para "What's the big deal"
	line "about dreaming?"

	para "Dreams scare me."
	done

ToreniaCityNPC5_Text_120f1b:
	ctxt "This city is gonna"
	line "be huge once the"
	cont "expansion is done."
	done

ToreniaCity_MapEventHeader ;filler
	db 0, 0

;warps
	db 12
	warp_def $13, $15, 1, TORENIA_MART
	warp_def $1f, $22, 1, TORENIA_GYM
	warp_def $5, $9, 2, LAUREL_FOREST_GATES
	warp_def $b, $1c, 1, TORENIA_MAGNET_TRAIN
	warp_def $b, $d, 1, TORENIA_POKECENTER
	warp_def $13, $10, 1, TORENIA_PACHISI
	warp_def $b, $17, 1, TORENIA_DRIFLOOM_TRADE
	warp_def $c, $21, 1, ROUTE_82_GATE
	warp_def $d, $21, 2, ROUTE_82_GATE
	warp_def $13, $9, 1, TORENIA_CELEBRITY
	warp_def $1b, $b, 1, TORENIA_GATE
	warp_def $1b, $c, 2, TORENIA_GATE

	;xy triggers
	db 0

	;signposts
	db 6
	signpost 31, 31, SIGNPOST_LOAD, ToreniaCitySignpost1
	signpost 12, 30, SIGNPOST_LOAD, ToreniaCitySignpost2
	signpost 6, 10, SIGNPOST_LOAD, ToreniaCitySignpost3
	signpost 11, 14, SIGNPOST_READ, ToreniaCitySignpost4
	signpost 19, 22, SIGNPOST_READ, ToreniaCitySignpost5
	signpost 19, 13, SIGNPOST_LOAD, ToreniaCitySignpost6

	;people-events
	db 7
	person_event SPRITE_PICNICKER, 23, 12, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 8 + PAL_OW_BLUE, 0, 0, ToreniaCityNPC2, -1
	person_event SPRITE_PICNICKER, 14, 24, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_PURPLE, 0, 0, ToreniaCityNPC3, -1
	person_event SPRITE_GRAMPS, 11, 6, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 1, -1, -1, PAL_OW_RED, 0, 0, ToreniaCityNPC4, -1
	person_event SPRITE_YOUNGSTER, 18, 5, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, 8 + PAL_OW_GREEN, 0, 0, ToreniaCityNPC5, -1
	person_event SPRITE_FRUIT_TREE, 24, 31, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, 0, 0, 0, ToreniaCityNPC6, -1
	person_event SPRITE_POKE_BALL, 31, 0, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, ToreniaCity_Item_1, EVENT_TORENIA_CITY_ITEM_1
	person_event SPRITE_POKE_BALL, 7, 30, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, ToreniaCity_Item_2, EVENT_TORENIA_CITY_ITEM_2
