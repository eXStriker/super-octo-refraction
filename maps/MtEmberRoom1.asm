MtEmberRoom1_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0
	
MtEmberRoomNPC:
	jumptextfaceplayer MtEmberRoomNPCText
	
MtEmberRoomNPCText:
	ctxt "Oh<...> hello!"
	
	para "I'm trying to get"
	line "to Kindle Road."
	
	para "This rock is very"
	line "hard though."

	para "In a future update"
	line "you'll be able to"
	
	para "travel to Kindle"
	line "Road and other"
	cont "places!"
	done

MtEmberRoom1_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $10, $c, 2, MT_EMBER_ENTRANCE
	warp_def $2, $c, 1, CAPER_CITY
	warp_def $11, $2, 1, MT_EMBER
	warp_def $11, $3, 1, MT_EMBER

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_MINER, 5, 11, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MtEmberRoomNPC, EVENT_MOLTRES
