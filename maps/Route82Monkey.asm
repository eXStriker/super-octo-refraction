Route82Monkey_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route82MonkeyNPC1:
	opentext
	writetext Route82MonkeyNPC1_Text_2f9a7b
	cry FAMBACO
	waitsfx
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadwildmon FAMBACO, 50
	startbattle
	reloadmapafterbattle
	setevent EVENT_FAMBACO
	disappear 2
	end

Route82MonkeyNPC1_Text_2f9a7b:
	text "<...>"
	done

Route82Monkey_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def $9, $7, 3, ROUTE_82

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_FAMBACO, 5, 5, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_RED, 0, 0, Route82MonkeyNPC1, EVENT_FAMBACO
