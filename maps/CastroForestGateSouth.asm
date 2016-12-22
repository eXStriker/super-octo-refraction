CastroForestGateSouth_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

CastroForestGateSouth_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $0, $5, 4, CASTRO_FOREST
	warp_def $7, $4, 4, ROUTE_57
	warp_def $7, $5, 4, ROUTE_57

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 0
