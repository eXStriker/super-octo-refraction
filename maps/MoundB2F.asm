MoundB2F_MapScriptHeader;trigger count
MoundB2FDark_MapScriptHeader
	db 0
 ;callback count
	db 1
	dbw MAPCALLBACK_NEWMAP, MoundCave_ResetFlash

MoundCave_ResetFlash:
	callasm .TryResetFlash
	return

.TryResetFlash:
	ld a, [wPrevMapGroup]
	cp GROUP_MOUND_F1
	jr nz, .set_flash
	ld a, [wPrevMapNumber]
	cp MAP_MOUND_B1F
	jr z, .reset_flash
	cp MAP_MOUND_B2F
	jr z, .b2f_check
	cp MAP_MOUND_B3F
	jr z, .b3f_check
.set_flash
	SetEngine ENGINE_FLASH
	ret

.b2f_check
	ld a, [wPrevWarp]
	cp 59
	jr z, .set_flash
	jr .reset_flash

.b3f_check
	ld a, [wPrevWarp]
	cp 67
	jr z, .set_flash
	cp 69
	jr z, .set_flash
.reset_flash
	ResetEngine ENGINE_FLASH
	ret

MoundB2FSignpost1:
MoundB2FSignpost2:
MoundB2FSignpost3:
MoundB2FSignpost4:
MoundB2FSignpost5:
MoundB3FSignpost1:
MoundB3FSignpost2:
MoundB3FSignpost3:
MoundB3FSignpost4:
MoundB3FSignpost5:
MoundB3FSignpost6:
	checkflag ENGINE_FLASH
	sif true
		jumptext MoundB2FSignpostText_AlreadyOn
	opentext
	writetext MoundB2FSignpost1_Text_1137a0
	waitbutton
	findpokemontype ELECTRIC
	sif false, then
		closetext
		end
	sendif
	writetext MoundB2FSignpostText_UseMonToStartTheGenerator
	addvar -1
	copyvartobyte wCurPartyMon
	yesorno
	closetext
	sif false
		end
	callstd fieldmovepokepic
	playwaitsfx SFX_FLASH
	callasm BlindingFlash
	end

MoundB2F_Item_1:
	db DYNAMITE, 1

MoundB2F_Item_2:
	db ESCAPE_ROPE, 1

MoundB2F_Trainer_1:
	trainer EVENT_MOUND_B2F_TRAINER_1, PATROLLER, 1, MoundB2F_Trainer_1_Text_111a3d, MoundB2F_Trainer_1_Text_111a6b, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer MoundB2F_Trainer_1_Script_Text_111a70

MoundB2F_Item_3:
	db DYNAMITE, 1

MoundB2F_Item_4:
	db DYNAMITE, 1

MoundB2F_Trainer_2:
	trainer EVENT_MOUND_B2F_TRAINER_2, PATROLLER, 3, MoundB2F_Trainer_2_Text_11228d, MoundB2F_Trainer_2_Text_11229f, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer MoundB2F_Trainer_2_Script_Text_1122a9

MoundB2FSignpost1_Text_1137a0:
	ctxt "An Electric"
	line "#mon or move"
	cont "could start this"
	cont "light generator."
	done

MoundB2FSignpostText_UseMonToStartTheGenerator:
	start_asm
	push bc
	ld hl, wPartyMonNicknames - PKMN_NAME_LENGTH
	ld bc, PKMN_NAME_LENGTH
	ld a, [hScriptVar]
	rst AddNTimes
	ld d, h
	ld e, l
	call CopyName1
	pop bc
	ld hl, .text
	ret
.text
	ctxt "Use <STRBF2> to"
	line "start the light"
	cont "generator?"
	done

MoundB2F_Trainer_1_Text_111a3d:
	ctxt "I just do what"
	line "the boss says."

	para "If I get paid,"
	line "I won't complain."
	done

MoundB2F_Trainer_1_Text_111a6b:
	ctxt "<...>"
	done

MoundB2F_Trainer_1_Script_Text_111a70:
	ctxt "I don't know what"
	line "we're doing, all"
	cont "I care about is"
	cont "the money."
	done

MoundB2F_Trainer_2_Text_11228d:
	ctxt "I'm a super hero!"
	done

MoundB2F_Trainer_2_Text_11229f:
	ctxt "No fair!"
	done

MoundB2F_Trainer_2_Script_Text_1122a9:
	ctxt "My boyfriend,"
	line "Pallet Green,"
	cont "won't be happy"
	cont "about this!"
	done

MoundB2FSignpostText_AlreadyOn:
	ctxt "The lights in"
	line "the room are"
	cont "already on."
	done

MoundB2F_MapEventHeader
MoundB2FDark_MapEventHeader
;filler
	db 0, 0

;warps
	db 66
	warp_def $3, $25, $2, MOUND_B1F
	warp_def $03, $0F, $02, MOUND_B3F
	warp_def $2B, $07, $03, MOUND_B3F
	warp_def $02, $0D, $04, MOUND_B3F
	warp_def $03, $0D, $05, MOUND_B3F
	warp_def $04, $0E, $06, MOUND_B3F
	warp_def $04, $0F, $07, MOUND_B3F
	warp_def $04, $10, $08, MOUND_B3F
	warp_def $04, $11, $09, MOUND_B3F
	warp_def $05, $11, $0A, MOUND_B3F
	warp_def $05, $10, $0B, MOUND_B3F
	warp_def $05, $0F, $0C, MOUND_B3F
	warp_def $05, $0E, $0D, MOUND_B3F
	warp_def $06, $0D, $0E, MOUND_B3F
	warp_def $07, $0D, $0F, MOUND_B3F
	warp_def $0E, $0C, $10, MOUND_B3F
	warp_def $0E, $0D, $11, MOUND_B3F
	warp_def $0E, $0E, $12, MOUND_B3F
	warp_def $0E, $0F, $13, MOUND_B3F
	warp_def $0E, $10, $14, MOUND_B3F
	warp_def $0E, $11, $15, MOUND_B3F
	warp_def $0F, $13, $16, MOUND_B3F
	warp_def $10, $13, $17, MOUND_B3F
	warp_def $11, $13, $18, MOUND_B3F
	warp_def $12, $13, $19, MOUND_B3F
	warp_def $13, $13, $1A, MOUND_B3F
	warp_def $14, $13, $1B, MOUND_B3F
	warp_def $15, $11, $1C, MOUND_B3F
	warp_def $15, $10, $1D, MOUND_B3F
	warp_def $15, $0F, $1E, MOUND_B3F
	warp_def $15, $0E, $1F, MOUND_B3F
	warp_def $15, $0D, $20, MOUND_B3F
	warp_def $15, $0C, $21, MOUND_B3F
	warp_def $14, $0A, $22, MOUND_B3F
	warp_def $13, $0A, $23, MOUND_B3F
	warp_def $12, $0A, $24, MOUND_B3F
	warp_def $11, $0A, $25, MOUND_B3F
	warp_def $10, $0A, $26, MOUND_B3F
	warp_def $0F, $0A, $27, MOUND_B3F
	warp_def $1C, $12, $28, MOUND_B3F
	warp_def $1D, $12, $29, MOUND_B3F
	warp_def $0E, $0A, $2A, MOUND_B3F
	warp_def $0E, $13, $2B, MOUND_B3F
	warp_def $15, $0A, $2C, MOUND_B3F
	warp_def $15, $13, $2D, MOUND_B3F
	warp_def $24, $05, $2E, MOUND_B3F
	warp_def $24, $04, $2F, MOUND_B3F
	warp_def $25, $04, $30, MOUND_B3F
	warp_def $26, $04, $31, MOUND_B3F
	warp_def $27, $04, $32, MOUND_B3F
	warp_def $28, $04, $33, MOUND_B3F
	warp_def $29, $04, $34, MOUND_B3F
	warp_def $29, $05, $35, MOUND_B3F
	warp_def $29, $06, $36, MOUND_B3F
	warp_def $29, $07, $37, MOUND_B3F
	warp_def $28, $08, $38, MOUND_B3F
	warp_def $28, $08, $39, MOUND_B3F
	warp_def $04, $0D, $01, MOUND_B3F
	warp_def $05, $0D, $3B, MOUND_B3F ; 59
	warp_def $0E, $0B, $3C, MOUND_B3F
	warp_def $0E, $12, $3D, MOUND_B3F
	warp_def $15, $0B, $3E, MOUND_B3F
	warp_def $15, $12, $3F, MOUND_B3F
	warp_def $20, $13, $40, MOUND_B3F
	warp_def $28, $08, $41, MOUND_B3F
	warp_def $29, $1B, $42, MOUND_B3F

	;xy triggers
	db 0

	;signposts
	db 5
	signpost 11, 11, SIGNPOST_READ, MoundB2FSignpost1
	signpost 1, 19, SIGNPOST_READ, MoundB2FSignpost2
	signpost 1, 33, SIGNPOST_READ, MoundB2FSignpost3
	signpost 37, 27, SIGNPOST_READ, MoundB2FSignpost4
	signpost 41, 11, SIGNPOST_READ, MoundB2FSignpost5

	;people-events
	db 6
	person_event SPRITE_POKE_BALL, 39, 26, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, MoundB2F_Item_1, EVENT_MOUND_B2F_ITEM_1
	person_event SPRITE_POKE_BALL, 4, 33, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 1, 0, MoundB2F_Item_2, EVENT_MOUND_B2F_ITEM_2
	person_event SPRITE_PALETTE_PATROLLER, 23, 26, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_SILVER, 2, 2, MoundB2F_Trainer_1, EVENT_MOUND_B2F_TRAINER_1
	person_event SPRITE_POKE_BALL, 21, 32, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, MoundB2F_Item_3, EVENT_MOUND_B2F_ITEM_3
	person_event SPRITE_POKE_BALL, 3, 2, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, MoundB2F_Item_4, EVENT_MOUND_B2F_ITEM_4
	person_event SPRITE_PALETTE_PATROLLER, 8, 3, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_YELLOW, 2, 2, MoundB2F_Trainer_2, EVENT_MOUND_B2F_TRAINER_2
