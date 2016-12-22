SenecaCavernsB1F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SenecaCavernsB1F_Trainer_1:
	trainer EVENT_SENECACAVERNSB1F_TRAINER_1, POKEFANM, 5, SenecaCavernsB1F_Trainer_1_Text_24d617, SenecaCavernsB1F_Trainer_1_Text_24d634, $0000, .Script

.Script:
	end_if_just_battled
	jumptext SenecaCavernsB1F_Trainer_1_Script_Text_24d64d

SenecaCavernsB1F_Trainer_2:
	trainer EVENT_SENECACAVERNSB1F_TRAINER_2, HIKER, 14, SenecaCavernsB1F_Trainer_2_Text_24d56c, SenecaCavernsB1F_Trainer_2_Text_24d591, $0000, .Script

.Script:
	end_if_just_battled
	jumptext SenecaCavernsB1F_Trainer_2_Script_Text_24d5c5

SenecaCavernsB1F_Trainer_3:
	trainer EVENT_SENECACAVERNSB1F_TRAINER_3, GENTLEMAN, 4, SenecaCavernsB1F_Trainer_3_Text_24d4a6, SenecaCavernsB1F_Trainer_3_Text_24d4da, $0000, .Script

.Script:
	end_if_just_battled
	jumptext SenecaCavernsB1F_Trainer_3_Script_Text_24d4f3

SenecaCavernsB1F_Trainer_4:
	trainer EVENT_SENECACAVERNSB1F_TRAINER_4, SCIENTIST, 3, SenecaCavernsB1F_Trainer_4_Text_24d674, SenecaCavernsB1F_Trainer_4_Text_24d696, $0000, .Script

.Script:
	end_if_just_battled
	jumptext SenecaCavernsB1F_Trainer_4_Script_Text_24d69f

SenecaCavernsB1F_Trainer_1_Text_24d617:
	ctxt "I'm SO ready for"
	line "the league!"
	done

SenecaCavernsB1F_Trainer_1_Text_24d634:
	ctxt "Maybe not!"

	para "Maybe not<...>"
	done

SenecaCavernsB1F_Trainer_1_Script_Text_24d64d:
	ctxt "Gotta train more!"
	done

SenecaCavernsB1F_Trainer_2_Text_24d56c:
	ctxt "This is a"
	line "beautifully"
	cont "built tunnel."
	done

SenecaCavernsB1F_Trainer_2_Text_24d591:
	ctxt "Oh wait, we were"
	line "battling?"

	para "Sorry, I got"
	line "distracted."
	done

SenecaCavernsB1F_Trainer_2_Script_Text_24d5c5:
	ctxt "Caves are like"
	line "houses, only built"

	para "by #mon and"
	line "Mother Nature."
	done

SenecaCavernsB1F_Trainer_3_Text_24d4a6:
	ctxt "Wait, youngster."

	para "You're in an awful"
	line "hurry, aren't you?"
	done

SenecaCavernsB1F_Trainer_3_Text_24d4da:
	ctxt "Well now I feel"
	line "better."
	done

SenecaCavernsB1F_Trainer_3_Script_Text_24d4f3:
	ctxt "I didn't want you"
	line "to get humiliated"

	para "at the Rijon"
	line "League."

	para "Since you beat me,"
	line "you might have a"

	para "chance to"
	line "humiliate them!"
	done

SenecaCavernsB1F_Trainer_4_Text_24d674:
	ctxt "This cave is a"
	line "geologist's dream!"
	done

SenecaCavernsB1F_Trainer_4_Text_24d696:
	ctxt "Well<...>"
	done

SenecaCavernsB1F_Trainer_4_Script_Text_24d69f:
	ctxt "If I had one word"
	line "to describe this"
	cont "cave, it would be<...>"

	para "Fascinating."
	done

SenecaCavernsB1F_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $3, $b, 4, SENECACAVERNSF1
	warp_def $10, $2, 1, SENECACAVERNSB2F
	warp_def $3, $2d, 3, SENECACAVERNSF1

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 4
	person_event SPRITE_POKEFAN_M, 19, 29, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 2, 1, SenecaCavernsB1F_Trainer_1, -1
	person_event SPRITE_HIKER, 32, 34, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_RED, 2, 1, SenecaCavernsB1F_Trainer_2, -1
	person_event SPRITE_GENTLEMAN, 17, 45, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 2, 1, SenecaCavernsB1F_Trainer_3, -1
	person_event SPRITE_SCIENTIST, 10, 6, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 2, 1, SenecaCavernsB1F_Trainer_4, -1
