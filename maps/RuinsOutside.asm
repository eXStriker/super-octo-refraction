RuinsOutside_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

RuinsOasis:
	opentext
	writetext RuinsOutsideSignpost1_Text_24dcd5
	yesorno
	iftrue RuinsOutside_24dcbf
	closetext
	end

RuinsOutsideNPC1:
	faceplayer
	opentext
	checkitem PRISM_JEWEL
	iftrue RuinsOutside_24f28b
	checkitem RED_JEWEL
	iftrue RuinsOutside_24f285
	checkitem BLUE_JEWEL
	iftrue RuinsOutside_24f285
	checkitem BROWN_JEWEL
	iftrue RuinsOutside_24f285
	checkitem WHITE_JEWEL
	iftrue RuinsOutside_24f285
	writetext RuinsOutsideNPC1_Text_24f2ab
	endtext

RuinsOutsideNPC2:
	jumptextfaceplayer RuinsOutsideNPC2_Text_24f1a1

RuinsOutside_24dcbf:
	special ClearBGPalettes
	special HealParty
	playwaitsfx SFX_HEAL_POKEMON
	special FadeInPalettes
	jumptext RuinsOutside_24dcbf_Text_24dd01

RuinsOutside_24f28b:
	writetext RuinsOutside_24f28b_Text_24f482
	playwaitsfx SFX_DEX_FANFARE_50_79
	takeitem PRISM_JEWEL, 1
	giveitem FAKE_ID, 1
	writetext RuinsOutside_24f28b_Text_24f4fc
	waitbutton
	setevent EVENT_RUINS_OUTSIDE_NPC_1
	special Special_BattleTowerFade
	disappear 2
	special Special_FadeInQuickly
	playwaitsfx SFX_EXIT_BUILDING
	reloadmap
	end

RuinsOutside_24f285:
	writetext RuinsOutside_24f285_Text_24f3f3
	endtext

RuinsOutsideSignpost1_Text_24dcd5:
	ctxt "It's an oasis!"

	para "Want to take a"
	line "relaxing dip?"
	done

RuinsOutsideNPC1_Text_24f2ab:
	ctxt "Hello, hello,"
	line "hellooo!"

	para "I am a revered"
	line "archaeologist!"

	para "Naljo has such"
	line "alluring history."

	para "Did you know!"

	para "These ruins used"
	line "to be a temple."

	para "Everyone in Naljo"
	line "would come here"
	para "to worship the"
	line "four Guardians,"

	para "but it's now in"
	line "a state of decay"
	para "because nobody is"
	line "using it anymore."

	para "If you bring me"
	line "something truly"
	para "exciting from the"
	line "inside, maybe I'll"
	cont "give you a reward."
	done

RuinsOutsideNPC2_Text_24f1a1:
	ctxt "There's several"
	line "hidden pits inside"
	cont "the Naljo ruins."

	para "You can jump over"
	line "pits not only to"
	cont "reach new areas,"

	para "but you can also"
	line "jump over pits"
	cont "that haven't been"
	cont "uncovered yet."

	para "That's just in"
	line "case you want to"
	cont "be careful."
	done

RuinsOutside_24dcbf_Text_24dd01:
	ctxt "That was soothing!"

	para "Your #mon are"
	line "now fully healed!"
	done

RuinsOutside_24f28b_Text_24f482:
	ctxt "My word!"

	para "I've never seen"
	line "beauty like this"
	cont "before in my life!"

	para "Please<...> take this."

	para "With this, I don't"
	line "need it anymore."

	para "The man handed"
	line "you a Fake ID!"
	done

RuinsOutside_24f28b_Text_24f4fc:
	ctxt "As far as everyone"
	line "else is concerned,"

	para "you are now a true"
	line "Naljo citizen."

	para "I had to use it"
	line "to stay in this"
	para "region undetected"
	line "by certain people"
	para "who say they want"
	line "the past of this"
	cont "land destroyed."

	para "But now at last,"
	line "the Prism Jewel"
	cont "is in my hands,"

	para "and I can finally"
	line "return home!"

	para "Goodbye!"
	done

RuinsOutside_24f285_Text_24f3f3:
	ctxt "Yes yes, jewels"
	line "can be quite<...>"
	para "interesting, but"
	line "these don't seem"
	cont "to interest me."

	para "If you find a"
	line "truly fascinating"
	para "jewel, only then"
	line "I'll reward you."
	done

RuinsOutside_MapEventHeader:: db 0, 0

.Warps: db 6
	warp_def 17, 54, 2, RUINS_ENTRY
	warp_def 17, 55, 2, RUINS_ENTRY
	warp_def 5, 30, 1, RUINS_F1
	warp_def 17, 6, 4, CLATHRITE_1F
	warp_def 17, 7, 4, CLATHRITE_1F
	warp_def 5, 31, 2, RUINS_F1

.CoordEvents: db 0

.BGEvents: db 36
	signpost 2, 7, SIGNPOST_READ, RuinsOasis
	signpost 3, 7, SIGNPOST_READ, RuinsOasis
	signpost 4, 7, SIGNPOST_READ, RuinsOasis
	signpost 5, 7, SIGNPOST_READ, RuinsOasis
	signpost 6, 7, SIGNPOST_READ, RuinsOasis
	signpost 6, 8, SIGNPOST_READ, RuinsOasis
	signpost 6, 9, SIGNPOST_READ, RuinsOasis
	signpost 6, 10, SIGNPOST_READ, RuinsOasis
	signpost 6, 11, SIGNPOST_READ, RuinsOasis
	signpost 6, 12, SIGNPOST_READ, RuinsOasis
	signpost 6, 13, SIGNPOST_READ, RuinsOasis
	signpost 6, 14, SIGNPOST_READ, RuinsOasis
	signpost 6, 15, SIGNPOST_READ, RuinsOasis
	signpost 6, 16, SIGNPOST_READ, RuinsOasis
	signpost 6, 18, SIGNPOST_READ, RuinsOasis
	signpost 6, 17, SIGNPOST_READ, RuinsOasis
	signpost 3, 18, SIGNPOST_READ, RuinsOasis
	signpost 2, 18, SIGNPOST_READ, RuinsOasis
	signpost 2, 41, SIGNPOST_READ, RuinsOasis
	signpost 3, 41, SIGNPOST_READ, RuinsOasis
	signpost 4, 41, SIGNPOST_READ, RuinsOasis
	signpost 4, 41, SIGNPOST_READ, RuinsOasis
	signpost 6, 43, SIGNPOST_READ, RuinsOasis
	signpost 6, 44, SIGNPOST_READ, RuinsOasis
	signpost 6, 45, SIGNPOST_READ, RuinsOasis
	signpost 6, 46, SIGNPOST_READ, RuinsOasis
	signpost 6, 47, SIGNPOST_READ, RuinsOasis
	signpost 6, 48, SIGNPOST_READ, RuinsOasis
	signpost 6, 49, SIGNPOST_READ, RuinsOasis
	signpost 6, 50, SIGNPOST_READ, RuinsOasis
	signpost 6, 51, SIGNPOST_READ, RuinsOasis
	signpost 6, 52, SIGNPOST_READ, RuinsOasis
	signpost 5, 52, SIGNPOST_READ, RuinsOasis
	signpost 4, 52, SIGNPOST_READ, RuinsOasis
	signpost 3, 52, SIGNPOST_READ, RuinsOasis
	signpost 2, 52, SIGNPOST_READ, RuinsOasis

.ObjectEvents: db 2
	person_event SPRITE_POKEFAN_M, 9, 6, SPRITEMOVEDATA_WANDER, 3, 3, -1, -1, PAL_OW_RED, 0, 0, RuinsOutsideNPC1, EVENT_RUINS_OUTSIDE_NPC_1
	person_event SPRITE_FISHER, 12, 46, SPRITEMOVEDATA_WANDER, 3, 3, -1, -1, PAL_OW_RED, 0, 0, RuinsOutsideNPC2, -1
