CheckAtLeastThreeLegalPokemon::
; Counts number of legal party mons. Returns to hScriptVar
	ld hl, wPartySpecies
	ld c, 0
	jr .handleLoop

.loop
	call BattleTower_IsCurSpeciesLegal
	jr c, .handleLoop
	inc c
.handleLoop
	ld a, [hli]
	cp $ff
	jr nz, .loop
	ld a, c
	ld [hScriptVar], a
	ret

BattleTower_IsCurSpeciesLegal_Far::
	ld a, b
BattleTower_IsCurSpeciesLegal:
; returns carry if illegal
	push hl
	push bc
	ld hl, BattleTower_BannedMons
	call IsInSingularArray
	pop bc
	pop hl
	ret

BattleTower_BannedMons::
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
	db EGG
	db LIBABEEL
	db PHANCERO
	db $ff

BattleTower_SetLevelGroup::
	ld a, [wMenuCursorY]
	ld c, 50
	call SimpleMultiply
	ld c, a
	call BattleTower_StackCallWRAMBankSwitch
.Function
	ld a, c
	ld [wBTChoiceOfLvlGroup], a
	ret

BattleTower_StackCallWRAMBankSwitch::
	ld a, BANK(wBattleTower)
	jp StackCallInWRAMBankA

BattleTower_InitChallenge::
	call BattleTower_StackCallWRAMBankSwitch
.Function
	ld hl, wBattleTower
	ld bc, wBattleTowerEnd - wBattleTower - 1
	xor a
	call ByteFill
	ld a, BANK(sBT_WinStreak)
	call GetSRAMBank
	ld a, [sBT_WinStreak]
	ld [hl], a
	call CloseSRAM
	call .SampleTeams
	ld hl, wBTOpponentIndices
	lb bc, (BattleTowerTrainerStructsEnd - BattleTowerTrainerStructs) / NAME_LENGTH, 7
	ld a, [wBT_WinStreak]
	cp 14
	jr z, .brain
	cp 42
	jr nz, .init
.brain
	ld a, $ff
	ld [wBTOpponentIndices + 6], a
	dec c
	jr .init

.SampleTeams:
	ld hl, wBTMonsSelected
	lb bc, (BattleTowerMonStructsEnd - BattleTowerMonStructs) / BTMON_DATA_LENGTH, 21
.init
	push hl
	push bc
	ld b, 0
	ld a, $ff
	call ByteFill
	pop bc
	pop hl
	push hl

.loop
	call Random
	cp b
	jr nc, .loop
	ld d, a
	jr .handleLoop
.loop2
	cp d
	jr z, .loop
.handleLoop
	ld a, [hli]
	cp $ff
	jr nz, .loop2
.insert
	dec hl
	ld [hl], d
	inc hl
	dec c
	jr nz, .loop
	pop hl
	ret

BattleTower_LoadCurrentTeam::
	call BattleTower_LoadTeamIntoBank2
	ld hl, OTPartyCount
	ld bc, OTPartyDataEnd - OTPartyCount
	xor a
	call ByteFill
	ld hl, OTPartyCount
	ld a, 3
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	dec a
	ld [hl], a
	ld hl, wBT_OTName
	ld de, OTPlayerName
	ld bc, NAME_LENGTH +- 1
	ln a, BANK(wOTPartyMonOT), BANK(wBT_OTName)
	call DoubleFarCopyWRAM
	ld a, "@"
	ld [de], a

	ld b, 3
	ld hl, OTPlayerName
	ld de, wOTPartyMonOT
.loop1
	push bc
	push hl
	ld bc, NAME_LENGTH
	rst CopyBytes
	pop hl
	pop bc
	dec b
	jr nz, .loop1
	ld hl, wBT_OTTrainerClass
	ld a, BANK(wBT_OTTrainerClass)
	call GetFarWRAMByte
	ld [OtherTrainerClass], a
	xor a
	ld [OtherTrainerID], a
	ld hl, wBT_OTPkmn1
.loop2
	; Species Index
	ld [wCurPartyMon], a
	ld c, a
	ld b, 0
	push hl
	ld hl, OTPartySpecies
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld a, BANK(wBT_OTPkmn1)
	call GetFarWRAMByte
	ld [de], a

	; Struct part 1
	push hl
	ld hl, OTPartyMon1
	ld a, [wCurPartyMon]
	call GetPartyLocation
	ld d, h
	ld e, l
	pop hl
	push de
	ld bc, MON_ID - MON_SPECIES
	ln a, BANK(OTPartyMon1), BANK(wBT_OTPkmn1)
	call DoubleFarCopyWRAM

	; Struct part 2
	ld a, MON_STAT_EXP - MON_ID
	add e
	ld e, a
	jr nc, .no_inc_d
	inc d
.no_inc_d
	ld bc, MON_PP - MON_STAT_EXP
	ln a, BANK(OTPartyMon1), BANK(wBT_OTPkmn1)
	call DoubleFarCopyWRAM

	; Nickname
	push hl
	ld hl, OTPartyMonNicknames
	ld a, [wCurPartyMon]
	call SkipNames
	ld d, h
	ld e, l
	pop hl
	ln a, BANK(OTPartyMonNicknames), BANK(wBT_OTPkmn1)
	call DoubleFarCopyWRAM

	; Level and Experience
	pop bc
	ld a, [bc]
	ld [wCurSpecies], a
	push hl
	call GetBaseData
	ld a, BANK(wBTChoiceOfLvlGroup)
	ld hl, wBTChoiceOfLvlGroup
	call GetFarWRAMByte
	ld hl, MON_LEVEL
	add hl, bc
	ld [hl], a
	ld d, a
	ld [CurPartyLevel], a
	push bc
	callba CalcExpAtLevel
	pop bc
	ld hl, MON_EXP
	add hl, bc
	ld a, [hProduct + 1]
	ld [hli], a
	ld a, [hProduct + 2]
	ld [hli], a
	ld a, [hProduct + 3]
	ld [hl], a

	; PP
	ld hl, MON_PP
	add hl, bc
	ld d, h
	ld e, l
	ld hl, MON_MOVES
	add hl, bc
	predef FillPP

	; Stats
	ld hl, MON_MAXHP
	add hl, bc
	push hl
	ld d, h
	ld e, l
	dec hl
	dec hl
	push hl
	ld hl, MON_STAT_EXP - 1
	add hl, bc
	ld b, 1
	predef CalcPkmnStats
	pop de
	pop hl
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a

	; Next
	pop hl
	ld a, [wCurPartyMon]
	inc a
	cp 3
	jp c, .loop2
	ld hl, OTPartySpecies + 3
	ld [hl], $ff

	ld a, [OtherTrainerClass]
	dec a
	ld e, a
	ld d, 0
	ld hl, .Sprites
	add hl, de
	ld a, [hl]
	ld [Map1ObjectSprite], a
	ld [UsedSprites + $2], a
	ld [hUsedSpriteIndex], a
.reject_color
	call Random
	and $70
	cp (PAL_OW_SILVER - 1) << 4
	jr z, .reject_color
	jr c, .add_80
	add $10
.add_80
	or $80
	ld [Map1ObjectColor], a
	ld a, [UsedSprites + $3]
	ld [hUsedSpriteTile], a
	jpba GetUsedSprite

.Sprites:
	db SPRITE_FALKNER
	db SPRITE_WHITNEY
	db SPRITE_BUGSY
	db SPRITE_MORTY
	db SPRITE_PRYCE
	db SPRITE_JASMINE
	db SPRITE_CHUCK
	db SPRITE_CLAIR
	db SPRITE_SILVER
	db SPRITE_BLUE
	db SPRITE_SORA
	db SPRITE_MURA
	db SPRITE_DAICHI
	db SPRITE_YUKI
	db SPRITE_KOJI
	db SPRITE_LANCE
	db SPRITE_PALETTE_PATROLLER
	db SPRITE_SCIENTIST
	db SPRITE_YOUNGSTER
	db SPRITE_YOUNGSTER
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_LASS
	db SPRITE_COOLTRAINER_M
	db SPRITE_COOLTRAINER_F
	db SPRITE_BUENA
	db SPRITE_SUPER_NERD
	db SPRITE_ROCKET
	db SPRITE_GENTLEMAN
	db SPRITE_BUENA
	db SPRITE_TEACHER
	db SPRITE_SABRINA
	db SPRITE_BUG_CATCHER
	db SPRITE_FISHER
	db SPRITE_SUPER_NERD
	db SPRITE_COOLTRAINER_F
	db SPRITE_SAILOR
	db SPRITE_SUPER_NERD
	db SPRITE_SILVER
	db SPRITE_ROCKER
	db SPRITE_POKEFAN_M
	db SPRITE_BIKER
	db SPRITE_BLAINE
	db SPRITE_PHARMACIST
	db SPRITE_FISHER
	db SPRITE_SUPER_NERD
	db SPRITE_BLACK_BELT
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_YOUNGSTER
	db SPRITE_SAGE
	db SPRITE_GRANNY
	db SPRITE_ROCKER
	db SPRITE_POKEFAN_M
	db SPRITE_ROCKER
	db SPRITE_TWIN
	db SPRITE_POKEFAN_F
	db SPRITE_RED
	db SPRITE_BLUE
	db SPRITE_OFFICER
	db SPRITE_POKEFAN_M
	db SPRITE_BROCK
	db SPRITE_SUPER_NERD
	db SPRITE_MISTY
	db SPRITE_LOIS
	db SPRITE_SPARKY
	db SPRITE_CAL
	db SPRITE_ROCKET
	db SPRITE_COOLTRAINER_M
	db SPRITE_MOM
	db SPRITE_KIMONO_GIRL
	db SPRITE_BUGSY
	db SPRITE_WHITNEY
	db SPRITE_SABRINA
	db SPRITE_COOLTRAINER_F
	db SPRITE_COOLTRAINER_F
	db SPRITE_COOLTRAINER_M
	db SPRITE_RED
	db SPRITE_COOLTRAINER_F
	db SPRITE_CAL

BattleTower_LoadTeamIntoBank2::
	call BattleTower_StackCallWRAMBankSwitch
.Function
	ld a, [wBT_CurStreak]
	ld c, a
	ld b, 0
	ld hl, wBTOpponentIndices
	add hl, bc
	
	ld a, [wBT_WinStreak]
	cp 20
	jp z, .TycoonSilver
	cp 48
	jp z, .TycoonGold
	
	ld a, [hl]
	ld hl, BattleTowerTrainerStructs
	call SkipNames
	ld de, wBT_OTName
	ld a, BANK(BattleTowerTrainerStructs)
	call FarCopyBytes
	ld a, [wBT_CurStreak]
	ld c, a
	add a
	add c
	ld c, a
	ld b, 0
	ld hl, wBTMonsSelected
	add hl, bc
	ld b, 3
	ld de, wBT_OTPkmn1
.loop
	ld a, [hli]
	push bc
	push hl
	ld hl, BattleTowerMonStructs
	ld bc, BTMonStructEnd - BTMonStructStart
	rst AddNTimes
	ld a, BANK(BattleTowerMonStructs)
	call FarCopyBytes
	pop hl
	pop bc
	dec b
	jr nz, .loop
	ret
	
.TycoonSilver
	ld hl, TycoonSilverTeam
	jr .copy
	
.TycoonGold
	ld hl, TycoonGoldTeam
	jr .copy
.copy
	call GetWeekday
	ld c, 3
	call SimpleDivide
	push af
	ld bc, 3 * (BTMON_STRUCT_LENGTH + PKMN_NAME_LENGTH)
	rst AddNTimes
	ld a, BANK(TycoonErrorTeam)
	call FarCopyBytes
	ld bc, NAME_LENGTH
	ld hl, .TycoonName
	pop af
	rst AddNTimes
	ld de, wBT_OTName
	rst CopyBytes
	
	
	ld a, $ff
	ld [wBTOpponentIndices + 6], a
	
	
	ret

.TycoonName:
	db "Candela@@@", CANDELA
	db "Blanche@@@", BLANCHE
	db "Spark@@@@@", SPARK_T

BattleTower_SaveChallengeData::
	call BattleTower_StackCallWRAMBankSwitch
.Function
	ld a, BANK(sBattleTower)
	call GetSRAMBank

	ld hl, wBattleTower
	ld de, sBattleTower
	ld bc, sBattleTowerEnd - sBattleTower
	rst CopyBytes
	jp CloseSRAM

BattleTower_LoadChallengeData::
	call BattleTower_StackCallWRAMBankSwitch
.Function
	ld a, BANK(sBattleTower)
	call GetSRAMBank

	ld hl, sBattleTower
	ld de, wBattleTower
	ld bc, sBattleTowerEnd - sBattleTower
	rst CopyBytes
	call CloseSRAM
	ld a, [wBT_CurStreak]
	ld [hScriptVar], a
	ret

StartBattleTowerBattle::
	ld hl, wOptions
	ld a, [hl]
	push af
	set BATTLE_SHIFT, [hl]

	ld hl, InBattleTowerBattle
	ld a, [hl]
	push af
	set 0, [hl]

	xor a
	ld [wLinkMode], a

	predef StartBattle

	;callba LoadPokemonData
	ld a, [wBattleResult]
	ld [hScriptVar], a
	and $f
	call z, .IncrementWinStreak
	
	ld a, BANK(sBT_WinStreak)
	call GetSRAMBank
	xor a
	ld [sBT_WinStreak], a
	call CloseSRAM

	pop af
	ld [InBattleTowerBattle], a
	pop af
	ld [wOptions], a
	ret

.IncrementWinStreak:
	call BattleTower_StackCallWRAMBankSwitch
.Function:
	ld hl, wBT_CurStreak
	inc [hl]
	ld hl, wBT_WinStreak
	ld a, [hl]
	cp 100
	ret nc
	inc [hl]
	
	ld a, BANK(sBT_WinStreak)
	call GetSRAMBank
	ld a, [hl]
	ld [sBT_WinStreak], a
	jp CloseSRAM

BattleTower_CheckFought7Trainers::
	call BattleTower_CheckCurrentStreak
	ld c, 7
	call SimpleDivide
	ld [hScriptVar], a
	ret

BattleTower_CheckCurrentStreak::
	ld hl, wBT_CurStreak
	ld a, BANK(wBT_CurStreak)
	call GetFarWRAMByte
	jr BattleTower_WriteScriptVarAndReturn

BattleTower_CheckDefeatedBrain::
	ld hl, wBT_WinStreak
	ld a, BANK(wBT_WinStreak)
	call GetFarWRAMByte
	ld b, $1
	cp 21
	jr z, .gotWinStreak
	cp 49
	jr z, .gotWinStreak
	ld b, $0
.gotWinStreak
	ld a, b
BattleTower_WriteScriptVarAndReturn:
	ld [hScriptVar], a
	ret

BattleTowerText::
; Print text c for trainer [wBT_OTTrainerClass]
; 1: Intro text
; 2: Player lost
; 3: Player won
	call BattleTower_StackCallWRAMBankSwitch
.Function
	ld e, c ; save text type in e

	ld a, [wBT_OTTrainerClass]
	cp CANDELA
	jr c, .normal
	cp SPARK_T + 1
	jr nc, .normal
	sub CANDELA
	dec e
	ld bc, 6
	ld hl, BTTycoonTextPointers
	rst AddNTimes
	ld d, 0
	add hl, de
	add hl, de
	jr .print

.normal
	dec a
	ld c, a
	ld b, CHECK_FLAG
	ld hl, BTTrainerClassGenders
	predef FlagAction
	ld a, c
	and a
	ld hl, BTFemaleTrainerTexts
	ld c, 15
	jr nz, .got_params
	ld hl, BTMaleTrainerTexts
	ld c, 25
.got_params
	dec e ; have we determined the text index already?
	jr nz, .restore ; if so, restore the index
	ld a, c
	call RandomRange
	ld [wBT_TrainerTextIndex], a
	jr .gotTextIndex

.restore
	ld a, [wBT_TrainerTextIndex]
.gotTextIndex
	ld c, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld b, d
	add hl, bc
	add hl, bc
.print
	ld a, [hli]
	ld h, [hl]
	ld l, a
	bccoord 1, 14
	jp ProcessTextCommands_

BTTrainerClassGenders:
bitfield: MACRO
x = 0
rept 8
x = x + (\1 << 8)
x = x >> 1
	shift
endr
	db x
endm

	bitfield MALE, FEMALE, MALE, MALE, FEMALE, FEMALE, MALE, MALE ; JOSIAH, BROOKLYN, RINJI, EDISON, AYAKA, CADENCE, ANDRE, BRUCE
	bitfield MALE, MALE, FEMALE, MALE, MALE, FEMALE, FEMALE, MALE ; RIVAL1, MURA, YUKI, KOJI, DAICHI, DELINQUENTF, SORA, CHAMPION
	bitfield MALE, MALE, MALE, MALE, MALE, FEMALE, FEMALE, MALE ; PATROLLER, SCIENTIST, YOUNGSTER, SCHOOLBOY, BIRD_KEEPER, LASS, CHEERLEADER, COOLTRAINERM
	bitfield FEMALE, FEMALE, MALE, MALE, MALE, FEMALE, FEMALE, FEMALE ; COOLTRAINERF, BEAUTY, POKEMANIAC, GRUNTF, GENTLEMAN, SKIER, TEACHER, SHERYL
	bitfield MALE, MALE, MALE, MALE, FEMALE, MALE, MALE, MALE ; BUG_CATCHER, FISHER, SWIMMERM, SWIMMERF, SAILOR, SUPER_NERD, RIVAL2, GUITARIST
	bitfield MALE, MALE, MALE, MALE, MALE, MALE, MALE, MALE ; HIKER, BIKER, JOE, BURGLAR, FIREBREATHER, JUGGLER, BLACKBELT_T, PSYCHIC_T
	bitfield FEMALE, MALE, MALE, FEMALE, MALE, MALE, MALE, FEMALE ; PICNICKER, CAMPER, SAGE, MEDIUM, BOARDER, POKEFANM, DELINQUENTM, TWINS
	bitfield FEMALE, MALE, MALE, MALE, MALE, MALE, MALE, FEMALE ; POKEFANF, RED, BLUE, OFFICER, MINER, KARPMAN, ARCADEPC_GROUP, LILY
	bitfield FEMALE, MALE, MALE, MALE, FEMALE, FEMALE, FEMALE, FEMALE ; LOIS, SPARKY, ERNEST, BUGSY, WHITNEY, SABRINA, CANDELA, BLANCHE
	bitfield MALE, MALE, FEMALE, MALE, MALE, MALE, MALE, MALE ; SPARK_T, BROWN, GUITARISTF, CAL

BTTycoonTextPointers:
	dw BattleTowerText_CandelaBefore
	dw BattleTowerText_CandelaLoss
	dw BattleTowerText_CandelaWin

	dw BattleTowerText_BlancheBefore
	dw BattleTowerText_BlancheLoss
	dw BattleTowerText_BlancheWin

	dw BattleTowerText_SparkBefore
	dw BattleTowerText_SparkLoss
	dw BattleTowerText_SparkWin


BTMaleTrainerTexts:
	dw .Greetings
	dw .PlayerLost
	dw .PlayerWon

.Greetings
	dw BattleTowerText_0x1ec000
	dw BattleTowerText_0x1ec080
	dw UnknownText_0x1ec0e1
	dw UnknownText_0x1ec14d
	dw UnknownText_0x1ec1ae
	dw UnknownText_0x1ec216
	dw UnknownText_0x1ec27b
	dw UnknownText_0x1ec2d9
	dw UnknownText_0x1ec33f
	dw UnknownText_0x1ec3ad
	dw UnknownText_0x1ec402
	dw UnknownText_0x1ec42e
	dw UnknownText_0x1ec4d6
	dw UnknownText_0x1ec532
	dw UnknownText_0x1ec580
	dw UnknownText_0x1ec5d3
	dw UnknownText_0x1ec631
	dw UnknownText_0x1ec6b1
	dw UnknownText_0x1ec720
	dw UnknownText_0x1ec77f
	dw UnknownText_0x1ec7d8
	dw UnknownText_0x1ec858
	dw UnknownText_0x1ec8b1
	dw UnknownText_0x1ec911
	dw UnknownText_0x1ec969

.PlayerLost
	dw BattleTowerText_0x1ec03b
	dw UnknownText_0x1ec0a3
	dw UnknownText_0x1ec108
	dw UnknownText_0x1ec16f
	dw UnknownText_0x1ec1d0
	dw UnknownText_0x1ec238
	dw UnknownText_0x1ec2a0
	dw UnknownText_0x1ec2fe
	dw UnknownText_0x1ec36c
	dw UnknownText_0x1ec3c5
	dw UnknownText_0x1ec411
	dw UnknownText_0x1ec461
	dw UnknownText_0x1ec4f5
	dw UnknownText_0x1ec54b
	dw UnknownText_0x1ec59d
	dw UnknownText_0x1ec5ee
	dw UnknownText_0x1ec651
	dw UnknownText_0x1ec6d0
	dw UnknownText_0x1ec73e
	dw UnknownText_0x1ec798
	dw UnknownText_0x1ec818
	dw UnknownText_0x1ec876
	dw UnknownText_0x1ec8d5
	dw UnknownText_0x1ec928
	dw UnknownText_0x1ec986

.PlayerWon
	dw UnknownText_0x1ec060
	dw UnknownText_0x1ec0c4
	dw UnknownText_0x1ec12a
	dw UnknownText_0x1ec190
	dw UnknownText_0x1ec1f4
	dw UnknownText_0x1ec259
	dw UnknownText_0x1ec2c0
	dw UnknownText_0x1ec320
	dw UnknownText_0x1ec389
	dw UnknownText_0x1ec3e5
	dw UnknownText_0x1ec41f
	dw UnknownText_0x1ec4a0
	dw UnknownText_0x1ec512
	dw UnknownText_0x1ec565
	dw UnknownText_0x1ec5b5
	dw UnknownText_0x1ec60d
	dw UnknownText_0x1ec68f
	dw UnknownText_0x1ec708
	dw UnknownText_0x1ec75b
	dw UnknownText_0x1ec7bb
	dw UnknownText_0x1ec837
	dw UnknownText_0x1ec898
	dw UnknownText_0x1ec8f0
	dw UnknownText_0x1ec949
	dw UnknownText_0x1ec99b


BTFemaleTrainerTexts:
	dw .Greetings
	dw .PlayerLost
	dw .PlayerWon

.Greetings
	dw UnknownText_0x1ec9bd
	dw UnknownText_0x1eca0a
	dw UnknownText_0x1eca64
	dw UnknownText_0x1ecabf
	dw UnknownText_0x1ecb19
	dw UnknownText_0x1ecb70
	dw UnknownText_0x1ecbd9
	dw UnknownText_0x1ecc39
	dw UnknownText_0x1ecc92
	dw UnknownText_0x1eccd7
	dw UnknownText_0x1ecd2b
	dw UnknownText_0x1ecd8d
	dw UnknownText_0x1ecded
	dw UnknownText_0x1ece4b
	dw UnknownText_0x1ecea8

.PlayerLost
	dw UnknownText_0x1ec9d9
	dw UnknownText_0x1eca2a
	dw UnknownText_0x1eca82
	dw UnknownText_0x1ecade
	dw UnknownText_0x1ecb37
	dw UnknownText_0x1ecb92
	dw UnknownText_0x1ecbf3
	dw UnknownText_0x1ecc55
	dw UnknownText_0x1ecca7
	dw UnknownText_0x1eccef
	dw UnknownText_0x1ecd4d
	dw UnknownText_0x1ecdaf
	dw UnknownText_0x1ece0d
	dw UnknownText_0x1ece70
	dw UnknownText_0x1ecec9

.PlayerWon
	dw UnknownText_0x1ec9f7
	dw UnknownText_0x1eca47
	dw UnknownText_0x1eca9d
	dw UnknownText_0x1ecafa
	dw UnknownText_0x1ecb55
	dw UnknownText_0x1ecbb6
	dw UnknownText_0x1ecc15
	dw UnknownText_0x1ecc75
	dw UnknownText_0x1eccc1
	dw UnknownText_0x1ecd0e
	dw UnknownText_0x1ecd6b
	dw UnknownText_0x1ecdcf
	dw UnknownText_0x1ece2a
	dw UnknownText_0x1ece8a
	dw UnknownText_0x1ecee8

PUSHS
SECTION "Debug BT", ROMX, BANK [BATTLE_TOWER_DEBUG]
BattleTower_DebugTeam::
	ld a, [rSVBK]
	push af
	ld a, BANK(wBTChoiceOfLvlGroup)
	ld [rSVBK], a
	ld a, 50
	ld [wBTChoiceOfLvlGroup], a
	pop af
	ld [rSVBK], a
	; back up the party
	xor a
	call GetSRAMBank
	ld hl, wPartyCount
	ld de, sBattleTowerPartyBackup
	ld bc, wPartyMonNicknamesEnd - wPartyCount
	rst CopyBytes
	call CloseSRAM

	; reset the party
	ld de, wPartyCount
	ld hl, DebugBTParty
	ld bc, wPartyMonNicknamesEnd - wPartyCount
	rst CopyBytes

	ld bc, wPartyMon1
	callba Level50Cap
	ld bc, wPartyMon2
	callba Level50Cap
	ld bc, wPartyMon3
	jpba Level50Cap

DebugBTParty:
	db 3
	db LUCARIO, LUCARIO, LUCARIO
	db $ff
	ds 3

	db LUCARIO
	db BLACKBELT
	db EARTHQUAKE, AURA_SPHERE, DRAIN_PUNCH, SWORDS_DANCE
	dw 09057
	dt 117360
	dw $FFFF ; hp
	dw $FFFF ; atk
	dw $FFFF ; def
	dw $FFFF ; spd
	dw $FFFF ; spc
	dw $FFFF ; dvs
	db $c0 | 16, $c0 | 32, $c0 | 16, $c0 | 32
	db 255
	db $00
	db 63, 00
	db 100
	db 0, 0
	bigdw 343
	bigdw 343
	bigdw 318
	bigdw 238
	bigdw 278
	bigdw 328
	bigdw 238

	db LUCARIO
	db BLACKBELT
	db EARTHQUAKE, AURA_SPHERE, DRAIN_PUNCH, SWORDS_DANCE
	dw 09057
	dt 117360
	dw $FFFF ; hp
	dw $FFFF ; atk
	dw $FFFF ; def
	dw $FFFF ; spd
	dw $FFFF ; spc
	dw $FFFF ; dvs
	db $c0 | 16, $c0 | 32, $c0 | 16, $c0 | 32
	db 255
	db $00
	db 63, 00
	db 100
	db 0, 0
	bigdw 343
	bigdw 343
	bigdw 318
	bigdw 238
	bigdw 278
	bigdw 328
	bigdw 238

	db LUCARIO
	db BLACKBELT
	db EARTHQUAKE, AURA_SPHERE, DRAIN_PUNCH, SWORDS_DANCE
	dw 09057
	dt 117360
	dw $FFFF ; hp
	dw $FFFF ; atk
	dw $FFFF ; def
	dw $FFFF ; spd
	dw $FFFF ; spc
	dw $FFFF ; dvs
	db $c0 | 16, $c0 | 32, $c0 | 16, $c0 | 32
	db 255
	db $00
	db 63, 00
	db 100
	db 0, 0
	bigdw 343
	bigdw 343
	bigdw 318
	bigdw 238
	bigdw 278
	bigdw 328
	bigdw 238

	ds 3 * $30

	db "DEBUG@@@@@@"
	db "DEBUG@@@@@@"
	db "DEBUG@@@@@@"
	ds 3 * $b

	db "TEST MON@@@"
	db "TEST MON@@@"
	db "TEST MON@@@"
	ds 3 * $b
POPS
