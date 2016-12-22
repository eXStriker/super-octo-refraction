Special::
; Run script special de.
	ld hl, SpecialsPointers
	ld d, 0
	add hl, de
	add hl, de
	add hl, de
	jp FarPointerCall

SpecialsPointers::
	add_special ClearSafariZoneFlag ; 0

; Communications
	add_special Special_SetBitsForLinkTradeRequest ; 1
	add_special Special_WaitForLinkedFriend
	add_special Special_CheckLinkTimeout
	add_special Special_TryQuickSave
	add_special Special_CheckBothSelectedSameRoom
	add_special Special_FailedLinkToPast
	add_special Special_CloseLink
	add_special WaitForOtherPlayerToExit ; 8
	add_special Special_SetBitsForBattleRequest
	add_special Special_SetBitsForTimeCapsuleRequest
	add_special Special_CheckTimeCapsuleCompatibility
	add_special Special_EnterTimeCapsule
	add_special Special_TradeCenter
	add_special Special_Colosseum
	add_special Special_TimeCapsule
	add_special Special_CableClubCheckWhichChris ; 10

; Map Events
	add_special _dummyspecial1
	add_special _dummyspecial3
	add_special _dummyspecial4
	add_special _dummyspecial5
	add_special _dummyspecial6
	add_special _dummyspecial14
	add_special _dummyspecial15
	add_special HealParty ; 18
	add_special PokemonCenterPC
	add_special Special_KrissHousePC
	add_special Special_DayCareMan
	add_special Special_DayCareLady
	add_special Special_DayCareManOutside
	add_special MoveDeletion
	add_special Special_SpurgeMartBank
	add_special Special_MagnetTrain ; 20
	add_special SpecialNameRival
	add_special Special_TownMap
	add_special _dummyspecial2
	add_special Special_UnownPuzzle
	add_special Special_SlotMachine
	add_special Special_CardFlip
	add_special Special_DummyNonfunctionalGameCornerGame ; 28
	add_special Special_ClearBGPalettesBufferScreen
	add_special FadeOutPalettes
	add_special Special_BattleTowerFade
	add_special Special_FadeBlackQuickly
	add_special FadeInPalettes
	add_special Special_FadeInQuickly
	add_special Special_ReloadSpritesNoPalettes
	add_special ClearBGPalettes ; 30
	add_special UpdateTimePals
	add_special ClearTileMap
	add_special UpdateSprites
	add_special ReplaceKrisSprite
	add_special Special_GameCornerPrizeMonCheckDex
	add_special SpecialSeenMon
	add_special PlayMapMusic
	add_special RestartMapMusic ; 38
	add_special HealMachineAnim
	add_special Special_SurfStartStep
	add_special Special_FindGreaterThanThatLevel
	add_special Special_FindAtLeastThatHappy
	add_special Special_FindThatSpecies
	add_special Special_FindThatSpeciesYourTrainerID
	add_special Special_DayCareMon1
	add_special Special_DayCareMon2 ; 40
	add_special _dummyspecial13
	add_special SpecialGiveNobusAggron
	add_special SpecialReturnNobusAggron
	add_special Special_SelectMonFromParty
	add_special SpecialCheckPokerus
	add_special Special_DisplayCoinCaseBalance
	add_special Special_DisplayMoneyAndCoinBalance
	add_special PlaceMoneyTopRight ; 48
	add_special _dummyspecial11
	add_special _dummyspecial9
	add_special _dummyspecial10
	add_special _dummyspecial12
	add_special _dummyspecial8
	add_special NameRater
	add_special Special_DisplayLinkRecord
	add_special GetFirstPokemonHappiness ; 50
	add_special CheckFirstMonIsEgg
	add_special RunCallback_04
	add_special PlaySlowCry
	add_special _dummyspecial16
	add_special Special_YoungerHaircutBrother
	add_special Special_OlderHaircutBrother
	add_special Special_DaisyMassage
	add_special PlayCurMonCry ; 58
	add_special ProfOaksPCBoot
	add_special _dummyspecial19
	add_special InitRoamMons
	add_special Special_FadeOutMusic
	add_special Diploma
	add_special PrintDiploma

	; Crystal
	add_special Reset
	add_special Special_MoveTutor ; 60
	add_special _dummyspecial17
	add_special _dummyspecial18
	add_special _dummyspecial20
	add_special _dummyspecial7
	add_special _dummyspecial21
	add_special SpecialMonCheck
	add_special Special_SetPlayerPalette
	add_special RefreshSprites ; 68
	add_special LoadMapPalettes
	add_special PushSoundstate
	add_special PopSoundstate
	add_special MoveRelearner

	; Custom
	add_special SaveParty
	add_special RestoreParty ; 70
	add_special Special_GoldenrodHappinessMoveTutor
	add_special InitClock

Special_SetPlayerPalette:
	ld a, [hScriptVar]
	ld d, a
	jpba SetPlayerPalette

Special_GameCornerPrizeMonCheckDex:
	ld a, [hScriptVar]
	dec a
	call CheckCaughtMon
	ret nz
	ld a, [hScriptVar]
	dec a
	call SetSeenAndCaughtMon
	call FadeToMenu
	ld a, [hScriptVar]
	ld [wd265], a
	callba NewPokedexEntry
	jp ExitAllMenus

SpecialSeenMon:
	ld a, [hScriptVar]
	dec a
	jp SetSeenMon

Special_FindGreaterThanThatLevel:
	ld a, [hScriptVar]
	ld b, a
	callba _FindGreaterThanThatLevel
	jr z, FoundNone
	jr FoundOne

Special_FindAtLeastThatHappy:
	ld a, [hScriptVar]
	ld b, a
	callba _FindAtLeastThatHappy
	jr z, FoundNone
	jr FoundOne

Special_FindThatSpecies:
	ld a, [hScriptVar]
	ld b, a
	callba _FindThatSpecies
	jr z, FoundNone
	jr FoundOne

Special_FindThatSpeciesYourTrainerID:
	ld a, [hScriptVar]
	ld b, a
	callba _FindThatSpeciesYourTrainerID
	jr z, FoundNone
	; fallthrough

FoundOne:
	ld a, TRUE
	ld [hScriptVar], a
	ret

FoundNone:
	xor a
	ld [hScriptVar], a
	ret

SpecialNameRival:
	ld b, $2 ; rival
	ld de, RivalName
	callba _NamingScreen
	; default to "Bronze"
	ld hl, RivalName
	ld de, DefaultRivalName
	jp InitName

DefaultRivalName:
	db "Bronze@"

Special_TownMap:
	call FadeToMenu
	callba _TownMap
	jp ExitAllMenus

Special_DisplayLinkRecord:
	call FadeToMenu
	callba DisplayLinkRecord
	jp ExitAllMenus

Special_KrissHousePC:
	xor a
	ld [hScriptVar], a
	callba _KrissHousePC
	ld a, c
	ld [hScriptVar], a
	ret

Special_UnownPuzzle:
	call FadeToMenu
	callba UnownPuzzle
	ld a, [wSolvedUnownPuzzle]
	ld [hScriptVar], a
	jp ExitAllMenus

Special_SlotMachine:
	call Special_CheckCoins
	ret c
	ld a, BANK(_SlotMachine)
	ld hl, _SlotMachine
	jr Special_StartGameCornerGame

Special_CardFlip:
	call Special_CheckCoins
	ret c
	ld a, BANK(_CardFlip)
	ld hl, _CardFlip
	jr Special_StartGameCornerGame

Special_DummyNonfunctionalGameCornerGame:
	call Special_CheckCoins
	ret c
	ld a, BANK(_DummyGame)
	ld hl, _DummyGame
; fallthrough

Special_StartGameCornerGame:
	call FarQueueScript
	call FadeToMenu
	ld hl, wQueuedScriptBank
	call FarPointerCall
	jp ExitAllMenus

Special_CheckCoins:
	ld hl, Coins
	ld a, [hli]
	or [hl]
	jr z, .no_coins
	ld a, COIN_CASE
	ld [wCurItem], a
	ld hl, NumItems
	call CheckItem
	ld hl, .NoCoinCaseText
	jr nc, .print
	and a
	ret

.no_coins
	ld hl, .NoCoinsText

.print
	call PrintText
	scf
	ret

.NoCoinsText
	; You have no coins.
	text_jump UnknownText_0x1bd3d7

.NoCoinCaseText
	; You don't have a COIN CASE.
	text_jump UnknownText_0x1bd3eb

Special_ClearBGPalettesBufferScreen:
	call ClearBGPalettes
	jp BufferScreen

StoreSwarmMapIndices::
	ld a, c
	and a
	jr nz, .yanma
; swarm dark cave violet entrance
	ld a, d
	ld [wDunsparceMapGroup], a
	ld a, e
	ld [wDunsparceMapNumber], a
	ret

.yanma
	ld a, d
	ld [wYanmaMapGroup], a
	ld a, e
	ld [wYanmaMapNumber], a
	ret

SpecialCheckPokerus:
; Check if a monster in your party has Pokerus
	callba CheckPokerus
	sbc a
	and 1
	ld [hScriptVar], a
	ret

PlayCurMonCry:
	ld a, [wCurPartySpecies]
	jp PlayCry

Special_FadeOutMusic:
	ld a, MUSIC_NONE % $100
	ld [MusicFadeIDLo], a
	ld a, MUSIC_NONE / $100
	ld [MusicFadeIDHi], a
	ld a, $2
	ld [MusicFade], a
	ret

Diploma:
	call FadeToMenu
	callba _Diploma
	jp ExitAllMenus

PrintDiploma:
	call FadeToMenu
	callba _PrintDiploma
	jp ExitAllMenus

_dummyspecial1:
_dummyspecial2:
_dummyspecial3:
_dummyspecial4:
_dummyspecial5:
_dummyspecial6:
_dummyspecial7:
_dummyspecial8:
_dummyspecial9:
_dummyspecial10:
_dummyspecial11:
_dummyspecial12:
_dummyspecial13:
_dummyspecial14:
_dummyspecial15:
_dummyspecial16:
_dummyspecial17:
_dummyspecial18:
_dummyspecial19:
_dummyspecial20:
_dummyspecial21:
	ret

SaveParty::
	ld bc, wPartyMonNicknamesEnd - wPokemonData
	ld de, wPartyBackup
	ld hl, wPokemonData
	ln a, BANK(wPartyBackup), BANK(wPokemonData)
	jp DoubleFarCopyWRAM

RestoreParty::
	ld bc, wPartyMonNicknamesEnd - wPokemonData
	ld de, wPokemonData
	ld hl, wPartyBackup
	ln a, BANK(wPokemonData), BANK(wPartyBackup)
	jp DoubleFarCopyWRAM

Special_SurfStartStep::
	call InitMovementBuffer
	call .GetMovementData
	call AppendToMovementBuffer
	ld a, movement_step_end
	jp AppendToMovementBuffer

.GetMovementData
	ld a, [PlayerDirection]
	srl a
	srl a
	and 3
	ld e, a
	ld d, 0
	ld hl, .movement_data
	add hl, de
	ld a, [hl]
	ret

.movement_data
	slow_step_down
	slow_step_up
	slow_step_left
	slow_step_right
