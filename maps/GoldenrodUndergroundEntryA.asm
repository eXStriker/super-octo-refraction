GoldenrodUndergroundEntryA_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

GoldenrodUndergroundEntryANPC1:
	jumptextfaceplayer GoldenrodUndergroundEntryANPC1_Text_327eb1

GoldenrodUndergroundEntryANPC1_Text_327eb1:
	ctxt "Be careful"
	line "downstairs."
	done

GoldenrodUndergroundEntryA_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $9, $4, 12, GOLDENROD_CITY
	warp_def $9, $5, 12, GOLDENROD_CITY
	warp_def $5, $5, 1, GOLDENROD_UNDERGROUND

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_SUPER_NERD, 7, 3, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, GoldenrodUndergroundEntryANPC1, -1
