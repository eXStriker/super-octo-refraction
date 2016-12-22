Route72Gate_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route72GateNPC1:
	jumptextfaceplayer Route72GateNPC1_Text_15b7e0

Route72GateNPC2:
	jumptextfaceplayer Route72GateNPC2_Text_15b86a

Route72GateNPC3:
	jumptextfaceplayer Route72GateNPC3_Text_15b835

Route72GateNPC4:
	faceplayer
	checkevent EVENT_BIG_SHINY_BALL_REWARD
	sif true
		jumptext Route72OldManAfterShinyBalls
	checkevent EVENT_ROUTE_72_GATE_POKEBALLS
	iftrue Route72Gate_15b6e8
	opentext
	writetext Route72Gate_15b7c8_Text_15b6f0
	setevent EVENT_ROUTE_72_GATE_POKEBALLS
	verbosegiveitem POKE_BALL, 5
	jumptext Route72OldManAfterShinyBalls

Route72Gate_15b6e8:
	checkcode VAR_DEXCAUGHT
	sif <, 253
		jumptext Route72Gate_15b6e8_Text_15b77d
	opentext
	writetext Route72OldManShowAllPokemonText
	waitbutton
	verbosegiveitem SHINY_BALL, 20
	setevent EVENT_BIG_SHINY_BALL_REWARD
	jumptext Route72OldManGaveShinyBalls

Route72OldManAfterShinyBalls:
	ctxt "You should be very"
	line "proud of what you"
	cont "accomplished."

	para "Completing the"
	line "Naljo Dex is no"
	cont "easy feat!"
	done

Route72OldManGaveShinyBalls:
	ctxt "These special"
	line "balls make any"
	cont "#mon shiny!"

	para "It has a strange"
	line "side effect on"
	cont "certain species."

	para "But I've never seen"
	line "it happen myself."

	para "Make sure you use"
	line "these wisely!"
	done

Route72OldManShowAllPokemonText:
	ctxt "What's this?!"

	para "253 #mon!"

	para "Simply amazing!"

	para "An impressive deed"
	line "such as this must"
	cont "be rewarded!"

	para "Oh, I know!"

	para "Please take good"
	line "care of these."
	done

Route72GateNPC1_Text_15b7e0:
	ctxt "Route 72 is ahead."

	para "It is full of"
	line "eager Trainers"
	cont "waiting to battle."

	para "Frankly<...>"

	para "What losers."
	done

Route72GateNPC2_Text_15b86a:
	ctxt "I need to do some"
	line "thinking<...>"

	para "My #mon hates"
	line "me, and I don't"
	cont "know why<...>"
	done

Route72GateNPC3_Text_15b835:
	ctxt "The stairs lead"
	line "down to a cave,"
	cont "so be careful."
	done

Route72Gate_15b7c8_Text_15b6f0:
	ctxt "Hello there."

	para "You're interested"
	line "in completing the"
	cont "#dex someday?"

	para "If so, perhaps I"
	line "can help you out!"

	para "This isn't much,"
	line "but it will be of"
	cont "some assistance."
	prompt

Route72Gate_15b7c8_Text_15b762:
	ctxt "<PLAYER> got"
	line "5 #balls!"
	done

Route72Gate_15b6e8_Text_15b77d:
	ctxt "I'm eager to see"
	line "a complete Naljo"
	cont "region #dex."

	para "Come back when"
	line "you're done!"
	done

Route72Gate_MapEventHeader ;filler
	db 0, 0

;warps
	db 9
	warp_def $0, $4, 1, ROUTE_72
	warp_def $0, $5, 2, ROUTE_72
	warp_def $7, $4, 1, ROUTE_71
	warp_def $7, $5, 1, ROUTE_71
	warp_def $e, $4, 4, OXALIS_CITY
	warp_def $e, $5, 15, OXALIS_CITY
	warp_def $15, $4, 3, ROUTE_72
	warp_def $15, $5, 3, ROUTE_72
	warp_def $7, $8, 6, CLATHRITE_1F

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 4
	person_event SPRITE_OFFICER, 4, 9, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, Route72GateNPC1, -1
	person_event SPRITE_OFFICER, 17, 0, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, Route72GateNPC2, -1
	person_event SPRITE_GRAMPS, 3, 3, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, Route72GateNPC3, -1
	person_event SPRITE_POKEFAN_M, 6, 0, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 0, 0, Route72GateNPC4, -1
