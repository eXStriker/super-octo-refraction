OwsauriCity_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw 5, OwsauriCity_SetFlyFlag

OwsauriCity_SetFlyFlag:
	setflag ENGINE_FLYPOINT_OWSAURI_CITY
	return

OwsauriCitySignpost1:
	ctxt "#mon in-depth"
	done

OwsauriCitySignpost2:
	ctxt "Name Rater"
	done

OwsauriCitySignpost3:
	jumpstd martsign

OwsauriCitySignpost4:
	jumpstd pokecentersign

OwsauriCitySignpost5:
	ctxt "#mon Gym"
	next "Leader: Lily"
	nl   ""
	next "The cold 'n icy"
	next "Trainer!"
	done

OwsauriCityNPC1:
	jumptextfaceplayer OwsauriCityNPC1_Text_33302a

OwsauriCityNPC2:
	jumptextfaceplayer OwsauriCityNPC2_Text_332e87

OwsauriCityNPC3:
	jumptextfaceplayer OwsauriCityNPC3_Text_332fc1

OwsauriCityNPC4:
	jumptextfaceplayer OwsauriCityNPC4_Text_332ece

OwsauriCityNPC5:
	fruittree 10

OwsauriCityNPC1_Text_33302a:
	ctxt "All those air"
	line "conditioners in"

	para "that gym forced"
	line "various people"

	para "to renovate the"
	line "local Power Plant."

	para "I guess the ice"
	line "#mon must be"

	para "comfortable in"
	line "there."
	done

OwsauriCityNPC2_Text_332e87:
	ctxt "Just tending to"
	line "the garden<...>"

	para "I got these"
	line "flowers from"
	cont "Johto!"
	done

OwsauriCityNPC3_Text_332fc1:
	ctxt "They added a bunch"
	line "of new games to"
	cont "the Game Corner."

	para "I was getting"
	line "tired of only"
	cont "slots."
	done

OwsauriCityNPC4_Text_332ece:
	ctxt "While they were"
	line "making new"

	para "buildings in"
	line "Goldenrod after"

	para "that earthquake"
	line "a couple of"

	para "years ago, we"
	line "had quite a few"

	para "of those people"
	line "move here."

	para "Some moved back"
	line "after the"

	para "construction, but"
	line "others stayed."

	para "I'm always open to"
	line "diversity!"
	done

OwsauriCity_MapEventHeader:: db 0, 0

.Warps: db 9
	warp_def 21, 3, 1, OWSAURI_NAMERATER
	warp_def 23, 17, 1, OWSAURI_MART
	warp_def 23, 33, 1, OWSAURI_POKECENTER
	warp_def 31, 32, 1, OWSAURI_GYM
	warp_def 9, 12, 1, OWSAURI_STATEXP
	warp_def 28, 4, 3, CASTRO_GYM
	warp_def 23, 21, 1, OWSAURI_GAME_CORNER
	warp_def 23, 27, 5, CAPER_CITY
	warp_def 23, 9, 1, OWSAURI_HOUSE

.CoordEvents: db 0

.BGEvents: db 5
	signpost 11, 13, SIGNPOST_LOAD, OwsauriCitySignpost1
	signpost 23, 5, SIGNPOST_LOAD, OwsauriCitySignpost2
	signpost 23, 18, SIGNPOST_READ, OwsauriCitySignpost3
	signpost 23, 34, SIGNPOST_READ, OwsauriCitySignpost4
	signpost 33, 33, SIGNPOST_LOAD, OwsauriCitySignpost5

.ObjectEvents: db 5
	person_event SPRITE_LASS, 26, 32, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, OwsauriCityNPC1, -1
	person_event SPRITE_KIMONO_GIRL, 18, 6, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, OwsauriCityNPC2, -1
	person_event SPRITE_FISHER, 15, 19, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, OwsauriCityNPC3, -1
	person_event SPRITE_SUPER_NERD, 12, 5, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, OwsauriCityNPC4, -1
	person_event SPRITE_FRUIT_TREE, 16, 31, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, OwsauriCityNPC5, -1

