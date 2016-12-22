SilphWarehouseF1_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SilphWarehouseF1NPC1:
	jumptextfaceplayer SilphWarehouseF1NPC1_Text_32186c

SilphWarehouseF1NPC1_Text_32186c:
	ctxt "Sorry, you're not"
	line "allowed up any"

	para "further unless"
	line "you're a Silph"
	cont "employee."

	para "There isn't"
	line "anything up there"
	cont "of interest."
	done

SilphWarehouseF1_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $11, $8, 1, ROUTE_59
	warp_def $11, $9, 1, ROUTE_59
	warp_def $a, $1b, 1, SILPH_WAREHOUSE_B1F
	warp_def $0, $1b, 1, SILPH_WAREHOUSE_F2

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_OFFICER, 1, 27, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SilphWarehouseF1NPC1, -1
