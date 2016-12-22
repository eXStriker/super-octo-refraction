AzaleaKurtBasement_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

AzaleaKurtBasementSignpost1:
	farjump BallMakingBasement

AzaleaKurtBasement_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $3, 3, AZALEA_KURT
	warp_def $7, $4, 3, AZALEA_KURT

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 2, 2, SIGNPOST_READ, AzaleaKurtBasementSignpost1

	;people-events
	db 0
