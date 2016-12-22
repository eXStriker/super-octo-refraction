HeathHouseTM13_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

HeathHouseTM13Signpost1:
	jumpstd difficultbookshelf

HeathHouseTM13NPC1:
	faceplayer
	opentext
	checkevent EVENT_GET_TM13
	iftrue HeathHouseTM13_14d518
	writetext HeathHouseTM13NPC1_Text_14d521
	buttonsound
	givetm 35 + RECEIVED_TM
	opentext
	setevent EVENT_GET_TM13
	jumptext HeathHouseTM13NPC1_Text_14d5b4

HeathHouseTM13_14d518:
	jumptext HeathHouseTM13_14d518_Text_14d649

HeathHouseTM13NPC1_Text_14d521:
	ctxt "zzz<...>"

	para "Wha?"

	para "Oh, I've been"
	line "dozing off for"
	cont "too long!"

	para "As an apology,"
	line "take this TM."
	done

HeathHouseTM13NPC1_Text_14d5b4:
	ctxt "This TM is"
	line "Sleep Talk."

	para "Your #mon will"
	line "use a random"
	para "attack while"
	line "it's sleeping!"
	done

HeathHouseTM13_14d518_Text_14d649:
	ctxt "zzz<...>"
	done

HeathHouseTM13_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $3, 4, HEATH_VILLAGE
	warp_def $7, $4, 4, HEATH_VILLAGE

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 11, 10, SIGNPOST_READ, HeathHouseTM13Signpost1
	signpost 10, 11, SIGNPOST_READ, HeathHouseTM13Signpost1

	;people-events
	db 1
	person_event SPRITE_FISHER, 3, 2, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 0, 0, HeathHouseTM13NPC1, -1
