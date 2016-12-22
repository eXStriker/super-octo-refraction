MersonGoldTokenExchange_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MersonGoldTokenExchangeNPC:
	faceplayer
	opentext
	checkevent EVENT_GOLDTOKENMAN_INTRO
	iftrue MersonGoldTokenExchange_CheckMilestones
	writetext MersonGoldTokenExchange_Text_Intro
	waitbutton
	setevent EVENT_GOLDTOKENMAN_INTRO

MersonGoldTokenExchange_CheckMilestones:
	scriptstartasm
	ld hl, MersonGoldTokenExchange_EventFlags
	call CountEventFlagsFromList
	ld a, e
	cp 8
	ld hl, MersonGoldTokenExchange_CheckFinishedDex
	ret z
	ld hl, MersonGoldTokenExchange_AfterFillingDex
	ret nc
	ld [hScriptVar], a
	ld hl, PokedexCaught
	ld b, EndPokedexCaught - PokedexCaught
	call CountSetBits
	push af
	ld a, [hScriptVar]
	inc a
	ld b, a
	swap a
	sub b
	add a, a
	ld b, a
	pop af
	cp b
	ld hl, MersonGoldTokenExchange_RequirementsForMilestone
	ret c
	scriptstopasm
	writetext MersonGoldTokenExchange_Text_PassedMilestone
	waitbutton
	verbosegiveitem GOLD_TOKEN, 4
	sif false
		jumptext MersonGoldTokenExchange_Text_NeedMoreSpace
	closetext
	scriptstartasm
	ld hl, MersonGoldTokenExchange_EventFlags
.loop
	ld a, [hli]
	ld d, [hl]
	ld e, a
	inc hl
	push hl
	push de
	ld b, CHECK_FLAG
	predef EventFlagAction
	pop de
	pop hl
	jr nz, .loop
	ld b, 1
	predef EventFlagAction
	ld hl, 0
	ret

MersonGoldTokenExchange_EventFlags:
	dw EVENT_GOLDTOKENMAN_MILESTONE_1
	dw EVENT_GOLDTOKENMAN_MILESTONE_2
	dw EVENT_GOLDTOKENMAN_MILESTONE_3
	dw EVENT_GOLDTOKENMAN_MILESTONE_4
	dw EVENT_GOLDTOKENMAN_MILESTONE_5
	dw EVENT_GOLDTOKENMAN_MILESTONE_6
	dw EVENT_GOLDTOKENMAN_MILESTONE_7
	dw EVENT_GOLDTOKENMAN_MILESTONE_8
	dw EVENT_GOLDTOKENMAN_MILESTONE_9
	dw -1

MersonGoldTokenExchange_RequirementsForMilestone:
	jumptext MersonGoldTokenExchange_Text_RequirementsForMilestone

MersonGoldTokenExchange_CheckFinishedDex:
	checkcode VAR_DEXCAUGHT
	sif <, 253
		jumptext MersonGoldTokenExchange_Text_RequirementsForSpecialGift
	writetext MersonGoldTokenExchange_Text_FinishedDex
	waitbutton
	verbosegiveitem TOKENFINDER, 1
	sif false
		jumptext MersonGoldTokenExchange_Text_NeedMoreSpace
	setevent EVENT_GOLDTOKENMAN_MILESTONE_9
	closetext
	end

MersonGoldTokenExchange_AfterFillingDex:
	jumptext MersonGoldTokenExchange_Text_AfterFillingDex

MersonGoldTokenExchange_Text_Intro:
	ctxt "Hello, I am a huge"
	line "fan of #mon!"

	para "For every 30"
	line "#mon you own, I"

	para "will give you 4"
	line "Gold Tokens."

	para "Great deal huh?"
	done

MersonGoldTokenExchange_Text_NeedMoreSpace:
	ctxt "You need more"
	line "space for your"
	cont "gift!"
	done

MersonGoldTokenExchange_Text_PassedMilestone:
	start_asm
	call MersonGoldTextExchange_GetMilestoneNumber
	ld hl, .text
	ret
.text
	ctxt "You passed the"
	line "<STRBF1> milestone!"
	done

MersonGoldTokenExchange_Text_RequirementsForMilestone:
	start_asm
	call MersonGoldTextExchange_GetMilestoneNumber
	ld a, [hScriptVar]
	inc a
	ld l, a
	swap a
	sub l
	add a, a
	ld [hTemp], a
	ld hl, .text
	ret
.text
	ctxt "You need to own"
	line "@"
	deciram hTemp, 1, 3
	ctxt " #mon in"
	cont "order to pass"
	cont "the <STRBF1>"
	cont "milestone!"
	done

MersonGoldTextExchange_GetMilestoneNumber:
	push bc
	ld a, [hScriptVar]
	ld hl, MersonGoldTokenExchange_Text_OrdinalNumbers
	call GetNthString
	ld d, h
	ld e, l
	ld hl, wStringBuffer1
	ld bc, 8
	ld a, "@"
	push hl
	call ByteFill
	pop hl
	call PlaceString
	pop bc
	ret

MersonGoldTokenExchange_Text_OrdinalNumbers:
	db "first@"
	db "second@"
	db "third@"
	db "fourth@"
	db "fifth@"
	db "sixth@"
	db "seventh@"
	db "eighth@"

MersonGoldTokenExchange_Text_FinishedDex:
	ctxt "Impressive!"

	para "You finished the"
	line "Naljodex!"

	para "You've moved me,"
	line "and since you"

	para "enjoy those Gold"
	line "Tokens, I'll let"

	para "you have an item"
	line "that will help"
	cont "you find more!"
	done

MersonGoldTokenExchange_Text_RequirementsForSpecialGift:
	ctxt "I have a very"
	line "special gift for"
	cont "those who"
	cont "complete their"
	cont "Naljo #dex!"

	para "Come back when"
	line "you complete it"
	cont "to get a very"
	cont "special gift."
	done

MersonGoldTokenExchange_Text_AfterFillingDex:
	ctxt "I'm still in shock"
	line "and awe over your"
	cont "accomplishment."

	para "You've made a"
	line "#mon fan very"
	cont "happy."
	done

MersonGoldTokenExchange_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $5, $4, 2, MERSON_CITY
	warp_def $5, $5, 2, MERSON_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_GENTLEMAN, 3, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, 8 + PAL_OW_YELLOW, 0, 0, MersonGoldTokenExchangeNPC, -1
