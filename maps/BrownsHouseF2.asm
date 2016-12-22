BrownsHouseF2_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

BrownsHouseF2Signpost1:
	jumptext BrownsHouseF2Signpost1_Text_330d6b

BrownsHouseF2Signpost1_Text_330d6b:
	ctxt "It's a dusty"
	line "Nintendo 64."
	done

BrownsHouseF2_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def $0, $7, 3, BROWNS_HOUSE_F1

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 5, 3, SIGNPOST_READ, BrownsHouseF2Signpost1

	;people-events
	db 0
