SaffronFightingDojo_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SaffronFightingDojo_Trainer_1:
	trainer EVENT_SAFFRON_FIGHTING_DOJO_TRAINER_1, BLACKBELT_T, 7, SaffronFightingDojo_Trainer_1_Text_16cc86, SaffronFightingDojo_Trainer_1_Text_16cca2, $0000, .Script

.Script:
	end_if_just_battled
	jumptext SaffronFightingDojo_Trainer_1_Script_Text_16ccc4

SaffronFightingDojo_Trainer_2:
	trainer EVENT_SAFFRON_FIGHTING_DOJO_TRAINER_2, BLACKBELT_T, 8, SaffronFightingDojo_Trainer_2_Text_16cf69, SaffronFightingDojo_Trainer_2_Text_16cf9a, $0000, .Script

.Script:
	end_if_just_battled
	jumptext SaffronFightingDojo_Trainer_2_Script_Text_16cfb2

SaffronFightingDojo_Trainer_3:
	trainer EVENT_SAFFRON_FIGHTING_DOJO_TRAINER_3, BLACKBELT_T, 9, SaffronFightingDojo_Trainer_3_Text_16cd77, SaffronFightingDojo_Trainer_3_Text_16cd9a, $0000, .Script

.Script:
	end_if_just_battled
	jumptext SaffronFightingDojo_Trainer_3_Script_Text_16cda9

SaffronFightingDojoNPC1:
	faceplayer
	opentext
	checkevent EVENT_FIGHTING_DOJO_WIN
	iffalse SaffronFightingDojo_16ce10
	checkevent EVENT_FIGHTING_DOJO_GOT_ITEM
	iffalse SaffronFightingDojo_16ce27
	jumptext SaffronFightingDojoNPC1_Text_16ce49

SaffronFightingDojo_16ce10:
	writetext SaffronFightingDojo_16ce10_Text_16ce74
	winlosstext SaffronFightingDojo_16ce10Text_16ceb0, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadtrainer BLACKBELT_T, 10
	startbattle
	reloadmapafterbattle
	playmapmusic
	opentext
	setevent EVENT_FIGHTING_DOJO_WIN
	writetext SaffronFightingDojo_16ce10_Text_16cec7
	waitbutton
	verbosegiveitem BLACKBELT, 1
	iffalse SaffronFightingDojo_16ce43
	writetext SaffronFightingDojo_16ce10_Text_16ceff
	waitbutton
	setevent EVENT_FIGHTING_DOJO_GOT_ITEM
	endtext

SaffronFightingDojo_16ce27:
	writetext SaffronFightingDojo_16ce10_Text_16cec7
	waitbutton
	verbosegiveitem BLACKBELT, 1
	iffalse SaffronFightingDojo_16ce43
	setevent EVENT_FIGHTING_DOJO_GOT_ITEM
	jumptext SaffronFightingDojo_16ce10_Text_16ceff

SaffronFightingDojo_16ce43:
	jumptext SaffronFightingDojo_16ce43_Text_16cf31

SaffronFightingDojo_Trainer_1_Text_16cc86:
	ctxt "Where might you"
	line "come from?"
	done

SaffronFightingDojo_Trainer_1_Text_16cca2:
	ctxt "Came to seek out"
	line "our master huh?"
	done

SaffronFightingDojo_Trainer_1_Script_Text_16ccc4:
	ctxt "The prime"
	line "fighters across"

	para "the land train"
	line "here."
	done

SaffronFightingDojo_Trainer_2_Text_16cf69:
	ctxt "Do you like your"
	line "mouth or fists"
	cont "do the talking?"
	done

SaffronFightingDojo_Trainer_2_Text_16cf9a:
	ctxt "I take it's the"
	line "latter."
	done

SaffronFightingDojo_Trainer_2_Script_Text_16cfb2:
	ctxt "Psychic power"
	line "frightens us!"
	done

SaffronFightingDojo_Trainer_3_Text_16cd77:
	ctxt "Are you ready to"
	line "face the master?"
	done

SaffronFightingDojo_Trainer_3_Text_16cd9a:
	ctxt "Yes!"

	para "You are!"
	done

SaffronFightingDojo_Trainer_3_Script_Text_16cda9:
	ctxt "Wait till you see"
	line "our master!"
	done

SaffronFightingDojoNPC1_Text_16ce49:
	ctxt "Keep up the"
	line "training,"

	para "because I will"
	line "too!"
	done

SaffronFightingDojo_16ce10_Text_16ce74:
	ctxt "Hey!"

	para "I'm Kiyo the"
	line "Karate King!"

	para "You!"

	para "Battle time!"

	para "Hwaaarggh!"
	done

SaffronFightingDojo_16ce10Text_16ceb0:
	ctxt "I'm beaten!"

	para "Waaaarggh!"
	done

SaffronFightingDojo_16ce10_Text_16cec7:
	ctxt "I'm crushed!"

	para "You earned this"
	line "belt!"
	done

SaffronFightingDojo_16ce10_Text_16ceff:
	ctxt "It'll make your"
	line "fighting #mon"

	para "even more"
	line "powerful!"
	done

SaffronFightingDojo_16ce43_Text_16cf31:
	ctxt "You foolish child,"
	line "make some room!"
	done

SaffronFightingDojo_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $f, $9, 1, SAFFRON_CITY
	warp_def $f, $a, 1, SAFFRON_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 4
	person_event SPRITE_BLACK_BELT, 10, 4, $9, 0, 0, -1, -1, PAL_OW_BROWN, 2, 3, SaffronFightingDojo_Trainer_1, -1
	person_event SPRITE_BLACK_BELT, 8, 7, $8, 0, 0, -1, -1, PAL_OW_BROWN, 2, 3, SaffronFightingDojo_Trainer_2, -1
	person_event SPRITE_BLACK_BELT, 6, 4, $9, 0, 0, -1, -1, PAL_OW_BROWN, 2, 3, SaffronFightingDojo_Trainer_3, -1
	person_event SPRITE_BLACK_BELT, 2, 5, $3, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SaffronFightingDojoNPC1, -1
