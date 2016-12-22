EagulouGymF1_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

EagulouGymF1_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $d, $a, 2, EAGULOU_CITY
	warp_def $b, $11, 1, EAGULOU_GYM_B1F

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 0
