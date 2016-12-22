MagmaRooms_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MagmaRooms_Item_1:
	db BLACKGLASSES, 1

MagmaRooms_Item_2:
	db ELIXIR, 1

MagmaRooms_Trainer_1:
	trainer EVENT_MAGMA_ROOMS_TRAINER_1, COOLTRAINERM, 4, MagmaRooms_Trainer_1_Text_11016d, MagmaRooms_Trainer_1_Text_1101a7, $0000, .Script

.Script:
	end_if_just_battled
	jumptext MagmaRooms_Trainer_1_Script_Text_1101d0

MagmaRooms_Trainer_2:
	trainer EVENT_MAGMA_ROOMS_TRAINER_2, COOLTRAINERF, 2, MagmaRooms_Trainer_2_Text_1102e0, MagmaRooms_Trainer_2_Text_11030b, $0000, .Script

.Script:
	end_if_just_battled
	jumptext MagmaRooms_Trainer_2_Script_Text_11032b

MagmaRooms_Trainer_3:
	trainer EVENT_MAGMA_ROOMS_TRAINER_3, COOLTRAINERM, 5, MagmaRooms_Trainer_3_Text_11021a, MagmaRooms_Trainer_3_Text_11026f, $0000, .Script

.Script:
	end_if_just_battled
	jumptext MagmaRooms_Trainer_3_Script_Text_11027d

MagmaRooms_Trainer_4:
	trainer EVENT_MAGMA_ROOMS_TRAINER_4, FIREBREATHER, 2, MagmaRooms_Trainer_4_Text_110439, MagmaRooms_Trainer_4_Text_110476, $0000, .Script

.Script:
	end_if_just_battled
	jumptext MagmaRooms_Trainer_4_Script_Text_11049b

MagmaRooms_Trainer_5:
	trainer EVENT_MAGMA_ROOMS_TRAINER_5, FIREBREATHER, 3, MagmaRooms_Trainer_5_Text_110517, MagmaRooms_Trainer_5_Text_11055b, $0000, .Script

.Script:
	end_if_just_battled
	jumptext MagmaRooms_Trainer_5_Script_Text_110560

MagmaRooms_Trainer_6:
	trainer EVENT_MAGMA_ROOMS_TRAINER_6, COOLTRAINERF, 3, MagmaRooms_Trainer_6_Text_110377, MagmaRooms_Trainer_6_Text_11039f, $0000, .Script

.Script:
	end_if_just_battled
	jumptext MagmaRooms_Trainer_6_Script_Text_1103c9

MagmaRooms_Trainer_1_Text_11016d:
	ctxt "Calling yourself"
	line "'cool' in your"
	cont "moniker, you'd see"
	cont "it as arrogant?"

	para "Nope!"
	done

MagmaRooms_Trainer_1_Text_1101a7:
	ctxt "It's ironic really."

	para "That's cool<...>"

	para "<...>right?"
	done

MagmaRooms_Trainer_1_Script_Text_1101d0:
	ctxt "But if I called"
	line "myself lame<...>"

	para "People would then"
	line "think I'm lame!"
	done

MagmaRooms_Trainer_2_Text_1102e0:
	ctxt "It's too humid in"
	line "here, I'm about"
	cont "to break a sweat!"
	done

MagmaRooms_Trainer_2_Text_11030b:
	ctxt "Aaand<...> I'm offi-"
	line "cially sweating."
	done

MagmaRooms_Trainer_2_Script_Text_11032b:
	ctxt "I'm sweating<...>"

	para "For all the"
	line "wrong reasons!"
	done

MagmaRooms_Trainer_3_Text_11021a:
	ctxt "The lava tide has"
	line "been known to rise"
	cont "to right where"
	cont "we're standing!"

	para "We're living on"
	line "the edge here!"
	done

MagmaRooms_Trainer_3_Text_11026f:
	ctxt "Darn it all."
	done

MagmaRooms_Trainer_3_Script_Text_11027d:
	ctxt "If only they made"
	line "shoes that let"
	cont "you walk on lava."

	para "Wouldn't that be"
	line "something?"
	done

MagmaRooms_Trainer_4_Text_110439:
	ctxt "Nothing to burn"
	line "here, so it's the"
	cont "perfect place to"
	cont "practice!"
	done

MagmaRooms_Trainer_4_Text_110476:
	ctxt "Well that's not"
	line "the way I wanted"
	cont "it, at all."
	done

MagmaRooms_Trainer_4_Script_Text_11049b:
	ctxt "My Magmar and I"
	line "like to get into"
	cont "fire breathing"
	cont "contests!"

	para "It took me years"
	line "to catch up to"
	cont "his ability."
	done

MagmaRooms_Trainer_5_Text_110517:
	ctxt "I was kicked out"
	line "of the park."

	para "They don't let me"
	line "perform my fire"
	cont "breathing there."
	done

MagmaRooms_Trainer_5_Text_11055b:
	ctxt "Oy."
	done

MagmaRooms_Trainer_5_Script_Text_110560:
	ctxt "To be fair, who"
	line "creates a park"
	cont "that's above a"
	cont "volcano anyway?"
	done

MagmaRooms_Trainer_6_Text_110377:
	ctxt "I heard this is a"
	line "cool place to do"
	cont "some training."
	done

MagmaRooms_Trainer_6_Text_11039f:
	ctxt "Cool, meaning"
	line "informal, not"
	cont "temperature."
	done

MagmaRooms_Trainer_6_Script_Text_1103c9:
	ctxt "To the southwest"
	line "of here, there is"
	cont "a real cold place."

	para "This region sure"
	line "has interesting"
	cont "geography."
	done

MagmaRooms_MapEventHeader ;filler
	db 0, 0

;warps
	db 10
	warp_def $2b, $21, 1, MAGMA_PALLETPATH_B1F
	warp_def $21, $5, 1, MAGMA_MINECART
	warp_def $31, $11, 2, MAGMA_F1
	warp_def $7, $7, 9, MAGMA_ROOMS
	warp_def $15, $19, 10, MAGMA_ROOMS
	warp_def $33, $7, 1, MAGMA_GROUDON
	warp_def $5, $2f, 2, MAGMA_ITEMROOM
	warp_def $2b, $14, 9, CAPER_CITY
	warp_def $25, $2f, 4, MAGMA_ROOMS
	warp_def $37, $35, 5, MAGMA_ROOMS

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 9
	person_event SPRITE_POKE_BALL, 25, 9, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, 0, 3, TM_SUNNY_DAY, 0, EVENT_MAGMA_ROOMS_NPC_1
	person_event SPRITE_POKE_BALL, 19, 32, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 1, 1, MagmaRooms_Item_1, EVENT_MAGMA_ROOMS_ITEM_1
	person_event SPRITE_POKE_BALL, 53, 33, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, MagmaRooms_Item_2, EVENT_MAGMA_ROOMS_ITEM_2
	person_event SPRITE_YOUNGSTER, 44, 26, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 2, 3, MagmaRooms_Trainer_1, -1
	person_event SPRITE_COOLTRAINER_F, 55, 37, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, MagmaRooms_Trainer_2, -1
	person_event SPRITE_YOUNGSTER, 29, 28, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, 2, 4, MagmaRooms_Trainer_3, -1
	person_event SPRITE_FISHER, 4, 32, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, 2, 2, MagmaRooms_Trainer_4, -1
	person_event SPRITE_FISHER, 13, 49, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, 2, 3, MagmaRooms_Trainer_5, -1
	person_event SPRITE_COOLTRAINER_F, 28, 48, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, MagmaRooms_Trainer_6, -1
