SeashoreMura_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SeashoreMuraNPC1:
	faceplayer
	opentext
	writetext SeashoreMuraNPC1_Text_321b67
	cry FEAROW
	waitsfx
	endtext

SeashoreMuraNPC2:
	jumptextfaceplayer SeashoreMuraNPC2_Text_321b14

SeashoreMuraNPC3:
	jumptextfaceplayer SeashoreMuraNPC3_Text_321a65

SeashoreMuraNPC1_Text_321b67:
	ctxt "Fearry: Feero!"
	done

SeashoreMuraNPC2_Text_321b14:
	ctxt "My dad puts extra"
	line "pressure on me to"

	para "make sure I turn"
	line "out all right."
	done

SeashoreMuraNPC3_Text_321a65:
	ctxt "I hope my boy Mura"
	line "is doing OK."

	para "He's part of the"
	line "Rijon League now."
	done

SeashoreMura_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 4, SEASHORE_CITY
	warp_def $7, $3, 4, SEASHORE_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_FEAROW, 2, 6, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SeashoreMuraNPC1, -1
	person_event SPRITE_LASS, 3, 0, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SeashoreMuraNPC2, -1
	person_event SPRITE_FISHING_GURU, 4, 5, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SeashoreMuraNPC3, -1
