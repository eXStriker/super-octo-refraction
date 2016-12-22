SouthSoutherly_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SouthSoutherly_Trainer_1:
	trainer EVENT_SOUTH_SOUTHERLY_TRAINER_1, FISHER, 11, SouthSoutherly_Trainer_1_Text_2fa9b0, SouthSoutherly_Trainer_1_Text_2fa9e6, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext SouthSoutherly_Trainer_1_Script_Text_2faa04
	endtext

SouthSoutherly_Trainer_2:
	trainer EVENT_SOUTH_SOUTHERLY_TRAINER_2, SWIMMERM, 12, SouthSoutherly_Trainer_2_Text_2fa92c, SouthSoutherly_Trainer_2_Text_2fa959, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext SouthSoutherly_Trainer_2_Script_Text_2fa974
	endtext

SouthSoutherly_Trainer_3:
	trainer EVENT_SOUTH_SOUTHERLY_TRAINER_3, SWIMMERM, 13, SouthSoutherly_Trainer_3_Text_2f8f41, SouthSoutherly_Trainer_3_Text_2f8f65, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext SouthSoutherly_Trainer_3_Script_Text_2f8f83
	endtext

SouthSoutherly_Trainer_4:
	trainer EVENT_SOUTH_SOUTHERLY_TRAINER_4, SWIMMERF, 9, SouthSoutherly_Trainer_4_Text_2f8fc3, SouthSoutherly_Trainer_4_Text_2f8ff0, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext SouthSoutherly_Trainer_4_Script_Text_2f900a
	endtext

SouthSoutherly_Trainer_1_Text_2fa9b0:
	ctxt "This is my"
	line "special fishing"

	para "spot, and you're"
	line "in my way!"
	done

SouthSoutherly_Trainer_1_Text_2fa9e6:
	ctxt "Fine, I'll fish"
	line "around you<...>"
	done

SouthSoutherly_Trainer_1_Script_Text_2faa04:
	ctxt "Sometimes they"
	line "bite, sometimes"
	cont "they don't."
	done

SouthSoutherly_Trainer_2_Text_2fa92c:
	ctxt "You're almost"
	line "there!"

	para "One more battle"
	line "though!"
	done

SouthSoutherly_Trainer_2_Text_2fa959:
	ctxt "Well you proved"
	line "yourself."
	done

SouthSoutherly_Trainer_2_Script_Text_2fa974:
	ctxt "Go, go and enjoy"
	line "the wonders of"
	cont "Tunod!"
	done

SouthSoutherly_Trainer_3_Text_2f8f41:
	ctxt "Southerly is"
	line "north."

	para "Hilarious, eh?"
	done

SouthSoutherly_Trainer_3_Text_2f8f65:
	ctxt "You take this too"
	line "seriously."
	done

SouthSoutherly_Trainer_3_Script_Text_2f8f83:
	ctxt "You gotta chill."

	para "Life's one big"
	line "joke to me."
	done

SouthSoutherly_Trainer_4_Text_2f8fc3:
	ctxt "There's too many"
	line "Tentacool."

	para "That's not cool!"
	done

SouthSoutherly_Trainer_4_Text_2f8ff0:
	ctxt "You're more"
	line "annoying now."
	done

SouthSoutherly_Trainer_4_Script_Text_2f900a:
	ctxt "I keep forgetting"
	line "to bring my Repel."
	done

SouthSoutherly_MapEventHeader ;filler
	db 0, 0

;warps
	db 0

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 5
	person_event SPRITE_FISHER, 18, 14, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 2, 1, SouthSoutherly_Trainer_1, -1
	person_event SPRITE_SWIMMER_GUY, 6, 8, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 2, 5, SouthSoutherly_Trainer_2, -1
	person_event SPRITE_POKE_BALL, 33, 4, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 3, TM_SUBSTITUTE, 0, EVENT_SOUTH_SOUTHERLY_NPC_1
	person_event SPRITE_SWIMMER_GUY, 54, 9, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 2, 4, SouthSoutherly_Trainer_3, -1
	person_event SPRITE_SWIMMER_GIRL, 30, 11, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 2, 5, SouthSoutherly_Trainer_4, -1
