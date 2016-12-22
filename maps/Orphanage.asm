Orphanage_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

OrphanageNPC1:
	faceplayer
	checkevent EVENT_GET_ORPHAN_CARD
	iffalse .giveOrphanCard
	faceplayer
	opentext
	checkcode VAR_PARTYCOUNT
	sif <, 2
		jumptext Orphanage_Text_CantDonateOnlyMon
	writetext OrphanageNPC1_Text_182eb0
	waitbutton
	special Special_SelectMonFromParty
	sif false
		jumptext Orphanage_Text_ChangedYourMind
	sif =, $ff
		jumptext Orphanage_Text_WeCantAcceptThisMon
	sif =, EGG
		jumptext Orphanage_Text_DontAcceptEggs
	callasm OrphanageCalculatePoints
	writetext Orphanage_Text_DonateAreYouSure
	yesorno
	iffalse .done
	callasm OrphanageTrackDonatedMon
	callasm OrphanageGiveOrphanPoints
	writetext Orphanage_Text_ThankYouForDonating
	waitbutton
	callasm DeletePartyPoke
	special HealParty
	playwaitsfx SFX_HEAL_POKEMON
.done
	jumptext Orphanage_Text_WeHopeToSeeYouAgain

.giveOrphanCard:
	opentext
	writetext Orphanage_1835cf_Text_183760
	waitbutton
	verbosegiveitem ORPHAN_CARD, 1
	waitbutton
	writetext Orphanage_1835cf_Text_183876
	setevent EVENT_GET_ORPHAN_CARD
	endtext

OrphanageTrackDonatedMon:
	ld hl, wOrphanageDonation1
	push hl
	ld de, wOrphanageDonation2
	ld c, wOrphanageDonationEnd - wOrphanageDonation2
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	call UpdateTime
	ld a, [wCurPartySpecies]
	pop hl
	ld [hli], a
	ld de, CurYear
	rept 2
		ld a, [de]
		inc de
		ld [hli], a
	endr
	ld a, [de]
	ld [hl], a
	ret

OrphanageGiveOrphanPoints:
	ld a, [wCurPartySpecies]
	call PlayCry
	ld hl, TempNumber
	ld a, [hli]
	ld [hMoneyTemp], a
	ld a, [hl]
	ld [hMoneyTemp + 1], a
	ld bc, hMoneyTemp
	push hl
	callba GiveOrphanPoints
	pop hl
	ld a, [hld]
	ld b, [hl]
	ld hl, wAccumulatedOrphanPoints + 3
	add [hl]
	ld [hld], a
	ld a, b
	adc [hl]
	ld [hld], a
	ret nc
	inc [hl]
	ret nz
	dec hl
	inc [hl]
	ret

DeletePartyPoke:
	xor a
	ld [wPokemonWithdrawDepositParameter], a
	jpba RemoveMonFromPartyOrBox

OrphanageCalculatePoints:
	ld a, MON_DVS
	call GetPartyParamLocation
	; Get the attributes of the Party Pokemon
	ld bc, 0

	push hl
	call .GetIVScore
	call .GetIVScore  ;Max: 12

	ld de, MON_LEVEL - (MON_DVS + 2)
	add hl, de
	ld a, [hl]
	call .AddOneQuarterA ; Max: 37

	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	call GetBaseData
	ld a, [BaseCatchRate]
	cpl
	call .AddOneEighthA ; Max: 68

	ld a, [BaseExp]
	call .AddOneEighthA ; Max: 99
	inc c ; Max: 100

	pop hl ; recover the DVs pointer
	callba CheckShininessHL
	ld h, b
	ld l, c
	jr nc, .NotShiny
	; Max if shiny: 400
	add hl, hl
	add hl, hl
.NotShiny
	ld a, h
	ld [TempNumber], a
	ld a, l
	ld [TempNumber + 1], a
	ret

.GetIVScore:
	ld a, [hl]
	and $f
	call .AddOneQuarterA
	ld a, [hli]
	swap a
	and $f
	jr .AddOneQuarterA

.AddOneEighthA:
	srl a
.AddOneQuarterA:
	srl a
	srl a
	add c
	ld c, a
	ret

OrphanageNPC2:
	faceplayer
	opentext
	writetext OrphanageNPC2_Text_1839a4
	waitbutton
.loop
	writetext OrphanageNPC2_Text_1839eb
	loadmenudata OrphanageMenu
	verticalmenu
	closewindow
	addvar -1
	sif >, 3
		jumptext OrphanageNPC2_Text_ComeAgainToAdopt
	loadarray .OrphanageAdoptedPokemonArray
	readarrayhalfword 4
	checkevent -1
	sif true
		jumptext Orphanage_Text_AlreadyReceivedMon
	readarrayhalfword 2
	checkorphanpoints -1
	sif =, 2
		jumptext Orphanage_Text_NeedMorePoints
	checkcode VAR_PARTYCOUNT
	sif =, 6, then
		checkcode VAR_BOXSPACE
		sif false
			jumptext Orphanage_Text_PartyAndBoxFull
	sendif
	writetext Orphanage_Text_AdoptAreYouSure
	yesorno
	sif false
		jumptext OrphanageNPC2_Text_ComeAgainToAdopt
	writetext Orphanage_Text_TakeCareOfIt
	waitbutton
	readarray 0
	special Special_GameCornerPrizeMonCheckDex
	cmdwitharrayargs .CustomGivePokeEnd - .CustomGivePoke
.CustomGivePoke
	db givepoke_command, %0011, 0, 1, NO_ITEM, 0
.CustomGivePokeEnd
	readarrayhalfword 4
	setevent -1
	readarrayhalfword 2
	takeorphanpoints -1
	jump .loop

adopt_mon: MACRO
; input: pokemon, level, orphan point cost
; output:
; 0. pokemon
; 1. level
; 2. orphan point cost
; 4. event flag
	db \1, \2
	dw \3, EVENT_ADOPTED_\1
ENDM

.OrphanageAdoptedPokemonArray:
	adopt_mon CHIKORITA, 10, 100
.OrphanageAdoptedPokemonArrayEntrySizeEnd:
	adopt_mon EEVEE, 15, 250
	adopt_mon TOGEPI, 15, 500
	adopt_mon RIOLU, 15, 1000

OrphanageMenu:
	db $40 ; flags
	db 00, 00 ; start coords
	db 11, 19 ; end coords
	dw OrphanageMenuOptions
	db 1 ; default option

OrphanageMenuOptions:
	db $80 ; flags
	db 5
	db "Chikorita    100@"
	db "Eevee        250@"
	db "Togepi       500@"
	db "Riolu       1000@"
	db "Cancel@"

OrphanageNPC1_Text_182eb0:
	ctxt "Welcome to the"
	line "#mon orphanage."

	para "Which #mon"
	line "would you like to"
	cont "donate?"
	done

OrphanageNPC2_Text_1839a4:
	ctxt "Hello, you can"
	line "exchange your"
	cont "Orphan Points for"
	cont "#mon up for"
	cont "adoption."
	done

OrphanageNPC2_Text_1839eb:
	ctxt "Which #mon do"
	line "you want?"
	done

Orphanage_1835cf_Text_183760:
	ctxt "Welcome to the"
	line "#mon orphanage."

	para "Many people catch"
	line "#mon and leave"
	para "the poor things"
	line "in their PCs"
	cont "forever."

	para "We are here to"
	line "prevent that, and"
	para "give the unwanted"
	line "#mon to people"
	para "who actually care"
	line "about them."

	para "Since this is"
	line "your first time"
	para "here, I will give"
	line "you your very own"
	cont "Orphan Card."
	done

Orphanage_1835cf_Text_183876:
	ctxt "Every time you"
	line "donate a #mon,"
	cont "I will put points"
	cont "on your card."

	para "The amount of"
	line "points are based"
	cont "on various factors"
	cont "of the #mon."

	para "Once you get"
	line "enough points, you"
	cont "can exchange"
	cont "points for a"
	cont "#mon that's up"
	cont "for adoption."

	para "If you are truly"
	line "interested in"
	cont "donating to us,"
	cont "talk to me again."
	done

Orphanage_Text_CantDonateOnlyMon:
	ctxt "You can't donate"
	line "your only #mon."
	done

Orphanage_Text_DontAcceptEggs:
	ctxt "I'm sorry, but we"
	line "don't accept eggs."
	done

Orphanage_Text_ChangedYourMind:
	ctxt "Changed your mind?"

	para "If you have a"
	line "change of heart,"

	para "please consider"
	line "donating."
	done

OrphanageNPC2_Text_ComeAgainToAdopt:
	ctxt "Come again if you"
	line "want to adopt a"
	cont "#mon."
	done

Orphanage_Text_WeHopeToSeeYouAgain:
	ctxt "We hope to see you"
	line "again."
	done

Orphanage_Text_WeCantAcceptThisMon:
	ctxt "I'm sorry, but we"
	line "cannot accept this"
	cont "#mon."
	done

Orphanage_Text_PartyAndBoxFull:
	ctxt "I'm sorry, but your"
	line "party and box are"
	cont "both full."
	done

Orphanage_Text_DonateAreYouSure:
	ctxt "Are you sure you"
	line "want to donate"
	cont "<STRBF1>?"
	done

Orphanage_Text_AdoptAreYouSure:
	ctxt "Are you sure you"
	line "want to adopt"
	cont "this #mon?"
	done

Orphanage_Text_TakeCareOfIt:
	ctxt "Thank you!"

	para "Please take good"
	line "care of it!"
	done

Orphanage_Text_ThankYouForDonating:
	ctxt "Thank you for"
	line "your donation."

	para "I have put @"
	deciram TempNumber, 2, 0
	ctxt ""
	line "points on your"
	cont "card."

	para "We will also"
	line "heal your party,"
	cont "as a complimentary"
	cont "service."
	done

Orphanage_Text_AlreadyReceivedMon:
	ctxt "You already"
	line "received this"
	cont "#mon!"
	done

Orphanage_Text_NeedMorePoints:
	ctxt "You need more"
	line "points for this"
	cont "#mon."
	done

Orphanage_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $15, $e, 7, SPURGE_CITY
	warp_def $15, $f, 7, SPURGE_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_BUENA, 11, 8, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 0, 0, OrphanageNPC1, -1
	person_event SPRITE_COOLTRAINER_F, 19, 7, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 0, 0, OrphanageNPC2, -1
