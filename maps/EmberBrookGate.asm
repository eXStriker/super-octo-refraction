EmberBrookGate_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

EmberBrookGateNPC1:
	jumptextfaceplayer EmberBrookGateNPC1_Text_2f9e96

EmberBrookGateNPC1_Text_2f9e96:
	ctxt "Eastward is Mt."
	line "Ember."

	para "Its structure"
	line "often changes"

	para "due to its many"
	line "eruptions."
	done

EmberBrookGate_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $4, $0, 6, ROUTE_67
	warp_def $5, $0, 7, ROUTE_67
	warp_def $4, $9, 1, EMBER_BROOK
	warp_def $5, $9, 2, EMBER_BROOK

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_OFFICER, 2, 4, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, EmberBrookGateNPC1, -1
