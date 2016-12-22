Route80Unused_MapScriptHeader;trigger count
	db 0

 ;callback count
	db 0

Route80Unused_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def $0, $0, 1, INTRO_OUTSIDE

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 1, 1, SIGNPOST_READ, ObjectEvent

	;people-events
	db 1
	person_event SPRITE_P0, -3, -3, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 1, ObjectEvent, -1


Route80Unused_Script_1:
	db NO_ITEM, 0
