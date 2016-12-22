PhloxTown_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 2

	dbw 5, PhloxTown_SetFlyFlag
	dbw MAPCALLBACK_TILES, PhloxLabDoor

PhloxTown_SetFlyFlag:
	setflag ENGINE_FLYPOINT_PHLOX_TOWN
	return

PhloxLabDoor:
	checkevent EVENT_PHLOX_LAB_UNLOCKED
	iffalse .notUnlocked
	changeblock 14, 4, $17
.notUnlocked
	return

PhloxTownSignpost1:
	ctxt "Bingo Hall"
	done ;51

PhloxTownSignpost2:
	ctxt "Acqua Mines"
	done ;52

PhloxTownSignpost3:
	ctxt "Algernon" ;53
	next "Laboratories"
	done

PhloxTownSignpost4:
	ctxt "The quiet"
	next "mountain ridge"
	done ;50

PhloxTownNPC1:
	jumptextfaceplayer PhloxTownNPC1_Text_1d297d

PhloxTownNPC2:
	jumptextfaceplayer PhloxTownNPC2_Text_1d28ef

PhloxTownNPC3:
	jumptextfaceplayer PhloxTownNPC3_Text_1d284e

PhloxTownNPC4:
	jumptextfaceplayer PhloxTownNPC4_Text_1d29b7

PhloxTownLabDoor:
	opentext
	checkevent EVENT_PHLOX_LAB_UNLOCKED
	iftrue .alreadyUnlocked
	checkitem LAB_CARD
	iftrue .haveLabCard
	jumptext PhloxTown_1d2bf7_Text_1d2c15

.alreadyUnlocked
	jumptext PhloxTown_DoorAlreadyUnlocked

.haveLabCard
	setevent EVENT_PHLOX_LAB_UNLOCKED
	playsound SFX_TRANSACTION
	writetext PhloxTownNPC5_Text_1d2bfd
	waitbutton
	closetext
	changeblock 14, 4, $17
	reloadmappart
	end

PhloxTown_1d2bf7:
	jumptext PhloxTown_1d2bf7_Text_1d2c15

PhloxTownNPC1_Text_1d297d:
	ctxt "It's always cold up"
	line "in these parts."

	para "Even during the"
	line "middle of summer."
	done

PhloxTownNPC2_Text_1d28ef:
	ctxt "We were totally"
	line "fine with living"
	cont "in seclusion."

	para "Why does everyone"
	line "want to put every-"
	cont "thing together?"

	para "Can't anything"
	line "ever just stand"
	cont "alone anymore?"
	done

PhloxTownNPC3_Text_1d284e:
	ctxt "That building was"
	line "built on my fav"
	cont "fishing spot!"

	para "They had a permit,"
	line "so I can't be too"
	cont "upset, I guess<...>"
	done

PhloxTownNPC4_Text_1d29b7:
	ctxt "There's a secluded"
	line "underground cave"
	cont "around here."

	para "Sometimes during"
	line "the day, it's"
	cont "totally flooded!"
	done

PhloxTownNPC5_Text_1d2bfd:
	ctxt "You unlocked the"
	line "door with the"
	cont "Lab Card!"
	done

PhloxTown_1d2bf7_Text_1d2c15:
	ctxt "The door is"
	line "locked."
	done

PhloxTown_DoorAlreadyUnlocked:
	ctxt "The door's already"
	line "unlocked."
	done

PhloxTown_MapEventHeader:: db 0, 0

.Warps: db 8
	warp_def 17, 13, 1, PHLOX_POKECENTER
	warp_def 23, 29, 1, PHLOX_MART
	warp_def 5, 14, 1, PHLOX_LAB_1F
	warp_def 27, 7, 2, PHLOX_ENTRY
	warp_def 23, 21, 1, PHLOX_BINGO
	warp_def 15, 21, 1, PHLOX_BARRY
	warp_def 9, 27, 2, ACQUA_PHLOXENTRANCE
	warp_def 7, 31, 1, CAPER_CITY

.CoordEvents: db 0

.BGEvents: db 5
	signpost 25, 19, SIGNPOST_LOAD, PhloxTownSignpost1
	signpost 9, 23, SIGNPOST_LOAD, PhloxTownSignpost2
	signpost 5, 11, SIGNPOST_LOAD, PhloxTownSignpost3
	signpost 29, 13, SIGNPOST_LOAD, PhloxTownSignpost4
	signpost 5, 14, SIGNPOST_READ, PhloxTownLabDoor

.ObjectEvents: db 4
	person_event SPRITE_COOLTRAINER_M, 13, 30, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, PhloxTownNPC1, -1
	person_event SPRITE_YOUNGSTER, 29, 19, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, PhloxTownNPC2, -1
	person_event SPRITE_FISHING_GURU, 6, 20, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, PhloxTownNPC3, -1
	person_event SPRITE_POKEFAN_F, 16, 5, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, PhloxTownNPC4, -1
