CastroGate_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

CastroGate_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $0, $5, 1, CASTRO_FOREST
	warp_def $7, $4, 4, CASTRO_VALLEY
	warp_def $7, $5, 4, CASTRO_VALLEY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 0
