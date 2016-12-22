PrisonF2_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

PrisonF2Trap1:
	faceperson 8, 0
	faceperson 0, 8
	jump PrisonF2_254e57

PrisonF2Trap2:
	applymovement 9, PrisonF2Trap2_Movement1
	jump PrisonF2_254ed2

PrisonF2Trap2_Movement1:
	turn_head_down
	step_end

PrisonF2Trap3:
	opentext
	writetext PrisonF2Trap3_Text_254e63
	waitbutton
	closetext
	applymovement 9, PrisonF2Trap3_Movement1
	farjump PrisonF2_1030eb

PrisonF2Trap3_Movement1:
	step_down
	step_end

PrisonF2Trap4:
	faceperson 0, 9
	faceperson 9, 0
	opentext
	writetext PrisonF2Trap3_Text_254e63
	waitbutton
	closetext
	applymovement 9, PrisonF2Trap4_Movement1
	farjump PrisonF2_1030eb

PrisonF2Trap4_Movement1:
	step_down
	step_down
	step_end

PrisonF2Trap5:
	faceperson 0, 9
	faceperson 9, 0
	opentext
	writetext PrisonF2Trap3_Text_254e63
	waitbutton
	closetext
	applymovement 9, PrisonF2Trap5_Movement1
	farjump PrisonF2_1030eb

PrisonF2Trap5_Movement1:
	step_down
	step_down
	step_down
	step_end

PrisonF2Trap6:
	faceperson 0, 9
	faceperson 9, 0
	opentext
	writetext PrisonF2Trap3_Text_254e63
	waitbutton
	closetext
	applymovement 9, PrisonF2Trap6_Movement1
	farjump PrisonF2_1030eb

PrisonF2Trap6_Movement1:
	step_down
	step_down
	step_down
	step_down
	step_end

PrisonF2Trap7:
	faceperson 0, 7
	faceperson 7, 0
	jump PrisonF2_254e57

PrisonF2Trap8:
	faceperson 0, 7
	faceperson 7, 0
	opentext
	writetext PrisonF2Trap3_Text_254e63
	waitbutton
	closetext
	applymovement 7, PrisonF2Trap8_Movement1
	farjump PrisonF2_1030eb

PrisonF2Trap8_Movement1:
	step_right
	step_end

PrisonF2Trap9:
	faceperson 0, 3
	faceperson 3, 0
	opentext
	writetext PrisonF2Trap3_Text_254e63
	waitbutton
	closetext
	applymovement 3, PrisonF2Trap9_Movement1
	farjump PrisonF2_1030eb

PrisonF2Trap9_Movement1:
	step_left
	step_left
	step_end

PrisonF2Trap10:
	faceperson 0, 3
	faceperson 3, 0
	opentext
	writetext PrisonF2Trap3_Text_254e63
	waitbutton
	closetext
	applymovement 3, PrisonF2Trap10_Movement1
	farjump PrisonF2_1030eb

PrisonF2Trap10_Movement1:
	step_left
	step_end

PrisonF2Trap11:
	faceperson 0, 3
	faceperson 3, 0
	jump PrisonF2_254e57

PrisonF2Trap12:
	faceperson 0, 5
	faceperson 5, 0
	opentext
	writetext PrisonF2Trap3_Text_254e63
	waitbutton
	closetext
	applymovement 5, PrisonF2Trap12_Movement1
	farjump PrisonF2_1030eb

PrisonF2Trap12_Movement1:
	step_left
	step_end

PrisonF2Trap13:
	applymovement 5, PrisonF2Trap13_Movement1
	jump PrisonF2_254ecc

PrisonF2Trap13_Movement1:
	turn_head_left
	step_end

PrisonF2Trap14:
	faceperson 0, 7
	faceperson 7, 0
	jump PrisonF2_254e57

PrisonF2Trap15:
	faceperson 0, 7
	faceperson 7, 0
	jump PrisonF2_254e57

PrisonF2Trap16:
	faceperson 0, 3
	faceperson 3, 0
	jump PrisonF2_254e57

PrisonF2Trap17:
	faceperson 0, 3
	faceperson 3, 0
	jump PrisonF2_254e57

PrisonF2Trap18:
	applymovement 9, PrisonF2Trap18_Movement1
	jump PrisonF2_254ed2

PrisonF2Trap18_Movement1:
	turn_head_left
	step_end

PrisonF2Trap19:
	applymovement 9, PrisonF2Trap19_Movement1
	jump PrisonF2_254ed2

PrisonF2Trap19_Movement1:
	turn_head_right
	step_end

PrisonF2Trap20:
	applymovement 5, PrisonF2Trap20_Movement1
	jump PrisonF2_254ecc

PrisonF2Trap20_Movement1:
	turn_head_up
	step_end

PrisonF2Trap21:
	applymovement 5, PrisonF2Trap21_Movement1
	jump PrisonF2_254ecc

PrisonF2Trap21_Movement1:
	turn_head_down
	step_end

PrisonF2Trap22:
	faceperson 0, 8
	faceperson 8, 0
	jump PrisonF2_254e57

PrisonF2Trap23:
	faceperson 0, 8
	faceperson 8, 0
	jump PrisonF2_254e57

PrisonF2NPC2:
	opentext
	writetext PrisonF2Trap3_Text_254e63
	waitbutton
	farjump PrisonF2_1030eb

PrisonF2NPC4:
	opentext
	writetext PrisonF2Trap3_Text_254e63
	waitbutton
	farjump PrisonF2_1030eb

PrisonF2NPC5:
	faceplayer
	opentext
	checkitem ROOF_CARD
	iffalse PrisonF2_255822
	setevent EVENT_SILPH_CO_NPC_6
	writetext PrisonF2NPC5_Text_255828
	waitbutton
	closetext
	applymovement 6, PrisonF2NPC5_Movement1
	disappear 6
	end

PrisonF2NPC5_Movement1:
	return_dig 32
	step_end

PrisonF2NPC6:
	faceperson 0, 7
	faceperson 7, 0
	opentext
	writetext PrisonF2Trap3_Text_254e63
	waitbutton
	closetext
	applymovement 7, PrisonF2NPC6_Movement1
	farjump PrisonF2_1030eb

PrisonF2NPC6_Movement1:
	step_right
	step_end

PrisonF2NPC7:
	opentext
	writetext PrisonF2Trap3_Text_254e63
	waitbutton
	farjump PrisonF2_1030eb

PrisonF2NPC8:
	opentext
	writetext PrisonF2Trap3_Text_254e63
	waitbutton
	farjump PrisonF2_1030eb

PrisonF2_254e57:
	opentext
	writetext PrisonF2Trap3_Text_254e63
	waitbutton
	farjump PrisonF2_1030eb

PrisonF2_254ed2:
	faceperson 0, 9
	faceperson 9, 0
	jump PrisonF2_254e57

PrisonF2_1030eb:
	warp PRISON_F1, 20, 3
	closetext
	end

PrisonF2_254ecc:
	faceperson 0, 5
	faceperson 5, 0
	jump PrisonF2_254e57

PrisonF2_255822:
	writetext PrisonF2_255822_Text_25586f
	endtext

PrisonF2Trap3_Text_254e63:
	ctxt "HALT!"

	para "You're not allowed"
	line "up here."
	done

PrisonF2NPC5_Text_255828:
	ctxt "Well it looks like"
	line "you have the roof"
	cont "card, so I guess"
	cont "I'll let you in."
	done

PrisonF2_255822_Text_25586f:
	ctxt "No one's allowed"
	line "up here without a"
	cont "special Roof Card."
	done

PrisonF2_MapEventHeader ;filler
	db 0, 0

;warps
	db 6
	warp_def $9, $25, 6, PRISON_F1
	warp_def $20, $1f, 1, PRISON_ROOF
	warp_def $10, $0, 1, PRISON_ELECTRIC_CHAIR
	warp_def $11, $0, 2, PRISON_ELECTRIC_CHAIR
	warp_def $14, $27, 1, PRISON_CAFETERIA
	warp_def $15, $27, 2, PRISON_CAFETERIA

	;xy triggers
	db 23
	xy_trigger 0, $2, $f, $0, PrisonF2Trap1, $0, $0
	xy_trigger 0, $d, $5, $0, PrisonF2Trap2, $0, $0
	xy_trigger 0, $e, $5, $0, PrisonF2Trap3, $0, $0
	xy_trigger 0, $f, $5, $0, PrisonF2Trap4, $0, $0
	xy_trigger 0, $10, $5, $0, PrisonF2Trap5, $0, $0
	xy_trigger 0, $11, $5, $0, PrisonF2Trap6, $0, $0
	xy_trigger 0, $13, $25, $0, PrisonF2Trap7, $0, $0
	xy_trigger 0, $13, $26, $0, PrisonF2Trap8, $0, $0
	xy_trigger 0, $17, $1e, $0, PrisonF2Trap9, $0, $0
	xy_trigger 0, $17, $1f, $0, PrisonF2Trap10, $0, $0
	xy_trigger 0, $17, $20, $0, PrisonF2Trap11, $0, $0
	xy_trigger 0, $7, $1, $0, PrisonF2Trap12, $0, $0
	xy_trigger 0, $7, $2, $0, PrisonF2Trap13, $0, $0
	xy_trigger 0, $12, $24, $0, PrisonF2Trap14, $0, $0
	xy_trigger 0, $14, $24, $0, PrisonF2Trap15, $0, $0
	xy_trigger 0, $16, $21, $0, PrisonF2Trap16, $0, $0
	xy_trigger 0, $18, $21, $0, PrisonF2Trap17, $0, $0
	xy_trigger 0, $c, $4, $0, PrisonF2Trap18, $0, $0
	xy_trigger 0, $c, $6, $0, PrisonF2Trap19, $0, $0
	xy_trigger 0, $6, $3, $0, PrisonF2Trap20, $0, $0
	xy_trigger 0, $8, $3, $0, PrisonF2Trap21, $0, $0
	xy_trigger 0, $3, $e, $0, PrisonF2Trap22, $0, $0
	xy_trigger 0, $3, $10, $0, PrisonF2Trap23, $0, $0

	;signposts
	db 0

	;people-events
	db 8
	person_event SPRITE_POKE_BALL, 2, 3, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_PURPLE, 3, TM_EXPLOSION, 0, EVENT_PRISON_F2_NPC_1
	person_event SPRITE_OFFICER, 23, 33, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, PrisonF2NPC2, -1
	person_event SPRITE_POKE_BALL, 0, 37, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 0, 0, ObjectEvent, -1
	person_event SPRITE_OFFICER, 7, 3, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, PrisonF2NPC4, -1
	person_event SPRITE_OFFICER, 30, 32, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, PrisonF2NPC5, EVENT_PRISON_F2_NPC_5
	person_event SPRITE_OFFICER, 19, 36, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, PrisonF2NPC6, -1
	person_event SPRITE_OFFICER, 3, 15, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, PrisonF2NPC7, -1
	person_event SPRITE_OFFICER, 12, 5, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, PrisonF2NPC8, -1
