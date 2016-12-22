SoutherlyCity_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1

	dbw 5, SoutherlyCity_SetFlyFlag

SoutherlyCity_SetFlyFlag:
	setflag ENGINE_FLYPOINT_SOUTHERLY_CITY
	return

SoutherlyCityTrap1:
	faceperson PLAYER, UP
	faceplayer
	opentext
	writetext SoutherlyCityTrap1_Text_2fa5aa
	waitbutton
	closetext
	applymovement 0, SoutherlyCityTrap1_Movement1
	end

SoutherlyCityTrap1_Movement1:
	step_right
	step_end

SoutherlyCityTrap2:
	faceperson PLAYER, LEFT
	opentext
	writetext SoutherlyCityTrap2_Text_2fa520
	waitbutton
	closetext
	applymovement 0, SoutherlyCityTrap2_Movement1
	end

SoutherlyCityTrap2_Movement1:
	step_down
	step_end

SoutherlyCitySignpost1:
	ctxt "#mon Gym"
	next "Leader: Ernest"
	nl   ""
	next "The guy with good"
	next "firepower!"
	done

SoutherlyCitySignpost2:
	ctxt "Battle Building"
	nl   ""
	next "Put your abilit-"
	next "ies to the test!"
	done

SoutherlyCitySignpost3:
	ctxt "Gateway to"
	next "Paradise!"
	done

SoutherlyCitySignpost4:
	jumpstd pokecentersign

SoutherlyCitySignpost5:
	ctxt "Airport"
	done
	
SoutherlyCityNPC1:
	jumptextfaceplayer SoutherlyCityNPC1Text

SoutherlyCitySignpost6:
	opentext
	writetext SoutherlyCitySignpost6_Text_2faa55
	waitbutton
	checkevent EVENT_REGISTERED_SOUTHERLY
	iftrue SoutherlyCity_2faa41
	writetext SoutherlyCitySignpost6_Text_2faa72
	waitbutton
	setevent EVENT_REGISTERED_SOUTHERLY
	writetext SoutherlyCitySignpost6_Text_2faa92
	yesorno
	iftrue SoutherlyCity_2faa4a
	closetext
	end

SoutherlyCityNPC2:
	jumptextfaceplayer SoutherlyCityNPC2_Text_2fa553

SoutherlyCityNPC3:
	jumptextfaceplayer SoutherlyCityTrap1_Text_2fa5aa

SoutherlyCityNPC4:
	jumptextfaceplayer SoutherlyCityNPC4_Text_2f8af7

SoutherlyCityNPC5:
	jumptextfaceplayer SoutherlyCityTrap2_Text_2fa520

SoutherlyCityNPC6:
	jumptextfaceplayer SoutherlyCityNPC6_Text_2f8b80

SoutherlyCityNPC7:
	faceplayer
	opentext
	writetext SoutherlyCityNPC7_Text_2fa505
	cry TYPHLOSION
	waitsfx
	endtext

SoutherlyCityNPC8:
	jumptextfaceplayer SoutherlyCityNPC8_Text_2fa4a5

SoutherlyCity_2faa41:
	writetext SoutherlyCitySignpost6_Text_2faa92
	yesorno
	iftrue SoutherlyCity_2faa4a
	closetext
	end

SoutherlyCity_2faa4a:
	warp LAUREL_POKECENTER, 5, 5
	end
	
SoutherlyCityNPC1Text:
	ctxt "This is the runway"
	line "for our airport."
	
	para "I can't let you"
	line "pass unless you"
	para "check in with the"
	line "people inside."
	done

SoutherlyCityTrap1_Text_2fa5aa:
	ctxt "Some weird"
	line "happenings have"

	para "been going on in"
	line "Espo Forest."

	para "I've been told to"
	line "guard the area"
	cont "for now."
	done

SoutherlyCityTrap2_Text_2fa520:
	ctxt "The bridge is"
	line "under construction"
	cont "right now."
	done

SoutherlyCitySignpost6_Text_2faa55:
	ctxt "Bill's"
	line "Teleportation"
	cont "System!"
	done

SoutherlyCitySignpost6_Text_2faa72:
	ctxt "Southerly City"
	line "was registered!"
	done

SoutherlyCitySignpost6_Text_2faa92:
	ctxt "Would you like to"
	line "teleport to"
	cont "Laurel City?"
	done

SoutherlyCityNPC2_Text_2fa553:
	ctxt "The airport has a"
	line "new plane!"

	para "The interiors and"
	line "exteriors are all"
	cont "#mon themed!"
	done

SoutherlyCityNPC4_Text_2f8af7:

	ctxt "Every time you"
	line "think you figured"

	para "out the stamina"
	line "challenge, they"

	para "throw you a"
	line "curveball!"

	para "I've been training"
	line "to beat it for"
	cont "years!"
	done

SoutherlyCityNPC6_Text_2f8b80:
	ctxt "It's quite tough"
	line "getting across"
	cont "to Naljo."

	para "I'm hoping that"
	line "they'll eventually"
	cont "build a bridge."
	done

SoutherlyCityNPC7_Text_2fa505:
	ctxt "Typhlosion: Rwar!"
	done

SoutherlyCityNPC8_Text_2fa4a5:
	ctxt "My Typhlosion is"
	line "my best friend!"

	para "I remember when"
	line "he was a cute"
	cont "little Cyndaquil!"
	done

SoutherlyCity_MapEventHeader ;filler
	db 0, 0

;warps
	db 7
	warp_def $7, $6, 1, SOUTHERLY_HOUSE2
	warp_def $7, $b, 1, SOUTHERLY_HOUSE
	warp_def $7, $16, 1, SOUTHERLY_BATTLE_HOUSE
	warp_def $11, $6, 1, SOUTHERLY_MART
	warp_def $11, $a, 1, SOUTHERLY_GYM
	warp_def $1b, $8, 1, SOUTHERLY_AIRPORT
	warp_def $f, $14, 1, SOUTHERLY_POKECENTER

	;xy triggers
	db 2
	xy_trigger 0, $13, $4, $0, SoutherlyCityTrap1, $0, $0
	xy_trigger 0, $4, $10, $0, SoutherlyCityTrap2, $0, $0

	;signposts
	db 6
	signpost 17, 14, SIGNPOST_LOAD, SoutherlyCitySignpost1
	signpost 7, 18, SIGNPOST_LOAD, SoutherlyCitySignpost2
	signpost 7, 14, SIGNPOST_LOAD, SoutherlyCitySignpost3
	signpost 16, 22, SIGNPOST_READ, SoutherlyCitySignpost4
	signpost 26, 12, SIGNPOST_LOAD, SoutherlyCitySignpost5
	signpost 16, 18, SIGNPOST_READ, SoutherlyCitySignpost6

	;people-events
	db 8
	person_event SPRITE_OFFICER, 33, 6, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, SoutherlyCityNPC1, -1
	person_event SPRITE_LASS, 26, 15, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SoutherlyCityNPC2, -1
	person_event SPRITE_OFFICER, 18, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, SoutherlyCityNPC3, -1
	person_event SPRITE_BLACK_BELT, 8, 24, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SoutherlyCityNPC4, -1
	person_event SPRITE_OFFICER, 4, 17, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, SoutherlyCityNPC5, -1
	person_event SPRITE_FISHER, 28, 23, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SoutherlyCityNPC6, -1
	person_event SPRITE_TYPHLOSION, 9, 8, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SoutherlyCityNPC7, -1
	person_event SPRITE_COOLTRAINER_F, 9, 7, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SoutherlyCityNPC8, -1
