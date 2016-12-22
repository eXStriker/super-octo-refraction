MagikarpCavernsMain_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MagikarpCavernsMain_Item_1:
	db HARD_STONE, 1

MagikarpCavernsMain_Item_2:
	db PRISM_SCALE, 1

MagikarpCavernsMainNPC1:
	faceplayer
	checkevent EVENT_MAGIKARP_TEST
	iftrue MagikarpCavernsMain_1609fc
	opentext
	writetext MagikarpCavernsMainNPC1_Text_162200
	yesorno
	iffalse MagikarpCavernsMain_1609f9
	writetext MagikarpCavernsMainNPC1_Text_1625fd
	waitbutton
	closetext
	setflag ENGINE_POKEMON_MODE
	setflag ENGINE_CUSTOM_PLAYER_SPRITE
	writecode VAR_MOVEMENT, PLAYER_NORMAL
	callasm .SetPlayerSpriteAsMagikarp
	warp MAGIKARP_CAVERNS_RAPIDS, 10, 11
	end

.SetPlayerSpriteAsMagikarp:
	ld a, MAGIKARP
	ld [wPokeonlyMainSpecies], a
	ld a, SPRITE_WALKING_MAGIKARP
	ld [PlayerSprite], a
	ret

MagikarpCavernsMainNPC2:
	jumpstd strengthboulder

MagikarpCavernsMain_1609fc:
	jumptextfaceplayer MagikarpCavernsMain_1609fc_Text_162611

MagikarpCavernsMain_1609f9:
	jumptext MagikarpCavernsMain_1609f9_Text_162552

MagikarpCavernsMainNPC3:
	jumptextfaceplayer MagikarpCavernsMainNPC3Text

MagikarpCavernsMainNPC3Text:
	ctxt "Hold on."

	para "North of the cave"
	line "lies the region of"
	cont "Tunod."

	para "You're not strong"
	line "enough to handle"

	para "the Trainers there"
	line "yet."

	para "Come back when you"
	line "have grown more as"
	cont "a Trainer!"
	done

MagikarpCavernsMainNPC1_Text_162200:
	ctxt "Welcome!"

	para "I see you found"
	line "your way around"
	cont "the sacred fish?"

	para "<...>"

	para "Oh, so you failed"
	line "to notice how this"
	cont "cave is designed?"

	para "I have aligned"     
	line "the rocks in here"

	para "to look like the"
	line "#mon I idolize."

	para "Yes, the majestic"
	line "fish #mon"
	cont "called Magikarp!"

	para "Tales of its"
	line "past have shown"

	para "it to be more"
	line "powerful than it"
	cont "is currently."

	para "In my family,"
	line "it is told that"

	para "my ancestors would"
	line "pray on a daily"

	para "basis for the fish"
	line "to return to its"
	cont "former glory days."

	para "<...>"

	para "What do you mean,"
	line "'Gyarados'?"

	para "BLASPHEMY!"

	para "I talk about its"
	line "former birth form."

	para "OK, you know what,"
	line "I'm done arguing"
	cont "with nonbelievers."

	para "<...>"

	para "What's that?"

	para "The path in the"
	line "forest is blocked?"

	para "HAHA!"

	para "<...> You know what."

	para "I'll tell that"
	line "fellow to move<...>"

	para "If you complete a"
	line "small task for me."

	para "I have the ability"
	line "to change you into"
	cont "a real Magikarp."

	para "--- really!"
	line "I do not lie!"

	para "In that legendary"
	line "form, you'll get"

	para "to experience what"
	line "Magikarp around"

	para "the world have to"
	line "deal with daily."

	para "That is, navigat-"
	line "ing in the rapids."

	para "Then, maybe you"
	line "won't think they"
	cont "are so 'weak'."

	para "Also, keep in mind"
	line "that once the task"

	para "begins, I will not"
	line "change you back"

	para "until you fully"
	line "complete the task."

	para "Do we have a deal?"
	done

MagikarpCavernsMainNPC1_Text_1625fd:
	ctxt "Good<...>"

	para "Go for it!"
	done

MagikarpCavernsMain_1609fc_Text_162611:
	ctxt "A well done job,"
	line "indeed."
	done

MagikarpCavernsMain_1609f9_Text_162552:
	ctxt "Suit yourself."

	para "Keep in mind, my"
	line "fellow worshiper"

	para "isn't going to"
	line "move without my"
	cont "permission."
	done

MagikarpCavernsMain_MapEventHeader:: db 0, 0

.Warps: db 16
	warp_def 11, 3, 8, MAGIKARP_CAVERNS_MAIN
	warp_def 3, 13, 3, MAGIKARP_CAVERNS_MAIN
	warp_def 15, 27, 2, MAGIKARP_CAVERNS_MAIN
	warp_def 7, 55, 7, MAGIKARP_CAVERNS_MAIN
	warp_def 19, 57, 14, MAGIKARP_CAVERNS_MAIN
	warp_def 23, 45, 11, MAGIKARP_CAVERNS_MAIN
	warp_def 21, 31, 4, MAGIKARP_CAVERNS_MAIN
	warp_def 37, 3, 1, MAGIKARP_CAVERNS_MAIN
	warp_def 45, 17, 12, MAGIKARP_CAVERNS_MAIN
	warp_def 47, 23, 13, MAGIKARP_CAVERNS_MAIN
	warp_def 31, 35, 6, MAGIKARP_CAVERNS_MAIN
	warp_def 29, 41, 9, MAGIKARP_CAVERNS_MAIN
	warp_def 29, 49, 10, MAGIKARP_CAVERNS_MAIN
	warp_def 57, 35, 5, MAGIKARP_CAVERNS_MAIN
	warp_def 57, 17, 3, LAUREL_CITY
	warp_def 9, 27, 1, ROUTE_87

.CoordEvents: db 0

.BGEvents: db 0

.ObjectEvents: db 5
	person_event SPRITE_POKE_BALL, 21, 17, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, MagikarpCavernsMain_Item_1, EVENT_MAGIKARP_CAVERNS_MAIN_ITEM_1
	person_event SPRITE_POKE_BALL, 21, 33, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 1, 0, MagikarpCavernsMain_Item_2, EVENT_MAGIKARP_CAVERNS_MAIN_ITEM_2
	person_event SPRITE_ELDER, 32, 18, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, MagikarpCavernsMainNPC1, -1
	person_event SPRITE_BOULDER, 25, 45, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, MagikarpCavernsMainNPC2, -1
	person_event SPRITE_ELDER, 10, 27, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, MagikarpCavernsMainNPC3, EVENT_RIJON_LEAGUE_WON
