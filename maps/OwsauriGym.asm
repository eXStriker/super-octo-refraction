OwsauriGym_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

OwsauriGymSignpost1:
	jumptext OwsauriGymSignpost1_Text_150568

OwsauriGymNPC1:
	faceplayer
	opentext
	checkflag ENGINE_HAILBADGE
	iffalse OwsauriGym_15245b
	writetext OwsauriGymNPC1_Text_15248a
	endtext

OwsauriGym_Trainer_1:
	trainer EVENT_OWSAURI_GYM_TRAINER_1, BOARDER, 6, OwsauriGym_Trainer_1_Text_1523a8, OwsauriGym_Trainer_1_Text_1523e0, $0000, .Script

.Script:
	end_if_just_battled
	jumptext OwsauriGym_Trainer_1_Script_Text_1523fa

OwsauriGym_Trainer_2:
	trainer EVENT_OWSAURI_GYM_TRAINER_2, BOARDER, 4, OwsauriGym_Trainer_2_Text_152237, OwsauriGym_Trainer_2_Text_15226b, $0000, .Script

.Script:
	end_if_just_battled
	jumptext OwsauriGym_Trainer_2_Script_Text_152279

OwsauriGym_Trainer_3:
	trainer EVENT_OWSAURI_GYM_TRAINER_3, BOARDER, 5, OwsauriGym_Trainer_3_Text_1522b3, OwsauriGym_Trainer_3_Text_1522da, $0000, .Script

.Script:
	end_if_just_battled
	jumptext OwsauriGym_Trainer_3_Script_Text_152307

OwsauriGymNPC2:
	jumptextfaceplayer OwsauriGymNPC2_Text_1526dc

OwsauriGym_15245b:
	writetext OwsauriGym_15245b_Text_152512
	winlosstext OwsauriGym_15245bText_1525c0, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadtrainer LILY, 1
	startbattle
	reloadmapafterbattle
	playmapmusic
	opentext
	writetext OwsauriGym_15245b_Text_15262a
	playwaitsfx SFX_TCG2_DIDDLY_5
	playmusic MUSIC_GYM
	writetext OwsauriGym_15245b_Text_152642
	waitbutton
	givetm 89 + RECEIVED_TM
	setflag ENGINE_HAILBADGE
	jumptext OwsauriGym_15245b_Text_152668

OwsauriGymSignpost1_Text_150568:
	ctxt "Owsauri Gym"
	line "Leader: Lily"
	done

OwsauriGymNPC1_Text_15248a:
	ctxt "Maybe when the"
	line "Goldenrod Tower"

	para "is repaired, I"
	line "could start DJing"
	cont "there?"

	para "I love loving"
	line "here, and"

	para "Goldenrod's a"
	line "lot closer than"
	cont "Lavender is."
	done

OwsauriGym_Trainer_1_Text_1523a8:
	ctxt "Hang on, what's"
	line "the rush."

	para "Chill out and"
	line "battle will ya?"
	done

OwsauriGym_Trainer_1_Text_1523e0:
	ctxt "Maybe that was"
	line "too cold."
	done

OwsauriGym_Trainer_1_Script_Text_1523fa:
	ctxt "Even with two"
	line "layers of coats,"

	para "I'm still getting"
	line "chills."

	para "I guess the"
	line "#mon like it."
	done

OwsauriGym_Trainer_2_Text_152237:
	ctxt "The slopes on top"
	line "of Clathrite are"
	cont "so gnarly dude!"
	done

OwsauriGym_Trainer_2_Text_15226b:
	ctxt "Whooooaaaaa!"
	done

OwsauriGym_Trainer_2_Script_Text_152279:
	ctxt "I also caught"
	line "these #mon"
	cont "over there!"
	done

OwsauriGym_Trainer_3_Text_1522b3:
	ctxt "Lily's so hot,"
	line "I'm gonna win her"
	cont "heart!"
	done

OwsauriGym_Trainer_3_Text_1522da:
	ctxt "She likes good"
	line "Trainers, so I'll"
	cont "keep at it!"
	done

OwsauriGym_Trainer_3_Script_Text_152307:
	ctxt "Didja know that"
	line "Lily used to be"

	para "a DJ way off in"
	line "Lavender?"
	done

OwsauriGymNPC2_Text_1526dc:
	ctxt "Cold enough for"
	line "ya?"

	para "Lily loves her Ice"
	line "#mon, so if you"

	para "bring something"
	line "hot, her team will"
	cont "melt away!"
	done

OwsauriGym_15245b_Text_152512:
	ctxt "Hi!"

	para "You're here to"
	line "face me?"

	para "Great!"

	para "I've always loved"
	line "ice #mon as"

	para "well as the"
	line "winter months!"

	para "I moved here from"
	line "Kanto when this"

	para "Gym needed a"
	line "leader!"

	para "Here's my team,"
	line "comin at ya!"
	done

OwsauriGym_15245bText_1525c0:
	ctxt "I'm sad, but at"
	line "the same time"
	cont "glad."

	para "Thanks to your"
	line "help, I can"

	para "improve as a Gym"
	line "Leader!"

	para "Here is my badge!"
	done

OwsauriGym_15245b_Text_15262a:
	ctxt "<PLAYER> received"
	line "Hail Badge."
	done

OwsauriGym_15245b_Text_152642:
	ctxt "You should take"
	line "this special TM"
	cont "too."
	done

OwsauriGym_15245b_Text_152668:
	ctxt "This is a special"
	line "move called"
	cont "Freeze Burn!"

	para "It's an ice move"
	line "that has the"

	para "chance of"
	line "burning or"
	cont "freezing!"
	done

OwsauriGym_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $13, $4, 4, OWSAURI_CITY
	warp_def $13, $5, 4, OWSAURI_CITY

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 17, 2, SIGNPOST_READ, OwsauriGymSignpost1
	signpost 17, 7, SIGNPOST_READ, OwsauriGymSignpost1

	;people-events
	db 5
	person_event SPRITE_MISTY, 4, 3, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 0, 0, OwsauriGymNPC1, -1
	person_event SPRITE_BOARDER, 4, 5, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 2, 3, OwsauriGym_Trainer_1, -1
	person_event SPRITE_BOARDER, 8, 0, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 2, 1, OwsauriGym_Trainer_2, -1
	person_event SPRITE_BOARDER, 7, 9, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, OwsauriGym_Trainer_3, -1
	person_event SPRITE_GYM_GUY, 17, 8, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 0, OwsauriGymNPC2, -1
