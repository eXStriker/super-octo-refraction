OwsauriMart_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

OwsauriMartNPC1:
	faceplayer
	opentext
	pokemart 0, 20
	closetext
	end

OwsauriMartNPC2:
	jumptextfaceplayer OwsauriMartNPC2_Text_333f1a

OwsauriMartNPC3:
	jumptextfaceplayer OwsauriMartNPC3_Text_333f47

OwsauriMartNPC2_Text_333f1a:
	ctxt "Lucky Punch only"
	line "works on one"
	cont "#mon!"
	done

OwsauriMartNPC3_Text_333f47:
	ctxt "Shiny Stones can"
	line "evolve certain"

	para "#mon, and be"
	line "used to make"
	cont "rings."
	done

OwsauriMart_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $6, 2, OWSAURI_CITY
	warp_def $7, $7, 2, OWSAURI_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_CLERK, 3, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, OwsauriMartNPC1, -1
	person_event SPRITE_BUENA, 6, 11, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, 0, 0, 0, OwsauriMartNPC2, -1
	person_event SPRITE_PHARMACIST, 2, 0, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, OwsauriMartNPC3, -1
