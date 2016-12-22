AcquaHiTide_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

AcquaHiTideHiddenItem_1:
	dw EVENT_ACQUA_HITIDE_HIDDENITEM_ICE_HEAL
	db ICE_HEAL

AcquaHiTide_MapEventHeader:: db 0, 0

.Warps: db 4
	warp_def 3, 15, 1, ACQUA_PHLOXENTRANCE
	warp_def 17, 23, 4, ACQUA_ROOM
	warp_def 2, 1, 1, CAPER_CITY
	warp_def 3, 19, 1, ACQUA_LABBASEMENTPATH

.CoordEvents: db 0

.BGEvents: db 1
	signpost 29, 30, SIGNPOST_ITEM, AcquaHiTideHiddenItem_1

.ObjectEvents: db 0

