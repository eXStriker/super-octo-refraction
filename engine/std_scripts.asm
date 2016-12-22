StdScripts::
	dba PokeCenterNurseScript
	dba DifficultBookshelfScript
	dba PictureBookshelfScript
	dba MagazineBookshelfScript
	dba FastCurrentScript
	dba MerchandiseShelfScript
	dba TownMapScript
	dba MiningScript
	dba JumpingShoesScript
	dba HomepageScript
	dba SmeltingScript
	dba JewelingScript
	dba TrashCanScript
	dba StrengthBoulderScript
	dba SmashRockScript
	dba PokeCenterSignScript
	dba MartSignScript
	dba GoldenrodRocketsScript
	dba RadioTowerRocketsScript
	dba ElevatorButtonScript
	dba DayToTextScript
	dba InitializeEventsScript
	dba GymStatue1Script
	dba GymStatue2Script
	dba ReceiveItemScript
	dba ReceiveTogepiEggScript
	dba PCScript
	dba GameCornerCoinVendorScript
	dba HappinessCheckScript
	dba FieldMovePokepicScript

PokeCenterNurseScript:
; EVENT_WELCOMED_TO_POKECOM_CENTER is never set

	opentext
	checkmorn
	iftrue .morn
	checkday
	iftrue .day
	checknite
	iftrue .nite
	jump .ok

.morn
	farwritetext NurseMornText
	buttonsound
	jump .ok

.day
	farwritetext NurseDayText
	buttonsound
	jump .ok

.nite
	farwritetext NurseNiteText
	buttonsound

.ok
	; only do this once
	farwritetext NurseAskHealText
	yesorno
	iffalse .done

	farwritetext NurseTakePokemonText
	pause 20
	spriteface LAST_TALKED, LEFT
	pause 10
	special HealParty
	writebyte 0 ; Machine is at a Pokemon Center
	special HealMachineAnim
	waitsfx
	spriteface LAST_TALKED, DOWN
	pause 10

	special SpecialCheckPokerus
	iftrue .pokerus
	farwritetext NurseReturnPokemonText
	pause 20
.done
	farwritetext NurseGoodbyeText

	spriteface LAST_TALKED, UP
	pause 10
	spriteface LAST_TALKED, DOWN
	pause 10

	endtext

.pokerus
	; already cleared earlier in the script
	farwritetext NursePokerusText
	waitbutton
	closetext
	setflag ENGINE_POKERUS
	end

DifficultBookshelfScript:
	farjumptext DifficultBookshelfText

PictureBookshelfScript:
	farjumptext PictureBookshelfText

MagazineBookshelfScript:
	farjumptext MagazineBookshelfText

FastCurrentScript:
	farjumptext FastCurrentText

MerchandiseShelfScript:
	farjumptext MerchandiseShelfText

TownMapScript:
	opentext
	farwritetext TownMapText
	waitbutton
	special Special_TownMap
	closetext
	end

JumpingShoesScript:
	checkevent EVENT_JUMPING_SHOES
	iffalse .noshoes
	playsound SFX_JUMP_OVER_LEDGE
	checkcode VAR_FACING
	anonjumptable
	dw .jumpDown
	dw .jumpUp
	dw .jumpLeft
	dw .jumpRight

.jumpDown
	applymovement 0, .jumpDownMove
.noshoes
	end

.jumpUp
	applymovement 0, .jumpUpMove
	end

.jumpLeft
	applymovement 0, .jumpLeftMove
	end

.jumpRight
	applymovement 0, .jumpRightMove
	end

.jumpDownMove:
	jump_step_down
	step_end

.jumpUpMove:
	jump_step_up
	step_end

.jumpLeftMove:
	jump_step_left
	step_end

.jumpRightMove:
	jump_step_right
	step_end

HomepageScript:
	farjumptext HomepageText

TrashCanScript: ; 0xbc1a5
	farjumptext TrashCanText

PCScript:
	opentext
	special PokemonCenterPC
	closetext
	end

ElevatorButtonScript:
	playsound SFX_READ_TEXT_2
	pause 15
	playsound SFX_ELEVATOR_END
	end

StrengthBoulderScript:
	farjump AskStrengthScript

SmashRockScript:
	farjump AskRockSmashScript

PokeCenterSignScript:
	farjumptext PokeCenterSignText

MartSignScript
	farjumptext MartSignText

DayToTextScript:
	checkcode VAR_WEEKDAY
	if_equal MONDAY, .Monday
	if_equal TUESDAY, .Tuesday
	if_equal WEDNESDAY, .Wednesday
	if_equal THURSDAY, .Thursday
	if_equal FRIDAY, .Friday
	if_equal SATURDAY, .Saturday
	stringtotext .SundayText, 0
	end
.Monday
	stringtotext .MondayText, 0
	end
.Tuesday
	stringtotext .TuesdayText, 0
	end
.Wednesday
	stringtotext .WednesdayText, 0
	end
.Thursday
	stringtotext .ThursdayText, 0
	end
.Friday
	stringtotext .FridayText, 0
	end
.Saturday
	stringtotext .SaturdayText, 0
	end
.SundayText
	db "Sunday@"
.MondayText
	db "Monday@"
.TuesdayText
	db "Tuesday@"
.WednesdayText
	db "Wednesday@"
.ThursdayText
	db "Thursday@"
.FridayText
	db "Friday@"
.SaturdayText
	db "Saturday@"

GoldenrodRocketsScript:
RadioTowerRocketsScript:
	end

;PRISM: This needs a couple
InitializeEventsScript:
	wildoff
	setevent EVENT_GOT_POKEDEX
	setevent EVENT_LAUREL_CITY_HIDDEN_TOTODILE
	setevent EVENT_BROOKLYN_NOT_IN_FOREST
	setevent EVENT_AGGRON_NOT_IN_MAGMA
	setevent EVENT_MAGMA_POLICE
	setevent EVENT_NOBU_NOT_IN_HOUSE
	setevent EVENT_SAXIFRAGE_LIGHT_OFF_1
	setevent EVENT_SAXIFRAGE_LIGHT_OFF_2
	setevent EVENT_SAXIFRAGE_LIGHT_OFF_3
	setevent EVENT_BLUE_NOT_ON_FIRST_FLOOR
	setevent EVENT_PHLOX_LAB_OFFICER
	setevent EVENT_INITIALIZED_EVENTS
	setevent EVENT_FAMBACO
	return

GymStatue1Script:
	mapnametotext $0
	opentext
	farwritetext GymStatue_CityGymText
	endtext

GymStatue2Script:
	mapnametotext $0
	opentext
	farwritetext GymStatue_CityGymText
	buttonsound
	farwritetext GymStatue_WinningTrainersText
	endtext

ReceiveItemScript:
	waitsfx
	farwritetext STDReceivedItemText
	playwaitsfx SFX_ITEM
	end

ReceiveTogepiEggScript:
	waitsfx
	farwritetext STDReceivedItemText
	playwaitsfx SFX_GET_EGG_FROM_DAYCARE_LADY
	end

GameCornerCoinVendorScript:
	faceplayer
	opentext
	farwritetext CoinVendor_WelcomeText
	buttonsound
	checkitem COIN_CASE
	iftrue CoinVendor_IntroScript
	farwritetext CoinVendor_NoCoinCaseText
	endtext

CoinVendor_IntroScript:
	farwritetext CoinVendor_IntroText

.loop:
	special Special_DisplayMoneyAndCoinBalance
	loadmenudata .MenuDataHeader
	verticalmenu
	closewindow
	if_equal $1, .Buy50
	if_equal $2, .Buy500
	jump .Cancel

.Buy50
	checkcoins 9949
	if_equal $0, .CoinCaseFull
	checkmoney $0, 1000
	if_equal $2, .NotEnoughMoney
	givecoins 50
	takemoney $0, 1000
	waitsfx
	playsound SFX_TRANSACTION
	farwritetext CoinVendor_Buy50CoinsText
	waitbutton
	jump .loop

.Buy500
	checkcoins 9499
	if_equal $0, .CoinCaseFull
	checkmoney $0, 10000
	if_equal $2, .NotEnoughMoney
	givecoins 500
	takemoney $0, 10000
	waitsfx
	playsound SFX_TRANSACTION
	farwritetext CoinVendor_Buy500CoinsText
	waitbutton
	jump .loop

.NotEnoughMoney
	farwritetext CoinVendor_NotEnoughMoneyText
	endtext

.CoinCaseFull
	farwritetext CoinVendor_CoinCaseFullText
	endtext

.Cancel
	farwritetext CoinVendor_CancelText
	endtext

.MenuDataHeader
	db $40 ; flags
	db 04, 00 ; start coords
	db 11, 15 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2
	db $80 ; flags
	db 3 ; items
	db " 50 :  ¥1000@"
	db "500 : ¥10000@"
	db "CANCEL@"

HappinessCheckScript:
	faceplayer
	opentext
	special GetFirstPokemonHappiness
	if_less_than 50, .Unhappy
	if_less_than 150, .KindaHappy
	farwritetext HappinessText3
	endtext

.KindaHappy
	farwritetext HappinessText2
	endtext

.Unhappy
	farwritetext HappinessText1
	endtext

MiningScript:
	farjump Mining

SmeltingScript:
	farjump Smelting

JewelingScript:
	farjump Jeweling

TalkToTrainerScript::
	faceplayer
	trainerflagaction CHECK_FLAG
	iftrue AlreadyBeatenTrainerScript
	loadmemtrainer
	encountermusic
	jump StartBattleWithMapTrainerScript

SeenByTrainerScript::
	loadmemtrainer
	encountermusic
	showemote EMOTE_SHOCK, LAST_TALKED, 30, 0
	callasm TrainerWalkToPlayer
	applymovement2 MovementBuffer
	writepersonxy LAST_TALKED
	faceperson PLAYER, LAST_TALKED
	; fallthrough

StartBattleWithMapTrainerScript:
	opentext
	trainertext $0
	waitbutton
	closetext
	loadmemtrainer
	startbattle
	reloadmapafterbattle
	trainerflagaction SET_FLAG
	callasm FreezeTrainerFacing
	loadvar wRunningTrainerBattleScript, -1

AlreadyBeatenTrainerScript:
	scripttalkafter
