HeathGymHouse_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

HeathGymHouse_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $9, $3, 2, HEATH_GYM
	warp_def $9, $4, 2, HEATH_GYM
	warp_def $5, $7, 2, HEATH_GYM_UNDERGROUND

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 0
	