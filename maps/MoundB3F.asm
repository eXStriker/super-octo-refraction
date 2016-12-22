MoundB3F_MapScriptHeader;trigger count
MoundB3FDark_MapScriptHeader
	db 0
 ;callback count
	db 1
	dbw MAPCALLBACK_NEWMAP, MoundCave_ResetFlash

MoundMinecart: 
	opentext
	writetext MoundB3FSignpost6_Text_11e760
	waitbutton
	writetext MoundB3FSignpost6_Text_11e77e
	loadmenudata MoundCaveMinecartMenuDataHeader
	verticalmenu
	closewindow
	if_equal 1, MoundB3F_11e890
	if_equal 2, MoundB3F_11e898
	if_equal 3, MoundB3F_11e8a0
	closetext
	end

MoundCaveMinecartMenuDataHeader:
	db $40 ; flags
	db 02, 00 ; start coords
	db 11, 19 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2:
	db $80 ; flags
	db 4 ; items
	db "Acqua Mines@"
	db "Clathrite Tunnel@"
	db "Firelight Caverns@"
	db "Cancel@"

MoundB3F_Item_1:
	db DYNAMITE, 1

MoundB3F_Item_2:
	db DYNAMITE, 1

MoundB3F_Trainer_1:
	trainer EVENT_MOUND_B3F_TRAINER_1, PATROLLER, 12, MoundB3F_Trainer_1_Text_11d500, MoundB3F_Trainer_1_Text_11d59a, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer MoundB3F_Trainer_1_Script_Text_11d6b1

MoundB3F_Trainer_2:
	trainer EVENT_MOUND_B3F_TRAINER_2, PATROLLER, 9, MoundB3F_Trainer_2_Text_11d1db, MoundB3F_Trainer_2_Text_11d353, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer MoundB3F_Trainer_2_Script_Text_11d375

MoundB3F_Trainer_3:
	trainer EVENT_MOUND_B3F_TRAINER_3, PATROLLER, 6, MoundB3F_Trainer_3_Text_11d428, MoundB3F_Trainer_3_Text_11d454, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer MoundB3F_Trainer_3_Script_Text_11d476


MoundB3F_11e890:
	warp ACQUA_START, 28, 35
	closetext
	end

MoundB3F_11e898:
	warp CLATHRITE_1F, 20, 37
	closetext
	end

MoundB3F_11e8a0:
	warp MAGMA_MINECART, 12, 13
	closetext
	end

MoundB3FSignpost6_Text_11e760:
	ctxt "This mine cart"
	line "seems stable!"
	done

MoundB3FSignpost6_Text_11e77e:
	ctxt "Where do you want"
	line "to go?"
	done

MoundB3F_Trainer_1_Text_11d500:
	ctxt "I'm amazed you've"
	line "made it this far<...>"

	para "<...><PLAYER>!"

	para "Yes, I know your"
	line "name<...> and plenty"
	cont "of other things."

	para "You can't run from"
	line "us, we'll find you!"

	para "Now young one,"
	line "let's fight!"
	done

MoundB3F_Trainer_1_Text_11d59a:
	ctxt "Darn you!"

	para "You might have"
	line "won this time<...>"

	para "<...>but you can't use"
	line "your #mon as a"
	cont "shield forever!"

	para "Behind your loyal"
	line "#mon is just"
	cont "a helpless child."

	para "But, like humans,"
	line "#mon are total-"
	cont "ly disposable."

	para "When it is upon"
	line "us, the world will"
	cont "see just how vul-"
	cont "nerable you are!"
	done

MoundB3F_Trainer_1_Script_Text_11d6b1:
	ctxt "Look, you earned"
	line "your dynamite,"
	cont "so go get it and"
	cont "leave me alone."

	para "We'll come back to"
	line "meet you again,"
	cont "when the time"
	cont "is more suitable."

	done

MoundB3F_Trainer_2_Text_11d1db:
	ctxt "Oh, it's you."

	para "You're the kid"
	line "we're looking for."

	para "Well, Patroller"
	line "Red is, anyways<...>"

	para "I just needed a"
	line "gig, and this is"
	cont "all I could get."

	para "I hope I do a"
	line "good enough job."
	done

MoundB3F_Trainer_2_Text_11d353:
	ctxt "They can't blame"
	line "me! It's my first"
	cont "day, after all."
	done

MoundB3F_Trainer_2_Script_Text_11d375:
	ctxt "Everybody needs a"
	line "way to make money,"
	cont "and this is mine."

	para "I agree, it is"
	line "a bit unorthodox."
	done

MoundB3F_Trainer_3_Text_11d428:
	ctxt "Hey."

	para "Hey!"

	para "Don't ignore me!"
	done

MoundB3F_Trainer_3_Text_11d454:
	ctxt "Gah, you're just"
	line "like Red!"
	done

MoundB3F_Trainer_3_Script_Text_11d476:
	ctxt "We haven't seen"
	line "the Red Patroller"
	cont "all day, so we"
	cont "had to do this"
	cont "mission solo."

	para "If you see him,"
	line "tell him Pink"
	cont "wants some real"
	cont "Pink-to-Red talk!"
	done

MoundB3F_MapEventHeader ;filler
MoundB3FDark_MapEventHeader
	db 0, 0

;warps
	db 69
	warp_def $07, $25, $06, MOUND_F1
	warp_def $11, $17, $02, MOUND_B2F
	warp_def $39, $0D, $03, MOUND_B2F
	warp_def $10, $15, $01, MOUND_B2F
	warp_def $11, $15, $01, MOUND_B2F
	warp_def $12, $16, $01, MOUND_B2F
	warp_def $12, $17, $01, MOUND_B2F
	warp_def $12, $18, $01, MOUND_B2F
	warp_def $12, $19, $01, MOUND_B2F
	warp_def $13, $19, $01, MOUND_B2F
	warp_def $13, $18, $01, MOUND_B2F
	warp_def $13, $17, $01, MOUND_B2F
	warp_def $13, $16, $01, MOUND_B2F
	warp_def $14, $15, $01, MOUND_B2F
	warp_def $15, $15, $01, MOUND_B2F
	warp_def $1C, $14, $10, MOUND_B2F
	warp_def $1C, $15, $11, MOUND_B2F
	warp_def $1C, $16, $12, MOUND_B2F
	warp_def $1C, $17, $13, MOUND_B2F
	warp_def $1C, $18, $14, MOUND_B2F
	warp_def $1C, $19, $15, MOUND_B2F
	warp_def $1D, $1B, $16, MOUND_B2F
	warp_def $1E, $1B, $17, MOUND_B2F
	warp_def $1F, $1B, $18, MOUND_B2F
	warp_def $20, $1B, $19, MOUND_B2F
	warp_def $21, $1B, $1A, MOUND_B2F
	warp_def $22, $1B, $1B, MOUND_B2F
	warp_def $23, $19, $1C, MOUND_B2F
	warp_def $23, $18, $1D, MOUND_B2F
	warp_def $23, $17, $1E, MOUND_B2F
	warp_def $23, $16, $1F, MOUND_B2F
	warp_def $23, $15, $20, MOUND_B2F
	warp_def $23, $14, $21, MOUND_B2F
	warp_def $22, $12, $22, MOUND_B2F
	warp_def $21, $12, $23, MOUND_B2F
	warp_def $20, $12, $24, MOUND_B2F
	warp_def $1F, $12, $25, MOUND_B2F
	warp_def $1E, $12, $26, MOUND_B2F
	warp_def $1D, $12, $27, MOUND_B2F
	warp_def $2A, $1A, $01, MOUND_B2F
	warp_def $2B, $1A, $01, MOUND_B2F
	warp_def $1C, $12, $01, MOUND_B2F
	warp_def $1C, $1B, $01, MOUND_B2F
	warp_def $23, $12, $01, MOUND_B2F
	warp_def $23, $1B, $01, MOUND_B2F
	warp_def $32, $0B, $01, MOUND_B2F
	warp_def $32, $0A, $01, MOUND_B2F
	warp_def $33, $0A, $01, MOUND_B2F
	warp_def $34, $0A, $01, MOUND_B2F
	warp_def $35, $0A, $01, MOUND_B2F
	warp_def $36, $0A, $01, MOUND_B2F
	warp_def $37, $0A, $01, MOUND_B2F
	warp_def $37, $0B, $01, MOUND_B2F
	warp_def $37, $0C, $01, MOUND_B2F
	warp_def $37, $0D, $01, MOUND_B2F
	warp_def $38, $0E, $01, MOUND_B2F
	warp_def $39, $0E, $01, MOUND_B2F
	warp_def $12, $15, $01, MOUND_B2F
	warp_def $13, $15, $01, MOUND_B2F
	warp_def $1C, $13, $3C, MOUND_B2F
	warp_def $1C, $1A, $3D, MOUND_B2F
	warp_def $23, $13, $3E, MOUND_B2F
	warp_def $23, $1A, $3F, MOUND_B2F
	warp_def $31, $0B, $01, MOUND_B2F
	warp_def $37, $0E, $01, MOUND_B2F
	warp_def $2D, $29, $42, MOUND_B2F
	warp_def $05, $0D, $45, MOUND_B3F ; 67
	warp_def $01, $0D, $0A, SPURGE_CITY
	warp_def $07, $1F, $43, MOUND_B3F ; 69

	;xy triggers
	db 0

	;signposts
	db 6
	signpost 15, 21, SIGNPOST_READ, MoundB3FSignpost1
	signpost 41, 27, SIGNPOST_READ, MoundB3FSignpost2
	signpost 43, 41, SIGNPOST_READ, MoundB3FSignpost3
	signpost 33, 23, SIGNPOST_READ, MoundB3FSignpost4
	signpost 53, 15, SIGNPOST_READ, MoundB3FSignpost5
	signpost 58, 8, SIGNPOST_READ, MoundMinecart

	;people-events
	db 5
	person_event SPRITE_POKE_BALL, 15, 4, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, MoundB3F_Item_1, EVENT_MOUND_B3F_ITEM_1
	person_event SPRITE_POKE_BALL, 42, 27, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, MoundB3F_Item_2, EVENT_MOUND_B3F_ITEM_2
	person_event SPRITE_PALETTE_PATROLLER, 47, 40, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_GREEN, 2, 2, MoundB3F_Trainer_1, EVENT_MOUND_B3F_TRAINER_1
	person_event SPRITE_PALETTE_PATROLLER, 44, 26, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_BLUE, 2, 2, MoundB3F_Trainer_2, EVENT_MOUND_B3F_TRAINER_2
	person_event SPRITE_PALETTE_PATROLLER, 21, 7, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_PURPLE, 2, 2, MoundB3F_Trainer_3, EVENT_MOUND_B3F_TRAINER_3
