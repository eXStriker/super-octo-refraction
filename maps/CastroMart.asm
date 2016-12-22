CastroMart_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

CastroMartNPC1:
	faceplayer
	opentext
	pokemart 0, 30
	closetext
	end

CastroMartNPC2:
	jumptextfaceplayer CastroMartNPC2_Text_330771

CastroMartNPC3:
	jumptextfaceplayer CastroMartNPC3_Text_33017d

CastroMartNPC2_Text_330771:
	ctxt "Ether restores"
	line "the PP of one of"
	cont "your moves."
	done

CastroMartNPC3_Text_33017d:
	ctxt "Safe Goggles will"
	line "prevent your"
	para "#mon from"
	line "being hurt by"
	cont "weather effects."
	done

CastroMart_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $6, 3, CASTRO_VALLEY
	warp_def $7, $7, 3, CASTRO_VALLEY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_CLERK, 3, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, CastroMartNPC1, -1
	person_event SPRITE_SCIENTIST, 2, 1, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, CastroMartNPC2, -1
	person_event SPRITE_GRANNY, 6, 12, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, CastroMartNPC3, -1
