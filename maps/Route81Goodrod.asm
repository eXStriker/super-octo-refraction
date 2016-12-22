Route81Goodrod_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route81GoodrodNPC1:
	faceplayer
	opentext
	checkevent EVENT_ROUTE_81_GOODROD
	iftrue Route81Goodrod_2f7d45
	giveitem GOOD_ROD, 1
	iffalse Route81Goodrod_2f7d4b
	writetext Route81GoodrodNPC1_Text_2f7d51
	playwaitsfx SFX_ITEM
	itemnotify
	setevent EVENT_ROUTE_81_GOODROD
	endtext

Route81Goodrod_2f7d45:
	writetext Route81Goodrod_2f7d45_Text_2f7dbc
	endtext

Route81Goodrod_2f7d4b:
	writetext Route81Goodrod_2f7d4b_Text_2f7e14
	endtext

Route81GoodrodNPC1_Text_2f7d51:
	ctxt "Hi!"

	para "I'm the Fishing"
	line "Guru's<...> uhm."

	para "We'll, I'm related"
	line "to him somehow."

	para "Anyway, I have a"
	line "good rod called"
	cont "Good Rod for you."

	para "Enjoy!"
	done

Route81Goodrod_2f7d45_Text_2f7dbc:
	ctxt "The Good Rod is a"
	line "lot better than"
	cont "that Old Rod."

	para "Hook and catch"
	line "some real big"
	cont "#mon for me!"
	done

Route81Goodrod_2f7d4b_Text_2f7e14:
	ctxt "Free some space!"
	done

Route81Goodrod_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 7, ROUTE_81
	warp_def $7, $3, 7, ROUTE_81

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_FISHING_GURU, 3, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, Route81GoodrodNPC1, -1
