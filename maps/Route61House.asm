Route61House_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0
	
Route61HouseTradeMan:
	faceplayer
	opentext
	trade 5
	endtext

Route61House_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 4, ROUTE_61
	warp_def $7, $3, 4, ROUTE_61

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_ROCKER, 5, 6, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 0, -1, -1, 0, 0, 0, Route61HouseTradeMan, -1
