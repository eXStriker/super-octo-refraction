MoragaTown_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw 5, MoragaTown_SetFlyFlag

MoragaTown_SetFlyFlag:
	setflag ENGINE_FLYPOINT_MORAGA_TOWN
	return

MoragaTownHiddenItem_1:
	dw EVENT_MORAGA_TOWN_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

MoragaTownSignpost1:
	ctxt "#mon Gym"
	next "Leader: Lois"
	nl ""
	next "The harmonious"
	next "grassy Trainer!"
	done

MoragaTownSignpost2:
	jumpstd pokecentersign

MoragaTownSignpost3:
	jumpstd martsign

MoragaTownSignpost4:
	ctxt "Not really a town"
	next "at all."
	done

MoragaTownSignpost5:
	ctxt "Closed for"
	next "renovations."
	done

MoragaTown_Item_1:
	db KINGS_ROCK, 1

MoragaTownNPC1:
	jumptextfaceplayer MoragaTownNPC1_Text_33365a

MoragaTownNPC2:
	jumptextfaceplayer MoragaTownNPC2_Text_33359f

MoragaTownNPC3:
	jumptextfaceplayer MoragaTownNPC3_Text_3335de

MoragaTownNPC4:
	jumptextfaceplayer MoragaTownNPC4_Text_3336c3

MoragaTownNPC1_Text_33365a:
	ctxt "Why would someone"
	line "plant the flowers"

	para "in front of the"
	line "entrance way?"

	para "They keep getting"
	line "stepped on!"
	done

MoragaTownNPC2_Text_33359f:
	ctxt "I heard they're"
	line "putting a museum"

	para "in this big"
	line "building."

	para "We could use some"
	line "culture."
	done

MoragaTownNPC3_Text_3335de:
	ctxt "These narrow"
	line "paths often"

	para "create annoying"
	line "walls of people."

	para "Getting them to"
	line "move is harder"

	para "than waking up a"
	line "Snorlax."
	done

MoragaTownNPC4_Text_3336c3:
	ctxt "Why they won't"
	line "let an old man"

	para "visit the gym is"
	line "beyond me!"
	done

MoragaTown_MapEventHeader ;filler
	db 0, 0

;warps
	db 11
	warp_def $21, $2b, 2, MORAGA_GATE_UNDERGROUND
	warp_def $1b, $16, 5, CAPER_CITY
	warp_def $3, $5, 1, MORAGA_TM_MACHINE
	warp_def $5, $1e, 1, MORAGA_GYM
	warp_def $2, $19, 6, CAPER_CITY
	warp_def $7, $27, 1, MORAGA_POKECENTER
	warp_def $1d, $5, 1, MORAGA_DINER
	warp_def $2, $17, 4, OWSAURI_GAME_CORNER
	warp_def $13, $28, 3, SILK_TUNNEL_1F
	warp_def $f, $9, 1, MORAGA_HOUSE
	warp_def $15, $3, 1, MORAGA_MART

	;xy triggers
	db 0

	;signposts
	db 6
	signpost 7, 29, SIGNPOST_LOAD, MoragaTownSignpost1
	signpost 7, 40, SIGNPOST_READ, MoragaTownSignpost2
	signpost 21, 4, SIGNPOST_READ, MoragaTownSignpost3
	signpost 29, 25, SIGNPOST_LOAD, MoragaTownSignpost4
	signpost 27, 33, SIGNPOST_LOAD, MoragaTownSignpost5
	signpost 6, 10, SIGNPOST_ITEM, MoragaTownHiddenItem_1

	;people-events
	db 5
	person_event SPRITE_POKE_BALL, 12, 12, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BROWN, 1, 0, MoragaTown_Item_1, EVENT_MORAGA_TOWN_ITEM_1
	person_event SPRITE_TEACHER, 22, 40, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, MoragaTownNPC1, -1
	person_event SPRITE_POKEFAN_F, 28, 20, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MoragaTownNPC2, -1
	person_event SPRITE_COOLTRAINER_M, 11, 5, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MoragaTownNPC3, -1
	person_event SPRITE_SAGE, 6, 27, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MoragaTownNPC4, -1
