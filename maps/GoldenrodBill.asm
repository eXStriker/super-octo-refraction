GoldenrodBill_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

GoldenrodBillNPC1:
	jumptextfaceplayer GoldenrodBillNPC1_Text_2f407b

GoldenrodBillNPC2:
	jumptextfaceplayer GoldenrodBillNPC2_Text_2f40e9

GoldenrodBillNPC1_Text_2f407b:
	ctxt "My brother Bill"
	line "made the PC"
	cont "#mon storage"
	cont "system."
	done

GoldenrodBillNPC2_Text_2f40e9:
	ctxt "I'm so proud of"
	line "my son."
	done

GoldenrodBill_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 4, GOLDENROD_CITY
	warp_def $7, $3, 4, GOLDENROD_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_LASS, 4, 5, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, GoldenrodBillNPC1, -1
	person_event SPRITE_POKEFAN_F, 3, 2, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, GoldenrodBillNPC2, -1
