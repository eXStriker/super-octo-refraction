Route74_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route74HiddenItem_1:
	dw EVENT_ROUTE_74_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route74Signpost1:
	ctxt "<DOWN> Spurge City"
	next "<RIGHT> Laurel City"
	next "<LEFT> Heath Village"
	done ;18

Route74_Trainer_1:
	trainer EVENT_ROUTE_74_TRAINER_1, SAILOR, 1, Route74_Trainer_1_Text_130acc, Route74_Trainer_1_Text_130b05, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer Route74_Trainer_1_Script_Text_130b10

Route74_Trainer_2:
	trainer EVENT_ROUTE_74_TRAINER_2, POKEFANM, 2, Route74_Trainer_2_Text_130b68, Route74_Trainer_2_Text_130b94, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer Route74_Trainer_2_Script_Text_130bae

Route74_Trainer_3:
	trainer EVENT_ROUTE_74_TRAINER_3, POKEFANF, 1, Route74_Trainer_3_Text_130c11, Route74_Trainer_3_Text_130c53, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer Route74_Trainer_3_Script_Text_130c68

Route74_Trainer_4:
	trainer EVENT_ROUTE_74_TRAINER_4, PSYCHIC_T, 1, Route74_Trainer_4_Text_130ca2, Route74_Trainer_4_Text_130ccd, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer Route74_Trainer_4_Script_Text_130ced

Route74_Trainer_1_Text_130acc:
	ctxt "I'm ready for"
	line "a real battle!"
	done

Route74_Trainer_1_Text_130b05:
	ctxt "Awaaargh!"
	done

Route74_Trainer_1_Script_Text_130b10:
	ctxt "I've traveled all"
	line "over the world"
	cont "with my #mon."

	para "Alola is the most"
	line "relaxing region"
	cont "in my opinion!"
	done

Route74_Trainer_2_Text_130b68:
	ctxt "Haha!"

	para "Time to show off"
	line "my Pikachu!"
	done

Route74_Trainer_2_Text_130b94:
	ctxt "Feh!"
	done

Route74_Trainer_2_Script_Text_130bae:
	ctxt "I'm not the only"
	line "Pikachu maniac"
	cont "in Naljo region."

	para "But!"

	para "None have as much"
	line "passion as I do!"
	done

Route74_Trainer_3_Text_130c11:
	ctxt "How cute are your"
	line "#mon? Show me!"
	done

Route74_Trainer_3_Text_130c53:
	ctxt "I don't mind"
	line "losing really<...>"
	done

Route74_Trainer_3_Script_Text_130c68:
	ctxt "Baby #mon are"
	line "so adorable!"
	done

Route74_Trainer_4_Text_130ca2:
	ctxt "I want to take"
	line "a look at your"
	cont "#mon party."
	done

Route74_Trainer_4_Text_130ccd:
	ctxt "Wow, your #mon"
	line "are talented!"
	done

Route74_Trainer_4_Script_Text_130ced:
	ctxt "No #mon is the"
	line "truly the same."

	para "Every single one"
	line "has their own"
	cont "individual traits."
	done

Route74_MapEventHeader:: db 0, 0

.Warps: db 2
	warp_def 10, 4, 3, HEATH_GATE
	warp_def 11, 4, 4, HEATH_GATE

.CoordEvents: db 0

.BGEvents: db 2
	signpost 5, 9, SIGNPOST_LOAD, Route74Signpost1
	signpost 19, 14, SIGNPOST_ITEM, Route74HiddenItem_1

.ObjectEvents: db 5
	person_event SPRITE_SAILOR, 29, 15, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, 2, 5, Route74_Trainer_1, -1
	person_event SPRITE_POKEFAN_M, 13, 9, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 2, 4, Route74_Trainer_2, -1
	person_event SPRITE_POKEFAN_F, 19, 17, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_PURPLE, 2, 5, Route74_Trainer_3, -1
	person_event SPRITE_PSYCHIC, 22, 14, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, Route74_Trainer_4, -1
	person_event SPRITE_POKE_BALL, 4, 12, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_GREEN, 3, TM_SWEET_SCENT, ObjectEvent, EVENT_ROUTE_74_TM12
