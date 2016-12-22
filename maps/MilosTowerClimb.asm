MilosTowerClimb_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MilosTowerClimb_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $5, $5, 1, MILOS_GREEN_ORB
	warp_def $2c, $5, 2, MILOS_F1

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 0
