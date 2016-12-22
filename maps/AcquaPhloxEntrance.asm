AcquaPhloxEntrance_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw 5, .AcquaPhloxWarpMod

.AcquaPhloxWarpMod:
	writebyte 1
	farjump AcquaWarpMod

AcquaPhloxEntrance_MapEventHeader:: db 0, 0

.Warps: db 2
	warp_def 3, 5, 255, CAPER_CITY
	warp_def 5, 5, 7, PHLOX_TOWN

.CoordEvents: db 0

.BGEvents: db 0

.ObjectEvents: db 0

