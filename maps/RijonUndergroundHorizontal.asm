RijonUndergroundHorizontal_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

RijonUndergroundHorizontal_Trainer_1:
	trainer EVENT_RIJON_UNDERGROUND_HORIZONTAL_TRAINER_1, COOLTRAINERF, 6, RijonUndergroundHorizontal_Trainer_1_Text_322de1, RijonUndergroundHorizontal_Trainer_1_Text_322e01, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer RijonUndergroundHorizontal_Trainer_1_Script_Text_322e30

RijonUndergroundHorizontal_Trainer_2:
	trainer EVENT_RIJON_UNDERGROUND_HORIZONTAL_TRAINER_2, COOLTRAINERM, 6, RijonUndergroundHorizontal_Trainer_2_Text_322d6e, RijonUndergroundHorizontal_Trainer_2_Text_322d8d, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer RijonUndergroundHorizontal_Trainer_2_Script_Text_322da7

RijonUndergroundHorizontal_Trainer_1_Text_322de1:
	ctxt "How do you turn"
	line "on the lights?"
	done

RijonUndergroundHorizontal_Trainer_1_Text_322e01:
	ctxt "Don't make this"
	line "any scarier than"
	cont "it has to be!"
	done

RijonUndergroundHorizontal_Trainer_1_Script_Text_322e30:
	ctxt "Why have a long"
	line "tunnel with no"
	cont "lights, it just"
	cont "doesn't make"
	cont "sense!"
	done

RijonUndergroundHorizontal_Trainer_2_Text_322d6e:
	ctxt "We're under the"
	line "bay!"

	para "Cool huh?"
	done

RijonUndergroundHorizontal_Trainer_2_Text_322d8d:
	ctxt "That's too much"
	line "pressure!"
	done

RijonUndergroundHorizontal_Trainer_2_Script_Text_322da7:
	ctxt "Ouch!"

	para "My ears just"
	line "popped!"
	done

RijonUndergroundHorizontal_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $5, $2, 1, ROUTE_52_GATE_UNDERGROUND
	warp_def $2, $2f, 1, ROUTE_55_GATE_UNDERGROUND

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_LASS, 1, 35, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 2, 4, RijonUndergroundHorizontal_Trainer_1, -1
	person_event SPRITE_YOUNGSTER, 5, 19, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, 2, 4, RijonUndergroundHorizontal_Trainer_2, -1
