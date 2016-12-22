ToreniaGym_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

ToreniaGymSignpost1:
	checkflag ENGINE_ELECTRONBADGE
	iftrue ToreniaGym_149164
	jumpstd gymstatue1

ToreniaGymSignpost2:
	checkflag ENGINE_ELECTRONBADGE
	iftrue ToreniaGym_149164
	jumpstd gymstatue1

ToreniaGymNPC1:
	faceplayer
	checkevent EVENT_HAUNTED_FOREST_GENGAR

	if_equal 1, ToreniaGym_14a44b
	jumptext ToreniaGymNPC1_Text_14a090

ToreniaGym_149164:
	trainertotext 4, 1, 1
	jumpstd gymstatue2

ToreniaGym_14a44b:
	checkflag ENGINE_ELECTRONBADGE
	if_equal 1, ToreniaGym_14a477
	opentext
	writetext ToreniaGym_14a44b_Text_14a275
	waitbutton
	winlosstext ToreniaGym_14a44b_Text_14a3ed, 0
	loadtrainer EDISON, 1
	startbattle
	reloadmapafterbattle
	opentext
	writetext ToreniaGym_14a44bText_14a388
	playwaitsfx SFX_TCG2_DIDDLY_5
	special RestartMapMusic
	writetext ToreniaGym_14a468_Text_14a480
	waitbutton
	givetm TM_DARK_PULSE + RECEIVED_TM
	setflag ENGINE_ELECTRONBADGE
	jumptext ToreniaGymTMExplain

ToreniaGym_14a477:
	jumptext ToreniaGym_14a477_Text_14a407
	
ToreniaGymTMExplain:
	ctxt "TM51 is Dark"
	line "Pulse!"
	
	para "It's a strong dark"
	line "attack that can"
	
	para "cause your foe to"
	line "flinch!"
	done

ToreniaGymNPC1_Text_14a090:
	ctxt "AHHH!"

	para "Who are you<...>?"

	para "<...>"

	para "Ah, that's right."

	para "I'm a Gym Leader"
	line "and this is a Gym."

	para "I suppose you are"
	line "here for my badge."

	para "Well, truth is<...>"

	para "I haven't accepted"
	line "Gym challenges for"
	cont "3 full years now."

	para "I used to dream<...>"

	para "But now I don't,"
	line "and it depresses"
	cont "me oh so greatly."

	para "I used to go on"
	line "so many adventures"
	cont "with my #mon."

	para "The wide green"
	line "fields I enjoyed"
	cont "as a young lad are"
	cont "starting to vanish"
	cont "from my mind<...>"

	para "Those dreams used"
	line "to be what pushed"
	cont "me to move on."

	para "But now<...>"

	para "No motivation to"
	line "do anything<...>"

	para "So until I find a"
	line "way to dream once"
	cont "again, you're not"
	cont "going to get a"
	cont "shot at my badge."
	done

ToreniaGym_14a44b_Text_14a275:
	ctxt "Hiya!"

	para "I just awakened"
	line "from the most"
	cont "pleasant dream."

	para "<...>"

	para "What? A Gengar"
	line "from Botan City"
	cont "was devouring my"
	cont "sweet dreams?"

	para "<...>"

	para "Ah, you sacrificed"
	line "yourself for me."

	para "How nice of you."

	para "Well, this isn't"
	line "a fictional anime,"
	cont "so I can't just"
	cont "give you my badge."

	para "You're still going"
	line "to have to prove"
	cont "your worth to me."
	done

ToreniaGym_14a44bText_14a388:
	ctxt "<PLAYER> got the"
	line "Midnight Badge!"
	done

ToreniaGym_14a44b_Text_14a3ed:
	ctxt "Marvelous!"
	done

ToreniaGym_14a477_Text_14a407:
	ctxt "Thank you for"
	line "allowing me to"
	cont "dream again."
	done

ToreniaGym_14a468_Text_14a480:
	ctxt "I won't be needing"
	line "this TM anymore"
	cont "either!"
	done

ToreniaGym_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $11, $a, 2, TORENIA_CITY
	warp_def $11, $b, 2, TORENIA_CITY

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 15, 9, SIGNPOST_READ, ToreniaGymSignpost1
	signpost 15, 12, SIGNPOST_READ, ToreniaGymSignpost2

	;people-events
	db 1
	person_event SPRITE_MORTY, 12, 10, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_SILVER, 0, 0, ToreniaGymNPC1, -1
