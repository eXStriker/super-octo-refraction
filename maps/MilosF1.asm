MilosF1_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MilosF1HiddenItem_1:
	dw EVENT_MILOS_F1_HIDDENITEM_RARE_CANDY
	db RARE_CANDY

MilosF1_Trainer_1:
	trainer EVENT_MILOS_F1_TRAINER_1, RIVAL1, RIVAL1_3, MilosF1_Trainer_1_Text_11dfb8, MilosF1_Trainer_1_Text_11e091, $0000, .Script

.Script:
	jumptext MilosF1_Trainer_1_Script_Text_11e0b5

MilosF1_Item_1:
	db TRADE_STONE, 1

MilosF1_Item_2:
	db CALCIUM, 1

MilosF1_Item_3:
	db NUGGET, 1

MilosF1_Item_4:
	db ESCAPE_ROPE, 1

MilosF1NPC1:
	jumpstd strengthboulder

MilosF1NPC2:
	faceplayer
	opentext
	writetext MilosF1NPC2_Text_11e157
	waitbutton
	writetext MilosF1NPC2_Text_11e1b2
	waitbutton
	winlosstext MilosF1NPC2Text_11e2cd, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadtrainer OFFICER, 1
	startbattle
	reloadmapafterbattle
	playmapmusic
	opentext
	writetext MilosF1NPC2_Text_11e2e1
	waitbutton
	special Special_BattleTowerFade
	playsound SFX_ENTER_DOOR
	waitsfx
	warpfacing LEFT, PHACELIA_POLICE_F2, 3, 1
	spriteface 2, 3
	opentext
	writetext MilosF1NPC2_Text_11e34d
	waitbutton
	callasm DressUpAsPalette
	closetext
	setevent EVENT_ROUTE_85_POLICEMAN_GONE
	setevent EVENT_IN_UNDERCOVER_MISSION
	blackoutmod PHACELIA_TOWN
	callasm CancelMapSign
	jumptext MilosF1NPC2_Text_11e44c

DressUpAsPalette:
	ld a, [wPlayerGender]
	ld [wSavedPlayerCharacteristics2], a
	and 1
	ld c, $c
	add c
	ld [wPlayerGender], a
	ret

MilosF1_Trainer_1_Text_11dfb8:
	ctxt "Oh look, it's the"
	line "little kid who"
	cont "won't just quit."

	para "Your persistence"
	line "is nothing but a"
	para "nuisance to all"
	line "Naljo residents."

	para "I'm bloody tired of"
	line "this goody little"
	para "two shoes trying"
	line "to hinder my big"
	cont "ambitions again."

	para "Your #mon"
	line "better know how"
	cont "to fight by now."
	done

MilosF1_Trainer_1_Text_11e091:
	ctxt "I'm not hard"
	line "enough on these"
	cont "#mon wimps!"
	done

MilosF1_Trainer_1_Script_Text_11e0b5:
	ctxt "Look, I do what I"
	line "gotta do, OK?"

	para "A guy like me"
	line "doesn't need to"
	cont "explain himself."

	para "Just<...> Just"
	line "leave me alone."
	done

MilosF1NPC2_Text_11e157:
	ctxt "I'm guarding this"
	line "area right here."

	para "Hm<...> Wait,"
	line "who are you?"

	para "<...>"

	para "I see."

	para "Well, do you have"
	line "any sort of ID<...>?"

	para "A visa?"

	para "A passport?"
	done

MilosF1NPC2_Text_11e1b2:
	ctxt "Wait, you fit the"
	line "profile of the"
	para "wanted criminal"
	line "we've been on the"
	cont "lookout for."

	para "A kid with spiky"
	line "hair let us know"
	para "of some foreigner"
	line "that's vandalizing"
	para "this area, and has"
	line "been mistreating"
	cont "poor #mon."

	para "<...>"

	para "Wait, so you can"
	line "prove that you"
	para "in fact treat your"
	line "#mon with the"
	para "love and respect"
	line "that they deserve?"

	para "Fine, let's see"
	line "how you battle."
	done

MilosF1NPC2Text_11e2cd:
	ctxt "I guess I stand"
	line "corrected!"
	done

MilosF1NPC2_Text_11e2e1:
	ctxt "Well you proved"
	line "yourself, that"
	cont "enough I can say."

	para "However, you're"
	line "still not allowed"
	cont "to be here."

	para "Come with me."
	done

MilosF1NPC2_Text_11e34d:
	ctxt "If you're willing"
	line "to go undercover"
	para "for me and find"
	line "another criminal,"
	cont "I'll let you stay."

	para "Pallet Patrollers"
	line "are loitering"
	para "nearby, and I"
	line "need your help"
	para "with arresting"
	line "one of them."

	para "Here - take this"
	line "suit, gain their"
	para "trust, and bring"
	line "them to me."
	done

MilosF1NPC2_Text_11e44c:
	ctxt "You look<...>"

	para "Well<...>"

	para "Interesting."

	para "Lure one of those"
	line "thugs back here."
	done

MilosF1_MapEventHeader ;filler
	db 0, 0

;warps
	db 9
	warp_def $3, $b, 5, ROUTE_77
	warp_def $25, $2f, 2, MILOS_TOWERCLIMB
	warp_def $39, $25, 1, PHACELIA_TOWN
	warp_def $1d, $5, 2, MILOS_B2FB
	warp_def $1b, $21, 3, MILOS_B1F
	warp_def $39, $39, 2, PHACELIA_GYM
	warp_def $11, $1b, 2, MILOS_B2F
	warp_def $20, $18, 2, CAPER_CITY
	warp_def $15, $15, 1, MILOS_B1F

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 28, 25, SIGNPOST_ITEM, MilosF1HiddenItem_1

	;people-events
	db 7
	person_event SPRITE_SILVER, 8, 11, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, 2, 4, MilosF1_Trainer_1, EVENT_MILOS_F1_TRAINER_1
	person_event SPRITE_POKE_BALL, 42, 12, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, MilosF1_Item_1, EVENT_MILOS_F1_ITEM_1
	person_event SPRITE_POKE_BALL, 56, 54, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, MilosF1_Item_2, EVENT_MILOS_F1_ITEM_2
	person_event SPRITE_POKE_BALL, 5, 37, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 0, MilosF1_Item_3, EVENT_MILOS_F1_ITEM_3
	person_event SPRITE_POKE_BALL, 24, 19, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 1, 0, MilosF1_Item_4, EVENT_MILOS_F1_ITEM_4
	person_event SPRITE_BOULDER, 48, 17, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, MilosF1NPC1, -1
	person_event SPRITE_OFFICER, 57, 37, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, MilosF1NPC2, EVENT_ARRESTED_PALETTE_BLACK
