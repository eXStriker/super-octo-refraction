SaxifrageIsland_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1

	dbw MAPCALLBACK_NEWMAP, Saxifrage_SetFlyFlag

Saxifrage_SetFlyFlag:
	setflag ENGINE_FLYPOINT_SAXIFRAGE_ISLAND
	return

SaxifrageIslandHiddenItem_1:
	dw EVENT_SAXIFRAGE_ISLAND_HIDDENITEM_REVIVE
	db REVIVE

SaxifrageIslandTrap1:
	applymovement 11, SaxifrageIslandTrap1_Movement1
	checkevent EVENT_ARRESTED
	iftrue SaxifrageIsland_12120e
	opentext
	writetext SaxifrageIslandTrap1_Text_12120f
	takeitem FAKE_ID, 1
	waitbutton
	warp PRISON_F1, 20, 6
	opentext
	writetext SaxifrageIslandTrap1_Text_1212f7
	setevent EVENT_ARRESTED
	waitbutton
	closetext
	applymovement 4, SaxifrageIsland_1212e1_Movement1
	blackoutmod PRISON_F1
	disappear 4
SaxifrageIsland_12120e:
	end

SaxifrageIslandTrap1_Movement1:
	step_left
	step_left
	step_left
	step_up
	turn_head_up
	step_end

SaxifrageIslandSignpost2:
	jumpstd pokecentersign

SaxifrageIslandSignpost3:
	jumptext SaxifrageIslandSignpost3_Text_121cee

SaxifrageIslandSignpost4:
	ctxt "Island to protect"
	next "the public from"
	next "dangerous crimi-"
	next "nals"
	done ;42

SaxifrageIslandNPC1:
	faceplayer
	opentext
	checkevent EVENT_PALETTE_BLUE
	sif true
		jumptext SaxifrageIsland_1239ed_Text_123b71
	writetext SaxifrageIslandNPC1_Text_1239f9
	waitbutton
	verbosegiveitem CAGE_KEY, 1
	sif false
		jumptext SaxifrageIsland_1239f3_Text_123bb4
	setevent EVENT_PALETTE_BLUE
	waitbutton
	closetext
	end

SaxifrageIslandNPC2:
	jumptextfaceplayer SaxifrageIslandNPC2_Text_123d8e

SaxifrageIslandNPC3:
	jumptextfaceplayer SaxifrageIslandNPC3_Text_12154e

SaxifrageIslandNPC4:
	jumpstd strengthboulder

SaxifrageIslandNPC9:
	jumptextfaceplayer SaxifrageIslandNPC9_Text_1214ff

SaxifrageIsland_1212e1_Movement1:
	step_right
	step_right
	step_right
	step_right
	step_right
	step_right
	step_right
	step_end

SaxifrageIslandTrap1_Text_12120f:
	ctxt "Halt!"

	para "Let me see your"
	line "identification."

	para "<...>"

	para "Haha, oh, you're"
	line "a smart kid, huh?"

	para "A fake ID won't"
	line "work with me."

	para "I need you to come"
	line "with me."
	done

SaxifrageIslandTrap1_Text_1212f7:
	ctxt "I need you to stay"
	line "here."

	para "Don't consider this"
	line "an arrest."

	para "We're not sure what"
	line "to do with you"
	cont "right now."

	para "We don't get many"
	line "kids coming to"
	cont "Saxifrage."

	para "Usually<...>"

	para "We get guys coming"
	line "through here all"

	para "the time claiming"
	line "they're here to"

	para "challenge Cadence"
	line "to a Gym Battle,"

	para "but what ends up"
	line "happening is them"

	para "trying to spring"
	line "their buddies out"
	cont "of prison."

	para "Now, I don't know"
	line "what purpose you"

	para "had in coming here"
	line "exactly,"

	para "but we'll figure"
	line "that out tomorrow."
	done

SaxifrageIslandSignpost3_Text_121cee:
	ctxt "500 Years of"
	line "Tradition"

	para "CIANWOOD CITY"
	line "PHARMACY"

	para "We Await Your"
	line "Medicinal Queries"
	done

SaxifrageIslandNPC1_Text_1239f9:
	ctxt "They got you too?"

	para "I was taken here,"
	line "Pink was taken to"
	cont "Eagulou City and"
	cont "and Red<...> somehow"
	cont "managed to escape."

	para "<...>"

	para "You're asking how"
	line "I ended up here?"

	para "Well<...>"

	para "After I was sent"
	line "here, Varaneous,"

	para "the #mon that"
	line "Red woke up, came"

	para "and created that"
	line "path back there."

	para "Red did say that"
	line "Varaneous knew"

	para "where the other"
	line "Guardians were."

	para "Perhaps it's trying"
	line "to return the orbs"

	para "to the other"
	line "Guardians."

	para "But yes, using the"
	line "path it created, I"

	para "was able to escape"
	line "and ended up here."

	para "Oh yeah, I found"
	line "this thing inside"
	cont "the Warden's house."

	para "Please take it."

	para "Maybe Varaneous is"
	line "still around."

	para "I have the sinking"
	line "feeling that you"

	para "might be able to"
	line "tame it."
	done

SaxifrageIslandNPC2_Text_123d8e:
	ctxt "The prisoners in"
	line "that jail come"

	para "up with the most"
	line "ridiculous tales."

	para "One inmate claims"
	line "that he sees a"

	para "pair of glowing"
	line "red eyes in the"
	cont "hallways at night."
	done

SaxifrageIslandNPC3_Text_12154e:
	ctxt "I'm waiting for"
	line "my boyfriend's"
	cont "time to be up."

	para "I'll wait for him"
	line "forever, won't I?"
	done

SaxifrageIslandNPC9_Text_1214ff:
	ctxt "We've built a wall"
	line "that blocks the"

	para "entrance in order"
	line "to keep people"
	cont "from escaping."
	done

SaxifrageIsland_1239ed_Text_123b71:
	ctxt "Please look for"
	line "the Guardians."
	done

SaxifrageIsland_1239f3_Text_123bb4:
	ctxt "Free some space"
	line "in your pack,"
	cont "if you would."
	done

SaxifrageIsland_MapEventHeader:: db 0, 0

.Warps: db 7
	warp_def 23, 16, 1, PRISON_F1
	warp_def 35, 2, 2, SAXIFRAGE_GYM
	warp_def 11, 25, 1, SAXIFRAGE_POKECENTER
	warp_def 37, 27, 1, SAXIFRAGE_MART
	warp_def 19, 2, 4, SAXIFRAGE_EXITS
	warp_def 3, 26, 1, SAXIFRAGE_EXITS
	warp_def 3, 7, 1, SAXIFRAGE_WARDENS_HOUSE

.CoordEvents: db 1
	xy_trigger 0, 20, 2, 0, SaxifrageIslandTrap1, 0, 0

.BGEvents: db 4
	signpost 11, 26, SIGNPOST_READ, SaxifrageIslandSignpost2
	signpost 37, 28, SIGNPOST_READ, SaxifrageIslandSignpost3
	signpost 30, 18, SIGNPOST_LOAD, SaxifrageIslandSignpost4
	signpost 17, 8, SIGNPOST_ITEM, SaxifrageIslandHiddenItem_1

.ObjectEvents: db 10
	person_event SPRITE_PALETTE_PATROLLER, 20, 9, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, SaxifrageIslandNPC1, EVENT_PHLOX_LAB_CEO
	person_event SPRITE_OFFICER, 31, 11, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, SaxifrageIslandNPC2, -1
	person_event SPRITE_LASS, 22, 21, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SaxifrageIslandNPC3, -1
	person_event SPRITE_BOULDER, 25, 9, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SaxifrageIslandNPC4, -1
	person_event SPRITE_BOULDER, 13, 7, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SaxifrageIslandNPC4, -1
	person_event SPRITE_BOULDER, 24, 8, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SaxifrageIslandNPC4, -1
	person_event SPRITE_BOULDER, 6, 13, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SaxifrageIslandNPC4, -1
	person_event SPRITE_BOULDER, 8, 28, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SaxifrageIslandNPC4, -1
	person_event SPRITE_OFFICER, 24, 17, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, SaxifrageIslandNPC9, -1
	person_event SPRITE_OFFICER, 22, 5, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, ObjectEvent, EVENT_ARRESTED

