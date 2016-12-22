MoundUpperArea_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MoundUpperAreaNPC1:
	faceplayer
	opentext
	checkevent EVENT_MOUND_CAVE_MYSTIC_WATER_NPC
	iftrue MoundUpperArea_11217a
	writetext MoundUpperAreaNPC1_Text_112182
	buttonsound
	verbosegiveitem MYSTIC_WATER, 1
	iffalse MoundUpperArea_112178
	setevent EVENT_MOUND_CAVE_MYSTIC_WATER_NPC
	closetext
	end

MoundUpperArea_11217a:
	jumptext MoundUpperArea_11217a_Text_11224a

MoundUpperArea_112178:
	closetext
	end

MoundUpperAreaNPC1_Text_112182:
	ctxt "You need a #mon"
	line "to get across the"
	cont "water?"

	para "Can't you swim"
	line "yourself?"

	para "You like my blue"
	line "necklace?"

	para "I found them under"
	line "water, here take"
	cont "one."
	done

MoundUpperArea_11217a_Text_11224a:
	ctxt "You need to learn"
	line "how to swim!"
	done

MoundUpperArea_MapEventHeader:: db 0, 0

.Warps: db 2
	warp_def 7, 25, 1, ROUTE_83
	warp_def 5, 3, 4, ROUTE_69

.CoordEvents: db 0

.BGEvents: db 0

.ObjectEvents: db 3
	person_event SPRITE_COOLTRAINER_M, 2, 17, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MoundUpperAreaNPC1, -1
	person_event SPRITE_POKE_BALL, 7, 11, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 3, TM_MUD_SLAP, 0, EVENT_MOUND_CAVE_TM31
	person_event SPRITE_POKE_BALL, 15, 15, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 3, TM_EARTHQUAKE, 0, EVENT_MOUND_CAVE_TM65
