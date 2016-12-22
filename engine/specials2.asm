SpecialGiveNobusAggron: ; 7305

; Adding to the party.
	xor a
	ld [wMonType], a

; Nobu's Aggron
	ld a, AGGRON
	ld [wCurPartySpecies], a
	ld a, 40
	ld [CurPartyLevel], a

	predef TryAddMonToParty
	jr nc, .NotGiven

; Caught data.
	ld b, 0
	callba SetGiftPartyMonCaughtData

; Holding a Berry.
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wPartyCount]
	dec a
	push af
	push bc
	ld hl, PartyMon1Item
	rst AddNTimes
	ld [hl], METAL_COAT
	pop bc
	pop af

; OT ID.
	ld hl, PartyMon1ID
	rst AddNTimes
	ld a, 00518 >> 8
	ld [hli], a
	ld [hl], 00518 & $ff

; Nickname.
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMonNicknames
	call SkipNames
	ld de, SpecialShuckleNick
	call CopyName2

; OT.
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMonOT
	call SkipNames
	ld de, SpecialShuckleOT
	call CopyName2
	ld [hl], "F"

; Engine flag for this event.
	ld hl, DailyFlags
	set 5, [hl]
; setflag ENGINE_SHUCKLE_GIVEN
	ld a, 1
	ld [hScriptVar], a
	ret

.NotGiven
	xor a
	ld [hScriptVar], a
	ret

SpecialShuckleOT:
	db "Nobu@F"
SpecialShuckleOTEnd:

SpecialShuckleNick:
	db "Aggron@"

SpecialReturnNobusAggron: ; 737e
	call _SpecialReturnNobusAggron
	ld [hScriptVar], a
	ret

_SpecialReturnNobusAggron:
	callba SelectMonFromParty
	ld a, $1
	ret c ; refused

	ld a, [wCurPartySpecies]
	cp AGGRON
	jr nz, .DontReturn

	ld a, [wCurPartyMon]
	ld hl, PartyMon1ID
	call GetPartyLocation

; OT ID
	ld a, [hli]
	cp 00518 >> 8
	jr nz, .DontReturn
	ld a, [hl]
	cp 00518 & $ff
	jr nz, .DontReturn

; OT
	ld a, [wCurPartyMon]
	ld hl, wPartyMonOT
	call SkipNames
	ld de, SpecialShuckleOT
	ld c, SpecialShuckleOTEnd - SpecialShuckleOT
	call StringCmp
	jr nz, .DontReturn ; not the correct mon
	callba CheckIfOnlyAliveMonIsCurPartyMon
	ld a, $3 ; fainted
	ret c
	xor a ; take from party
	ld [wPokemonWithdrawDepositParameter], a
	callba RemoveMonFromPartyOrBox
	ld a, $2 ; gave aggron back
	ret

.DontReturn
	xor a
	ret

Special_SelectMonFromParty:: ; 73f7
	callba SelectMonFromParty
	jr c, .cancel
	callba CheckForSpecialGiftMon
	ld a, $ff
	jr c, .specialGiftMon
	ld a, [wCurPartySpecies]
	ld [hScriptVar], a
	ld [wNamedObjectIndexBuffer], a
	call GetPokemonName
	jp CopyPokemonName_Buffer1_Buffer3

.cancel
	xor a
.specialGiftMon
	ld [hScriptVar], a
	ret

Special_YoungerHaircutBrother: ; 7413
	ld hl, Data_YoungerHaircutBrother
	jr MassageOrHaircut

Special_OlderHaircutBrother: ; 7418
	ld hl, Data_OlderHaircutBrother
	jr MassageOrHaircut

Special_DaisyMassage: ; 741d
	ld hl, Data_DaisyMassage

MassageOrHaircut: ; 7420
	push hl
	callba SelectMonFromParty
	pop hl
	jr c, .nope
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .egg
	push hl
	call GetCurNick
	call CopyPokemonName_Buffer1_Buffer3
	pop hl
	call Random
; Bug: Subtracting $ff from $ff fails to set c.
; This can result in overflow into the next data array.
; In the case of getting a massage from Daisy, we bleed
; into CopyPokemonName_Buffer1_Buffer3, which passes
; $d0 to ChangeHappiness and returns $73 to the script.
; The end result is that there is a 0.4% chance your
; Pokemon's happiness will not change at all.
.loop
	sub [hl]
	jr c, .ok
	inc hl
	inc hl
	inc hl
	jr .loop

.ok
	inc hl
	ld a, [hli]
	ld [hScriptVar], a
	ld c, [hl]
	jp ChangeHappiness

.nope
	xor a
	ld [hScriptVar], a
	ret

.egg
	ld a, 1
	ld [hScriptVar], a
	ret

Data_YoungerHaircutBrother: ; 7459
	db $4c, 2, HAPPINESS_YOUNGCUT1 ; 30% chance
	db $80, 3, HAPPINESS_YOUNGCUT2 ; 20% chance
	db $ff, 4, HAPPINESS_YOUNGCUT3 ; 50% chance

Data_OlderHaircutBrother: ; 7462
	db $9a, 2, HAPPINESS_OLDERCUT1 ; 60% chance
	db $4c, 3, HAPPINESS_OLDERCUT2 ; 10% chance
	db $ff, 4, HAPPINESS_OLDERCUT3 ; 30% chance

Data_DaisyMassage: ; 746b
	db $ff, 2, HAPPINESS_MASSAGE ; 99.6% chance

CopyPokemonName_Buffer1_Buffer3: ; 746e
	ld hl, wStringBuffer1
	ld de, wStringBuffer3
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	ret
