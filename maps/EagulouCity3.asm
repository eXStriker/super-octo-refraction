EagulouCity3_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

EagulouCity3_MapEventHeader ;filler
	db 0, 0

;warps
	db 6
	warp_def $19, $2, 1, EAGULOU_PARK_GATE
	warp_def $19, $3, 2, EAGULOU_PARK_GATE
	warp_def $0, $e, 5, EAGULOU_CITY_2
	warp_def $0, $f, 6, EAGULOU_CITY_2
	warp_def $a, $1d, 3, EAGULOU_PARK_1
	warp_def $b, $1d, 4, EAGULOU_PARK_1

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 0
