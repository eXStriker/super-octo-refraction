RuinsF5_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

RuinsF5GrappleHookSpot:
	opentext
	checkitem GRAPPLE_HOOK
	sif false
		jumptext RuinsF5_GrappleHookSpot_Text_NoGrappleHook
	writetext RuinsF5GrappleHookSpot_Text_WantToUseIt
	yesorno
	sif true, then
		playwaitsfx SFX_VICEGRIP
		warp RUINS_ROOF, 6, 9
	sendif
	closetext
	end

RuinsF5Chest:
	opentext
	checkevent EVENT_RUINS_OPENED_CHEST
	sif true
		jumptext RuinsF5_Chest_Text_Empty
	checkitem RED_JEWEL
	sif false
		jumptext RuinsF5_Chest_Text_Locked
	checkitem BLUE_JEWEL
	sif false
		jumptext RuinsF5_Chest_Text_Locked
	checkitem BROWN_JEWEL
	sif false
		jumptext RuinsF5_Chest_Text_Locked
	checkitem WHITE_JEWEL
	sif false
		jumptext RuinsF5_Chest_Text_Locked
	writetext RuinsF5Chest_Text_24efa2
	playwaitsfx SFX_WALL_OPEN
	writetext RuinsF5Chest_Text_Inside
	waitbutton
	takeitem RED_JEWEL, 1
	takeitem BLUE_JEWEL, 1
	takeitem BROWN_JEWEL, 1
	takeitem WHITE_JEWEL, 1
	setevent EVENT_RUINS_OPENED_CHEST
	verbosegiveitem PRISM_JEWEL
	waitbutton
	closetext
	end

RuinsF5_Item_1:
	db WHITE_JEWEL, 1

RuinsF5_PatrollerGreen:
	trainer EVENT_RUINS_F5_TRAINER_1, PATROLLER, 14, RuinsF5_PatrollerGreen_Text_BeforeBattle, RuinsF5_PatrollerGreen_Text_BattleWon, $0000, .Script
.Script
	jumptext RuinsF5_PatrollerGreen_Text_AfterBattle

RuinsF5GrappleHookSpot_Text_WantToUseIt:
	ctxt "You have a"
	line "Grapple Hook."

	para "Want to use it to"
	line "get to the top?"
	done

RuinsF5Chest_Text_24efa2:
	ctxt "Placed all four"
	line "jewels inside of"
	cont "the front holes."

	para "They all fit"
	line "perfectly!"

	para "The chest was"
	line "unlocked!"
	done

RuinsF5Chest_Text_Inside:
	ctxt "Inside is<...>"

	para "The Prism Jewel!"
	done

RuinsF5_PatrollerGreen_Text_BeforeBattle:
	ctxt "Could you just"
	line "stop already?"

	para "We're looking for"
	line "the shards of the"
	cont "Turtle Guardian."

	para "We'll be wealthy"
	line "if we find and"
	cont "deliver them to"
	cont "those scientists!"

	para "We've only found"
	line "some worthless"
	cont "jewels so far."

	para "But you're not"
	line "getting this one."
	done

RuinsF5_PatrollerGreen_Text_BattleWon:
	ctxt "Well, one man's"
	line "trash is another"
	cont "man's delusion."
	done

RuinsF5_PatrollerGreen_Text_AfterBattle:
	ctxt "Look, I need to"
	line "get paid, y'know."

	para "Everyone needs to"
	line "make a living<...>"
	cont "somehow."
	done

RuinsF5_GrappleHookSpot_Text_NoGrappleHook:
	ctxt "There's a hole in"
	line "the ceiling."

	para "It would be quite"
	line "the view if you"
	cont "could somehow"
	cont "get up there!"
	done

RuinsF5_Chest_Text_Empty:
	ctxt "It's empty."

	para "No kidding,"
	line "right?"
	done

RuinsF5_Chest_Text_Locked:
	ctxt "The chest is"
	line "locked."

	para "It looks like"
	line "four items can"
	cont "fit in front."

	para "Could this be the"
	line "way to unlock"
	cont "this thing?"
	done

RuinsF5_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $9, 2, RUINS_F4
	warp_def $6, $2, 1, CAPER_CITY

	;xy triggers
	db 0

	;signposts
	db 3
	signpost 6, 2, SIGNPOST_READ, RuinsF5GrappleHookSpot
	signpost 4, 5, SIGNPOST_UP, RuinsF5Chest
	signpost 4, 6, SIGNPOST_UP, RuinsF5Chest

	;people-events
	db 2
	person_event SPRITE_POKE_BALL, 2, 9, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_SILVER, 1, 0, RuinsF5_Item_1, EVENT_RUINS_F5_ITEM_1
	person_event SPRITE_PALETTE_PATROLLER, 4, 8, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_GREEN, 2, 1, RuinsF5_PatrollerGreen, EVENT_RUINS_F5_TRAINER_1
