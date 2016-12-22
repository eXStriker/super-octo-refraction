CastroForest_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

CastroForestHiddenItem_1:
	dw EVENT_CASTRO_FOREST_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

CastroForestHiddenItem_2:
	dw EVENT_CASTRO_FOREST_HIDDENITEM_EMERALD_EGG
	db EMERALD_EGG

CastroForest_Trainer_1:
	trainer EVENT_CASTRO_FOREST_TRAINER_1, SAGE, 4, CastroForest_Trainer_1_Text_10bb00, CastroForest_Trainer_1_Text_10bb35, $0000, .Script

.Script:
	end_if_just_battled
	jumptext CastroForest_Trainer_1_Script_Text_10bb51

CastroForestNPC1:
	jumptextfaceplayer CastroForestNPC1_Text_10ab80

CastroForest_Trainer_2:
	trainer EVENT_CASTRO_FOREST_TRAINER_2, SAGE, 5, CastroForest_Trainer_2_Text_10bb73, CastroForest_Trainer_2_Text_10b98a, $0000, .Script

.Script:
	end_if_just_battled
	jumptext CastroForest_Trainer_2_Script_Text_10b9a4

CastroForest_Item_1:
	db SITRUS_BERRY, 3

CastroForest_Item_2:
	db SMOKE_BALL, 1

CastroForestNPC2:
	fruittree 8

CastroForest_Trainer_1_Text_10bb00:
	ctxt "A fool woke up the"
	line "mighty Varaneous!"
	
	para "Wait, you saw the"
	line "revival?"
	done

CastroForest_Trainer_1_Text_10bb35:
	ctxt "At least we're"
	line "safe here."
	done

CastroForest_Trainer_1_Script_Text_10bb51:
	ctxt "Many of us have"
	line "fled Naljo to"
	cont "ensure our safety."
	done

CastroForestNPC1_Text_10ab80:
	ctxt "At the time, this"
	line "is a sacred area."

	para "You are not"
	line "permitted to"
	para "enter at the"
	line "moment."
	done

CastroForest_Trainer_2_Text_10bb73:
	ctxt "I'm a Naljo"
	line "descendent."

	para "I felt safe until"
	line "I learned that"
	
	para "Varaneous attacked"
	line "another Naljo"
	cont "descendent."
	done

CastroForest_Trainer_2_Text_10b98a:
	ctxt "How droll."
	done

CastroForest_Trainer_2_Script_Text_10b9a4:
	ctxt "I was raised to"
	line "believe that the"
	
	para "guardians were"
	line "reasonable."
	
	para "If they are truly"
	line "savages, then I"
	
	para "never want to"
	line "return to Naljo."
	done

CastroForest_MapEventHeader ;filler
	db 0, 0

;warps
	db 6
	warp_def $1d, $23, 1, CASTRO_GATE
	warp_def $1d, $22, 1, CASTRO_GATE
	warp_def $b, $8, 2, ROUTE_62_GATE
	warp_def $1d, $c, 1, CASTRO_FOREST_GATE_SOUTH
	warp_def $1d, $d, 1, CASTRO_FOREST_GATE_SOUTH
	warp_def $a, $8, 2, ROUTE_62_GATE

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 2, 5, SIGNPOST_ITEM, CastroForestHiddenItem_1
	signpost 27, 24, SIGNPOST_ITEM, CastroForestHiddenItem_2

	;people-events
	db 6
	person_event SPRITE_SAGE, 9, 25, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 2, 2, CastroForest_Trainer_1, -1
	person_event SPRITE_SAGE, 22, 13, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 2, CastroForestNPC1, EVENT_RIJON_SECOND_PART
	person_event SPRITE_SAGE, 7, 10, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 2, 3, CastroForest_Trainer_2, -1
	person_event SPRITE_POKE_BALL, 28, 27, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 0, CastroForest_Item_1, EVENT_CASTRO_FOREST_ITEM_1
	person_event SPRITE_POKE_BALL, 23, 17, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_GREEN, 1, 0, CastroForest_Item_2, EVENT_CASTRO_FOREST_ITEM_2
	person_event SPRITE_FRUIT_TREE, 19, 34, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 0, 0, CastroForestNPC2, -1
