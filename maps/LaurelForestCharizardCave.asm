LaurelForestCharizardCave_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

LaurelForestCharizardCaveSignpost1:
	checkevent EVENT_0
	sif true
		jumptext LaurelForestCharizardCave_146f8c_Text_14753b
	opentext
	writetext LaurelForestCharizardCaveSignpost1_Text_147520
	waitbutton
	closetext
	playsound SFX_STRENGTH
	changemap BANK(LaurelForestCharizardCaveSignpost1_BlockData1), LaurelForestCharizardCaveSignpost1_BlockData1
	reloadmappart
	waitsfx
	setevent EVENT_0
	end

LaurelForestCharizardCaveSignpost2:
	checkevent EVENT_0
	sif false
		jumptext LaurelForestCharizardCave_146f8c_Text_14753b
	opentext
	writetext LaurelForestCharizardCaveSignpost1_Text_147520
	waitbutton
	closetext
	playsound SFX_STRENGTH
	changemap BANK(LaurelForestCharizardCaveSignpost2_BlockData1), LaurelForestCharizardCaveSignpost2_BlockData1
	reloadmappart
	waitsfx
	clearevent EVENT_0
	end

LaurelForestCharizardCaveNPC1:
	faceplayer
	cry CHARMANDER
	waitsfx
	jumptext LaurelForestCharizardCaveNPC1_Text_1474e9

LaurelForestCharizardCaveNPC2:
	faceplayer
	cry CHARIZARD
	waitsfx
	jumptext LaurelForestCharizardCaveNPC2_Text_147481

LaurelForestCharizardCaveNPC3:
	faceplayer
	cry CHARIZARD
	waitsfx
	faceplayer
	checkevent EVENT_POKEONLY_CHARMANDER_TRAPPED
	sif true
		jumptext LaurelForestCharizardCave_146f78_Text_147021
	checkevent EVENT_POKEONLY_CHARIZARD_MOVED_BOULDER
	sif true
		jumptext LaurelForestCharizardCave_146f75_Text_1473b6
	opentext
	writetext LaurelForestCharizardCaveNPC3_Text_1470c0
	waitbutton
	closetext
	applymovement 4, LaurelForestCharizardCaveNPC3_Movement1
	applymovement 8, LaurelForestCharizardCaveNPC3_Movement2
	disappear 8
	playsound SFX_STRENGTH
	earthquake 80
	applymovement 4, LaurelForestCharizardCaveNPC3_Movement3
	setevent EVENT_POKEONLY_CHARIZARD_MOVED_BOULDER
	closetext
	end

LaurelForestCharizardCaveNPC3_Movement1:
	fast_jump_step_right
	big_step_up
	big_step_up
	big_step_left
	big_step_left
	big_step_left
	big_step_left
	big_step_up
	turn_head_left
	step_end

LaurelForestCharizardCaveNPC3_Movement2:
	big_step_right
	big_step_up
	fast_jump_step_left
	step_38
	step_end

LaurelForestCharizardCaveNPC3_Movement3:
	big_step_right
	big_step_right
	big_step_right
	big_step_right
	big_step_down
	big_step_down
	big_step_down
	fast_jump_step_left
	turn_head_down
	step_end

LaurelForestCharizardCave_Item_CuroShard:
	db CURO_SHARD, 1

LaurelForestCharizardCaveNPC5_Item_MiningPick:
	db MINING_PICK, 3

LaurelForestCharizardCaveNPC6:
	jumpstd smashrock

LaurelForestCharizardCaveNPC7:
	jumptext LaurelForestCharizardCaveNPC7_Text_147000

LaurelForestCharizardCave_14632e:
	jumptext LaurelForestCharizardCave_146fbb_Text_146fd8

LaurelForestCharizardCave_146fbb:
	jumptext LaurelForestCharizardCave_146fbb_Text_146fd8

LaurelForestCharizardCaveSignpost1_Text_147520:
	ctxt "You pushed the"
	line "button."
	done

LaurelForestCharizardCaveNPC1_Text_1474e9:
	ctxt "That was close,"
	line "thank goodness!"

	para "I was saved!" 
	done

LaurelForestCharizardCaveNPC2_Text_147481:
	ctxt "I often question"
	line "how my partner"
	para "want to raise our"
	line "child<...>"

	para "but you must"
	line "understand that"
	para "this is tradition"
	line "in his family."
	done

LaurelForestCharizardCaveNPC3_Text_1470c0:
	ctxt "I'm disappointed"
	line "in my son<...>"

	para "He needed outside"
	line "help to get home,"

	para "rather than just"
	line "simply swimming"
	cont "across the water."

	para "I guess he can't"
	line "swim<...>"

	para "and it's good that"
	line "we found out."

	para "<...>"

	para "What do you mean,"
	line "'you're looking"
	cont "for Curo Shards'?"

	para "Some scientists"
	line "chained us down"
	para "recently just to"
	line "dig out a tunnel."

	para "Of course, I was"
	line "able to break out"
	para "alone and free my"
	line "partner just fine."

	para "I was hoping my"
	line "child would manage"
	para "to free himself,"
	line "and show his inner"
	cont "strength, but<...>"

	para "Anyway, putting"
	line "parenting aside<...>"

	para "I remember one of"
	line "them going on and"
	para "on about how he"
	line "lost some shard,"

	para "so maybe it's in"
	line "that tunnel?"

	para "I blocked it off"
	line "to keep my son"
	cont "from exploring."

	para "If you want to go"
	line "down there and"
	para "play with<...>"
	line "whatever those"
	para "human scums made,"
	line "be my guest."

	para "I'll clear it for"
	line "you, because only"
	para "someone as strong"
	line "as I can."
	done

LaurelForestCharizardCaveNPC7_Text_147000:
	ctxt "A heavy boulder"
	line "blocks the way."
	done

LaurelForestCharizardCave_146f8c_Text_14753b:
	ctxt "The button has al-"
	line "ready been pushed."
	done

LaurelForestCharizardCave_146f78_Text_147021:
	ctxt "Yes, I know my son"
	line "is still stuck on"
	cont "the other side."

	para "He needs to learn"
	line "how to survive"
	cont "for himself!"
	done

LaurelForestCharizardCave_146f75_Text_1473b6:
	ctxt "These humans may"
	line "be annoying and"
	cont "pathetic, but<...>"

	para "They are pushing"
	line "my offspring to"
	para "the limit, much"
	line "further than I"
	para "was pushed by my"
	line "own father."

	para "We will keep"
	line "the honorable"
	para "bloodline of our"
	line "family going"
	cont "forever."
	done

LaurelForestCharizardCave_146fbb_Text_146fd8:
	ctxt "Free some space!"
	done

LaurelForestCharizardCaveSignpost1_BlockData1:
INCBIN "./maps/LaurelForestCharizardCaveSignpost1_BlockData1.blk.lz"

LaurelForestCharizardCaveSignpost2_BlockData1:
INCBIN "./maps/LaurelForestCharizardCaveSignpost2_BlockData1.blk.lz"

LaurelForestCharizardCave_MapEventHeader:: db 0, 0

.Warps: db 7
	warp_def 17, 9, 4, LAUREL_FOREST_POKEMON_ONLY
	warp_def 5, 3, 7, LAUREL_FOREST_CHARIZARD_CAVE
	warp_def 3, 7, 4, LAUREL_FOREST_CHARIZARD_CAVE
	warp_def 3, 37, 3, LAUREL_FOREST_CHARIZARD_CAVE
	warp_def 23, 22, 6, LAUREL_FOREST_CHARIZARD_CAVE
	warp_def 14, 10, 5, LAUREL_FOREST_CHARIZARD_CAVE
	warp_def 27, 5, 2, LAUREL_FOREST_CHARIZARD_CAVE

.CoordEvents: db 0

.BGEvents: db 5
	signpost 1, 27, SIGNPOST_READ, LaurelForestCharizardCaveSignpost1
	signpost 9, 37, SIGNPOST_READ, LaurelForestCharizardCaveSignpost2
	signpost 15, 37, SIGNPOST_READ, LaurelForestCharizardCaveSignpost1
	signpost 21, 27, SIGNPOST_READ, LaurelForestCharizardCaveSignpost1
	signpost 21, 23, SIGNPOST_READ, LaurelForestCharizardCaveSignpost2

.ObjectEvents: db 7
	person_event SPRITE_CHARMANDER, 14, 14, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, LaurelForestCharizardCaveNPC1, EVENT_POKEONLY_CHARMANDER_TRAPPED
	person_event SPRITE_DRAGON, 6, 7, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, LaurelForestCharizardCaveNPC2, -1
	person_event SPRITE_DRAGON, 5, 12, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, LaurelForestCharizardCaveNPC3, -1
	person_event SPRITE_POKE_BALL, 20, 34, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 1, 0, LaurelForestCharizardCave_Item_CuroShard, EVENT_LAUREL_POKEMONONLY_CUROSHARD_CHARIZARD
	person_event SPRITE_POKE_BALL, 24, 4, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 1, 0, LaurelForestCharizardCaveNPC5_Item_MiningPick, EVENT_LAUREL_POKEMONONLY_MININGPICKS
	person_event SPRITE_ROCK, 8, 3, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, LaurelForestCharizardCaveNPC6, -1
	person_event SPRITE_BOULDER, 2, 9, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, LaurelForestCharizardCaveNPC7, EVENT_POKEONLY_CHARIZARD_MOVED_BOULDER
