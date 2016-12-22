Route73_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route73HiddenItem_1:
	dw EVENT_ROUTE_73_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route73Signpost2:
	ctxt "<UP> Mound Cave"
	next "<UP><UP>Spurge City"
	next "<DOWN> Oxalis City"
	next "<UP><RIGHT>Torenia City"
	done ;12

Route73_Item_1:
	db MAX_ELIXIR, 1

Route73_Trainer_1:
	trainer EVENT_ROUTE_73_TRAINER_1, PICNICKER, 2, Route73_Trainer_1_Text_12dd73, Route73_Trainer_1_Text_12dd96, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer Route73_Trainer_1_Script_Text_12ddaa

Route73_Trainer_2:
	trainer EVENT_ROUTE_73_TRAINER_2, BIRD_KEEPER, 1, Route73_Trainer_2_Text_12ddd6, Route73_Trainer_2_Text_12ddf8, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer Route73_Trainer_2_Script_Text_12de11

Route73_Trainer_3:
	trainer EVENT_ROUTE_73_TRAINER_3, BUG_CATCHER, 2, Route73_Trainer_3_Text_12df36, Route73_Trainer_3_Text_12df61, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer Route73_Trainer_3_Script_Text_12df81

Route73_Trainer_4:
	trainer EVENT_ROUTE_73_TRAINER_4, JUGGLER, 1, Route73_Trainer_4_Text_12deaa, Route73_Trainer_4_Text_12dece, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer Route73_Trainer_4_Script_Text_12dee6

Route73NPC1:
	fruittree 16

Route73_Item_2:
	db REPEL, 2

Route73NPC3:
	jumptextfaceplayer Route73NPC3_Text_12fc3c

Route73_Trainer_1_Text_12dd73:
	ctxt "How did you do"
	line "against Josiah?"
	done

Route73_Trainer_1_Text_12dd96:
	ctxt "I think I know<...>"
	done

Route73_Trainer_1_Script_Text_12ddaa:
	ctxt "Josiah might be"
	line "tough, but he's"
	cont "also hot!"

	para "Literally!"
	done

Route73_Trainer_2_Text_12ddd6:
	ctxt "Think fast!"
	done

Route73_Trainer_2_Text_12ddf8:
	ctxt "Yikes! I wasn't"
	line "fast enough!"
	done

Route73_Trainer_2_Script_Text_12de11:
	ctxt "You always need"
	line "to think fast"
	cont "during battles."
	done

Route73_Trainer_3_Text_12df36:
	ctxt "You must have"
	line "faith in your"
	cont "#mon!"
	done

Route73_Trainer_3_Text_12df61:
	ctxt "I'm questioning my"
	line "decisions now<...>"
	done

Route73_Trainer_3_Script_Text_12df81:
	ctxt "What's the key"
	line "to good battles?"

	para "Motivation!"
	done

Route73_Trainer_4_Text_12deaa:
	ctxt "Catch an Electric"
	line "and Fire #mon!"
	done

Route73_Trainer_4_Text_12dece:
	ctxt "Heed my warning!"
	done

Route73_Trainer_4_Script_Text_12dee6:
	ctxt "Catch an Electric"
	line "and a Fire-type"
	cont "#mon before you"
	cont "go into the cave."

	para "Trust me!"
	done

Route73NPC3_Text_12fc3c:
	ctxt "I'm not letting you"
	line "through right now."

	para "The #mon ahead"
	line "are too tough for"
	cont "a kid like you."

	para "Maybe<...> If you"
	line "defeated Josiah,"
	cont "it could convince"
	cont "me to move."

	para "Hah! As if that"
	line "could happen."
	done

Route73_MapEventHeader:: db 0, 0

.Warps: db 3
	warp_def 33, 11, 1, SPRITE_PICKER_MALE
	warp_def 33, 12, 2, SPRITE_PICKER_MALE
	warp_def 1, 12, 1, MOUND_F1

.CoordEvents: db 0

.BGEvents: db 2
	signpost 2, 19, SIGNPOST_ITEM, Route73HiddenItem_1
	signpost 29, 15, SIGNPOST_LOAD, Route73Signpost2

.ObjectEvents: db 9
	person_event SPRITE_POKE_BALL, 10, 17, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 3, Route73_Item_1, EVENT_ROUTE_73_ITEM_1
	person_event SPRITE_PICNICKER, 25, 14, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_GREEN, 2, 3, Route73_Trainer_1, -1
	person_event SPRITE_BIRDKEEPER, 24, 8, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 4, Route73_Trainer_2, -1
	person_event SPRITE_BUG_CATCHER, 14, 10, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, Route73_Trainer_3, -1
	person_event SPRITE_JUGGLER, 10, 11, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_BLUE, 2, 2, Route73_Trainer_4, -1
	person_event SPRITE_FRUIT_TREE, 30, 10, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_PURPLE, 0, 0, Route73NPC1, -1
	person_event SPRITE_POKE_BALL, 15, 18, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_GREEN, 1, 0, Route73_Item_2, EVENT_ROUTE_73_ITEM_2
	person_event SPRITE_POKE_BALL, 30, 21, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 3, TM_WHIRLWIND, 0, EVENT_ROUTE_73_TM53
	person_event SPRITE_FISHER, 26, 13, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, Route73NPC3, EVENT_ROUTE_73_GUARD

