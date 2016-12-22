PhaceliaGym_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

PhaceliaGymNPC1:
	faceplayer
	jump PhaceliaGym_2fb7f4

PhaceliaGym_Trainer_1:
	trainer EVENT_PHACELIA_GYM_TRAINER_1, BLACKBELT_T, 3, PhaceliaGym_Trainer_1_Text_2fb885, PhaceliaGym_Trainer_1_Text_2fb8de, $0000, .Script

.Script:
	end_if_just_battled
	jumptext PhaceliaGym_Trainer_1_Script_Text_2fb8e7

PhaceliaGym_Trainer_2:
	trainer EVENT_PHACELIA_GYM_TRAINER_2, BLACKBELT_T, 4, PhaceliaGym_Trainer_2_Text_2fb92e, PhaceliaGym_Trainer_2_Text_2fb9a8, $0000, .Script

.Script:
	end_if_just_battled
	jumptext PhaceliaGym_Trainer_2_Script_Text_2fb9b8

PhaceliaGym_Trainer_3:
	trainer EVENT_PHACELIA_GYM_TRAINER_3, BLACKBELT_T, 5, PhaceliaGym_Trainer_3_Text_2fba3d, PhaceliaGym_Trainer_3_Text_2fba97, $0000, .Script

.Script:
	end_if_just_battled
	jumptext PhaceliaGym_Trainer_3_Script_Text_2fbaa5

PhaceliaGymNPC2:
	faceplayer
	opentext
	checkflag ENGINE_MUSCLEBADGE
	iffalse PhaceliaGym_2fbaf3
	jumptext PhaceliaGymNPC2_Text_2fbb25

PhaceliaGymNPC3:
	jumpstd smashrock

PhaceliaGymNPC4:
	jumpstd smashrock

PhaceliaGymNPC5:
	jumpstd smashrock

PhaceliaGym_2fb7f4:
	jumptextfaceplayer PhaceliaGym_2fb7f4_Text_2fb7fc

PhaceliaGym_2fbaf3:
	writetext PhaceliaGym_2fbaf3_Text_2fbbc2
	waitbutton
	winlosstext PhaceliaGym_2fbaf3Text_2fbd01, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadtrainer ANDRE, 1
	startbattle
	reloadmapafterbattle
	playmapmusic
	opentext
	writetext PhaceliaGym_2fbaf3_Text_2fbdc3
	playwaitsfx SFX_TCG2_DIDDLY_5
	setflag ENGINE_MUSCLEBADGE
	writetext PhaceliaGym_2fbaf3_Text_2fbddd
	waitbutton
	givetm TM_DYNAMICPUNCH + RECEIVED_TM
	jumptext PhaceliaGym_2fbaf3_Text_2fbe32

PhaceliaGym_Trainer_1_Text_2fb885:
	ctxt "It takes years of"
	line "intense training"
	para "before you even"
	line "get considered to"
	para "be one of Andre's"
	line "lowly disciples!"
	done

PhaceliaGym_Trainer_1_Text_2fb8de:
	ctxt "Augh!"
	done

PhaceliaGym_Trainer_1_Script_Text_2fb8e7:
	ctxt "I need to take my"
	line "training itinerary"
	cont "more seriously!"
	done

PhaceliaGym_Trainer_2_Text_2fb92e:
	ctxt "Up at 4AM, 16"
	line "hours of training,"
	para "with only three"
	line "10-minute breaks."

	para "Day after day."

	para "Thus is the life"
	line "of a warrior."
	done

PhaceliaGym_Trainer_2_Text_2fb9a8:
	ctxt "I need more!"
	done

PhaceliaGym_Trainer_2_Script_Text_2fb9b8:
	ctxt "I'm going to start"
	line "waking up at 3AM"
	para "and train non-"
	line "stop until 9PM!"

	para "I must become"
	line "more powerful"
	para "than you could"
	line "ever imagine!"
	done

PhaceliaGym_Trainer_3_Text_2fba3d:
	ctxt "I may be only"
	line "second in command"
	para "here<...> But it"
	line "doesn't matter."

	para "You're not going"
	line "any farther."
	done

PhaceliaGym_Trainer_3_Text_2fba97:
	ctxt "Inequitable!"
	done

PhaceliaGym_Trainer_3_Script_Text_2fbaa5:
	ctxt "I wore you down"
	line "enough. You won't "
	para "stand a chance"
	line "against Andre!"
	done

PhaceliaGymNPC2_Text_2fbb25:
	ctxt "Technology and"
	line "civilization is"
	para "going to fail us"
	line "in the end."

	para "When that happens,"
	line "my crew along with"
	para "our #mon teams"
	line "will be the most"
	para "powerful force"
	line "in the world!"
	done

PhaceliaGym_2fb7f4_Text_2fb7fc:
	ctxt "Andre's the kind of"
	line "Gym Leader who"
	para "lets his fists"
	line "do the talking."

	para "He can be very"
	line "hostile, so do"
	para "be careful when"
	line "talking to him."
	done

PhaceliaGym_2fbaf3_Text_2fbbc2:
	ctxt "Hey, how did you"
	line "get this far?"

	para "My followers need"
	line "to train more."

	para "I'm Andre."

	para "This cave, right"
	line "here, is our home."

	para "My #mon and I"
	line "carved it using"
	para "nothing but our"
	line "BARE HANDS!"

	para "These construction"
	line "workers are so"
	para "pathetic, relying"
	line "on technology to"
	para "achieve tasks,"
	line "rather than simply"
	para "making their body"
	line "an indestructible"
	cont "war machine!"

	para "Think I'm crazy?"

	para "Just watch!"
	done

PhaceliaGym_2fbaf3Text_2fbd01:
	ctxt "No!"

	para "You may be strong"
	line "now, but what"
	para "will happen when"
	line "society can no"
	para "longer produce"
	line "things to fill"
	cont "your item pack?"

	para "I'll give you a"
	line "badge for now,"
	para "but when the world"
	line "ends, don't come"
	cont "crying to me."
	done

PhaceliaGym_2fbaf3_Text_2fbdc3:
	ctxt "<PLAYER>"
	line "received Muscle"
	cont "Badge."
	done

PhaceliaGym_2fbaf3_Text_2fbddd:
	ctxt "I need to rid"
	line "myself of such"
	para "foul shortcuts"
	line "that technology"
	cont "has created."

	para "Take this."
	done

PhaceliaGym_2fbaf3_Text_2fbe32:
	ctxt "This TM is called"
	line "Dynamicpunch."
	
	para "It's an innacurate"
	line "move, but if it"
	
	para "hits, the foe"
	line "becomes confused!"

	para "You may see it as"
	line "an advantage, but"
	para "I only see it as"
	line "a way to cripple"
	para "you and your team's"
	line "ability to survive"
	cont "without help."
	done

PhaceliaGym_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $f, $f, 2, PHACELIA_TOWN
	warp_def $1, $3, 6, MILOS_F1

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 8
	person_event SPRITE_GYM_GUY, 10, 15, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PhaceliaGymNPC1, -1
	person_event SPRITE_BLACK_BELT, 14, 11, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 2, 2, PhaceliaGym_Trainer_1, -1
	person_event SPRITE_BLACK_BELT, 11, 6, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 2, 3, PhaceliaGym_Trainer_2, -1
	person_event SPRITE_BLACK_BELT, 4, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 2, 2, PhaceliaGym_Trainer_3, -1
	person_event SPRITE_CHUCK, 2, 14, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PhaceliaGymNPC2, -1
	person_event SPRITE_ROCK, 5, 16, SPRITEMOVEDATA_SMASHABLE_ROCK, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, PhaceliaGymNPC3, -1
	person_event SPRITE_ROCK, 4, 3, SPRITEMOVEDATA_SMASHABLE_ROCK, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, PhaceliaGymNPC4, -1
	person_event SPRITE_ROCK, 3, 2, SPRITEMOVEDATA_SMASHABLE_ROCK, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, PhaceliaGymNPC5, -1
