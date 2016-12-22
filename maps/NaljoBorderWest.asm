NaljoBorderWest_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

NaljoBorderWestTrap1:
	checkevent EVENT_BADGE_CHECKER
	iftrue NaljoBorderWest_11da70
	opentext
	writetext NaljoBorderWestTrap1_Text_11da84
	waitbutton
	applymovement 0, NaljoBorderWestTrap1_Movement1
	writetext NaljoBorderWestTrap1_Text_11da94
	waitbutton
	checkcode VAR_BADGES
	if_less_than 8, NaljoBorderWest_11da71
	setevent EVENT_BADGE_CHECKER
	writetext NaljoBorderWestTrap1_Text_11daf1
	playwaitsfx SFX_DEX_FANFARE_50_79
	jumptext NaljoBorderWestTrap1_Text_11db28

NaljoBorderWestTrap1_Movement1:
	turn_head_left
	step_end

NaljoBorderWestNPC1:
	jumptextfaceplayer NaljoBorderWestNPC1_Text_11ebaf

NaljoBorderWest_11da70:
	end

NaljoBorderWest_11da71:
	writetext NaljoBorderWest_11da71_Text_11db45
	playwaitsfx SFX_WRONG
	writetext NaljoBorderWest_11da71_Text_11db6e
	waitbutton
	closetext
	applymovement 0, NaljoBorderWest_11da71_Movement1
	end

NaljoBorderWest_11da71_Movement1:
	step_down
	step_end

NaljoBorderWestNPC2:
	jumptextfaceplayer NaljoBorderWestNPC2Text

NaljoBorderWestNPC2Text:
	ctxt "Only the best of"
	line "the best have a"

	para "chance to compete"
	line "in Rijon's League!"

	para "Don't take it for"
	line "granted!"
	done

NaljoBorderWestTrap1_Text_11da84:
	ctxt "Hang on there."
	done

NaljoBorderWestTrap1_Text_11da94:
	ctxt "I can only allow"
	line "you to use the"

	para "warp to the Rijon"
	line "League if you have"

	para "at least eight"
	line "badges."
	done

NaljoBorderWestTrap1_Text_11daf1:
	ctxt "Spectacular!"

	para "You've collected"
	line "all of the Naljo"
	cont "Badges."
	done

NaljoBorderWestTrap1_Text_11db28:
	ctxt "You are permitted"
	line "to enter."
	done

NaljoBorderWestNPC1_Text_11ebaf:
	ctxt "Many Trainers try"
	line "to sneak by."

	para "We've really had"
	line "to beef up"
	cont "security here."
	done

NaljoBorderWest_11da71_Text_11db45:
	ctxt "Sorry, looks like"
	line "you don't have"
	cont "enough."
	done

NaljoBorderWest_11da71_Text_11db6e:
	ctxt "Come back when"
	line "you've collected"
	cont "eight of them."
	done

NaljoBorderWest_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $13, $4, 1, ROUTE_68
	warp_def $13, $5, 1, ROUTE_68
	warp_def $2, $5, 1, NALJO_BORDER_WARPROOM
	warp_def $c, $11, 1, NALJO_BORDER_EAST

	;xy triggers
	db 2
	xy_trigger 0, $f, $4, $0, NaljoBorderWestTrap1, $0, $0
	xy_trigger 0, $f, $5, $0, NaljoBorderWestTrap1, $0, $0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_OFFICER, 15, 2, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, NaljoBorderWestNPC1, -1
	person_event SPRITE_OFFICER, 13, 8, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, NaljoBorderWestNPC2, EVENT_ROUTE_63_TRAINER_2
