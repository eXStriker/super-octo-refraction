GoldenrodGym_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

GoldenrodGymSignpost1:
	opentext
	writetext GoldenrodGymSignpost1_Text_3260f6
	endtext

GoldenrodGymSignpost2:
	opentext
	writetext GoldenrodGymSignpost1_Text_3260f6
	endtext

GoldenrodGym_Trainer_1:
	trainer EVENT_GOLDENROD_GYM_TRAINER_1, BEAUTY, 3, GoldenrodGym_Trainer_1_Text_326223, GoldenrodGym_Trainer_1_Text_32625f, $0000, .Script

.Script:
	end_if_just_battled
	jumptext GoldenrodGym_Trainer_1_Script_Text_326270

GoldenrodGym_Trainer_2:
	trainer EVENT_GOLDENROD_GYM_TRAINER_2, BEAUTY, 4, GoldenrodGym_Trainer_2_Text_3262b5, GoldenrodGym_Trainer_2_Text_3262dc, $0000, .Script

.Script:
	end_if_just_battled
	jumptext GoldenrodGym_Trainer_2_Script_Text_3262e5

GoldenrodGymNPC2:
	faceplayer
	opentext
	checkflag ENGINE_PLAINBADGE
	iffalse GoldenrodGym_326327
	jumptext GoldenrodGymNPC2_Text_326362

GoldenrodGym_326327:
	writetext GoldenrodGym_326327_Text_3263a8
	winlosstext GoldenrodGym_326327Text_32647a, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadtrainer WHITNEY, 1
	startbattle
	reloadmapafterbattle
	playmapmusic
	opentext
	writetext GoldenrodGym_326327_Text_3264b8
	playwaitsfx SFX_TCG2_DIDDLY_5
	setflag ENGINE_PLAINBADGE
	playmusic MUSIC_GYM
	writetext GoldenrodGym_326327_Text_3264d1
	waitbutton
	giveitem MAGNET_PASS, 1
	opentext
	writetext GoldenrodGym_326327_Text_32650a
	playwaitsfx SFX_ITEM
	jumptext GoldenrodGym_326327_Text_32652c

GoldenrodGymSignpost1_Text_3260f6:
	ctxt "Goldenrod Gym"

	para "Leader: Whitney"
	done

GoldenrodGym_Trainer_1_Text_326223:
	ctxt "I can't wait to"
	line "see your cute"
	cont "#mon!"

	para "My #mon won't"
	line "hold back!"
	done

GoldenrodGym_Trainer_1_Text_32625f:
	ctxt "Oh, is that it?"
	done

GoldenrodGym_Trainer_1_Script_Text_326270:
	ctxt "You must be"
	line "really good to"
	cont "beat me!"

	para "Never stop!"
	done

GoldenrodGym_Trainer_2_Text_3262b5:
	ctxt "Give it your best"
	line "shot, cause I"
	cont "will!"
	done

GoldenrodGym_Trainer_2_Text_3262dc:
	ctxt "Oh, no!"
	done

GoldenrodGym_Trainer_2_Script_Text_3262e5:
	ctxt "Normal #mon"
	line "can learn all"

	para "sorts of moves"
	line "from TMs."
	done

GoldenrodGymNPC2_Text_326362:
	ctxt "I'm so happy that"
	line "I get the chance"

	para "to battle great"
	line "Trainers like"
	cont "you!"
	done

GoldenrodGym_326327_Text_3263a8:
	ctxt "Hi! I'm Whitney!"

	para "I got into #mon"
	line "years ago because"
	cont "everyone else was!"

	para "Guess it wasn't"
	line "just a silly fad!"

	para "I've gotten cuter"
	line "and stronger over"

	para "the years, so if"
	line "you want my badge,"

	para "you're going to"
	line "have to earn it!"
	done

GoldenrodGym_326327Text_32647a:
	ctxt "Hey that was"
	line "good!"

	para "I'm not going to"
	line "cry, you earned"
	cont "my badge!"
	done

GoldenrodGym_326327_Text_3264b8:
	ctxt "<PLAYER> received"
	line "Plain Badge."
	done

GoldenrodGym_326327_Text_3264d1:
	ctxt "I'm all out of"
	line "those TMs, but"

	para "you can have"
	line "this instead."
	done

GoldenrodGym_326327_Text_32650a:
	ctxt "Whitney hands you"
	line "a Magnet Pass!"
	done

GoldenrodGym_326327_Text_32652c:
	ctxt "The Magnet Pass"
	line "will allow you"

	para "to take the Magnet"
	line "Train back and"

	para "forth from Johto "
	line "to Kanto as many"
	cont "times as you want!"

	para "I would go myself,"
	line "but they tightened"

	para "up security in"
	line "Saffron City."
	done

GoldenrodGym_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $f, $4, 1, GOLDENROD_CITY
	warp_def $f, $5, 1, GOLDENROD_CITY

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 13, 2, SIGNPOST_READ, GoldenrodGymSignpost1
	signpost 13, 7, SIGNPOST_READ, GoldenrodGymSignpost2

	;people-events
	db 4
	person_event SPRITE_GYM_GUY, 13, 8, SPRITEMOVEDATA_00, 0, 0, -1, -1, 0, 0, 0, ObjectEvent, -1
	person_event SPRITE_BUENA, 9, 6, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 2, GoldenrodGym_Trainer_1, -1
	person_event SPRITE_BUENA, 5, 3, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 2, GoldenrodGym_Trainer_2, -1
	person_event SPRITE_WHITNEY, 1, 4, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, GoldenrodGymNPC2, -1
