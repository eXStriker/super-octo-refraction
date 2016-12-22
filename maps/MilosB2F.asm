MilosB2F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw MAPCALLBACK_TILES, SetBlocks

SetBlocks:
	checkevent EVENT_0
	iffalse .skip1
	scall MilosB2F_RedOff
.skip1
	checkevent EVENT_1
	iffalse .skip2
	scall MilosB2F_YellowOff
.skip2
	checkevent EVENT_2
	iffalse .skip3
	scall MilosB2F_GreenOff
.skip3
	checkevent EVENT_3
	iffalse .skip4
	scall MilosB2F_BrownOff
.skip4
	return

MilosB2FTrap1:
	spriteface 0, 0
	playsound SFX_RETURN
	showemote 0, 0, 32
	applymovement 0, MilosB2FTrap1_Movement1
	playsound SFX_STRENGTH
	earthquake 16
	end

MilosB2FTrap1_Movement1:
	fast_slide_step_down
	fast_slide_step_down
	fast_slide_step_down
	fast_slide_step_down
	fast_slide_step_down
	fast_slide_step_down
	step_end

MilosB2FTrap2:
	spriteface 0, 0
	playsound SFX_RETURN
	showemote 0, 0, 32
	applymovement 0, MilosB2FTrap2_Movement1
	playsound SFX_STRENGTH
	earthquake 16
	end

MilosB2FTrap2_Movement1:
	fast_slide_step_down
	fast_slide_step_down
	fast_slide_step_down
	fast_slide_step_down
	step_end

MilosB2FTrap3:
	spriteface 0, 0
	playsound SFX_RETURN
	showemote 0, 0, 32
	applymovement 0, MilosB2FTrap3_Movement1
	playsound SFX_STRENGTH
	earthquake 16
	end

MilosB2FTrap3_Movement1:
	fast_slide_step_down
	fast_slide_step_down
	fast_slide_step_down
	fast_slide_step_down
	fast_slide_step_down
	fast_slide_step_down
	step_end

MilosB2FSignpost1:
MilosB2FSignpost2:
	jumptext MilosB2FSignpost1_Text_14f000

MilosB2FSignpost3:
	opentext
	writetext MilosB2FSignpost3_Text_14efa8
	waitbutton
	playwaitsfx SFX_STOP_SLOT
	milosswitch EVENT_2, MilosB2F_GreenOff, MilosB2F_GreenOn
	reloadmappart
	closetext
	end

MilosB2FSignpost4:
	opentext
	writetext MilosB2FSignpost3_Text_14efa8
	waitbutton
	playwaitsfx SFX_STOP_SLOT
	milosswitch EVENT_0, MilosB2F_RedOff, MilosB2F_RedOn
	reloadmappart
	closetext
	end

MilosB2FSignpost5:
	opentext
	writetext MilosB2FSignpost3_Text_14efa8
	waitbutton
	playwaitsfx SFX_STOP_SLOT
	milosswitch EVENT_1, MilosB2F_YellowOff, MilosB2F_YellowOn
	reloadmappart
	closetext
	end

MilosB2FSignpost6:
	opentext
	writetext MilosB2FSignpost3_Text_14efa8
	waitbutton
	playwaitsfx SFX_STOP_SLOT
	milosswitch EVENT_3, MilosB2F_BrownOff, MilosB2F_BrownOn
	reloadmappart
	closetext
	end

MilosB2FSignpost7:
MilosB2FSignpost8:
	jumptext MilosB2FSignpost7_Text_14e594

MilosB2FSignpost9:
MilosB2FSignpost10:
	jumptext MilosB2FSignpost9_Text_14e55e


MilosB2FSignpost11:
MilosB2FSignpost12:
	jumptext MilosB2FSignpost11_Text_14e577

MilosB2FSignpost13:
	checkevent EVENT_JUMPING_SHOES
	sif false
		end
	checkevent EVENT_3
	sif false
		end
	jump MilosB2FJump

MilosB2FSignpost14:
	checkevent EVENT_JUMPING_SHOES
	sif false
		end
	checkevent EVENT_3
	sif false
		end
	checkevent EVENT_2
	sif false
		end

MilosB2FJump:
	playsound SFX_JUMP_OVER_LEDGE
	checkcode VAR_FACING
	sif >, 3
		writebyte 0
	anonjumptable
	dw .facing_down
	dw .facing_up
	dw .facing_left
	dw .facing_right
.facing_down
.facing_up
	end
.facing_left
	applymovement 0, .left_movement
	end
.facing_right
	applymovement 0, .right_movement
	end
.left_movement
	jump_step_left
	step_end
.right_movement
	jump_step_right
	step_end

MilosB2F_Item_1:
	db PROTECTOR, 1

MilosB2F_Item_2:
	db OLD_ROD, 1

MilosB2F_Trainer_1:
	trainer EVENT_MILOS_B2F_TRAINER_1, PATROLLER, 7, MilosB2F_Trainer_1_Text_14e69c, MilosB2F_Trainer_1_Text_14e731, $0000, .Script

.Script:
	jumptext MilosB2F_Trainer_1_Script_Text_14e760

MilosB2F_Trainer_2:
	trainer EVENT_MILOS_B2F_TRAINER_2, PATROLLER, 10, MilosB2F_Trainer_2_Text_14e5bd, MilosB2F_Trainer_2_Text_14e614, $0000, .Script

.Script:
	jumptext MilosB2F_Trainer_2_Script_Text_14e652

MilosB2F_GreenOff:
	changeblock 26, 10, $36
	changeblock 30, 12, $51
	changeblock 30, 10, $52
	changeblock 32, 22, $50
	end

MilosB2F_RedOff:
	changeblock 12, 16, $51
	changeblock 12, 14, $52
	changeblock 0, 16, $6b
	end

MilosB2F_YellowOff:
	changeblock 14, 22, $77
	changeblock 22, 10, $51
	changeblock 22, 8, $52
	changeblock 24, 16, $50
	changeblock 26, 16, $50
	end

MilosB2F_BrownOff:
	changeblock 30, 4, $32
	changeblock 32, 8, $37
	changeblock 32, 12, $37
	changeblock 30, 20, $52
	changeblock 30, 22, $51
	changeblock 36, 14, $52
	changeblock 36, 16, $51
	end

MilosB2F_GreenOn:
	changeblock 26, 10, $7b
	changeblock 30, 12, $2f
	changeblock 30, 10, $30
	changeblock 32, 22, $4c
	end

MilosB2F_RedOn:
	changeblock 12, 16, $68
	changeblock 12, 14, $67
	changeblock 0, 16, $6a
	end

MilosB2F_YellowOn:
	changeblock 14, 22, $76
	changeblock 22, 10, $7e
	changeblock 22, 8, $7d
	changeblock 24, 16, $2e
	changeblock 26, 16, $2e
	end

MilosB2F_BrownOn:
	changeblock 30, 4, $33
	changeblock 32, 8, $4d
	changeblock 32, 12, $4d
	changeblock 30, 20, $49
	changeblock 30, 22, $48
	changeblock 36, 14, $49
	changeblock 36, 16, $48
	end

MilosB2FSignpost1_Text_14f000:
	ctxt "Colored switches"
	line "will change if"
	cont "blocks of the same"
	cont "color appear or"
	cont "not."
	done

MilosB2FSignpost3_Text_14efa8:
	ctxt "<PLAYER> pulled"
	line "the switch!"
	done

MilosB2FSignpost7_Text_14e594:
	ctxt "fac fortia et"
	line "patere"
	done

MilosB2FSignpost9_Text_14e55e:
	ctxt "sic parvis magna"
	done

MilosB2FSignpost11_Text_14e577:
	ctxt "bis dat qui cito"
	line "dat"
	done

MilosB2FSignpost13_Text_14c7cc:
	ctxt "Dragons are weak"
	line "against dragon-"
	cont "type moves."
	done

MilosB2F_Trainer_1_Text_14e69c:
	ctxt "There's a rare"
	line "item somewhere"
	cont "in this dump!"

	para "If we get that,"
	line "Red will be very"
	cont "pleased with us."
	done

MilosB2F_Trainer_1_Text_14e731:
	ctxt "I don't get it."

	para "You don't even see"
	line "us as a threat<...>"
	done

MilosB2F_Trainer_1_Script_Text_14e760:
	ctxt "Red is trying to"
	line "collect strange"

	para "orb shards from"
	line "around the region."
	done

MilosB2F_Trainer_2_Text_14e5bd:
	ctxt "I'm much better"
	line "prepared this"
	cont "time around."

	para "You better stop"
	line "pestering us, so"
	cont "Red may continue"
	cont "with his plans."
	done

MilosB2F_Trainer_2_Text_14e614:
	ctxt "Can't you just"
	line "let me win?"

	para "I don't wanna be"
	line "an intern forever."
	done

MilosB2F_Trainer_2_Script_Text_14e652:
	ctxt "I won't gain any"
	line "respect if I keep"
	cont "losing to kids!"
	done

MilosB2F_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $5, $1, 2, MILOS_B1F
	warp_def $5, $27, 7, MILOS_F1
	warp_def $4, $f, 5, MILOS_B1F

	;xy triggers
	db 3
	xy_trigger 0, $4, $15, $0, MilosB2FTrap1, $0, $0
	xy_trigger 0, $8, $25, $0, MilosB2FTrap2, $0, $0
	xy_trigger 0, $4, $d, $0, MilosB2FTrap3, $0, $0

	;signposts
	db 14
	signpost  6,  7, SIGNPOST_READ,  MilosB2FSignpost1
	signpost  5,  7, SIGNPOST_UP,    MilosB2FSignpost2
	signpost 10, 27, SIGNPOST_RIGHT, MilosB2FSignpost3
	signpost 16,  0, SIGNPOST_LEFT,  MilosB2FSignpost4
	signpost 22, 14, SIGNPOST_LEFT,  MilosB2FSignpost5
	signpost  4, 31, SIGNPOST_RIGHT, MilosB2FSignpost6
	signpost  4, 23, SIGNPOST_READ,  MilosB2FSignpost7
	signpost  3, 23, SIGNPOST_UP,    MilosB2FSignpost8
	signpost 16, 17, SIGNPOST_READ,  MilosB2FSignpost9
	signpost 15, 17, SIGNPOST_UP,    MilosB2FSignpost10
	signpost 24,  1, SIGNPOST_READ,  MilosB2FSignpost11
	signpost 23,  1, SIGNPOST_UP,    MilosB2FSignpost12
	signpost  8, 32, SIGNPOST_READ,  MilosB2FSignpost13
	signpost 12, 32, SIGNPOST_READ,  MilosB2FSignpost14

	;people-events
	db 5
	person_event SPRITE_POKE_BALL, 24, 0, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, MilosB2F_Item_1, EVENT_MILOS_B2F_ITEM_1
	person_event SPRITE_POKE_BALL, 12, 18, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 0, MilosB2F_Item_2, EVENT_MILOS_B2F_ITEM_2
	person_event SPRITE_PALETTE_PATROLLER, 24, 21, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_PURPLE, 2, 1, MilosB2F_Trainer_1, EVENT_MILOS_B2F_TRAINER_1
	person_event SPRITE_PALETTE_PATROLLER, 12, 28, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 1, MilosB2F_Trainer_2, EVENT_MILOS_B2F_TRAINER_2
	person_event SPRITE_POKE_BALL, 4, 16, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 3, TM_SEISMIC_TOSS, 0, EVENT_MILOS_B2F_NPC_1
