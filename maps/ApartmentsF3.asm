ApartmentsF3_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

ApartmentsF3Signpost1:
	jumptext ApartmentsF3Signpost1_Text_3202a7

ApartmentsF3Signpost2:
	jumptext ApartmentsF3Signpost2_Text_320280

ApartmentsF3Signpost3:
	jumptext ApartmentsF3Signpost3_Text_32028d

ApartmentsF3Signpost4:
	jumptext ApartmentsF3Signpost4_Text_32029a

ApartmentsF3NPC1:
	jumptext ApartmentsF3NPC1_Text_320380

ApartmentsF3NPC2:
	jumptext ApartmentsF3NPC1_Text_320380

ApartmentsF3NPC3:
	jumptext ApartmentsF3NPC1_Text_320380

ApartmentsF3Signpost1_Text_3202a7:
	ctxt "2-A"
	done

ApartmentsF3Signpost2_Text_320280:
	ctxt "2-B"
	done

ApartmentsF3Signpost3_Text_32028d:
	ctxt "2-C"
	done

ApartmentsF3Signpost4_Text_32029a:
	ctxt "2-D"
	done

ApartmentsF3NPC1_Text_320380:
	ctxt "The door is"
	line "locked."
	done

ApartmentsF3_MapEventHeader:: db 0, 0

.Warps: db 6
	warp_def 12, 1, 3, APARTMENTS_F2
	warp_def 12, 17, 4, APARTMENTS_F2
	warp_def 4, 3, 1, CAPER_CITY
	warp_def 0, 9, 1, APARTMENTS_2D
	warp_def 4, 17, 1, CAPER_CITY
	warp_def 12, 9, 1, CAPER_CITY

.CoordEvents: db 0

.BGEvents: db 4
	signpost 4, 2, SIGNPOST_READ, ApartmentsF3Signpost1
	signpost 12, 8, SIGNPOST_READ, ApartmentsF3Signpost2
	signpost 4, 16, SIGNPOST_READ, ApartmentsF3Signpost3
	signpost 0, 8, SIGNPOST_READ, ApartmentsF3Signpost4

.ObjectEvents: db 0
