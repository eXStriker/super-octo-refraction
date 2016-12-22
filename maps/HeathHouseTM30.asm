HeathHouseTM30_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

HeathHouseTM30NPC1:
	faceplayer
	opentext
	checkevent EVENT_GET_TM30
	iftrue HeathHouseTM30_15d9f6
	writetext HeathHouseTM30NPC1_Text_15d9fc
	waitbutton
	givetm 30 + RECEIVED_TM
	setevent EVENT_GET_TM30
	closetext
	end

HeathHouseTM30_15d9f6:
	jumptext HeathHouseTM30_15d9f6_Text_15da71

HeathHouseTM30NPC1_Text_15d9fc:
	ctxt "You are quite the"
	line "young swimmer."

	para "I have already"
	line "used this item"
	para "on all of my"
	line "ghost #mon,"
	para "let me pass it"
	line "down to you!"
	done

HeathHouseTM30_15d9f6_Text_15da71:
	ctxt "TM30 is Shadow"
	line "Ball."

	para "It's a powerful"
	line "ghost attack"
	para "that can even"
	line "lower your foe's"
	cont "special defense!"
	done

HeathHouseTM30_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $3, 3, HEATH_VILLAGE
	warp_def $7, $4, 3, HEATH_VILLAGE

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_GRANNY, 3, 2, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, HeathHouseTM30NPC1, -1
