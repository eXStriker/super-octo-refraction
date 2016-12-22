LaurelForestPokemonOnly_MapScriptHeader: ;trigger count
	db 0

 ;callback count
	db 1
	dbw MAPCALLBACK_TILES, .LaurelForestPokemonOnlyReloadBlocks

.LaurelForestPokemonOnlyReloadBlocks
	checkevent EVENT_POKEONLY_CHARMANDER_PUSHED_BOULDER_2
	iftrue .TriggerFillPond
	checkevent EVENT_POKEONLY_CHARMANDER_PUSHED_BOULDER_1
	iffalse .end
	changeblock 48, 26, $cf
.end
	return
.TriggerFillPond
	scall TriggerFillPond
	return

TriggerFillPond:
	changeblock 48, 26, $85
	changeblock 46, 26, $5d
	changeblock 44, 26, $5d
	changeblock 44, 28, $5d
	changeblock 46, 28, $5d
	changeblock 46, 30, $5d
	changeblock 44, 30, $5d
	changeblock 44, 30, $5d
	changeblock 42, 30, $5d
	changeblock 40, 30, $5d
	changeblock 38, 30, $5d
	changeblock 36, 30, $5d
	changeblock 34, 26, $5d
	changeblock 36, 26, $5d
	changeblock 38, 26, $5d
	changeblock 40, 26, $5d
	changeblock 34, 28, $5d
	changeblock 36, 28, $5d
	changeblock 38, 28, $5d
	changeblock 40, 28, $5d
	changeblock 40, 32, $5d
	changeblock 42, 32, $5d
	changeblock 44, 32, $5d
	end

LaurelForestPokemonOnlySignpost5:
	opentext
	writetext LaurelForestPokemonOnly_1096e8_Text_108b6d
	waitbutton
	checkpokemontype FIRE
	anonjumptable
	dw .fail
	dw LaurelForestPokemonOnly_1096dd
	dw .cancel
.fail
	jumptext LaurelForestPokemonOnly_1096f6_Text_108b20
.cancel
	closetext
	end

LaurelForestPokemonOnlyNPC1:
	faceplayer
	cry CHARIZARD
	waitsfx
	opentext
	writetext LaurelForestPokemonOnlyNPC1_Text_10aa68
	waitbutton
	takeitem CURO_SHARD, 3
	iffalse LaurelForestPokemonOnly_10ab30
	writetext LaurelForestPokemonOnlyNPC1_Text_10bca0
	waitbutton
	closetext
	playsound SFX_METRONOME
	applymovement 2, LaurelForestPokemonOnlyNPC1_Movement1
	disappear 2
	setevent EVENT_POKEONLY_BRAINWASHED_CHARIZARD
	end

LaurelForestPokemonOnlyNPC1_Movement1:
	return_dig 73
	step_end

LaurelForestPokemonOnlyNPC2:
	faceplayer
	cry CHARMANDER
	waitsfx
	opentext
	checkitem GIANT_ROCK
	iftrue LaurelForestPokemonOnly_10a24e
	jumptext LaurelForestPokemonOnlyNPC2_Text_109c5d

LaurelForestPokemonOnlyNPC3:
	faceplayer
	cry BUTTERFREE
	opentext
	faceplayer
	checkevent EVENT_POKEONLY_FINISHED_CATERPIE_QUEST
	iftrue LaurelForestPokemonOnly_10b791
	checkevent EVENT_POKEONLY_CATERPIE_IN_PARTY
	iftrue LaurelForestPokemonOnly_10b950
	writetext LaurelForestPokemonOnlyNPC3_Text_10b0db
	yesorno
	iffalse LaurelForestPokemonOnly_10b7c8
	writetext LaurelForestPokemonOnlyNPC3_Text_10b154
	waitbutton
	checkcode VAR_PARTYCOUNT
	if_equal 2, LaurelForestPokemonOnly_10b7d4
	writetext LaurelForestPokemonOnlyNPC3_Text_1081b8
	playwaitsfx SFX_CHOOSE_A_CARD
	waitbutton
	givepoke BUTTERFREE, 20, SILK, 1, LaurelForestButterfreeName, LaurelForestOTName
	disappear 4
	setevent EVENT_POKEONLY_MOTHERBUTTERFREE_IN_PARTY
	closetext
	end

LaurelForestPokemonOnlyNPC4:
	faceplayer
	cry METAPOD
	jumptext LaurelForestPokemonOnly_109eb7_Text_10805e

LaurelForestPokemonOnlyNPC6:
	faceplayer
	cry CATERPIE
	checkevent EVENT_POKEONLY_MOTHERBUTTERFREE_IN_PARTY
	iftrue LaurelForestPokemonOnly_10b6e0
	opentext
	writetext LaurelForestPokemonOnlyNPC6_Text_10ac86
	yesorno
	iffalse LaurelForestPokemonOnly_10b7da
	checkcode VAR_PARTYCOUNT
	if_equal 2, LaurelForestPokemonOnly_10b7d4
	writetext LaurelForestPokemonOnlyNPC6_Text_10acf8
	waitbutton
	writetext LaurelForestPokemonOnlyNPC6_Text_10819c
	playwaitsfx SFX_CHOOSE_A_CARD
	givepoke CATERPIE, 4, SILK, 1, LaurelForestCaterpieName, LaurelForestOTName
	setevent EVENT_POKEONLY_CATERPIE_IN_PARTY
	setevent EVENT_POKEONLY_CATERPIE_PICKED_UP
	disappear 6
	closetext
	end

LaurelForestOTName:
	db "Wild@F"
LaurelForestOTNameEnd:

LaurelForestCaterpieName:
	db "Caterpie@"

LaurelForestButterfreeName:
	db "Butterfree@"

LaurelForestPikachuName:
	db "Pikachu@"

LaurelForestPokemonOnly_Item_CuroShard:
	db CURO_SHARD, 1

LaurelForestPikachuDefeated:
	jumptext LaurelForestPikachuDefeatedText

LaurelForestPikachuOver:
	checkevent EVENT_POKEONLY_PIKACHU_MAD
	iftrue LaurelForestOverAngryPikachu
	jumptext LaurelForestPokemonOnly_109030_Text_109197

LaurelForestOverAngryPikachu:
	jumptext LaurelForestPokemonOnly_10900b_Text_108672

LaurelForestPokemonOnlyNPC9:
	faceplayer
	cry PIKACHU

	checkevent EVENT_POKEONLY_FINISHED_PIKACHU_QUEST
	iftrue LaurelForestPikachuOver

	checkevent EVENT_POKEONLY_PIKACHU_MAD
	iftrue LaurelForestPokemonOnly_108ff2

	checkevent EVENT_POKEONLY_PIKACHU_DEFEATED
	iftrue LaurelForestPikachuDefeated

	checkevent EVENT_POKEONLY_PIKACHU_GAVE_OBJECTIVE
	iftrue LaurelForestPokemonOnly_109017

	opentext
	checkpoke PIKACHU
	iftrue LaurelForestPokemonOnly_10906a
	checkpoke RAICHU
	iftrue LaurelForestPikachuMeetAsRaichu
	checkpoke PICHU
	iftrue LaurelForestPikachuMeetAsPichu

	writetext LaurelForestPokemonOnlyNPC9_Text_1082ad
	yesorno
	iffalse LaurelForestPokemonOnly_108fc1
	setevent EVENT_POKEONLY_PIKACHU_GAVE_OBJECTIVE
	jumptext LaurelForestPokemonOnlyNPC9_Text_10830b

LaurelForestPokemonOnlyNPC10:
	faceplayer
	cry BUTTERFREE
	jumptext LaurelForestPokemonOnlyNPC10_Text_1080ca

LaurelForestPokemonOnlyNPC11:
	faceplayer
	opentext
	writetext LaurelForestPokemonOnlyNPC11_Text_108a00
	yesorno
	iffalse LaurelForestPokemonOnly_108987
	closetext
	callasm RemoveSecondPartyMember
	restorecustchar
	restoresecondpokemon
	clearflag ENGINE_POKEMON_MODE
	clearflag ENGINE_USE_TREASURE_BAG
	blackoutmod LAUREL_CITY
	warp LAUREL_FOREST_MAIN, 36, 4
	end

LaurelForestPokemonOnly_Item_GiantRock:
	db GIANT_ROCK, 1

LaurelForestPokemonOnlyNPC13:
	checkflag EVENT_POKEONLY_FIRE_OUT
	iftrue LaurelForestPokemonOnlySignpost5

	opentext
	writetext LaurelForestPokemonOnlyNPC13_Text_108bd1
	yesorno
	iffalse LaurelForestPokemonOnly_108987
	takeitem ORAN_BERRY, 1
	iffalse LaurelForestPokemonOnly_108989
	writetext LaurelForestPokemonOnlyNPC13_Text_1091ef
	giveitem BURNT_BERRY, 1
	closetext
	end

LaurelForestPokemonOnlyNPC14:
	jumptextfaceplayer LaurelForestPokemonOnly_109ec1_Text_10802f

LaurelForestPokemonOnly_10ab30:
	writetext LaurelForestPokemonOnly_10ab30_Text_10aacb
	yesorno
	iftrue LaurelForestPokemonOnly_10ab3a
	closetext
	end

LaurelForestPokemonOnly_10a24e:
	checkevent EVENT_POKEONLY_CHARMANDER_PUSHED_BOULDER_1
	iftrue LaurelForestPokemonOnly_10a262
	writetext LaurelForestPokemonOnly_10a24e_Text_109cf0
	waitbutton
	changeblock $30, $1a, $cf

	setevent EVENT_POKEONLY_CHARMANDER_PUSHED_BOULDER_1
	takeitem GIANT_ROCK, 1
	closetext
	end

LaurelForestPokemonOnly_10b950:
	writetext LaurelForestPokemonOnly_10b950_Text_10ad1d
	giveitem CURO_SHARD, 1
	iffalse LaurelForestPokemonOnly_10b7ce
	closetext
	callasm RemoveSecondPartyMember
	clearevent EVENT_POKEONLY_MOTHERBUTTERFREE_IN_PARTY
	setevent EVENT_POKEONLY_FINISHED_CATERPIE_QUEST
	if_equal METAPOD, .returnAsMetapod
	if_equal BUTTERFREE, .returnAsButterfree
	clearevent EVENT_POKEONLY_CATERPIE_NOT_IN_NEST
	appear 14
	end

.returnAsMetapod
	clearevent EVENT_POKEONLY_METAPOD_NOT_IN_NEST
	appear 5
	end

.returnAsButterfree
	clearevent EVENT_POKEONLY_CHILD_BUTTERFREE_NOT_IN_NEST
	appear 10
	end

RemoveSecondPartyMember:
	ld hl, wPartyMonOT
	ld de, LaurelForestOTName
	ld c, LaurelForestOTNameEnd - LaurelForestOTName
	call StringCmp
	jr nz, .removesecond

	ld hl, wPartyMon2
	ld de, wPartyMon1
	ld bc, PARTYMON_STRUCT_LENGTH
	rst CopyBytes

	ld hl, wPartyMonOT + NAME_LENGTH
	ld de, wPartyMonOT
	ld bc, NAME_LENGTH
	rst CopyBytes

	ld hl, wPartyMonNicknames + PKMN_NAME_LENGTH
	ld de, wPartyMonNicknames
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes

	ld a, [wPartySpecies]
	ld b, a
	ld a, [wPartySpecies + 1]
	ld [wPartySpecies], a
	ld a, b
	jr .done

.removesecond
	ld a, [wPartySpecies + 1]
.done
	ld [hScriptVar], a
	ld a, $ff
	ld [wPartySpecies + 1], a
	ld a, 1
	ld [wPartyCount], a
	ld hl, PartyMon1HP
	ld a, [hli]
	or [hl]
	ret nz
	inc [hl]
	ret

LaurelForestPokemonOnly_10b791:
	jumptext LaurelForestPokemonOnly_10b79c_Text_10adf9

LaurelForestPokemonOnly_10b7c8:
	jumptext LaurelForestPokemonOnly_10b7c8_Text_10b119

LaurelForestPokemonOnly_10b6e0:
	cry BUTTERFREE
	opentext
	writetext LaurelForestPokemonOnly_10b950_Text_10ad1d
	giveitem CURO_SHARD, 1
	iffalse LaurelForestPokemonOnly_10b7ce
	appear 4
	appear 14
	clearevent EVENT_POKEONLY_MOTHERBUTTERFREE_IN_PARTY
	clearevent EVENT_POKEONLY_CATERPIE_NOT_IN_NEST
	setevent EVENT_POKEONLY_CATERPIE_PICKED_UP
	setevent EVENT_POKEONLY_FINISHED_CATERPIE_QUEST
	callasm RemoveSecondPartyMember
	disappear 6
	closetext
	end

LaurelForestPokemonOnly_10b7da:
	jumptext LaurelForestPokemonOnly_10b7da_Text_10accb

LaurelForestPokemonOnly_10b7d4:
	jumptext LaurelForestPokemonOnly_10b7d4_Text_10ac67

LaurelForestPokemonOnly_10bd61:
	jumptext LaurelForestPokemonOnly_10bd61_Text_10bd7c

LaurelForestPokemonOnlyNPC8:
	checkevent EVENT_POKEONLY_PIKACHU_IN_PARTY
	iftrue LaurelForestPokemonOnly_10bacd
	checkevent EVENT_POKEONLY_FRUIT_TREE_DEAD
	iftrue LaurelForestPokemonOnly_10bed4
	opentext
	giveitem ORAN_BERRY, 1
	writetext LaurelForestPokemonOnly_10bac0_Text_10bbd0
	playwaitsfx SFX_ITEM
	setevent EVENT_POKEONLY_FRUIT_TREE_DEAD
	closetext
	end

LaurelForestPokemonOnly_10bed4:
	jumptext LaurelForestPokemonOnly_10bed4_Text_10bc61

LaurelForestPokemonOnly_10906a:
	opentext
	writetext LaurelForestPokemonOnly_108f62_Text_1086d4
	waitbutton

LaurelForestPikachuAskParty:
	writetext LaurelForestPokemonOnly_10906a_Text_108720
	yesorno
	iffalse LaurelForestPokemonOnly_109036
	checkcode VAR_PARTYCOUNT
	if_not_equal 1, LaurelForestPokemonOnly_1090c3
	writetext LaurelForestPokemonOnly_10906a_Text_10877a
	waitbutton
	writetext LaurelForestPokemonOnly_10906a_Text_1081d6
	playwaitsfx SFX_CHOOSE_A_CARD
	waitbutton
	givepoke PIKACHU, 20, SILK, 1, LaurelForestPikachuName, LaurelForestOTName
	setevent EVENT_POKEONLY_PIKACHU_IN_PARTY
	disappear 9
	closetext
	end

LaurelForestPikachuMeetAsPichu:
	writetext LaurelForestPokemonOnly_10906a_Text_108701
	waitbutton
	jump LaurelForestPikachuAskParty

LaurelForestPikachuMeetAsRaichu:
	writetext LaurelForestPokemonOnly_108f68_Text_1086eb
	waitbutton
	jump LaurelForestPikachuAskParty

LaurelForestPokemonOnly_109030:
	jumptext LaurelForestPokemonOnly_109030_Text_109197

LaurelForestPokemonOnly_109017:
	takeitem BURNT_BERRY, 1
	iffalse LaurelForestPokemonOnly_10902a
	opentext
	writetext LaurelForestPokemonOnly_109017_Text_109162
	waitbutton
	giveitem CURO_SHARD, 1
	setflag EVENT_POKEONLY_FINISHED_PIKACHU_QUEST
	closetext
	end

LaurelForestPokemonOnly_10900b:
	jumptext LaurelForestPokemonOnly_10900b_Text_108672

LaurelForestPokemonOnly_108ff2:
	takeitem BURNT_BERRY, 2
	iffalse LaurelForestPokemonOnly_109005
	writetext LaurelForestPokemonOnly_108ff2_Text_10862f
	playwaitsfx SFX_ITEM
	waitbutton
	giveitem CURO_SHARD, 1
	setevent EVENT_POKEONLY_FINISHED_PIKACHU_QUEST
	closetext
	end

LaurelForestPokemonOnly_108fe0:
	jumptext LaurelForestPokemonOnly_108fe0_Text_10854a

LaurelForestPokemonOnly_108fc1:
	writetext LaurelForestPokemonOnly_108fc1_Text_108368
	waitbutton
	writecode VAR_BATTLETYPE, BATTLETYPE_TRAP
	loadwildmon PIKACHU, 22, LIGHT_BALL, SURF, THUNDERBOLT, DOUBLE_TEAM, SIGNAL_BEAM
	startbattle
	reloadmapafterbattle
	opentext
	iftrue LaurelForestPokemonOnly_108fe6
	setevent EVENT_POKEONLY_PIKACHU_DEFEATED
	writetext LaurelForestPokemonOnly_108fc1_Text_108394
	giveitem CURO_SHARD, 1
	playwaitsfx SFX_ITEM
	closetext
	end

LaurelForestPokemonOnly_108987:
	closetext
	end

LaurelForestPokemonOnly_108989:
	jumptext LaurelForestPokemonOnly_108989_Text_1091d0

LaurelForestPokemonOnly_10ab3a:
	writecode VAR_BATTLETYPE, BATTLETYPE_TRAP
	loadwildmon CHARIZARD, 65
	startbattle
	iffalse LaurelForestPokemonOnly_10ab51
	dontrestartmapmusic
	reloadmap
	warp LAUREL_FOREST_POKEMON_ONLY, 3, 56
	special HealParty
	closetext
	end

LaurelForestPokemonOnly_10a262:
	writetext LaurelForestPokemonOnly_10a262_Text_109ee1
	waitbutton
	changeblock 48, 26, $85
	playsound SFX_STRENGTH
	reloadmappart
	pause 64
	changeblock 46, 26, $5d
	playsound SFX_WHIRLWIND
	reloadmappart
	pause 16
	changeblock 44, 26, $5d
	reloadmappart
	pause 16
	changeblock 44, 28, $5d
	playsound SFX_WHIRLWIND
	reloadmappart
	pause 16
	changeblock 46, 28, $5d
	reloadmappart
	pause 16
	changeblock 46, 30, $5d
	playsound SFX_WHIRLWIND
	reloadmappart
	pause 16
	scall TriggerFillPond
	reloadmappart
	setevent EVENT_POKEONLY_CHARMANDER_PUSHED_BOULDER_2
	clearevent EVENT_POKEONLY_CHARMANDER_TRAPPED
	closetext
	opentext
	takeitem GIANT_ROCK, 1
	writetext LaurelForestPokemonOnly_10a294_Text_109f21
	waitbutton
	closetext
	checkcode VAR_FACING
	if_equal 3, LaurelForestPokemonOnly_10a280
	applymovement 3, LaurelForestPokemonOnly_10a271_Movement1
	disappear 3

	end

LaurelForestPokemonOnly_10b7ce:
	jumptext LaurelForestPokemonOnly_10b7ce_Text_108f30

LaurelForestPokemonOnly_109036:
	jumptext LaurelForestPokemonOnly_109036_Text_108750

LaurelForestPokemonOnly_1090c3:
	jumptext LaurelForestPokemonOnly_10b7d4_Text_10ac67

LaurelForestPokemonOnly_10902a:
	jumptext LaurelForestPokemonOnly_10902a_Text_10911f

LaurelForestPokemonOnly_109005:
	jumptext LaurelForestPokemonOnly_109005_Text_108606

LaurelForestPokemonOnly_108fe6:
	setevent EVENT_POKEONLY_PIKACHU_MAD
	special PokemonCenterPC
	jumptext LaurelForestPokemonOnly_108fe6_Text_1085b4

LaurelForestPokemonOnly_1096dd:
	appear 13
	clearevent EVENT_POKEONLY_FIRE_OUT
	jumptext LaurelForestPokemonOnly_1096da_Text_108b85

LaurelForestPokemonOnly_10ab51:
	dontrestartmapmusic
	reloadmap
	disappear 2
	setevent EVENT_POKEONLY_BRAINWASHED_CHARIZARD
	closetext
	playmapmusic
	end

LaurelForestPokemonOnly_10bacd:
	opentext
	writetext LaurelForestPokemonOnly_10bacd_Text_109b8b
	waitbutton
	giveitem CURO_SHARD, 1
	playwaitsfx SFX_ITEM
	setevent EVENT_POKEONLY_FINISHED_PIKACHU_QUEST
	clearevent EVENT_POKEONLY_PIKACHU_IN_PARTY
	appear 9
	callasm RemoveSecondPartyMember
	closetext
	end

LaurelForestPokemonOnly_10a271_Movement1:
	step_left
	step_left
	step_left
	step_up
	step_up
	step_up
	step_right
	step_up
	step_up
	step_end

LaurelForestPokemonOnly_10a280:
	applymovement 3, LaurelForestPokemonOnly_10a280_Movement1
	disappear 3
	closetext
	end

LaurelForestPokemonOnly_10a280_Movement1:
	step_down
	step_left
	step_left
	step_up
	step_left
	step_up
	step_up
	step_up
	step_up
	step_up
	step_end

LaurelForestPokemonOnly_10a280_Movement2:
	step_left
	step_up
	step_up
	step_up
	step_right
	step_up
	step_up
	step_end

LaurelForestPokemonOnlyNPC1_Text_10aa68:
	ctxt "<...>"

	para "Snarl<...>"

	para "Looks like it's not"
	line "in its right mind<...>"

	para "I wonder what"
	line "happened to it?"
	done

LaurelForestPokemonOnlyNPC1_Text_10bca0:
	ctxt "You placed three"
	line "Curo Shards on"
	cont "Charizard's head."

	para "Gruhh<...> What?"

	para "Where am I?"

	para "Who are you?"

	para "Was I standing"
	line "around all day?"

	para "That's just plain"
	line "unacceptable!"

	para "I have so many"
	line "things to do!"
	done

LaurelForestPokemonOnlyNPC2_Text_109c5d:
	ctxt "Help!"

	para "Some very mean"
	line "scientists dug"
	cont "for fossils here,"

	para "and it's blocked"
	line "me off from my"
	cont "own house!"

	para "There has to be"
	line "some way to get"
	para "the water out of"
	line "the way<...>?"
	done

LaurelForestPokemonOnlyNPC3_Text_10b0db:
	ctxt "Oh no!"

	para "Where in the world"
	line "did my baby go?"

	para "Please help me"
	line "find it, please!"
	done

LaurelForestPokemonOnlyNPC3_Text_10b154:
	ctxt "Oh, thank you."

	para "Let's look for it!"
	done

LaurelForestPokemonOnlyNPC3_Text_1081b8:
	ctxt "Butterfree joined"
	line "the party!"
	done

LaurelForestPokemonOnlyNPC6_Text_10ac86:
	ctxt "Help!"

	para "I can't find my"
	line "mommy anywhere!"

	para "Can you please"
	line "help me out with"
	cont "finding my mommy?"
	done

LaurelForestPokemonOnlyNPC6_Text_10acf8:
	ctxt "Oh, thank you!"

	para "Please find my"
	line "mommy for me!"
	done

LaurelForestPokemonOnlyNPC6_Text_10819c:
	ctxt "Caterpie joined"
	line "the party!"
	done

LaurelForestPokemonOnlyNPC9_Text_1082ad:
	ctxt "Oh, hello there!"

	para "Uh<...>"

	para "It seems like I'm"
	line "pretty hungry!"

	para "Will you go and"
	line "get me something"
	cont "tasty to eat?"

	para "Also, I only eat"
	line "Burnt Berries."
	done

LaurelForestPokemonOnlyNPC9_Text_10830b:
	ctxt "Wonderful!"

	para "I can't wait to"
	line "eat, eat, eat!"
	done

LaurelForestPokemonOnlyNPC10_Text_1080ca:
	ctxt "Whee!"

	para "I love these"
	line "beautiful wings!"

	para "I can fly around"
	line "just like mommy!"
	done

LaurelForestPokemonOnlyNPC11_Text_108a00:
	ctxt "Want to leave?"
	done

LaurelForestPokemonOnlyNPC13_Text_108bd1:
	ctxt "Use Oran Berry"
	line "here?"
	done

LaurelForestPokemonOnlyNPC13_Text_1091ef:
	ctxt "The Oran Berry was"
	line "burned!"
	prompt

LaurelForestPokemonOnly_10ab30_Text_10aacb:
	ctxt "Do you want to"
	line "fight this"
	cont "Charizard?"
	done

LaurelForestPokemonOnly_10a24e_Text_109cf0:
	ctxt "Large rock?"

	para "That might work!"

	para "Push it over!"
	done

LaurelForestPokemonOnly_10b950_Text_10ad1d:
	ctxt "Oh!"

	para "Thank you for"
	line "finding my baby!"

	para "I was so worried."

	para "Here is a Curo"
	line "Shard!"
	prompt

LaurelForestPokemonOnly_10b7c8_Text_10b119:
	ctxt "No?"

	para "But anything could"
	line "be happening to"
	cont "my baby right now!"
	done

LaurelForestPokemonOnly_109eb7_Text_10805e:
	ctxt "I feel this hard"
	line "shell suits me"
	cont "better anyway!"

	para "That was one great"
	line "adventure, and"
	cont "it sure made me"
	cont "stronger!"
	done

LaurelForestPokemonOnly_109ec1_Text_10802f:
	ctxt "I hope one day"
	line "I can become as"
	cont "strong as you."
	done

LaurelForestPokemonOnly_10b7da_Text_10accb:
	ctxt "No? But I'm lost!"

	para "Please don't leave"
	line "me here alone!"
	done

LaurelForestPokemonOnly_10b7d4_Text_10ac67:
	ctxt "Make more room in"
	line "your party!"
	done

LaurelForestPokemonOnly_10bd61_Text_10bd7c:
	ctxt "Free some space!"
	done

LaurelForestPokemonOnly_10bed4_Text_10bc61:
	ctxt "This tree won't"
	line "grow any more"
	cont "Berries<...>"
	done

LaurelForestPokemonOnly_10906a_Text_108701:
	ctxt "Oh, how cute,"
	line "a little Pichu!"
	done

LaurelForestPokemonOnly_10906a_Text_108720:
	ctxt "How would you"
	line "like to go on"
	cont "adventure with me?"
	done

LaurelForestPokemonOnly_10906a_Text_10877a:
	ctxt "Great!"

	para "Let's find some"
	line "tasty Berries!"
	done

LaurelForestPokemonOnly_10906a_Text_1081d6:
	ctxt "Pikachu joined"
	line "the party!"
	done

LaurelForestPokemonOnly_109030_Text_109197:
	ctxt "I'm full for now!"
	done

LaurelForestPikachuDefeatedText:
	ctxt "Please, let me be."
	done

LaurelForestPokemonOnly_109017_Text_109162:
	ctxt "Thank you for the"
	line "Burnt Berry!"

	para "As thanks, here's"
	line "a Curo Shard."
	done

LaurelForestPokemonOnly_10900b_Text_108672:
	ctxt "<...>Uhm, what are you"
	line "still doing here?"
	done

LaurelForestPokemonOnly_108ff2_Text_10862f:
	ctxt "Finally!"

	para "I'll let you go"
	line "for now, and take"
	para "take this junk I"
	line "found earlier."

	para "Pikachu willfully"
	line "handed over the"
	cont "Curo Shard!"
	done

LaurelForestPokemonOnly_108fe0_Text_10854a:
	ctxt "Please, let me be!"
	done

LaurelForestPokemonOnly_108fc1_Text_108368:
	ctxt "Ok, that's it!"

	para "You wanna fight?"

	para "We'll fight!"
	done

LaurelForestPokemonOnly_108fc1_Text_108394:
	ctxt "Ok ok ok, sorry!"

	para "You don't have to"
	line "get me anything<...>"

	para "For going easy on"
	line "me, here's a Curo"
	cont "Shard."
	done

LaurelForestPokemonOnly_108989_Text_1091d0:
	ctxt "You don't have an"
	line "Oran Berry."
	done

LaurelForestPokemonOnly_1096e8_Text_108b6d:
	ctxt "Want to start a"
	line "fire here?"
	done

LaurelForestPokemonOnly_1096f6_Text_108b20:
	ctxt "It's a highly"
	line "flammable stump."
	done

LaurelForestPokemonOnly_1096da_Text_108b85:
	ctxt "You started a"
	line "scorching fire!"
	done

LaurelForestPokemonOnly_109ac0_Text_108bbc:
	ctxt "Use the item"
	line "Soft Sand here?"
	done

LaurelForestPokemonOnly_10a262_Text_109ee1:
	ctxt "Another rock!"

	para "Let's see if this"
	line "will work<...>"
	done

LaurelForestPokemonOnly_10b7ce_Text_108f30:
	ctxt "You have no room"
	line "for this item."

	para "Come back later."
	done

LaurelForestPokemonOnly_10b79c_Text_10adf9:
	ctxt "I always worry"
	line "about my baby."

	para "I don't know what"
	line "I would do if"
	cont "something awful"
	cont "happened to it."
	done

LaurelForestPokemonOnly_10bac0_Text_10bbd0:
	ctxt "This tree appears"
	line "damaged<...>"

	para "There's one Oran"
	line "Berry left, might"
	cont "as well pick it!"

	para "You picked the"
	line "Berry."
	done

LaurelForestPokemonOnly_108f62_Text_1086d4:
	ctxt "Wow, another"
	line "Pikachu!"
	done

LaurelForestPokemonOnly_108f68_Text_1086eb:
	ctxt "Wow, a Raichu!"
	line "That's so cool!"
	done

LaurelForestPokemonOnly_109036_Text_108750:
	ctxt "Aww, I was really"
	line "looking forward"
	cont "to it!"
	done

LaurelForestPokemonOnly_10902a_Text_10911f:
	ctxt "Where is the"
	line "Burnt Berry?"

	para "I can't see it."
	done

LaurelForestPokemonOnly_109005_Text_108606:
	ctxt "Hey, don't come"
	line "back without"
	para "the two Burnt"
	line "Berries!"
	done

LaurelForestPokemonOnly_108fe6_Text_1085b4:
	ctxt "YEAH!"

	para "If you don't want"
	line "to get hurt, you"
	cont "better deliver two"
	cont "Burnt Berries<...>"

	para "<...>or else!"
	done

LaurelForestPokemonOnly_10bacd_Text_109b8b:
	ctxt "Forget the Berries,"
	line "look at that root!"

	para "Let me gnaw on it"
	line "for a few seconds."

	para "<...>gnaw<...>"

	para "<...>gnaw<...>"

	para "<...>gnaw<...>"

	para "OK<...> I'm good."

	para "Thanks for taking"
	line "me here, I'm"
	para "afraid to leave"
	line "my beach alone."

	para "Here's a Curo Shard."
	done

LaurelForestPokemonOnly_10a294_Text_109f21:
	ctxt "Uh wow, how did"
	line "the water vanish"
	cont "that fast?"

	para "No matter, I'm"
	line "coming back home,"
	cont "mom and dad!"
	done

LaurelForestPokemonOnly_MapEventHeader ;filler
	db 0, 0

;warps
	db 6
	warp_def $36, $0, 1, CAPER_CITY
	warp_def $37, $0, 1, CAPER_CITY
	warp_def $5, $37, 1, LAUREL_FOREST_LAB
	warp_def $15, $30, 1, LAUREL_FOREST_CHARIZARD_CAVE
	warp_def $38, $25, 1, LAUREL_FOREST_BEACH
	warp_def $39, $25, 2, LAUREL_FOREST_BEACH

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 16, 27, SIGNPOST_READ, LaurelForestPokemonOnlySignpost5

	;people-events
	db 13
	person_event SPRITE_DRAGON, 10, 50, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, LaurelForestPokemonOnlyNPC1, EVENT_POKEONLY_BRAINWASHED_CHARIZARD
	person_event SPRITE_CHARMANDER, 28, 50, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, LaurelForestPokemonOnlyNPC2, EVENT_POKEONLY_CHARMANDER_PUSHED_BOULDER_2
	person_event SPRITE_BUTTERFREE, 30, 12, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, LaurelForestPokemonOnlyNPC3, EVENT_POKEONLY_MOTHERBUTTERFREE_IN_PARTY
	person_event SPRITE_METAPOD, 31, 14, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, LaurelForestPokemonOnlyNPC4, EVENT_POKEONLY_METAPOD_NOT_IN_NEST
	person_event SPRITE_CATERPIE, 52, 34, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, LaurelForestPokemonOnlyNPC6, EVENT_POKEONLY_CATERPIE_PICKED_UP
	person_event SPRITE_POKE_BALL, 15, 4, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 1, 0, LaurelForestPokemonOnly_Item_CuroShard, EVENT_LAUREL_POKEMONONLY_CUROSHARD
	person_event SPRITE_FRUIT_TREE, 57, 22, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, LaurelForestPokemonOnlyNPC8, -1
	person_event SPRITE_PIKACHU, 51, 47, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, LaurelForestPokemonOnlyNPC9, EVENT_POKEONLY_PIKACHU_IN_PARTY
	person_event SPRITE_BUTTERFREE, 32, 14, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, LaurelForestPokemonOnlyNPC10, EVENT_POKEONLY_CHILD_BUTTERFREE_NOT_IN_NEST
	person_event SPRITE_FAIRY, 56, 2, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, 0, 0, LaurelForestPokemonOnlyNPC11, -1
	person_event SPRITE_POKE_BALL, 24, 12, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 1, 0, LaurelForestPokemonOnly_Item_GiantRock, EVENT_LAUREL_POKEMONONLY_BOULDER_1
	person_event SPRITE_FIRE, 16, 27, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, 0, 0, 0, LaurelForestPokemonOnlyNPC13, EVENT_POKEONLY_FIRE_OUT
	person_event SPRITE_CATERPIE, 30, 14, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, LaurelForestPokemonOnlyNPC14, EVENT_POKEONLY_CATERPIE_NOT_IN_NEST
