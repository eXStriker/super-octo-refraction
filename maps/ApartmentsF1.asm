ApartmentsF1_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

ApartmentsF1_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $13, $8, 2, SPURGE_CITY
	warp_def $13, $9, 2, SPURGE_CITY
	warp_def $2, $3, 1, APARTMENTS_F2
	warp_def $2, $11, 2, APARTMENTS_F2

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 0
