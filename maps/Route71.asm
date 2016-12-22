Route71_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route71HiddenItem_1:
	dw EVENT_ROUTE_71_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route71Signpost1:
	ctxt "<LEFT> Caper City"
	next "<RIGHT><UP>Oxalis City"
	next "<RIGHT> Clathrite"
	next "  Tunnel"
	done ;5

Route71Signpost3:
	ctxt "<UP> Oxalis City" ;54
	next "<LEFT> Caper City"
	next "<RIGHT> Clathrite"
	next "  Tunnel"
	done

Route71NPC2:
	jumptextfaceplayer Route71NPC2_Text_12903f

Route71NPC3:
	jumptextfaceplayer Route71NPC3_Text_129097

Route71NPC4:
	fruittree 15

Route71NPC5:
	jumptextfaceplayer Route71NPC5_Text_129104

Route71NPC6:
	checktime 2
	iftrue Route71_128e68
	checktime 4
	iftrue Route71_128e6e
	jumptextfaceplayer Route71NPC6_Text_129177

Route71_128e68:
	jumptextfaceplayer Route71NPC6_Text_129177

Route71_128e6e:
	jumptextfaceplayer Route71_128e6e_Text_1291a7

Route69_Trainer_3:
	trainer EVENT_ROUTE_69_TRAINER_3, HIKER, 1, Route69_Trainer_3_Text_135147, Route69_Trainer_3_Text_135162, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer Route69_Trainer_3_Script_Text_13517e

Route71NPC2_Text_12903f:
	ctxt "I really dislike"
	line "celebrities."
	
	para "They just get so"
	line "much attention for"
	cont "so little effort!"
	
	para "I mean, even"
	line "the champion of"
	cont "the Rijon League"
	cont "has his own TV"
	cont "show!"
	
	para "That's nuts!"
	done

Route71NPC3_Text_129097:
	ctxt "Was Caper City"
	line "too cold for you?"

	para "You're in luck!"

	para "It starts getting"
	line "warmer from this"
	cont "route onwards."
	done

Route71NPC5_Text_129104:
	ctxt "I'm too anxious"
	line "standing here."

	para "I'm afraid of"
	line "falling off."

	para "Maybe if I"
	line "crawled down, I"
	cont "would be safe."
	done

Route71NPC6_Text_129177:
	ctxt "Key,"
	line "Gym,"
	cont "Psychic."

	para "Get it?"
	done

Route71_128e6e_Text_1291a7:
	ctxt "Crystal Silk"

	para "Get it?"
	done

Route69_Trainer_3_Text_135147:
	ctxt "Go, Sentret!"
	done

Route69_Trainer_3_Text_135162:
	ctxt "No, Sentret!"
	done

Route69_Trainer_3_Script_Text_13517e:
	ctxt "Gah!"

	para "Wipe that stupid"
	line "smirk of yours"
	cont "off your face!"
	done

Route70_Trainer_1_Text_12975e:
	ctxt "My bugs will grow"
	line "up to be strong!"
	done

Route70_Trainer_1_Text_129789:
	ctxt "Argh! No fair!"
	done

Route70_Trainer_1_Script_Text_1297a2:
	ctxt "Don't underestimate"
	line "the power of Bug-"
	cont "type #mon!"
	done


Route71_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def $5, $33, 3, ROUTE_72_GATE

	;xy triggers
	db 0

	;signposts
	db 3
	signpost 5, 15, SIGNPOST_LOAD, Route71Signpost1
	signpost 5, 30, SIGNPOST_ITEM, Route71HiddenItem_1
	signpost 7, 52, SIGNPOST_LOAD, Route71Signpost3

	;people-events
	db 7
	person_event SPRITE_YOUNGSTER, 10, 40, SPRITEMOVEDATA_WANDER, 3, 3, -1, -1, 8 + PAL_OW_GREEN, 0, 0, Route71NPC2, -1
	person_event SPRITE_TEACHER, 5, 7, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 2, 2, -1, -1, 8 + PAL_OW_GREEN, 0, 0, Route71NPC3, -1
	person_event SPRITE_FRUIT_TREE, 4, 41, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, Route71NPC4, -1
	person_event SPRITE_FISHER, 4, 18, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 8 + PAL_OW_YELLOW, 0, 0, Route71NPC5, -1
	person_event SPRITE_COOLTRAINER_M, 12, 51, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 0, 0, 0, Route71NPC6, -1
	person_event SPRITE_HIKER, 10, 48, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 2, 4, Route69_Trainer_3, -1
	person_event SPRITE_BUG_CATCHER, 12, 19, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 2, 3, Route70_Trainer_1, -1
