MersonHouse2_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MersonHouse2NPC1:
	jumptextfaceplayer MersonHouse2NPC1_Text_3223a0

MersonHouse2NPC1_Text_3223a0:
	ctxt "Who said you"
	line "could come in?"

	para "SCRAM!"
	done

MersonHouse2_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 6, MERSON_CITY
	warp_def $7, $3, 6, MERSON_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_GRAMPS, 3, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MersonHouse2NPC1, -1
