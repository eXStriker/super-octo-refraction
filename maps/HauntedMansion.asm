HauntedMansion_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

HauntedMansionChestKey1:
	opentext
	writetext HauntedMansion_Text_PlayerOpenedChest
	waitbutton
	checkevent EVENT_GOT_BEDROOM_KEY_1
	iffalse HauntedMansion_GetKey1
	jumptext HauntedMansion_Text_ChestIsEmpty

HauntedMansionChestKey2:
	opentext
	writetext HauntedMansion_Text_PlayerOpenedChest
	waitbutton
	checkevent EVENT_GOT_BEDROOM_KEY_2
	iffalse HauntedMansion_GetKey2
	jumptext HauntedMansion_Text_ChestIsEmpty

HauntedMansionMansionDoor:
	checkitem MANSION_KEY
	iftrue HauntedMansion_OpenMansionDoor
MansionBedroomNoKeys:
	jumptext HauntedMansion_Text_DoorIsLocked

HauntedMansionBedroomDoor:
	checkevent EVENT_GOT_BEDROOM_KEY_1
	iftrue HauntedMansion_OpenBedroomDoor1
	opentext
	jumptext HauntedMansion_Text_DoorIsLocked_TwoLocks

HauntedMansionNPC1:
	jumptextfaceplayer HauntedMansionNPC1_Text

HauntedMansion_Item_1:
	db SUPER_REPEL, 2

HauntedMansion_Item_2:
	db SPELL_TAG, 1

HauntedMansion_Item_3:
	db RARE_CANDY, 1

HauntedMansionGengar:
	opentext
	writetext HauntedMansionGengar_Text
	waitbutton
	closetext
	playsound SFX_PERISH_SONG
	special Special_BattleTowerFade
	waitsfx
	warp DREAMSEQUENCE, 34, 2
	end

HauntedMansion_Trainer_1:
	trainer EVENT_HAUNTED_MANSION_TRAINER_1, MEDIUM, 2, HauntedMansion_Trainer_1_InitialText, HauntedMansion_Trainer_1_WinText, $0000, .Script

.Script
	end_if_just_battled
	jumptextfaceplayer HauntedMansion_Trainer_1_AfterWinText

HauntedMansion_Trainer_2:
	trainer EVENT_HAUNTED_MANSION_TRAINER_2, MEDIUM, 3, HauntedMansion_Trainer_2_Text, HauntedMansion_Trainer_2_Text, $0000, .Script

.Script
	end_if_just_battled
	jumptextfaceplayer HauntedMansion_Trainer_2_Text

HauntedMansion_Trainer_3:
	trainer EVENT_HAUNTED_MANSION_TRAINER_3, SAGE, 3, HauntedMansion_Trainer_3_InitialText, HauntedMansion_Trainer_3_WinText, $0000, .Script

.Script
	end_if_just_battled
	jumptextfaceplayer HauntedMansion_Trainer_3_AfterWinText

HauntedMansionNPC3:
	jumptextfaceplayer HauntedMansionNPC3_Text

HauntedMansion_GetKey1:
	verbosegiveitem BEDROOM_KEY, 1
	setevent EVENT_GOT_BEDROOM_KEY_1
	waitbutton
	closetext
	end

HauntedMansion_GetKey2:
	verbosegiveitem BEDROOM_KEY, 1
	setevent EVENT_GOT_BEDROOM_KEY_2
	waitbutton
	closetext
	end

HauntedMansion_OpenMansionDoor:
	opentext
	writetext HauntedMansion_Text_OpenedMansionKey
	waitbutton
	playsound SFX_ENTER_DOOR
	special Special_BattleTowerFade
	waitsfx
	warpfacing UP, HAUNTED_MANSION, 42, 15
	closetext
	end

HauntedMansion_OpenBedroomDoor1:
	checkevent EVENT_GOT_BEDROOM_KEY_2
	if_equal 1, HauntedMansion_OpenBedroomDoor2
	jump HauntedMansion_DoorLocked_TwoLocks

HauntedMansion_OpenBedroomDoor2:
	opentext
	writetext HauntedMansion_Text_OpenedPairKeys
	waitbutton
	playsound SFX_ENTER_DOOR
	special Special_BattleTowerFade
	waitsfx
	warpfacing UP, HAUNTED_MANSION, 52, 31
	closetext
	end

HauntedMansion_DoorLocked_TwoLocks:
	jumptextfaceplayer HauntedMansion_Text_DoorIsLocked_TwoLocks

HauntedMansion_Text_PlayerOpenedChest:
	ctxt "<PLAYER> opened"
	line "the chest<...>"
	done

HauntedMansion_Text_ChestIsEmpty:
	ctxt "The chest is"
	line "empty!"
	done

HauntedMansion_Text_DoorIsLocked:
	ctxt "The door is"
	line "locked."
	done

HauntedMansion_Text_DoorIsLocked_TwoLocks:
	ctxt "This door is"
	line "locked by two"
	cont "locks."
	done

HauntedMansionNPC1_Text:
	ctxt "My grandmother"
	line "used to own this"
	cont "very mansion."

	para "She always told"
	line "me that the"
	para "colors of the"
	line "rainbow in order"
	para "were Red, Grey,"
	line "Blue, Yellow,"
	cont "Brown and Teal."

	para "I'm not sure why"
	line "she always told"
	cont "me that though<...>"
	done

HauntedMansionGengar_Text:
	ctxt "Hehehe, the dreams"
	line "come to me now!"

	para "I was starving!"

	para "Ready for bedtime?"

	para "Hehehe!"
	done

HauntedMansion_Trainer_1_InitialText:
	ctxt "Just how did you"
	line "figure out how to"
	cont "get the spare key?"
	done

HauntedMansion_Trainer_1_WinText:
	ctxt "Oh, my blabber"
	line "mouth of a"
	cont "grand daughter<...>"
	done

HauntedMansion_Trainer_1_AfterWinText:
	ctxt "We're not leaving,"
	line "even if the ghosts"
	para "continue pranking"
	line "us every day."
	done

HauntedMansion_Trainer_2_Text:
	ctxt "<...>"
	done

HauntedMansion_Trainer_3_InitialText:
	ctxt "The ghosts are"
	line "reclaiming their"
	cont "rightful land<...>"
	done

HauntedMansion_Trainer_3_WinText:
	ctxt "These ghosts sure"
	line "cannot fight!"
	done

HauntedMansion_Trainer_3_AfterWinText:
	ctxt "The ghosts that"
	line "dwell here are"
	para "annoying, yet they"
	line "are all harmless."
	done

HauntedMansionNPC3_Text:
	ctxt "You're not ready to"
	line "come down here."

	para "The #mon down"
	line "stairs are too"

	para "strong for you"
	line "right now."

	para "Come back later."
	done

HauntedMansion_Text_OpenedMansionKey:
	ctxt "<PLAYER> opened"
	line "the door with the"
	cont "Mansion Key."
	done

HauntedMansion_Text_OpenedPairKeys:
	ctxt "<PLAYER> opened"
	line "the door with the"
	cont "pair of keys."
	done

HauntedMansion_MapEventHeader ;filler
	db 0, 0

;warps
	db 24
	warp_def $29, $6, 3, HAUNTED_FOREST
	warp_def $29, $7, 3, HAUNTED_FOREST
	warp_def $3, $5, 8, HAUNTED_MANSION
	warp_def $4, $d, 1, HAUNTED_MANSION
	warp_def $3, $15, 10, HAUNTED_MANSION
	warp_def $7, $2, 12, HAUNTED_MANSION
	warp_def $7, $16, 15, HAUNTED_MANSION
	warp_def $17, $4, 3, HAUNTED_MANSION
	warp_def $17, $5, 3, HAUNTED_MANSION
	warp_def $17, $12, 5, HAUNTED_MANSION
	warp_def $17, $13, 5, HAUNTED_MANSION
	warp_def $5, $20, 6, HAUNTED_MANSION
	warp_def $3, $27, 20, HAUNTED_MANSION
	warp_def $3, $2f, 21, HAUNTED_MANSION
	warp_def $5, $36, 7, HAUNTED_MANSION
	warp_def $f, $2a, 23, HAUNTED_MANSION
	warp_def $f, $2b, 23, HAUNTED_MANSION
	warp_def $1f, $34, 4, HAUNTED_MANSION
	warp_def $1f, $35, 4, HAUNTED_MANSION
	warp_def $2b, $31, 13, HAUNTED_MANSION
	warp_def $3b, $1c, 14, HAUNTED_MANSION
	warp_def $3b, $1d, 14, HAUNTED_MANSION
	warp_def $24, $7, 1, CAPER_CITY
	warp_def $37, $2c, 1, HAUNTED_MANSION_BASEMENT

	;xy triggers
	db 0

	;signposts
	db 4
	signpost 16, 21, SIGNPOST_READ, HauntedMansionChestKey1
	signpost 54, 53, SIGNPOST_READ, HauntedMansionChestKey2
	signpost 35, 7, SIGNPOST_READ, HauntedMansionMansionDoor
	signpost 3, 13, SIGNPOST_READ, HauntedMansionBedroomDoor

	;people-events
	db 10
	person_event SPRITE_TEACHER, 37, 4, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 0, 0, HauntedMansionNPC1, -1
	person_event SPRITE_POKE_BALL, 7, 11, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_PLAYER, 1, 0, HauntedMansion_Item_1, EVENT_HAUNTED_MANSION_ITEM_1
	person_event SPRITE_POKE_BALL, 16, 7, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_PURPLE, 3, TM_DREAM_EATER, 0, EVENT_HAUNTED_MANSION_NPC_2
	person_event SPRITE_POKE_BALL, 50, 26, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_PLAYER, 1, 0, HauntedMansion_Item_2, EVENT_HAUNTED_MANSION_ITEM_2
	person_event SPRITE_POKE_BALL, 7, 50, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 1, 0, HauntedMansion_Item_3, EVENT_HAUNTED_MANSION_ITEM_3
	person_event SPRITE_GENGAR, 24, 52, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_RED, 0, 0, HauntedMansionGengar, EVENT_HAUNTED_FOREST_GENGAR
	person_event SPRITE_GRANNY, 12, 42, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BROWN, 2, 1, HauntedMansion_Trainer_1, -1
	person_event SPRITE_GRANNY, 20, 18, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BROWN, 2, 1, HauntedMansion_Trainer_2, -1
	person_event SPRITE_SAGE, 44, 50, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 1, HauntedMansion_Trainer_3, -1
	person_event SPRITE_GRANNY, 55, 44, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BROWN, 0, 1, HauntedMansionNPC3, EVENT_RIJON_LEAGUE_WON
