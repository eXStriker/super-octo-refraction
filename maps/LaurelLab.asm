LaurelLab_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

LaurelLabSignpost1:
	jumpstd magazinebookshelf

LaurelLabSignpost2:
	jumpstd difficultbookshelf

LaurelLabNPC2:
	faceplayer
	opentext
	checkitem FOSSIL_CASE
	iftrue .skip_intro_text
	writetext LaurelLabNPC2_Text_15f880
	waitbutton
	verbosegiveitem FOSSIL_CASE
.skip_intro_text
	jumptext LaurelLabNPC2_Text_15f880_2

LaurelLabNPC1:
	faceplayer
	opentext
	writetext LaurelLab_15f4b0_Text_15f580
	yesorno
	iffalse LaurelLab_RefusedFossil
	takefossil
	anonjumptable
	dw LaurelLab_Lileep
	dw LaurelLab_Anorith
	dw LaurelLab_Cranidos
	dw LaurelLab_Shieldon
	dw LaurelLab_DontHaveFossil
	dw LaurelLab_DontHaveFossil

LaurelLabAppraiseFossil:
	pokenamemem 0, 0
	writetext LaurelLab_Lileep_Text_15f69b
	waitbutton
	writetext LaurelLab_Lileep_Text_15f6b2
	closetext
	spriteface 2, UP
	checkcode VAR_FACING
	anonjumptable
	dw .end
	dw .step_left_and_up
	dw .end
	dw .look_up

.step_left_and_up
	applymovement 0, LaurelLab_15f506_Movement1
.end
	end

.look_up
	applymovement 0, LaurelLab_15f50e_Movement1
	end

LaurelLab_Lileep:
	writebyte LILEEP
	scall LaurelLabAppraiseFossil
	writebyte 0
	special Special_UnownPuzzle
	iffalse LaurelLab_FailedUnownPuzzle
	givepoke LILEEP, 10
	jump LaurelLabRewardPlayerDialogue

LaurelLab_Anorith:
	writebyte ANORITH
	scall LaurelLabAppraiseFossil
	writebyte 1
	special Special_UnownPuzzle
	iffalse LaurelLab_FailedUnownPuzzle
	givepoke ANORITH, 10
	jump LaurelLabRewardPlayerDialogue

LaurelLab_Cranidos:
	writebyte CRANIDOS
	scall LaurelLabAppraiseFossil
	writebyte 2
	special Special_UnownPuzzle
	iffalse LaurelLab_FailedUnownPuzzle
	givepoke CRANIDOS, 10
	jump LaurelLabRewardPlayerDialogue

LaurelLab_Shieldon:
	writebyte SHIELDON
	scall LaurelLabAppraiseFossil
	writebyte 3
	special Special_UnownPuzzle
	iffalse LaurelLab_FailedUnownPuzzle
	givepoke SHIELDON, 10
LaurelLabRewardPlayerDialogue:
	scriptstartasm
	ld hl, wFossilsRevived
	inc [hl]
	jr nz, .done
	inc hl
	inc [hl]
	jr nz, .done
	ld a, $ff
	ld [hld], a
	ld [hl], a
.done
	scriptstopasm
	faceplayer
	opentext
	writetext LaurelLab_15f52f_Text_15f73e
	playwaitsfx SFX_DEX_FANFARE_140_169
	closetext
	end

LaurelLab_FailedUnownPuzzle:
	special RestartMapMusic
	jumptext LaurelLab_15f516_Text_15f715

LaurelLab_DontHaveFossil:
	jumptext LaurelLab_15f4cf_Text_15f610

LaurelLab_RefusedFossil:
	jumptext LaurelLab_15f4be_Text_15f644

LaurelLab_15f50e_Movement1:
	turn_head_up
	step_end

LaurelLab_15f506_Movement1:
	step_left
	step_up
	step_end

LaurelLabNPC2_Text_15f880:
	ctxt "I know about four"
	line "#mon fossils."

	para "Anorith comes from"
	line "a Claw Fossil."

	para "Lileep comes from"
	line "a Root Fossil."

	para "Cranidos comes"
	line "from a Skull"
	cont "Fossil."

	para "Shieldon comes"
	line "from an Armor"
	cont "Fossil."

	para "You can find"
	line "fossils by mining,"
	cont "so good luck!"

	para "Oh, but you need"
	line "somewhere safe to"
	cont "carry them."

	para "Here, try this."
	done

LaurelLabNPC2_Text_15f880_2:
	ctxt "If you mine up a"
	line "fossil, put it in"

	para "that Fossil Case"
	line "and bring it here!"
	done

LaurelLab_15f4b0_Text_15f580:
	ctxt "I am a scientist."

	para "That's right, a"
	line "SCIENTIST!"

	para "I invented a"
	line "machine to revive"
	cont "#mon fossils."

	para "Want me to try"
	line "the machine on"
	cont "yours?"
	done

LaurelLab_15f4be_Text_15f644:
	ctxt "What, you don't"
	line "trust<...>"

	para "A SCIENTIST?!"
	done

LaurelLab_15f4cf_Text_15f610:
	ctxt "You can't fool a"
	line "scientist, you"
	cont "don't have a"
	cont "fossil!"
	done

LaurelLab_Lileep_Text_15f69b:
	ctxt "Ah!"

	para "This is a"
	line "<STRBF1>!"
	done

LaurelLab_Lileep_Text_15f6b2:
	ctxt "I need you to"
	line "help me complete"
	cont "the process, come."
	prompt

LaurelLab_15f516_Text_15f715:
	ctxt "Good going."

	para "The fossil was"
	line "destroyed<...>"
	done

LaurelLab_15f52f_Text_15f73e:
	ctxt "We were"
	line "successful!"

	para "Here is your"
	line "<STRBF1>!"
	done

LaurelLab_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $b, $4, 5, LAUREL_CITY
	warp_def $b, $5, 5, LAUREL_CITY

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 1, 0, SIGNPOST_READ, LaurelLabSignpost1
	signpost 1, 1, SIGNPOST_READ, LaurelLabSignpost2

	;people-events
	db 2
	person_event SPRITE_SCIENTIST, 7, 9, SPRITEMOVEDATA_WALK_UP_DOWN, 1, 1, -1, -1, 8 + PAL_OW_GREEN, 0, 0, LaurelLabNPC1, -1
	person_event SPRITE_SCIENTIST, 6, 1, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, LaurelLabNPC2, -1
