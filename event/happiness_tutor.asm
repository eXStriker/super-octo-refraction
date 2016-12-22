Special_GoldenrodHappinessMoveTutor:
	ld hl, .IntroText
	call PrintText
	call YesNoBox
	jp c, .cancel
	ld hl, .WhichOneText
	call PrintText

	ld b, $6
	callba SelectMonFromParty
	jr c, .cancel

	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .egg

	call IsAPokemon
	jr c, .no_mon

	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames
	call SkipNames
	ld de, wStringBuffer3
	rst CopyBytes

	ld a, MON_HAPPINESS
	call GetPartyParamLocation
	ld a, [hl]
	cp 200
	jr c, .not_happy_enough

	ld a, [wCurPartySpecies]
	dec a
	ld c, a
	ld b, 0
	ld hl, HappinessMoves
	add hl, bc
	ld a, [hl]
	ld [wPutativeTMHMMove], a
	ld d, a

	ld a, MON_MOVES
	call GetPartyParamLocation
	ld b, 4
.loop
	ld a, [hli]
	and a
	jr z, .ask_learn
	cp d
	jr z, .already_knows
	dec b
	jr nz, .loop
.ask_learn
	ld a, d
	ld [wd265], a
	call GetMoveName
	ld hl, wStringBuffer1
	ld de, wStringBuffer2
	ld bc, wStringBuffer2 - wStringBuffer1
	rst CopyBytes

	ld hl, .AskTeachMoveText
	call PrintText
	call YesNoBox
	jr c, .cancel

	predef LearnMove
	ld hl, .ComeAgainText
	jp PrintText

.cancel
	ld hl, .DeclinedText
	jp PrintText

.egg
	ld hl, .EggText
	jp PrintText

.no_mon
	ld hl, .NotPokemonText
	jp PrintText

.not_happy_enough
	ld hl, .NotHappyEnoughText
	jp PrintText

.already_knows
	ld hl, .HappyButKnowsText
	jp PrintText

.IntroText:
	text_jump HappinessTutor_IntroText

.WhichOneText:
	text_jump HappinessTutor_WhichOneText

.AskTeachMoveText:
	text_jump HappinessTutor_AskTeachMoveText

.ComeAgainText:
	text_jump HappinessTutor_ComeAgainText

.DeclinedText:
	text_jump HappinessTutor_DeclinedText

.EggText:
	text_jump HappinessTutor_EggText

.NotPokemonText:
	text_jump HappinessTutor_NotPokemonText

.NotHappyEnoughText:
	text_jump HappinessTutor_NotHappyEnoughText

.HappyButKnowsText:
	text_jump HappinessTutor_HappyButKnowsText

HappinessMoves:
	; obviously needs to be filled in
	db MUSTARD_GAS
	db MUSTARD_GAS
	db MUSTARD_GAS
	db SACRED_FIRE
	db SACRED_FIRE
	db SACRED_FIRE
	db POWER_GEM
	db POWER_GEM
	db POWER_GEM
	db X_SCISSOR
	db X_SCISSOR
	db X_SCISSOR
	db METEOR_MASH
	db METEOR_MASH
	db LEWISITE
	db STORM_FRONT
	db STORM_FRONT
	db STORM_FRONT
	db STORM_FRONT
	db STORM_FRONT
	db STORM_FRONT
	db STORM_FRONT
	db PAIN_SPLIT
	db PAIN_SPLIT
	db BARRIER
	db BARRIER
	db EXTREMESPEED
	db EXTREMESPEED
	db EXTREMESPEED
	db WILD_CHARGE
	db WILD_CHARGE
	db PERISH_SONG
	db PERISH_SONG
	db PERISH_SONG
	db MOONBLAST
	db MOONBLAST
	db SACRED_FIRE
	db SACRED_FIRE
	db MOONLIGHT
	db MOONLIGHT
	db OUTRAGE
	db OUTRAGE
	db THUNDER_FANG
	db THUNDER_FANG
	db THUNDER_FANG
	db CONFUSE_RAY
	db CONFUSE_RAY
	db NIGHT_SHADE
	db NIGHT_SHADE
	db SIGNAL_BEAM
	db SIGNAL_BEAM
	db NIGHT_SHADE
	db NIGHT_SHADE
	db DRAIN_PUNCH
	db DRAIN_PUNCH
	db ROLLOUT
	db ROLLOUT
	db DRAGON_DANCE
	db DRAGON_DANCE
	db SPITE
	db SPITE
	db SPITE
	db AMNESIA
	db AMNESIA
	db AMNESIA
	db DRAIN_PUNCH
	db DRAIN_PUNCH
	db DRAIN_PUNCH
	db LEWISITE
	db LEWISITE
	db LEWISITE
	db VAPORIZE
	db VAPORIZE
	db METEOR_MASH
	db METEOR_MASH
	db METEOR_MASH
	db NASTY_PLOT
	db NASTY_PLOT
	db GROWTH
	db GROWTH
	db BASE_TREMOR
	db BASE_TREMOR
	db BASE_TREMOR
	db LEWISITE
	db LEWISITE
	db DRAGON_PULSE
	db DRAGON_PULSE
	db MAGNITUDE
	db MAGNITUDE
	db PERISH_SONG
	db PERISH_SONG
	db MOONBLAST
	db MOONBLAST
	db MOONBLAST
	db HEAD_SMASH
	db EXPLOSION
	db EXPLOSION
	db FOCUS_ENERGY
	db FOCUS_ENERGY
	db FOCUS_ENERGY
	db FOCUS_ENERGY
	db CONFUSE_RAY
	db CONFUSE_RAY
	db RAZOR_LEAF
	db RAZOR_LEAF
	db TAKE_DOWN
	db TAKE_DOWN
	db FOCUS_ENERGY
	db CRUNCH
	db CRUNCH
	db DRAGON_DANCE
	db DRAGON_DANCE
	db HAZE
	db SLUDGE
	db HEAD_SMASH
	db SLUDGE
	db HEAD_SMASH
	db AQUA_JET
	db AQUA_JET
	db AQUA_JET
	db AQUA_JET
	db AQUA_JET
	db CRUNCH
	db EARTH_POWER
	db BULLET_PUNCH
	db SACRED_FIRE
	db BULLET_PUNCH
	db SACRED_FIRE
	db VAPORIZE
	db VAPORIZE
	db WILD_CHARGE
	db DISABLE
	db EARTH_POWER
	db AQUA_JET
	db BASE_TREMOR
	db EARTH_POWER
	db METALLURGY
	db PAIN_SPLIT
	db RAPID_SPIN
	db RAPID_SPIN
	db HEAD_SMASH
	db HEAD_SMASH
	db MINIMIZE
	db POWER_GEM
	db CONFUSE_RAY
	db SACRED_FIRE
	db AURA_SPHERE
	db AURA_SPHERE
	db AURA_SPHERE
	db GROWTH
	db GROWTH
	db GROWTH
	db GROWTH
	db GROWTH
	db FEINT_ATTACK
	db FEINT_ATTACK
	db FEINT_ATTACK
	db FOCUS_ENERGY
	db FOCUS_ENERGY
	db FOCUS_ENERGY
	db RECOVER
	db RECOVER
	db SWEET_KISS
	db SWEET_KISS
	db SWEET_KISS
	db SWEET_KISS
	db POISON_GAS
	db POISON_GAS
	db OUTRAGE
	db AQUA_JET
	db AQUA_JET
	db BARRIER
	db SCARY_FACE
	db MOONLIGHT
	db MOONLIGHT
	db MOONLIGHT
	db AEROBLAST
	db AEROBLAST
	db PURSUIT
	db PURSUIT
	db PURSUIT
	db MOONLIGHT
	db FOCUS_ENERGY
	db FOCUS_ENERGY
	db LEWISITE
	db LEWISITE
	db AQUA_JET
	db AQUA_JET
	db DRAGON_DANCE
	db DRAGON_DANCE
	db CROSS_CHOP
	db CROSS_CHOP
	db FEINT_ATTACK
	db FEINT_ATTACK
	db SPRING_BUDS
	db AURA_SPHERE
	db AURA_SPHERE
	db IRON_DEFENSE
	db GROWTH
	db SACRED_FIRE
	db SACRED_FIRE
	db LEWISITE
	db LEWISITE
	db SMOKESCREEN
	db SMOKESCREEN
	db HEAD_SMASH
	db X_SCISSOR
	db HEAD_SMASH
	db X_SCISSOR
	db AQUA_JET
	db AQUA_JET
	db METALLURGY
	db IRON_DEFENSE
	db IRON_DEFENSE
	db CRUNCH
	db CRUNCH
	db CRUNCH
	db ACID_ARMOR
	db ACID_ARMOR
	db HEAD_SMASH
	db HEAD_SMASH
	db NIGHT_SLASH
	db NIGHT_SLASH
	db NIGHT_SLASH
	db NIGHT_SLASH
	db NIGHT_SLASH
	db NIGHT_SLASH
	db NIGHT_SLASH
	db NIGHT_SLASH
	db HEAD_SMASH
	db METALLURGY
	db METALLURGY
	db METALLURGY
	db METALLURGY
	db CRUNCH
	db DRAIN_PUNCH
	db DRAIN_PUNCH
	db BASE_TREMOR
	db BULLET_PUNCH
	db SACRED_FIRE
	db SWEET_KISS
	db HAZE
	db FLARE_BLITZ
	db AQUA_JET
	db AEROBLAST
	db DRAGON_PULSE
	db DRAGON_PULSE
	db DRAGON_PULSE
	db AURA_SPHERE
	db LAVA_POOL
	db GROWTH
	db BULLET_PUNCH
	db TACKLE
	db LEWISITE
	db TACKLE
	db TACKLE
