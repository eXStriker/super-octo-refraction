OwsauriStatEXP_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

OwsauriStatEXPNPC:
	faceplayer
	opentext
	writetext OwsauriStatEXPNPC_Text_Introduction
	yesorno
	sif false, then
		closetext
		end
	sendif
	checkmoney 0, 500
	sif =, 2
		jumptext OwsauriStatEXPNPC_Text_NotEnoughMoney
	takemoney 0, 500
	writetext OwsauriStatEXPNPC_Text_ChooseAMon
	waitbutton
	special Special_SelectMonFromParty
	iffalse .refund
	writetext OwsauriStatEXPNPC_Text_ChooseAStat
	loadmenudata StatEXPCheckMenu
	verticalmenu
	closewindow
	iffalse .refund
	jumptext OwsauriStatEXP_ShowEXP
.refund
	givemoney 0, 500
	closetext
	end

StatEXPCheckMenu:
	db $40 ; flags
	db 00, 05 ; start coords
	db 11, 19 ; end coords
	dw StatEXPCheckMenuOptions
	db 1 ; default option

StatEXPCheckMenuOptions:
	db $80
	db $5
StatExpStatNames:
	db "HP@"
	db "Attack@"
	db "Defense@"
	db "Speed@"
	db "Special@"

OwsauriStatEXPNPC_Text_Introduction:
	ctxt "For ¥500 I can"
	line "tell you the Stat"

	para "Experience of one"
	line "of your #mon."

	para "Interested?"
	done

OwsauriStatEXPNPC_Text_NotEnoughMoney:
	ctxt "Sorry, you don't"
	line "have enough money."
	done

OwsauriStatEXPNPC_Text_ChooseAMon:
	ctxt "Choose a #mon"
	line "you want me to"
	cont "check."
	done

OwsauriStatEXPNPC_Text_ChooseAStat:
	ctxt "Which stat do you"
	line "want me to check?"
	done

OwsauriStatEXP_ShowEXP:
	start_asm
	push bc
	ld a, [wPartyMenuCursor]
	dec a
	ld bc, PARTYMON_STRUCT_LENGTH
	ld hl, wPartyMon1 + MON_HP_EXP
	rst AddNTimes
	ld a, [hScriptVar]
	dec a
	push af
	add a, a
	ld c, a
	ld b, 0
	add hl, bc
	ld de, TempNumber
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld a, "@"
	ld hl, wStringBuffer1
	ld c, 8 ; b is already 0
	call ByteFill
	pop af
	ld hl, StatExpStatNames
	call GetNthString
	ld d, h
	ld e, l
	ld hl, wStringBuffer1
	call PlaceString
	pop bc
	ld hl, .text
	ret
.text
	ctxt "<STRBF1> EXP:"
	line "@"
	deciram TempNumber, 2, 5
	ctxt "/65535"
	done

OwsauriStatEXP_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 5, OWSAURI_CITY
	warp_def $7, $3, 5, OWSAURI_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_PHARMACIST, 3, 5, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, OwsauriStatEXPNPC, -1
