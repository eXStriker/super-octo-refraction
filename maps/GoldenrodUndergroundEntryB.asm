GoldenrodUndergroundEntryB_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

GoldenrodUndergroundEntryBNPC1:
	jumptextfaceplayer GoldenrodUndergroundEntryBNPC1_Text_327e7f

GoldenrodUndergroundEntryBNPC1_Text_327e7f:
	ctxt "Those Trainers"
	line "down there can"
	cont "be unruly."
	done

GoldenrodUndergroundEntryB_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $9, $4, 13, GOLDENROD_CITY
	warp_def $9, $5, 13, GOLDENROD_CITY
	warp_def $5, $5, 2, GOLDENROD_UNDERGROUND

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_COOLTRAINER_F, 7, 7, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_YELLOW, 0, 0, GoldenrodUndergroundEntryBNPC1, -1
