CheckBreedmonCompatibility:
	call .CheckBreedingGroupCompatibility
	ld c, $0
	jp nc, .done
	ld a, [wBreedMon1Species]
	ld [wCurPartySpecies], a
	ld a, [wBreedMon1DVs]
	ld [TempMonDVs], a
	ld a, [wBreedMon1DVs + 1]
	ld [TempMonDVs + 1], a
	ld a, BREEDMON
	ld [wMonType], a
	predef GetGender
	jr c, .genderless
	ld b, $1
	jr nz, .breedmon2
	inc b

.breedmon2
	push bc
	ld a, [wBreedMon2Species]
	ld [wCurPartySpecies], a
	ld a, [wBreedMon2DVs]
	ld [TempMonDVs], a
	ld a, [wBreedMon2DVs + 1]
	ld [TempMonDVs + 1], a
	ld a, $3
	ld [wMonType], a
	predef GetGender
	pop bc
	jr c, .genderless
	ld a, $1
	jr nz, .compare_gender
	inc a

.compare_gender
	cp b
	jr nz, .compute

.genderless
	ld c, $0
	ld a, [wBreedMon1Species]
	cp DITTO
	jr z, .ditto1
	ld a, [wBreedMon2Species]
	cp DITTO
	jr nz, .done
	jr .compute

.ditto1
	ld a, [wBreedMon2Species]
	cp DITTO
	jr z, .done

.compute
	call .CheckDVs
	ld c, 255
	jp z, .done
	ld a, [wBreedMon2Species]
	ld b, a
	ld a, [wBreedMon1Species]
	cp b
	ld c, 254
	jr z, .compare_ids
	ld c, 128
.compare_ids
	; Speed up
	ld a, [wBreedMon1ID]
	ld b, a
	ld a, [wBreedMon2ID]
	cp b
	jr nz, .done
	ld a, [wBreedMon1ID + 1]
	ld b, a
	ld a, [wBreedMon2ID + 1]
	cp b
	jr nz, .done
	ld a, c
	sub 77
	ld c, a

.done
	ld a, c
	ld [wd265], a
	ret

.CheckDVs
; If Defense DVs match and the lower 3 bits of the Special DVs match,
; maximize the chances of spawning an egg regardless of species.
	ld a, [wBreedMon1DVs]
	and %1111
	ld b, a
	ld a, [wBreedMon2DVs]
	and %1111
	cp b
	ret nz
	ld a, [wBreedMon1DVs + 1]
	and %111
	ld b, a
	ld a, [wBreedMon2DVs + 1]
	and %111
	cp b
	ret

.CheckBreedingGroupCompatibility
; If either mon is in the No Eggs group,
; they are not compatible.
	ld a, [wBreedMon2Species]
	ld [wCurSpecies], a
	call GetBaseData
	ld a, [BaseEggGroups]
	cp NO_EGGS * $11
	jr z, .Incompatible

	ld a, [wBreedMon1Species]
	ld [wCurSpecies], a
	call GetBaseData
	ld a, [BaseEggGroups]
	cp NO_EGGS * $11
	jr z, .Incompatible

; Ditto is automatically compatible with everything.
; If not Ditto, load the breeding groups into b/c and d/e.
	ld a, [wBreedMon2Species]
	cp DITTO
	jr z, .Compatible
	ld [wCurSpecies], a
	call GetBaseData
	ld a, [BaseEggGroups]
	push af
	and $f
	ld b, a
	pop af
	and $f0
	swap a
	ld c, a

	ld a, [wBreedMon1Species]
	cp DITTO
	jr z, .Compatible
	ld [wCurSpecies], a
	push bc
	call GetBaseData
	pop bc
	ld a, [BaseEggGroups]
	push af
	and $f
	ld d, a
	pop af
	and $f0
	swap a
	ld e, a

	ld a, d
	cp b
	jr z, .Compatible
	cp c
	jr z, .Compatible

	ld a, e
	cp b
	jr z, .Compatible
	cp c
	jr z, .Compatible

.Incompatible
	and a
	ret

.Compatible
	scf
	ret

DoEggStep::
	xor a
	ld [EngineBuffer1], a
	call GetFirstPartyMonAbility
	ld b, 1
	cp ABILITY_MAGMA_ARMOR
	jr z, .begin
	cp ABILITY_FLAME_BODY
	jr z, .begin
	dec b
.begin
	ld de, wPartySpecies
	ld hl, PartyMon1Happiness
	jr .handleLoop

.loop
	push de
	ld de, PARTYMON_STRUCT_LENGTH
	add hl, de
	pop de
.handleLoop
	ld a, [de]
	inc de
	cp -1
	jr z, .done
	cp EGG
	jr nz, .loop
	dec [hl]
	jr z, .hatch
	ld a, b
	and a
	jr z, .loop
	dec [hl]
	jr nz, .loop
.hatch
	ld a, 1
	ld [EngineBuffer1], a
	jr .loop

.done
	ld a, [EngineBuffer1]
	and a
	ret

OverworldHatchEgg::
	call RefreshScreen
	call LoadStandardMenuDataHeader
	call HatchEggs
	call ExitAllMenus
	call RestartMapMusic
	jp CloseText

HatchEggs:
	ld de, wPartySpecies
	ld hl, PartyMon1Happiness
	xor a
	ld [wCurPartyMon], a

.loop
	ld a, [de]
	inc de
	cp -1
	ret z
	push de
	push hl
	cp EGG
	jp nz, .next
	ld a, [hl]
	and a
	jp nz, .next
	ld [hl], $78

	push de

	callba SetEggMonCaughtData
	ld a, [wCurPartyMon]
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld a, [hl]
	ld [wCurPartySpecies], a
	dec a
	call SetSeenAndCaughtMon

.nottogepi

	pop de

	ld a, [wCurPartySpecies]
	dec de
	ld [de], a
	ld [wd265], a
	ld [wCurSpecies], a
	call GetPokemonName
	xor a
	ld [wd26b], a
	call GetBaseData
	ld a, [wCurPartyMon]
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	push hl
	ld bc, MON_MAXHP
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	push hl
	ld bc, MON_LEVEL
	add hl, bc
	ld a, [hl]
	ld [CurPartyLevel], a
	pop hl
	push hl
	ld bc, MON_STATUS
	add hl, bc
	xor a
	ld [hli], a
	ld [hl], a
	pop hl
	push hl
	ld bc, MON_STAT_EXP - 1
	add hl, bc
	ld b, $0
	predef CalcPkmnStats
	pop bc
	ld hl, MON_MAXHP
	add hl, bc
	ld d, h
	ld e, l
	ld hl, MON_HP
	add hl, bc
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hl], a
	ld hl, MON_ID
	add hl, bc
	ld a, [PlayerID]
	ld [hli], a
	ld a, [PlayerID + 1]
	ld [hl], a
	ld hl, MON_MOVES
	add hl, bc
	ld d, h
	ld e, l
	callba AddMovesObtained
	ld a, [wCurPartyMon]
	ld hl, wPartyMonOT
	ld bc, NAME_LENGTH
	rst AddNTimes
	ld d, h
	ld e, l
	ld hl, PlayerName
	rst CopyBytes
	ld hl, .Text_HatchEgg
	call PrintText
	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames
	ld bc, PKMN_NAME_LENGTH
	rst AddNTimes
	ld d, h
	ld e, l
	push de
	ld hl, .Text_NicknameHatchling
	call PrintText
	call YesNoBox
	pop de
	jr c, .nonickname

	ld a, $1
	ld [wd26b], a
	xor a
	ld [wMonType], a
	push de
	ld b, $0
	callba NamingScreen
	pop hl
	ld de, wStringBuffer1
	call InitName
	jr .next

.nonickname
	ld hl, wStringBuffer1
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes

.next
	ld hl, wCurPartyMon
	inc [hl]
	pop hl
	ld de, PARTYMON_STRUCT_LENGTH
	add hl, de
	pop de
	jp .loop

.Text_HatchEgg
	; Huh? @ @
	text_far UnknownText_0x1c0db0
	start_asm
	ld hl, VramState
	res 0, [hl]
	push hl
	push de
	push bc
	ld a, [wCurPartySpecies]
	push af
	call EggHatch_AnimationSequence
	ld hl, .ClearTextbox
	call PrintText
	pop af
	ld [wCurPartySpecies], a
	pop bc
	pop de
	pop hl
	ld hl, .CameOutOfItsEgg
	ret

.ClearTextbox
	text_jump UnknownText_0x1c0db8

.CameOutOfItsEgg
	; came out of its EGG!@ @
	text_far UnknownText_0x1c0dba
	start_asm
	ld de, SFX_CAUGHT_MON
	jp Text_PlaySFXAndPrompt

.Text_NicknameHatchling
	; Give a nickname to @ ?
	text_jump UnknownText_0x1c0dd8

InitEggMoves:
	call GetHeritableMoves
	ld d, h
	ld e, l
	ld b, NUM_MOVES
.loop
	ld a, [de]
	and a
	ret z
	ld hl, wEggMonMoves
	ld c, NUM_MOVES
.next
	ld a, [de]
	cp [hl]
	jr z, .skip
	inc hl
	dec c
	jr nz, .next
	call GetEggMove
	jr nc, .skip
	call LoadEggMove

.skip
	inc de
	dec b
	jr nz, .loop
	ret

GetEggMove:
GLOBAL EggMoves

	push bc
	ld a, [wEggMonSpecies]
	dec a
	ld c, a
	ld b, 0
	ld hl, EggMovePointers
	add hl, bc
	add hl, bc
	ld a, BANK(EggMovePointers)
	call GetFarHalfword
.loop
	ld a, BANK(EggMoves)
	call GetFarByteAndIncrement
	cp -1
	jr z, .reached_end
	ld b, a
	ld a, [de]
	cp b
	jr nz, .loop
	jr .done_carry

.reached_end
	call GetBreedmonMovePointer
	ld b, NUM_MOVES
.loop2
	ld a, [de]
	cp [hl]
	jr z, .found_eggmove
	inc hl
	dec b
	jr z, .inherit_tmhm
	jr .loop2

.found_eggmove
	ld a, [wEggMonSpecies]
	dec a
	ld c, a
	ld b, 0
	ld hl, EvosAttacksPointers
	add hl, bc
	add hl, bc
	ld a, BANK(EvosAttacksPointers)
	call GetFarHalfword
.loop3
	ld a, BANK(EvosAttacks)
	call GetFarByteAndIncrement
	and a
	jr nz, .loop3
.loop4
	ld a, BANK(EvosAttacks)
	call GetFarByteAndIncrement
	and a
	jr z, .inherit_tmhm
	ld a, BANK(EvosAttacks)
	call GetFarByteAndIncrement
	ld b, a
	ld a, [de]
	cp b
	jr nz, .loop4
	jr .done_carry

.inherit_tmhm
	ld hl, TMHMMoves
.loop5
	ld a, BANK(TMHMMoves)
	call GetFarByteAndIncrement
	and a
	jr z, .done
	ld b, a
	ld a, [de]
	cp b
	jr nz, .loop5
	ld [wPutativeTMHMMove], a
	predef CanLearnTMHMMove
	ld a, c
	and a
	jr z, .done

.done_carry
	pop bc
	scf
	ret

.done
	pop bc
	and a
	ret

LoadEggMove:
	push de
	push bc
	ld a, [de]
	ld b, a
	ld hl, wEggMonMoves
	ld c, NUM_MOVES
.loop
	ld a, [hli]
	and a
	jr z, .done
	dec c
	jr nz, .loop
	ld de, wEggMonMoves
	ld hl, wEggMonMoves + 1
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a

.done
	dec hl
	ld [hl], b
	ld hl, wEggMonMoves
	ld de, wEggMonPP
	predef FillPP
	pop bc
	pop de
	ret

GetHeritableMoves:
	ld hl, wBreedMon2Moves
	ld a, [wBreedMon1Species]
	cp DITTO
	jr z, .ditto1
	ld a, [wBreedMon2Species]
	cp DITTO
	jr z, .ditto2
	ld a, [wBreedMotherOrNonDitto]
	and a
	ret z
	ld hl, wBreedMon1Moves
	ret

.ditto1
	ld a, [wCurPartySpecies]
	push af
	ld a, [wBreedMon2Species]
	ld [wCurPartySpecies], a
	ld a, [wBreedMon2DVs]
	ld [TempMonDVs], a
	ld a, [wBreedMon2DVs + 1]
	ld [TempMonDVs + 1], a
	ld a, BREEDMON
	ld [wMonType], a
	predef GetGender
	jr c, .inherit_mon2_moves
	jr nz, .inherit_mon2_moves
	jr .inherit_mon1_moves

.ditto2
	ld a, [wCurPartySpecies]
	push af
	ld a, [wBreedMon1Species]
	ld [wCurPartySpecies], a
	ld a, [wBreedMon1DVs]
	ld [TempMonDVs], a
	ld a, [wBreedMon1DVs + 1]
	ld [TempMonDVs + 1], a
	ld a, BREEDMON
	ld [wMonType], a
	predef GetGender
	jr c, .inherit_mon1_moves
	jr nz, .inherit_mon1_moves

.inherit_mon2_moves
	ld hl, wBreedMon2Moves
	pop af
	ld [wCurPartySpecies], a
	ret

.inherit_mon1_moves
	ld hl, wBreedMon1Moves
	pop af
	ld [wCurPartySpecies], a
	ret

GetBreedmonMovePointer:
	ld hl, wBreedMon1Moves
	ld a, [wBreedMon1Species]
	cp DITTO
	ret z
	ld a, [wBreedMon2Species]
	cp DITTO
	jr z, .ditto
	ld a, [wBreedMotherOrNonDitto]
	and a
	ret z

.ditto
	ld hl, wBreedMon2Moves
	ret

GetEggFrontpic:
	push de
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	call GetBaseData
	pop de
	predef_jump GetFrontpic

GetHatchlingFrontpic:
	push de
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	call GetBaseData
	pop de
	predef_jump GetAnimatedFrontpic

Hatch_UpdateFrontpicBGMapCenter:
	push af
	call WaitTop
	push hl
	push bc
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, " "
	call ByteFill
	pop bc
	pop hl
	ld a, b
	ld [hBGMapAddress + 1], a
	ld a, c
	ld [hGraphicStartTile], a
	lb bc, 7, 7
	predef PlaceGraphic
	pop af
	call Hatch_LoadFrontpicPal
	call SetPalettes
	jp ApplyTilemapInVBlank

EggHatch_DoAnimFrame:
	push hl
	push de
	push bc
	callba PlaySpriteAnimations
	call DelayFrame
	pop bc
	pop de
	pop hl
	ret

EggHatch_AnimationSequence:
	ld a, [wd265]
	ld [wJumptableIndex], a
	ld a, [wCurSpecies]
	push af
	ld de, MUSIC_NONE
	call PlayMusic
	callba BlankScreen
	call DisableLCD
	ld hl, EggHatchGFX
	ld de, VTiles0 tile $00
	ld bc, $20
	ld a, BANK(EggHatchGFX)
	call FarCopyBytes
	callba ClearSpriteAnims
	ld de, VTiles2 tile $00
	ld a, [wJumptableIndex]
	call GetHatchlingFrontpic
	ld de, VTiles2 tile $31
	ld a, EGG
	call GetEggFrontpic
	ld de, MUSIC_EVOLUTION
	call PlayMusic
	call EnableLCD
	hlcoord 7, 4
	ld b, VBGMap0 / $100
	ld c, $31 ; Egg tiles start here
	ld a, EGG
	call Hatch_UpdateFrontpicBGMapCenter
	ld c, 80
	call DelayFrames
	xor a
	ld [wcf64], a
	ld a, [hSCX]
	ld b, a
.outerloop
	ld hl, wcf64
	ld a, [hl]
	inc [hl]
	cp 8
	jr nc, .done
	ld e, [hl]
.loop
; wobble e times
	ld a, 2
	ld [hSCX], a
	ld a, -2
	ld [wGlobalAnimXOffset], a
	call EggHatch_DoAnimFrame
	ld c, 2
	call DelayFrames
	ld a, -2
	ld [hSCX], a
	ld a, 2
	ld [wGlobalAnimXOffset], a
	call EggHatch_DoAnimFrame
	ld c, 2
	call DelayFrames
	dec e
	jr nz, .loop
	ld c, 16
	call DelayFrames
	call EggHatch_CrackShell
	jr .outerloop

.done
	ld de, SFX_EGG_HATCH
	call PlaySFX
	xor a
	ld [hSCX], a
	ld [wGlobalAnimXOffset], a
	call ClearSprites
	call Hatch_InitShellFragments
	hlcoord 6, 3
	ld b, VBGMap0 / $100
	ld c, $00 ; Hatchling tiles start here
	ld a, [wJumptableIndex]
	call Hatch_UpdateFrontpicBGMapCenter
	call Hatch_ShellFragmentLoop
	call WaitSFX
	ld a, [wJumptableIndex]
	ld [wCurPartySpecies], a
	hlcoord 6, 3
	ld d, $0
	ld e, ANIM_MON_HATCH
	predef AnimateFrontpic
	pop af
	ld [wCurSpecies], a
	ret

Hatch_LoadFrontpicPal:
	ld [PlayerHPPal], a
	lb bc, SCGB_0B, $0
	predef_jump GetSGBLayout

EggHatch_CrackShell:
	ld a, [wcf64]
	dec a
	and $7
	cp $7
	ret z
	srl a
	ret nc
	swap a
	srl a
	add 9 * 8 + 4
	ld d, a
	ld e, 11 * 8
	ld a, SPRITE_ANIM_INDEX_19
	call _InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], $0
	ld de, SFX_EGG_CRACK
	jp PlaySFX

EggHatchGFX: INCBIN "gfx/misc/egg_hatch.2bpp"

Hatch_InitShellFragments:
	callba ClearSpriteAnims
	ld hl, .SpriteData
.loop
	ld a, [hli]
	cp -1
	jr z, .done
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	push hl
	push bc

	ld a, SPRITE_ANIM_INDEX_1C
	call _InitSpriteAnimStruct

	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], $0

	pop de
	ld a, e
	ld hl, SPRITEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	add [hl]
	ld [hl], a

	ld hl, SPRITEANIMSTRUCT_0B
	add hl, bc
	ld [hl], d

	pop hl
	jr .loop
.done
	ld de, SFX_EGG_HATCH
	call PlaySFX
	jp EggHatch_DoAnimFrame

.SpriteData
; Probably OAM.
	dsprite 10, 4,  9, 0, $00, $3c
	dsprite 11, 4,  9, 0, $01, $04
	dsprite 10, 4, 10, 0, $00, $30
	dsprite 11, 4, 10, 0, $01, $10
	dsprite 10, 4, 11, 0, $02, $24
	dsprite 11, 4, 11, 0, $03, $1c
	dsprite 10, 0,  9, 4, $00, $36
	dsprite 12, 0,  9, 4, $01, $0a
	dsprite 10, 0, 10, 4, $02, $2a
	dsprite 12, 0, 10, 4, $03, $16
	db -1

Hatch_ShellFragmentLoop:
	ld c, 129
.loop
	call EggHatch_DoAnimFrame
	dec c
	jr nz, .loop
	ret

Special_DayCareMon1:
	ld hl, DayCareMon1Text
	call PrintText
	ld a, [wBreedMon1Species]
	call PlayCry
	ld a, [wDaycareLady]
	bit 0, a
	jr z, DayCareMonCursor
	call ButtonSound
	ld hl, wBreedMon2Nick
	call DayCareMonCompatibilityText
	jp PrintText

Special_DayCareMon2:
	ld hl, DayCareMon2Text
	call PrintText
	ld a, [wBreedMon2Species]
	call PlayCry
	ld a, [wDaycareMan]
	bit 0, a
	jr z, DayCareMonCursor
	call ButtonSound
	ld hl, wBreedMon1Nick
	call DayCareMonCompatibilityText
	jp PrintText

DayCareMonCursor:
	jp WaitPressAorB_BlinkCursor

DayCareMon2Text:
	; It's @ that was left with the DAY-CARE LADY.
	text_jump UnknownText_0x1c0df3

DayCareMon1Text:
	; It's @ that was left with the DAY-CARE MAN.
	text_jump UnknownText_0x1c0e24

DayCareMonCompatibilityText:
	push bc
	ld de, wStringBuffer1
	ld bc, NAME_LENGTH
	rst CopyBytes
	call CheckBreedmonCompatibility
	pop bc
	ld a, [wd265]
	ld hl, .AllAlone
	cp -1
	ret z
	ld hl, .Incompatible
	and a
	ret z
	ld hl, .HighCompatibility
	cp 230
	ret nc
	cp 70
	ld hl, .ModerateCompatibility
	ret nc
	ld hl, .SlightCompatibility
	ret

.AllAlone
	; It's brimming with energy.
	text_jump UnknownText_0x1c0e54

.Incompatible
	; It has no interest in @ .
	text_jump UnknownText_0x1c0e6f

.HighCompatibility
	; It appears to care for @ .
	text_jump UnknownText_0x1c0e8d

.ModerateCompatibility
	; It's friendly with @ .
	text_jump UnknownText_0x1c0eac

.SlightCompatibility
	; It shows interest in @ .
	text_jump UnknownText_0x1c0ec6
