MersonCaveB1F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MersonCaveB1FSignpost1:
	ctxt "<LEFT> Route 54"
	done

MersonCaveB1F_Item_1:
	db HP_UP, 1

MersonCaveB1F_Item_2:
	db DUSK_RING, 1

MersonCaveB1F_Trainer_1:
	trainer EVENT_MERSON_CAVE_B1F_TRAINER_1, BUG_CATCHER, 5, MersonCaveB1F_Trainer_1_Text_2f0c28, MersonCaveB1F_Trainer_1_Text_2f0c44, $0000, .Script

.Script:
	end_if_just_battled
	jumptext MersonCaveB1F_Trainer_1_Script_Text_2f0c6b

MersonCaveB1F_Trainer_2:
	trainer EVENT_MERSON_CAVE_B1F_TRAINER_2, HIKER, 4, MersonCaveB1F_Trainer_2_Text_2f0b7c, MersonCaveB1F_Trainer_2_Text_2f0ba3, $0000, .Script

.Script:
	end_if_just_battled
	jumptext MersonCaveB1F_Trainer_2_Script_Text_2f0bbc

MersonCaveB1F_Trainer_3:
	trainer EVENT_MERSON_CAVE_B1F_TRAINER_3, LASS, 2, MersonCaveB1F_Trainer_3_Text_2f0afc, MersonCaveB1F_Trainer_3_Text_2f0b1f, $0000, .Script

.Script:
	end_if_just_battled
	jumptext MersonCaveB1F_Trainer_3_Script_Text_2f0b36

MersonCaveB1F_Trainer_1_Text_2f0c28:
	ctxt "I almost found my"
	line "way out!"
	done

MersonCaveB1F_Trainer_1_Text_2f0c44:
	ctxt "Oh well, my bugs"
	line "still grow"
	cont "stronger!"
	done

MersonCaveB1F_Trainer_1_Script_Text_2f0c6b:
	ctxt "I've battled"
	line "several people"

	para "who chose to"
	line "travel through"
	cont "this cave."
	done

MersonCaveB1F_Trainer_2_Text_2f0b7c:
	ctxt "Always a good hike"
	line "through this cave."
	done

MersonCaveB1F_Trainer_2_Text_2f0ba3:
	ctxt "It just never"
	line "gets old!"
	done

MersonCaveB1F_Trainer_2_Script_Text_2f0bbc:
	ctxt "Cave structures"
	line "are known to"

	para "change every once"
	line "in a while."

	para "You'll never know"
	line "what's new!"
	done

MersonCaveB1F_Trainer_3_Text_2f0afc:
	ctxt "This cave's like"
	line "a confusing maze."
	done

MersonCaveB1F_Trainer_3_Text_2f0b1f:
	ctxt "Well that wasn't"
	line "cool."
	done

MersonCaveB1F_Trainer_3_Script_Text_2f0b36:
	ctxt "Maybe there's areas"
	line "that only #mon"
	cont "have explored."
	done

MersonCaveB1F_MapEventHeader ;filler
	db 0, 0

;warps
	db 5
	warp_def $21, $c, 6, ROUTE_54
	warp_def $21, $f, 1, ROUTE_54
	warp_def $7, $5, 6, MERSON_CAVE_B2F
	warp_def $d, $b, 3, SEASHORE_CITY
	warp_def $f, $19, 4, MERSON_CAVE_B2F

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 23, 15, SIGNPOST_LOAD, MersonCaveB1FSignpost1

	;people-events
	db 5
	person_event SPRITE_POKE_BALL, 12, 2, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_GREEN, 1, 0, MersonCaveB1F_Item_1, EVENT_MERSON_CAVE_B1F_ITEM_1
	person_event SPRITE_POKE_BALL, 23, 25, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 0, MersonCaveB1F_Item_2, EVENT_MERSON_CAVE_B1F_ITEM_2
	person_event SPRITE_YOUNGSTER, 30, 6, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 2, 4, MersonCaveB1F_Trainer_1, -1
	person_event SPRITE_FISHER, 17, 24, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 2, 3, MersonCaveB1F_Trainer_2, -1
	person_event SPRITE_COOLTRAINER_F, 4, 20, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_PURPLE, 2, 1, MersonCaveB1F_Trainer_3, -1
