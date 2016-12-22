MoragaMart_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MoragaMartNPC1:
	faceplayer
	opentext
	pokemart 0, 21
	closetext
	end

MoragaMartNPC2:
	jumptextfaceplayer MoragaMartNPC2_Text_333fd9

MoragaMartNPC2_Text_333fd9:
	ctxt "They sell Leaf"
	line "stones here."

	para "They're super cheap"
	line "too!"
	done

MoragaMart_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $6, 11, MORAGA_TOWN
	warp_def $7, $7, 11, MORAGA_TOWN

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_CLERK, 3, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MoragaMartNPC1, -1
	person_event SPRITE_PHARMACIST, 4, 10, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MoragaMartNPC2, -1
