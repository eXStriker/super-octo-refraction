LaurelStick_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

LaurelStickNPC1:
	faceplayer
	opentext
	checkevent EVENT_LAUREL_CITY_STICK
	iftrue LaurelStick_1857f3
	writetext LaurelStickNPC1_Text_1857ff
	buttonsound
	verbosegiveitem STICK, 1
	iffalse LaurelStick_1857f7
	setevent EVENT_LAUREL_CITY_STICK
	waitbutton
	jumptext LaurelStickNPC1_Text_185851

LaurelStickNPC2:
	jumptextfaceplayer LaurelStickNPC2_Text_185888

LaurelStick_1857f3:
	jumptext LaurelStickNPC1_Text_185851

LaurelStick_1857f7:
	closetext
	end

LaurelStickNPC1_Text_1857ff:
	ctxt "Hehehe<...>"

	para "I collect sticks."

	para "<...>"

	para "What's that?"
	line "Stickers?"

	para "Oh my, younglings"
	line "these day<...>"

	para "Here, you can have"
	line "one of my sticks."
	done

LaurelStickNPC1_Text_185851:
	ctxt "Sticks can be"
	line "useful in the"
	cont "right place."
	done

LaurelStickNPC2_Text_185888:
	ctxt "Oh, grandma<...>"

	para "Is your memory"
	line "really gone?"
	done

LaurelStick_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 2, LAUREL_CITY
	warp_def $7, $3, 2, LAUREL_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_GRANNY, 3, 2, SPRITEMOVEDATA_SPINCLOCKWISE, 1, 1, -1, -1, 8 + PAL_OW_BROWN, 0, 0, LaurelStickNPC1, -1
	person_event SPRITE_TEACHER, 2, 7, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, 0, 0, LaurelStickNPC2, -1
