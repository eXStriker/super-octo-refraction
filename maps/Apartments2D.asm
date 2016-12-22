Apartments2D_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Apartments2DNPC1:
	faceplayer
	opentext
	checkevent EVENT_SPURGE_APARTMENT_TM67
	iftrue Apartments2D_3203f7
	writetext Apartments2DNPC1_Text_3203fd
	waitbutton
	givetm 67 + RECEIVED_TM
	setevent EVENT_SPURGE_APARTMENT_TM67
	closetext
	end

Apartments2D_3203f7:
	jumptext Apartments2D_3203f7_Text_3204be

Apartments2DNPC1_Text_3203fd:
	ctxt "The world is"
	line "experiencing a"
	cont "constant change."

	para "Technology keeps"
	line "growing without"
	cont "signs of decline."

	para "Therefore, I must"
	line "get rid of this TM"
	para "to work against"
	line "the current trend."

	para "I also need to"
	line "make some room in "
	cont "my apartment<...>"
	done

Apartments2D_3203f7_Text_3204be:
	ctxt "TM67 is called"
	line "Tri Attack."

	para "Its type is a"
	line "combination of"
	para "Fire, Ice, and"
	line "Electric."

	para "It also has the"
	line "chance of either"
	para "burning, freezing,"
	line "or paralyzing"
	cont "your opponent."
	done

Apartments2D_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $9, $4, 4, APARTMENTS_F3
	warp_def $9, $5, 4, APARTMENTS_F3

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_SCIENTIST, 5, 2, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, Apartments2DNPC1, -1
