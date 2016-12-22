AcaniaLighthouseF1_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

AcaniaLighthouseF1_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $11, $8, 6, ACANIA_DOCKS
	warp_def $11, $9, 6, ACANIA_DOCKS
	warp_def $b, $9, 1, ACANIA_LIGHTHOUSE_F2

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 0
