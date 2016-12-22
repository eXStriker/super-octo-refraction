EagulouMart_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

EagulouMartNPC1:
	faceplayer
	opentext
	pokemart 0, 31
	closetext
	end

EagulouMartNPC2:
	jumptextfaceplayer EagulouMartNPC2_Text_330ffd

EagulouMartNPC2_Text_330ffd:
	ctxt "Everyone who lived"
	line "in the city moved"
	cont "out."

	para "Seems like they"
	line "didn't like a"

	para "prison opening up"
	line "here."
	done

EagulouMart_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $6, 5, EAGULOU_CITY
	warp_def $7, $7, 5, EAGULOU_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_CLERK, 3, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, EagulouMartNPC1, -1
	person_event SPRITE_SAGE, 5, 11, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, EagulouMartNPC2, -1
