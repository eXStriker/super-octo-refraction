MilosB2Fb_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw MAPCALLBACK_TILES, SetBlocksB2fb

SetBlocksB2fb:
	checkevent EVENT_0
	iffalse .skip1B2fb
	scall MilosB2Fb_RedOff
.skip1B2fb
	checkevent EVENT_1
	iffalse .skip2B2fb
	scall MilosB2Fb_YellowOff
.skip2B2fb
	checkevent EVENT_2
	iffalse .skip3B2fb
	scall MilosB2Fb_GreenOff
.skip3B2fb
	checkevent EVENT_3
	iffalse .skip4B2fb
	scall MilosB2Fb_BrownOff
.skip4B2fb
	return

MilosB2Fb_RedOn:
	changeblock $c, $6, $6a
	changeblock $8, $a, $6a
	changeblock $0, $12, $6a
	changeblock $12, $16, $6a
	changeblock $8, $1e, $6a
	changeblock $c, $8, $67
	changeblock $c, $a, $68
	changeblock $4, $10, $67
	changeblock $4, $12, $68
	changeblock $12, $18, $67
	changeblock $12, $1a, $68
	changeblock $4, $6, $83
	changeblock $18, $16, $83
	changeblock $c, $1e, $83
	end

MilosB2Fb_RedOff:
	changeblock $c, $6, $6b
	changeblock $8, $a, $6b
	changeblock $0, $12, $6b
	changeblock $12, $16, $6b
	changeblock $8, $1e, $6b
	changeblock $c, $8, $52
	changeblock $c, $a, $51
	changeblock $4, $10, $52
	changeblock $4, $12, $51
	changeblock $12, $18, $52
	changeblock $12, $1a, $51
	changeblock $4, $6, $50
	changeblock $18, $16, $50
	changeblock $c, $1e, $50
	end

MilosB2Fb_YellowOn:
	changeblock $4, $16, $76
	changeblock $c, $14, $7d
	changeblock $c, $16, $7e
	changeblock $2, $1a, $7d
	changeblock $2, $1c, $7e
	end

MilosB2Fb_YellowOff:
	changeblock $4, $16, $77
	changeblock $c, $14, $52
	changeblock $c, $16, $51
	changeblock $2, $1a, $52
	changeblock $2, $1c, $51
	end

MilosB2Fb_GreenOn:
	changeblock $c, $12, $7b
	changeblock $6, $1a, $4c
	changeblock $30, $18, $30
	end

MilosB2Fb_GreenOff:
	changeblock $c, $12, $36
	changeblock $6, $1a, $50
	changeblock $30, $18, $52
	changeblock $30, $1a, $51
	end

MilosB2Fb_BrownOn:
	changeblock $10, $16, $33
	changeblock $12, $1e, $33
	changeblock $12, $22, $4d
	changeblock $a, $12, $4d
	changeblock $8, $18, $49
	changeblock $8, $1a, $48
	end

MilosB2Fb_BrownOff:
	changeblock $10, $16, $32
	changeblock $12, $1e, $32
	changeblock $12, $22, $82
	changeblock $a, $12, $82
	changeblock $8, $18, $52
	changeblock $8, $1a, $51
	end

MilosB2FbSignpost1:
MilosB2FbSignpost2:
MilosB2FbSignpost3:
MilosB2FbSignpost4:
MilosB2FbSignpost5:
	opentext
	writetext MilosB2FbSignpost1_Text_122b55
	playwaitsfx SFX_STOP_SLOT
	scall MilosB2Fb_122ad3
	reloadmappart
	closetext
	end

MilosB2FbSignpost6:
	opentext
	writetext MilosB2FbSignpost6_Text_122c18
	playwaitsfx SFX_STOP_SLOT
	scall MilosB2Fb_122bde
	reloadmappart
	closetext
	end

MilosB2FbSignpost7:
	opentext
	writetext MilosB2FbSignpost7_Text_122c6a
	playwaitsfx SFX_STOP_SLOT
	scall MilosB2Fb_122c38
	reloadmappart
	closetext
	end

MilosB2FbSignpost9:
MilosB2FbSignpost8:
	opentext
	writetext MilosB2FbSignpost8_Text_122ccb
	playwaitsfx SFX_STOP_SLOT
	scall MilosB2Fb_122c89
	reloadmappart
	closetext
	end

MilosB2FbSignpost10:
MilosB2FbSignpost11:
	jumptext MilosB2FbSignpost10_Text_123101

MilosB2FbSignpost12:
MilosB2FbSignpost13:
	jumptext MilosB2FbSignpost12_Text_123118

MilosB2FbSignpost14:
MilosB2FbSignpost15:
	jumptext MilosB2FbSignpost14_Text_123139

MilosB2FbSignpost16:
MilosB2FbSignpost17:
	jumptext MilosB2FbSignpost16_Text_12314f

MilosB2FbNPC1:
	opentext
	writetext MilosB2FbNPC1_Text_122d0e
	playwaitsfx SFX_DEX_FANFARE_80_109
	disappear 2
	writetext MilosB2FbNPC1_Text_122d2c
	waitbutton
	setevent EVENT_JUMPING_SHOES
	playsound SFX_STRENGTH
	scall MilosB2Fb_122ad3
	scall MilosB2Fb_122bde
	scall MilosB2Fb_122c38
	scall MilosB2Fb_122c89
	reloadmappart
	earthquake 20
	jumptext MilosB2Fb_123890_Text_122d62

MilosB2Fb_Item_1:
	db SACRED_ASH, 1

MilosB2Fb_Item_2:
	db DAWN_STONE, 1

MilosB2Fb_Trainer_1:
	trainer EVENT_MILOS_B2FB_TRAINER_1, PATROLLER, 13, MilosB2Fb_Trainer_1_Text_123570, MilosB2Fb_Trainer_1_Text_1235e1, $0000, .Script

.Script:
	jumptext MilosB2Fb_Trainer_1_Script_Text_123602

MilosB2Fb_Trainer_2:
	trainer EVENT_MILOS_B2FB_TRAINER_2, PATROLLER, 2, MilosB2Fb_Trainer_2_Text_1234dc, MilosB2Fb_Trainer_2_Text_12351b, $0000, .Script

.Script:
	jumptext MilosB2Fb_Trainer_2_Script_Text_123530

MilosB2Fb_122ad3:
	milosswitch EVENT_0, MilosB2Fb_RedOff, MilosB2Fb_RedOn
	end

MilosB2Fb_122bde:
	milosswitch EVENT_1, MilosB2Fb_YellowOff, MilosB2Fb_YellowOn
	end

MilosB2Fb_122c38:
	milosswitch EVENT_2, MilosB2Fb_GreenOff, MilosB2Fb_GreenOn
	end

MilosB2Fb_122c89:
	milosswitch EVENT_3, MilosB2Fb_BrownOff, MilosB2Fb_BrownOn
	end

MilosB2Fb_123890:
	jumptext MilosB2Fb_123890_Text_122d62

MilosB2FbSignpost1_Text_122b55:
	ctxt "Pulled the Red"
	line "Switch!"
	prompt

MilosB2FbSignpost6_Text_122c18:
	ctxt "Pulled the Yellow"
	line "Switch!"
	prompt

MilosB2FbSignpost7_Text_122c6a:
	ctxt "Pulled the Green"
	line "Switch!"
	prompt

MilosB2FbSignpost8_Text_122ccb:
	ctxt "Pulled the Brown"
	line "Switch!"
	prompt

MilosB2FbSignpost10_Text_123101:
	ctxt "invictus maneo"
	done

MilosB2FbSignpost12_Text_123118:
	ctxt "non progredi est"
	line "regredi"
	done

MilosB2FbSignpost14_Text_123139:
	ctxt "semper fortis"
	done

MilosB2FbSignpost16_Text_12314f:
	ctxt "honor virtutis"
	line "praemium"
	done

MilosB2FbNPC1_Text_122d0e:
	ctxt "You found the"
	line "jumping shoes!"
	done

MilosB2FbNPC1_Text_122d2c:
	ctxt "When you reach a"
	line "small gap, press"
	cont "A to jump over"
	cont "it!"
	done

MilosB2Fb_Trainer_1_Text_123570:
	ctxt "Oh, it's you again."

	para "I saw this coming."

	para "We all did."

	para "If you think for"
	line "a second you're"
	cont "getting past me,"

	para "then you'll be"
	line "sadly mistaken."
	done

MilosB2Fb_Trainer_1_Text_1235e1:
	ctxt "That's pathetic."

	para "You're pathetic."
	done

MilosB2Fb_Trainer_1_Script_Text_123602:
	ctxt "Cut the optimism,"
	line "you need a real"
	cont "reality check."

	para "Just who are you"
	line "without your dear"
	cont "#mon, huh?"
	done

MilosB2Fb_Trainer_2_Text_1234dc:
	ctxt "Can you pay some"
	line "attention to me"
	cont "while I pretend"
	cont "that I don't care?"
	done

MilosB2Fb_Trainer_2_Text_12351b:
	ctxt "Real talk, that's"
	line "kinda unfair<...>"
	done

MilosB2Fb_Trainer_2_Script_Text_123530:
	ctxt "I'm intriguing, but"
	line "nobody wants to"
	cont "understand me<...>"
	done

MilosB2Fb_123890_Text_122d62:
	ctxt "Uh oh!"

	para "Picking up the"
	line "shoes reversed"
	cont "all of the"
	cont "switches!"
	done

MilosB2Fb_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $3, $13, 4, MILOS_B1F
	warp_def $3, $1b, 4, MILOS_F1

	;xy triggers
	db 0

	;signposts
	db 17
	signpost 6, 12, SIGNPOST_LEFT, MilosB2FbSignpost1
	signpost 10, 8, SIGNPOST_LEFT, MilosB2FbSignpost2
	signpost 22, 18, SIGNPOST_LEFT, MilosB2FbSignpost3
	signpost 30, 8, SIGNPOST_LEFT, MilosB2FbSignpost4
	signpost 18, 0, SIGNPOST_LEFT, MilosB2FbSignpost5
	signpost 22, 4, SIGNPOST_LEFT, MilosB2FbSignpost6
	signpost 18, 13, SIGNPOST_RIGHT, MilosB2FbSignpost7
	signpost 22, 17, SIGNPOST_RIGHT, MilosB2FbSignpost8
	signpost 30, 19, SIGNPOST_RIGHT, MilosB2FbSignpost9
	signpost 5, 7, SIGNPOST_UP, MilosB2FbSignpost10
	signpost 6, 7, SIGNPOST_READ, MilosB2FbSignpost11
	signpost 21, 9, SIGNPOST_UP, MilosB2FbSignpost12
	signpost 22, 9, SIGNPOST_READ, MilosB2FbSignpost13
	signpost 34, 15, SIGNPOST_READ, MilosB2FbSignpost14
	signpost 33, 15, SIGNPOST_UP, MilosB2FbSignpost15
	signpost 26, 43, SIGNPOST_READ, MilosB2FbSignpost16
	signpost 25, 43, SIGNPOST_UP, MilosB2FbSignpost17

	;people-events
	db 5
	person_event SPRITE_POKE_BALL, 30, 20, SPRITEMOVEDATA_00, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 4, MilosB2FbNPC1, EVENT_JUMPING_SHOES
	person_event SPRITE_POKE_BALL, 40, 54, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 1, 3, MilosB2Fb_Item_1, EVENT_MILOS_B2FB_ITEM_1
	person_event SPRITE_POKE_BALL, 26, 48, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 76, MilosB2Fb_Item_2, EVENT_MILOS_B2FB_ITEM_2
	person_event SPRITE_PALETTE_PATROLLER, 6, 31, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_GREEN, 2, 1, MilosB2Fb_Trainer_1, EVENT_MILOS_B2FB_TRAINER_1
	person_event SPRITE_PALETTE_PATROLLER, 14, 0, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_SILVER, 2, 1, MilosB2Fb_Trainer_2, EVENT_MILOS_B2FB_TRAINER_2
