IlexForestGate_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

IlexForestGateNPC1:
	jumptextfaceplayer IlexForestGateNPC1_Text_323046

IlexForestGateNPC1_Text_323046:
	ctxt "Ilex Forest is"
	line "big. Be careful!"

	para "You've seen worse?"

	para "You've made me"
	line "curious."

	para "Now I want to"
	line "visit the Naljo"
	cont "region."
	done

IlexForestGate_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $4, $0, 2, ILEX_FOREST
	warp_def $5, $0, 3, ILEX_FOREST
	warp_def $4, $9, 1, AZALEA_TOWN
	warp_def $5, $9, 2, AZALEA_TOWN

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_OFFICER, 2, 5, SPRITEMOVEDATA_00, 0, 0, -1, -1, 0, 0, 0, IlexForestGateNPC1, -1
