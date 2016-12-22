SilphWarehouseF2_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SilphWarehouseF2NPC1:
	jumptextfaceplayer SilphWarehouseF2NPC1_Text_323e9f

SilphWarehouseF2NPC1_Text_323e9f:
	ctxt "I'm Starting With"
	line "The Man In The"
	cont "Mirror!"
	done

SilphWarehouseF2_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def $6, $3, 1, SILPH_WAREHOUSE_F1

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_SWIMMER_GUY, 3, 3, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_PLAYER, 0, 0, SilphWarehouseF2NPC1, -1
