GoldenrodStorage_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

GoldenrodStorage_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $b, $2, 2, GOLDENROD_SWITCHES
	warp_def $b, $3, 3, GOLDENROD_SWITCHES
	warp_def $2, $11, 1, GOLDENROD_MART_B1F

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 0
