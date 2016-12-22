Route68_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route68HiddenItem_1:
	dw EVENT_ROUTE_68_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route68Signpost1:
	ctxt "<LEFT> Acania Docks"
	next "<RIGHT> Rijon Border"
	next "<RIGHT><RIGHT>Hayward City"
	done ;46

Route68_Trainer_1:
	trainer EVENT_ROUTE_68_TRAINER_1, OFFICER, 4, Route68_Trainer_1_Text_1379a2, Route68_Trainer_1_Text_1379d1, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext Route68_Trainer_1_Script_Text_1379e6
	endtext

Route68_Trainer_2:
	trainer EVENT_ROUTE_68_TRAINER_2, SWIMMERM, 15, Route68_Trainer_2_Text_1378fb, Route68_Trainer_2_Text_137933, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext Route68_Trainer_2_Script_Text_137965
	endtext

Route68_Trainer_3:
	trainer EVENT_ROUTE_68_TRAINER_3, SWIMMERM, 14, Route68_Trainer_3_Text_1377c5, Route68_Trainer_3_Text_1377e9, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext Route68_Trainer_3_Script_Text_1377f2
	endtext

Route68_Trainer_4:
	trainer EVENT_ROUTE_68_TRAINER_4, SWIMMERF, 10, Route68_Trainer_4_Text_137868, Route68_Trainer_4_Text_1378a5, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext Route68_Trainer_4_Script_Text_1378b6
	endtext

Route68_Trainer_5:
	trainer EVENT_ROUTE_68_TRAINER_5, SWIMMERF, 11, Route68_Trainer_5_Text_135e88, Route68_Trainer_5_Text_135ee0, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext Route68_Trainer_5_Script_Text_135ef9
	endtext

Route68NPC1:
	fruittree 25

Route68_Item_1:
	db ELIXIR, 1

Route68_Trainer_1_Text_1379a2:
	ctxt "You're thinking"
	line "of leaving Naljo?"

	para "Can you handle it?"
	done

Route68_Trainer_1_Text_1379d1:
	ctxt "Looks like it."
	done

Route68_Trainer_1_Script_Text_1379e6:
	ctxt "Just don't cause"
	line "any problems in"
	cont "Rijon, please."

	para "Naljo already has"
	line "a bad pretty bad"
	cont "rep over there."
	done

Route68_Trainer_2_Text_1378fb:
	ctxt "I'm from Rijon,"
	line "just visiting to"
	cont "experience Naljo."
	done

Route68_Trainer_2_Text_137933:
	ctxt "Oh yeah, I also"
	line "like to battle"
	cont "people from Naljo."
	done

Route68_Trainer_2_Script_Text_137965:
	ctxt "What do you mean,"
	line "'you don't really"
	cont "recommend Naljo?'"
	done

Route68_Trainer_3_Text_1377c5:
	ctxt "This is my"
	line "favorite swimming"
	cont "spot!"
	done

Route68_Trainer_3_Text_1377e9:
	ctxt "Whoops."
	done

Route68_Trainer_3_Script_Text_1377f2:
	ctxt "The water is"
	line "clearer here"

	para "than everywhere"
	line "else in Naljo."

	para "You can see the"
	line "#mon swimming"
	cont "below us!"
	done

Route68_Trainer_4_Text_137868:
	ctxt "When swimming, I"
	line "do try to avoid"
	cont "dunking my head"
	cont "in the water."
	done

Route68_Trainer_4_Text_1378a5:
	ctxt "That was harsh."
	done

Route68_Trainer_4_Script_Text_1378b6:
	ctxt "I don't dunk my"
	line "head, ever."

	para "My make-up would"
	line "wash off!"
	done

Route68_Trainer_5_Text_135e88:
	ctxt "So glad they built"
	line "that dock town."

	para "I can rest between"
	line "my swim to Torenia"
	cont "from Hayward."
	done

Route68_Trainer_5_Text_135ee0:
	ctxt "Well that tired"
	line "me out alright."
	done

Route68_Trainer_5_Script_Text_135ef9:
	ctxt "Some fly, some"
	line "dig, some swim."

	para "I prefer swimming."
	done

Route68_MapEventHeader:: db 0, 0

.Warps: db 1
	warp_def 5, 49, 1, NALJO_BORDER_WEST

.CoordEvents: db 0

.BGEvents: db 2
	signpost 7, 51, SIGNPOST_LOAD, Route68Signpost1
	signpost 14, 22, SIGNPOST_ITEM, Route68HiddenItem_1

.ObjectEvents: db 7
	person_event SPRITE_OFFICER, 6, 48, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 1, Route68_Trainer_1, -1
	person_event SPRITE_SWIMMER_GUY, 13, 30, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 2, 1, Route68_Trainer_2, -1
	person_event SPRITE_SWIMMER_GUY, 6, 9, SPRITEMOVEDATA_SPINCLOCKWISE, 0, 0, -1, -1, PAL_OW_GREEN, 2, 3, Route68_Trainer_3, -1
	person_event SPRITE_SWIMMER_GIRL, 11, 16, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_YELLOW, 2, 3, Route68_Trainer_4, -1
	person_event SPRITE_SWIMMER_GIRL, 6, 34, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_PURPLE, 2, 3, Route68_Trainer_5, -1
	person_event SPRITE_FRUIT_TREE, 11, 10, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, Route68NPC1, -1
	person_event SPRITE_POKE_BALL, 7, 16, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, Route68_Item_1, EVENT_ROUTE_68_ITEM_1

