RuinsRoof_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

RuinsRoofNPC1:
	opentext
	setevent EVENT_RAIWATO
	writetext RuinsRoofNPC1_Text_24f17a
	cry RAIWATO
	waitsfx
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadwildmon RAIWATO, 50
	startbattle
	reloadmapafterbattle
	dontrestartmapmusic
	reloadmap
	disappear 2
	end

RuinsRoofNPC1_Text_24f17a:
	ctxt "Zut zutt!"
	done

RuinsRoof_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def $8, $6, 2, RUINS_F5

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_P0, 4, 7, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, RuinsRoofNPC1, EVENT_RAIWATO
