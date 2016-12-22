MainArcadeScript::
	special SaveParty
	callasm CopyArcadeParty
	special HealParty
	callasm InitializeArcadeRun
.loop
	callasm IncrementArcadeRoundCounter
	opentext
	writetext .generating
	pause 20
	callasm RestorePartyPP
	callasm StartArcadeBattle
	reloadmap
	iftrue .loop
	scriptstartasm
	ld a, [wOptionsBackup]
	ld [wOptions], a
	scriptstopasm
	special RestoreParty
	end
.generating
	ctxt "Generating team"
	line "for round @"
	deciram wBattleArcadeCurrentRound, 2, 3
	ctxt "<...>"
	done

InitializeArcadeRun::
	ld hl, wOptions
	ld a, [hl]
	ld [wOptionsBackup], a
	or (1 << BATTLE_SCENE) | (1 << BATTLE_SHIFT) ; set, animations off
	ld [hl], a
	ld hl, wBattleArcadeRunData
	ld bc, wBattleArcadeRunDataEnd - wBattleArcadeRunData
	xor a
	jp ByteFill

IncrementArcadeRoundCounter::
	ld hl, wBattleArcadeCurrentRound
	ld a, [hli]
	ld c, [hl]
	ld b, a
	inc bc
	ld a, c
	ld [hld], a
	ld [hl], b
	ld a, b
	and a
	jr nz, .max_difficulty
	dec c
	ld a, c
	cp 40
	jr nc, .max_difficulty
	sla c
	sla c
	add a, c
	ld e, a
.resample
	call Random
	cp 250
	jr nc, .resample
	ld c, 10
	call SimpleDivide
	add a, e
	cp 200
	jr c, .value_selected
.max_difficulty
	ld a, 200
.value_selected
	ld [wBattleArcadeDifficulty], a
	ret

StartArcadeBattle::
	call InitializeArcadeBattle
	ld a, 1
	ld [hScriptVar], a
	predef StartBattle
	xor a
	ld [InBattleTowerBattle], a
	ld de, 0
	call PlayMusic
	call DelayFrame
	ld de, MUSIC_BATTLE_TOWER_LOBBY
	call PlayMusic
	ld a, [wBattleResult]
	and $f
	jp z, ScoreArcadeBattle
	jp ArcadeRunOver

GiveArcadeTickets::
	; gives cde tickets to the player, capped at 9,999,999
	ld hl, wBattleArcadeTickets + 2
	ld a, [hld]
	add a, e
	ld e, a
	ld a, [hld]
	adc d
	ld d, a
	ld a, [hl]
	adc c
	ld c, a
	; the max is 9,999,999, which is $98967f
	cp $98
	jr c, .validated_ticket_amount
	jr nz, .max_ticket_amount
	ld a, d
	cp $96
	jr c, .validated_ticket_amount
	jr nz, .max_ticket_amount
	ld a, e
	cp $7f
	jr c, .validated_ticket_amount
.max_ticket_amount
	ld c, $98
	ld de, $967f
.validated_ticket_amount
	ld hl, wBattleArcadeTickets
	ld a, c
	ld [hli], a
	ld a, d
	ld [hli], a
	ld [hl], e
	ret

TakeArcadeTickets::
	; takes away cde tickets from the player, leaves with 0 if not enough
	ld hl, wBattleArcadeTickets + 2
	ld a, [hl]
	sub e
	ld [hld], a
	ld a, [hl]
	sbc d
	ld [hld], a
	ld a, [hl]
	sbc c
	jr c, .underflow
	ld [hl], a
	ret
.underflow
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

CreateFullscreenTextbox:
	hlcoord 0, 0
	lb bc, 16, 18
	jp TextBox

WaitForButtonPress:
	call DelayFrame
	call GetJoypad
	ld a, [hJoyPressed]
	and a, A_BUTTON | B_BUTTON
	ret nz
	jr WaitForButtonPress

NextArcadeScreen:
	call WaitForButtonPress
	ld de, SFX_READ_TEXT
	call WaitPlaySFX
	jp WaitSFX

ScoreArcadeBattle:
	xor a
	ld [hBGMapMode], a
	ld hl, wBattleArcadeRoundScore
	ld a, 700 / $100
	ld [hli], a
	ld [hl], 700 % $100
	call CreateFullscreenTextbox
	hlcoord 2, 2
	ld de, .header
	call PlaceText
	ld hl, wBattleArcadeCurrentRound
	ld a, [hli]
	ld e, [hl]
	ld d, a
	ld bc, 0
	hlcoord 8, 2
	ld a, 3
	ld [hDigitsFlags], a
	predef PrintBigNumber
	hlcoord 1, 4
	ld de, .won_line
	call PlaceText
	hlcoord 1, 5
	ld de, .difficulty
	call PlaceText
	ld a, [wBattleArcadeDifficulty]
	ld e, a
	ld d, 0
	call .add_score
	ld bc, 0
	hlcoord 16, 5
	ld a, 3
	ld [hDigitsFlags], a
	predef PrintBigNumber
	ld de, .battle_time
	hlcoord 1, 7
	call PlaceText
	decoord 4, 8
	ld bc, STOPWATCH_BATTLE
	callba PrintStopwatchValue
	call CalculateArcadeTimeScore
	call .add_score
	ld a, d
	rla
	sbc a
	ld c, a
	ld b, a
	hlcoord 15, 7
	ld a, 4
	ld [hDigitsFlags], a
	predef PrintBigNumber
	ld de, .percentage_hp
	hlcoord 1, 10
	call PlaceText
	ld a, 3
	ld de, wPartyMonNicknames
	hlcoord 3, 11
.print_name_loop
	push af
	push hl
	push de
	call PlaceString
	pop de
	ld h, d
	ld l, e
	ld de, PKMN_NAME_LENGTH
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop af
	dec a
	jr nz, .print_name_loop
	xor a
.calculate_pokemon_score_loop
	push af
	call .calculate_pokemon_score
	pop af
	inc a
	cp 3
	jr c, .calculate_pokemon_score_loop
	ld de, .round_total
	hlcoord 1, 15
	call PlaceString
	ld hl, wBattleArcadeRoundScore
	ld a, [hli]
	ld e, [hl]
	ld d, a
	ld bc, 0
	hlcoord 15, 15
	ld a, 4
	ld [hDigitsFlags], a
	predef PrintBigNumber
	ld a, 1
	ld [hBGMapMode], a
	call NextArcadeScreen
	xor a
	ld [hBGMapMode], a
	call CreateFullscreenTextbox
	hlcoord 1, 6
	ld de, .round_score
	call PlaceText
	hlcoord 1, 7
	ld de, .multiplier
	call PlaceText
	hlcoord 1, 8
	ld de, .subtotal
	call PlaceText
	hlcoord 1, 11
	ld de, .total
	call PlaceString
	ld hl, wBattleArcadeRoundScore
	ld a, [hli]
	ld e, [hl]
	ld d, a
	push de
	ld bc, 0
	hlcoord 15, 6
	ld a, 4
	ld [hDigitsFlags], a
	predef PrintBigNumber
	ld hl, wBattleArcadeCurrentRound
	ld a, [hli]
	ld e, [hl]
	ld d, a
	push de
	call .count_digits
	xor 3
	ld c, a
	ld b, 0
	hlcoord 14, 7
	add hl, bc
	push hl
	ld bc, 0
	hlcoord 16, 7
	ld a, 3
	ld [hDigitsFlags], a
	predef PrintBigNumber
	pop hl
	ld [hl], $f1
	pop bc
	pop de
	call Multiply16
	push bc
	push de
	hlcoord 10, 8
	ld a, 9
	ld [hDigitsFlags], a
	predef PrintBigNumber
	pop de
	pop bc
	ld hl, wBattleArcadeRunningScore + 3
	ld a, [hl]
	add a, e
	ld e, a
	ld [hld], a
	ld a, [hl]
	adc d
	ld d, a
	ld [hld], a
	ld a, [hl]
	adc c
	ld c, a
	ld [hld], a
	ld a, [hl]
	adc b
	ld b, a
	ld [hl], a
	hlcoord 9, 11
	ld a, $8a
	ld [hDigitsFlags], a
	predef PrintBigNumber
	ld a, 1
	ld [hBGMapMode], a
	call NextArcadeScreen
	ld a, [wBattleArcadeCurrentRound]
	cp 999 / $100
	ret c
	ld a, [wBattleArcadeCurrentRound + 1]
	cp 999 % $100
	ret c
	xor a
	ld [hBGMapMode], a
	call CreateFullscreenTextbox
	hlcoord 1, 7
	ld de, .congratulations
	call PlaceText
	ld a, 1
	ld [hBGMapMode], a
	call NextArcadeScreen
	jp ArcadeRunOver

.count_digits
	ld a, d
	and a
	jr nz, .three_digits
	ld a, e
	cp 100
	jr nc, .three_digits
	cp 10
	sbc a
	add a, 2
	ret
.three_digits
	ld a, 3
	ret

.calculate_pokemon_score
	push af
	ld hl, PartyMon1HP
	call GetPartyLocation
	xor a
	ld [hMultiplicand], a
	ld a, [hli]
	ld [hMultiplicand + 1], a
	ld a, [hli]
	ld [hMultiplicand + 2], a
	ld a, 200
	ld [hMultiplier], a
	predef Multiply
	ld a, [hli]
	ld [hDivisor], a
	ld a, [hl]
	ld [hDivisor + 1], a
	predef DivideLong
	ld a, [hLongQuotient + 3]
	inc a ; proper rounding!
	srl a
	ld e, a
	ld d, 0
	hlcoord 16, 11
	ld bc, SCREEN_WIDTH
	pop af
	rst AddNTimes
	ld bc, 0
	ld a, 3
	ld [hDigitsFlags], a
	push de
	predef PrintBigNumber
	pop de
	; fallthrough

.add_score
	ld hl, wBattleArcadeRoundScore
	ld a, [hli]
	ld l, [hl]
	ld h, a
	add hl, de
	ld a, h
	ld c, l
	ld hl, wBattleArcadeRoundScore
	ld [hli], a
	ld [hl], c
	ret

.header
	ctxt "Round     score:"
	done
.won_line
	ctxt "Battle won     700"
	done
.difficulty
	ctxt "Difficulty"
	done
.battle_time
	ctxt "Battle time:"
	nl   "  [        ]"
	done
.percentage_hp
	ctxt "HP percentages:"
	done
.round_total
	db "ROUND "
.total
	db "TOTAL@"
.round_score
	ctxt "Round score"
	done
.multiplier
	ctxt "Multiplier"
	done
.subtotal
	ctxt "Subtotal"
	done
.congratulations
	ctxt " Congratulations!"
	nl   " You reached the"
	nl   "last round of the"
	nl   "  Battle Arcade!"
	done

CalculateArcadeTimeScore:
	lb bc, STOPWATCH_READ_FORMATTED | STOPWATCH_RESET, STOPWATCH_BATTLE
	callba ReadStopwatch
	ld a, b
	and a
	jr nz, .min_score
	ld a, c
	cp 1
	jr c, .max_score
	jr z, .between_1_and_2
	cp 2
	jr z, .between_2_and_3
	cp 5
	jr c, .between_3_and_5
	cp 15
	jr c, .between_5_and_15
	jr .between_15_and_60
.min_score
	ld de, -100
	ret
.max_score
	ld de, 200
	ret
.between_1_and_2
	sla d
	ld a, e
	cp 50
	ccf
	ld a, 200
	sbc d
	ld e, a
	ld d, 0
	ret
.between_2_and_3
	sla d
	ld a, e
	cp 50
	ccf
	ld a, 0
	adc d
	ld c, 3
	call SimpleDivide
	ld a, 80
	sub b
	ld e, a
	ld d, 0
	ret
.between_3_and_5
	ld a, c
	cp 4
	ccf
	sbc a
	and 60
	add a, d
	ld c, 3
	call SimpleDivide
	ld a, 40
	sub b
	ld e, a
	ld d, 0
	ret
.between_5_and_15
	ld a, 5
	sub c
	ld e, a
	sbc a
	ld d, a
	ret
.between_15_and_60
	sla c
	ld a, d
	cp 30
	ccf
	ld a, 0
	adc c
	cpl
	add a, 21
	ld e, a
	ld d, $ff
	ret

ArcadeRunOver:
	xor a
	ld [hBGMapMode], a
	call CreateFullscreenTextbox
	hlcoord 4, 4
	ld de, .header
	call PlaceText
	hlcoord 1, 6
	ld de, .score
	call PlaceText
	hlcoord 1, 7
	ld de, .rounds
	call PlaceText
	hlcoord 1, 9
	ld de, .tickets
	call PlaceText
	ld hl, wBattleArcadeRunningScore
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	push bc
	push de
	hlcoord 9, 6
	ld a, $8a
	ld [hDigitsFlags], a
	predef PrintBigNumber
	pop de
	pop bc
	ld hl, wBattleArcadeMaxScore
	call CompareBCDEtoHL
	call nc, .update_high_score
	push bc
	push de
	ld hl, wBattleArcadeCurrentRound
	ld a, [hli]
	ld e, [hl]
	ld d, a
	ld a, [wBattleResult]
	and $f
	jr z, .last_battle_won
	dec de
.last_battle_won
	ld hl, wBattleArcadeMaxRound
	call CompareDEtoHL
	call nc, .update_max_round
	ld bc, 0
	hlcoord 16, 7
	ld a, 3
	ld [hDigitsFlags], a
	predef PrintBigNumber
	pop de
	pop bc
	call .calculate_tickets
	ld b, 0
	push bc
	push de
	hlcoord 14, 9
	ld a, 5
	ld [hDigitsFlags], a
	predef PrintBigNumber
	pop de
	pop bc
	call GiveArcadeTickets
	xor a
	ld [hScriptVar], a
	inc a
	ld [hBGMapMode], a
	jp NextArcadeScreen
.header
	ctxt "Final result"
	done
.score
	ctxt "Score"
	done
.rounds
	ctxt "Rounds won"
	done
.tickets
	ctxt "Tickets won"
	done
.update_high_score
	ld hl, wBattleArcadeMaxScore
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, d
	ld [hli], a
	ld [hl], e
	ret
.update_max_round
	ld hl, wBattleArcadeMaxRound
	ld a, d
	ld [hli], a
	ld [hl], e
	ret
.calculate_tickets
	ld hl, hDividend
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, 300 / $100
	ld [hli], a
	ld [hl], 300 % $100
	predef DivideLong
	ld hl, hLongQuotient
	ld a, [hli]
	and a
	jr nz, .max_tickets
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	; the max, 99999, is $1869f
	ld a, c
	cp 1
	ret c
	jr nz, .max_tickets
	ld a, d
	cp $86
	ret c
	jr nz, .max_tickets
	ld a, e
	cp $9f
	ret c
.max_tickets
	ld c, 99999 / $10000
	ld de, 99999 % $10000
	ret

InitializeArcadeBattle:
	ld a, [wBattleArcadeDifficulty]
	add a, 50
	ld e, a
	call GenerateArcadeParty
	ld a, BATTLETYPE_CANLOSE
	ld [wBattleType], a
	ld a, 6
	ld [InBattleTowerBattle], a
	; jp LoadArcadeTrainerData : fallthrough

LoadArcadeTrainerData:
	ld a, ARCADEPC_GROUP
	ld [OtherTrainerClass], a
	ld a, ARCADEPC_TRAINER
	ld [OtherTrainerID], a
	ld a, BANK(.won_text)
	ld hl, wWinTextBank
	ld [hli], a
	ld [hl], a
	ld hl, wWinTextPointer
	ld a, .won_text % $100
	ld [hli], a
	ld a, .won_text / $100
	ld [hli], a
	ld a, .lost_text % $100
	ld [hli], a
	ld [hl], .lost_text / $100
	ret
.won_text
	ctxt "Round @"
	deciram wBattleArcadeCurrentRound, 2, 3
	ctxt " won!"
	done
.lost_text
	ctxt "Round @"
	deciram wBattleArcadeCurrentRound, 2, 3
	ctxt " lost."
	done

GenerateArcadeParty:
	; in: e: percentage adjustment
	; out: OT party, nickname and OT name structures filled
	; This function attempts to generate a random opponent party of e% the strength of the player's party, between levels 40 and 100.
	; This is based on the fact that relative power grows as the level to the power of 3.81, smoothing out the curve by scaling DVs/stat exp as well.
	call GenerateArcadePartyScaledData
	ld a, 3
	ld de, OTPartyMonNicknames
	ld hl, OTPartyMon1
.generation_loop
	push af
	push de
	push hl
	call SelectArcadeSet
	pop hl
	pop de
	push de
	push hl
	call FillArcadePokemonData
	pop hl
	pop de
	ld bc, OTPartyMon2 - OTPartyMon1
	add hl, bc
	ld a, e
	add a, PKMN_NAME_LENGTH
	ld e, a
	sbc a
	and 1
	add a, d
	ld d, a
	pop af
	dec a
	jr nz, .generation_loop
	ld a, "@"
	ld hl, wOTPartyMonOT
	ld bc, NAME_LENGTH * 3
	call ByteFill ;ByteFill exits with hl pointing to the end of the filled area
	ld bc, NAME_LENGTH * 3
	xor a
	call ByteFill
	xor a
	ld bc, PKMN_NAME_LENGTH * 3
	ld hl, OTPartyMonNicknames + PKMN_NAME_LENGTH * 3
	call ByteFill
	ld hl, OTPartyMon4
	ld bc, OTPartyMonsEnd - OTPartyMon4
	xor a
	call ByteFill
	ld hl, OTPartyCount
	ld a, 3
	ld [hli], a
	ld a, [OTPartyMon1Species]
	ld [hli], a
	ld a, [OTPartyMon2Species]
	ld [hli], a
	ld a, [OTPartyMon3Species]
	ld [hli], a
	ld a, $ff
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ret

GenerateArcadePartyScaledData:
	; in: e: percentage adjustment
	; out: OTPartyMon1 through 3 with levels, DVs and stat exp filled in
	; this function generates all of the battle arcade party data that is scaled by level
	push de
	ld hl, PartyMon1Level
	ld de, wPartyMon2 - wPartyMon1
	ld b, [hl]
	add hl, de
	ld c, [hl]
	add hl, de
	pop de
	ld d, [hl]
	call GenerateArcadeLevels
	jp GenerateArcadeStatExpAndDVs

GenerateArcadeLevels:
	; in: b, c, d: party levels, e: percentage adjustment
	; out: b, c, d: generated levels, e: normalized score remainder
	; this function intends to approximate a random level spread that is e% as strong as the input spread
	; since the relative power of a mon grows as the 3.81th power of the level, scoring computations are basically the total of level^3.81 for the whole party
	; the "normalized score remainder" is a number out of 256 approximately indicating how much of the score wasn't used (since levels must be integers)
	; a score of $77446cf represents a party fully level 100; a score of $3a245a represents a party fully level 40
	call CalculateLevelScoring
	ld a, b
	and a
	jr nz, .no_underflow
	ld a, c
	cp $3a
	jr c, .underflow
	jr nz, .no_underflow
	ld a, d
	cp $24
	jr c, .underflow
	jr nz, .no_underflow
	ld a, e
	cp $5b
	jr c, .underflow
.no_underflow
	ld a, b
	cp 7
	jr c, .valid_target_score
	jr nz, .overflow
	ld a, c
	cp $74
	jr c, .valid_target_score
	jr nz, .overflow
	ld a, d
	cp $46
	jr c, .valid_target_score
	jr nz, .overflow
	ld a, e
	cp $cf
	jr c, .valid_target_score
.overflow
	rept 4
		sla c
		rl b
	endr
	ld a, -$77
	add a, b
	ld e, a
	lb bc, 100, 100
	ld d, 100
	ret
.underflow
	lb bc, 40, 40
	lb de, 40, 0
	ret

.valid_target_score
	; since the OTPartyMons structure is clearly not in use here (as we're generating a party), it can be used as a buffer
	; bytes 0-3: target score, 4-6: current levels, 7: over / under target
	ld hl, OTPartyMon4
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	lb bc, 50, 60
	lb de, 55, 100
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld [hl], d
	call CalculateLevelScoring
	ld hl, OTPartyMon4
	call CompareBCDEtoHL
	jr z, .exact_score
	sbc a
	ld [OTPartyMon4 + 7], a

.level_selection_loop
	call Random
	cp $ff
	jr z, .level_selection_loop
.try_next_bits
	bit 0, a
	jr z, .selected_target
	bit 1, a
	jr z, .selected_target
	srl a
	srl a
	jr .try_next_bits
.selected_target
	and 3
	jr nz, .initial_not_zero
	ld a, 4
.initial_not_zero
	ld c, a
	rlca
	rlca
	rlca
	add a, c
	or $c0
	ld hl, OTPartyMon4 + 7
	inc [hl]
	dec [hl]
	jr z, .over
	jr .under

.reached_exact_score
	pop af
.exact_score
	ld e, 0
	ld hl, OTPartyMon4 + 4
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld d, [hl]
	ret

.over
	push af
	and 3
	cp 3
	jr z, .done_over
	ld e, a
	ld d, 0
	ld hl, OTPartyMon4 + 4
	add hl, de
	ld a, [hl]
	cp 41
	jr c, .cant_lower
	dec [hl]
	push hl
	call .calculate_current_score
	ld hl, OTPartyMon4
	call CompareBCDEtoHL
	pop hl
	jr z, .reached_exact_score
	jr c, .undo_lowering
	pop af
	jp .level_selection_loop
.undo_lowering
	inc [hl]
.cant_lower
	pop af
	rrca
	rrca
	jr .over

.under
	push af
	and 3
	cp 3
	jr z, .done_under
	ld e, a
	ld d, 0
	ld hl, OTPartyMon4 + 4
	add hl, de
	ld a, [hl]
	cp 100
	jr nc, .cant_raise
	inc [hl]
	push hl
	call .calculate_current_score
	ld hl, OTPartyMon4
	call CompareBCDEtoHL
	pop hl
	jr z, .reached_exact_score
	jr nc, .undo_raising
	pop af
	jp .level_selection_loop
.undo_raising
	dec [hl]
.cant_raise
	pop af
	rrca
	rrca
	jr .under

.done_over
	call .find_smallest
	ld a, [hl]
	cp 41
	jp c, .underflow
	dec [hl]
.done_under
	pop af
	call .find_smallest_index
	ld d, 0
	ld hl, OTPartyMon4 + 4
	add hl, de
	push hl
	call .calculate_current_score
	ld hl, OTPartyMon4 + 8
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, d
	ld [hli], a
	ld [hl], e
	ld hl, OTPartyMon4 + 3
	ld a, [hl]
	sub e
	ld [hld], a
	ld a, [hl]
	sbc d
	ld [hld], a
	ld a, [hl]
	sbc c
	ld [hl], a
	pop hl
	inc [hl]
	push hl
	call .calculate_current_score
	pop hl
	dec [hl]
	ld hl, OTPartyMon4 + 11
	ld a, e
	sub [hl]
	ld e, a
	dec hl
	ld a, d
	sbc [hl]
	ld d, a
	dec hl
	ld a, c
	sbc [hl]
	ld c, a
	bit 7, e
	ld e, d
	ld d, c
	jr z, .no_divisor_increment
	inc de
.no_divisor_increment
	ld hl, hDividend
	ld bc, OTPartyMon4 + 1
	xor a
	ld [hli], a
	ld a, [bc]
	inc bc
	ld [hli], a
	ld a, [bc]
	inc bc
	ld [hli], a
	ld a, [bc]
	ld [hli], a
	ld a, d
	ld [hli], a
	ld [hl], e
	predef DivideLong
	ld a, [hLongQuotient + 2]
	and a
	jr nz, .remainder_overflow
	ld a, [hLongQuotient + 3]
	ld e, a
	jr .remainder_calculated
.remainder_overflow
	ld e, $ff

.remainder_calculated
	ld hl, OTPartyMon4 + 4
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld d, [hl]
	ret

.find_smallest
	ld hl, OTPartyMon4 + 4
	lb de, 40, $ff
	call .replace_levels
	push hl
	call .find_smallest_index
	pop hl
	push de
	lb de, $ff, 40
	call .replace_levels
	pop de
	ld d, 0
	add hl, de
	ret

.find_smallest_index
	ld a, [hli]
	ld e, 0
	cp [hl]
	jr c, .first_less_than_second
	inc e
	ld a, [hl]
.first_less_than_second
	inc hl
	cp [hl]
	ret c
	ld e, 2
	ret

.replace_levels
	push hl
	ld c, 3
.loop
	ld a, [hl]
	cp d
	jr nz, .no_replacement
	ld [hl], e
.no_replacement
	inc hl
	dec c
	jr nz, .loop
	pop hl
	ret

.calculate_current_score
	ld hl, OTPartyMon4 + 4
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld d, [hl]
	ld e, 100
	jp CalculateLevelScoring

CompareBCDEtoHL:
	; compares bcde to 32-bit [hl]
	ld a, b
	sub [hl]
	ret nz
	inc hl
	ld a, c
	sub [hl]
	ret nz
	inc hl
	; fallthrough

CompareDEtoHL:
	; compares de to 16-bit [hl]
	ld a, d
	sub [hl]
	ret nz
	inc hl
	ld a, e
	sub [hl]
	ret

CalculateLevelScoring:
	; b, c, d: levels; e: percentage adjustment
	; out: score in bcde
	xor a
	ld hl, hProduct
	rept 4
		ld [hli], a
	endr
	push de
	push bc
	ld a, b
	call .add_level_score
	pop bc
	ld a, c
	call .add_level_score
	pop de
	ld a, d
	call .add_level_score
	ld hl, hProduct
	ld d, [hl]
	xor a
	rept 3
		ld [hli], a
		ld a, d
		ld d, [hl]
	endr
	ld [hli], a
	ld [hl], e
	predef Multiply
	ld a, d
	ld c, e
	ld b, 0
	ld hl, 0
	rst AddNTimes ; simply because it preserves hProduct
	xor a
	sla l
	adc h
	ld hl, hProduct + 3
	add [hl]
	dec hl
	ld e, a
	ld a, [hld]
	adc 0
	ld d, a
	ld a, [hld]
	adc 0
	ld c, a
	ld a, [hld]
	adc 0
	ld b, a
	ret
.add_level_score
	sub 40
	rlca
	rlca
	ld c, a
	ld b, 0
	ld hl, LevelConversionTable + 3
	add hl, bc ; this leaves carry cleared
	ld c, (hProduct + 3) % $100
	rept 3
		ld a, [$ff00+c]
		adc [hl]
		dec hl
		ld [$ff00+c], a
		dec c
	endr
	ld a, [$ff00+c]
	adc [hl]
	ld [$ff00+c], a
	ret

LevelConversionTable:
	; since relative power grows as level^3.81, precalculate that value for each level because it's impossible to calculate in runtime
	; the table actually lists (level ^ 3.81) << 8 / 100, for easier calculation of percentages; the lower-order byte is ultimately a fractional part
	; the table begins at level 40 since that is the minimum level allowed in the Battle Arcade
	dd   3251536
	dd   3572288
	dd   3915793
	dd   4283066
	dd   4675140
	dd   5093070
	dd   5537928
	dd   6010807
	dd   6512820
	dd   7045098
	dd   7608791
	dd   8205071
	dd   8835125
	dd   9500162
	dd  10201410
	dd  10940113
	dd  11717537
	dd  12534966
	dd  13393702
	dd  14295065
	dd  15240395
	dd  16231051
	dd  17268408
	dd  18353862
	dd  19488825
	dd  20674730
	dd  21913026
	dd  23205181
	dd  24552681
	dd  25957030
	dd  27419750
	dd  28942382
	dd  30526483
	dd  32173630
	dd  33885416
	dd  35663452
	dd  37509368
	dd  39424812
	dd  41411447
	dd  43470955
	dd  45605037
	dd  47815410
	dd  50103809
	dd  52471985
	dd  54921709
	dd  57454768
	dd  60072965
	dd  62778122
	dd  65572078
	dd  68456689
	dd  71433828
	dd  74505386
	dd  77673270
	dd  80939403
	dd  84305729
	dd  87774204
	dd  91346805
	dd  95025524
	dd  98812369
	dd 102709368
	dd 106718562

GenerateArcadeStatExpAndDVs:
	; in: b, c, d: levels, e: normalized score remainder (as given by GenerateArcadeLevels)
	; out: stat exp, DVs and level filled in OTPartyMon1 through OTPartyMon3 (all registers overwritten)
	; this function generates stat experience for the battle arcade party based on the levels and the normalized score remainder
	; using the normalized score remainder attempts to generate a smooth difficulty curve based on the original percentage adjustment
	push bc
	push de
	ld a, e
	ld c, 7
	call SimpleDivide
	cp 3
	jr c, .not_three_or_four
	cp 5
	jr nc, .not_three_or_four
	xor 7
.not_three_or_four
	ld hl, OTPartyMon4
	ld c, a
	rept 3
		xor a
		srl c
		rla
		add a, b
		ld [hli], a
	endr
	ld a, 1
	ld [hli], a
	ld [hli], a
	ld [hl], a
	pop de
	pop bc
	ld a, b
	ld e, 0
	cp c
	jr c, .first_less_than_second
	inc e
	ld a, c
.first_less_than_second
	cp d
	jr c, .third_not_minimum
	ld e, 2
.third_not_minimum
	ld hl, OTPartyMon4 + 3
	push de
	ld d, 0
	add hl, de
	pop de
	ld [hl], 0
	ld a, b
	ld e, 0
	cp c
	jr nc, .first_greater_than_second
	inc e
	ld a, c
.first_greater_than_second
	cp d
	jr nc, .third_not_maximum
	ld e, 2
.third_not_maximum
	ld hl, OTPartyMon4 + 3
	push de
	ld d, 0
	add hl, de
	ld [hl], 2
	ld de, OTPartyMon2 - OTPartyMon1
	ld hl, OTPartyMon1Level
	ld [hl], b
	add hl, de
	ld [hl], c
	pop bc
	add hl, de
	ld [hl], b
	ld c, 0
	ld hl, OTPartyMon1
.generate_next
	push hl
	call .generate_stats
	pop hl
	ld de, OTPartyMon2 - OTPartyMon1
	add hl, de
	inc c
	ld a, c
	cp 3
	jr c, .generate_next
	ret

.generate_stats
	ld de, OTPartyMon1Level - OTPartyMon1
	add hl, de
	push hl
	ld a, [hl]
	ld de, OTPartyMon1DVs - OTPartyMon1Level
	add hl, de
	cp 70
	ccf
	sbc a
	and $cc
	ld [hli], a
	ld [hl], a
	ld hl, OTPartyMon4 + 3
	ld e, c
	ld d, 0
	add hl, de
	ld e, [hl]
	ld d, 0
	ld hl, OTPartyMon4
	add hl, de
	ld a, [hl]
	push bc
	ld c, 6
	call SimpleDivide
	pop de
	ld c, e
	pop hl
	ld d, a
	ld a, [hl]
	sub 40
	cp 30
	jr c, .level_below_70
	sub 24
.level_below_70
	add a, b
	add a, 20
	ld e, a
	push bc
	ld bc, OTPartyMon1StatExp - OTPartyMon1Level
	add hl, bc
	pop bc
	ld b, 5
.stat_generation_loop
	ld a, b
	cp d
	jr c, .increment_stat
	cp 5
	jr nz, .dont_increment_stat
	ld a, d
	dec a
	jr nz, .dont_increment_stat
.increment_stat
	ld a, 1
	jr .stat_increment_loaded
.dont_increment_stat
	xor a
.stat_increment_loaded
	add a, e
	rlca
	rlca
	push bc
	push hl
	ld hl, 0
	ld c, a
	ld b, 0
	rst AddNTimes
	ld a, h
	ld c, l
	pop hl
	ld [hli], a
	ld a, c
	ld [hli], a
	pop bc
	dec b
	jr nz, .stat_generation_loop
	ret

SelectArcadeSet:
	; in: hl: pointer to the OTPartyMon structure where the set will be loaded (pre-loaded with scaled data)
	; out: loaded set in structure
.resample
	; this label isn't strictly necessary, but it makes the code cleaner
	call Random
	ld b, a
	call Random
	ld c, a
	ld de, $10000 / ARCADE_MAX_ENTRY_RANDOM
	call Divide16
	ld a, d
	cp ARCADE_MAX_ENTRY_RANDOM >> 8
	jr c, .random_ok
	jr nz, .resample
	ld a, e
	cp ARCADE_MAX_ENTRY_RANDOM & $ff
	jr nc, .resample
.random_ok
	push hl
	ld bc, 8 ;size of a single set
	ld hl, BattleArcadeSets - 8
.selection_loop
	add hl, bc
	ld a, d
	and a
	jr nz, .next_set
	ld a, e
	cp [hl]
	jr c, .selected
.next_set
	ld a, e ;redo the subtraction in case we got here by jumping
	sub [hl]
	ld e, a
	jr nc, .selection_loop
	dec d
	jr .selection_loop
.selected
	ld d, h
	ld e, l
	inc de
	push de
	ld a, [de]
	ld hl, .legendaries
	call IsInSingularArray
	jr nc, .selection_ok
	pop de
	push de
	ld a, [de]
	dec a
	ld hl, PokedexSeen
	ld b, CHECK_FLAG
	ld c, a
	predef FlagAction
	jr nz, .selection_ok
	pop de
	pop hl
	jr .resample
.selection_ok
	pop de
	pop hl
	rept 2
		ld a, [de]
		inc de
		ld [hli], a
	endr
	ld a, [de]
	inc de
	ld c, a
	rept 4
		ld a, [de]
		inc de
		ld [hli], a
	endr
	ld de, OTPartyMon1DVs - (OTPartyMon1Moves + 4)
	add hl, de
	rept 2
		ld a, [hl]
		ld b, 0
		srl c
		rr b
		srl c
		rl b
		rl b
		swap b
		or b
		ld b, 0
		srl c
		rr b
		srl c
		rl b
		rl b
		or b
		ld [hli], a
	endr
	ret
.legendaries
	db PHANCERO
	db ARTICUNO
	db ZAPDOS
	db MOLTRES
	db MEWTWO
	db MEW
	db FAMBACO
	db GROUDON
	db KYOGRE
	db RAYQUAZA
	db LUGIA
	db HO_OH
	db VARANEOUS
	db RAIWATO
	db LIBABEEL
	db -1

FillArcadePokemonData:
	; in: de: pointer to name, hl: pointer to OTPartyMon struct
	; out: loaded data
	; fills in the data that wasn't filled in by the previous functions
	ld a, [hl]
	ld [wCurSpecies], a
	call GetBaseData
	push de
	push hl
	ld bc, OTPartyMon1MaxHP - OTPartyMon1
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	push hl
	ld bc, OTPartyMon1Level - OTPartyMon1
	add hl, bc
	ld a, [hl]
	ld [CurPartyLevel], a
	ld bc, (OTPartyMon1StatExp - 1) - OTPartyMon1Level
	add hl, bc
	ld b, 1
	predef CalcPkmnStats
	pop hl
	push hl
	ld bc, OTPartyMon1PP - OTPartyMon1
	add hl, bc
	ld d, h
	ld e, l
	ld bc, OTPartyMon1Moves - OTPartyMon1PP
	add hl, bc
	predef FillPP
	pop hl
	push hl
	ld bc, OTPartyMon1Level - OTPartyMon1
	add hl, bc
	ld d, [hl]
	callba CalcExpAtLevel
	pop hl
	push hl
	ld bc, OTPartyMon1ID - OTPartyMon1
	add hl, bc
	xor a
	ld [hli], a
	ld [hli], a
	ld bc, hProduct + 1
	rept 2
		ld a, [bc]
		inc bc
		ld [hli], a
	endr
	ld a, [bc]
	ld [hl], a
	pop hl
	push hl
	ld bc, OTPartyMon1Happiness - OTPartyMon1
	add hl, bc
	ld a, $ff
	ld [hli], a
	xor a
	rept 3
		ld [hli], a
	endr
	inc hl
	ld [hli], a
	ld [hli], a
	ld d, h
	ld e, l
	inc hl
	inc hl
	ld a, [hli]
	ld c, [hl]
	ld [de], a
	inc de
	ld a, c
	ld [de], a
	pop hl
	ld a, [hl]
	ld [wd265], a
	call GetPokemonName
	ld hl, wStringBuffer1
	ld bc, PKMN_NAME_LENGTH
	pop de
	rst CopyBytes
	ret

CopyArcadeParty:
	lb bc, 0, 3
	ld hl, wSelectedParty
.loop
	ld a, [hli]
	push hl
	push bc
	call .copy_mon
	pop bc
	pop hl
	inc b
	dec c
	jr nz, .loop
	ld hl, wPartyMon1
	ld bc, wPartyMon2 - wPartyMon1
	ld de, wPartyCount
	ld a, 3
	ld [de], a
	inc de
	rept 2
		ld a, [hl]
		add hl, bc
		ld [de], a
		inc de
	endr
	ld a, [hl]
	ld [de], a
	inc de
	ld a, -1
	ld [de], a
	ret
.copy_mon
	; copy saved mon a into party mon b
	ld c, a
	ld hl, wPartyBackup + (wPartyMon1 - wPokemonData)
	ld de, wPartyMon1
	ld a, wPartyMon2 - wPartyMon1
	push bc
	call .copy_mon_data
	pop bc
	ld hl, wPartyBackup + (wPartyMonOT - wPokemonData)
	ld de, wPartyMonOT
	ld a, NAME_LENGTH
	push bc
	call .copy_mon_data
	pop bc
	ld hl, wPartyBackup + (wPartyMonNicknames - wPokemonData)
	ld de, wPartyMonNicknames
	ld a, PKMN_NAME_LENGTH
	; fallthrough
.copy_mon_data
	push bc
	push af
	push hl
	ld h, d
	ld l, e
	ld c, b
	ld b, 0
	rst AddNTimes
	ld d, h
	ld e, l
	pop hl
	pop af
	pop bc
	ld b, 0
	push af
	rst AddNTimes
	pop af
	ld c, a
	ld b, 0
	ln a, BANK(wPokemonData), BANK(wPartyBackup)
	jp DoubleFarCopyWRAM

RestorePartyPP::
	ld hl, wCurPartyMon
	ld [hl], 2
.loop
	push hl
	callba RestoreAllPP
	pop hl
	xor a
	or [hl]
	ret z
	dec [hl]
	jr .loop
