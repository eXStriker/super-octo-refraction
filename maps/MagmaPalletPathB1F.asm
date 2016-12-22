MagmaPalletPathB1F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MagmaPalletPathB1FNPC1:
	faceplayer
	opentext
	checkevent EVENT_NOBUS_AGGRON_IN_PARTY
	iftrue MagmaPalletPathB1F_112553
	jumptext MagmaPalletPathB1FNPC1_Text_11259e

MagmaPalletPathB1F_Item_1:
	db PP_UP, 1

MagmaPalletPathB1FNPC4:
	jumpstd strengthboulder

MagmaPalletPathB1F_112553:
	writetext MagmaPalletPathB1F_112553_Text_11261b
	waitbutton
	special SpecialReturnNobusAggron
	anonjumptable
	dw MagmaPalletPathB1F_112592
	dw MagmaPalletPathB1F_112592
	dw MagmaPalletPathB1f_GaveBackAggron
	dw MagmaPalletPathB1F_112598

MagmaPalletPathB1f_GaveBackAggron:
	closetext
	appear $3
	cry AGGRON
	waitsfx
	opentext
	writetext MagmaPalletPathB1F_112553_Text_112643
	waitbutton
	closetext
	applymovement 0, MagmaPalletPathB1F_112553_Movement1
	applymovement 3, MagmaPalletPathB1F_112553_Movement2
	follow 3, 2
	applymovement 3, MagmaPalletPathB1F_112553_Movement3
	stopfollow
	disappear 3
	disappear 2
	playsound SFX_EXIT_BUILDING

	setevent EVENT_AGGRON_NOT_IN_MAGMA
	clearevent EVENT_NOBUS_AGGRON_IN_PARTY
	clearevent EVENT_NOBU_NOT_IN_HOUSE
	waitsfx
	end

MagmaPalletPathB1F_112553_Movement1:
	step_down
	step_right
	step_end

MagmaPalletPathB1F_112553_Movement2:
	step_left
	step_end

MagmaPalletPathB1F_112553_Movement3:
	step_down
	step_down
	step_down
	step_down
	step_down
	step_down
	step_down
	step_end

MagmaPalletPathB1F_112592:
	jumptext MagmaPalletPathB1F_112592_Text_1127dd

MagmaPalletPathB1F_112598:
	jumptext MagmaPalletPathB1F_112598_Text_1127fe

MagmaPalletPathB1FNPC1_Text_11259e:
	ctxt "Young one, please!"
	line "Can you help!"

	para "<...> ugh."

	para "I can't move<...>"

	para "My friend possess-"
	line "es a strong body,"
	cont "made of steel."

	para "He'd be able to"
	line "carry me home."

	para "Please, could you"
	line "bring him here?"

	para "He's currently"
	line "at our home on"
	para "Route 80, likely"
	line "taking a rest."

	para "Please hurry!"
	done

MagmaPalletPathB1F_112553_Text_11261b:
	ctxt "Did you manage"
	line "to find my friend?"

	para "<...>"

	para "Thank goodness!"
	done

MagmaPalletPathB1F_112553_Text_112643:
	ctxt "Thank you, my"
	line "friend will now"
	cont "return me home."

	para "However, I still"
	line "need your help."

	para "At the end of this"
	line "tunnel lie the"
	para "resting grounds"
	line "of a powerful"
	cont "Naljo guardian."

	para "Fools wearing"
	line "traditional Naljo"
	para "garbs are trying"
	line "to revive it!"

	para "They desire to"
	line "awaken the Naljo"
	para "Guardians, in"
	line "order to bring"
	para "Naljo back to"
	line "what it used to"
	para "be hundreds of"
	line "years ago."

	para "They don't know"
	line "that the Guardians"

	para "will kill everyone"
	line "in Naljo who don't"

	para "possess the blood-"
	line "line of the first"
	cont "Naljo generation."

	para "Innocent people"
	line "and #mon will"

	para "all perish if"
	line "it wakes up!"

	para "Please, stop them"
	line "at all costs!"
	done

MagmaPalletPathB1F_112592_Text_1127dd:
	ctxt "It's unwise to"
	line "tease an old man."
	done

MagmaPalletPathB1F_112598_Text_1127fe:
	ctxt "Even though I'm in"
	line "pain right now,"

	para "I know that it"
	line "could be dangerous"

	para "to be in this cave"
	line "without a #mon."

	para "Bring some more"
	line "#mon with you"
	cont "and come back."
	done

MagmaPalletPathB1F_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $21, $25, 1, MAGMA_ROOMS
	warp_def $9, $7, 3, MAGMA_PALLETPATH_1F

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 5
	person_event SPRITE_SAGE, 23, 36, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_GREEN, 0, 1, MagmaPalletPathB1FNPC1, EVENT_RESCUED_NOBU
	person_event SPRITE_AGGRON, 24, 37, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_SILVER, 0, 0, ObjectEvent, EVENT_AGGRON_NOT_IN_MAGMA
	person_event SPRITE_POKE_BALL, 5, 23, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_PURPLE, 1, 0, MagmaPalletPathB1F_Item_1, EVENT_MAGMA_PALLETPATH_B1F_ITEM_1
	person_event SPRITE_POKE_BALL, 17, 37, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 3, TM_DUST_DEVIL, 0, EVENT_MAGMA_PALLETPATH_B1F_NPC_3
	person_event SPRITE_BOULDER, 21, 33, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, MagmaPalletPathB1FNPC4, -1
