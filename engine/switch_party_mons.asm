_SwitchPartyMons:
	ld a, [wSwitchMon]
	ld [wSwitchMon2], a
	ld a, [wCurPartyMon]
	ld [wSwitchMon1], a

	call .SwapMon
	ld a, [wSwitchMon2]
	call .ClearSprite
	ld a, [wSwitchMon1]

.ClearSprite: ; 50f34 (14:4f34)
	push af
	hlcoord 0, 1
	ld bc, 2 * SCREEN_WIDTH
	rst AddNTimes
	ld bc, 2 * SCREEN_WIDTH
	ld a, " "
	call ByteFill
	pop af
	ld hl, Sprites
	ld bc, $10
	rst AddNTimes
	ld de, $4
	ld c, $4
.gfx_loop
	ld [hl], $a0
	add hl, de
	dec c
	jr nz, .gfx_loop
	ld de, SFX_SWITCH_POKEMON
	jp WaitPlaySFX

.SwapMon: ; 50f62 (14:4f62)
	push hl
	push de
	push bc

	; Swap species via stack
	ld bc, wPartySpecies
	ld a, [wSwitchMon1]
	ld l, a
	ld h, 0
	add hl, bc
	ld d, h
	ld e, l

	ld a, [wSwitchMon2]
	ld l, a
	ld h, 0
	add hl, bc

	ld a, [hl]
	push af
	ld a, [de]
	ld [hl], a
	pop af
	ld [de], a

	; Swap mon structs via wd002
	ld a, [wSwitchMon1]
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	push hl
	ld de, wd002
	ld bc, PARTYMON_STRUCT_LENGTH
	rst CopyBytes

	ld a, [wSwitchMon2]
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	pop de
	push hl
	ld bc, PARTYMON_STRUCT_LENGTH
	rst CopyBytes

	pop de
	ld hl, wd002
	ld bc, PARTYMON_STRUCT_LENGTH
	rst CopyBytes

	; Swap OT names via wd002
	ld a, [wSwitchMon1]
	ld hl, wPartyMonOT
	call SkipNames
	push hl
	call .CopyNameTowd002

	ld a, [wSwitchMon2]
	ld hl, wPartyMonOT
	call SkipNames
	pop de
	push hl
	call .CopyName

	pop de
	ld hl, wd002
	call .CopyName

	; Swap nicknames via wd002
	ld hl, wPartyMonNicknames
	ld a, [wSwitchMon1]
	call SkipNames
	push hl
	call .CopyNameTowd002

	ld hl, wPartyMonNicknames
	ld a, [wSwitchMon2]
	call SkipNames
	pop de
	push hl
	call .CopyName

	pop de
	ld hl, wd002
	call .CopyName

	pop bc
	pop de
	pop hl
	ret

.CopyNameTowd002: ; 51036 (14:5036)
	ld de, wd002
.CopyName: ; 51039 (14:5039)
	ld bc, NAME_LENGTH
	rst CopyBytes
	ret
