SaxifrageEastExit_MapScriptHeader;trigger count
	db 0

 ;callback count
	db 0

SaxifrageEastExit_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $d, $5, 2, SAXIFRAGE_ISLAND
	warp_def $d, $4, 2, SAXIFRAGE_ISLAND

	db 0, 0, 0, 0, 0