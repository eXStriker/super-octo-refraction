PhaceliaCity_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw 5, Phacelia_SetFlyFlag

Phacelia_SetFlyFlag:
	setflag ENGINE_FLYPOINT_PHACELIA_TOWN
	return

PhaceliaCitySignpost1:
	jumpstd pokecentersign

PhaceliaCitySignpost2:
	jumpstd martsign

PhaceliaCitySignpost3:
	ctxt "Not quite a"
	next "town yet"
	done ;40

PhaceliaCitySignpost4:
	ctxt "Move deleter"
	done ;41

PhaceliaCityNPC1:
	fruittree 20

PhaceliaCityNPC2:
	jumpstd smashrock

PhaceliaCityNPC3:
	jumpstd smashrock

PhaceliaCityNPC4:
	faceplayer
	opentext
	writetext PhaceliaCityNPC4_Text_2f5f08
	cry MACHOKE
	waitsfx
	endtext

PhaceliaCityNPC5:
	jumptextfaceplayer PhaceliaCityNPC5_Text_2f7488

PhaceliaCityNPC6:
	jumptextfaceplayer PhaceliaCityNPC5_Text_2f7488

PhaceliaCityNPC7:
	jumptextfaceplayer PhaceliaCityNPC7_Text_2f7efa

PhaceliaCityNPC9:
	jumpstd strengthboulder

PhaceliaCityNPC10:
	jumptextfaceplayer PhaceliaCityNPC10_Text_2f5e62

PhaceliaCityNPC11:
	jumpstd smashrock

PhaceliaCityNPC4_Text_2f5f08:
	ctxt "Machoke: Rhahhh!"
	done

PhaceliaCityNPC5_Text_2f7488:
	ctxt "Security's been"
	line "tightened up for"
	cont "the moment."

	para "<...>"

	para "Wait, you're a"
	line "Pallet Patroller?"

	para "We're keeping our"
	line "eyes on your kind."

	para "<...>"

	para "Oh wait, you're"
	line "going undercover?"

	para "Oh, I see."

	para "Well, once you"
	line "help catch one of"
	cont "the patrollers,"
	cont "I'll let you in."
	done

PhaceliaCityNPC7_Text_2f7efa:
	ctxt "According to the"
	line "union rules, I"
	cont "am entitled to"
	cont "a 15 minute break."
	done

PhaceliaCityNPC10_Text_2f5e62:
	ctxt "I aspire to be"
	line "part of Andre's"
	cont "crew someday!"

	para "He was raised by"
	line "a family of"
	cont "Machamp, and has"
	cont "no idea who his"
	cont "real parents are."

	para "He's like half man,"
	line "half Machamp!"
	done

PhaceliaCity_MapEventHeader ;filler
	db 0, 0

;warps
	db 10
	warp_def $3, $a, 3, MILOS_F1
	warp_def $5, $1c, 1, PHACELIA_GYM
	warp_def $7, $5, 1, PHACELIA_POLICE_F1
	warp_def $9, $f, 1, PHACELIA_POKECENTER
	warp_def $7, $19, 1, PHACELIA_MART
	warp_def $15, $6, 1, PHACELIA_WEST_EXIT
	warp_def $15, $b, 1, PHACELIA_MOVE_DELETER
	warp_def $13, $19, 1, PHACELIA_TM20
	warp_def $1d, $f, 1, PHACELIA_SOLROCK_TRADE
	warp_def $19, $20, 1, PHACELIA_EAST_EXIT

	;xy triggers
	db 0

	;signposts
	db 4
	signpost 9, 16, SIGNPOST_READ, PhaceliaCitySignpost1
	signpost 7, 26, SIGNPOST_READ, PhaceliaCitySignpost2
	signpost 20, 18, SIGNPOST_LOAD, PhaceliaCitySignpost3
	signpost 22, 10, SIGNPOST_LOAD, PhaceliaCitySignpost4

	;people-events
	db 11
	person_event SPRITE_FRUIT_TREE, 4, 20, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, PhaceliaCityNPC1, -1
	person_event SPRITE_ROCK, 9, 9, SPRITEMOVEDATA_SMASHABLE_ROCK, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, PhaceliaCityNPC2, -1
	person_event SPRITE_ROCK, 22, 16, SPRITEMOVEDATA_SMASHABLE_ROCK, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, PhaceliaCityNPC3, -1
	person_event SPRITE_MACHOKE, 25, 17, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, PhaceliaCityNPC4, -1
	person_event SPRITE_OFFICER, 6, 28, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, PhaceliaCityNPC5, EVENT_ARRESTED_PALETTE_BLACK
	person_event SPRITE_OFFICER, 4, 10, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, PhaceliaCityNPC6, EVENT_ARRESTED_PALETTE_BLACK
	person_event SPRITE_FISHER, 17, 22, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PhaceliaCityNPC7, -1
	person_event SPRITE_POKE_BALL, 15, 18, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 3, TM_ENERGY_BALL, 0, EVENT_PHACELIA_TM54
	person_event SPRITE_BOULDER, 17, 17, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, PhaceliaCityNPC9, -1
	person_event SPRITE_BLACK_BELT, 12, 13, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PhaceliaCityNPC10, -1
	person_event SPRITE_ROCK, 27, 22, SPRITEMOVEDATA_SMASHABLE_ROCK, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, PhaceliaCityNPC11, -1
