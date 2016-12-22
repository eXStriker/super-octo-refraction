PachisiGameBotan::
	callasm SetBoardIDBotan
	jump PachisiMain

PachisiGameTorenia::
	callasm SetBoardIDTorenia

PachisiMain:
	opentext
	special PlaceMoneyTopRight
	writetext PachisiTextStartText
	yesorno
	iffalse .endPachisi
	checkmoney $0, 2000
	if_equal 2, .notenoughmoney
	takemoney $0, 2000
	waitsfx
	playsound SFX_TRANSACTION
	closetext
	applymovement 0, .playerMoveOutOfWay
	applymovement 2, .guardMoveDown
	applymovement 0, .playerEnterBoard
	applymovement 2, .guardMoveUp
	playmusic MUSIC_MOBILE_ADAPTER
	callasm InitRolls

.pachisiloop
	opentext
	callasm FacePlayerToNextTile
	applymovement 0, wPachisiPath
	callasm CheckRollCount
	if_equal 0, .outofrolls
	if_equal 1, .onlastroll
	writetext PachisiAskRollText
	yesorno
	iffalse .asktoend

.rolldice
	callasm RollDice
	writetext PachisiRolledDiceText
.moveplayer
	waitbutton
	closetext
	applymovement 0, wPachisiPath
	callasm GetPachisiTile
	if_greater_than PACHISI_WARP_BOTAN_SECTION_4, .pachisiloop
	anonjumptable
	dw .pachisiloop
	dw .grassTile
	dw .waterTile
	dw .caveTile
	dw .moneytile
	dw .healTile
	dw .itemTile
	dw .muncherTile
	dw .warpTile1
	dw .warpTile2
	dw .deathTile
	dw .diceTile
	dw .randomTile
	dw .finishTile
	dw .forwardsTile
	dw .backwardsTile
	dw .warpTileItems
	dw .warpTileBotanSection2
	dw .warpTileRandom
	dw .warpTileBotanSection3
	dw .warpTileBotanSection4
	dw .pachisiloop

.warpTileItems
	playsound SFX_WARP_FROM
	applymovement 0, .warpFrom
	special FadeOutPalettes
	warp BOTAN_PACHISI, 38, 2
	playmusic MUSIC_MOBILE_ADAPTER
	playsound SFX_WARP_TO
	applymovement 0, .warpTo
	writebyte $BC
	callasm JumpToSquare
	jump .pachisiloop

.warpTileRandom
	playsound SFX_WARP_FROM
	applymovement 0, .warpFrom
	special FadeOutPalettes
	warp BOTAN_PACHISI, 27, 30
	playsound SFX_WARP_TO
	playmusic MUSIC_MOBILE_ADAPTER
	applymovement 0, .warpTo
	writebyte $93
	callasm JumpToSquare
	jump .pachisiloop

.warpTileBotanSection4
	playsound SFX_WARP_FROM
	applymovement 0, .warpFrom
	special FadeOutPalettes
	warp BOTAN_PACHISI, 10, 30
	playsound SFX_WARP_TO
	playmusic MUSIC_MOBILE_ADAPTER
	applymovement 0, .warpTo
	writebyte $6e
	callasm JumpToSquare
	jump .pachisiloop

.warpTileBotanSection3
	playsound SFX_WARP_FROM
	applymovement 0, .warpFrom
	special FadeOutPalettes
	warp BOTAN_PACHISI, 17, 18
	playsound SFX_WARP_TO
	playmusic MUSIC_MOBILE_ADAPTER
	applymovement 0, .warpTo
	writebyte $4a
	callasm JumpToSquare
	jump .pachisiloop

.warpTileBotanSection2
	playsound SFX_WARP_FROM
	applymovement 0, .warpFrom
	special FadeOutPalettes
	warp BOTAN_PACHISI, 12, 8
	playsound SFX_WARP_TO
	playmusic MUSIC_MOBILE_ADAPTER
	applymovement 0, .warpTo
	writebyte $1c
	callasm JumpToSquare
	jump .pachisiloop

.onlastroll
	opentext
	writetext PachisiAskRollFinalText
	yesorno
	iffalse .asktoend
	jump .rolldice

.outofrolls
	opentext
	writetext PachisiOutOfRollsText
	playwaitsfx SFX_QUIT_SLOTS
	closetext
	jump .loseGame

.moneytile
	opentext
	writetext PachisiMoneyText
	playwaitsfx SFX_TRANSACTION
	waitbutton
	closetext
	jump .pachisiloop

.grassTile
	setlasttalked 255
	writecode 3, BATTLETYPE_TRAP
	callasm PachisiGetGrassPokemon
	startbattle
	dontrestartmapmusic
	reloadmap
	iftrue .loseGame
	playmusic MUSIC_MOBILE_ADAPTER
	jump .pachisiloop

.caveTile
	setlasttalked 255
	writecode 3, BATTLETYPE_TRAP
	callasm PachisiGetCavePokemon
	startbattle
	dontrestartmapmusic
	reloadmap
	iftrue .loseGame
	playmusic MUSIC_MOBILE_ADAPTER
	jump .pachisiloop

.waterTile
	setlasttalked 255
	writecode 3, BATTLETYPE_TRAP
	callasm PachisiGetWaterPokemon
	startbattle
	dontrestartmapmusic
	reloadmap
	iftrue .loseGame
	playmusic MUSIC_MOBILE_ADAPTER
	jump .pachisiloop

.healTile
	special HealParty
	special Special_BattleTowerFade
	playwaitsfx SFX_HEAL_POKEMON
	special FadeInPalettes
	opentext
	writetext HealTileText
	waitbutton
	closetext
	jump .pachisiloop

.itemTile
	callasm GetPachisiItem
	opentext
	verbosegiveitem ITEM_FROM_MEM
	waitbutton
	jump .pachisiloop

.muncherTile
	opentext
	playwaitsfx SFX_BEAT_UP
	writetext PachisiMuncher
	takemoney $0, 500
	waitbutton
	closetext
	jump .pachisiloop

.warpTile1
	playsound SFX_WARP_FROM
	applymovement 0, .warpFrom
	special FadeOutPalettes
	warp TORENIA_PACHISI, 3, 12
	playmusic MUSIC_MOBILE_ADAPTER
	playsound SFX_WARP_TO
	applymovement 0, .warpTo
	callasm JumpToSquare69
	jump .pachisiloop

.warpTile2
	playsound SFX_WARP_FROM
	applymovement 0, .warpFrom
	special FadeOutPalettes
	warp TORENIA_PACHISI, 18, 2
	playmusic MUSIC_MOBILE_ADAPTER
	playsound SFX_WARP_TO
	applymovement 0, .warpTo
	callasm JumpToSquare42
	jump .pachisiloop

.warpFrom
	teleport_from
	step_end

.warpTo
	teleport_to
	step_end

.deathTile
	playmusic MUSIC_NONE
	playwaitsfx SFX_GS_INTRO_CHARIZARD_FIREBALL
	opentext
	writetext PachisiDeathText
	waitbutton
	closetext
	jump .loseGame

.diceTile
	callasm GiveAdditionalRolls
	playwaitsfx SFX_EGG_HATCH
	opentext
	writetext PachisiGetDiceRollsText
	waitbutton
	closetext
	jump .pachisiloop

.randomTile
	random 10
	if_equal PACHISI_GRASS, .grassTile
	if_equal PACHISI_CAVE, .caveTile
	if_equal PACHISI_WATER, .waterTile
	if_equal PACHISI_HEAL, .healTile
	if_equal PACHISI_ITEM, .itemTile
	if_equal PACHISI_MUNCHER, .muncherTile
	if_equal PACHISI_MONEY, .moneytile
	if_equal PACHISI_DEATH - 2, .deathTile
	if_equal PACHISI_DICE - 2, .diceTile
	if_equal PACHISI_FORWARDS - 4, .forwardsTile
	if_equal PACHISI_BACKWARDS - 4, .backwardsTile
	jump .pachisiloop

.forwardsTile
	opentext
	random 6
	callasm ForwardTile
	writetext PachisiMoveForwardText
	jump .moveplayer

.backwardsTile
	opentext
	random 6
	callasm BackwardsTile
	writetext PachisiMoveBackwardsText
	jump .moveplayer

.finishTile
	playwaitsfx SFX_DEX_FANFARE_230_PLUS
	scriptstartasm
	ld hl, wPachisiWinCount
	inc [hl]
	jr nz, .done_increasing_win_count
	inc hl
	inc [hl]
	jr nz, .done_increasing_win_count
	ld a, $ff
	ld [hld], a
	ld [hl], a
.done_increasing_win_count
	scriptstopasm
	callasm GetBoardID
	iftrue .botanWin

	warpfacing 1, TORENIA_PACHISI, $11, $1b
	opentext
	writetext PachisiCongratsText
	waitbutton
	checkevent EVENT_TORENIA_SHINY_BALL
	iftrue .giveBigNugget
	setevent EVENT_TORENIA_SHINY_BALL
.giveShinyBall
	verbosegiveitem SHINY_BALL
	waitbutton
	closetext
	end

.botanWin
	warpfacing 1, BOTAN_PACHISI, 15, 39
	opentext
	writetext PachisiCongratsText
	waitbutton
	checkevent EVENT_BOTAN_SHINY_BALL
	iftrue .giveBigNugget
	setevent EVENT_BOTAN_SHINY_BALL
	jump .giveShinyBall

.endPachisi
	closetext
	end

.giveBigNugget
	verbosegiveitem BIG_NUGGET
	waitbutton
	closetext
	end

.asktoend
	writetext AskLeaveText
	yesorno
	iftrue .loseGame
	jump .pachisiloop
	end

.loseGame
	special HealParty

	callasm GetBoardID
	iftrue .botanLose
	warpfacing 1, TORENIA_PACHISI, $11, $1b
	jumptext LostGameText

.botanLose
	warpfacing 1, BOTAN_PACHISI, 15, 39
	jumptext LostGameText

.notenoughmoney
	jumptext PachisiTextNotEnoughMoney

.playerMoveOutOfWay
	step_left
	turn_head_right
	step_end

.guardMoveDown
	step_down
	step_down
	turn_head_up
	step_end

.playerEnterBoard
	step_right
	step_up
	step_up
	step_end

.guardMoveUp
	step_up
	step_up
	step_end

JumpToSquare:
	ld a, [hScriptVar]
	ld [wPachisiPosition], a
	ret

GetBoardID:
	ld a, [wPachisiBoardID]
	ld [hScriptVar], a
	ret

FacePlayerToNextTile:
	call GetPachisiDirection
	ld a, [wPachisiPosition]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	and $3
	ld hl, wPachisiPath
	ld [hli], a
	ld a, movement_step_end
	ld [hl], a
	ret

ForwardTile:
	ld a, [hScriptVar]
	inc a
	ld [hScriptVar], a
	jp CreatePachisiPath

BackwardsTile:
	ld a, [hScriptVar]
	inc a
	ld [hScriptVar], a

	ld c, a
	push bc

	ld a, [wPachisiPosition]
	dec a

	ld e, a
	ld d, 0
	call GetPachisiDirection
	add hl, de
	ld de, wPachisiPath

.loop
	ld a, [hl]

	cp movement_step_end
	jr z, .endLoop

	bit 0, a
	jr z, .bitOff
	res 0, a
	jr .write

.bitOff
	set 0, a

.write
	ld [de], a
	dec hl
	inc de
	dec c
	jr nz, .loop

.endLoop
	ld a, movement_step_end
	ld [de], a

	pop bc
	ld a, [wPachisiPosition]
	sub c
	ld [wPachisiPosition], a
	ret

GiveAdditionalRolls:
	call Random
	and 3
	inc a
	cp 4
	jr nz, .notfour
	ld a, 2
.notfour
	ld [TempNumber], a
	ld c, a
	ld a, [wPachisiDiceRolls]
	add c
	ld [wPachisiDiceRolls], a
	ret

SetBoardIDBotan:
	ld a, 1
	jr SetBoardID

SetBoardIDTorenia:
	xor a
SetBoardID:
	ld [wPachisiBoardID], a
	ret

CheckRollCount:
	ld a, [wPachisiDiceRolls]
	ld [hScriptVar], a
	ret

JumpToSquare69:
	ld a, 69
	ld [wPachisiPosition], a
	ret

JumpToSquare42:
	ld a, 42
	ld [wPachisiPosition], a
	ret

PachisiGetCavePokemon:
	ld hl, PachisiCavePokemon
	jr PachisiGetPokemon

PachisiGetWaterPokemon:
	ld hl, PachisiWaterPokemon
	jr PachisiGetPokemon

PachisiGetGrassPokemon:
	ld hl, PachisiGrassPokemon

PachisiGetPokemon:
	ld a, (1 << 7) | 1
	ld [wBattleScriptFlags], a
	call Random
	and $f

	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [TempWildMonSpecies], a

	call Random
	and $7
	ld c, 25
	add c
	ld [CurPartyLevel], a
	ret

PachisiGrassPokemon:
	db PIDGEOTTO
	db PARAS
	db VULPIX
	db PARAS
	db GROWLITHE
	db EXEGGCUTE
	db EXEGGCUTE
	db WEEPINBELL
	db WEEPINBELL
	db PIDGEOTTO
	db LUXIO
	db TAILLOW
	db TAILLOW
	db TAILLOW
	db SCYTHER
	db ABSOL

PachisiWaterPokemon:
	db GOLDEEN
	db MAGIKARP
	db SLOWPOKE
	db LOTAD
	db GOLDEEN
	db MAGIKARP
	db SLOWPOKE
	db LOMBRE
	db TENTACOOL
	db TENTACOOL
	db SURSKIT
	db SURSKIT
	db SLOWPOKE
	db MAGIKARP
	db MAGIKARP
	db GYARADOS

PachisiCavePokemon:
	db ZUBAT
	db GEODUDE
	db VULPIX
	db KOFFING
	db ONIX
	db KOFFING
	db VULPIX
	db GEODUDE
	db ZUBAT
	db GEODUDE
	db ZUBAT
	db ZUBAT
	db ONIX
	db RHYHORN
	db RHYHORN
	db TORKOAL

GetPachisiItem:
	ld hl, PachisiItems
	call Random
	and $3f
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [hScriptVar], a
	ret

PachisiItems:
	db POTION
	db POKE_BALL
	db POTION
	db POKE_BALL
	db POTION
	db POKE_BALL
	db POTION
	db POKE_BALL
	db ANTIDOTE
	db BURN_HEAL
	db ICE_HEAL
	db AWAKENING
	db PARLYZ_HEAL
	db FULL_HEAL
	db SUPER_POTION
	db X_ATTACK
	db X_DEFEND ;10
	db X_SPEED
	db X_SPECIAL
	db SUPER_POTION
	db SUPER_POTION
	db CHERI_BERRY
	db ASPEAR_BERRY
	db RAWST_BERRY
	db PERSIM_BERRY ;18
	db CHESTO_BERRY
	db LUM_BERRY
	db LEPPA_BERRY
	db ORAN_BERRY
	db SITRUS_BERRY
	db ULTRA_BALL
	db RARE_CANDY
	db POTION
	db POKE_BALL
	db SUPER_POTION
	db GREAT_BALL
	db SUPER_POTION
	db GREAT_BALL
	db SUPER_POTION
	db GREAT_BALL
	db ANTIDOTE
	db BURN_HEAL
	db ICE_HEAL
	db AWAKENING
	db PARLYZ_HEAL
	db THUNDERSTONE
	db WATER_STONE
	db X_ATTACK
	db X_DEFEND ;30
	db X_SPEED
	db X_SPECIAL
	db GOLD_DUST
	db GOLD_DUST
	db TIMER_BALL
	db DIVE_BALL
	db FAST_BALL
	db FRIEND_BALL ;38
	db QUICK_BALL
	db THUNDERSTONE
	db LEAF_STONE
	db FIRE_STONE
	db MOOMOO_MILK
	db ULTRA_BALL
	db SACRED_ASH

GetPachisiTile:
	ld hl, ToreniaTiles
	ld a, [wPachisiBoardID]
	and a
	jr z, .inTorenia
	ld hl, BotanTiles

.inTorenia
	ld a, [wPachisiPosition]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [hScriptVar], a
	ret

GetPachisiDirection:
	ld hl, ToreniaDirections
	ld a, [wPachisiBoardID]
	and a
	ret z
	ld hl, BotanDirections
	ret

CreatePachisiPath:
	ld c, a

	call GetPachisiDirection
	ld a, [wPachisiPosition]

	ld e, a
	ld d, 0
	add hl, de
	ld b, d
	ld de, wPachisiPath
	push bc
	rst CopyBytes
	ld a, movement_step_end
	ld [de], a

	pop bc
	ld a, [wPachisiPosition]
	add c
	ld [wPachisiPosition], a
	ret

RollDice:
	ld a, 6
	call RandomRange
	inc a

	call CreatePachisiPath

	ld a, c
	ld [hScriptVar], a

	ld hl, wPachisiDiceRolls
	ld a, [hl]
	dec a
	ld [hl], a
	ret

InitRolls:
	ld a, 25
	ld [wPachisiDiceRolls], a

	xor a
	ld [wPachisiPosition], a
	ret

PachisiMoveBackwardsText:
	ctxt "Move @"
	deciram hScriptVar, 1, 3
	ctxt " tiles"
	line "backwards!"
	done

PachisiMoveForwardText:
	ctxt "Move @"
	deciram hScriptVar, 1, 3
	ctxt " tiles"
	line "forward!"
	done

PachisiOutOfRollsText:
	ctxt "You have ran out"
	line "of rolls."

	para "The game is over."
	done

HealTileText:
	ctxt "Your #mon party"
	line "was fully healed!"
	done

LostGameText:
	ctxt "Nice try, come"
	line "back some other"
	cont "time!"
	done

AskLeaveText:
	ctxt "Are you sure you"
	line "want to leave the"
	cont "game?"
	done

PachisiRolledDiceText:
	ctxt "You rolled a @"
	deciram hScriptVar, 1, 3
	ctxt "!"
	done

PachisiAskRollFinalText:
	ctxt "Last roll!"
	line "Roll the dice?"
	done

PachisiAskRollText:
	deciram wPachisiDiceRolls, 1, 2
	ctxt " rolls left."
	line "Roll the dice?"
	done

PachisiTextNotEnoughMoney:
	ctxt "You don't have"
	line "enough money to"
	cont "play."
	done

PachisiTextStartText:
	ctxt "Welcome to the"
	line "Pachisi Board!"

	para "It costs ¥2000"
	line "to play."

	para "Want to give it"
	line "a go?"
	done

PachisiMoneyText:
	ctxt "You found ¥500!"
	done

PachisiMuncher:
	ctxt "The Muncher nipped"
	line "¥500 off of you!"
	done

PachisiDeathText:
	ctxt "Uh oh!"

	para "The game is now"
	line "over."
	done

PachisiGetDiceRollsText:
	ctxt "Gained @"
	deciram TempNumber, 1, 3

	ctxt ""
	line "additional rolls."
	done

PachisiCongratsText:
	ctxt "Congratulations!"

	line "You have won<...>"
	done

ToreniaDirections:
	rept 9
		db movement_big_step_up
	endr
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_down
	rept 4
		db movement_big_step_right
	endr
	rept 7
		db movement_big_step_up
	endr
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_up
	db movement_big_step_up
	db movement_big_step_left
	db movement_big_step_left
	db movement_big_step_left
	db movement_big_step_down
	db movement_big_step_left
	db movement_big_step_left
	db movement_big_step_left
	rept 7
		db movement_big_step_up
	endr
	db movement_big_step_left
	db movement_big_step_left
	db movement_big_step_left
	db movement_big_step_down
	db movement_big_step_down
	db movement_big_step_left
	db movement_big_step_left
	db movement_big_step_left
	db movement_big_step_down
	db movement_big_step_down
	rept 5
		db movement_big_step_left
	endr
	db movement_big_step_down
	db movement_big_step_left
	db movement_big_step_left
	db movement_big_step_left
	db movement_big_step_down
	db movement_big_step_left
	db movement_big_step_left
	db movement_big_step_down
	db movement_big_step_down
	db movement_big_step_left
	db movement_big_step_down
	db movement_big_step_down
	db movement_big_step_right
	rept 4
		db movement_big_step_down
	endr
	db movement_big_step_right
	db movement_big_step_right
	rept 5
		db movement_big_step_down
	endr
	db movement_big_step_left
	db movement_big_step_down
	db movement_big_step_down
	db movement_big_step_right
	db movement_big_step_down
	db movement_big_step_down
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_up
	db movement_big_step_up
	db movement_big_step_up
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_down
	db movement_big_step_down
	db movement_big_step_down
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_right
	rept 5
		db movement_step_end
	endr
	db -1

BotanDirections:
	db movement_big_step_up
	db movement_big_step_up
	db movement_big_step_up
	rept 6
		db movement_big_step_left
	endr
	db movement_big_step_up
	db movement_big_step_up
	db movement_big_step_up
	db movement_big_step_left
	db movement_big_step_up
	db movement_big_step_left
	db movement_big_step_left
	db movement_big_step_up
	db movement_big_step_up
	rept 4
		db movement_big_step_right
	endr
	rept 5
		db movement_step_end
	endr

	rept 4
		db movement_big_step_left
	endr
	db movement_big_step_down
	db movement_big_step_left
	db movement_big_step_left
	rept 5
		db movement_big_step_down
	endr
	rept 6
		db movement_big_step_left
	endr
	rept 5
		db movement_big_step_up
	endr
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_up
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_right
	rept 6
		db movement_big_step_up
	endr
	rept 5
		db movement_big_step_right
	endr
	rept 5
		db movement_step_end
	endr

	rept 4
		db movement_big_step_right
	endr
	db movement_big_step_down
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_up
	db movement_big_step_right
	rept 6
		db movement_big_step_up
	endr
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_down
	rept 7
		db movement_big_step_right
	endr
	db movement_big_step_up
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_down
	db movement_big_step_down
	rept 5
		db movement_step_end
	endr
	db movement_big_step_right
	db movement_big_step_right
	rept 8
		db movement_big_step_down
	endr
	rept 4
		db movement_big_step_left
	endr
	db movement_big_step_up
	rept 6
		db movement_big_step_left
	endr
	rept 8
		db movement_big_step_up
	endr
	rept 4
		db movement_big_step_right
	endr
	rept 5
		db movement_step_end
	endr

	db movement_big_step_up
	db movement_big_step_left
	db movement_big_step_left
	db movement_big_step_up
	db movement_big_step_up
	db movement_big_step_right
	db movement_big_step_up
	db movement_big_step_right
	db movement_big_step_up
	db movement_big_step_up
	rept 5
		db movement_big_step_right
	endr
	db movement_big_step_down
	db movement_big_step_right
	db movement_big_step_right
	db movement_big_step_right
	rept 7
		db movement_big_step_down
	endr
	db movement_big_step_left
	db movement_big_step_down
	db movement_big_step_left
	db movement_big_step_left
	db movement_big_step_left
	rept 5
		db movement_big_step_down
	endr
	rept 5
		db movement_step_end
	endr

	db movement_big_step_up
	rept 13
		db movement_big_step_left
	endr
	db movement_big_step_down
	rept 5
		db movement_step_end
	endr

ToreniaTiles:
	db PACHISI_NOTHING
	db PACHISI_GRASS
	db PACHISI_FORWARDS
	db PACHISI_NOTHING
	db PACHISI_NOTHING
	db PACHISI_NOTHING
	db PACHISI_MONEY
	db PACHISI_CAVE
	db PACHISI_BACKWARDS
	db PACHISI_HEAL
	db PACHISI_GRASS
	db PACHISI_MUNCHER
	db PACHISI_ITEM
	db PACHISI_MUNCHER
	db PACHISI_WATER
	db PACHISI_BACKWARDS
	db PACHISI_FORWARDS
	db PACHISI_NOTHING
	db PACHISI_DEATH
	db PACHISI_WATER
	db PACHISI_DICE
	db PACHISI_MUNCHER
	db PACHISI_GRASS
	db PACHISI_GRASS
	db PACHISI_CAVE
	db PACHISI_HEAL
	db PACHISI_NOTHING
	db PACHISI_NOTHING
	db PACHISI_WATER
	db PACHISI_FORWARDS
	db PACHISI_MUNCHER
	db PACHISI_MONEY
	db PACHISI_WATER
	db PACHISI_MUNCHER
	db PACHISI_DICE
	db PACHISI_NOTHING
	db PACHISI_RANDOM
	db PACHISI_CAVE
	db PACHISI_DEATH
	db PACHISI_WATER
	db PACHISI_ITEM
	db PACHISI_MONEY
	db PACHISI_WARP_TORENIA_1
	db PACHISI_CAVE
	db PACHISI_BACKWARDS
	db PACHISI_NOTHING
	db PACHISI_MUNCHER
	db PACHISI_ITEM
	db PACHISI_DICE
	db PACHISI_CAVE
	db PACHISI_MONEY
	db PACHISI_NOTHING
	db PACHISI_RANDOM
	db PACHISI_WATER
	db PACHISI_FORWARDS
	db PACHISI_HEAL
	db PACHISI_MUNCHER
	db PACHISI_CAVE
	db PACHISI_GRASS
	db PACHISI_ITEM
	db PACHISI_ITEM
	db PACHISI_DEATH
	db PACHISI_MONEY
	db PACHISI_HEAL
	db PACHISI_BACKWARDS
	db PACHISI_GRASS
	db PACHISI_NOTHING
	db PACHISI_GRASS
	db PACHISI_FORWARDS
	db PACHISI_WARP_TORENIA_2
	db PACHISI_MUNCHER
	db PACHISI_NOTHING
	db PACHISI_DICE
	db PACHISI_MONEY
	db PACHISI_GRASS
	db PACHISI_MUNCHER
	db PACHISI_ITEM
	db PACHISI_NOTHING
	db PACHISI_NOTHING
	db PACHISI_NOTHING
	db PACHISI_FORWARDS
	db PACHISI_BACKWARDS
	db PACHISI_MONEY
	db PACHISI_MONEY
	db PACHISI_RANDOM
	db PACHISI_MUNCHER
	db PACHISI_DICE
	db PACHISI_DEATH
	db PACHISI_BACKWARDS
	db PACHISI_DEATH
	db PACHISI_BACKWARDS
	db PACHISI_HEAL
	db PACHISI_GRASS
	db PACHISI_MUNCHER
	db PACHISI_ITEM
	db PACHISI_CAVE
	db PACHISI_RANDOM
	db PACHISI_DEATH
	db PACHISI_DEATH
	db PACHISI_DEATH
	rept 6
		db PACHISI_FINISH
	endr
	db -1

BotanTiles:
	db PACHISI_NOTHING
	db PACHISI_GRASS
	db PACHISI_ITEM
	db PACHISI_MONEY
	db PACHISI_WARP_BOTAN_RANDOM
	db PACHISI_WATER
	db PACHISI_BACKWARDS
	db PACHISI_MUNCHER
	db PACHISI_GRASS
	db PACHISI_MONEY
	db PACHISI_RANDOM
	db PACHISI_CAVE
	db PACHISI_RANDOM
	db PACHISI_MONEY
	db PACHISI_MONEY
	db PACHISI_ITEM
	db PACHISI_DICE
	db PACHISI_GRASS
	db PACHISI_NOTHING
	db PACHISI_GRASS
	db PACHISI_RANDOM
	db PACHISI_NOTHING
	rept 6
		db PACHISI_WARP_BOTAN_SECTION_2
	endr

	db PACHISI_NOTHING
	db PACHISI_HEAL
	db PACHISI_CAVE
	db PACHISI_NOTHING
	db PACHISI_FORWARDS
	db PACHISI_BACKWARDS
	db PACHISI_MUNCHER
	db PACHISI_GRASS
	db PACHISI_GRASS
	db PACHISI_MUNCHER
	db PACHISI_DICE
	db PACHISI_DEATH
	db PACHISI_MONEY
	db PACHISI_WATER
	db PACHISI_BACKWARDS
	db PACHISI_NOTHING
	db PACHISI_RANDOM
	db PACHISI_MONEY
	db PACHISI_DEATH
	db PACHISI_WATER
	db PACHISI_GRASS
	db PACHISI_GRASS
	db PACHISI_ITEM
	db PACHISI_ITEM
	db PACHISI_GRASS
	db PACHISI_NOTHING
	db PACHISI_FORWARDS
	db PACHISI_CAVE
	db PACHISI_FORWARDS
	db PACHISI_WARP_BOTAN_ITEMS
	db PACHISI_FORWARDS
	db PACHISI_NOTHING
	db PACHISI_DICE
	db PACHISI_NOTHING
	db PACHISI_FORWARDS
	db PACHISI_HEAL
	db PACHISI_RANDOM
	db PACHISI_NOTHING
	db PACHISI_DICE
	db PACHISI_ITEM
	rept 6
		db PACHISI_WARP_BOTAN_SECTION_3
	endr

	db PACHISI_NOTHING
	db PACHISI_DICE
	db PACHISI_ITEM
	db PACHISI_WATER
	db PACHISI_GRASS
	db PACHISI_CAVE
	db PACHISI_NOTHING
	db PACHISI_FORWARDS
	db PACHISI_CAVE
	db PACHISI_RANDOM
	db PACHISI_CAVE
	rept 4
		db PACHISI_GRASS
	endr
	db PACHISI_FORWARDS
	db PACHISI_WARP_BOTAN_SECTION_2
	db PACHISI_MUNCHER
	db PACHISI_DEATH
	db PACHISI_DEATH
	db PACHISI_ITEM
	db PACHISI_ITEM
	db PACHISI_DEATH
	db PACHISI_DEATH
	db PACHISI_NOTHING
	db PACHISI_FORWARDS
	db PACHISI_CAVE
	db PACHISI_GRASS
	db PACHISI_MUNCHER
	db PACHISI_ITEM
	rept 6
		db PACHISI_WARP_BOTAN_SECTION_4
	endr
	db PACHISI_NOTHING
	db PACHISI_MONEY
	db PACHISI_ITEM
	db PACHISI_NOTHING
	db PACHISI_BACKWARDS
	db PACHISI_MUNCHER
	db PACHISI_ITEM
	db PACHISI_WATER
	db PACHISI_DEATH
	db PACHISI_HEAL
	db PACHISI_CAVE
	db PACHISI_ITEM
	db PACHISI_DICE
	db PACHISI_MONEY
	db PACHISI_DEATH
	db PACHISI_DEATH
	db PACHISI_WATER
	db PACHISI_MUNCHER
	db PACHISI_GRASS
	db PACHISI_ITEM
	db PACHISI_FORWARDS
	db PACHISI_HEAL
	db PACHISI_MONEY
	db PACHISI_CAVE
	db PACHISI_RANDOM
	db PACHISI_CAVE
	db PACHISI_GRASS
	db PACHISI_GRASS
	db PACHISI_ITEM
	db PACHISI_DEATH
	db PACHISI_DEATH
	db PACHISI_DEATH
	rept 6
		db PACHISI_FINISH
	endr

	rept 35
		db PACHISI_RANDOM
	endr
	rept 6
		db PACHISI_WARP_BOTAN_SECTION_2
	endr

	rept 15
		db PACHISI_ITEM
	endr
	rept 5
		db PACHISI_WARP_BOTAN_SECTION_3
	endr
