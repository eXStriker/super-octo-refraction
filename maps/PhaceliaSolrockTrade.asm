PhaceliaSolrockTrade_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

PhaceliaSolrockTradeNPC1:
	faceplayer
	opentext
	trade 3
	endtext

PhaceliaSolrockTrade_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 9, PHACELIA_TOWN
	warp_def $7, $3, 9, PHACELIA_TOWN

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_TEACHER, 3, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, PhaceliaSolrockTradeNPC1, -1
