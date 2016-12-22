CastroDock_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

CastroDockNPC1:
	jumptextfaceplayer CastroDockNPC1_Text

CastroDockNPC2:
	faceplayer
	opentext
	writetext CastroDockNPC2_Text_Welcome
	waitbutton
	checkitem FERRY_TICKET
	sif false
		jumptext CastroDockNPC2_Text_NoTicket
	writetext CastroDockNPC2_Text_WantToGo
	yesorno
	sif false, then
		closetext
		end
	sendif
	writetext CastroDockNPC2_Text_Departing
	waitbutton
	closetext
	spriteface 3, DOWN
	pause 10
	playsound SFX_EXIT_BUILDING
	disappear 3
	waitsfx
	applymovement PLAYER, CastroDockMoveDown
	playsound SFX_EXIT_BUILDING
	disappear 0
	waitsfx
	playsound SFX_BOAT 
	waitsfx
	warp ROUTE_86_DOCK, 9, 22
	end

CastroDockMoveDown:
	step_down
	step_end

CastroDockNPC1_Text:
	ctxt "You need a"
	line "special ticket"

	para "to board the"
	line "ferry."

	para "Do they still"
	line "make those?"
	done

CastroDockNPC2_Text_Welcome:
	ctxt "Welcome to the"
	line "Arcade Ferry!"

	para "Do you have a"
	line "ticket?"
	done

CastroDockNPC2_Text_WantToGo:
	ctxt "Wonderful!"

	para "Would you like to"
	line "board and head to"
	cont "the Battle Arcade?"
	done

CastroDockNPC2_Text_Departing:
	ctxt "Great!"

	para "We'll depart right"
	line "now!"
	done

CastroDockNPC2_Text_NoTicket:
	ctxt "Sorry, no ticket,"
	line "no entry!"
	done

CastroDock_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def $5, $9, 2, CASTRO_DOCK_PATH

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_SAILOR, 8, 3, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_BLUE, 0, 0, CastroDockNPC1, -1
	person_event SPRITE_SAILOR, 15, 9, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, CastroDockNPC2, -1
