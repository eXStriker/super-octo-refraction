Route86Dock_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route86DockNPC1:
	faceplayer
	opentext
	writetext Route86DockNPC1_Text_16d24a
	waitbutton
	checkitem FERRY_TICKET
	iffalse Route86Dock_16d242
	writetext Route86DockNPC1_Text_16d280
	yesorno
	iffalse Route86Dock_16d248
	writetext Route86DockNPC1_Text_16d2bf
	waitbutton
	closetext
	spriteface 2, DOWN
	pause 10
	playsound SFX_EXIT_BUILDING
	disappear 2
	waitsfx
	applymovement PLAYER, Route86DockMoveDown
	playsound SFX_EXIT_BUILDING
	disappear 0
	waitsfx
	playsound SFX_BOAT 
	waitsfx
	warp CASTRO_DOCK, 9, 14
	end

Route86DockMoveDown:
	step_down
	step_end

Route86DockNPC2:
	jumptextfaceplayer Route86DockNPC2_Text_16d383

Route86DockNPC3:
	jumptextfaceplayer Route86DockNPC3_Text_16d33e

Route86Dock_16d242:
	jumptext Route86Dock_16d242_Text_16d31a

Route86Dock_16d248:
	closetext
	end

Route86DockNPC1_Text_16d24a:
	ctxt "Welcome to the"
	line "Battle Ferry!"

	para "Do you have a"
	line "ticket?"
	done

Route86DockNPC1_Text_16d280:
	ctxt "Wonderful!"

	para "Would you like to"
	line "board and head"
	cont "to Castro Valley?"
	done

Route86DockNPC1_Text_16d2bf:
	ctxt "Great!"

	para "We'll depart"
	line "right now!"
	done

Route86DockNPC2_Text_16d383:
	ctxt "If you surf north"
	line "you'll end up to"
	cont "the Battle Arcade."
	done

Route86DockNPC3_Text_16d33e:
	ctxt "The Battle Arcade"
	line "has an interesting"
	cont "concept."

	para "Good luck!"
	done

Route86Dock_16d242_Text_16d31a:
	ctxt "Sorry, no ticket"
	line "no entry!"
	done

Route86Dock_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def $3, $9, 5, ROUTE_86_DOCK_EXIT

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_SAILOR, 23, 9, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, Route86DockNPC1, -1
	person_event SPRITE_YOUNGSTER, 11, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, Route86DockNPC2, -1
	person_event SPRITE_COOLTRAINER_F, 13, 12, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, Route86DockNPC3, -1
