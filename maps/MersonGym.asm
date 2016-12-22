MersonGym_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MersonGymSignpost1:
	jumptext MersonGymSignpost1_Text_16a209

MersonGymNPC1:
	faceplayer
	opentext
	checkflag ENGINE_MARINEBADGE
	iffalse MersonGym_169f4a
	jumptext MersonGymNPC1_Text_169f7c

MersonGym_Trainer_1:
	trainer EVENT_MERSON_GYM_TRAINER_1, CAMPER, 5, MersonGym_Trainer_1_Text_16835d, MersonGym_Trainer_1_Text_1683ec, $0000, .Script

.Script:
	end_if_just_battled
	jumptext MersonGym_Trainer_1_Script_Text_16840a

MersonGymNPC2:
	jumptextfaceplayer MersonGymNPC2_Text_16a172

MersonGym_169f4a:
	writetext MersonGym_169f4a_Text_169fb0
	winlosstext MersonGym_169f4aText_16a063, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadtrainer KARPMAN, 1
	startbattle
	reloadmapafterbattle
	playmapmusic
	opentext
	writetext MersonGym_169f4a_Text_16a0b5
	playwaitsfx SFX_TCG2_DIDDLY_5
	playmusic MUSIC_GYM
	writetext MersonGym_169f4a_Text_16a0cf
	waitbutton
	givetm 80 + RECEIVED_TM
	setflag ENGINE_MARINEBADGE
	jumptext MersonGym_169f4a_Text_16a119

MersonGymSignpost1_Text_16a209:
	ctxt "Merson City"
	line "#mon Gym."
	done

MersonGymNPC1_Text_169f7c:
	ctxt "You impressed me."

	para "Keep getting those"
	line "Rijon badges."
	done

MersonGym_Trainer_1_Text_16835d:
	ctxt "Stop right there!"
	done

MersonGym_Trainer_1_Text_1683ec:
	ctxt "I have to win"
	line "these battles…"
	done

MersonGym_Trainer_1_Script_Text_16840a:
	ctxt "I thought I had"
	line "a chance against"
	cont "you!"

	para "Maybe I shouldn't"
	line "be so optimistic."
	done

MersonGymNPC2_Text_16a172:
	ctxt "Karpman's a big"
	line "fan of water"
	cont "#mon."

	para "You battled an"
	line "annoying water"

	para "gym leader in"
	line "Naljo?"

	para "Oh wow, I don't"
	line "mean to be"

	para "negative, but"
	line "she sounds awful."
	done

MersonGym_169f4a_Text_169fb0:
	ctxt "I'm Karpman."

	para "I train only water"
	line "type #mon!"

	para "Fire is useless"
	line "against my mighty"
	cont "water attacks!"

	para "You don't look"
	line "intimidated<...>"

	para "What's wrong with"
	line "you?"

	para "Well whatever, let"
	line "the fight begin!"
	done

MersonGym_169f4aText_16a063:
	ctxt "Looks like I need"
	line "to respect your"
	cont "authority!"

	para "Go ahead and take"
	line "the Marine Badge."
	done

MersonGym_169f4a_Text_16a0b5:
	ctxt "<PLAYER> received"
	line "Marine Badge."
	done

MersonGym_169f4a_Text_16a0cf:
	ctxt "The Marine Badge"
	line "will make your"

	para "#mon even"
	line "stronger!"

	para "Also take this"
	line "gift."
	done

MersonGym_169f4a_Text_16a119:
	ctxt "Storm Front will"
	line "deal damage and"
	cont "start a rainstorm."

	para "It's ideal for all"
	line "water #mon."
	done

MersonGym_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $d, $4, 3, MERSON_CITY
	warp_def $d, $5, 3, MERSON_CITY

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 11, 0, SIGNPOST_READ, MersonGymSignpost1

	;people-events
	db 3
	person_event SPRITE_BROCK, 2, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 8 + PAL_OW_GREEN, 0, 0, MersonGymNPC1, -1
	person_event SPRITE_CAMPER, 8, 2, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 8 + PAL_OW_GREEN, 2, 3, MersonGym_Trainer_1, -1
	person_event SPRITE_GYM_GUY, 11, 7, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 1, MersonGymNPC2, -1
