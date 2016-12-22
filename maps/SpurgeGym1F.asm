SpurgeGym1F_MapScriptHeader;trigger count
	db 2
	maptrigger .Trigger0
	maptrigger .Trigger1

 ;callback count
	db 0

.Trigger0
	priorityjump .Script
.Trigger1
	end

.Script:
	checkevent EVENT_ENTERED_SPURGE_GYM
	clearevent EVENT_ENTERED_SPURGE_GYM
	iffalse .done
	checkevent EVENT_SPURGE_GYM_B1F_ITEM_2
	iffalse .noDynamite
	checkevent EVENT_SPURGE_GYM_SMASHROCK
	iftrue .noDynamite
	takeitem DYNAMITE, 1
.noDynamite
	callasm UnhideParty
	applymovement 2, .GymLeaderMovementAfterPlayerQuits
	faceperson PLAYER, 2
	opentext
	writetext GymLeaderAfterPlayerQuitsText
	waitbutton
	closetext
	applymovement 2, .GymLeaderMovementReturnToOriginalSpot
.done
	dotrigger $1
	end

.GymLeaderMovementAfterPlayerQuits:
	step_down
	step_end

.GymLeaderMovementReturnToOriginalSpot:
	step_up
	step_end
	
SpurgeGymSignpost:
	jumptext SpurgeGymSignpostText

UnhideParty:
	ld hl, wPartyCount
	ld a, [hli]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wBackupSecondPartySpecies]
	ld [hl], a
	ld a, $ff
	ld [wPartyEnd], a
	ld a, 6
	ld [wPartyCount], a
	ret

SpurgeGym1FNPC1:
	faceplayer
	opentext
	checkevent EVENT_SPURGE_GYM_DEFEATED
	sif true
		jumptext SpurgeGym1FNPC1_Text_OpportunityToFaceEliteFour

	checkcode VAR_PARTYCOUNT
	sif !=, 6
		jumptext SpurgeGym1FNPC1_Text_ThisGymRequires6Pokemon

	callasm .CheckPartyForEggs
	sif false
		jumptext SpurgeGym1FNPC1_Text_PartyHasEggInIt

	writetext SpurgeGym1FNPC1_Text_2fb03f
	waitbutton
	closetext
	playsound SFX_ENTER_DOOR
	changeblock 4, 2, $17
	reloadmappart
	pause 16
	blackoutmod SPURGE_GYM_1F
	special HealParty
	callasm SpurgeHidePokemon
	setevent EVENT_ENTERED_SPURGE_GYM
	clearevent EVENT_SPURGE_GYM_POKEMON_1
	clearevent EVENT_SPURGE_GYM_POKEMON_2
	clearevent EVENT_SPURGE_GYM_POKEMON_3
	clearevent EVENT_SPURGE_GYM_POKEMON_4
	clearevent EVENT_SPURGE_GYM_POKEMON_5
	clearevent EVENT_SPURGE_GYM_POKEMON_6
	clearevent EVENT_SPURGE_GYM_B1F_NPC_2
	clearevent EVENT_SPURGE_GYM_B1F_NPC_3
	clearevent EVENT_SPURGE_GYM_B1F_NPC_4
	clearevent EVENT_SPURGE_GYM_B1F_NPC_5
	clearevent EVENT_SPURGE_GYM_PUSHROCK
	clearevent EVENT_SPURGE_GYM_B1F_ITEM_2
	clearevent EVENT_SPURGE_GYM_SWITCH_ENABLED
	clearevent EVENT_SPURGE_GYM_SMASHROCK
	applymovement PLAYER, SpurgeGym1FNPC1_HidePlayer
	warp SPURGE_GYM_B1F, 20, 36
	warpsound
	applymovement PLAYER, SpurgeGym1FNPC1_Movement1
	domaptrigger SPURGE_GYM_1F, $0
	jumptext SpurgeGym1F_2fb1ba_Text_2fb0e0

.CheckPartyForEggs:
	ld hl, wPartySpecies
	xor a
	ld [hScriptVar], a
.loop
	ld a, [hli]
	cp EGG
	ret z
	inc a
	jr nz, .loop
	inc a
	ld [hScriptVar], a
	ret

SpurgeGym1FNPC1_HidePlayer:
	skyfall_top
	step_end

SpurgeGym1FNPC1_Movement1:
	skyfall
	step_end

SpurgeGym1FNPC2:
	jumpstd strengthboulder

SpurgeGym1FNPC3:
	jumpstd smashrock

SpurgeHidePokemon:
	ld de, wMisc
	ld bc, wPartyMon1
	ld h, 6
.loop
	push hl
	ld hl, MON_LEVEL
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc de
	cp MAX_LEVEL
	jr nc, .atMaxLevel
	ld [TempMonLevel], a
	push de
	push bc
	call CalcExpToNextLevelPercent
	pop bc
	pop de
	ld a, [hLongQuotient + 3]
	cpl
	jr .writePercent
.atMaxLevel
	call Random
.writePercent
	ld [de], a
	inc de
	ld a, PARTYMON_STRUCT_LENGTH
	add c
	ld c, a
	jr nc, .noCarry
	inc b
.noCarry
	pop hl
	ld a, 6
	sub h
	ld [de], a
	inc de
	dec h
	jr nz, .loop

	call SortPartyFromWeakestToStrongest
	call ReorganizeParty
	ld hl, wPartySpecies
	ld a, [hld]
	ld [wBackupSecondPartySpecies], a
	xor a
	ld [hli], a
	ld [hl], $ff
	ret

CalcExpToNextLevelPercent:
	ld hl, MON_EXP
	add hl, bc
	ld de, TempMonExp
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	callba CalcExpToNextLevel
	ld a, [TempMonLevel]
	ld d, a
	callba CalcExpAtLevel
	ld hl, wTotalExpToNextLevel + 2

	ld a, [hQuotient + 2]
	ld b, a
	ld a, [hld]
	sub b
	ld e, a

	ld a, [hQuotient + 1]
	ld b, a
	ld a, [hld]
	sbc b
	ld d, a

	ld a, [hQuotient]
	ld b, a
	ld a, [hl]
	sbc b
	ld c, a
	jr z, .notFluctuatingL99
; scale both exp values by 2
; scale wTotalExpToNextLevel
	srl c
	rr d
	rr e
; scale wTotalExpToNextLevel
	ld hl, wExpToNextLevel
	srl [hl]
	inc hl
	rr [hl]
	inc hl
	rr [hl]
.notFluctuatingL99
	ld hl, wExpToNextLevel + 1
	ld a, [hli]
	ld [hMultiplicand + 1], a
	ld a, [hl]
	ld [hMultiplicand + 2], a
	xor a
	ld [hMultiplicand], a
	dec a
	ld [hMultiplier], a
	predef Multiply
	ld a, d
	ld [hDivisor], a
	ld a, e
	ld [hDivisor + 1], a
	predef_jump DivideLong

SortPartyFromWeakestToStrongest:
	ld hl, wMisc
	ld c, 6
.loop1
	push hl
	push bc
	call .SortIteration
	pop bc
	pop hl
	jr c, .loop1
	ld hl, wWeakestToStrongestMonList + 2
	ld de, wMisc
	ld c, 6
.loop2
	ld a, [hli]
	ld [de], a
	inc hl
	inc hl
	inc de
	dec c
	jr nz, .loop2
	ret

.SortIteration:
; make sure the list of c items at hl is currently in descending order
; items: 16-bit big-endian value, 8-bit index
; swap the items and return carry if it's not in descending order
	ld de, 0
	ld b, -1
.loop
	ld a, [hli]
	cp d
	jr c, .swap
	jr nz, .replace_de
	ld a, [hl]
	cp e
	jr c, .swap
.replace_de
	dec hl
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld b, a
	dec c
	jr nz, .loop
	and a
	ret

.swap
	inc hl
	ld a, [hl]
	ld [hl], b
	ld b, a
	dec hl
	ld a, [hl]
	ld [hl], e
	ld e, a
	dec hl
	ld a, [hl]
	ld [hl], d
	ld d, a
	dec hl
	ld [hl], b
	dec hl
	ld [hl], e
	dec hl
	ld [hl], d
	scf
	ret

ReorganizeParty:
; copy species
; copy mon data
; copy ot name
; copy nickname
	xor a
.loop
	ld [hMonToStore], a
	ld hl, wWeakestToStrongestMonList
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [hMonToCopy], a

	ld de, wPartySpecies
	add e
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
	ld hl, wPartySpeciesMisc
	add hl, bc
	ld a, [de]
	ld [hl], a

	ld hl, wPartyMon1Misc
	ld de, wPartyMon1
	ld bc, PARTYMON_STRUCT_LENGTH
	call .CopyPartymonDataToMisc

	ld hl, wPartyMonOTMisc
	ld de, wPartyMonOT
	ld bc, NAME_LENGTH
	push bc
	call .CopyPartymonDataToMisc
	pop bc

	ld hl, wPartyMonNicknamesMisc
	ld de, wPartyMonNicknames
	call .CopyPartymonDataToMisc

.handleLoop
	ld a, [hMonToStore]
	inc a
	cp 6
	jr nz, .loop
	ld [wPartyCountMisc], a
	ld a, $ff
	ld [wPartyEndMisc], a
	ld hl, wPokemonDataMisc
	ld de, wPokemonData
	ld bc, wPokemonDataMiscEnd - wPokemonDataMisc
	rst CopyBytes
	ret

.CopyPartymonDataToMisc:
	ld a, [hMonToStore]
	rst AddNTimes
	push hl
	ld h, d
	ld l, e
	ld a, [hMonToCopy]
	rst AddNTimes
	pop de
	rst CopyBytes
	ret
	
SpurgeGymSignpostText:
	ctxt "Spurge Gym"
	
	para "Leader: Bruce"
	done

SpurgeGym1FNPC1_Text_ThisGymRequires6Pokemon:
	ctxt "Sorry, this gym"
	line "requires for you"

	para "to have a full"
	line "party of six."

	para "Come back with"
	line "a full team and"
	cont "then we'll talk."

	para "Also, don't bring"
	line "any eggs into your"
	cont "party, please."

	para "It's for your"
	line "benefit, anyway."
	done

SpurgeGym1FNPC1_Text_PartyHasEggInIt:
	ctxt "Sorry, eggs aren't"
	line "allowed in this"
	cont "Gym challenge."

	para "Come back with no"
	line "eggs in your party"

	para "if you want to"
	line "challenge the Gym."
	done

SpurgeGym1FNPC1_Text_2fb03f:
	ctxt "Welcome Trainer!"

	para "Are you ready to"
	line "fight for the"
	cont "Naljo Badge?"

	para "<...>"

	para "Well, I'm not."
	done

SpurgeGym1F_2fb1ba_Text_2fb0e0:
	ctxt "Here's the skinny."

	para "I've taken all of"
	line "your #mon."

	para "Once you find all"
	line "of them, come and"

	para "find me. Then I'll"
	line "see if you're"

	para "truly worthy of"
	line "getting my badge."
	done

GymLeaderAfterPlayerQuitsText:
	ctxt "Not up for the"
	line "challenge?"

	para "Here are your"
	line "#mon back,"
	cont "then. Bummer."

	para "Come back once"
	line "you get stronger."
	done

SpurgeGym1FNPC1_Text_OpportunityToFaceEliteFour:
	ctxt "Now that you have"
	line "the Naljo Badge,"

	para "you will be able"
	line "to compete in the"
	cont "Rijon League!"

	para "To get there,"
	line "go to Acania Docks"
	cont "and head east."

	para "You'll reach the"
	line "Naljo Border,"

	para "where you'll be"
	line "able to enter the"
	cont "Seneca Caverns."

	para "From that point"
	line "on, you'll have to"

	para "rely on your own"
	line "skill to navigate"

	para "through it in"
	line "order to reach"
	cont "the Rijon League."

	para "Stay strong!"
	done

SpurgeGym1F_MapEventHeader:: db 0, 0

.Warps: db 2
	warp_def 13, 4, 6, SPURGE_CITY
	warp_def 13, 5, 6, SPURGE_CITY

.CoordEvents: db 0

.BGEvents: db 2
	signpost 11, 2, SIGNPOST_READ, SpurgeGymSignpost
	signpost 11, 7, SIGNPOST_READ, SpurgeGymSignpost

.ObjectEvents: db 1
	person_event SPRITE_CLAIR, 2, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, SpurgeGym1FNPC1, -1
