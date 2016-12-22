Mining:
	checkflag ENGINE_POKEMON_MODE
	iftrue .skip
	opentext ;Check mining pick
	checkitem MINING_PICK
	sif false, then
		playsound SFX_READ_TEXT_2
		jumptext NoMiningPickText
	sendif
	;We have mining pick
	playwaitsfx SFX_BEAT_UP
	takeitem MINING_PICK, 1
	callasm ExtractItem
	sif false
		jumptext NoItemExtracted
	if_equal FOSSIL, .fossil
	verbosegiveitem SPECIAL_ITEM, 1
	iffalse .noroom
	waitbutton
.giveexp
	giveminingEXP
	closetext
.skip
	end

.fossil
	givefossil
	waitbutton
	if_equal $1, .giveexp
.noroom
	giveitem MINING_PICK, 1
	closetext
	end

ExtractItem:
	ld hl, MiningPickItemTable
	ld a, [MiningLevel]
	sra a
	ld c, a
	ld b, 0
	add hl, bc ;Get base position
.randomItem
	call Random
	cp 100
	jr nc, .randomItem
	ld c, a
	ld b, 0
	add hl, bc ;Get item position
	ld a, [hl]
	cp SPECIAL_ITEM
	jr z, .getItemFromMapGroup
	ld [hScriptVar], a
	ret

.getItemFromMapGroup
	ld a, [MapGroup]
	dec a
	ld c, a
	ld b, 0
	ld hl, SpecialItems
	add hl, bc
	ld a, [hl]
	ld [hScriptVar], a
	ret

NoMiningPickText::
	text "You need a Mining"
	line "Pick to mine."
	done

NoItemExtracted::
	text "Unable to extract"
	line "anything."
	done

MiningPickItemTable: ;Every 2 levels shifts the table up, totaling in 150 items
	rept 29
		db NO_ITEM
	endr
	rept 7
		db GOLD_DUST
	endr
	rept 10
		db HEART_SCALE
	endr
	rept 13
		db COAL
		db ORE
	endr
	db HARD_STONE
	db REVIVE
	db SPECIAL_ITEM
	db SPECIAL_ITEM
	rept 5
		db EVERSTONE
	endr
	db HARD_STONE
	db SPECIAL_ITEM
	db KINGS_ROCK
	db SPECIAL_ITEM
	db REVIVE
	db SPECIAL_ITEM
	rept 2 ; 89
		db COAL
		db ORE
	endr
	rept 4
		db HEART_SCALE
	endr
	db FOSSIL
	db LEAF_STONE
	db FIRE_STONE
	db WATER_STONE
	db THUNDERSTONE
	db SHINY_STONE
	db SUN_STONE
	db DAWN_STONE
	db DUSK_STONE
	rept 8
		db COAL
		db ORE
	endr
	db HARD_STONE
	db CHARCOAL
	db KINGS_ROCK
	db KINGS_ROCK
	db REVIVE
	db REVIVE
	rept 9
		db SPECIAL_ITEM
	endr
	db LIGHT_CLAY
	db REVIVE
	db REVIVE
	db MAX_REVIVE
	db NUGGET
	db NUGGET
	db LEAF_STONE
	db FIRE_STONE
	db WATER_STONE
	db THUNDERSTONE
	db SHINY_STONE
	db SUN_STONE
	db DAWN_STONE
	db DUSK_STONE
	db BIG_NUGGET
	db FOSSIL
	db FOSSIL

SpecialItems: ;Ordered by bank
	db NO_ITEM ;1
	db ICY_ROCK ;2
	db COAL ;3
	db COAL ;4
	db LEAF_STONE ;5
	db WATER_STONE ;6
	db NO_ITEM ;7
	db ORE ;8
	db HARD_STONE ;9
	db ICY_ROCK ;10
	db NO_ITEM ;11
	db ENERGYPOWDER ;12
	db ICY_ROCK ;13
	db ICY_ROCK ;14
	db ICY_ROCK ;15
	db ICY_ROCK ;16
	db DAMP_ROCK ;17
	db NO_ITEM ;18
	db COAL ;19
	db NO_ITEM ;20
	db GOLD_DUST ;21
	db SOFT_SAND ;22
	db SMOOTH_ROCK ;23
	db SOFT_SAND ;24
	db BRICK_PIECE ;25
	db SMOOTH_ROCK ;26
	db DAMP_ROCK ;27
	db ICY_ROCK ;28
	db HEAT_ROCK ;29
	db NO_ITEM ;30
	db WATER_STONE ;31
	db GOLD_DUST ;32
	db ENERGYPOWDER;33
	db SUN_STONE;34
	db FIRE_STONE;35
	db FIRE_STONE;36
	db LIGHT_CLAY;37
	db ICY_ROCK;38
	db COAL;39
	db COAL;40
	db ORE;41
	;Rijon
	db DAMP_ROCK ;42
	db HARD_STONE ;43
	db HARD_STONE ;44
	db EVERSTONE ;45
	db NO_ITEM ;46
	db ENERGYPOWDER ;47
	db ENERGYPOWDER ;48
	db DUSK_STONE ;49
	db NO_ITEM ;50
	db HEAT_ROCK ;51
	db GOLD_DUST ;52
	db NO_ITEM ;53
	db NO_ITEM ;54
	db NO_ITEM ;55
	db NO_ITEM ;56
	db NO_ITEM ;57
	db DAMP_ROCK ;58
	db HARD_STONE ;59
	db HARD_STONE ;60
	db COAL ;61
	db HEAT_ROCK ;62
	db NO_ITEM ;63
	db ORE ;64
	db ENERGYPOWDER ;65
	db NO_ITEM ;66
	db NO_ITEM ;67
	db NO_ITEM ;68
	db COAL ;69
	db HARD_STONE ;70
	db GOLD_DUST ;71
	db DAMP_ROCK ;72
	db GOLD_DUST ;73
	db HARD_STONE ;74
	db ICY_ROCK ;75
	db NO_ITEM ;76
	db LEAF_STONE ;77
	db NO_ITEM ;78
	db MOON_STONE ;79
	db NO_ITEM ;80
	db KINGS_ROCK ;81
	db NO_ITEM ;82
	db NO_ITEM ;83
	db THUNDERSTONE ;84
	db NO_ITEM ;85
	db NO_ITEM ;86
	db NO_ITEM ;87
	db FIRE_STONE ;88
	db DAWN_STONE ;89
	db NO_ITEM ;90
	db NO_ITEM ;91
