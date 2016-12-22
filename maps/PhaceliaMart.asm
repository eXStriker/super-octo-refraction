PhaceliaMart_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

PhaceliaMartNPC1:
	jumptextfaceplayer PhaceliaMartNPC1_Text_2f76ca

PhaceliaMartNPC2:
	faceplayer
	opentext
	pokemart 0, 9
	closetext
	end

PhaceliaMartNPC3:
	jumptextfaceplayer PhaceliaMartNPC3_Text_2f777f

PhaceliaMartNPC1_Text_2f76ca:
	ctxt "Why do we need"
	line "all of these"
	cont "cities?"

	para "I enjoy the calm"
	line "country side."

	para "An old man like"
	line "me can't take"
	cont "any more stress"
	cont "in his life, but"
	cont "the construction"
	cont "sounds keep"
	cont "waking me up."
	done

PhaceliaMartNPC3_Text_2f777f:
	ctxt "Andre is a beast!"

	para "He opened a gym"
	line "here before they"
	cont "started building"
	cont "the city."

	para "A gym in a cave,"
	line "imagine that?"
	done

PhaceliaMart_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $6, 5, PHACELIA_TOWN
	warp_def $7, $7, 5, PHACELIA_TOWN

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_GRAMPS, 6, 11, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PhaceliaMartNPC1, -1
	person_event SPRITE_CLERK, 3, 6, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PhaceliaMartNPC2, -1
	person_event SPRITE_BLACK_BELT, 2, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PhaceliaMartNPC3, -1
