HaywardHouse_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

EggAppraiserScript:
	clearevent EVENT_0
	faceplayer
	opentext
	checkevent EVENT_EGG_APPRAISER
	iftrue .skipExplanation
	writetext EggAppraiserIntroduceText
	waitbutton
	setevent EVENT_EGG_APPRAISER
.skipExplanation
	checkitem GOLD_EGG
	iftrue .giveHooh
.checkSilverEgg:
	checkitem SILVER_EGG
	iftrue .giveLugia
	checkevent EVENT_0
	iftrue .checkEggEnd
	checkitem CRYSTAL_EGG
	iftrue .eggAppraiserWrongEgg
	checkitem RUBY_EGG
	iftrue .eggAppraiserWrongEgg
	checkitem SAPPHIRE_EGG
	iftrue .eggAppraiserWrongEgg
	checkitem EMERALD_EGG
	iftrue .eggAppraiserWrongEgg
	checkitem LUCKY_EGG
	iftrue .eggAppraiserWrongEgg
.checkEggEnd
	checkevent EVENT_GOT_HOOH_EGG
	iffalse .notBothEgg
	checkevent EVENT_GOT_LUGIA_EGG
	iffalse .notBothEgg
	jumptext EggAppraiserDoneText

.notBothEgg
	jumptext EggAppraiserNoEggText

.giveHooh
	writetext EggAppraiserHoohEggText
	waitbutton
	checkcode VAR_PARTYCOUNT
	if_equal 6, .noRoom
.getHoohEgg
	takeitem GOLD_EGG
	giveegg HO_OH, 1
	setevent EVENT_GOT_HOOH_EGG
	writetext EggAppraiserGivenEgg
	playwaitsfx SFX_GET_EGG_FROM_DAYCARE_MAN
	setevent EVENT_0
	jump .checkSilverEgg
.noRoom
	jumptext EggAppraiserNoRoomText

.giveLugia
	writetext EggAppraiserLugiaEggText
	waitbutton
	checkcode VAR_PARTYCOUNT
	if_equal 6, .noRoom
.getLugiaEgg
	takeitem SILVER_EGG
	giveegg LUGIA, 1
	setevent EVENT_GOT_LUGIA_EGG
	writetext EggAppraiserGivenEgg
	playwaitsfx SFX_GET_EGG_FROM_DAYCARE_MAN
	jump .checkEggEnd

.eggAppraiserWrongEgg
	jumptext EggAppraiserWrongEggText

EggAppraiserGivenEgg:
	ctxt "<PLAYER> added"
	line "the egg to the"
	cont "party!"
	done

EggAppraiserWrongEggText:
	ctxt "This egg<...>"

	para "It's special all"
	line "right."

	para "But it's not a"
	line "#mon, sorry!"
	done

EggAppraiserDoneText:
	ctxt "I don't think you"
	line "will be able to"

	para "find more special"
	line "#mon eggs."

	para "How I could help!"
	done

EggAppraiserNoEggText:
	ctxt "Come back if you"
	line "find more special"
	cont "eggs."
	done

EggAppraiserNoRoomText:
	ctxt "You don't have any"
	line "room for this."

	para "Please free some"
	line "space in your"
	cont "party."
	done

EggAppraiserHoohEggText:
	ctxt "Incredible!"

	para "This Gold Egg is"
	line "actually a #mon"
	cont "egg!"
	done

EggAppraiserLugiaEggText:
	ctxt "Incredible!"

	para "This Silver Egg is"
	line "actually a #mon"
	cont "egg!"
	done

EggAppraiserIntroduceText:
	ctxt "Welcome welcome!"

	para "I am the Egg"
	line "Appraiser!"

	para "Certain special"
	line "eggs are actually"
	cont "#mon."

	para "Bring me an egg"
	line "and I'll see if"
	para "it's actually a"
	line "rare #mon!"
	done

HaywardHouse_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def 7, 2, 8, HAYWARD_CITY
	warp_def 7, 3, 8, HAYWARD_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_R_MANIAC, 3, 5, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 0, 0, EggAppraiserScript, -1
