PrisonElectricChair_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw MAPCALLBACK_TILES, SetPrisonElectricBlocks

SetPrisonElectricBlocks:
	scall PrisonElectricDoor
	return

PrisonElectricDoor:
	checkevent EVENT_PRISON_ELECTRIC_CHAIR_POKEMON_1
	iffalse .no
	checkevent EVENT_PRISON_ELECTRIC_CHAIR_POKEMON_2
	iffalse .no
	checkevent EVENT_PRISON_ELECTRIC_CHAIR_POKEMON_3
	iffalse .no
	changeblock 8, 0, $5b
.no
	end

PrisonElectricDoorSign:
	checkevent EVENT_PRISON_ELECTRIC_CHAIR_POKEMON_1
	iffalse PrisonElectricChair_254a92
	checkevent EVENT_PRISON_ELECTRIC_CHAIR_POKEMON_2
	iffalse PrisonElectricChair_254a92
	checkevent EVENT_PRISON_ELECTRIC_CHAIR_POKEMON_3
	sif false
PrisonElectricChair_254a92:
		jumptext PrisonElectricChair_254a92_Text_254ac0
	end

PrisonElectricChairNPC2:
	faceplayer
	cry FLAAFFY
	waitsfx
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_TRAP
	loadwildmon FLAAFFY, 30
	startbattle
	reloadmapafterbattle
	disappear 2
	setevent EVENT_PRISON_ELECTRIC_CHAIR_POKEMON_3
	jump PrisonElectricDoor

PrisonElectricChairNPC3:
	faceplayer
	cry RAICHU
	waitsfx
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_TRAP
	loadwildmon RAICHU, 30
	startbattle
	reloadmapafterbattle
	disappear 3
	setevent EVENT_PRISON_ELECTRIC_CHAIR_POKEMON_2
	jump PrisonElectricDoor

PrisonElectricChairNPC4:
	faceplayer
	cry ELECTABUZZ
	waitsfx
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_TRAP
	loadwildmon ELECTABUZZ, 30
	startbattle
	reloadmapafterbattle
	disappear 4
	setevent EVENT_PRISON_ELECTRIC_CHAIR_POKEMON_1
	jump PrisonElectricDoor
	
PrisonElectricChair_254a92_Text_254ac0:
	ctxt "Electricity is"
	line "being fed into"
	cont "the door."

	para "Perhaps that's"
	line "what's keeping"
	cont "it locked?"
	done

PrisonElectricChair_MapEventHeader:: db 0, 0

.Warps: db 3
	warp_def 14, 19, 3, PRISON_F2
	warp_def 15, 19, 4, PRISON_F2
	warp_def 1, 9, 1, PRISON_CONTAINMENT

.CoordEvents: db 0

.BGEvents: db 1
	signpost 1, 9, SIGNPOST_READ, PrisonElectricDoorSign

.ObjectEvents: db 3
	person_event SPRITE_FLAAFFY, 9, 16, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PrisonElectricChairNPC2, EVENT_PRISON_ELECTRIC_CHAIR_POKEMON_3
	person_event SPRITE_RAICHU, 5, 9, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PrisonElectricChairNPC3, EVENT_PRISON_ELECTRIC_CHAIR_POKEMON_2
	person_event SPRITE_ELECTABUZZ, 9, 3, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, PrisonElectricChairNPC4, EVENT_PRISON_ELECTRIC_CHAIR_POKEMON_1

