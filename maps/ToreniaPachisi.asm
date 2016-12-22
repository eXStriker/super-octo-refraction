ToreniaPachisi_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

ToreniaPachisiNPC1:
	farjump PachisiGameTorenia

ToreniaPachisiNPC2:
	jumptextfaceplayer ToreniaPachisiNPC2_Text_155a64

ToreniaPachisiNPC2_Text_155a64:
	ctxt "This game is just"
	line "about pure luck<...>"

	para "Which is why I"
	line "always lose at"
	cont "this, naturally."

	para "Nope, no pity for"
	line "an old man<...>"
	done

ToreniaPachisi_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $1d, $10, 6, TORENIA_CITY
	warp_def $1d, $11, 6, TORENIA_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_OFFICER, 26, 17, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 0, 0, ToreniaPachisiNPC1, -1
	person_event SPRITE_GRAMPS, 12, 18, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, 8 + PAL_OW_BROWN, 0, 0, ToreniaPachisiNPC2, -1
