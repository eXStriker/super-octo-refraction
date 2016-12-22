PrisonRoof_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw MAPCALLBACK_OBJECTS, .Callback

.Callback
	checkevent EVENT_PRISON_ROOF_TRAINER_2
	iftrue .skip
	appear $2
.skip
	return

PrisonRoof_Trainer_1:
	trainer EVENT_PRISON_ROOF_TRAINER_1, OFFICER, 5, PrisonRoof_Trainer_1_Text_255137, PrisonRoof_Trainer_1_Text_25515b, $0000, .Script

.Script:
	jumptextfaceplayer PrisonRoof_Trainer_1_Script_Text_255163

PrisonRoof_Trainer_2:
	trainer EVENT_PRISON_ROOF_TRAINER_2, OFFICER, 6, PrisonRoof_Trainer_2_Text_255194, PrisonRoof_Trainer_2_Text_255203, $0000, .Script

.Script:
	faceplayer
	opentext
	writetext PrisonRoof_Trainer_2_Script_Text_255220
	waitbutton
	closetext
	opentext
	writetext PrisonRoof_Trainer_2_Script_Text_255399
	waitbutton
	closetext
	jumptext PrisonRoof_Trainer_2_Script_Text_2553a7

PrisonRoof_Trainer_1_Text_255137:
	ctxt "What what what?"
	done

PrisonRoof_Trainer_1_Text_25515b:
	ctxt "Uh<...>"
	done

PrisonRoof_Trainer_1_Script_Text_255163:
	ctxt "What happened?"
	done

PrisonRoof_Trainer_2_Text_255194:
	ctxt "Dangit Grady,"
	line "stay focused."

	para "I hate taking care"
	line "of this guy<...>"
	done

PrisonRoof_Trainer_2_Text_255203:
	ctxt "Wait, aren't you"
	line "an inmate?"
	done

PrisonRoof_Trainer_2_Script_Text_255220:
	ctxt "This is seriously"
	line "one of the worst"
	cont "prisons ever."

	para "These prisoners"
	line "could break out"
	para "at anytime if"
	line "they wanted to."

	para "Me and Grady dang"
	line "near run the whole"
	para "security in this"
	line "place nowadays."

	para "Isn't that right,"
	line "huh, Grady?"
	done

PrisonRoof_Trainer_2_Script_Text_255399:
	ctxt "Grady: Huh?"
	done

PrisonRoof_Trainer_2_Script_Text_2553a7:
	ctxt "Anyway, you're just"
	line "a kid."

	para "They should've sent"
	line "you to juvie."

	para "Go down to the"
	line "workout room and"
	para "ask Paulie for"
	line "the new password"
	cont "to the basement."

	para "It's because of"
	line "his incompetence"
	para "that we gotta"
	line "keep changing the"
	cont "darn password<...>"
	done

PrisonRoof_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def $b, $d, 2, PRISON_F2

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_OFFICER, 11, 12, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_GREEN, 2, 1, PrisonRoof_Trainer_1, -1
	person_event SPRITE_OFFICER, 11, 14, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_GREEN, 2, 1, PrisonRoof_Trainer_2, -1
