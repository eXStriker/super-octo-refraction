HeathInn_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1

	dbw 5, HeathInnSetSpawnPoint

HeathInnSetSpawnPoint:
	blackoutmod HEATH_VILLAGE
	return

HeathInnSignpost1:
	jumpstd magazinebookshelf

HeathInnSignpost2:
	jumpstd magazinebookshelf

HeathInnNPC1:
	jumptextfaceplayer HeathInnNPC1_Text_1556a5

HeathInnNPC2:
	opentext
	special PlaceMoneyTopRight
	writetext HeathInnNPC2_Text_1555b0
	yesorno
	iftrue HeathInn_1557f9
	jumptext HeathInn_1557f4_Text_15566d

HeathInnNPC3:
	opentext
	pokemart 0, 6
	closetext
	end

HeathInn_1557f9:
	checkmoney 0, 100
	if_equal 2, HeathInn_15580b

HeathInn_155810:
	writetext HeathInn_155810_Text_155622
	special ClearBGPalettes
	playwaitsfx SFX_SNORE
	pause 20
	playwaitsfx SFX_SNORE
	pause 20
	playwaitsfx SFX_SNORE
	pause 20
	playwaitsfx SFX_SNORE
	pause 20
	special HealParty
	reloadmap
	takemoney 0, 100
	jumptext HeathInn_155810_Text_155640

HeathInn_15580b:
	jumptext HeathInn_15580b_Text_1555fa

HeathInnNPC1_Text_1556a5:
	ctxt "This village is"
	line "purely family-run."

	para "It only consists"
	line "of family members"
	para "and has stayed"
	line "that way for"
	cont "centuries now."

	para "My cousin Rinji"
	line "often takes our"
	para "children into his"
	line "forest to become"
	cont "#mon Trainers."

	para "My grandmother"
	line "manages the rooms"
	cont "in this very inn,"

	para "and my brother"
	line "runs the shop."
	done

HeathInnNPC2_Text_1555b0:
	ctxt "Oh dear, you and"
	line "your #mon look"
	cont "tired."

	para "I'll let you rent"
	line "a room for ¥100."
	done

HeathInn_1557f4_Text_15566d:
	ctxt "Oh OK then, you're"
	line "always welcome"
	para "to stay if you'd"
	line "like."
	done

HeathInn_155810_Text_155622:
	ctxt "Thank you, have"
	line "a good rest!"
	prompt

HeathInn_155810_Text_155640:
	ctxt "Welcome back, I"
	line "hope you enjoyed"
	cont "your stay."
	done

HeathInn_15580b_Text_1555fa:
	ctxt "I'm afraid your"
	line "wallet is nearly"
	cont "empty."
	done

HeathInn_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $9, $9, 5, HEATH_VILLAGE
	warp_def $9, $a, 5, HEATH_VILLAGE

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 1, 14, SIGNPOST_READ, HeathInnSignpost1
	signpost 1, 3, SIGNPOST_READ, HeathInnSignpost2

	;people-events
	db 3
	person_event SPRITE_BLACK_BELT, 6, 11, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, HeathInnNPC1, -1
	person_event SPRITE_GRANNY, 4, 17, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, HeathInnNPC2, -1
	person_event SPRITE_YOUNGSTER, 4, 1, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_PLAYER, 0, 0, HeathInnNPC3, -1
