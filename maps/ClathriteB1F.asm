ClathriteB1F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

ClathriteB1FTrap1:
	checkitem FLUFFY_COAT
	iffalse ClathriteB1F_11ad50
	end

ClathriteB1FTrap2:
	checkitem FLUFFY_COAT
	iffalse ClathriteB1F_11ad50
	end

ClathriteB1F_Item_1:
	db ETHER, 1

ClathriteB1F_Item_2:
	db PP_UP, 1

ClathriteB1F_Trainer_1:
	trainer EVENT_CLATHRITE_B1F_TRAINER_1, BOARDER, 1, ClathriteB1F_Trainer_1_Text_11aa5e, ClathriteB1F_Trainer_1_Text_11aa85, $0000, .Script

.Script:
	end_if_just_battled
	jumptext ClathriteB1F_Trainer_1_Script_Text_11aa93

ClathriteB1F_Trainer_2:
	trainer EVENT_CLATHRITE_B1F_TRAINER_2, BOARDER, 2, ClathriteB1F_Trainer_2_Text_11aade, ClathriteB1F_Trainer_2_Text_11ab17, $0000, .Script

.Script:
	end_if_just_battled
	jumptext ClathriteB1F_Trainer_2_Script_Text_11ab3a

ClathriteB1F_11ad50:
	opentext
	writetext ClathriteB1F_11ad50_Text_11ad5b
	waitbutton
	closetext
	applymovement 0, ClathriteB1F_11ad50_Movement1
	end

ClathriteB1F_11ad50_Movement1:
	step_right
	step_end

ClathriteB1F_Trainer_1_Text_11aa5e:
	ctxt "I'm lost, can you"
	line "help me get out?"
	done

ClathriteB1F_Trainer_1_Text_11aa85:
	ctxt "I guess not."
	done

ClathriteB1F_Trainer_1_Script_Text_11aa93:
	ctxt "At least it's fun"
	line "sliding down this"
	cont "maze on my board."
	done

ClathriteB1F_Trainer_2_Text_11aade:
	ctxt "Just came in from"
	line "outside, looking"
	para "to catch some wild"
	line "icy #mon!"
	done

ClathriteB1F_Trainer_2_Text_11ab17:
	ctxt "You see why I"
	line "would need to."
	done

ClathriteB1F_Trainer_2_Script_Text_11ab3a:
	ctxt "I heard a legend"
	line "resides somewhere"
	cont "in this very cave<...>"

	para "Well, it's probably"
	line "just some rumor."
	done

ClathriteB1F_11ad50_Text_11ad5b:
	ctxt "Wow, it's way too"
	line "cold in here."

	para "Unless I want to"
	line "catch hypothermia,"

	para "I'd better head"
	line "back for now."
	done

ClathriteB1F_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $21, $f, 1, CLATHRITE_B2F
	warp_def $29, $1d, 3, CLATHRITE_1F
	warp_def $3, $3, 3, CLATHRITE_B2F
	warp_def $17, $1b, 2, CLATHRITE_1F

	;xy triggers
	db 2
	xy_trigger 0, $18, $19, $0, ClathriteB1FTrap1, $0, $0
	xy_trigger 0, $27, $1a, $0, ClathriteB1FTrap2, $0, $0

	;signposts
	db 0

	;people-events
	db 4
	person_event SPRITE_POKE_BALL, 16, 18, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, ClathriteB1F_Item_1, EVENT_CLATHRITE_B1F_ITEM_1
	person_event SPRITE_POKE_BALL, 22, 2, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, ClathriteB1F_Item_2, EVENT_CLATHRITE_B1F_ITEM_2
	person_event SPRITE_BOARDER, 6, 20, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_BLUE, 2, 2, ClathriteB1F_Trainer_1, -1
	person_event SPRITE_BOARDER, 22, 26, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 2, 2, ClathriteB1F_Trainer_2, -1
