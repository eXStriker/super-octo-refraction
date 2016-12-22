GoldenrodCapeGate_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

GoldenrodCapeGateNPC1:
	jumptextfaceplayer GoldenrodCapeGateNPC1_Text_322f60

GoldenrodCapeGateNPC1_Text_322f60:
	ctxt "I hope you enjoy"
	line "the view!"
	done

GoldenrodCapeGate_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $4, $0, 1, GOLDENROD_CAPE
	warp_def $5, $0, 2, GOLDENROD_CAPE
	warp_def $4, $9, 6, GOLDENROD_CITY
	warp_def $5, $9, 7, GOLDENROD_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_OFFICER, 2, 4, SPRITEMOVEDATA_00, 0, 0, -1, -1, 0, 0, 0, GoldenrodCapeGateNPC1, -1
