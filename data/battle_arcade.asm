battle_arcade_entry: MACRO
	; relative likelihood, species, item, attack DV, defense DV, speed DV, special DV
	; likelihood is relative chance of being picked, DVs are out of 3 (the upper bits are set by the scaled data calculation)
	; moves are on a line by itself because macros cannot take more than nine parameters
	; DVs are optional; leave them out if maxed out
ARCADE_MAX_ENTRY_RANDOM = ARCADE_MAX_ENTRY_RANDOM + \1
	db \1
	if _NARG > 2
		db \2, \3
		if _NARG > 3
			db (\4) | (\5 << 2) | (\6 << 4) | (\7 << 6)
		else
			db $ff
		endc
	else
		db \2
		db 0, $ff
	endc
ENDM

battle_arcade_moves: MACRO
	db \1
	if _NARG > 1
		db \2
	else
		db NO_MOVE
	endc
	if _NARG > 2
		db \3
	else
		db NO_MOVE
	endc
	if _NARG > 3
		db \4
	else
		db NO_MOVE
	endc
	if _NARG > 4
		fail "A set cannot have more than four moves"
	endc
ENDM

ARCADE_MAX_ENTRY_RANDOM = 0

BattleArcadeSets::

; general format:
; battle_arcade_entry 60, CHARIZARD, LEFTOVERS, 3, 3, 3, 3 (declares a Charizard with relative chance 60, holding Leftovers, with max DVs)
; battle_arcade_moves FLAMETHROWER, FLY, TOXIC, PROTECT (declares the moves that the Charizard has)
; the DVs can be left out if they are all maxed out (i.e., they are all 3, 3, 3, 3)

	battle_arcade_entry 60, VENUSAUR, LEPPA_BERRY, 3, 3, 2, 3
	battle_arcade_moves GIGA_DRAIN, LEECH_SEED, SYNTHESIS, SLUDGE_BOMB

	battle_arcade_entry 60, IVYSAUR, HARD_STONE
	battle_arcade_moves ENERGY_BALL, SLUDGE_BOMB, ANCIENTPOWER, TOXIC

	battle_arcade_entry 75, VENUSAUR, MIRACLE_SEED
	battle_arcade_moves VINE_WHIP, SLUDGE_BOMB, LEECH_SEED, PROTECT

	battle_arcade_entry 75, VENUSAUR, LEPPA_BERRY
	battle_arcade_moves GIGA_DRAIN, LEECH_SEED, SYNTHESIS, SLUDGE_BOMB

	battle_arcade_entry 60, CHARMELEON, HARD_STONE
	battle_arcade_moves FLARE_BLITZ, OUTRAGE, ROCK_SLIDE, SCREECH

	battle_arcade_entry 75, CHARIZARD, POLKADOT_BOW
	battle_arcade_moves WING_ATTACK, DRAGON_CLAW, SLASH, SMOKESCREEN

	battle_arcade_entry 75, CHARIZARD, LEFTOVERS
	battle_arcade_moves FLAMETHROWER, FLY, TOXIC, PROTECT

	battle_arcade_entry 60, WARTORTLE
	battle_arcade_moves SURF, ICE_BEAM, AURA_SPHERE, PROTECT

	battle_arcade_entry 75, BLASTOISE, LEFTOVERS
	battle_arcade_moves HYDRO_PUMP, ZAP_CANNON, DARK_PULSE, HAZE

	battle_arcade_entry 75, BLASTOISE, LEFTOVERS
	battle_arcade_moves CURSE, AQUA_JET, WATERFALL, BODY_SLAM

	battle_arcade_entry 25, CATERPIE, FOCUS_BAND
	battle_arcade_moves TACKLE, STRING_SHOT

	battle_arcade_entry 25, METAPOD, FOCUS_BAND
	battle_arcade_moves TACKLE, HARDEN

	battle_arcade_entry 100, BUTTERFREE, BERRY_JUICE
	battle_arcade_moves BUG_BUZZ, AIR_SLASH, SPRING_BUDS, PROTECT

	battle_arcade_entry 100, CHIMECHO, ORAN_BERRY
	battle_arcade_moves PSYBEAM, NOISE_PULSE, CALM_MIND, RECOVER

	battle_arcade_entry 100, CHIMECHO, TWISTEDSPOON
	battle_arcade_moves BASE_TREMOR, ZEN_HEADBUTT, POWER_BALLAD, LIGHT_SCREEN

	battle_arcade_entry 100, TORKOAL, LEFTOVERS
	battle_arcade_moves MUSTARD_GAS, FIRE_SPIN, POISON_GAS, SMOKESCREEN

	battle_arcade_entry 100, TORKOAL, LUM_BERRY
	battle_arcade_moves SARIN, EARTHQUAKE, FLAMETHROWER, LEWISITE

	battle_arcade_entry 100, PIDGEOT, PECHA_BERRY
	battle_arcade_moves AIR_SLASH, VOID_SPHERE, HYPER_BEAM, FINAL_CHANCE

	battle_arcade_entry 40, TAILLOW, FOCUS_BAND
	battle_arcade_moves BRAVE_BIRD, DOUBLE_EDGE, BASE_TREMOR, SWAGGER

	battle_arcade_entry 100, SWELLOW, BERRY_JUICE
	battle_arcade_moves BRAVE_BIRD, POWER_BALLAD, QUICK_ATTACK, SUPERSONIC

	battle_arcade_entry 100, FEAROW, ASPEAR_BERRY
	battle_arcade_moves SKY_ATTACK, TRI_ATTACK, DUST_DEVIL, PURSUIT

	battle_arcade_entry 40, BUNEARY, FOCUS_BAND
	battle_arcade_moves BODY_SLAM, HI_JUMP_KICK, PLAY_ROUGH, TOXIC

	battle_arcade_entry 100, LOPUNNY, BLACKBELT
	battle_arcade_moves HEADBUTT, HI_JUMP_KICK, DIZZY_PUNCH, COSMIC_POWER

	battle_arcade_entry 100, LOPUNNY, BERSERK_GENE, 3, 3, 2, 3
	battle_arcade_moves SWIFT, THUNDERBOLT, TOXIC, PROTECT

	battle_arcade_entry 75, PIKACHU, LIGHT_BALL
	battle_arcade_moves THUNDERBOLT, SURF, FLY, DIG

	battle_arcade_entry 100, RAICHU, METAL_COAT
	battle_arcade_moves THUNDER, METEOR_MASH, SEISMIC_TOSS, NASTY_PLOT

	battle_arcade_entry 40, SHINX, FOCUS_BAND, 3, 3, 2, 3
	battle_arcade_moves THUNDER_FANG, BASE_TREMOR, BITE, THUNDER_WAVE

	battle_arcade_entry 60, LUXIO, FOCUS_BAND, 3, 3, 2, 3
	battle_arcade_moves THUNDER, NIGHT_SLASH, SIGNAL_BEAM, RAIN_DANCE

	battle_arcade_entry 100, LUXRAY, LUM_BERRY
	battle_arcade_moves THUNDER_FANG, IRON_TAIL, BITE, SCARY_FACE

	battle_arcade_entry 100, LUXRAY, NO_ITEM, 3, 3, 2, 3
	battle_arcade_moves WILD_CHARGE, MUD_SLAP, THIEF, LEER

	battle_arcade_entry 40, ELECTRIKE, FOCUS_BAND
	battle_arcade_moves CRYSTAL_BOLT, NOISE_PULSE, FLAMETHROWER, TOXIC

	battle_arcade_entry 100, MANECTRIC, POLKADOT_BOW
	battle_arcade_moves SPARK, CRUNCH, HEADBUTT, CURSE

	battle_arcade_entry 40, SNORUNT, FOCUS_BAND, 3, 3, 2, 3
	battle_arcade_moves BLIZZARD, DOUBLE_TEAM, DISABLE, HAIL

	battle_arcade_entry 100, MANECTRIC, NEVERMELTICE, 3, 3, 2, 3
	battle_arcade_moves THUNDERBOLT, FLAMETHROWER, HYPER_BEAM, PRISM_SPRAY

	battle_arcade_entry 100, GLALIE, FOCUS_BAND
	battle_arcade_moves FREEZE_BURN, CRUNCH, EXPLOSION, SPIKES

	battle_arcade_entry 100, GLALIE, BLACKGLASSES, 3, 3, 2, 3
	battle_arcade_moves BLIZZARD, DARK_PULSE, HAIL, PROTECT

	battle_arcade_entry 100, FROSLASS, BRIGHTPOWDER
	battle_arcade_moves ICE_PUNCH, SHADOW_CLAW, DRAININGKISS, HAIL

	battle_arcade_entry 50, FROSLASS, ORAN_BERRY, 3, 3, 2, 3
	battle_arcade_moves SHADOW_BALL, ICE_BEAM, THUNDER, RAIN_DANCE

	battle_arcade_entry 100, VOLBEAT, SILVERPOWDER, 3, 3, 2, 3
	battle_arcade_moves BUG_BUZZ, GROWTH, AGILITY, ENDURE

	battle_arcade_entry 100, ILLUMISE, LEFTOVERS, 3, 3, 2, 3
	battle_arcade_moves SIGNAL_BEAM, METRONOME, MOONLIGHT, CONFUSE_RAY

	battle_arcade_entry 100, NINETALES, SOFT_SAND
	battle_arcade_moves FLAMETHROWER, DIG, QUICK_ATTACK, WILL_O_WISP

	battle_arcade_entry 50, NINETALES, NEVERMELTICE
	battle_arcade_moves BOIL, FREEZE_BURN, DARK_PULSE, NASTY_PLOT

	battle_arcade_entry 40, JIGGLYPUFF, LEFTOVERS
	battle_arcade_moves SEISMIC_TOSS, LIGHT_SCREEN, REFLECT, PERISH_SONG

	battle_arcade_entry 100, WIGGLYTUFF, HARD_STONE
	battle_arcade_moves BASE_TREMOR, PLAY_ROUGH, ROLLOUT, DEFENSE_CURL

	battle_arcade_entry 100, WIGGLYTUFF, MEGAPHONE, 3, 3, 2, 3
	battle_arcade_moves MOONBLAST, NOISE_PULSE, ICY_WIND, SING

	battle_arcade_entry 60, GOLBAT, LEFTOVERS
	battle_arcade_moves SLUDGE_BOMB, AIR_SLASH, HAZE, CONFUSE_RAY

	battle_arcade_entry 40, ARON, FOCUS_BAND
	battle_arcade_moves HEAD_SMASH, IRON_TAIL, EARTHQUAKE, TOXIC

	battle_arcade_entry 60, LAIRON, FOCUS_BAND, 3, 3, 2, 3
	battle_arcade_moves IRON_HEAD, ROCK_SLIDE, STOMP, AGILITY

	battle_arcade_entry 100, AGGRON, LEFTOVERS
	battle_arcade_moves FLASH_CANNON, POWER_GEM, PROTECT, METALLURGY

	battle_arcade_entry 100, AGGRON, HARD_STONE, 3, 3, 2, 3
	battle_arcade_moves IRON_TAIL, ROCK_SLIDE, DOUBLE_EDGE, IRON_DEFENSE

	battle_arcade_entry 100, PARASECT, POISON_BARB
	battle_arcade_moves SPRING_BUDS, SLUDGE_BOMB, DIG, PROTECT

	battle_arcade_entry 100, PARASECT, LEFTOVERS, 3, 3, 2, 3
	battle_arcade_moves SEED_BOMB, X_SCISSOR, SLEEP_POWDER, SWORDS_DANCE

	battle_arcade_entry 100, VENOMOTH, LEFTOVERS, 3, 3, 2, 3
	battle_arcade_moves BUG_BUZZ, AGILITY, SUBSTITUTE, BATON_PASS

	battle_arcade_entry 40, BRONZOR, FOCUS_BAND
	battle_arcade_moves PSYCHIC_M, FLASH_CANNON, SOLARBEAM, RAIN_DANCE

	battle_arcade_entry 100, BRONZONG, METAL_COAT
	battle_arcade_moves ZEN_HEADBUTT, IRON_HEAD, STEEL_EATER, RAIN_DANCE

	battle_arcade_entry 100, BRONZONG, LUM_BERRY
	battle_arcade_moves PSYCHIC_M, FLASH_CANNON, SHADOW_BALL, SAFEGUARD

	battle_arcade_entry 50, DRAPION, RAWST_BERRY
	battle_arcade_moves SLUDGE_BOMB, DARK_PULSE, EARTHQUAKE, AGILITY

	battle_arcade_entry 100, DRAPION, SILVERPOWDER, 3, 3, 2, 3
	battle_arcade_moves NIGHT_SLASH, STEEL_EATER, SLASH, POISON_JAB

	battle_arcade_entry 40, CRANIDOS, HARD_STONE
	battle_arcade_moves ROCK_SLIDE, FIRE_PUNCH, ICE_PUNCH, SCARY_FACE

	battle_arcade_entry 100, RAMPARDOS, HARD_STONE
	battle_arcade_moves DUST_DEVIL, ZEN_HEADBUTT, FLAMETHROWER, LEER

	battle_arcade_entry 50, RAMPARDOS, ASPEAR_BERRY
	battle_arcade_moves HEAD_SMASH, MUSTARD_GAS, IRON_HEAD, SUNNY_DAY

	battle_arcade_entry 40, SHIELDON, LEFTOVERS
	battle_arcade_moves IRON_TAIL, STEEL_EATER, IRON_DEFENSE, SCREECH

	battle_arcade_entry 100, BASTIODON, LUM_BERRY
	battle_arcade_moves FLASH_CANNON, ANCIENTPOWER, NOISE_PULSE, METALLURGY

	battle_arcade_entry 100, ARCANINE, DRAGON_FANG
	battle_arcade_moves BOIL, DRAGON_PULSE, SOLARBEAM, SUNNY_DAY

	battle_arcade_entry 100, ARCANINE, BLACKBELT
	battle_arcade_moves FLAME_WHEEL, EXTREMESPEED, DOUBLE_KICK, ROAR

	battle_arcade_entry 40, WHISMUR, FOCUS_BAND
	battle_arcade_moves HYPER_VOICE, FIRE_BLAST, BLIZZARD, SHADOW_BALL

	battle_arcade_entry 60, LOUDRED, FOCUS_BAND
	battle_arcade_moves BASE_TREMOR, BODY_SLAM, THUNDERPUNCH, POWER_BALLAD

	battle_arcade_entry 50, EXPLOUD, MEGAPHONE
	battle_arcade_moves HYPER_VOICE, SURF, SLEEP_TALK, REST

	battle_arcade_entry 100, EXPLOUD, POLKADOT_BOW
	battle_arcade_moves BASE_TREMOR, STOMP, ASTONISH, SCREECH

	battle_arcade_entry 100, ALAKAZAM, ASPEAR_BERRY
	battle_arcade_moves PSYBEAM, ENERGY_BALL, SIGNAL_BEAM, CALM_MIND

	battle_arcade_entry 100, ALAKAZAM, TWISTEDSPOON
	battle_arcade_moves ZEN_HEADBUTT, ICE_PUNCH, FIRE_PUNCH, THUNDERPUNCH

	battle_arcade_entry 100, MACHAMP, CHARCOAL
	battle_arcade_moves CROSS_CHOP, FLAMETHROWER, ICE_PUNCH, BULLET_PUNCH

	battle_arcade_entry 50, MACHAMP, SOFT_SAND
	battle_arcade_moves DYNAMICPUNCH, ROCK_SLIDE, DIG, TOXIC

	battle_arcade_entry 100, VICTREEBEL, MIRACLE_SEED
	battle_arcade_moves STEEL_EATER, GIGA_DRAIN, FINAL_CHANCE, SUNNY_DAY

	battle_arcade_entry 80, TENTACRUEL, POLKADOT_BOW
	battle_arcade_moves POISON_JAB, WATERFALL, WRAP, SWORDS_DANCE

	battle_arcade_entry 80, TENTACRUEL, MIRACLE_SEED, 3, 3, 2, 3
	battle_arcade_moves SURF, SLUDGE_BOMB, GIGA_DRAIN, VAPORIZE

	battle_arcade_entry 100, GOLEM, MAGNET
	battle_arcade_moves ROCK_SLIDE, DOUBLE_EDGE, THUNDERPUNCH, METALLURGY

	battle_arcade_entry 100, GOLEM, HARD_STONE, 3, 3, 2, 3
	battle_arcade_moves DIG, ROLLOUT, SELFDESTRUCT, DEFENSE_CURL

	battle_arcade_entry 50, RAPIDASH, SILVERPOWDER, 3, 3, 2, 3
	battle_arcade_moves FLARE_BLITZ, MEGAHORN, SUNNY_DAY, MORNING_SUN

	battle_arcade_entry 100, RAPIDASH, METAL_COAT
	battle_arcade_moves FLAMETHROWER, IRON_TAIL, WILD_CHARGE, AGILITY

	battle_arcade_entry 50, SLOWBRO, LEFTOVERS
	battle_arcade_moves WATERFALL, ZEN_HEADBUTT, THUNDER_WAVE, PROTECT

	battle_arcade_entry 100, SLOWBRO, POLKADOT_BOW
	battle_arcade_moves PSYCHIC_M, SURF, VOID_SPHERE, DISABLE

	battle_arcade_entry 100, MAGNETON, MAGNET
	battle_arcade_moves ZAP_CANNON, FLASH_CANNON, TRI_ATTACK, MIND_READER

	battle_arcade_entry 100, MAGNEZONE, LEFTOVERS
	battle_arcade_moves WILD_CHARGE, ROLLOUT, SCREECH, IRON_DEFENSE

	battle_arcade_entry 100, MAGNEZONE, MEGAPHONE, 3, 3, 2, 3
	battle_arcade_moves THUNDERBOLT, FLASH_CANNON, NOISE_PULSE, LIGHT_SCREEN

	battle_arcade_entry 40, DRIFLOON, SITRUS_BERRY, 3, 3, 2, 3
	battle_arcade_moves SHADOW_BALL, THUNDER, WILL_O_WISP, RAIN_DANCE

	battle_arcade_entry 100, DRIFBLIM, PINK_BOW
	battle_arcade_moves SHADOW_BALL, STORM_FRONT, PRISM_SPRAY, HAZE

	battle_arcade_entry 100, DRIFBLIM, SITRUS_BERRY, 3, 3, 2, 3
	battle_arcade_moves ASTONISH, BODY_SLAM, EXPLOSION, ENDURE

	battle_arcade_entry 100, SABLEYE, LEFTOVERS
	battle_arcade_moves FEINT_ATTACK, TOXIC, MEAN_LOOK, PROTECT

	battle_arcade_entry 50, SPIRITOMB, ORAN_BERRY
	battle_arcade_moves DARK_PULSE, SHADOW_BALL, PAIN_SPLIT, NASTY_PLOT

	battle_arcade_entry 100, BANETTE, BLACKGLASSES
	battle_arcade_moves SHADOW_CLAW, PURSUIT, MUSTARD_GAS, SCREECH

	battle_arcade_entry 100, BANETTE, LEFTOVERS, 3, 3, 2, 3
	battle_arcade_moves SHADOW_BALL, WILL_O_WISP, DISABLE, PROTECT

	battle_arcade_entry 40, DUSKULL, SITRUS_BERRY
	battle_arcade_moves NIGHT_SHADE, TOXIC, CURSE, PROTECT

	battle_arcade_entry 100, DUSCLOPS, LEFTOVERS
	battle_arcade_moves FUTURE_SIGHT, NIGHT_SHADE, SPITE, PROTECT

	battle_arcade_entry 100, GENGAR, CIGARETTE
	battle_arcade_moves SHADOW_BALL, MUSTARD_GAS, GIGA_DRAIN, MEAN_LOOK

	battle_arcade_entry 100, GENGAR, ORAN_BERRY, 3, 3, 2, 3
	battle_arcade_moves SARIN, SHADOW_CLAW, LEWISITE, METRONOME

	battle_arcade_entry 40, ONIX, HARD_STONE
	battle_arcade_moves EARTHQUAKE, ROCK_SLIDE, DRAGONBREATH, CURSE

	battle_arcade_entry 100, LUNATONE, LEFTOVERS
	battle_arcade_moves PSYCHIC_M, POWER_GEM, MOONBLAST, COSMIC_POWER

	battle_arcade_entry 100, SOLROCK, LUM_BERRY
	battle_arcade_moves ZEN_HEADBUTT, ROCK_SLIDE, EXPLOSION, WILL_O_WISP

	battle_arcade_entry 60, VIBRAVA, FOCUS_BAND
	battle_arcade_moves EARTHQUAKE, OUTRAGE, SAND_ATTACK, SCREECH

	battle_arcade_entry 50, FLYGON, LUM_BERRY
	battle_arcade_moves EARTHQUAKE, DRAGON_CLAW, IRON_TAIL, CRUNCH

	battle_arcade_entry 50, FLYGON, HARD_STONE
	battle_arcade_moves DRAGON_PULSE, HYPER_VOICE, BUG_BUZZ, DUST_DEVIL

	battle_arcade_entry 40, MAKUHITA, SITRUS_BERRY
	battle_arcade_moves DRAIN_PUNCH, FEINT_ATTACK, ICE_PUNCH, BULLET_PUNCH

	battle_arcade_entry 100, HARIYAMA, MYSTIC_WATER
	battle_arcade_moves REVERSAL, SURF, BODY_SLAM, ENDURE

	battle_arcade_entry 100, HARIYAMA, SITRUS_BERRY, 3, 3, 2, 3
	battle_arcade_moves CROSS_CHOP, BASE_TREMOR, BULLET_PUNCH, BELLY_DRUM

	battle_arcade_entry 100, EXEGGUTOR, MIRACLE_SEED
	battle_arcade_moves ZEN_HEADBUTT, GIGA_DRAIN, MOONLIGHT, SUNNY_DAY

	battle_arcade_entry 100, CACTURNE, BLACKGLASSES
	battle_arcade_moves SEED_BOMB, FEINT_ATTACK, PIN_MISSILE, SANDSTORM

	battle_arcade_entry 50, HITMONLEE, RAWST_BERRY
	battle_arcade_moves HI_JUMP_KICK, DOUBLE_KICK, BULK_UP, MIND_READER

	battle_arcade_entry 100, HITMONLEE, METAL_COAT, 3, 3, 2, 3
	battle_arcade_moves HI_JUMP_KICK, ROCK_SLIDE, HEADBUTT, BULLET_PUNCH

	battle_arcade_entry 50, HITMONCHAN, ORAN_BERRY
	battle_arcade_moves DRAIN_PUNCH, ICE_PUNCH, FIRE_PUNCH, THUNDERPUNCH

	battle_arcade_entry 100, HITMONCHAN, CHESTO_BERRY, 3, 3, 2, 3
	battle_arcade_moves MACH_PUNCH, BULLET_PUNCH, REST, BULK_UP

	battle_arcade_entry 40, TRAPINCH, BRIGHTPOWDER
	battle_arcade_moves EARTHQUAKE, CRUNCH, QUICK_ATTACK, SWAGGER

	battle_arcade_entry 50, WEEZING, POISON_BARB
	battle_arcade_moves SARIN, SLUDGE_BOMB, LEWISITE, WILL_O_WISP

	battle_arcade_entry 100, WEEZING, CIGARETTE
	battle_arcade_moves SLUDGE, MUSTARD_GAS, FLAMETHROWER, SELFDESTRUCT

	battle_arcade_entry 60, RHYDON, ORAN_BERRY
	battle_arcade_moves EARTHQUAKE, MEGAHORN, SURF, FLAMETHROWER

	battle_arcade_entry 60, CHANSEY, LUCKY_PUNCH
	battle_arcade_moves METRONOME, SEISMIC_TOSS, TOXIC, SOFTBOILED

	battle_arcade_entry 100, KANGASKHAN, PINK_BOW
	battle_arcade_moves BODY_SLAM, DIZZY_PUNCH, THUNDERPUNCH, TAIL_WHIP

	battle_arcade_entry 100, KANGASKHAN, POLKADOT_BOW, 3, 3, 2, 3
	battle_arcade_moves STOMP, OUTRAGE, FIRE_PUNCH, SUBSTITUTE

	battle_arcade_entry 100, TANGROWTH, HARD_STONE
	battle_arcade_moves ENERGY_BALL, ANCIENTPOWER, PRISM_SPRAY, SUNNY_DAY

	battle_arcade_entry 100, TANGROWTH, MIRACLE_SEED
	battle_arcade_moves RAZOR_LEAF, EARTHQUAKE, SYNTHESIS, SUNNY_DAY

	battle_arcade_entry 100, MAWILE, LEFTOVERS
	battle_arcade_moves PLAY_ROUGH, DYNAMICPUNCH, THUNDER_FANG, IRON_DEFENSE

	battle_arcade_entry 100, MAWILE, POISON_BARB, 3, 3, 2, 3
	battle_arcade_moves FLASH_CANNON, ICE_BEAM, FLAMETHROWER, SLUDGE_BOMB

	battle_arcade_entry 100, SEAKING, TWISTEDSPOON
	battle_arcade_moves HYDRO_PUMP, PSYBEAM, SIGNAL_BEAM, RAIN_DANCE

	battle_arcade_entry 100, SEAKING, SITRUS_BERRY
	battle_arcade_moves WATERFALL, MEGAHORN, POISON_JAB, AGILITY

	battle_arcade_entry 40, LOTAD, FOCUS_BAND
	battle_arcade_moves HYDRO_PUMP, ENERGY_BALL, BLIZZARD, RAIN_DANCE

	battle_arcade_entry 60, LOMBRE, MYSTIC_WATER, 3, 3, 2, 3
	battle_arcade_moves SURF, LEECH_SEED, RAIN_DANCE, PROTECT

	battle_arcade_entry 100, LUDICOLO, MAGNET
	battle_arcade_moves ENERGY_BALL, WATERFALL, THUNDERPUNCH, SWORDS_DANCE

	battle_arcade_entry 100, LUDICOLO, RAWST_BERRY, 3, 3, 2, 3
	battle_arcade_moves BUBBLEBEAM, SPRING_BUDS, METRONOME, RAIN_DANCE

	battle_arcade_entry 60, SCYTHER, SCOPE_LENS
	battle_arcade_moves WING_ATTACK, FURY_CUTTER, SLASH, FOCUS_ENERGY

	battle_arcade_entry 100, RELICANTH, TWISTEDSPOON
	battle_arcade_moves WATERFALL, ROCK_SLIDE, ZEN_HEADBUTT, RAIN_DANCE

	battle_arcade_entry 50, RELICANTH, LUM_BERRY
	battle_arcade_moves HEAD_SMASH, HYDRO_PUMP, DOUBLE_EDGE, REST

	battle_arcade_entry 60, ELECTABUZZ, TWISTEDSPOON
	battle_arcade_moves THUNDERBOLT, PSYCHIC_M, SEISMIC_TOSS, LIGHT_SCREEN

	battle_arcade_entry 60, MAGMAR, MYSTIC_WATER
	battle_arcade_moves FLAMETHROWER, BUBBLEBEAM, LAVA_POOL, VAPORIZE

	battle_arcade_entry 100, ELECTIVIRE, BLACKBELT
	battle_arcade_moves CRYSTAL_BOLT, DRAIN_PUNCH, ICE_PUNCH, SCREECH

	battle_arcade_entry 100, MAGMORTAR, CHARCOAL
	battle_arcade_moves BOIL, PSYCHIC_M, CROSS_CHOP, SMOKESCREEN

	battle_arcade_entry 50, GYARADOS, PERSIM_BERRY
	battle_arcade_moves WATERFALL, EARTHQUAKE, FINAL_CHANCE, DRAGON_DANCE

	battle_arcade_entry 100, GYARADOS, ORAN_BERRY
	battle_arcade_moves HYDRO_PUMP, STORM_FRONT, FLAMETHROWER, DARK_PULSE

	battle_arcade_entry 100, ABSOL, CHARCOAL
	battle_arcade_moves DARK_PULSE, THUNDER, FLAMETHROWER, WILL_O_WISP

	battle_arcade_entry 50, ABSOL, SCOPE_LENS, 3, 3, 2, 3
	battle_arcade_moves NIGHT_SLASH, PLAY_ROUGH, ZEN_HEADBUTT, SLASH

	battle_arcade_entry 100, DITTO, METAL_POWDER
	battle_arcade_moves TRANSFORM

	battle_arcade_entry 40, EEVEE, POLKADOT_BOW
	battle_arcade_moves DOUBLE_EDGE, IRON_TAIL, QUICK_ATTACK, SAND_ATTACK

	battle_arcade_entry 100, VAPOREON, BERRY_JUICE
	battle_arcade_moves HYDRO_PUMP, SIGNAL_BEAM, PRISM_SPRAY, ACID_ARMOR

	battle_arcade_entry 100, JOLTEON, KINGS_ROCK
	battle_arcade_moves CRYSTAL_BOLT, DOUBLE_KICK, PIN_MISSILE, THUNDER_WAVE

	battle_arcade_entry 100, FLAREON, POLKADOT_BOW
	battle_arcade_moves FLARE_BLITZ, TAKE_DOWN, IRON_TAIL, SMOG

	battle_arcade_entry 60, LILEEP, LEFTOVERS
	battle_arcade_moves ROCK_SLIDE, SWORDS_DANCE, LEECH_SEED, PROTECT

	battle_arcade_entry 100, CRADILY, ORAN_BERRY
	battle_arcade_moves SEED_BOMB, ANCIENTPOWER, EARTHQUAKE, RECOVER

	battle_arcade_entry 40, ANORITH, FOCUS_BAND
	battle_arcade_moves X_SCISSOR, ROCK_SLIDE, IRON_TAIL, STRING_SHOT

	battle_arcade_entry 100, ARMALDO, SITRUS_BERRY
	battle_arcade_moves X_SCISSOR, ROCK_SLIDE, IRON_TAIL, RAPID_SPIN

	battle_arcade_entry 50, SNORLAX, ORAN_BERRY
	battle_arcade_moves STOMP, METRONOME, CURSE, REST

	battle_arcade_entry 100, SNORLAX, MIRACLE_SEED, 3, 3, 2, 3
	battle_arcade_moves BODY_SLAM, SEED_BOMB, ICE_BEAM, THUNDERBOLT

	battle_arcade_entry 40, BELDUM, FOCUS_BAND
	battle_arcade_moves IRON_HEAD, ZEN_HEADBUTT, HEADBUTT, IRON_DEFENSE

	battle_arcade_entry 60, METANG, FOCUS_BAND
	battle_arcade_moves METEOR_MASH, ZEN_HEADBUTT, PURSUIT, AGILITY

	battle_arcade_entry 100, METAGROSS, NEVERMELTICE
	battle_arcade_moves METEOR_MASH, ZEN_HEADBUTT, ICY_WIND, BULLET_PUNCH

	battle_arcade_entry 25, MAGIKARP, FOCUS_BAND
	battle_arcade_moves TACKLE, FLAIL, SPLASH

	battle_arcade_entry 10, PHANCERO, ORAN_BERRY
	battle_arcade_moves SHADOW_BALL, STORM_FRONT, AURA_SPHERE, PROTECT

	battle_arcade_entry 20, ARTICUNO, HARD_STONE
	battle_arcade_moves ICE_BEAM, STORM_FRONT, ANCIENTPOWER, MIST

	battle_arcade_entry 20, ZAPDOS, SILVERPOWDER
	battle_arcade_moves THUNDERBOLT, DRILL_PECK, SIGNAL_BEAM, THUNDER_WAVE

	battle_arcade_entry 20, MOLTRES, SHARP_BEAK
	battle_arcade_moves FLAMETHROWER, WING_ATTACK, SOLARBEAM, SUNNY_DAY

	battle_arcade_entry 10, MEWTWO, ASPEAR_BERRY
	battle_arcade_moves PSYCHIC_M, VOID_SPHERE, AURA_SPHERE, AMNESIA

	battle_arcade_entry 10, MEW, SITRUS_BERRY
	battle_arcade_moves TRANSFORM, METRONOME, NASTY_PLOT, BATON_PASS

	battle_arcade_entry 10, FAMBACO, ORAN_BERRY
	battle_arcade_moves EARTHQUAKE, PSYCHO_CUT, HEADBUTT, AGILITY

	battle_arcade_entry 10, GROUDON, ORAN_BERRY
	battle_arcade_moves FLAMETHROWER, SOLARBEAM, SLASH, BULK_UP

	battle_arcade_entry 10, KYOGRE, ORAN_BERRY
	battle_arcade_moves WATERFALL, BLIZZARD, THUNDER_WAVE, HAIL

	battle_arcade_entry 10, RAYQUAZA, POLKADOT_BOW
	battle_arcade_moves DRAGON_CLAW, EXTREMESPEED, SCARY_FACE, SCREECH

	battle_arcade_entry 10, LUGIA, ORAN_BERRY
	battle_arcade_moves AEROBLAST, FUTURE_SIGHT, SAFEGUARD, PROTECT

	battle_arcade_entry 10, HO_OH, ORAN_BERRY
	battle_arcade_moves SACRED_FIRE, GIGA_DRAIN, ANCIENTPOWER, CALM_MIND

	battle_arcade_entry 10, VARANEOUS, ORAN_BERRY
	battle_arcade_moves FIRE_BLAST, BOIL, VOID_SPHERE, SUNNY_DAY

	battle_arcade_entry 10, RAIWATO, ORAN_BERRY
	battle_arcade_moves AEROBLAST, VOID_SPHERE, SMOKESCREEN, RECOVER

	battle_arcade_entry 10, LIBABEEL, SILVERPOWDER
	battle_arcade_moves HYDRO_PUMP, DARK_PULSE, PRISM_SPRAY, NASTY_PLOT

	battle_arcade_entry 60, BAYLEEF, FOCUS_BAND
	battle_arcade_moves SPRING_BUDS, NATURE_POWER, TOXIC, PROTECT

	battle_arcade_entry 100, MEGANIUM, MIRACLE_SEED
	battle_arcade_moves GIGA_DRAIN, OUTRAGE, EARTHQUAKE, SWORDS_DANCE

	battle_arcade_entry 60, QUILAVA, FOCUS_BAND
	battle_arcade_moves FIRE_BLAST, REVERSAL, SMOKESCREEN, ENDURE

	battle_arcade_entry 100, TYPHLOSION, BLACKBELT
	battle_arcade_moves FLAME_WHEEL, THUNDERPUNCH, DOUBLE_KICK, SMOKESCREEN

	battle_arcade_entry 60, CROCONAW
	battle_arcade_moves WATERFALL, CRUNCH, ROCK_SLIDE, DRAGON_DANCE

	battle_arcade_entry 100, FERALIGATR, NEVERMELTICE
	battle_arcade_moves SURF, SLASH, ICE_PUNCH, DRAGON_DANCE

	battle_arcade_entry 25, SENTRET, FOCUS_BAND
	battle_arcade_moves BODY_SLAM, DYNAMICPUNCH, MUD_SLAP, QUICK_ATTACK

	battle_arcade_entry 100, FURRET, MEGAPHONE
	battle_arcade_moves BODY_SLAM, FIRE_PUNCH, HYPER_VOICE, AMNESIA

	battle_arcade_entry 40, RALTS, FOCUS_BAND
	battle_arcade_moves PSYCHIC_M, DRAININGKISS, DESTINY_BOND, WILL_O_WISP

	battle_arcade_entry 60, KIRLIA, FOCUS_BAND
	battle_arcade_moves PSYCHIC_M, SHADOW_BALL, DRAININGKISS, CALM_MIND

	battle_arcade_entry 100, GARDEVOIR, PINK_BOW
	battle_arcade_moves DRAININGKISS, CONFUSION, ENERGY_BALL, CALM_MIND

	battle_arcade_entry 50, GARDEVOIR, MEGAPHONE, 3, 3, 2, 3
	battle_arcade_moves PSYCHIC_M, MOONBLAST, HYPER_VOICE, WILL_O_WISP

	battle_arcade_entry 50, GALLADE, SCOPE_LENS
	battle_arcade_moves DRAIN_PUNCH, PSYCHO_CUT, NIGHT_SLASH, BULK_UP

	battle_arcade_entry 100, GALLADE, ORAN_BERRY
	battle_arcade_moves CROSS_CHOP, ZEN_HEADBUTT, LEER, THUNDER_WAVE

	battle_arcade_entry 40, SPINARAK, FOCUS_BAND
	battle_arcade_moves MEGAHORN, DIG, TOXIC, SWAGGER

	battle_arcade_entry 100, ARIADOS, POISON_BARB
	battle_arcade_moves MEGAHORN, POISON_JAB, AGILITY, BATON_PASS

	battle_arcade_entry 100, CROBAT, POISON_BARB
	battle_arcade_moves STEEL_EATER, AIR_SLASH, GIGA_DRAIN, NASTY_PLOT

	battle_arcade_entry 100, LANTURN, TWISTEDSPOON
	battle_arcade_moves BUBBLEBEAM, ICE_BEAM, PSYBEAM, SIGNAL_BEAM

	battle_arcade_entry 100, LANTURN, MAGNET
	battle_arcade_moves WATERFALL, SPARK, FLAIL, ENDURE

	battle_arcade_entry 100, CARNIVINE, KINGS_ROCK
	battle_arcade_moves SEED_BOMB, SLUDGE_BOMB, FEINT_ATTACK, STUN_SPORE

	battle_arcade_entry 40, TOGEPI, LEFTOVERS
	battle_arcade_moves SEISMIC_TOSS, SHADOW_BALL, SOFTBOILED, SING

	battle_arcade_entry 60, TOGETIC, HARD_STONE
	battle_arcade_moves TRI_ATTACK, AIR_SLASH, ANCIENTPOWER, AGILITY

	battle_arcade_entry 40, NATU, FOCUS_BAND
	battle_arcade_moves PSYCHIC_M, NIGHT_SHADE, CONFUSE_RAY, THUNDER_WAVE

	battle_arcade_entry 100, XATU, ASPEAR_BERRY
	battle_arcade_moves PSYCHIC_M, AIR_SLASH, GIGA_DRAIN, NIGHT_SHADE

	battle_arcade_entry 100, XATU, METAL_COAT, 3, 3, 2, 3
	battle_arcade_moves ZEN_HEADBUTT, DRILL_PECK, STEEL_WING, HAZE

	battle_arcade_entry 40, MAREEP, FOCUS_BAND
	battle_arcade_moves THUNDERBOLT, HEADBUTT, SWAGGER, THUNDER_WAVE

	battle_arcade_entry 60, FLAAFFY, HARD_STONE
	battle_arcade_moves THUNDERBOLT, POWER_GEM, LIGHT_SCREEN, COTTON_SPORE

	battle_arcade_entry 100, AMPHAROS, CHARCOAL
	battle_arcade_moves SPARK, OUTRAGE, FIRE_PUNCH, HEADBUTT

	battle_arcade_entry 100, AMPHAROS, POLKADOT_BOW
	battle_arcade_moves ZAP_CANNON, DYNAMICPUNCH, SWIFT, SAND_ATTACK

	battle_arcade_entry 100, TOGEKISS, POLKADOT_BOW
	battle_arcade_moves SKY_ATTACK, ZEN_HEADBUTT, SWIFT, NASTY_PLOT

	battle_arcade_entry 100, TOGEKISS, ORAN_BERRY, 3, 3, 2, 3
	battle_arcade_moves AIR_SLASH, FLAMETHROWER, AURA_SPHERE, THUNDER_WAVE

	battle_arcade_entry 60, MARILL, SITRUS_BERRY
	battle_arcade_moves AQUA_JET, PLAY_ROUGH, TOXIC, BELLY_DRUM

	battle_arcade_entry 100, AZUMARILL, LEFTOVERS
	battle_arcade_moves HYDRO_PUMP, ICY_WIND, FUTURE_SIGHT, PROTECT

	battle_arcade_entry 100, AZUMARILL, HARD_STONE
	battle_arcade_moves WATERFALL, PLAY_ROUGH, ROLLOUT, DEFENSE_CURL

	battle_arcade_entry 60, NUMEL, LEFTOVERS, 3, 3, 2, 3
	battle_arcade_moves EARTHQUAKE, FIRE_BLAST, AMNESIA, DOUBLE_TEAM

	battle_arcade_entry 100, CAMERUPT, METAL_COAT
	battle_arcade_moves EARTH_POWER, FLAMETHROWER, FLASH_CANNON, LAVA_POOL

	battle_arcade_entry 100, CAMERUPT, LEFTOVERS, 3, 3, 2, 3
	battle_arcade_moves DIG, BOIL, ROCK_SLIDE, CURSE

	battle_arcade_entry 60, WAILMER, LEFTOVERS
	battle_arcade_moves WATERFALL, ZEN_HEADBUTT, CURSE, SELFDESTRUCT

	battle_arcade_entry 100, WAILORD, LUM_BERRY, 3, 3, 2, 3
	battle_arcade_moves SURF, ZEN_HEADBUTT, IRON_HEAD, LEWISITE

	battle_arcade_entry 100, WAILORD, MEGAPHONE, 3, 3, 2, 3
	battle_arcade_moves HYDRO_PUMP, HYPER_VOICE, ICE_BEAM, AMNESIA

	battle_arcade_entry 40, SURSKIT, FOCUS_BAND
	battle_arcade_moves HYDRO_PUMP, SIGNAL_BEAM, ICE_BEAM, RAIN_DANCE

	battle_arcade_entry 100, MASQUERAIN, MYSTIC_WATER
	battle_arcade_moves BUG_BUZZ, AIR_SLASH, ENERGY_BALL, BUBBLEBEAM

	battle_arcade_entry 60, SHROOMISH, LEFTOVERS, 3, 3, 2, 3
	battle_arcade_moves SEED_BOMB, SWORDS_DANCE, LEECH_SEED, SLEEP_POWDER

	battle_arcade_entry 100, BRELOOM, MIRACLE_SEED
	battle_arcade_moves ENERGY_BALL, DRAIN_PUNCH, THUNDERPUNCH, FINAL_CHANCE

	battle_arcade_entry 60, YANMA, SHARP_BEAK
	battle_arcade_moves BUG_BUZZ, AIR_SLASH, SHADOW_BALL, GIGA_DRAIN

	battle_arcade_entry 100, YANMEGA, SILVERPOWDER, 3, 3, 2, 3
	battle_arcade_moves BUG_BUZZ, HYPNOSIS, WHIRLWIND, STRING_SHOT

	battle_arcade_entry 100, ESPEON, SILVERPOWDER, 3, 3, 2, 3
	battle_arcade_moves PSYCHIC_M, SIGNAL_BEAM, MUD_SLAP, MORNING_SUN

	battle_arcade_entry 100, UMBREON, LEFTOVERS
	battle_arcade_moves FEINT_ATTACK, IRON_TAIL, SCREECH, SAND_ATTACK

	battle_arcade_entry 100, GLACEON, SOFT_SAND
	battle_arcade_moves BLIZZARD, DIG, BARRIER, HAIL

	battle_arcade_entry 100, SLOWKING, HARD_STONE, 3, 3, 2, 3
	battle_arcade_moves PSYCHIC_M, SURF, POWER_GEM, NASTY_PLOT

	battle_arcade_entry 60, MISDREAVUS, FOCUS_BAND
	battle_arcade_moves SHADOW_BALL, PAIN_SPLIT, MEAN_LOOK, PERISH_SONG

	battle_arcade_entry 100, MISMAGIUS, ORAN_BERRY
	battle_arcade_moves SHADOW_BALL, VOID_SPHERE, ENERGY_BALL, PAIN_SPLIT

	battle_arcade_entry 40, SWABLU, FOCUS_BAND
	battle_arcade_moves FLY, MOONBLAST, TOXIC, PROTECT

	battle_arcade_entry 100, ALTARIA, PINK_BOW
	battle_arcade_moves DRAGON_PULSE, HYPER_VOICE, MOONBLAST, HEAL_BELL

	battle_arcade_entry 100, ALTARIA, METAL_COAT
	battle_arcade_moves OUTRAGE, SKY_ATTACK, IRON_TAIL, DRAGON_DANCE

	battle_arcade_entry 40, PINECO, POLKADOT_BOW
	battle_arcade_moves EXPLOSION, PAIN_SPLIT, STRING_SHOT, SPIKES

	battle_arcade_entry 100, FORRETRESS, SILVERPOWDER
	battle_arcade_moves IRON_HEAD, PIN_MISSILE, ZAP_CANNON, SPIKES

	battle_arcade_entry 100, RHYPERIOR, MAGNET, 3, 3, 2, 3
	battle_arcade_moves DIG, THUNDER_FANG, SWORDS_DANCE, COUNTER

	battle_arcade_entry 75, GLIGAR, LEFTOVERS, 3, 3, 2, 3
	battle_arcade_moves DIG, TOXIC, SAND_ATTACK, SANDSTORM

	battle_arcade_entry 100, STEELIX, DRAGON_FANG
	battle_arcade_moves FLASH_CANNON, DRAGON_PULSE, ANCIENTPOWER, METALLURGY

	battle_arcade_entry 100, STEELIX, BLACKGLASSES, 3, 3, 2, 3
	battle_arcade_moves IRON_TAIL, DIG, CRUNCH, CURSE

	battle_arcade_entry 100, GLISCOR, SHARP_BEAK
	battle_arcade_moves EARTHQUAKE, WING_ATTACK, THUNDER_FANG, LEER

	battle_arcade_entry 25, FEEBAS, FOCUS_BAND
	battle_arcade_moves WATERFALL, IRON_TAIL, CONFUSE_RAY, HYPNOSIS

	battle_arcade_entry 100, MILOTIC, POLKADOT_BOW
	battle_arcade_moves WATERFALL, BODY_SLAM, ATTRACT, RECOVER

	battle_arcade_entry 50, MILOTIC, BERRY_JUICE, 3, 3, 2, 3
	battle_arcade_moves HYDRO_PUMP, ICE_BEAM, DRAGON_PULSE, SAFEGUARD

	battle_arcade_entry 100, SCIZOR, SCOPE_LENS
	battle_arcade_moves X_SCISSOR, STEEL_WING, NIGHT_SLASH, FOCUS_ENERGY

	battle_arcade_entry 100, SCIZOR, METAL_COAT, 3, 3, 2, 3
	battle_arcade_moves BULLET_PUNCH, FURY_CUTTER, PURSUIT, SWORDS_DANCE

	battle_arcade_entry 50, LUCARIO, METAL_COAT
	battle_arcade_moves DRAIN_PUNCH, BULLET_PUNCH, ZEN_HEADBUTT, SWORDS_DANCE

	battle_arcade_entry 50, LUCARIO, BLACKGLASSES, 3, 3, 2, 3
	battle_arcade_moves AURA_SPHERE, FLASH_CANNON, DARK_PULSE, NASTY_PLOT

	battle_arcade_entry 75, SNEASEL, BLACKGLASSES
	battle_arcade_moves ICE_PUNCH, BITE, IRON_TAIL, SWORDS_DANCE

	battle_arcade_entry 40, TEDDIURSA, FOCUS_BAND, 3, 3, 2, 3
	battle_arcade_moves SLASH, CROSS_CHOP, FEINT_ATTACK, PLAY_ROUGH

	battle_arcade_entry 100, URSARING, BLACKBELT
	battle_arcade_moves BODY_SLAM, FIRE_PUNCH, FEINT_ATTACK, SEED_BOMB

	battle_arcade_entry 50, URSARING, BLACKBELT, 3, 3, 2, 3
	battle_arcade_moves DOUBLE_EDGE, NIGHT_SLASH, SLEEP_TALK, REST

	battle_arcade_entry 100, MAGCARGO, HARD_STONE, 3, 3, 2, 3
	battle_arcade_moves EARTH_POWER, FLAMETHROWER, ANCIENTPOWER, LAVA_POOL

	battle_arcade_entry 40, SWINUB, FOCUS_BAND, 3, 3, 2, 3
	battle_arcade_moves BLIZZARD, EARTHQUAKE, TOXIC, HAIL

	battle_arcade_entry 75, PILOSWINE, NEVERMELTICE
	battle_arcade_moves EARTHQUAKE, ICY_WIND, ROCK_SLIDE, MIST

	battle_arcade_entry 75, PILOSWINE, ORAN_BERRY, 3, 3, 2, 3
	battle_arcade_moves BLIZZARD, EARTH_POWER, ANCIENTPOWER, AMNESIA

	battle_arcade_entry 40, GIBLE, FOCUS_BAND
	battle_arcade_moves EARTHQUAKE, OUTRAGE, IRON_TAIL, TOXIC

	battle_arcade_entry 60, GABITE, FOCUS_BAND
	battle_arcade_moves EARTHQUAKE, DRAGON_CLAW, SAND_ATTACK, SANDSTORM

	battle_arcade_entry 100, GARCHOMP, SOFT_SAND
	battle_arcade_moves DRAGON_PULSE, DIG, SLASH, SANDSTORM

	battle_arcade_entry 40, BAGON, FOCUS_BAND
	battle_arcade_moves OUTRAGE, DOUBLE_EDGE, SHADOW_CLAW, SCARY_FACE

	battle_arcade_entry 60, SHELGON, POLKADOT_BOW
	battle_arcade_moves DRAGON_PULSE, HYDRO_PUMP, DOUBLE_EDGE, LAUGHING_GAS

	battle_arcade_entry 75, SALAMENCE, ORAN_BERRY
	battle_arcade_moves DRAGON_CLAW, FLAMETHROWER, ZEN_HEADBUTT, HYPER_VOICE

	battle_arcade_entry 100, HOUNDOOM, MAGNET
	battle_arcade_moves CRUNCH, BOIL, THUNDER_FANG, WILL_O_WISP

	battle_arcade_entry 50, HOUNDOOM, POISON_BARB, 3, 3, 2, 3
	battle_arcade_moves FLAMETHROWER, DARK_PULSE, SLUDGE_BOMB, NASTY_PLOT

	battle_arcade_entry 100, MAMOSWINE, METAL_COAT, 3, 3, 2, 3
	battle_arcade_moves BLIZZARD, DIG, IRON_HEAD, HAIL

	battle_arcade_entry 40, PHANPY, FOCUS_BAND
	battle_arcade_moves EARTHQUAKE, ROCK_SLIDE, BODY_SLAM, PLAY_ROUGH

	battle_arcade_entry 100, DONPHAN, MAGNET
	battle_arcade_moves MAGNITUDE, PLAY_ROUGH, THUNDER_FANG, RAPID_SPIN

	battle_arcade_entry 75, PORYGON2, BERRY_JUICE
	battle_arcade_moves TRI_ATTACK, THUNDERBOLT, ICE_BEAM, CONVERSION2

	battle_arcade_entry 100, PORYGONZ, ORAN_BERRY
	battle_arcade_moves SWIFT, SHADOW_BALL, CONVERSION, DEFENSE_CURL

	battle_arcade_entry 100, PORYGONZ, METAL_COAT, 3, 3, 2, 3
	battle_arcade_moves ZAP_CANNON, IRON_TAIL, DOUBLE_TEAM, MIND_READER

	battle_arcade_entry 100, WEAVILE, SCOPE_LENS
	battle_arcade_moves NIGHT_SLASH, ICE_PUNCH, SLASH, SCREECH

	battle_arcade_entry 100, HITMONTOP, BLACKGLASSES
	battle_arcade_moves HI_JUMP_KICK, PURSUIT, BULLET_PUNCH, RAPID_SPIN

	battle_arcade_entry 100, SYLVEON, LEFTOVERS
	battle_arcade_moves MOONBLAST, NOISE_PULSE, CHARM, PROTECT

	battle_arcade_entry 50, BLISSEY, POLKADOT_BOW
	battle_arcade_moves BODY_SLAM, ROLLOUT, DEFENSE_CURL, SOFTBOILED

	battle_arcade_entry 50, BLISSEY, TWISTEDSPOON, 3, 3, 2, 3
	battle_arcade_moves BLIZZARD, THUNDER, FIRE_BLAST, PSYCHIC_M

	battle_arcade_entry 60, PUPITAR, BLACKGLASSES
	battle_arcade_moves EARTHQUAKE, CRUNCH, IRON_DEFENSE, REST

	battle_arcade_entry 50, TYRANITAR, BLACKGLASSES
	battle_arcade_moves ROCK_SLIDE, BITE, THUNDER_FANG, DRAGON_DANCE

	battle_arcade_entry 100, TYRANITAR, ASPEAR_BERRY
	battle_arcade_moves DARK_PULSE, FLAMETHROWER, ICE_BEAM, THUNDERBOLT


	assert ARCADE_MAX_ENTRY_RANDOM <= $ffff, "Too many battle arcade entries; lower the likelihoods or remove some entries"
