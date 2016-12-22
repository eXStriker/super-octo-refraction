AcquaLabBasementPath_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw 5, .AcquaLabBasementPathWarpMod

.AcquaLabBasementPathWarpMod:
	writebyte 4

AcquaWarpMod:
	pushvar
	checkcode VAR_HOUR
	divideop 0, 6
	loadarray .TimeToTideArray
	popvar
	cmdwitharrayargs .CustomWarpModEnd - .CustomWarpMod
.CustomWarpMod:
	db warpmod_command, %10, -1, 0
.CustomWarpModEnd
	return
	
.TimeToTideArray:
	map ACQUA_LOWTIDE
.TimeToTideArrayEntrySizeEnd:
	map ACQUA_MEDTIDE
	map ACQUA_HITIDE
	map ACQUA_MEDTIDE

AcquaLabBasementPathNPC1:
	faceplayer
	setevent EVENT_ACQUA_POKEMON_GUARD
	cry RHYDON
	waitsfx
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_SHINY
	loadwildmon RHYDON, 50
	startbattle
	reloadmapafterbattle
	dontrestartmapmusic
	disappear 2
	end

AcquaLabBasementPath_MapEventHeader ;filler
	db 0, 0

;warps
	db 8
	warp_def $3, $5, 255, CAPER_CITY
	warp_def $5, $3, 3, ACQUA_LABBASEMENTPATH
	warp_def $5, $d, 2, ACQUA_LABBASEMENTPATH
	warp_def $3, $f, 5, ACQUA_LABBASEMENTPATH
	warp_def $3, $19, 4, ACQUA_LABBASEMENTPATH
	warp_def $5, $17, 7, ACQUA_LABBASEMENTPATH
	warp_def $d, $17, 6, ACQUA_LABBASEMENTPATH
	warp_def $b, $5, 6, PHLOX_LAB_B1F

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_RHYDON, 12, 5, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_SILVER, 0, 0, AcquaLabBasementPathNPC1, EVENT_ACQUA_POKEMON_GUARD
