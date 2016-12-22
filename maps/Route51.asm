Route51_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route51HiddenItem_1:
	dw EVENT_ROUTE_51_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route51Signpost1:
	ctxt "<RIGHT> Route 50"
	next "<DOWN> Hayward City"
	done

Route51_Trainer_1:
	trainer EVENT_ROUTE_51_TRAINER_1, SUPER_NERD, 4, Route51_Trainer_1_Text_332474, Route51_Trainer_1_Text_3324e8, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route51_Trainer_1_Script_Text_332511

Route51_Trainer_1_Text_332474:
	ctxt "Someone should"
	line "clear this path."

	para "Forcing people to"
	line "walk through"

	para "several blades of"
	line "grass is just"

	para "poor ground"
	line "design."
	done

Route51_Trainer_1_Text_3324e8:
	ctxt "Well this puts"
	line "things into"
	cont "perspective."
	done

Route51_Trainer_1_Script_Text_332511:
	ctxt "I guess I wouldn't"
	line "have found these"

	para "great #mon if"
	line "it wasn't for this"
	cont "grassy path."
	done

Route51_MapEventHeader ;filler
	db 0, 0

;warps
	db 0

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 5, 11, SIGNPOST_LOAD, Route51Signpost1
	signpost 4, 4, SIGNPOST_ITEM, Route51HiddenItem_1

	;people-events
	db 1
	person_event SPRITE_YOUNGSTER, 14, 13, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 2, 3, Route51_Trainer_1, -1
