BrownsHouseF1_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

BrownsHouseF1NPC1:
	faceplayer
	opentext
	checkevent EVENT_FOUGHT_BROWN
	iftrue BrownsHouseF1_2f0030
	jumptext BrownsHouseF1NPC1_Text_2f004c

BrownsHouseF1_2f0030:
	checkevent EVENT_GOT_TM90
	iftrue BrownsHouseF1_2f0046
	writetext BrownsHouseF1_2f0030_Text_2f00a2
	waitbutton
	setevent EVENT_GOT_TM90
	givetm 90 + RECEIVED_TM
	jumptext BrownsHouseF1_2f0030_Text_2f0136

BrownsHouseF1_2f0046:
	jumptext BrownsHouseF1_2f0046_Text_2f019a

BrownsHouseF1NPC1_Text_2f004c:
	ctxt "I'm worried sick"
	line "about my son"
	cont "Brown."

	para "If you ever find"
	line "him, please let"
	cont "me know he's OK."
	done

BrownsHouseF1_2f0030_Text_2f00a2:
	ctxt "What?"

	para "Brown is in the"
	line "Mystery Zone?"

	para "He could have"
	line "called, but at"

	para "least I feel"
	line "better knowing"
	cont "he's safe."

	para "Take this gift"
	line "please."
	done

BrownsHouseF1_2f0030_Text_2f0136:
	ctxt "This TM holds a"
	line "very special"

	para "move called"
	line "Prism Spray."

	para "The move type is"
	line "randomized after"
	cont "every use!"
	done

BrownsHouseF1_2f0046_Text_2f019a:
	ctxt "Thank you again"
	line "for putting a"

	para "widow's mind at"
	line "ease."
	done

BrownsHouseF1_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $7, $2, 1, SEASHORE_CITY
	warp_def $7, $3, 1, SEASHORE_CITY
	warp_def $0, $7, 1, BROWNS_HOUSE_F2

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_REDS_MOM, 3, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, BrownsHouseF1NPC1, -1
