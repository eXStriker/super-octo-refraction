EvolvePokemon:
	ld hl, EvolvableFlags
	xor a
	ld [hl], a
	ld a, [wCurPartyMon]
	ld c, a
	ld b, SET_FLAG
	predef FlagAction
EvolveAfterBattle:
	xor a
	ld [wMonTriedToEvolve], a
	dec a
	ld [wCurPartyMon], a
	push hl
	push bc
	push de
	ld hl, wPartyCount

	push hl

EvolveAfterBattle_MasterLoop:
.master_loop
	ld hl, wCurPartyMon
	inc [hl]

	pop hl

	inc hl
	ld a, [hl]
	cp $ff
	jp z, .ReturnToMap

	ld [wEvolutionPrevSpecies], a

	push hl
	ld a, [wCurPartyMon]
	ld c, a
	ld hl, EvolvableFlags
	ld b, CHECK_FLAG
	predef FlagAction
	ld a, c
	and a
	jr z, .master_loop

	ld a, [wEvolutionPrevSpecies]
	dec a
	ld b, 0
	ld c, a
	ld hl, EvosAttacksPointers
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a

	push hl
	xor a
	ld [wMonType], a
	predef CopyPkmnToTempMon
	pop hl

.loop
	ld a, [hli]
	and a
	jr z, EvolveAfterBattle_MasterLoop

	ld b, a

	cp EVOLVE_TRADE
	jp z, .trade

	ld a, [wLinkMode]
	and a
	jp nz, .dont_evolve_2

	ld a, b
	cp EVOLVE_ITEM
	jp z, .item
	cp EVOLVE_ITEM_MALE
	jp z, .item_m
	cp EVOLVE_ITEM_FEMALE
	jp z, .item_f

	ld a, [wForceEvolution]
	and a
	jp nz, .dont_evolve_2

	ld a, b
	cp EVOLVE_HOLD_NIGHT
	jr z, .held_night
	cp EVOLVE_LEVEL
	jp z, .level
	cp EVOLVE_HAPPINESS
	jr z, .happiness
	cp EVOLVE_SYLVEON ; lol
	jp z, .sylveon
	cp EVOLVE_MAPGROUP
	jp z, .mapgroup
	cp EVOLVE_MOVE
	jp z, .move

; EVOLVE_STAT
	ld a, [TempMonLevel]
	cp [hl]
	jp c, .dont_evolve_1

	call IsMonHoldingEverstone
	jp z, .dont_evolve_1

	push hl
	ld de, TempMonAttack
	ld hl, TempMonDefense
	ld c, 2
	call StringCmp
	ld a, ATK_EQ_DEF
	jr z, .got_tyrogue_evo
	ld a, ATK_LT_DEF
	jr c, .got_tyrogue_evo
	ld a, ATK_GT_DEF
.got_tyrogue_evo
	pop hl

	inc hl
	cp [hl]
	jp nz, .dont_evolve_2

	inc hl
	jp .proceed

.happiness
	ld a, [TempMonHappiness]
	cp 220
	jp c, .dont_evolve_2

	call IsMonHoldingEverstone
	jp z, .dont_evolve_2

	ld a, [hli]
	cp TR_ANYTIME
	jr z, .proceed2
	cp TR_MORNDAY
	jr z, .happiness_daylight

; TR_NITE
	ld a, [TimeOfDay]
	cp NITE
	jp nz, .dont_evolve_3
	jr .proceed2

.happiness_daylight
	ld a, [TimeOfDay]
	cp NITE
	jp z, .dont_evolve_3
	jr .proceed2

.held_night
	ld a, [TimeOfDay]
	cp NITE
	jp nz, .dont_evolve_2
	ld a, [hli]
	ld b, a
	jr .held_night_item_check

.trade
	ld a, [wLinkMode]
	and a
	jr nz, .trading
	ld a, [wCurItem]
	cp TRADE_STONE
	jp nz, .dont_evolve_2
.trading
	call IsMonHoldingEverstone
	jp z, .dont_evolve_2

	ld a, [hli]
	ld b, a
	inc a
	jr z, .proceed2

	ld a, [wLinkMode]
	cp LINK_TIMECAPSULE
	jp z, .dont_evolve_3

.held_night_item_check
	ld a, [TempMonItem]
	cp b
	jp nz, .dont_evolve_3

	xor a
	ld [TempMonItem], a
.proceed2
	jp .proceed

.sylveon
	push hl
	ld de, TempMonStatExp
	ld hl, 0
	ld a, 5
.statExpCountLoop
	ld [hLoopCounter], a
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	ld c, a
	inc de
	add hl, bc
	jr c, .enoughStatExp
	ld a, [hLoopCounter]
	dec a
	jr nz, .statExpCountLoop
.noFairyTypeMove
	pop hl
	jp .dont_evolve_3
.enoughStatExp
	ld de, TempMonMoves
	ld c, NUM_MOVES
.checkFairyTypeMoveLoop
	push bc
	ld a, [de]
	and a
	jr z, .noFairyTypeMove
	inc de
	dec a
	ld hl, Moves + MOVE_TYPE
	ld bc, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	and $3f
	cp FAIRY_T
	pop bc
	jr z, .hasFairyTypeMove
	dec c
	jr nz, .checkFairyTypeMoveLoop
	jr .noFairyTypeMove
.hasFairyTypeMove
	pop hl
	jr .proceed

.mapgroup
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
	ld d, 0
	jr .mapGroupHandleLoop
.mapGroupLoop
	cp b
	jr nz, .mapGroupFail
	ld a, c
	cp [hl]
	jr nz, .mapGroupFail
	ld d, 1
.mapGroupFail
	inc hl
.mapGroupHandleLoop
	ld a, [hli]
	cp -1
	jr nz, .mapGroupLoop
	ld a, d
	and a
	jp z, .dont_evolve_3
	jr .proceed

.move
	ld a, [hli]
	ld b, a
	ld de, TempMonMoves
	ld c, NUM_MOVES
.checkMoveLoop
	ld a, [de]
	and a
	jr z, .moveNotFound
	inc de
	cp b
	jr z, .proceed
	dec c
	jr nz, .checkMoveLoop
.moveNotFound
	jp .dont_evolve_3

.item_f
	ld a, $3
	ld [wMonType], a
	push hl
	predef GetGender
	pop hl
	jr z, .item
.notMale
	jp .dont_evolve_2
.item_m
	ld a, $3
	ld [wMonType], a
	push hl
	predef GetGender
	pop hl
	jr z, .notMale
.item
	ld a, [hli]
	ld b, a
	ld a, [wCurItem]
	cp b
	jp nz, .dont_evolve_3

	ld a, [wForceEvolution]
	and a
	jp z, .dont_evolve_3
	ld a, [wLinkMode]
	and a
	jp nz, .dont_evolve_3
	jr .proceed

.level
	ld a, [hli]
	ld b, a
	ld a, [TempMonLevel]
	cp b
	jp c, .dont_evolve_3
	call IsMonHoldingEverstone
	jp z, .dont_evolve_3

.proceed
	ld a, [TempMonLevel]
	ld [CurPartyLevel], a
	ld a, $1
	ld [wMonTriedToEvolve], a

	push hl

	ld a, [hl]
	ld [wEvolutionNewSpecies], a
	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames
	call GetNick
	call CopyName1
	ld hl, Text_WhatEvolving
	call PrintText

	ld c, 50
	call DelayFrames

	xor a
	ld [hBGMapMode], a
	hlcoord 0, 0
	lb bc, 12, 20
	call ClearBox

	ld a, $1
	ld [hBGMapMode], a
	call ClearSprites

	callba EvolutionAnimation

	push af
	call ClearSprites
	pop af
	jp c, CancelEvolution

	ld hl, Text_CongratulationsYourPokemon
	call PrintText

	pop hl

	ld a, [hl]
	ld [wCurSpecies], a
	ld [TempMonSpecies], a
	ld [wEvolutionNewSpecies], a
	ld [wd265], a
	call GetPokemonName

	push hl
	ld hl, Text_EvolvedIntoPKMN
	call PrintTextBoxText

	ld de, MUSIC_NONE
	call PlayMusic
	ld de, SFX_CAUGHT_MON
	call PlayWaitSFX

	ld c, 40
	call DelayFrames

	call ClearTileMap
	call UpdateSpeciesNameIfNotNicknamed
	call GetBaseData

	ld hl, TempMonExp + 2
	ld de, TempMonMaxHP
	ld b, $1
	predef CalcPkmnStats

	ld a, [wCurPartyMon]
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld e, l
	ld d, h
	ld bc, MON_MAXHP
	add hl, bc
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, TempMonMaxHP + 1
	ld a, [hld]
	sub c
	ld c, a
	ld a, [hl]
	sbc b
	ld b, a
	ld hl, TempMonHP + 1
	ld a, [hl]
	add c
	ld [hld], a
	ld a, [hl]
	adc b
	ld [hl], a

	ld hl, TempMonSpecies
	ld bc, PARTYMON_STRUCT_LENGTH
	rst CopyBytes

	ld a, [wCurSpecies]
	ld [wd265], a
	xor a
	ld [wMonType], a
	call LearnLevelMoves
	ld a, [wd265]
	dec a
	call SetSeenAndCaughtMon

	ld a, [wd265]

	pop de
	pop hl
	ld a, [TempMonSpecies]
	ld [hl], a
	push hl
	ld l, e
	ld h, d
	jp .master_loop

.dont_evolve_1
	inc hl
.dont_evolve_2
	inc hl
.dont_evolve_3
	inc hl
	jp .loop

.ReturnToMap
	pop de
	pop bc
	pop hl
	ld a, [wLinkMode]
	and a
	ret nz
	ld a, [wBattleMode]
	and a
	ret nz
	ld a, [wMonTriedToEvolve]
	and a
	jp nz, RestartMapMusic
	ret

UpdateSpeciesNameIfNotNicknamed:
	ld a, [wCurSpecies]
	push af
	ld a, [BaseDexNo]
	ld [wd265], a
	call GetPokemonName
	pop af
	ld [wCurSpecies], a
	ld hl, wStringBuffer1
	ld de, wStringBuffer2
.loop
	ld a, [de]
	inc de
	cp [hl]
	inc hl
	ret nz
	cp "@"
	jr nz, .loop

	ld a, [wCurPartyMon]
	ld bc, PKMN_NAME_LENGTH
	ld hl, wPartyMonNicknames
	rst AddNTimes
	push hl
	ld a, [wCurSpecies]
	ld [wd265], a
	call GetPokemonName
	ld hl, wStringBuffer1
	pop de
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	ret

CancelEvolution:
	ld hl, Text_StoppedEvolving
	call PrintText
	call ClearTileMap
	pop hl
	jp EvolveAfterBattle_MasterLoop

IsMonHoldingEverstone:
	push hl
	ld a, [wCurPartyMon]
	ld hl, PartyMon1Item
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld a, [hl]
	cp EVERSTONE
	pop hl
	ret

Text_CongratulationsYourPokemon:
	; Congratulations! Your @ @
	text_jump UnknownText_0x1c4b92

Text_EvolvedIntoPKMN:
	; evolved into @ !
	text_jump UnknownText_0x1c4baf

Text_StoppedEvolving:
	; Huh? @ stopped evolving!
	text_jump UnknownText_0x1c4bc5

Text_WhatEvolving:
	; What? @ is evolving!
	text_jump UnknownText_0x1c4be3

LearnLevelMoves:
	ld a, [wd265]
	ld [wCurPartySpecies], a
	dec a
	ld b, 0
	ld c, a
	ld hl, EvosAttacksPointers
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a

.skip_evos
	ld a, [hli]
	and a
	jr nz, .skip_evos

.find_move
	ld a, [hli]
	and a
	jr z, .done

	ld b, a
	ld a, [CurPartyLevel]
	cp b
	ld a, [hli]
	jr nz, .find_move

	push hl
	ld d, a
	ld hl, PartyMon1Moves
	ld a, [wCurPartyMon]
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes

	ld b, NUM_MOVES
.check_move
	ld a, [hli]
	cp d
	jr z, .has_move
	dec b
	jr nz, .check_move
	jr .learn
.has_move

	pop hl
	jr .find_move

.learn
	ld a, d
	ld [wPutativeTMHMMove], a
	ld [wd265], a
	call GetMoveName
	call CopyName1
	predef LearnMove
	pop hl
	jr .find_move

.done
	ld a, [wCurPartySpecies]
	ld [wd265], a
	ret

FillMoves:
; Fill in moves at de for wCurPartySpecies at CurPartyLevel

	push hl
	push de
	push bc
	ld hl, EvosAttacksPointers
	ld b, 0
	ld a, [wCurPartySpecies]
	dec a
	add a
	rl b
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
.GoToAttacks
	ld a, [hli]
	and a
	jr nz, .GoToAttacks
	jr .GetLevel

.NextMove
	pop de
.GetMove
	inc hl
.GetLevel
	ld a, [hli]
	and a
	jp z, .done
	ld b, a
	ld a, [CurPartyLevel]
	cp b
	jp c, .done
	ld a, [wFillMoves_IsPartyMon]
	and a
	jr z, .CheckMove
	ld a, [wd002]
	cp b
	jr nc, .GetMove

.CheckMove
	push de
	ld c, NUM_MOVES
.CheckRepeat
	ld a, [de]
	inc de
	cp [hl]
	jr z, .NextMove
	dec c
	jr nz, .CheckRepeat
	pop de
	push de
	ld c, NUM_MOVES
.CheckSlot
	ld a, [de]
	and a
	jr z, .LearnMove
	inc de
	dec c
	jr nz, .CheckSlot
	pop de
	push de
	push hl
	ld h, d
	ld l, e
	call ShiftMoves
	ld a, [wFillMoves_IsPartyMon]
	and a
	jr z, .ShiftedMove
	push de
	ld bc, PartyMon1PP - (PartyMon1Moves + NUM_MOVES - 1)
	add hl, bc
	ld d, h
	ld e, l
	call ShiftMoves
	pop de

.ShiftedMove
	pop hl

.LearnMove
	ld a, [hl]
	ld [de], a
	ld a, [wFillMoves_IsPartyMon]
	and a
	jr z, .NextMove
	push hl
	ld a, [hl]
	ld hl, MON_PP - MON_MOVES
	add hl, de
	push hl
	dec a
	ld hl, Moves + MOVE_PP
	ld bc, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	pop hl
	ld [hl], a
	pop hl
	jr .NextMove

.done
	pop bc
	pop de
	pop hl
	ret

ShiftMoves:
	ld c, NUM_MOVES - 1
.loop
	inc de
	ld a, [de]
	ld [hli], a
	dec c
	jr nz, .loop
	ret

GetPreEvolution:
; Find the first mon to evolve into wCurPartySpecies.

; Return carry and the new species in wCurPartySpecies
; if a pre-evolution is found.

	ld c, 0
.loop ; For each Pokemon...
	ld hl, EvosAttacksPointers
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
.loop2 ; For each evolution...
	ld a, [hli]
	and a
	jr z, .no_evolve ; If we jump, this Pokemon does not evolve into wCurPartySpecies.
	cp EVOLVE_STAT ; This evolution type has the extra parameter of stat comparison.
	jr nz, .not_tyrogue
	inc hl

.not_tyrogue
	inc hl
	ld a, [wCurPartySpecies]
	cp [hl]
	jr z, .found_preevo
	inc hl
	ld a, [hl]
	and a
	jr nz, .loop2

.no_evolve
	inc c
	ld a, c
	cp NUM_POKEMON
	jr c, .loop
	and a
	ret

.found_preevo
	inc c
	ld a, c
	ld [wCurPartySpecies], a
	scf
	ret
