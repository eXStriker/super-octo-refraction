PopMonFromBox:
	ld a, BANK(sBoxCount)
	call GetSRAMBank
	ld hl, sBoxCount
	call RemoveIndexFromSpeciesList
	ld a, [sBoxCount]
	dec a
	ld [wd265], a
	ld hl, sBoxMonNicknames
	ld bc, PKMN_NAME_LENGTH
	ld de, wBufferMonNick
	call PopObjectFromArray
	ld a, [sBoxCount]
	dec a
	ld [wd265], a
	ld hl, sBoxMonOT
	ld bc, NAME_LENGTH
	ld de, wBufferMonOT
	call PopObjectFromArray
	ld a, [sBoxCount]
	dec a
	ld [wd265], a
	ld hl, sBoxMons
	ld bc, BOXMON_STRUCT_LENGTH
	ld de, wBufferMon
	call PopObjectFromArray
	ld hl, wBufferMonMoves
	ld de, TempMonMoves
	ld bc, NUM_MOVES
	rst CopyBytes
	ld hl, wBufferMonPP
	ld de, TempMonPP
	ld bc, NUM_MOVES
	rst CopyBytes
	ld a, [wCurPartyMon]
	ld b, a
	callba RestorePPOfWithdrawnBoxMon
	jp CloseSRAM

PopMonFromParty:
	ld hl, wPartyCount
	call RemoveIndexFromSpeciesList
	ld a, [wPartyCount]
	dec a
	ld [wd265], a
	ld hl, wPartyMonNicknames
	ld bc, PKMN_NAME_LENGTH
	ld de, wBufferMonNick
	call PopObjectFromArray
	ld a, [wPartyCount]
	dec a
	ld [wd265], a
	ld hl, wPartyMonOT
	ld bc, NAME_LENGTH
	ld de, wBufferMonOT
	call PopObjectFromArray
	ld a, [wPartyCount]
	dec a
	ld [wd265], a
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	ld de, wBufferMon
	jp PopObjectFromArray

RemoveIndexFromSpeciesList:
	inc [hl]
	inc hl
	ld a, [wCurPartyMon]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wCurPartySpecies]
	ld c, a
.loop
	ld a, [hl]
	ld [hl], c
	inc hl
	inc c
	ld c, a
	jr nz, .loop
	ret

PopObjectFromArray:
	push de
	push hl
	push bc
	ld a, [wd265]
	dec a
	rst AddNTimes
	push hl
	add hl, bc
	ld d, h
	ld e, l
	pop hl
.loop
	push bc
	ld a, [wd265]
	ld b, a
	ld a, [wCurPartyMon]
	cp b
	pop bc
	jr z, .done
	push hl
	push de
	push bc
	rst CopyBytes
	pop bc
	pop de
	pop hl
	push hl
	ld a, l
	sub c
	ld l, a
	ld a, h
	sbc b
	ld h, a
	pop de
	ld a, [wd265]
	dec a
	ld [wd265], a
	jr .loop

.done
	pop bc
	pop hl
	ld a, [wCurPartyMon]
	rst AddNTimes
	ld d, h
	ld e, l
	pop hl
	rst CopyBytes
	ret
