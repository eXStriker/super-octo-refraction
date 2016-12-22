ApartmentsF2_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

ApartmentsF2Signpost1:
	jumptext ApartmentsF2Signpost1_Text_3201f7

ApartmentsF2Signpost2:
	jumptext ApartmentsF2Signpost2_Text_320204

ApartmentsF2Signpost3:
	jumptext ApartmentsF2Signpost3_Text_320211

ApartmentsF2Signpost4:
	jumptext ApartmentsF2Signpost4_Text_32021e

ApartmentsF2NPC1:
	jumptext ApartmentsF2NPC1_Text_320380

ApartmentsF2NPC2:
	jumptext ApartmentsF2NPC1_Text_320380

ApartmentsF2Signpost1_Text_3201f7:
	ctxt "1-A"
	done

ApartmentsF2Signpost2_Text_320204:
	ctxt "1-B"
	done

ApartmentsF2Signpost3_Text_320211:
	ctxt "1-C"
	done

ApartmentsF2Signpost4_Text_32021e:
	ctxt "1-D"
	done

ApartmentsF2NPC1_Text_320380:
	ctxt "The door is"
	line "locked."
	done

ApartmentsF2_MapEventHeader:: db 0, 0

.Warps: db 8
	warp_def 5, 2, 3, APARTMENTS_F1
	warp_def 5, 18, 4, APARTMENTS_F1
	warp_def 18, 1, 1, APARTMENTS_F3
	warp_def 18, 19, 2, APARTMENTS_F3
	warp_def 2, 4, 1, CAPER_CITY
	warp_def 2, 14, 1, APARTMENTS_1B
	warp_def 16, 6, 1, APARTMENTS_1C
	warp_def 16, 12, 1, CAPER_CITY

.CoordEvents: db 0

.BGEvents: db 4
	signpost 2, 5, SIGNPOST_READ, ApartmentsF2Signpost1
	signpost 2, 15, SIGNPOST_READ, ApartmentsF2Signpost2
	signpost 16, 7, SIGNPOST_READ, ApartmentsF2Signpost3
	signpost 16, 13, SIGNPOST_READ, ApartmentsF2Signpost4

.ObjectEvents: db 0
