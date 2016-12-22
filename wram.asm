INCLUDE "includes.asm"
INCLUDE "macros/wram.asm"
INCLUDE "vram.asm"

SECTION "Version check", WRAM0
wBuildNumberCheck:: ; c000

SECTION "Stack", WRAM0
wc000::
StackBottom::
	ds $100 - 1
Stack::
StackTop::
	ds 1


SECTION "Audio", WRAM0
wMusic::
MusicPlaying:: ; c100
; nonzero if playing
	ds 1

Channels::
Channel1:: channel_struct Channel1 ; c101
Channel2:: channel_struct Channel2 ; c133
Channel3:: channel_struct Channel3 ; c165
Channel4:: channel_struct Channel4 ; c197

SFXChannels::
Channel5:: channel_struct Channel5 ; c1c9
Channel6:: channel_struct Channel6 ; c1fb
Channel7:: channel_struct Channel7 ; c22d
Channel8:: channel_struct Channel8 ; c25f
ChannelsEnd::
	ds 1 ; c291
wCurTrackDuty:: ds 1
wCurTrackIntensity:: ds 1
wCurTrackFrequency:: dw
wc296:: ds 1 ; BCD value, dummied out
wCurNoteDuration:: ds 1

CurMusicByte:: ; c298
	ds 1
CurChannel:: ; c299
	ds 1
Volume:: ; c29a
; corresponds to $ff24
; Channel control / ON-OFF / Volume (R/W)
;   bit 7 - Vin->SO2 ON/OFF
;   bit 6-4 - SO2 output level (volume) (# 0-7)
;   bit 3 - Vin->SO1 ON/OFF
;   bit 2-0 - SO1 output level (volume) (# 0-7)
	ds 1
SoundOutput:: ; c29b
; corresponds to $ff25
; bit 4-7: ch1-4 so2 on/off
; bit 0-3: ch1-4 so1 on/off
	ds 1
SoundInput:: ; c29c
; corresponds to $ff26
; bit 7: global on/off
; bit 0: ch1 on/off
; bit 1: ch2 on/off
; bit 2: ch3 on/off
; bit 3: ch4 on/off
	ds 1

MusicID::
MusicIDLo:: ; c29d
	ds 1
MusicIDHi:: ; c29e
	ds 1
MusicBank:: ; c29f
	ds 1
NoiseSampleAddress::
NoiseSampleAddressLo:: ; c2a0
	ds 1
NoiseSampleAddressHi:: ; c2a1
	ds 1
wNoiseSampleDelay:: ; noise delay? ; c2a2
	ds 1
; c2a3
	ds 1
MusicNoiseSampleSet:: ; c2a4
	ds 1
SFXNoiseSampleSet:: ; c2a5
	ds 1
Danger:: ; c2a6
; bit 7: on/off
; bit 4: pitch
; bit 0-3: counter
	ds 1
MusicFade:: ; c2a7
; fades volume over x frames
; bit 7: fade in/out
; bit 0-5: number of frames for each volume level
; $00 = none (default)
	ds 1
MusicFadeCount:: ; c2a8
	ds 1
MusicFadeID::
MusicFadeIDLo:: ; c2a9
	ds 1
MusicFadeIDHi:: ; c2aa
	ds 1
	ds 5

CryPitch:: ; c2b0
	ds 2
CryLength:: ; c2b2
	ds 2
LastVolume:: ; c2b4
	ds 1
wc2b5:: ds 1
SFXPriority:: ; c2b6
; if nonzero, turn off music when playing sfx
	ds 1
	ds 1
Channel1JumpCondition:: ds 1
Channel2JumpCondition:: ds 1
Channel3JumpCondition:: ds 1
Channel4JumpCondition:: ds 1
wStereoPanningMask:: ds 1
CryTracks:: ; c2bd
; plays only in left or right track depending on what side the monster is on
; both tracks active outside of battle
	ds 1
wSFXDuration:: ds 1
CurSFX:: ; c2bf
; id of sfx currently playing
	ds 1

wMapMusic:: ; c2c0
	ds 1

wDontPlayMapMusicOnReload:: ds 1
wMusicEnd::

SECTION "WRAM", WRAM0

wPartyMenuItemEffectPointer::
	ds 2
wSavedPartyMenuActionText::
	ds 1

wMonPicTileCount::
	ds 1

wBoxAlignment:: ds 1
InputType:: ; c2c7
	ds 1
AutoInputAddress:: ; c2c8
	ds 2
AutoInputBank:: ; c2ca
	ds 1
AutoInputLength:: ; c2cb
	ds 1

wMonStatusFlags:: ds 1
wGameLogicPause:: ds 1
wSpriteUpdatesEnabled:: ds 1
wMapTimeOfDay:: ds 1

wTextEndPointer:: ds 2

	ds 2

wc2d4:: ds 1 ; related to printer
wPrinterDataJumptableIndex:: ds 1 ; related to printer
wLastDexEntry:: ds 1
wLinkSuppressTextScroll:: ds 1 ; related to link comms

wCurrentLandmark:: ds 1
wLastLandmark:: ds 1
wMapSignTimer:: ds 1
wMapSignRoutineIdx:: ds 1

wLinkMode:: ; c2dc
; 0 not in link battle
; 1 link battle
; 4 mobile battle
	ds 1

	ds 3

wPlayerNextMovement:: ds 1
wPlayerMovement:: ds 1
wc2e2::
wMovementPerson:: ds 1
wMovementDataPointer:: ds 3 ; dba
wc2e6:: ds 4
wMovementByteWasControlSwitch:: ds 1
wMovementPointer:: ds 2 ; c2eb

; do not put anything here, cleared in some movement function
	ds 2
	
	ds 1

wTempObjectCopyMapObjectIndex:: ds 1 ; c2f0
wTempObjectCopySprite:: ds 1 ; c2f1
wTempObjectCopySpriteVTile:: ds 1 ; c2f2
wTempObjectCopyPalette:: ds 1 ; c2f3
wTempObjectCopyMovement:: ds 1 ; c2f4
wTempObjectCopyRange:: ds 1 ; c2f5
wTempObjectCopyX:: ds 1 ; c2f6
wTempObjectCopyY:: ds 1 ; c2f7
wTempObjectCopyRadius:: ds 1 ; c2f8
wTempObjectCopySpritesAddr::
	ds 1

TileDown:: ; c2fa
	ds 1
TileUp:: ; c2fb
	ds 1
TileLeft:: ; c2fc
	ds 1
TileRight:: ; c2fd
	ds 1

TilePermissions:: ; c2fe
; set if tile behavior prevents
; you from walking in that direction
; bit 3: down
; bit 2: up
; bit 1: left
; bit 0: right
	ds 1

wOptionsBackup:: ds 1

SECTION "wSpriteAnims", WRAM0 [$c300]
; wc300 - wc313 is a 10x2 dictionary.
; keys: taken from third column of SpriteAnimSeqData
; values: VTiles
wSpriteAnimDict:: ds 10 * 2

wSpriteAnimationStructs::

sprite_anim_struct: MACRO
\1Index:: ds 1          ; 0
\1FramesetID:: ds 1     ; 1
\1AnimSeqID:: ds 1      ; 2
\1TileID:: ds 1         ; 3
\1XCoord:: ds 1         ; 4
\1YCoord:: ds 1         ; 5
\1XOffset:: ds 1        ; 6
\1YOffset:: ds 1        ; 7
\1Duration:: ds 1       ; 8
\1DurationOffset:: ds 1 ; 9
\1FrameIndex:: ds 1     ; a
\1Sprite0b:: ds 1
\1Sprite0c:: ds 1
\1Sprite0d:: ds 1
\1Sprite0e:: ds 1
\1Sprite0f:: ds 1
ENDM

; Field  0: Index
; Fields 1-3: Loaded from SpriteAnimSeqData
SpriteAnim1:: sprite_anim_struct SpriteAnim1
SpriteAnim2:: sprite_anim_struct SpriteAnim2
SpriteAnim3:: sprite_anim_struct SpriteAnim3
SpriteAnim4:: sprite_anim_struct SpriteAnim4
SpriteAnim5:: sprite_anim_struct SpriteAnim5
SpriteAnim6:: sprite_anim_struct SpriteAnim6
SpriteAnim7:: sprite_anim_struct SpriteAnim7
SpriteAnim8:: sprite_anim_struct SpriteAnim8
SpriteAnim9:: sprite_anim_struct SpriteAnim9
SpriteAnim10:: sprite_anim_struct SpriteAnim10
wSpriteAnimationStructsEnd::

wSpriteAnimCount:: ds 1
wCurrSpriteOAMAddr:: ds 1

CurIcon:: ; c3b6
	ds 1


wCurIconTile:: ds 1
wSpriteAnimAddrBackup::
wSpriteAnimIDBuffer::
wCurrSpriteAddSubFlags::
	ds 2
wCurrAnimVTile:: ds 1
wCurrAnimXCoord:: ds 1
wCurrAnimYCoord:: ds 1
wCurrAnimXOffset:: ds 1
wCurrAnimYOffset:: ds 1
wGlobalAnimYOffset:: ds 1
wGlobalAnimXOffset:: ds 1
wSpriteAnimsEnd::

SECTION "Sprites", WRAM0 [$c400]

Sprites:: ; c400
; 4 bytes per sprite
; 40 sprites
; struct:
;	y (px)
;	x (px)
;	tile id
;	attributes:
;		bit 7: priority
;		bit 6: y flip
;		bit 5: x flip
;		bit 4: pal # (non-cgb)
;		bit 3: vram bank (cgb only)
;		bit 2-0: pal # (cgb only)
	ds 4 * 40
SpritesEnd::


SECTION "Tilemap", WRAM0

TileMap:: ; c4a0
; 20x18 grid of 8x8 tiles
	ds SCREEN_WIDTH * SCREEN_HEIGHT
TileMapEnd::


SECTION "Battle", WRAM0
wMisc::

wc608::
wOddEgg:: party_struct OddEgg
wOddEggName:: ds PKMN_NAME_LENGTH
wOddEggOTName:: ds PKMN_NAME_LENGTH
	ds wc608 - @

wBT_OTTemp:: battle_tower_struct wBT_OTTemp
	ds wc608 - @

	hall_of_fame wHallOfFameTemp
	ds wc608 - @

wWeakestToStrongestMonList::
	ds 7
	
wPokemonDataMisc::

wPartyCountMisc::
	ds 1
wPartySpeciesMisc::
	ds PARTY_LENGTH
wPartyEndMisc::
	ds 1

wPartyMonsMisc::
wPartyMon1Misc:: party_struct wPartyMon1Misc
wPartyMon2Misc:: party_struct wPartyMon2Misc
wPartyMon3Misc:: party_struct wPartyMon3Misc
wPartyMon4Misc:: party_struct wPartyMon4Misc
wPartyMon5Misc:: party_struct wPartyMon5Misc
wPartyMon6Misc:: party_struct wPartyMon6Misc

wPartyMonOTMisc:: ds NAME_LENGTH * PARTY_LENGTH

wPartyMonNicknamesMisc:: ds PKMN_NAME_LENGTH * PARTY_LENGTH
wPokemonDataMiscEnd::

	ds wWeakestToStrongestMonList - @

	ds 10
wc612::
	ds 10
wInitHourBuffer:: ; c61c
	ds 10
wInitMinuteBuffer::
	ds wc608 - @

wBattle::
wEnemyMoveStruct::  move_struct wEnemyMoveStruct ; c608
wPlayerMoveStruct:: move_struct wPlayerMoveStruct ; c60f

EnemyMonNick::  ds PKMN_NAME_LENGTH ; c616
BattleMonNick:: ds PKMN_NAME_LENGTH ; c621

BattleMon:: battle_struct BattleMon ; c62c

	ds 2

wWildMon:: ds 1 ; c64e

wBeatUpSpecies:: ds 1

wEnemyTrainerItem1:: ds 1 ; c650
wEnemyTrainerItem2:: ds 1 ; c651
wEnemyTrainerBaseReward:: ds 1 ; c652
wEnemyTrainerAIFlags:: ds 3 ; c653
OTClassName:: ds NAME_LENGTH ; c656

	ds 2

CurOTMon:: ; c663
	ds 1

wBattleParticipantsNotFainted::
; Bit array.  Bits 0 - 5 correspond to party members 1 - 6.
; Bit set if the mon appears in battle.
; Bit cleared if the mon faints.
; Backed up if the enemy switches.
; All bits cleared if the enemy faints.
	ds 1

TypeModifier:: ; c665
; >10: super-effective
;  10: normal
; <10: not very effective
; bit 7: stab
	ds 1

wCriticalHitOrOHKO:: ; c666
; 0 if not critical
; 1 for a critical hit
; 2 for a OHKO
	ds 1

AttackMissed:: ; c667
; nonzero for a miss
	ds 1

wPlayerSubStatus1:: ; c668
; bit
; 7 attract
; 6 encore
; 5 endure
; 4 perish song
; 3 identified
; 2 protect
; 1 curse
; 0 nightmare
	ds 1
wPlayerSubStatus2:: ; c669
; bit
; 7
; 6 sturdy
; 5 unburden
; 4 flash fire
; 3 ability changed
; 2 guarding
; 1 final chance
; 0 curled
	ds 1
wPlayerSubStatus3:: ; c66a
; bit
; 7 confused
; 6 flying
; 5 underground
; 4 charged
; 3 flinch
; 2 in loop
; 1 rollout
; 0 bide
	ds 1
wPlayerSubStatus4:: ; c66b
; bit
; 7 leech seed
; 6 rage
; 5 recharge
; 4 substitute
; 3
; 2 focus energy
; 1 mist
; 0 bide: unleashed energy
	ds 1
wPlayerSubStatus5:: ; c66c
; bit
; 7 cant run
; 6 destiny bond
; 5 lock-on
; 4 encore
; 3 transformed
; 2
; 1
; 0 toxic
	ds 1

wEnemySubStatus1:: ; c66d
; see wPlayerSubStatus1
	ds 1
wEnemySubStatus2:: ; c66e
; see wPlayerSubStatus2
	ds 1
wEnemySubStatus3:: ; c66f
; see wPlayerSubStatus3
	ds 1
wEnemySubStatus4:: ; c670
; see wPlayerSubStatus4
	ds 1
wEnemySubStatus5:: ; c671
; see wPlayerSubStatus5
	ds 1

PlayerRolloutCount:: ; c672
	ds 1
PlayerConfuseCount:: ; c673
	ds 1
PlayerToxicCount:: ; c674
	ds 1
PlayerDisableCount:: ; c675
	ds 1
PlayerEncoreCount:: ; c676
	ds 1
PlayerPerishCount:: ; c677
	ds 1
PlayerFuryCutterCount:: ; c678
	ds 1
PlayerProtectCount:: ; c679
	ds 1

EnemyRolloutCount:: ; c67a
	ds 1
EnemyConfuseCount:: ; c67b
	ds 1
EnemyToxicCount:: ; c67c
	ds 1
EnemyDisableCount:: ; c67d
	ds 1
EnemyEncoreCount:: ; c67e
	ds 1
EnemyPerishCount:: ; c67f
	ds 1
EnemyFuryCutterCount:: ; c680
	ds 1
EnemyProtectCount:: ; c681
	ds 1

PlayerDamageTaken:: ; c682
	ds 2
EnemyDamageTaken:: ; c684
	ds 2

wBattleReward:: ds 3 ; c686
wBattleAnimParam:: ds 1 ; c689
BattleScriptBuffer:: ; c68a
	ds 40

BattleScriptBufferLoc:: ; c6b2
	ds 2

wTurnEnded:: ds 1 ; c6b4
	ds 1

PlayerStats:: ; c6b6
	ds 10
	ds 1
EnemyStats:: ; c6c1
	ds 10
	ds 1

PlayerStatLevels:: ; c6cc
; 07 neutral
PlayerAtkLevel:: ; c6cc
	ds 1
PlayerDefLevel:: ; c6cd
	ds 1
PlayerSpdLevel:: ; c6ce
	ds 1
PlayerSAtkLevel:: ; c6cf
	ds 1

wc6d0::
PlayerSDefLevel:: ; c6d0
	ds 1
PlayerAccLevel:: ; c6d1
	ds 1
PlayerEvaLevel:: ; c6d2
	ds 1
PlayerAbility:: ; c6d3
	ds 1
PlayerStatLevelsEnd::

EnemyStatLevels:: ; c6d4
; 07 neutral
EnemyAtkLevel:: ; c6d4
	ds 1
EnemyDefLevel:: ; c6d5
	ds 1
EnemySpdLevel:: ; c6d6
	ds 1
EnemySAtkLevel:: ; c6d7
	ds 1
EnemySDefLevel:: ; c6d8
	ds 1
EnemyAccLevel:: ; c6d9
	ds 1
EnemyEvaLevel:: ; c6da
	ds 1
EnemyAbility:: ; c6db
	ds 1
EnemyTurnsTaken:: ; c6dc
	ds 1
PlayerTurnsTaken:: ; c6dd
	ds 1

wBattleTurnTemp:: ; c6de
	ds 1

PlayerSubstituteHP:: ; c6df
	ds 1
EnemySubstituteHP:: ; c6e0
	ds 1

wUnusedPlayerLockedMove:: ds 1 ; c6e1
	ds 1
CurPlayerMove:: ; c6e3
	ds 1
CurEnemyMove:: ; c6e4
	ds 1

LinkBattleRNCount:: ; c6e5
; how far through the prng stream
	ds 1

wEnemyItemState:: ds 1 ; c6e6

	ds 2

CurEnemyMoveNum:: ; c6e9
	ds 1

wEnemyHPAtTimeOfPlayerSwitch:: ds 2 ; c6ea
wPayDayMoney:: ds 3 ; c6ec

wSafariMonAngerCount:: ds 1
wSafariMonEating:: ds 2

wEnemyBackupDVs:: ds 2; used when enemy is transformed

AlreadyDisobeyed:: ; c6f4
	ds 1
DisabledMove:: ; c6f5
	ds 1
EnemyDisabledMove:: ; c6f6
	ds 1

wWhichMonFaintedFirst:: ds 1

; exists so you can't counter on switch
LastEnemyCounterMove:: ; c6f8
	ds 1
LastPlayerCounterMove:: ; c6f9
	ds 1

wEnemyMinimized:: ds 1 ; c6fa

AlreadyFailed:: ; c6fb
	ds 1

wBattleParticipantsIncludingFainted:: ds 1 ; c6fc
wDanger:: ds 1 ; c6fd
wPlayerMinimized:: ds 1 ; c6fe
wPlayerScreens:: ; c6ff
; bit
; 4 reflect
; 3 light screen
; 2 safeguard
; 0 spikes
	ds 1

wEnemyScreens:: ; c700
; see wPlayerScreens
	ds 1

PlayerSafeguardCount:: ; c701
	ds 1
PlayerLightScreenCount:: ; c702
	ds 1
PlayerReflectCount:: ; c703
	ds 1

wTempAIAbility:: ; c704
	ds 1

EnemySafeguardCount:: ; c705
	ds 1
EnemyLightScreenCount:: ; c706
	ds 1
EnemyReflectCount:: ; c707
	ds 1

wEnemyAlreadyDisobeyed::
	ds 1

wBattleTurns::
	ds 1

Weather:: ; c70a
; 00 normal
; 01 rain
; 02 sun
; 03 sandstorm
; 04 hail
; 05 rain stopped
; 06 sunlight faded
; 07 sandstorm subsided
; 08 hail stopped
	ds 1

WeatherCount:: ; c70b
; # turns remaining
	ds 1

RaisedStat::
LoweredStat:: ; c70c
	ds 1
EffectFailed:: ; c70d
	ds 1
FailedMessage:: ; c70e
	ds 1
wEnemyGoesFirst:: ; c70f
	ds 1
wPlayerIsSwitching:: ds 1 ; c710
wEnemyIsSwitching::  ds 1 ; c711

PlayerUsedMoves:: ; c712
; add a move that has been used once by the player
; added in order of use
	ds NUM_MOVES

wEnemyAISwitchScore:: ds 1 ; c716
wEnemySwitchMonParam:: ds 1 ; c717
wEnemySwitchMonIndex:: ds 1 ; c718
wTempLevel:: ds 1 ; c719
LastPlayerMon:: ds 1 ; c71a
LastPlayerMove:: ; c71b
	ds 1
LastEnemyMove:: ; c71c
	ds 1

wPlayerFutureSightCount:: ds 1 ; c71d
wPlayerFutureSightLevel:: ds 1
wEnemyFutureSightCount:: ds 1 ; c71e
wEnemyFutureSightLevel:: ds 1
wGivingExperienceToExpShareHolders:: ds 1 ; c71f
wBackupEnemyMonBaseStats:: ds 5 ; c720
wBackupEnemyMonCatchRate:: db ; c725
wBackupEnemyMonBaseExp:: db ; c726
wPlayerFutureSightUsersSpAtk:: ds 2 ; c727
wEnemyFutureSightUsersSpAtk:: ds 2 ; c729
wPlayerRageCounter:: ds 1 ; c72b
wEnemyRageCounter:: ds 1 ; c72c
wBeatUpHitAtLeastOnce:: ds 1 ; c72d
wPlayerTrappingMove:: ds 1 ; c72e
wEnemyTrappingMove:: ds 1 ; c72f
wPlayerWrapCount:: ds 1 ; c730
wEnemyWrapCount:: ds 1 ; c731
wPlayerCharging:: ds 1 ; c732
wEnemyCharging:: ds 1 ; c733
BattleEnded:: ; c734
	ds 1

wWildMonMoves:: ds NUM_MOVES ; c735
wWildMonPP:: ds NUM_MOVES ; c739
wAmuletCoin:: ds 1 ; c73a
wSomeoneIsRampaging:: ds 1 ; c73b
wPlayerJustGotFrozen:: ds 1 ; c73c
wEnemyJustGotFrozen:: ds 1 ; c73d

wPlayerJustSentMonOut:: ds 1
wEnemyJustSentMonOut:: ds 1
wBattleEnd::
; Battle RAM

; c741
	ds wc6d0 - @
wTrademons::
wPlayerTrademon:: trademon wPlayerTrademon
wOTTrademon::     trademon wOTTrademon
wTrademonsEnd::
wTradeAnimPointer::
	ds 2
wLinkPlayer1Name:: ds NAME_LENGTH
wLinkPlayer2Name:: ds NAME_LENGTH
wLinkTradeSendmonSpecies:: ds 1
wLinkTradeGetmonSpecies:: ds 1
	ds wc6d0 - @

; naming screen
wNamingScreenDestinationPointer:: ds 2 ; c6d0
wNamingScreenCurrNameLength:: ds 1 ; c6d2
wNamingScreenMaxNameLength:: ds 1 ; c6d3
wNamingScreenType:: ds 1 ; c6d4
wNamingScreenCursorObjectPointer:: ds 2 ; c6d5
wNamingScreenLastCharacter:: ds 1 ; c6d7
wNamingScreenStringEntryCoord:: ds 2 ; c6d8
	ds wc6d0 - @

; pokegear
wPokegearMapCursorObjectPointer:: ds 2 ; c6d5
wPokegearMapCursorLandmark:: ds 1 ; c6d7
wPokegearMapPlayerIconLandmark:: ds 1 ; c6d8
	ds wc6d0 - @

wSlots::
; Slot Machine
; c6d0
wReel1:: slot_reel wReel1
wReel2:: slot_reel wReel2
wReel3:: slot_reel wReel3
; c700
wReel1Stopped:: ds 3
wReel2Stopped:: ds 3
wReel3Stopped:: ds 3
wSlotBias:: ds 1
wSlotBet:: ds 1
wFirstTwoReelsMatching:: ds 1
wFirstTwoReelsMatchingSevens:: ds 1
wSlotMatched:: ds 1
wCurrReelStopped:: ds 3
wPayout:: ds 2
wCurrReelXCoord:: ds 1
wCurrReelYCoord:: ds 1
	ds 2
wSlotBuildingMatch:: ds 1
wSlotsDataEnd::
	ds 28
wSlotsEnd::
	ds wSlots - @

; Card Flip
; c6d0
wCardFlip::
wDeck:: ds 24
wDeckEnd::
; c6e8
wCardFlipNumCardsPlayed:: ds 1
wCardFlipFaceUpCard:: ds 1
wDiscardPile:: ds 24
wDiscardPileEnd::
wCardFlipEnd::
	ds wCardFlip - @

; Dummy Game
; c6d0
wDummyGame::
wDummyGameCards:: ds 9 * 5
wDummyGameCardsEnd::
wDummyGameLastCardPicked:: ds 1 ; c6fd
wDummyGameCard1:: ds 1 ; c6fe
wDummyGameCard2:: ds 1 ; c6ff
wDummyGameCard1Location:: ds 1 ; c700
wDummyGameCard2Location:: ds 1 ; c701
wDummyGameNumberTriesRemaining:: ds 1 ; c702
wDummyGameCounter:: ds 1 ; c708
wDummyGameNumCardsMatched:: ds 1 ; c709
wDummyGameEnd::
	ds wDummyGame - @
; Unown Puzzle
wUnownPuzzle::
wPuzzlePieces::
	ds 6 * 6
wUnownPuzzleEnd::

	ds wDummyGame - @

; Bingo
; c6d0

wBingo::

wBingoCursorX:: ds 1
wBingoCursorY:: ds 1

wBingoCursorPointer:: ds 2

wBingoCurrentCell:: ds 1

wBingoEnd:: ds wBingo - @

wPokedexDataStart::
wPokedexOrder:: ds NUM_POKEMON
wPokedexOrderEnd:: ds 256 - NUM_POKEMON
wPokedexMetadata::
wDexListingScrollOffset:: ; offset of the first displayed entry from the start
	ds 1
wDexListingCursor::
	ds 1 ; Dex cursor
wDexListingEnd::
	ds 1 ; Last mon to display
wDexListingHeight:: ; number of entries displayed at once in the dex listing
	ds 1
; wCurrentDexMode::   ; Pokedex Mode
	ds 1 ; Index of the topmost visible item in a scrolling menu
wDexSearchMonType1:: ds 1 ; first type to search
wDexSearchMonType2:: ds 1 ; second type to search
wDexSearchResultCount:: ds 1
wDexArrowCursorPosIndex:: ds 1
wDexArrowCursorDelayCounter:: ds 1
wDexArrowCursorBlinkCounter:: ds 1
wDexSearchSlowpokeFrame:: ds 1
wUnlockedUnownMode:: ds 1
wDexCurrentUnownIndex:: ds 1
wDexUnownCount:: ds 1

wDexConvertedMonType:: ds 1 ; mon type converted from dex search mon type
wSearchBackupDexListingScrollOffset:: ds 1
wSearchBackupDexListingCursor:: ds 1
wBackupDexListingCursor::
	ds 1
wBackupDexListingPage::
	ds 1
wDexCurrentLocation::
	ds 1
wPokedexStatus::
	ds 1
wPokedexDataEnd::
	ds 2

wMiscEnd::

CurrentDamageData::
wCurDamage:: ds 2 ; c7e8
wCurDamageMovePowerNumerator:: ds 2 ; c7ea
wCurDamageMovePowerDenominator:: ds 1 ; c7ec
wCurDamageLevel:: ds 1 ; c7ed
wCurDamageItemModifier:: ds 1 ; c7ee
wCurDamageFlags:: ds 1 ; c7ef - bit 7: fixed damage, bit 6: dirty, bit 5-4: x1.5 damage mods (critical hits), bit 1-0: x1.5 attack mods
wCurDamageFixedValue::
wCurDamageAttack:: ds 2 ; c7f0
wCurDamageDefense:: ds 2 ; c7f2
wCurDamageShiftCount:: ds 1 ; c7f4 - signed!
wCurDamageRandomVariance:: ds 1 ; c7f5 - complemented (variance: *(255 - this value)/255)
wCurDamageModifierNumerator:: ds 3 ; c7f6
wCurDamageModifierDenominator:: ds 2 ; c7f9
CurrentDamageDataEnd::

wWildMonCustomItem::
	ds 1

wWildMonCustomMoves::
	ds NUM_MOVES

SECTION "Overworld Map", WRAM0 [$c800]

OverworldMap:: ; c800
	ds 1300
OverworldMapEnd::
	ds OverworldMap - @

wBillsPCPokemonList::
; Pokemon, box number, list index

wMysteryGiftPartyTemp:: ; ds PARTY_LENGTH * (1 + 1 + NUM_MOVES)
wMysteryGiftStaging::

wLinkData:: ; ds $514
wLinkPlayerName:: ds NAME_LENGTH
wLinkPartyCount:: ds 1
wLinkPartySpecies:: ds PARTY_LENGTH
wLinkPartySpeciesEnd:: ds 1

wTimeCapsulePlayerData::
wTimeCapsulePartyMon1:: red_party_struct wTimeCapsulePartyMon1
wTimeCapsulePartyMon2:: red_party_struct wTimeCapsulePartyMon2
wTimeCapsulePartyMon3:: red_party_struct wTimeCapsulePartyMon3
wTimeCapsulePartyMon4:: red_party_struct wTimeCapsulePartyMon4
wTimeCapsulePartyMon5:: red_party_struct wTimeCapsulePartyMon5
wTimeCapsulePartyMon6:: red_party_struct wTimeCapsulePartyMon6
wTimeCapsulePartyMonOTNames:: ds PARTY_LENGTH * NAME_LENGTH
wTimeCapsulePartyMonNicks:: ds PARTY_LENGTH * PKMN_NAME_LENGTH
wTimeCapsulePlayerDataEnd::
	ds wTimeCapsulePlayerData - @

wLinkPlayerData::
wLinkPlayerPartyMon1:: party_struct wLinkPlayerPartyMon1
wLinkPlayerPartyMon2:: party_struct wLinkPlayerPartyMon2
wLinkPlayerPartyMon3:: party_struct wLinkPlayerPartyMon3
wLinkPlayerPartyMon4:: party_struct wLinkPlayerPartyMon4
wLinkPlayerPartyMon5:: party_struct wLinkPlayerPartyMon5
wLinkPlayerPartyMon6:: party_struct wLinkPlayerPartyMon6
wLinkPlayerPartyMonOTNames:: ds PARTY_LENGTH * NAME_LENGTH
wLinkPlayerPartyMonNicks:: ds PARTY_LENGTH * PKMN_NAME_LENGTH
wLinkPlayerDataEnd::
	ds $35d

wLinkDataEnd::
	ds wLinkData - @

wc800::	ds 1
wc801:: ds 1
wc802:: ds 1
wc803:: ds 4
wc807:: ds 7
wc80e:: ds 1
wc80f:: ds 1
wc810:: ds 1
wc811:: ds 1
wc812:: ds 1
wc813:: ds 1
wc814:: ds 4
wc818:: ds 8
wc820:: ds 1
wc821:: ds 15
wc830:: ds 16
wc840:: ds 16
wMysteryGiftTrainerData:: ds (1 + 1 + NUM_MOVES) * PARTY_LENGTH + 2
wMysteryGiftTrainerDataEnd::
	ds wMysteryGiftTrainerData - @
wc850:: ds 16
wc860:: ds 16
wc870:: ds 16
wc880:: ds 16
wc890:: ds 16
wc8a0:: ds 16
wc8b0:: ds 16
wc8c0:: ds 16
wc8d0:: ds 16
wc8e0:: ds 16
wc8f0:: ds 16

wMysteryGiftPartnerData::
wc900:: ds 1
wMysteryGiftPartnerID:: ds 2
wMysteryGiftPartnerName:: ds NAME_LENGTH
wMysteryGiftPartnerDexCaught:: ds 1
wc90f::
wMysteryGiftPartnerSentDeco:: ds 1
wMysteryGiftPartnerWhichItem:: ds 1
wMysteryGiftPartnerWhichDeco:: ds 1
wMysteryGiftPartnerBackupItem:: ds 2
wMysteryGiftPartnerDataEnd::
	ds 60

wMysteryGiftPlayerData:: ds 1
wMysteryGiftPlayerID:: ds 2
wMysteryGiftPlayerName:: ds NAME_LENGTH
wMysteryGiftPlayerDexCaught:: ds 1
wMysteryGiftPlayerSentDeco:: ds 1
wMysteryGiftPlayerWhichItem:: ds 1
wMysteryGiftPlayerWhichDeco:: ds 1
wMysteryGiftPlayerBackupItem:: ds 2
wMysteryGiftPlayerDataEnd::
	ds 144

wc9f4:: ds 12

wCreditsFaux2bpp::
wca00:: ds 1
wca01:: ds 1
wca02::
	ds 126

wca80:: ds 1
wca81:: ds 1

; Gameboy Printer
wPrinterData1:: ds 1
wPrinterData2:: ds 1
wPrinterData3:: ds 1
wPrinterData4:: ds 1
wPrinterData5:: ds 1
wPrinterData6:: ds 1

wPrinterStatus1:: ds 1
wPrinterStatus2::
; bit 7: set if error 1
; bit 6: set if error 4
; bit 5: set if error 3
	ds 1

wca8a:: ds 1
wPrinterDelay:: ds 1
wca8c:: ds 1
wca8d:: ds 1
wca8e:: ds 1
wca8f:: ds 1

; tilemap backup?
wca90:: ds 16
wcaa0:: ds 3
wcaa3:: ds 2
wcaa5:: ds 11
wcab0:: ds 5
wcab5:: ds 10
wcabf:: ds 1
wcac0:: ds 9
wcac9:: ds 7
wcad0:: ds 16
wcae0:: ds 16
wcaf0:: ds 16
wcb00:: ds 8
wcb08:: ds 6
wcb0e:: ds 5
wcb13:: ds 9
wcb1c:: ds 14
wBillsPC_ScrollPosition:: ds 1
wBillsPC_CursorPosition:: ds 1
wBillsPC_NumMonsInBox:: ds 1
wBillsPC_NumMonsOnScreen:: ds 1
wBillsPC_LoadedBox:: ds 1 ; 0 if party, 1 - 14 if box, 15 if active box
wBillsPC_BackupScrollPosition:: ds 1
wBillsPC_BackupCursorPosition:: ds 1
wBillsPC_BackupLoadedBox:: ds 1
	ds 19
wcb45:: ds 20
wcb59:: ds 20
wcb6d:: ds 1
wcb6e:: ds 22
wcb84:: ds 100
wcbe8:: dw
wLinkOTPartyMonTypes::
	ds 2 * PARTY_LENGTH
	ds 2

wPrinterTextIndex::
wcbf8:: ds 2
wcbfa:: ds 1
wcbfb:: ds 1
; 292 bytes unallocated (still used by overworld map)

SECTION "Credits WRAM", WRAM0 [$cd20]
CreditsPos::
	ds 2
CreditsTimer:: ; cd22
	ds 1

	ds CreditsPos - @

BGMapBuffer::
	ds 40
BGMapPalBuffer:: ; cd48
	ds 40

BGMapBufferPtrs:: ; cd70
; 20 bg map addresses (16x8 tiles)
	ds 40

PlayerHPPal:: ; cd99
	ds 1
EnemyHPPal:: ; cd9a
	ds 1

wHPPals:: ds PARTY_LENGTH
wcda1:: ds 1

LCD:: ds 15
wLCDCPointer:: ds 25

	ds 16

AttrMap:: ; cdd9
; 20x18 grid of palettes for 8x8 tiles
; read horizontally from the top row
; bit 3: vram bank
; bit 0-2: palette id
	ds SCREEN_WIDTH * SCREEN_HEIGHT
AttrMapEnd::
wTileAnimBuffer::
	ds $10
; addresses dealing with serial comms
wOtherPlayerLinkMode:: ds 1
wOtherPlayerLinkAction:: ds 4
wPlayerLinkAction:: ds 1
wcf57:: ds 4
wcf5b:: ds 1
wcf5c:: ds 1
wcf5d:: ds 2

wMonType:: ; cf5f
	ds 1

wCurSpecies:: ; cf60
wCurMove::
	ds 1

wNamedObjectTypeBuffer::
	ds 1
	
SGBPredef::
	ds 1

wJumptableIndex::
wBattleTowerBattleEnded::
wcf63::
	ds 1

wNrOfBeatenBattleTowerTrainers::
wMomBankDigitCursorPosition::
wIntroSceneFrameCounter::
wHoldingUnownPuzzlePiece::
wCardFlipCursorY::
wCreditsBorderFrame::
wDexEntryPrevJumptableIndex::
wDatesetYear::
wcf64::
	ds 1

wCreditsBorderMon::
wTitleScreenTimerLo::
wUnownPuzzleCursorPosition::
wCardFlipCursorX::
wCurrPocket::
wDatesetMonth::
wcf65::
	ds 1

wCreditsLYOverride::
wTitleScreenTimerHi::
wUnownPuzzleHeldPiece::
wCardFlipWhichCard::
wDatesetDay::
wcf66::
	ds 1

wDatesetMonthLength::
wcf67::
	ds 1
wcf68::
	ds 1
wcf69::
	ds 1
wMoveIsAnAbility::
	ds 1
wSGBPals::
	ds 1

wFadeCounterBeforeDelay::
	ds 1
wFadeReloadValue::
	ds 1

	ds 3

wWindowStackPointer:: dw ; cf71
wMenuJoypad:: ds 1   ; cf73
wMenuSelection:: ds 1 ; cf74
MenuSelectionQuantity:: ds 1 ; cf75
wWhichIndexSet:: ds 1
wScrollingMenuCursorPosition:: ds 1
wWindowStackSize:: ds 9

; menu data header
wMenuDataHeader:: ; cf81
wMenuFlags:: ds 1
; bit 7&6: When set, don't push the tiles behind the menu
; bit 4: When set, set bit 6 of w2DMenuFlags1 (Play sprite animations)
; bit 3: When set, don't play the click SFX
; bit 1: When set, push one extra tile length from each side.
; bit 0: When set, don't restore tile backup for exit menu. May be written in _PushWindow (unsure)

wMenuBorderTopCoord:: ds 1
wMenuBorderLeftCoord:: ds 1
wMenuBorderBottomCoord:: ds 1
wMenuBorderRightCoord:: ds 1
wMenuData2Pointer:: ds 2
wMenuCursorBuffer:: ds 2
; end menu data header
wMenuDataBank:: ds 1 ; menu data bank?
	ds 6
wMenuDataHeaderEnd::

wMenuData2::
wMenuData2Flags:: ds 1 ; cf91
; bit 7: When set, start printing text one tile to the right of the border
;        In scrolling menus, SELECT is functional
; bit 6: When clear, start printing text one tile below the border
;        In scrolling menus, START is functional
; bit 5: In scrolling menus, call function #3 when a new item is selected
; bit 4: In scrolling menus, display arrows showing the scrolling directions
; bit 3: When set, SELECT is functional
;        In scrolling menus, LEFT is functional
; bit 2: When set, L/R are functional
;        In scrolling menus, RIGHT is functional
; bit 1: Enable Select button
;        In scrolling menus, call function #3 (if bit 5 allows it) even if the same item is being selected
; bit 0: Disable B button
;        In scrolling menus, call function #1 when Cancel is to be displayed

wMenuData2_ScrollingMenuHeight::
wMenuData2Items::
	ds 1 ; cf92
wMenuData2IndicesPointer::
wMenuData2Spacing::
wMenuData2_ScrollingMenuWidth::
	ds 1 ; cf93
wMenuData2_2DMenuItemStringsBank::
wMenuData2_ScrollingMenuSpacing::
	ds 1 ; cf94
wMenuData2_2DMenuItemStringsAddr::
wMenuData2DisplayFunctionPointer::
wMenuData2_ItemsPointerBank::
	ds 1 ; cf95
wMenuData2_ItemsPointerAddr::
	ds 1 ; cf96
wMenuData2PointerTableAddr::
wMenuData2_2DMenuFunctionBank::
	ds 1 ; cf97
wMenuData2_2DMenuFunctionAddr::
wMenuData2_ScrollingMenuFunction1::
	ds 3 ; cf98
wMenuData2_ScrollingMenuFunction2::
	ds 3 ; cf9b
wMenuData2_ScrollingMenuFunction3::
	ds 3 ; cf9e
wMenuData2End::

wMenuData3::
w2DMenuCursorInitY:: ds 1 ; cfa1
w2DMenuCursorInitX:: ds 1 ; cfa2
w2DMenuNumRows:: ds 1 ; cfa3
w2DMenuNumCols:: ds 1 ; cfa4
w2DMenuFlags1:: ds 1 ; cfa5
w2DMenuFlags2:: ds 1 ; cfa6
w2DMenuCursorOffsets:: ds 1 ; cfa7
wMenuJoypadFilter:: ds 1 ; cfa8
wMenuData3End::

wMenuCursorY:: ds 1 ; cfa9
wMenuCursorX:: ds 1 ; cfaa
wCursorOffCharacter:: ds 1 ; cfab
wCursorCurrentTile:: ds 2 ; cfac
wAmountOfCurItem::
	ds 2

wGenericDelay:: ; cfb0
	ds 1
wOverworldDelay:: ; cfb1
	ds 1
wTextDelayFrames:: ; cfb2
	ds 1
wVBlankOccurred:: ; cfb3
	ds 1

wRNGState:: ds 4
wRNGCumulativeDividerPlus:: ds 2
wRNGCumulativeDividerMinus:: ds 1

wcfbb:: ds 1

GameTimerPause:: ; cfbc
; bit 0
	ds 1

wTemporaryScriptVariable:: ds 1

wcfbe::
; SGB flags?
	ds 2

InBattleTowerBattle:: ; cfc0
; 0 not in BattleTower-Battle
; 1 BattleTower-Battle
	ds 1

wInitialLY:: ds 1 ; cfc1

FXAnimID::
FXAnimIDLo:: ; cfc2
	ds 1
FXAnimIDHi:: ; cfc3
	ds 1
wPlaceBallsX:: ; cfc4
	ds 1
wPlaceBallsY:: ; cfc5
	ds 1
TileAnimationTimer:: ; cfc6
	ds 1

; palette backups?
wBGP:: ds 1
wOBP0:: ds 1
wOBP1:: ds 1

wNumHits:: ds 2

wOptions:: ; cfcc
; bit 0-2: number of frames to delay when printing text
;   fast 1; mid 3; slow 5
; bit 3: ?
; bit 4: no text delay
; bit 5: stereo off/on
; bit 6: battle style shift/set
; bit 7: battle scene off/on
	ds 1

wSaveFileExists:: ds 1

TextBoxFrame:: ; cfce
; bits 0-2: textbox frame 0-7
	ds 1
TextBoxFlags::
	ds 1

GBPrinter:: ; cfd0
; bit 0-6: brightness
;   lightest: $00
;   lighter:  $20
;   normal:   $40 (default)
;   darker:   $60
;   darkest:  $7F
	ds 1

wOptions2:: ; cfd1
; bit 1: menu account off/on
	ds 1

	ds 2
OptionsEnd::

; Time buffer, for counting the amount of time since
; an event began.

wSecondsSince:: ds 1
wMinutesSince:: ds 1
wHoursSince:: ds 1
wDaysSince:: ds 1

wBattlePlayerSkinTone:: ds 4 ;cfd8

; Each bit controls whether the corresponding stopwatch is running or stopped.
wStopwatchControl:: ds 1 ;cfdc

	ds 3 ;cfdd, AVAILABLE

wDebugMenuCurrentMenu:: ds 2 ;cfe0
wDebugMenuNextMenu:: ds 2 ;cfe2
wDebugMenuFlags:: ds 1 ;cfe4
wDebugMenuOptionCount:: ds 1 ;cfe5
wDebugMenuCurrentOption:: ds 1 ;cfe6
wDebugMenuParameter:: ds 1 ;cfe7

wDummyGameLastMatches:: ds 5
	ds wDummyGameLastMatches - @

wDebugMenuScratchSpace:: ds 24 ;cfe8


wRAM0End:: ; d000


SECTION "WRAM 1", WRAMX, BANK [1]

wd000:: ds 1
DefaultSpawnpoint::
wd001:: ds 1

; d002

wBufferMonNick:: ds PKMN_NAME_LENGTH
wBufferMonOT:: ds NAME_LENGTH
wBufferMon:: party_struct wBufferMon
	ds 8
wMonOrItemNameBuffer::
	ds wBufferMonNick - @

wMovementBufferCount:: ds 1
wMovementBufferPerson:: ds 1
wMovementBufferUnknD004:: ds 1
wMovementBufferPointer:: dw
MovementBuffer:: ds 16 ; d007
	ds wMovementBufferCount - @

LuckyNumberDigit1Buffer:: ds 1
LuckyNumberDigit2Buffer:: ds 1
LuckyNumberDigit3Buffer:: ds 1
LuckyNumberDigit4Buffer:: ds 1
LuckyNumberDigit5Buffer:: ds 1
	ds LuckyNumberDigit1Buffer - @

wTowerArcadePartyCount:: ds 1
wSelectedParty:: ds 3
wTowerArcadePartyEnd::
	ds wTowerArcadePartyCount - @

InitalFlypoint::

wd002::
wWeekdayAtStartOfMonth::
wBattleTempExpPoints::
wTempDayOfWeek::
wApricorns::
	ds 1
wd003::
wCurMonthLength::
wPlaceBallsDirection::
	ds 1
wd004::
wTrainerHUDTiles::
	ds 1
wd005::
StartFlypoint:: ; d005
	ds 1
wd006::
EndFlypoint:: ; d006
	ds 1
wd007::
	ds 1
	ds wd002 - @

wMartItem1BCD:: ds 3
wMartItem2BCD:: ds 3
wMartItem3BCD:: ds 3
wMartItem4BCD:: ds 3
wMartItem5BCD:: ds 3
wMartItem6BCD:: ds 3
wMartItem7BCD:: ds 3
wMartItem8BCD:: ds 3
wMartItem9BCD:: ds 3
wMartItem10BCD:: ds 3
wMartItemBCDEnd::
	ds 13
wd02d:: ds 1
wd02e:: ds 1
wd02f:: ds 1
wd030:: ds 1
wd031:: ds 1
wd032:: ds 1
wd033:: ds 1
wd034:: ds 2
wd036:: ds 2
wd038:: ds 3
wd03b:: ds 3

; d03e

wTempFacingTile::
CurFruitTree:: ds 1
CurFruit:: ds 1
	ds CurFruitTree - @ ; d03e

wElevatorPointerBank:: ds 1
wElevatorPointer:: ; dw
wElevatorPointerLo:: ds 1
wElevatorPointerHi:: ds 1
wElevatorOriginFloor:: ds 1
	ds wElevatorPointerBank - @ ; d03e

wCurSignpostYCoord:: ds 1
wCurSignpostXCoord:: ds 1
wCurSignpostType:: ds 1
wCurSignpostScriptAddr:: dw
	ds wCurSignpostYCoord - @ ; d03e

wCurSignpostItemFlag:: dw
wCurSignpostItemID:: ds 1
	ds wCurSignpostItemFlag - @ ; d03e

wCurCoordEventTriggerID:: ds 1
wCurCoordEventMapY:: ds 1
wCurCoordEventMapX:: ds 1
	ds 1 ; unused
wCurCoordEventScriptAddr:: dw
	ds 2 ; unused
	ds wCurCoordEventTriggerID - @ ; d03e

wCurItemBallContents:: ds 1
wCurItemBallQuantity:: ds 1
	ds wCurItemBallContents - @ ; d03e

wTempTrainerBank:: ds 1
wTempTrainerDistance:: ds 1
wTempTrainerFacing:: ds 1
wTempTrainerHeader::
wTempTrainerEventFlag:: ds 2
wTempTrainerClass:: ds 1
wTempTrainerID:: ds 1
wSeenTextPointer:: dw
wWinTextPointer:: dw
wLossTextPointer:: dw
wScriptAfterPointer:: dw
	ds wTempTrainerBank - @

wLoadSignpostScriptBuffer::
wMenuItemsList::
CurInput::
EngineBuffer1:: ; d03e
	ds 1

wd03f::
wJumpStdScriptBuffer::
MartPointerBank::
EngineBuffer2::
	ds 1

wd040::
MartPointer:: ; d040
EngineBuffer3::
	ds 1

wd041::
EngineBuffer4::
	ds 1

MovementAnimation:: ; d042
EngineBuffer5::
	ds 1

WalkingDirection:: ; d043
wBargainShopFlags::
	ds 1

FacingDirection:: ; d044
	ds 1

WalkingX::
wMartMenuCursorBuffer:: ; d045
wScrollingMenuCursorBuffer::
	ds 1
WalkingY:: ; d046
wMartMenuScrollPosition::
wScrollingMenuScrollPosition::
	ds 1

WalkingTile:: ; d047
	ds 1
	
	ds 3

wWinTextBank::
	ds 1
wLossTextBank::
	ds 1

wRunningTrainerBattleScript:: ds 1
wMenuItemsListEnd::
wTempTrainerHeaderEnd::
wPlayerMovementDirection:: ds 24
wTMHMMoveNameBackup:: ds MOVE_NAME_LENGTH

wStringBuffer1:: ; d073
	ds 19

wStringBuffer2:: ; d086
	ds 19

wStringBuffer3:: ; d099
	ds 19

wStringBuffer4:: ; d0ac
	ds 19

wScriptBuffer:: ; d0bf
; dedicated buffer of 19 bytes to store whatever in scripts
	ds 19

wd0d2:: ds 2

CurBattleMon:: ; d0d4
	ds 1
CurMoveNum:: ; d0d5
	ds 1

wLastPocket:: ds 1

wPCItemMenuCursor:: ds 1
wPartyMenuCursor:: ds 1
wItemsPocketCursor:: ds 1
wKeyItemsPocketCursor:: ds 1
wBallsPocketCursor:: ds 1
wTMHMPocketCursor:: ds 1

wPCItemScrollPosition:: ds 1
	ds 1
wItemsPocketScrollPosition:: ds 1
wKeyItemsPocketScrollPosition:: ds 1
wBallsPocketScrollPosition:: ds 1
wTMHMPocketScrollPosition:: ds 1

wMoveSwapBuffer::
wSwitchMon::
wSwitchItem::
	ds 1

wMenuScrollPosition:: ds 4
wQueuedScriptBank:: ds 1
wQueuedScriptAddr:: ds 2
wNumMoves:: ds 1 ; returned to by ListMoves predef
wFieldMoveSucceeded::
wItemEffectSucceeded::
wPlayerAction::
; 0 - use move
; 1 - use item
; 2 - switch
wSolvedUnownPuzzle::
	ds 1 ; d0ec

VramState:: ; d0ed
; bit 0: overworld sprite updating on/off
; bit 6: something to do with text
; bit 7: on when surf initiates
;        flickers when climbing waterfall
	ds 1

wBattleResult:: ds 1
wUsingItemWithSelect:: ds 1

CurMart::
CurElevator:: ds 1
CurElevatorFloors:: ds 21

wCurItem:: ; d106
	ds 1

wCurItemQuantity:: ; d107
wMartItemID::
	ds 1

wCurPartySpecies:: ; d108
	ds 1

wCurPartyMon:: ; d109
; contains which monster in a party
; is being dealt with at the moment
; 0-5
	ds 1

wWhichHPBar::
; 0: Enemy
; 1: Player
	ds 1
wPokemonWithdrawDepositParameter::
; 0: Take from PC
; 1: Put into PC
; 2: Take from Daycare
; 3: Put into Daycare
	ds 1
wItemQuantityChangeBuffer:: ds 1
wItemQuantityBuffer:: ds 1

TempMon:: ; d10e
	party_struct TempMon

wSpriteFlags:: ; d13e
; no facings if set
	ds 1

wHandlePlayerStep:: ds 2 ; d13f

wPartyMenuActionText:: ; d141
	ds 1

wItemAttributeParamBuffer:: ; d142
	ds 1

CurPartyLevel:: ; d143
	ds 1

wScrollingMenuListSize:: ; d144
	ds 1

	ds 1

; used when following a map warp
; d146
wNextWarp:: ds 1
wNextMapGroup:: ds 1
wNextMapNumber:: ds 1
wPrevWarp:: ds 1
wPrevMapGroup:: ds 1
wPrevMapNumber:: ds 1
; d14c

wMapObjectGlobalOffsetX:: ds 1 ; used in FollowNotExact
wMapObjectGlobalOffsetY:: ds 1 ; used in FollowNotExact

; Player movement
wPlayerStepVectorX:: ds 1   ; d14e
wPlayerStepVectorY:: ds 1   ; d14f
wPlayerStepFlags:: ds 1     ; d150
; bit 7: Start step
; bit 6: Stop step
; bit 5: Doing step
; bit 4: In midair
; bits 0-3: unused
wPlayerStepDirection:: ds 1 ; d151

wBGMapAnchor:: ds 2 ; d152

UsedSprites:: ; d154
; sprite ID, start tile
	ds 32 * 2
UsedSpritesEnd::

wOverworldMapAnchor:: dw ; d194
wMetatileStandingY:: ds 1 ; d196
wMetatileStandingX:: ds 1 ; d197
wSecondMapHeaderBank:: ds 1 ; d198
wTileset:: ds 1 ; d199
wPermission:: ds 1 ; d19a
wSecondMapHeaderAddr:: dw ; d19b

; width/height are in blocks (2x2 walkable tiles, 4x4 graphics tiles)
MapHeader:: ; d19d
MapBorderBlock:: ; d19d
	ds 1
MapHeight:: ; d19e
	ds 1
MapWidth:: ; d19f
	ds 1
MapBlockDataBank:: ; d1a0
	ds 1
MapBlockDataPointer:: ; d1a1
	ds 2
MapScriptHeaderBank:: ; d1a3
	ds 1
MapScriptHeaderPointer:: ; d1a4
	ds 2
MapEventHeaderPointer:: ; d1a6
	ds 2
; bit set
MapConnections:: ; d1a8
	ds 1
NorthMapConnection:: ; d1a9
NorthConnectedMapGroup:: ; d1a9
	ds 1
NorthConnectedMapNumber:: ; d1aa
	ds 1
NorthConnectionStripPointer:: ; d1ab
	ds 2
NorthConnectionStripLocation:: ; d1ad
	ds 2
NorthConnectionStripLength:: ; d1af
	ds 1
NorthConnectedMapWidth:: ; d1b0
	ds 1
NorthConnectionStripYOffset:: ; d1b1
	ds 1
NorthConnectionStripXOffset:: ; d1b2
	ds 1
NorthConnectionWindow:: ; d1b3
	ds 2

SouthMapConnection:: ; d1b5
SouthConnectedMapGroup:: ; d1b5
	ds 1
SouthConnectedMapNumber:: ; d1b6
	ds 1
SouthConnectionStripPointer:: ; d1b7
	ds 2
SouthConnectionStripLocation:: ; d1b9
	ds 2
SouthConnectionStripLength:: ; d1bb
	ds 1
SouthConnectedMapWidth:: ; d1bc
	ds 1
SouthConnectionStripYOffset:: ; d1bd
	ds 1
SouthConnectionStripXOffset:: ; d1be
	ds 1
SouthConnectionWindow:: ; d1bf
	ds 2

WestMapConnection:: ; d1c1
WestConnectedMapGroup:: ; d1c1
	ds 1
WestConnectedMapNumber:: ; d1c2
	ds 1
WestConnectionStripPointer:: ; d1c3
	ds 2
WestConnectionStripLocation:: ; d1c5
	ds 2
WestConnectionStripLength:: ; d1c7
	ds 1
WestConnectedMapWidth:: ; d1c8
	ds 1
WestConnectionStripYOffset:: ; d1c9
	ds 1
WestConnectionStripXOffset:: ; d1ca
	ds 1
WestConnectionWindow:: ; d1cb
	ds 2

EastMapConnection:: ; d1cd
EastConnectedMapGroup:: ; d1cd
	ds 1
EastConnectedMapNumber:: ; d1ce
	ds 1
EastConnectionStripPointer:: ; d1cf
	ds 2
EastConnectionStripLocation:: ; d1d1
	ds 2
EastConnectionStripLength:: ; d1d3
	ds 1
EastConnectedMapWidth:: ; d1d4
	ds 1
EastConnectionStripYOffset:: ; d1d5
	ds 1
EastConnectionStripXOffset:: ; d1d6
	ds 1
EastConnectionWindow:: ; d1d7
	ds 2


TilesetHeader::
TilesetBank:: ; d1d9
	ds 1
TilesetAddress:: ; d1da
	ds 2
TilesetBlocksBank:: ; d1dc
	ds 1
TilesetBlocksAddress:: ; d1dd
	ds 2
TilesetCollisionBank:: ; d1df
	ds 1
TilesetCollisionAddress:: ; d1e0
	ds 2
TilesetAnim:: ; d1e2
; bank 3f
	ds 2
; unused ; d1e4
	ds 2
TilesetPalettes:: ; d1e6
; bank 3f
	ds 2

EvolvableFlags:: ; d1e8
	flag_array PARTY_LENGTH

wForceEvolution:: ds 1

wCurHPAnimMaxHP::   dw ; d1ea
wCurHPAnimOldHP::   dw ; d1ec
wCurHPAnimNewHP::   dw ; d1ee
wCurHPAnimPal::     db ; d1f0
wCurHPBarPixels::   db ; d1f1
wNewHPBarPixels::   db ; d1f2
wCurHPAnimDeltaHP:: dw ; d1f3
wCurHPAnimLowHP::   db ; d1f5
wCurHPAnimHighHP::  db ; d1f6
	ds wCurHPAnimMaxHP - @

wItemfinderSignpostsBank:: ds 1
wItemfinderSignpostsCount:: ds 1
wItemfinderScreenBottom:: ds 1
wItemfinderScreenRight:: ds 1
	ds wItemfinderSignpostsBank - @

wEvolutionPrevSpecies:: ds 1
wEvolutionNewSpecies:: ds 1
wEvolutionFrontpicTileOffset:: ds 1
wEvolutionCanceled:: ds 1
	ds wEvolutionPrevSpecies - @

wCustomizationExpandedPal:: ds 3
wSavedPlayerCharacteristics:: ds 5 ; wPlayerCharacteristicsEnd - wPlayerCharacteristics
	ds wCustomizationExpandedPal - @

wExpToNextLevel:: ds 3
wTotalExpToNextLevel:: ds 3
	ds wExpToNextLevel - @

wCurMagikarpLengthFeet:: ds 1
wCurMagikarpLengthInches:: ds 1
	ds wCurMagikarpLengthFeet - @

wClockResetCurrentField:: ds 1
wClockResetPreviousField:: ds 1
wClockResetYCoord:: ds 1
wClockResetWeekday:: ds 1
wClockResetHours:: ds 1
wClockResetMinutes:: ds 1
	ds wClockResetCurrentField - @

wWhiteOutFlags:: ds 1
wTrainerNotes_EncounterLevel:: ds 1
	ds wWhiteOutFlags - @

wBattleTowerLegalPokemonFlags::
wBattleArcadeMenuCursorBuffer::
wListMoves_Spacing::
wFillMoves_IsPartyMon:: ds 1
wSwitchMon1:: ds 1
wSwitchMon2:: ds 1
	ds wListMoves_Spacing - @

wCatchMon_CatchRate:: ds 1
wCatchMon_NumShakes:: ds 1
wCatchMon_Critical:: ds 1
	ds wCatchMon_CatchRate - @

wPPUpPPBuffer::

wTrainerHUD_BallIcons:: ds PARTY_LENGTH
	ds wTrainerHUD_BallIcons - @

wMonSubmenuItemsCount::
wPlayerOwnedApricornsCount:: ds 1
wMonSubmenuItems::
wPlayerOwnedApricornsList:: ds 10
	ds wPlayerOwnedApricornsCount - @

wItemPCQuantityDeltaBackup:: ds 1
wItemPCQuantityBackup:: ds 1
	ds wItemPCQuantityDeltaBackup - @

wTempMysteryGiftTimer::
wCurItemPrice:: ds 2
	ds wCurItemPrice - @

wTreeCoordScore:: ds 1
wTreeIDScore:: ds 1
	ds wTreeCoordScore - @

wHealMachineAnimType:: ds 1
wHealMachineOBPBackup:: ds 1
wHealMachineRoutineIDX:: ds 1
	ds wHealMachineAnimType - @

wLuckyNumberCurIDBuffer:: ds 5
	ds wLuckyNumberCurIDBuffer - @

wFieldMoveBufferSpace::
wFieldMoveJumptableIndex:: ds 1
wFieldMoveSurfType::
wFieldMoveEscapeType::
wRodType:: ds 1
wFieldMoveCutTileLocation:: ds 2
wFieldMoveCutTileReplacement:: ds 1
wFieldMovePokepicSpecies::
wFishResponse:: ds 1
wWhichCutAnimation:: ds 1
wFieldMoveBufferSpaceEnd::

wAI_CurrentItem:: ds 1
	ds 1
wLinkBuffer_D1F3::
	ds 3
wTempTrainerType::
	ds 4

LinkBattleRNs:: ; d1fa
	ds 10


TempNumber::
TempEnemyMonSpecies::  ds 1 ; d204
TempBattleMonSpecies:: ds 1 ; d205

EnemyMon:: battle_struct EnemyMon ; d206
EnemyMonBaseStats:: ds 5 ; d226
EnemyMonCatchRate:: db ; d22b
EnemyMonBaseExp::   db ; d22c
EnemyMonEnd::


wBattleMode:: ; d22d
; 0: overworld
; 1: wild battle
; 2: trainer battle
	ds 1

TempWildMonSpecies:: ds 1
OtherTrainerClass:: ; d22f
; class (Youngster, Bug Catcher, etc.) of opposing trainer
; 0 if opponent is a wild Pokémon, not a trainer
	ds 1

wBattleType:: ; d230
; $00 normal
; $01 can lose
; $02 debug
; $03 dude/tutorial
; $04 fishing
; $05 roaming
; $06 contest
; $07 shiny
; $08 headbutt/rock smash
; $09 trap
; $0a force Item1
; $0b celebi
; $0c suicune
	ds 1

OtherTrainerID:: ; d231
; which trainer of the class that you're fighting
; (Joey, Mikey, Albert, etc.)
	ds 1

wForcedSwitch:: ds 1

TrainerClass:: ; d233
	ds 1

UnownLetter:: ; d234
	ds 1

wMoveSelectionMenuType:: ds 1

CurBaseData:: ; d236
BaseDexNo:: ; d236
	ds 1
BaseStats:: ; d237
BaseHP:: ; d237
	ds 1
BaseAttack:: ; d238
	ds 1
BaseDefense:: ; d239
	ds 1
BaseSpeed:: ; d23a
	ds 1
BaseSpecialAttack:: ; d23b
	ds 1
BaseSpecialDefense:: ; d23c
	ds 1
BaseType:: ; d23d
BaseType1:: ; d23d
	ds 1
BaseType2:: ; d23e
	ds 1
BaseCatchRate:: ; d23f
	ds 1
BaseExp:: ; d240
	ds 1
BaseItems:: ; d241
	ds 2
BaseGender:: ; d243
	ds 1
BaseUnknown1:: ; d244
	ds 1
BaseEggSteps:: ; d245
	ds 1
BaseUnknown2:: ; d246
	ds 1
BasePicSize:: ; d247
	ds 1
wBaseAbilities::
wBaseAbility1:: db ; d248
wBaseAbility2:: db ; d249
BasePadding:: ; d24a
	ds 2
BaseGrowthRate:: ; d24c
	ds 1
BaseEggGroups:: ; d24d
	ds 1
BaseTMHM:: ; d24e
	ds 8

wSunriseOffset::
	ds 1
wSunriseOffsetDate::
	ds 2

	ds 1

wMornEncounterRate::  ds 1 ; d25a
wDayEncounterRate::   ds 1 ; d25b
wNiteEncounterRate::  ds 1 ; d25c
wWaterEncounterRate:: ds 1 ; d25d
wListMoves_MoveIndicesBuffer:: ds NUM_MOVES
wPutativeTMHMMove:: ds 1
wd263:: ds 1
wBattleHasJustStarted:: ds 1
wFoundMatchingIDInParty::
wNamedObjectIndexBuffer::
wCurTMHM::
wTypeMatchup::
wd265:: ds 1
wFailedToFlee:: ds 1
wNumFleeAttempts:: ds 1
wMonTriedToEvolve:: ds 1

TimeOfDay:: ; d269
	ds 1

wLastBallShakes:: ds 1 ; d26a

SECTION "Enemy Party", WRAMX, BANK [1]
wd26b::
wEmoteSFX:: ds 2
wPlayEmoteSFX:: ds 1
	ds wEmoteSFX - @
OTPlayerName:: ds NAME_LENGTH ; d26b
OTPlayerID:: ds 2 ; d276
	ds 8
OTPartyCount::   ds 1 ; d280
OTPartySpecies:: ds PARTY_LENGTH ; d281
OTPartyEnd::     ds 1

wDudeBag:: ; d288
wDudeNumItems:: ds 1
wDudeItems:: ds 2 * 4
wDudeItemsEnd:: ds 1

wDudeNumKeyItems:: ds 1 ; d292
wDudeKeyItems:: ds 18
wDudeKeyItemsEnd:: ds 1

wDudeNumBalls:: ds 1 ; d2a6
wDudeBalls:: ds 2 * 4 ; d2a7
wDudeBallsEnd:: ds 1 ; d2af
wDudeBagEnd::
	ds wDudeBag - @

wPachisiPath::
wCardDeck:: ds 7 ;d288 (52 Cards)
wYourCardHand:: ds 12
wDealerCardHand::
wPokerMenu::
	ds 12

	ds wCardDeck - @

wParkMinigameData::

wParkMinigameRemainingTime:: ds 4
wParkMinigameTotalTime:: ds 1 ;minutes
wParkMinigameGameType:: ds 1

park_minigame_spot: MACRO
\1Flags::
\1Species::
	ds 1 ; 0 indicates empty/cooldown, -1 indicates an item
\1Item::
\1Level::
\1Cooldown::
	ds 1
\1DVs::
\1Quantity::
	ds 2
ENDM

wParkMinigameSpot1:: park_minigame_spot wParkMinigameSpot1
wParkMinigameSpot2:: park_minigame_spot wParkMinigameSpot2
wParkMinigameSpot3:: park_minigame_spot wParkMinigameSpot3
wParkMinigameSpot4:: park_minigame_spot wParkMinigameSpot4
wParkMinigameSpot5:: park_minigame_spot wParkMinigameSpot5
wParkMinigameSpot6:: park_minigame_spot wParkMinigameSpot6
wParkMinigameSpot7:: park_minigame_spot wParkMinigameSpot7
wParkMinigameSpot8:: park_minigame_spot wParkMinigameSpot8
wParkMinigameSpot9:: park_minigame_spot wParkMinigameSpot9
wParkMinigameSpot10:: park_minigame_spot wParkMinigameSpot10
wParkMinigameSpot11:: park_minigame_spot wParkMinigameSpot11
wParkMinigameSpot12:: park_minigame_spot wParkMinigameSpot12
wParkMinigameSpot13:: park_minigame_spot wParkMinigameSpot13
wParkMinigameSpotsEnd::

wParkMinigameCurrentSpotNumber:: ds 1
wParkMinigameCurrentSpot:: park_minigame_spot wParkMinigameCurrentSpot

wParkMinigameSavedHeldItems:: ds 6
wParkMinigameSavedBalls:: ds MAX_BALLS * 2 + 2

wParkMinigameDataEnd::
	ds wParkMinigameData - @

OTPartyMons::
OTPartyMon1:: party_struct OTPartyMon1 ; d288
OTPartyMon2:: party_struct OTPartyMon2 ; d2b8
OTPartyMon3:: party_struct OTPartyMon3 ; d2e8
OTPartyMon4:: party_struct OTPartyMon4 ; d318
OTPartyMon5:: party_struct OTPartyMon5 ; d348
OTPartyMon6:: party_struct OTPartyMon6 ; d378
OTPartyMonsEnd::

wOTPartyMonOT:: ds NAME_LENGTH * PARTY_LENGTH ; d3a8
OTPartyMonNicknames:: ds PKMN_NAME_LENGTH * PARTY_LENGTH ; d3ea
OTPartyDataEnd::
wAIMoveScores:: 
	ds 4

wBattleAction:: ds 1 ; d430

	ds 1
MapStatus:: ; d432
	ds 1
MapEventStatus:: ; d433
; 0: do map events
; 1: do background events
	ds 1

ScriptFlags:: ; d434
; bit 3: priority jump
; bit 2: script running
; bit 1: callback
; bit 0: ????????
	ds 1
ScriptFlags2:: ; d435
; bit 0: is fishing
	ds 1
ScriptFlags3:: ; d436
; bit 4: wild encounters
; bit 2: warps and connections
; bit 1: xy triggers
; bit 0: count steps
	ds 1

ScriptMode:: ; d437
	ds 1
ScriptRunning:: ; d438
	ds 1
ScriptBank:: ; d439
	ds 1
ScriptPos:: ; d43a
	ds 2

wScriptStackSize:: ds 1
wScriptStack:: ds 3 * 5
	ds 1
ScriptDelay:: ; d44d
	ds 1

wPriorityScriptBank::
wScriptTextBank::
	ds 1 ; d44e
wPriorityScriptAddr::
wScriptTextAddr:: ds 2 ; d44f
	ds 1
wWildEncounterCooldown:: ds 1 ; d452

wScriptArrayBank::
	ds 1
wScriptArrayAddress::
	ds 2
wScriptArrayEntrySize::
	ds 1
wScriptArrayCurrentEntry::
	ds 1
	
wInitialTextColumn:: ds 1 ; d458

wBattleScriptFlags:: ds 2 ; d459
wPlayerSpriteSetupFlags:: ds 1 ; d45b
; bit 7: if set, cancel PlayerAction
; bit 5: if set, set facing according to bits 0-1
; bits 0-1: direction facing

wScriptArrayCommandBuffer::
	ds 15

wCompressedTextBuffer:: ds 7 ; d465

wTimeEventCallback:: ds 2 ; d46c
wTimeEventCallbackBank:: ds 1 ; d46e
wMapStatusEnd:: ds 2 ; d470

wTempPlayerCustSelection::
	ds 1

wTempPlayerClothesPalette::
	ds 3

wGameData::
wPlayerData::
PlayerID:: ; d47b
	ds 2

PlayerName:: ds NAME_LENGTH ; d47d
MomsName::   ds NAME_LENGTH ; d488
RivalName::  ds NAME_LENGTH ; d493
PlayerOWSprite:: ds 1 ;d49e
PlayerColor::    ds 2 ; d49f
PlayerRace::     ds 1 ;d4a1
BackupPlayerOWSprite:: ds 1 ;d4a2
BackupPlayerColor::    ds 2 ;d4a3
BackupPlayerRace::     ds 1 ;d4a5
MiningLevel:: ds 1 ;d4a6
MiningEXP::   ds 1 ;d4a7
SmeltingLevel:: ds 1 ;d4a8
SmeltingEXP::   ds 1 ;d4a9
JewelingLevel:: ds 1 ;d4aa
JewelingEXP::   ds 1 ;d4ab
BallMakingLevel:: ds 1 ;d4ac
BallMakingEXP::   ds 1 ;d4ad
OrphanPoints:: ds 2 ;d4ae
SootSackAsh:: ds 2 ;d4b0
BattlePoints:: ds 2 ;d4a6

wSavedAtLeastOnce:: ds 1
wSpawnAfterChampion:: ds 1


; init time set at newgame
StartDay:: ; d4b6
	ds 1
StartHour:: ; d4b7
	ds 1
StartMinute:: ; d4b8
	ds 1
StartSecond:: ; d4b9
	ds 1

wRTC:: ; d4ba
	ds 8
wDST:: ; d4c2
	ds 1

GameTimeCap:: ; d4c3
	ds 1
GameTimeHours:: ; d4c4
	ds 2
GameTimeMinutes:: ; d4c6
	ds 1
GameTimeSeconds:: ; d4c7
	ds 1
GameTimeFrames:: ; d4c8
	ds 1

CurYear::
	ds 1
CurMonth::
	ds 1
CurDay:: ; d4cb
	ds 1
wTimeDataEnd::
	ds 1
wObjectFollow_Leader:: ds 1
wObjectFollow_Follower:: ds 1
wCenteredObject:: ds 1
wFollowerMovementQueueLength:: ds 1
wFollowMovementQueue:: ds 5

ObjectStructs:: ; d4d6
object_struct: MACRO
\1Struct::
\1Sprite:: ds 1
\1MapObjectIndex:: ds 1
\1SpriteTile:: ds 1
\1MovementType:: ds 1
\1Flags:: ds 2
\1Palette:: ds 1
\1Walking:: ds 1
\1Direction:: ds 1
\1StepType:: ds 1
\1StepDuration:: ds 1
\1Action:: ds 1
\1ObjectStepFrame:: ds 1
\1Facing:: ds 1
\1StandingTile:: ds 1 ; collision
\1LastTile:: ds 1     ; collision
\1StandingMapX:: ds 1
\1StandingMapY:: ds 1
\1LastMapX:: ds 1
\1LastMapY:: ds 1
\1ObjectInitX:: ds 1
\1ObjectInitY:: ds 1
\1Radius:: ds 1
\1SpriteX:: ds 1
\1SpriteY:: ds 1
\1SpriteXOffset:: ds 1
\1SpriteYOffset:: ds 1
\1MovementByteIndex:: ds 1
\1Object28:: ds 1
\1Object29:: ds 1
\1Object30:: ds 1
\1Object31:: ds 1
\1Range:: ds 1
	ds 7
\1StructEnd::
ENDM

	object_struct Player
	object_struct Object1
	object_struct Object2
	object_struct Object3
	object_struct Object4
	object_struct Object5
	object_struct Object6
	object_struct Object7
	object_struct Object8
	object_struct Object9
	object_struct Object10
	object_struct Object11
	object_struct Object12
ObjectStructsEnd:: ; d6de

wCmdQueue:: ds CMDQUEUE_CAPACITY * CMDQUEUE_ENTRY_SIZE
	ds $28

MapObjects:: ; d71e
map_object: MACRO
\1Object::
\1ObjectStructID::  ds 1
\1ObjectSprite::    ds 1
\1ObjectYCoord::    ds 1
\1ObjectXCoord::    ds 1
\1ObjectMovement::  ds 1
\1ObjectRadius::    ds 1
\1ObjectHour::      ds 1
\1ObjectTimeOfDay:: ds 1
\1ObjectColor::     ds 1
\1ObjectRange::     ds 1
\1ObjectScript::    ds 2
\1ObjectEventFlag:: ds 2
	ds 2
endm

	map_object Player
	map_object Map1
	map_object Map2
	map_object Map3
	map_object Map4
	map_object Map5
	map_object Map6
	map_object Map7
	map_object Map8
	map_object Map9
	map_object Map10
	map_object Map11
	map_object Map12
	map_object Map13
	map_object Map14
	map_object Map15
MapObjectsEnd::

wObjectMasks:: ds NUM_OBJECTS ; d81e

VariableSprites:: ; d82e
	ds $10

wEnteredMapFromContinue:: ds 1 ; d83e
	ds 2
TimeOfDayPal:: ; d841
	ds 1
wSelectButtonCounter::
	ds 4
; d846
wTimeOfDayPalFlags:: ds 1
wTimeOfDayPalset:: ds 1
CurTimeOfDay:: ; d848
	ds 1

	ds 1

wSecretID:: ds 2

wStatusFlags:: ; d84c
	; 0 - pokedex
	; 1 - unown dex
	; 2 - pokemon only mode
	; 3 - pokerus
	; 4 - use treasure bag
	; 5 - wild encounters on/off
	; 6 - hall of fame
	; 7 - bug contest on
	ds 1

wStatusFlags2:: ; d84d
	; 0 - flash
	; 1 -
	; 2 - park catching minigame
	; 3 -
	; 4 - bike shop call
	; 5 - pokerus
	; 6 - berry juice?
	; 7 - rockets in mahogany
	ds 1

Money:: ; d84e
	ds 3

wBankMoney:: ; d851
	ds 3
wBankSavingMoney:: ; d854
	ds 1

Coins:: ; d855
	ds 2

wMysteryZoneWinCount:: ds 2 ;d857

TMsHMs:: ; d859
	flag_array NUM_TMS + NUM_HMS
TMsHMsEnd::

NumItems:: ; d866
	ds 1
Items:: ; d867
	ds MAX_ITEMS * 2 + 1
ItemsEnd::

NumKeyItems:: ; d8a4
	ds 1
KeyItems:: ; d8a5
	ds MAX_KEY_ITEMS + 1
KeyItemsEnd::

NumBalls:: ; d8bc
	ds 1
Balls:: ; d8bd
	ds MAX_BALLS * 2 + 1
BallsEnd::

PCItems:: ; d8f1
	ds MAX_PC_ITEMS * 2 + 1
PCItemsEnd::

	ds 1

wPokegearFlags:: ds 1
; bit 0: map
; bit 1: radio
; bit 2: phone
; bit 3: expn
; bit 7: on/off
	ds 1
; wLastDexMode::
	ds 1

wExperienceShareOn::
	ds 1
WhichRegisteredItem:: ; d95b
	ds 1
RegisteredItem:: ; d95c
	ds 1

PlayerState:: ; d95d
	ds 1

wHallOfFameCount:: ds 2
wTradeFlags:: flag_array 6 ; d960
	ds 1
MooMooBerries:: ; d962
	ds 1 ; how many berries fed to MooMoo
UndergroundSwitchPositions:: ; d963
	ds 1 ; which positions the switches are in
wPokeonlyBackupPokemonNickname:: ; d964
	ds PKMN_NAME_LENGTH
wPachisiDiceRolls::
	ds 1
wPachisiPosition:: ;d970
	ds 1
wPachisiBoardID:: ;d971
	ds 1

;SECTION "Map Triggers", WRAMX, BANK [1]

wPokecenter2FTrigger::                       ds 1 ; d972
wTradeCenterTrigger::                        ds 1 ; d973
wColosseumTrigger::                          ds 1 ; d974
wTimeCapsuleTrigger::                        ds 1 ; d975
wRoute69GateTrigger::                        ds 1 ; d976
wIlkBrotherHouseTrigger::                    ds 1 ; d977
wPokeonlyForestTrigger::                     ds 1 ; d978
wMilosB1FTrigger::                           ds 1 ; d979
wMilosB2FTrigger::                           ds 1 ; d97a
wMilosB2FBTrigger::                          ds 1 ; d97a
wMagmaTunnelTrigger::                        ds 1 ; d97b
wRuinsF1Trigger::                            ds 1 ; d97c
wRuinsF2Trigger::                            ds 1 ; d97d
wRuinsF3Trigger::                            ds 1 ; d97e
wRuinsF4Trigger::                            ds 1 ; d97f
wRuinsF5Trigger::                            ds 1 ; d980
wSaxifrageTrigger::                          ds 1 ; d981
wPrisonF2Trigger::                           ds 1 ; d982
wClathriteBF1Trigger::                       ds 1 ; d983
wAcquaMinesBasementTrigger::                 ds 1 ; d984
wHauntedMansionBasementTrigger::             ds 1 ; d985
wPhloxLab1FTrigger::                         ds 1 ; d986
wSoutherlyCityTrigger::                      ds 1 ; d987
wRoute69Trigger::                            ds 1 ; d988
wNaljoBadgeCheckTrigger::                    ds 1 ; d989
wLaurelCityTrigger::                         ds 1 ; d98a
wRoute49GateTrigger::                        ds 1 ; d98b
wMysteryBrownTrigger::                       ds 1 ; d98c
wMysteryGoldTrigger::                        ds 1 ; d98d
wMysteryRedTrigger::                         ds 1 ; d98e
wAcquaStartTrigger::                         ds 1 ; d9c4
wProvincialParkContestTrigger::              ds 1 ; d9c1
wBattleTowerBattleRoomTrigger::              ds 1 ; d99f
wBattleTowerElevatorTrigger::                ds 1 ; d9a0
wBattleTowerHallwayTrigger::                 ds 1 ; d9a1
wBattleTowerEntranceTrigger::                ds 1 ; d9a2
wIntroOutsideTrigger::                       ds 1 ; d9c2
wSpurgeGym1FTrigger::                        ds 1 ; d9c3
wPowerPlantTrigger::                         ds 1 ; d9c4
wCaperCityTrigger::                          ds 1 ; d9c5
wHeathGateTrigger::                          ds 1 ; d9c6
	ds 119
	
wMovesObtained::
	ds 32
wItemsObtained::
	ds 32

wAButtonCount:: ds 4 ;da52
wBButtonCount:: ds 4
wSelectButtonCount:: ds 4
wStartButtonCount:: ds 4
wRightButtonCount:: ds 4
wLeftButtonCount:: ds 4
wUpButtonCount:: ds 4
wDownButtonCount:: ds 4

EventFlags:: ; da72
	flag_array NUM_EVENTS

wBingoCurrentCard:: ds 1 ; db6c
wBingoAwardedPrizes:: ds 2 ; db6d
wBingoMarkedCells:: ds 3 ; db6f

wCurBox:: ; db72
	ds 1
wCatchMonSwitchBox:: ds 1
	ds 1

; 8 chars + $50
wBoxNames:: ds BOX_NAME_LENGTH * NUM_BOXES ; db75

wCelebiEvent::
	ds 1

	ds 1

wBikeFlags:: ; dbf5
; bit 0: using strength
; bit 1: always on bike
; bit 2: downhill
	ds 1

wEncounterRateStage:: ; dbf6
; 0 - encounter rate halved
; 1 - encounter rate normal
; 2 - encounter rate doubled
	ds 1

wCurrentMapTriggerPointer:: ds 2 ; dbf7

wCurrentCaller:: ds 2 ; dbf9
wCurrMapWarpCount:: ds 1 ; dbfb
wCurrMapWarpHeaderPointer:: ds 2 ; dbfc
wCurrentMapXYTriggerCount:: ds 1 ; dbfe
wCurrentMapXYTriggerHeaderPointer:: ds 2 ; dbff
wCurrentMapSignpostCount:: ds 1 ; dc01
wCurrentMapSignpostHeaderPointer:: ds 2 ; dc02
wCurrentMapPersonEventCount:: ds 1 ; dc04
wCurrentMapPersonEventHeaderPointer:: ds 2 ; dc05
wCurrMapTriggerCount:: ds 1 ; dc07
wCurrMapTriggerHeaderPointer:: ds 2 ; dc08
wCurrMapCallbackCount:: ds 1 ; dc0a
wCurrMapCallbackHeaderPointer:: ds 2 ; dc0b

wTimeLastSetTimeMachine:: ; day, hour, min, sec ; dc35
	ds 4
	ds 11

wDailyResetTimer:: ds 2 ; flag, day
DailyFlags:: ds 1
WeeklyFlags:: ds 1
SwarmFlags:: ds 1

wTowerTycoonsDefeated:: ds 2 ; dc21 (little-endian)

wStartDay:: ds 1
wClockEnabled:: ds 1
	ds 2

FruitTreeFlags:: flag_array NUM_FRUIT_TREES ; dc27

wPachisiWinCount:: ds 2 ; dc29 (little-endian)

wLuckyNumberDayBuffer:: ds 2

wTreasureBagCount:: ds 1
wTreasureBag:: ds TREASURE_BAG_CAPACITY
wTreasureBagEnd:: ds 1

orphanage_record: MACRO
\1Species:: db
\1Year:: db
\1Month:: db
\1Day:: db
ENDM

wOrphanageDonation1:: orphanage_record wOrphanageDonation1
wOrphanageDonation2:: orphanage_record wOrphanageDonation2
wOrphanageDonation3:: orphanage_record wOrphanageDonation3
wOrphanageDonation4:: orphanage_record wOrphanageDonation4
wOrphanageDonation5:: orphanage_record wOrphanageDonation5
wOrphanageDonation6:: orphanage_record wOrphanageDonation6
wOrphanageDonation7:: orphanage_record wOrphanageDonation7
wOrphanageDonationEnd::

	ds 3

wYanmaMapGroup:: ds 1 ; dc5a
wYanmaMapNumber:: ds 1

wGlobalStepCounter:: ds 4
wBattlesWonCounter:: ds 3
wTotalBattleTime:: ds 6 ; 3 byte hours (big endian), minutes, seconds, hundredths

	ds 6

wAccumulatedOrphanPoints:: ds 4 ; dc6f, big endian

StepCount:: ; dc73
	ds 1
PoisonStepCount:: ; dc74
	ds 1

wFossilsRevived:: ds 2 ; dc75 (little-endian)

wHappinessStepCount:: ds 1
	ds 1

wSafariBallsRemaining:: ds 1 ; dc79
wSafariTimeRemaining:: ds 2 ; dc7a

wLastRepelUsed:: ds 1 ; dc7c used to be the phone list

wFossilCaseCount:: ds 1 ; cd7d
wFossilCase:: ds FOSSIL_CASE_SIZE ; dc7e
wFossilCaseEnd:: ds 1 ; dc9c

wLuckyNumberShowFlag:: ds 2 ; dc9d
wLuckyIDNumber:: ds 2 ; dc9f
wRepelEffect:: ds 2 ; If a Repel is in use, it contains the nr of steps it's still active
wBikeStep:: ds 1
wKurtApricornQuantity:: ds 1

wPlayerDataEnd::


wMapData::
	ds 4

wDigWarp:: ds 1
wDigMapGroup:: ds 1
wDigMapNumber:: ds 1
; used on maps like second floor pokécenter, which are reused, so we know which
; map to return to
BackupWarpNumber:: ; dcac
	ds 1
BackupMapGroup:: ; dcad
	ds 1
BackupMapNumber:: ; dcae
	ds 1

	ds 3

wLastSpawnMapGroup:: ds 1
wLastSpawnMapNumber:: ds 1

WarpNumber:: ; dcb4
	ds 1
MapGroup:: ; dcb5
	ds 1 ; map group of current map
MapNumber:: ; dcb6
	ds 1 ; map number of current map
YCoord:: ; dcb7
	ds 1 ; current y coordinate relative to top-left corner of current map
XCoord:: ; dcb8
	ds 1 ; current x coordinate relative to top-left corner of current map
wScreenSave:: ds 6 * 5

wMapDataEnd::


SECTION "Party", WRAMX, BANK [1]

wPokemonData::

wPartyCount:: ; dcd7
	ds 1 ; number of Pokémon in party
wPartySpecies:: ; dcd8
	ds PARTY_LENGTH ; species of each Pokémon in party
wPartyEnd:: ; dcde
	ds 1 ; legacy scripts don't check wPartyCount

wPartyMons::
wPartyMon1:: party_struct PartyMon1 ; dcdf
wPartyMon2:: party_struct PartyMon2 ; dd0f
wPartyMon3:: party_struct PartyMon3 ; dd3f
wPartyMon4:: party_struct PartyMon4 ; dd6f
wPartyMon5:: party_struct PartyMon5 ; dd9f
wPartyMon6:: party_struct PartyMon6 ; ddcf

wPartyMonOT:: ds NAME_LENGTH * PARTY_LENGTH ; ddff

wPartyMonNicknames:: ds PKMN_NAME_LENGTH * PARTY_LENGTH ; de41
wPartyMonNicknamesEnd::

wPokeonlyMainSpecies:: ds 1
wPokeonlyBackupPokemonSpecies:: ds 2
wPokeonlyMainDVs:: ds 2
wPokeonlyBackupPokemonOT:: ds NAME_LENGTH

wSavedPlayerCharacteristics2::
	ds 5
wSavedPlayerCharacteristics2End::
	
wPokeonlyMonPalette::
	ds 1

PokedexCaught:: ; de99
	flag_array NUM_POKEMON
EndPokedexCaught::

PokedexSeen:: ; deb9
	flag_array NUM_POKEMON
EndPokedexSeen::

Badges::
wNaljoBadges:: ; ded9
	flag_array 8
wRijonBadges:: ; deda
	flag_array 8
wOtherBadges:: ; dedb
	flag_array 8
VisitedSpawns:: ; dedc
	flag_array NUM_SPAWNS ;5

wBattleArcadeMaxScore:: ds 4 ; dee1
wBattleArcadeMaxRound:: ds 2 ; dee5
wBattleArcadeTickets:: ds 3 ; dee7

wBattleArcadeRunData::
wBattleArcadeRunningScore:: ds 4 ; deea
wBattleArcadeCurrentRound:: ds 2 ; deee
wBattleArcadeDifficulty:: ds 1 ; def0
wBattleArcadeRoundScore:: ds 2 ; def1
wBattleArcadeRunDataEnd::

	ds 2

wDaycareMan:: ; def5
; bit 7: active
; bit 6: monsters are compatible
; bit 5: egg ready
; bit 0: monster 1 in daycare
	ds 1

wBreedMon1::
wBreedMon1Nick::  ds PKMN_NAME_LENGTH ; def6
wBreedMon1OT::    ds NAME_LENGTH ; df01
wBreedMon1Stats:: box_struct wBreedMon1 ; df0c

wDaycareLady:: ; df2c
; bit 7: active
; bit 0: monster 2 in daycare
	ds 1

wStepsToEgg:: ; df2d
	ds 1
wBreedMotherOrNonDitto:: ; df2e
;  z: yes
; nz: no
	ds 1

wBreedMon2::
wBreedMon2Nick::  ds PKMN_NAME_LENGTH ; df2f
wBreedMon2OT::    ds NAME_LENGTH ; df3a
wBreedMon2Stats:: box_struct wBreedMon2 ; df45

wEggNick:: ds PKMN_NAME_LENGTH ; df65
wEggOT::   ds NAME_LENGTH ; df70
wEggMon::  box_struct wEggMon ; df7b

wBackupSecondPartySpecies:: ds 1

wBackupMon:: party_struct wBackupMon

wDunsparceMapGroup:: ds 1
wDunsparceMapNumber:: ds 1
wFishingSwarmFlag:: ds 1

roam_struct: MACRO
\1Species::   db
\1Level::     db
\1MapGroup::  db
\1MapNumber:: db
\1HP::        ds 2
\1DVs::       ds 2
ENDM

wRoamMon1:: roam_struct wRoamMon1 ; dfcf

wPlayerCharacteristics::
wPlayerGender::
; bit 0: gender
; bits 1-3: character model
; bits 4-6: skin tone
	ds 1

wPlayerClothesPalette::
	ds 2

wPlayerClothesScrollPosition::
	ds 1
wPlayerCustMenuCursorBuffer::
	ds 1
wPlayerCharacteristicsEnd::

wParkMinigamePokeBalls:: ds 1
wParkMinigameGreatBalls:: ds 1
wParkMinigameUltraBalls:: ds 1
wParkMinigameMasterBalls:: ds 1

	ds 4

wRoamMons_CurrentMapNumber:: ds 1
wRoamMons_CurrentMapGroup:: ds 1
wRoamMons_LastMapNumber:: ds 1
wRoamMons_LastMapGroup:: ds 1

; dfe8
wPokemonDataEnd::
wGameDataEnd::

SECTION "Pic Animations", WRAMX, BANK [2]

TempTileMap::
; 20x18 grid of 8x8 tiles
	ds SCREEN_WIDTH * SCREEN_HEIGHT ; $168 = 360
; PokeAnim Header
wPokeAnimSceneIndex:: ds 1
wPokeAnimPointer:: ds 2
wPokeAnimSpecies:: ds 1
wPokeAnimUnownLetter:: ds 1
wPokeAnimSpecies2:: ds 1
wPokeAnimGraphicStartTile:: ds 1
wPokeAnimCoord:: ds 2
wPokeAnimFrontpicHeight:: ds 1
; PokeAnim Data
wPokeAnimExtraFlag:: ds 1
wPokeAnimSpeed:: ds 1
wPokeAnimPointerBank:: ds 1
wPokeAnimPointerAddr:: ds 2
wPokeAnimFramesBank:: ds 1
wPokeAnimFramesAddr:: ds 2
wPokeAnimBitmaskBank:: ds 1
wPokeAnimBitmaskAddr:: ds 2
wPokeAnimFrame:: ds 1
wPokeAnimJumptableIndex:: ds 1
wPokeAnimRepeatTimer:: ds 1
wPokeAnimCurBitmask:: ds 1
wPokeAnimWaitCounter:: ds 1
wPokeAnimCommand:: ds 1
wPokeAnimParameter:: ds 1
	ds 1
wPokeAnimBitmaskCurCol:: ds 1
wPokeAnimBitmaskCurRow:: ds 1
wPokeAnimBitmaskCurBit:: ds 1
wPokeAnimBitmaskBuffer:: ds 7
wPokeAnimDestination:: ds 2
wPokeAnimStructEnd::

SECTION "Battle Tower", WRAMX, BANK [2]

wBattleTower::
wBT_CurStreak:: ds 1
wBTChoiceOfLvlGroup:: ds 1
wBTOpponentIndices:: ds 7
wBTMonsSelected:: ds 3 * 7
wBT_OTTrainer:: battle_tower_struct wBT_OT
wBT_TrainerTextIndex:: ds 2
wBT_WinStreak:: ds 1
wBattleTowerEnd::

SECTION "WRAM 2 extra", WRAMX, BANK [2]

wPartyBackup:: ds wPartyMonNicknamesEnd - wPokemonData

wBigNumerator:: ds 16
	ds 8 ;this space intentionally left blank
wBigDenominator:: ds 16
wBigNumberBuffer:: ds 16

wDEDTempSamp::
	ds 16
GetDEDByte::
	ds $100
; dynamic code is loaded here
GetDEDByteEnd::

wScriptVarStackCount:: ds 1
wScriptVarStack:: ds 15 ; assuming that nothing will exceed this limit

SECTION "WRAM 2 aligned", WRAMX [$D000], BANK [2]

wDebugMenuScratchArea:: ds $200 ;d000

wStopwatchCounters:: ds $20 ; d200 (MUST be aligned to a multiple of 4)

SECTION "Sound Stack", WRAMX [$DFFF -(SOUND_STATE_SIZE * SOUND_STACK_CAPACITY)], BANK [2]

wSoundStack:: ds SOUND_STATE_SIZE * SOUND_STACK_CAPACITY
wSoundStackSize:: db

SECTION "Metatiles", WRAMX, BANK [3]
wDecompressedMetatiles::
	ds 256 * 16

SECTION "Collision (and maybe music?)", WRAMX, BANK [4]
wDecompressedCollision::
	ds 256 * 4

SECTION "GBC Video", WRAMX, BANK [5]

; 8 4-color palettes
UnknBGPals:: ds 8 palettes ; d000
UnknOBPals:: ds 8 palettes ; d040
BGPals::     ds 8 palettes ; d080
OBPals::     ds 8 palettes ; d0c0

SECTION "LY Overrides", WRAMX [$D100], BANK [5]
wLYOverrides:: ; d100
	ds SCREEN_HEIGHT_PX
wLYOverridesEnd:: ; d190

SECTION "Magnet Train", WRAMX [$D191], BANK[5]
wMagnetTrainDirection:: ds 1
wMagnetTrainInitPosition:: ds 1
wMagnetTrainHoldPosition:: ds 1
wMagnetTrainFinalPosition:: ds 1
wMagnetTrainPlayerSpriteInitX:: ds 1

SECTION "LY Overrides Staging", WRAMX [$D200], BANK[5]
LYOverridesBackup:: ; d200
	ds SCREEN_HEIGHT_PX
LYOverridesBackupEnd::


SECTION "Battle Animations", WRAMX [$d300], BANK [5]
wTitleScreenBGPIListAndSpectrumColours::
wBattleAnimTileDict:: ds 10

battle_anim_struct: MACRO
; Placeholder until we can figure out what it all means
\1_Index::  ds 1
\1_Flags:: ds 1
\1_YFixParam:: ds 1
\1_FramesetIndex:: ds 1
\1_FunctionIndex:: ds 1
\1_Palette:: ds 1
\1_TileID:: ds 1
\1_XCoord:: ds 1
\1_YCoord:: ds 1
\1_XOffset:: ds 1
\1_YOffset:: ds 1
\1_Param:: ds 1
\1_Anim0c:: ds 1
\1_Anim0d:: ds 1
\1_AnonJumptableIndex:: ds 1
\1_Anim0f:: ds 1
\1_Anim10:: ds 1
\1_Anim11:: ds 1
\1_Anim12:: ds 1
\1_Anim13:: ds 1
\1_Anim14:: ds 1
\1_Anim15:: ds 1
\1_Anim16:: ds 1
\1_Anim17:: ds 1
endm

ActiveAnimObjects:: ; d30a
AnimObject01:: battle_anim_struct AnimObject01
AnimObject02:: battle_anim_struct AnimObject02
AnimObject03:: battle_anim_struct AnimObject03
AnimObject04:: battle_anim_struct AnimObject04
AnimObject05:: battle_anim_struct AnimObject05
AnimObject06:: battle_anim_struct AnimObject06
AnimObject07:: battle_anim_struct AnimObject07
AnimObject08:: battle_anim_struct AnimObject08
AnimObject09:: battle_anim_struct AnimObject09
AnimObject10:: battle_anim_struct AnimObject10
ActiveAnimObjectsEnd:: ; d3aa

battle_bg_effect: MACRO
\1_Function:: ds 1
\1_01:: ds 1
\1_02:: ds 1
\1_03:: ds 1
endm

ActiveBGEffects:: ; d3fa
BGEffect1:: battle_bg_effect BGEffect1
BGEffect2:: battle_bg_effect BGEffect2
BGEffect3:: battle_bg_effect BGEffect3
BGEffect4:: battle_bg_effect BGEffect4
BGEffect5:: battle_bg_effect BGEffect5
ActiveBGEffectsEnd::

wNumActiveBattleAnims:: ds 1 ; d40e

BattleAnimFlags:: ; d40f
	ds 1
BattleAnimAddress:: ; d410
	ds 2
BattleAnimDuration:: ; d412
	ds 1
BattleAnimParent:: ; d413
	ds 2
BattleAnimLoops:: ; d415
	ds 1
BattleAnimVar:: ; d416
	ds 1
BattleAnimByte:: ; d417
	ds 1
wBattleAnimOAMPointerLo:: ds 1 ; d418
BattleAnimTemps:: ; d419
wBattleAnimTempOAMFlags::
wBattleAnimTemp0:: ds 1
wBattleAnimTemp1:: ds 1
wBattleAnimTempTileID::
wBattleAnimTemp2:: ds 1
wBattleAnimTempXCoord::
wBattleAnimTemp3:: ds 1
wBattleAnimTempYCoord::
wBattleAnimTemp4:: ds 1
wBattleAnimTempXOffset::
wBattleAnimTemp5:: ds 1
wBattleAnimTempYOffset::
wBattleAnimTemp6:: ds 1
wBattleAnimTemp7:: ds 1
wBattleAnimTempPalette::
wBattleAnimTemp8:: ds 1

wSurfWaveBGEffect:: ds $40
wSurfWaveBGEffectEnd::
	ds -$e
wBattleAnimEnd::

SECTION "Trainer Card Leader Palettes", WRAMX [$d500], BANK [5]
wTrainerCardLeaderPals:: ds 20 * 4
wTrainerCardBadgePals:: ds 20 * 4
wTrainerCardBadgePalsEnd::
wTempBadges:: ds 3
	ds wTrainerCardLeaderPals - @

w3DPrismBitMasks:: ds 9
w3DPrismAngles:: ds 4
w3DPrismXIncs:: ds 3 * 2
w3DPrismShadePos:: ds 1
w3DPrismState:: ds 1
w3DPrismPage:: ds 1
wTitleCloudsCounter:: ds 1

SECTION "Palettes 2", WRAMX [$d600], BANK [5]
BGPalsBuffer2:: ds 8 palettes
OBPalsBuffer2:: ds 8 palettes
FadeDeltas:: ds 16 palettes
FadeCounters:: ds 16 * 4 * 3
w3DPrismTmpGFX:: ds 63 tiles

SECTION "WRAM 6", WRAMX, BANK [6]

wDecompressScratch:: ds $400
wDecompressScratch2:: ds $800
wBackupAttrMap:: ds $400

SECTION "WRAM 7", WRAMX, BANK [7]
wWindowStack:: ds $1000 - 1
wWindowStackBottom:: ds 1

INCLUDE "sram.asm"
