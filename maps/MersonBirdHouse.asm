MersonBirdHouse_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MersonBirdHouseNPC1:
	faceplayer
	opentext
	writetext MersonBirdHouseNPC1_Text_322616
	cry SWELLOW
	waitsfx
	endtext

MersonBirdHouseNPC2:
	faceplayer
	opentext
	checkevent EVENT_TM62
	iftrue MersonBirdHouse_32247c
	writetext MersonBirdHouseNPC2_Text_322482
	waitbutton
	givetm 62 + RECEIVED_TM
	setevent EVENT_TM62
	closetext
	end

MersonBirdHouseNPC3:
	faceplayer
	opentext
	writetext MersonBirdHouseNPC3_Text_322633
	cry XATU
	waitsfx
	endtext

MersonBirdHouseNPC4:
	faceplayer
	opentext
	writetext MersonBirdHouseNPC4_Text_3225f3
	cry PIDGEOT
	waitsfx
	endtext

MersonBirdHouse_32247c:
	jumptext MersonBirdHouse_32247c_Text_322532

MersonBirdHouseNPC1_Text_322616:
	ctxt "Swellow: Kaw!"
	done

MersonBirdHouseNPC2_Text_322482:
	ctxt "Ha!"

	para "The swiftness of"
	line "a flying #mon"

	para "cannot be"
	line "outmatched!"

	para "You seem like a"
	line "traveller just"

	para "like me just"
	line "bursting with"
	cont "courage!"

	para "It feels like you"
	line "can love this TM"
	cont "just like I do!"
	done

MersonBirdHouseNPC3_Text_322633:
	ctxt "Xatu: tu!!!"
	done

MersonBirdHouseNPC4_Text_3225f3:
	ctxt "aaabaaajss: Ott"
	line "ot!"
	done

MersonBirdHouse_32247c_Text_322532:
	ctxt "TM62 is Sky"
	line "Attack!"

	para "It takes one turn"
	line "to charge, but"

	para "afterwards it"
	line "deals a very"

	para "devastating blow"
	line "to your foe!"
	done

MersonBirdHouse_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 5, MERSON_CITY
	warp_def $7, $3, 5, MERSON_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 4
	person_event SPRITE_SWELLOW, 7, 6, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, MersonBirdHouseNPC1, -1
	person_event SPRITE_BLACK_BELT, 3, 2, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MersonBirdHouseNPC2, -1
	person_event SPRITE_XATU, 2, 7, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, MersonBirdHouseNPC3, -1
	person_event SPRITE_PIDGEOT, 4, 0, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, MersonBirdHouseNPC4, -1
