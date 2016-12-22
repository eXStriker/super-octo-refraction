HauntedForestGate_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

HauntedForestGateHiddenItem_1:
	dw EVENT_HAUNTED_FOREST_GATE_HIDDENITEM_RUBY_EGG
	db RUBY_EGG

HauntedForestGateNPC1:
	jumptextfaceplayer HauntedForestGateNPC1_Text_170ac2

HauntedForestGateNPC1_Text_170ac2:
	ctxt "Ghosts can change"
	line "their landscape,"
	cont "so enter at your"
	cont "own risk."
	done

HauntedForestGate_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $4, $0, 1, HAUNTED_FOREST
	warp_def $5, $0, 2, HAUNTED_FOREST
	warp_def $9, $4, 9, BOTAN_CITY
	warp_def $9, $5, 9, BOTAN_CITY

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 1, 9, SIGNPOST_ITEM, HauntedForestGateHiddenItem_1

	;people-events
	db 1
	person_event SPRITE_OFFICER, 3, 5, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 8 + PAL_OW_BROWN, 0, 0, HauntedForestGateNPC1, -1
