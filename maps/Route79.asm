Route79_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route79HiddenItem_1:
	dw EVENT_ROUTE_79_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route79_Trainer_1:
	trainer EVENT_ROUTE_79_TRAINER_1, COOLTRAINERM, 10, Route79_Trainer_1_Text_13ecf0, Route79_Trainer_1_Text_13ed3f, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route79_Trainer_1_Script_Text_13ed66

Route79_Trainer_2:

	trainer EVENT_ROUTE_79_TRAINER_2, BIRD_KEEPER, 6, Route79_Trainer_2_Text_13ebec, Route79_Trainer_2_Text_13ec54, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route79_Trainer_2_Script_Text_13ec9d

Route79_Trainer_3:
	trainer EVENT_ROUTE_79_TRAINER_3, POKEFANM, 4, Route79_Trainer_3_Text_13ea52, Route79_Trainer_3_Text_13ea7a, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route79_Trainer_3_Script_Text_13eaaa

Route79_Trainer_4:
	trainer EVENT_ROUTE_79_TRAINER_4, COOLTRAINERM, 9, Route79_Trainer_4_Text_13eaed, Route79_Trainer_4_Text_13eb49, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route79_Trainer_4_Script_Text_13eb6c

Route79_Item_1:
	db WATER_RING, 1

Route79_Trainer_1_Text_13ecf0:
	ctxt "Visiting jail is"
	line "something else."

	para "It's such a thrill"
	line "to see all of the"
	cont "hostile #mon."
	done

Route79_Trainer_1_Text_13ed3f:
	ctxt "<...> Guess I should"
	line "learn from the"
	cont "prison #mon."
	done

Route79_Trainer_1_Script_Text_13ed66:
	ctxt "Many of those"
	line "locked up #mon"

	para "were abused by"
	line "their Trainers."

	para "I feel sorry for"
	line "them, but it"

	para "makes sense to"
	line "keep them locked"

	para "away so they don't"
	line "harm anyone else."
	done

Route79_Trainer_2_Text_13ebec:
	ctxt "I just broke out"
	line "of that prison."

	para "What did I do to"
	line "get there in the"
	cont "first place?"

	para "That's none of"
	line "your business."
	done

Route79_Trainer_2_Text_13ec54:
	ctxt "Guess my #mon"
	line "are pretty rusty."

	para "They usually don't"
	line "allow battles in"
	cont "the prison."
	done

Route79_Trainer_2_Script_Text_13ec9d:
	ctxt "You could say I'm"
	line "a jailbird."

	para "<...>"

	para "Start laughing"
	line "before I get mad."
	done

Route79_Trainer_3_Text_13ea52:
	ctxt "Yooo, my brotha!"

	para "I'm the biggest"
	line "Ponyta fan ever!"
	done

Route79_Trainer_3_Text_13ea7a:
	ctxt "Other ponyta fans"
	line "will give me some"
	cont "backlash for this!"
	done

Route79_Trainer_3_Script_Text_13eaaa:
	ctxt "Join my Ponyta"
	line "club, we're all"
	cont "super friendly."
	done

Route79_Trainer_4_Text_13eaed:
	ctxt "I just gave all"
	line "of my #mon a"
	cont "bunch of Protein."

	para "They'll now have"
	line "no problem taking"
	cont "you down!"
	done

Route79_Trainer_4_Text_13eb49:
	ctxt "Wait, why didn't"
	line "the Protein work?"
	done

Route79_Trainer_4_Script_Text_13eb6c:
	ctxt "Turns out that"
	line "Protein doesn't"
	cont "work instantly<...>"

	para "Your #mon have"
	line "to grow in level"
	cont "after using it."

	para "Got any of those<...>"

	para "Rare Candies?"
	done

Route79_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $d, $2, 2, ROUTE_78_EAST_EXIT
	warp_def $3, $20, 3, SAXIFRAGE_EXITS

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 16, 27, SIGNPOST_ITEM, Route79HiddenItem_1

	;people-events
	db 5
	person_event SPRITE_COOLTRAINER_M, 5, 29, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, 0, 2, 1, Route79_Trainer_1, -1
	person_event SPRITE_BIRDKEEPER, 8, 23, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 2, 1, Route79_Trainer_2, -1
	person_event SPRITE_POKEFAN_M, 12, 10, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, 0, 2, 1, Route79_Trainer_3, -1
	person_event SPRITE_COOLTRAINER_M, 12, 20, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 8 + PAL_OW_GREEN, 2, 4, Route79_Trainer_4, -1
	person_event SPRITE_POKE_BALL, 2, 7, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 1, 0, Route79_Item_1, EVENT_ROUTE_79_ITEM_1
