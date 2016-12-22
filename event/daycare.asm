	const_def
	const DAYCARETEXT_MAN_INTRO
	const DAYCARETEXT_MAN_EGG
	const DAYCARETEXT_LADY_INTRO
	const DAYCARETEXT_LADY_EGG
	const DAYCARETEXT_WHICH_ONE
	const DAYCARETEXT_DEPOSIT
	const DAYCARETEXT_CANT_BREED_EGG
	const DAYCARETEXT_LAST_MON
	const DAYCARETEXT_LAST_ALIVE_MON
	const DAYCARETEXT_COME_BACK_LATER
	const DAYCARETEXT_CANT_ACCEPT_THIS
	const DAYCARETEXT_GENIUSES
	const DAYCARETEXT_ASK_WITHDRAW
	const DAYCARETEXT_WITHDRAW
	const DAYCARETEXT_TOO_SOON
	const DAYCARETEXT_PARTY_FULL
	const DAYCARETEXT_NOT_ENOUGH_MONEY
	const DAYCARETEXT_OH_FINE
	const DAYCARETEXT_COME_AGAIN
	const DAYCARETEXT_13

Special_DayCareMan:
	ld hl, wDaycareMan
	bit 0, [hl]
	jr nz, .AskWithdrawMon
	ld hl, wDaycareMan
	ld a, DAYCARETEXT_MAN_INTRO
	call DayCareManIntroText
	jr c, .cancel
	call DayCareAskDepositPokemon
	jr c, .print_text
	callba DepositMonWithDaycareMan
	ld hl, wDaycareMan
	set 0, [hl]
	call DayCare_DepositPokemonText
	jp DayCare_InitBreeding

.AskWithdrawMon
	callba GetBreedMon1LevelGrowth
	ld hl, wBreedMon1Nick
	call GetPriceToRetrieveBreedmon
	call DayCare_AskWithdrawBreedMon
	jr c, .print_text
	callba RetrievePokemonFromDaycareMan
	call DayCare_TakeMoney_PlayCry
	ld hl, wDaycareMan
	res 0, [hl]
	res 5, [hl]
	jr .cancel

.print_text
	call PrintDayCareText

.cancel
	ld a, DAYCARETEXT_13
	jp PrintDayCareText

Special_DayCareLady:
	ld hl, wDaycareLady
	bit 0, [hl]
	jr nz, .AskWithdrawMon
	ld hl, wDaycareLady
	ld a, DAYCARETEXT_LADY_INTRO
	call DayCareLadyIntroText
	jr c, .cancel
	call DayCareAskDepositPokemon
	jr c, .print_text
	callba DepositMonWithDaycareLady
	ld hl, wDaycareLady
	set 0, [hl]
	call DayCare_DepositPokemonText
	jp DayCare_InitBreeding

.AskWithdrawMon
	callba GetBreedMon2LevelGrowth
	ld hl, wBreedMon2Nick
	call GetPriceToRetrieveBreedmon
	call DayCare_AskWithdrawBreedMon
	jr c, .print_text
	callba RetrievePokemonFromDaycareLady
	call DayCare_TakeMoney_PlayCry
	ld hl, wDaycareLady
	res 0, [hl]
	ld hl, wDaycareMan
	res 5, [hl]
	jr .cancel

.print_text
	call PrintDayCareText

.cancel
	ld a, DAYCARETEXT_13
	jp PrintDayCareText

DayCareLadyIntroText:
	bit 7, [hl]
	jr nz, .okay
	set 7, [hl]
	inc a
.okay
	call PrintDayCareText
	jp YesNoBox

DayCareManIntroText:
	set 7, [hl]
	call PrintDayCareText
	jp YesNoBox

DayCareAskDepositPokemon:
	ld a, [wPartyCount]
	cp 2
	jr c, .OnlyOneMon
	ld a, DAYCARETEXT_WHICH_ONE
	call PrintDayCareText
	ld b, 6
	callba SelectTradeOrDaycareMon
	jr c, .Declined
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .Egg
	callba CheckForSpecialGiftMon
	jr c, .specialGiftMon
	callba CheckIfOnlyAliveMonIsCurPartyMon
	jr c, .OutOfUsableMons
	ld hl, wPartyMonNicknames
	ld a, [wCurPartyMon]
	call GetNick
	and a
	ret

.Declined
	ld a, DAYCARETEXT_COME_AGAIN
	scf
	ret

.Egg
	ld a, DAYCARETEXT_CANT_BREED_EGG
	scf
	ret

.OnlyOneMon
	ld a, DAYCARETEXT_LAST_MON
	scf
	ret

.OutOfUsableMons
	ld a, DAYCARETEXT_LAST_ALIVE_MON
	scf
	ret

.specialGiftMon
	ld a, DAYCARETEXT_CANT_ACCEPT_THIS
	scf
	ret

DayCare_DepositPokemonText:
	ld a, DAYCARETEXT_DEPOSIT
	call PrintDayCareText
	ld a, [wCurPartySpecies]
	call PlayCry
	ld a, DAYCARETEXT_COME_BACK_LATER
	jp PrintDayCareText

DayCare_AskWithdrawBreedMon:
	ld a, [wStringBuffer2 + 1]
	and a
	jr nz, .grew_at_least_one_level
	ld a, DAYCARETEXT_PARTY_FULL
	call PrintDayCareText
	call YesNoBox
	jr c, .refused
	jr .check_money

.grew_at_least_one_level
	ld a, DAYCARETEXT_GENIUSES
	call PrintDayCareText
	call YesNoBox
	jr c, .refused
	ld a, DAYCARETEXT_ASK_WITHDRAW
	call PrintDayCareText
	call YesNoBox
	jr c, .refused

.check_money
	ld de, Money
	ld bc, wStringBuffer2 + 2
	callba CompareMoney
	jr c, .not_enough_money
	ld a, [wPartyCount]
	cp PARTY_LENGTH
	jr nc, .PartyFull
	and a
	ret

.refused
	ld a, DAYCARETEXT_COME_AGAIN
	scf
	ret

.not_enough_money
	ld a, DAYCARETEXT_OH_FINE
	scf
	ret

.PartyFull
	ld a, DAYCARETEXT_NOT_ENOUGH_MONEY
	scf
	ret

DayCare_TakeMoney_PlayCry:
	ld bc, wStringBuffer2 + 2
	ld de, Money
	callba TakeMoney
	ld a, DAYCARETEXT_WITHDRAW
	call PrintDayCareText
	ld a, [wCurPartySpecies]
	call PlayCry
	ld a, DAYCARETEXT_TOO_SOON
	jp PrintDayCareText

GetPriceToRetrieveBreedmon:
	ld a, b
	ld [wStringBuffer2], a
	ld a, d
	ld [wStringBuffer2 + 1], a
	ld de, wStringBuffer1
	ld bc, NAME_LENGTH
	rst CopyBytes
	ld hl, 0
	ld bc, 100
	ld a, [wStringBuffer2 + 1]
	rst AddNTimes
	ld de, 100
	add hl, de
	xor a
	ld [wStringBuffer2 + 2], a
	ld a, h
	ld [wStringBuffer2 + 3], a
	ld a, l
	ld [wStringBuffer2 + 4], a
	ret

PrintDayCareText:
	ld e, a
	ld d, 0
	ld hl, .TextTable
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp PrintText

.TextTable
	dw .DayCareManIntro ; 00
	dw .DayCareManOddEgg ; 01
	dw .DayCareLadyIntro ; 02
	dw .DayCareLadyOddEgg ; 03
	dw .WhichOne ; 04
	dw .OkayIllRaiseYourMon ; 05
	dw .CantAcceptEgg ; 06
	dw .JustOneMon ; 07
	dw .LastHealthyMon ; 08
	dw .ComeBackForItLater ; 09
	dw .CantAcceptThis ; 0a
	dw .AreWeGeniusesOrWhat ; 0b
	dw .AskRetrieveMon ; 0c
	dw .PerfectHeresYourMon ; 0d
	dw .GotBackMon ; 0e
	dw .ImmediatelyWithdrawMon ; 0f
	dw .PartyFull ; 10
	dw .NotEnoughMoney ; 11
	dw .OhFineThen ; 12
	dw .ComeAgain ; 13

.DayCareManIntro
	; I'm the DAY-CARE MAN. Want me to raise a #mon?
	text_jump UnknownText_0x1bdaa9

.DayCareManOddEgg
	; I'm the DAY-CARE MAN. Do you know about EGGS? I was raising #mon with my wife, you see. We were shocked to find an EGG! How incredible is that? So, want me to raise a #mon?
	text_jump UnknownText_0x1bdad8

.DayCareLadyIntro
	; I'm the DAY-CARE LADY. Should I raise a #mon for you?
	text_jump UnknownText_0x1bdb85

.DayCareLadyOddEgg
	; I'm the DAY-CARE LADY. Do you know about EGGS? My husband and I were raising some #mon, you see. We were shocked to find an EGG! How incredible could that be? Should I raise a #mon for you?
	text_jump UnknownText_0x1bdbbb

.WhichOne
	; What should I raise for you?
	text_jump UnknownText_0x1bdc79

.JustOneMon
	; Oh? But you have just one #mon.
	text_jump UnknownText_0x1bdc97

.CantAcceptEgg
	; Sorry, but I can't accept an EGG.
	text_jump UnknownText_0x1bdcb8

.CantAcceptThis
	; Sorry, but I can't accept this #mon.
	text_jump UnknownText_0x1bdcda

.LastHealthyMon
	; If you give me that, what will you battle with?
	text_jump UnknownText_0x1bdcff

.OkayIllRaiseYourMon
	; OK. I'll raise your @ .
	text_jump UnknownText_0x1bdd30

.ComeBackForItLater
	; Come back for it later.
	text_jump UnknownText_0x1bdd4b

.AreWeGeniusesOrWhat
	; Are we geniuses or what? Want to see your @ ?
	text_jump UnknownText_0x1bdd64

.AskRetrieveMon
	; Your @ has grown a lot. By level, it's grown by @ . If you want your #mon back, it will cost ¥@ .
	text_jump UnknownText_0x1bdd96

.PerfectHeresYourMon
	; Perfect! Here's your #mon.
	text_jump UnknownText_0x1bde04

.GotBackMon
	; got back @ .
	text_jump UnknownText_0x1bde1f

.ImmediatelyWithdrawMon
	; Huh? Back already? Your @ needs a little more time with us. If you want your #mon back, it will cost ¥100.
	text_jump UnknownText_0x1bde32

.PartyFull
	; You have no room for it.
	text_jump UnknownText_0x1bdea2

.NotEnoughMoney
	; You don't have enough money.
	text_jump UnknownText_0x1bdebc

.OhFineThen
	; Oh, fine then.
	text_jump UnknownText_0x1bded9

.ComeAgain
	; Come again.
	text_jump UnknownText_0x1bdee9

Special_DayCareManOutside:
	ld hl, wDaycareMan
	bit 6, [hl]
	jr nz, .AskGiveEgg
	ld hl, .NotYet
	jp PrintText

.NotYet
	; Not yet…
	text_jump UnknownText_0x1bdef6

.AskGiveEgg
	ld hl, .IntroText
	call PrintText
	call YesNoBox
	jr c, .Declined
	ld a, [wPartyCount]
	cp PARTY_LENGTH
	jr nc, .PartyFull
	call DayCare_GiveEgg
	ld hl, wDaycareMan
	res 6, [hl]
	call DayCare_InitBreeding
	ld hl, .GotEggText
	call PrintText
	ld de, SFX_GET_EGG_FROM_DAYCARE_LADY
	call PlaySFX
	ld c, 120
	call DelayFrames
	xor a
	ld [hScriptVar], a
	ret

.Declined
	ld hl, .IllKeepItThanksText

.Load0
	call PrintText
	xor a
	ld [hScriptVar], a
	ret

.PartyFull
	ld hl, .PartyFullText
	call PrintText
	ld a, $1
	ld [hScriptVar], a
	ret

.IntroText
	; Ah, it's you! We were raising your #mon, and my goodness, were we surprised! Your #mon had an EGG! We don't know how it got there, but your #mon had it. You want it?
	text_jump UnknownText_0x1bdf00

.GotEggText
	; received the EGG!
	text_jump UnknownText_0x1bdfa5

.IllKeepItThanksText
	; Well then, I'll keep it. Thanks!
	text_jump UnknownText_0x1bdfd1

.PartyFullText
	; You have no room in your party. Come back later.
	text_jump UnknownText_0x1bdff2

DayCare_GiveEgg:
	ld a, [wEggMonLevel]
	ld [CurPartyLevel], a
	ld hl, wPartyCount
	ld a, [hl]
	cp PARTY_LENGTH
	jr nc, .PartyFull
	inc a
	ld [hl], a

	ld c, a
	ld b, 0
	add hl, bc
	ld a, EGG
	ld [hli], a
	ld a, [wEggMonSpecies]
	ld [wCurSpecies], a
	ld [wCurPartySpecies], a
	ld a, -1
	ld [hl], a

	ld hl, wPartyMonNicknames
	ld bc, PKMN_NAME_LENGTH
	call DayCare_GetCurrentPartyMember
	ld hl, wEggNick
	rst CopyBytes

	ld hl, wPartyMonOT
	ld bc, NAME_LENGTH
	call DayCare_GetCurrentPartyMember
	ld hl, wEggOT
	rst CopyBytes

	ld hl, wPartyMon1
	ld bc, PARTYMON_STRUCT_LENGTH
	call DayCare_GetCurrentPartyMember
	ld hl, wEggMon
	ld bc, wEggMonEnd - wEggMon
	rst CopyBytes

	call GetBaseData
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld b, h
	ld c, l
	ld hl, MON_ID + 1
	add hl, bc
	push hl
	ld hl, MON_MAXHP
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	push bc
	ld b, $0
	predef CalcPkmnStats
	pop bc
	ld hl, MON_HP
	add hl, bc
	xor a
	ld [hli], a
	ld [hl], a
	and a
	ret

.PartyFull
	scf
	ret

DayCare_GetCurrentPartyMember:
	ld a, [wPartyCount]
	dec a
	rst AddNTimes
	ld d, h
	ld e, l
	ret

DayCare_InitBreeding:
	ld a, [wDaycareLady]
	bit 0, a
	ret z
	ld a, [wDaycareMan]
	bit 0, a
	ret z
	callba CheckBreedmonCompatibility
	ld a, [wd265]
	and a
	ret z
	inc a
	ret z
	ld hl, wDaycareMan
	set 5, [hl]
.loop
	call Random
	cp 150
	jr c, .loop
	ld [wStepsToEgg], a

	xor a
	ld hl, wEggMon
	ld bc, wEggMonEnd - wEggMon
	call ByteFill
	ld hl, wEggNick
	ld bc, PKMN_NAME_LENGTH
	call ByteFill
	ld hl, wEggOT
	ld bc, NAME_LENGTH
	call ByteFill
	ld a, [wBreedMon1DVs]
	ld [TempMonDVs], a
	ld a, [wBreedMon1DVs + 1]
	ld [TempMonDVs + 1], a
	ld a, [wBreedMon1Species]
	ld [wCurPartySpecies], a
	ld a, $3
	ld [wMonType], a
	ld a, [wBreedMon1Species]
	cp DITTO
	ld a, $1
	jr z, .LoadWhichBreedmonIsTheMother
	ld a, [wBreedMon2Species]
	cp DITTO
	ld a, $0
	jr z, .LoadWhichBreedmonIsTheMother
	callba GetGender
	ld a, $0
	jr z, .LoadWhichBreedmonIsTheMother
	inc a

.LoadWhichBreedmonIsTheMother
	ld [wBreedMotherOrNonDitto], a
	and a
	ld a, [wBreedMon1Species]
	jr z, .GotMother
	ld a, [wBreedMon2Species]

.GotMother
	ld [wCurPartySpecies], a
	callba GetPreEvolution
	callba GetPreEvolution
	ld a, EGG_LEVEL
	ld [CurPartyLevel], a

	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	ld [wEggMonSpecies], a

	call GetBaseData
	ld hl, wEggNick
	ld de, .String_EGG
	call CopyName2
	ld hl, PlayerName
	ld de, wEggOT
	ld bc, NAME_LENGTH
	rst CopyBytes
	xor a
	ld [wEggMonItem], a
	ld de, wEggMonMoves
	xor a
	ld [wFillMoves_IsPartyMon], a
	predef FillMoves
	callba InitEggMoves
	ld hl, wEggMonID
	ld a, [PlayerID]
	ld [hli], a
	ld a, [PlayerID + 1]
	ld [hl], a
	ld a, [CurPartyLevel]
	ld d, a
	callba CalcExpAtLevel
	ld hl, wEggMonExp
	ld a, [hMultiplicand]
	ld [hli], a
	ld a, [hMultiplicand + 1]
	ld [hli], a
	ld a, [hMultiplicand + 2]
	ld [hl], a
	xor a
	ld b, wEggMonDVs - wEggMonStatExp
	ld hl, wEggMonStatExp
.loop2
	ld [hli], a
	dec b
	jr nz, .loop2
	ld hl, wEggMonDVs
	call Random
	ld [hli], a
	ld [TempMonDVs], a
	call Random
	ld [hld], a
	ld [TempMonDVs + 1], a
	ld de, wBreedMon1DVs
	ld a, [wBreedMon1Species]
	cp DITTO
	jr z, .GotDVs
	ld de, wBreedMon2DVs
	ld a, [wBreedMon2Species]
	cp DITTO
	jr z, .GotDVs
	ld a, BREEDMON
	ld [wMonType], a
	push hl
	callba GetGender
	pop hl
	ld de, wBreedMon1DVs
	ld bc, wBreedMon2DVs
	jr c, .SkipDVs
	jr z, .ParentCheck2
	ld a, [wBreedMotherOrNonDitto]
	and a
	jr z, .GotDVs
	ld d, b
	ld e, c
	jr .GotDVs

.ParentCheck2
	ld a, [wBreedMotherOrNonDitto]
	and a
	jr nz, .GotDVs
	ld d, b
	ld e, c

.GotDVs
	ld a, [de]
	inc de
	and $f
	ld b, a
	ld a, [hl]
	and $f0
	add b
	ld [hli], a
	ld a, [de]
	and $7
	ld b, a
	ld a, [hl]
	and $f8
	add b
	ld [hl], a

.SkipDVs
	ld hl, wStringBuffer1
	ld de, wMonOrItemNameBuffer
	ld bc, NAME_LENGTH
	rst CopyBytes
	ld hl, wEggMonMoves
	ld de, wEggMonPP
	predef FillPP
	ld hl, wMonOrItemNameBuffer
	ld de, wStringBuffer1
	ld bc, NAME_LENGTH
	rst CopyBytes
	ld a, [BaseEggSteps]
	ld hl, wEggMonHappiness
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, [CurPartyLevel]
	ld [wEggMonLevel], a
	ret

.String_EGG
	db "Egg@"
