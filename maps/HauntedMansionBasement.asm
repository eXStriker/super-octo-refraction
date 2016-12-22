HauntedMansionBasement_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw MAPCALLBACK_TILES, HauntedMansionBasementDoors

HauntedMansionBasementDoors:
	checkevent EVENT_HAUNTED_MANSION_BASEMENT_DOOR_1
	iffalse .skipDoor1
	changeblock 4, 6, $18
.skipDoor1
	checkevent EVENT_HAUNTED_MANSION_BASEMENT_DOOR_2
	iffalse .skipDoor2
	changeblock 8, 14, $18
.skipDoor2
	checkevent EVENT_HAUNTED_MANSION_BASEMENT_DOOR_3
	iffalse .skipDoor3
	changeblock 14, 12, $18
.skipDoor3
	checkevent EVENT_PHANCERO
	iftrue .end
	changeblock 12, 10, $7f
.end
	return

HauntedMansionBasementSignpost1:
	checkevent EVENT_HAUNTED_MANSION_BASEMENT_DOOR_1
	iftrue HauntedMansionBasement_2f60ec
	opentext
	checkitem CAGE_KEY
	iffalse HauntedMansionBasement_2f609d
	writetext HauntedMansionBasementSignpost1_Text_2f60a3
	waitbutton
	takeitem CAGE_KEY, 1
	playsound SFX_ENTER_DOOR
	changeblock 4, 6, $18
	reloadmappart
	setevent EVENT_HAUNTED_MANSION_BASEMENT_DOOR_1
	closetext
	end

HauntedMansionBasementSignpost2:
	checkevent EVENT_HAUNTED_MANSION_BASEMENT_DOOR_2
	iftrue HauntedMansionBasement_2f60ec
	opentext
	checkitem CAGE_KEY
	iffalse HauntedMansionBasement_2f609d
	writetext HauntedMansionBasementSignpost1_Text_2f60a3
	waitbutton
	takeitem CAGE_KEY, 1
	playsound SFX_ENTER_DOOR
	changeblock 8, 14, $18
	reloadmappart
	setevent EVENT_HAUNTED_MANSION_BASEMENT_DOOR_2
	closetext
	end

HauntedMansionBasementSignpost3:
	checkevent EVENT_HAUNTED_MANSION_BASEMENT_DOOR_3
	iftrue HauntedMansionBasement_2f60ec
	opentext
	checkitem CAGE_KEY
	iffalse HauntedMansionBasement_2f609d
	writetext HauntedMansionBasementSignpost1_Text_2f60a3
	waitbutton
	takeitem CAGE_KEY, 1
	playsound SFX_ENTER_DOOR
	changeblock 14, 12, $18
	reloadmappart
	setevent EVENT_HAUNTED_MANSION_BASEMENT_DOOR_3
	closetext
	end

HauntedMansionBasement_Item_1:
	db CLEANSE_TAG, 1

HauntedMansionBasementNPC2:
	jumpstd smashrock

HauntedMansionBasementPhanceroBoulder:
	callasm HasRockSmash
	sif =, 1
		jumptext HauntedBasementNoRockSmash
	opentext
	writetext HauntedBasementAskRockSmash
	yesorno
	iftrue HauntedBasementActivateRockSmash
	closetext
	end

HauntedBasementActivateRockSmash:
	setevent EVENT_PHANCERO_BOULDER
	farjump RockSmashScript

HauntedBasementNoRockSmash:
	text_jump UnknownText_0x1c0906

HauntedBasementAskRockSmash:
	text_jump UnknownText_0x1c0924

HauntedMansionBasement_2f609d:
	jumptext HauntedMansionBasement_2f609d_Text_2f60b7

HauntedMansionBasement_2f60ec:
	end

HauntedMansionBasementSignpost1_Text_2f60a3:
	ctxt "Unlocked the"
	line "door!"
	done

HauntedMansionBasement_2f609d_Text_2f60b7:
	ctxt "The door is"
	line "locked."
	done

PhanceroPortal:
	checkevent EVENT_PHANCERO
	iftrue .noEntry
	playsound SFX_WARP_TO
	applymovement 0, PhanceroWarpMovement
	warp PHANCERO_ROOM, 85, 11
	playsound SFX_WARP_FROM
	applymovement 0, PhanceroWarpEntry
.noEntry
	end

PhanceroWarpMovement:
	teleport_from
	step_end

PhanceroWarpEntry:
	teleport_to
	step_end

HauntedMansionBasement_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def $a, $7, 24, HAUNTED_MANSION

	;xy triggers
	db 1
	xy_trigger 0, 10, 12, $0, PhanceroPortal, $0, $0

	;signposts
	db 3
	signpost 7, 5, SIGNPOST_READ, HauntedMansionBasementSignpost1
	signpost 15, 9, SIGNPOST_READ, HauntedMansionBasementSignpost2
	signpost 13, 15, SIGNPOST_READ, HauntedMansionBasementSignpost3

	;people-events
	db 7
	person_event SPRITE_POKE_BALL, 10, 16, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_SILVER, 3, TM_SHADOW_CLAW, 0, EVENT_HAUNTED_MANSION_BASEMENT_NPC_1
	person_event SPRITE_POKE_BALL, 3, 4, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_GREEN, 1, 0, HauntedMansionBasement_Item_1, EVENT_HAUNTED_MANSION_BASEMENT_ITEM_1
	person_event SPRITE_ROCK, 6, 5, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, HauntedMansionBasementNPC2, -1
	person_event SPRITE_ROCK, 17, 5, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, HauntedMansionBasementNPC2, -1
	person_event SPRITE_ROCK, 10, 12, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, HauntedMansionBasementPhanceroBoulder, EVENT_PHANCERO_BOULDER
	person_event SPRITE_ROCK, 15, 13, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, HauntedMansionBasementNPC2, -1
	person_event SPRITE_ROCK, 11, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, HauntedMansionBasementNPC2, -1
