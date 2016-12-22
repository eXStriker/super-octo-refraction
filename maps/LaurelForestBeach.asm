LaurelForestBeach_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

LaurelForestBeachSignpost1:
	opentext
	writetext LaurelForestBeachSignpost1_Text_129b20
	yesorno
	sif false
		jumptext LaurelForestBeach_12bb9e_Text_129b3a
	writetext LaurelForestBeach_12bba4_Text_129b4c
	checkevent EVENT_0
	iffalse LaurelForestBeach_12bbb4
	playsound SFX_SWITCH_POKEMON
	changemap BANK(LaurelForestBeach_12bbc0_BlockData1), LaurelForestBeach_12bbc0_BlockData1
	clearevent EVENT_0
	endtext

LaurelForestBeachNPC1:
	faceplayer
	cry SURSKIT
	jumptext LaurelForestBeachNPC1_Text_129c51

LaurelForestBeachNPC2:
	faceplayer
	cry XATU
	waitsfx
	jumptext LaurelForestBeachNPC2_Text_12b45b

LaurelForestBeachNPC4:
	faceplayer
	cry WARTORTLE
	checkevent EVENT_POKEONLY_BEAT_WARTORTLE
	iffalse LaurelForestBeach_12ab67
	jumptext LaurelForestBeach_12ab60_Text_129ec0

LaurelForestBeachNPC5:
	checkevent EVENT_POKEONLY_FRUIT_TREE_2_DEAD
	iffalse LaurelForestBeach_12bc95
	jumptext LaurelForestBeach_12bed4_Text_12bc61

LaurelForestBeachGiantRock:
	db GIANT_ROCK, 1

LaurelForestBeach_12ab67:
	opentext
	writetext LaurelForestBeach_12ab7b_Text_129cf0
	waitbutton
	writecode VAR_BATTLETYPE, BATTLETYPE_TRAP
	loadwildmon WARTORTLE, 22
	startbattle
	reloadmapafterbattle
	setevent EVENT_POKEONLY_BEAT_WARTORTLE
	jumptext LaurelForestBeach_12aba0_Text_129e35

LaurelForestBeach_12bc95:
	opentext
	writetext LaurelForestBeach_12bad0_Text_12bbd0
	giveitem ORAN_BERRY, 1
	writetext LaurelForestBeach_Text_LeadingMonHeldBerry
	playwaitsfx SFX_ITEM
	waitbutton
	setevent EVENT_POKEONLY_FRUIT_TREE_2_DEAD
	checkevent EVENT_POKEONLY_PIKACHU_IN_PARTY
	sif false
		endtext
	cry PIKACHU
	waitsfx
	jumptext BeachPikachuCommentsText

LaurelForestBeach_12bbb4:
	playsound SFX_SWITCH_POKEMON
	changemap BANK(LaurelForestBeach_12bbb4_BlockData1), LaurelForestBeach_12bbb4_BlockData1
	setevent EVENT_0
	endtext

LaurelForestBeachSignpost1_Text_129b20:
	ctxt "Oooh, a switch!"

	para "Push it?"
	done

LaurelForestBeachNPC1_Text_129c51:
	ctxt "I come from far"
	line "away<...>"

	para "I was washed upon"
	line "this shore, and"
	para "the current is"
	line "too fast to push"
	cont "me back home."

	para "I wonder what"
	line "causes the strange"
	cont "tides here?"
	done

LaurelForestBeachNPC2_Text_12b45b:
	ctxt "There was a vein"
	line "of mind rejuve-"
	para "nating shards"
	line "that were called"
	cont "'Curo Shards'."

	para "They were used by"
	line "our community to"
	para "aid us in thinking"
	line "straight during"
	cont "stressful moments."

	para "To create this"
	line "effect, all you"
	cont "need is 3 shards."

	para "However, the vein"
	line "has been blocked"
	para "off recently due"
	line "to the scientists."

	para "They're working"
	line "on collecting"
	cont "every last one!"

	para "The community is"
	line "still holding on"
	cont "to a few, though."

	para "If you need one,"
	line "you should look"
	para "around and talk"
	line "to the residents."
	done

LaurelForestBeach_12bb9e_Text_129b3a:
	ctxt "Fine, be a wimp!"
	done

LaurelForestBeach_12bba4_Text_129b4c:
	ctxt "Who wouldn't?"
	done

LaurelForestBeach_12ab60_Text_129ec0:
	ctxt "I told you, stay"
	line "out of my way!"
	done

LaurelForestBeach_12bed4_Text_12bc61:
	ctxt "This tree won't"
	line "grow any more"
	cont "Berries<...>"
	done

LaurelForestBeach_12ab7b_Text_129cf0:
	ctxt "-sigh-"

	para "Ever since someone"
	line "put that strange"
	cont "machine there,"

	para "my beach has"
	line "been full of"
	cont "trespassers!"

	para "In fact, what are"
	line "you doing here?"

	para "Get off my beach"
	line "now or you'll be"
	cont "sorry!"
	done

LaurelForestBeach_12aba0_Text_129e35:
	ctxt "Fine, I'll share."

	para "Just make sure to"
	line "stay out of my"
	cont "way from now on."
	done

BeachPikachuCommentsText:
	ctxt "This Berry looks"
	line "delicious!"

	para "But I think we"
	line "can do better."

	para "Let's look for"
	line "more!"
	done

LaurelForestBeach_12bad0_Text_12bbd0:
	ctxt "This tree appears"
	line "damaged<...>"

	para "There's one Oran"
	line "Berry left, might"
	cont "as well pick it!"
	prompt

LaurelForestBeach_Text_LeadingMonHeldBerry:
	ctxt "Picked the Berry!"
	done

LaurelForestBeach_12bbb4_BlockData1:
INCBIN "./maps/LaurelForestBeach_12bbb4_BlockData1.blk.lz"

LaurelForestBeach_12bbc0_BlockData1:
INCBIN "./maps/LaurelForestBeach_12bbc0_BlockData1.blk.lz"

LaurelForestBeach_MapEventHeader:: db 0, 0

.Warps: db 2
	warp_def 1, 8, 5, LAUREL_FOREST_POKEMON_ONLY
	warp_def 2, 8, 6, LAUREL_FOREST_POKEMON_ONLY

.CoordEvents: db 0

.BGEvents: db 1
	signpost 15, 7, SIGNPOST_READ, LaurelForestBeachSignpost1

.ObjectEvents: db 5
	person_event SPRITE_SURSKIT, 10, 11, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, LaurelForestBeachNPC1, -1
	person_event SPRITE_XATU, 16, 13, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, LaurelForestBeachNPC2, -1
	person_event SPRITE_WARTORTLE, 14, 10, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, LaurelForestBeachNPC4, -1
	person_event SPRITE_FRUIT_TREE, 15, 6, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, LaurelForestBeachNPC5, -1
	person_event SPRITE_POKE_BALL, 12, 15, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 1, 0, LaurelForestBeachGiantRock, EVENT_POKEONLY_GOT_ROCK_1
