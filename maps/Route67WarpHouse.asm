Route67WarpHouse_MapScriptHeader;trigger count
	db 0

 ;callback count
	db 0

Route67WarpHouse_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $9, $4, 5, ROUTE_67
	warp_def $9, $5, 5, ROUTE_67
	warp_def $5, $5, 2, NALJO_BORDER_WARPROOM

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 0
