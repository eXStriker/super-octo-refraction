CastroTyrogueTrade_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

CastroTyrogueTradeNPC1:
	faceplayer
	opentext
	trade 2
	endtext

CastroTyrogueTrade_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 9, CASTRO_VALLEY
	warp_def $7, $3, 9, CASTRO_VALLEY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_LASS, 4, 2, SPRITEMOVEDATA_WALK_UP_DOWN, 1, 1, -1, -1, PAL_OW_GREEN, 0, 0, CastroTyrogueTradeNPC1, -1
