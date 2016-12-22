_MainMenu:
	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame
	ld de, MUSIC_ROUTE_37
	ld a, e
	ld [wMapMusic], a
	call PlayMusic
	callba MainMenu
	jp StartTitleScreen

PrintDayOfWeek:
	push de
	ld hl, .Days
	ld a, b
	call GetNthString
	ld d, h
	ld e, l
	pop hl
	call PlaceString
	ld h, b
	ld l, c
	ld de, .Day
	jp PlaceString

.Days
	db "Sun@"
	db "Mon@"
	db "Tues@"
	db "Wednes@"
	db "Thurs@"
	db "Fri@"
	db "Satur@"

.Day
	db "day@"

NewGame_ClearTileMapEtc:
	xor a
	ld [hMapAnims], a
	call ClearTileMap
	call LoadFontsExtra
	call LoadStandardFont
	call ClearWindowData
	jp LoadLCDCode

NewGame:
	xor a
	ld [wMonStatusFlags], a
	call ResetWRAM
	call NewGame_ClearTileMapEtc
	call OakSpeech
	call InitializeWorld

	ld a, $80
	ld [wMapSignRoutineIdx], a
	ld a, ROUTE_69
	ld [wLastLandmark], a
	ld [wCurrentLandmark], a
	xor a
	ld [wMapSignTimer], a

	ld a, SPAWN_HOME
	ld [DefaultSpawnpoint], a

	ld a, MAPSETUP_WARP
	ld [hMapEntryMethod], a
	jp FinishContinueFunction

ResetWRAM:
	xor a
	ld [hBGMapMode], a

	ld hl, Sprites
	ld bc, wOptions - Sprites
	xor a
	call ByteFill

	ld hl, wd000
	ld bc, wGameData - wd000
	xor a
	call ByteFill

	ld hl, wGameData
	ld bc, wGameDataEnd - wGameData
	xor a
	call ByteFill

	ld a, [rLY]
	ld [hSecondsBackup], a
	call DelayFrame
	call Random
	ld [PlayerID], a

	ld a, [rLY]
	ld [hSecondsBackup], a
	call DelayFrame
	call Random
	ld [PlayerID + 1], a

	call Random
	ld [wSecretID], a
	ld a, [hRandomAdd]
	ld [wSecretID + 1], a

	ld hl, wPartyCount
	call InitList

	xor a
	ld [wCurBox], a
	ld [wSavedAtLeastOnce], a

	call SetDefaultBoxNames

	ld a, BANK(sBoxCount)
	call GetSRAMBank
	ld hl, sBoxCount
	call InitList
	call CloseSRAM

	ld hl, NumItems
	call InitList

	ld hl, NumKeyItems
	call InitList

	ld hl, NumBalls
	call InitList

	ld hl, PCItems
	call InitList

	ld hl, wTreasureBagCount
	call InitList

	ld hl, wFossilCaseCount
	call InitList

	xor a
	ld [wRoamMon1Species], a
	ld a, -1
	ld [wRoamMon1MapGroup], a
	ld [wRoamMon1MapNumber], a

	xor a
	ld [wMonType], a

	ld [wNaljoBadges], a
	ld [wRijonBadges], a
	ld [wOtherBadges], a

	ld [Coins], a
	ld [Coins + 1], a

	ld [BattlePoints], a
	ld [BattlePoints + 1], a

	ld [OrphanPoints], a
	ld [OrphanPoints + 1], a

	ld [SootSackAsh], a
	ld [SootSackAsh + 1], a

START_MONEY EQU 3000

IF START_MONEY / $10000
	ld a, START_MONEY / $10000
ENDC
	ld [Money], a
	ld a, START_MONEY / $100 % $100
	ld [Money + 1], a
	ld a, START_MONEY % $100
	ld [Money + 2], a

	call InitializeNPCNames

	jp ResetGameTime

InitList:
; Loads 0 in the count and -1 in the first item or mon slot.
	xor a
	ld [hli], a
	dec a
	ld [hl], a
	ret

SetDefaultBoxNames:
	ld hl, wBoxNames
	ld c, 0
.loop
	push hl
	ld de, .Box
	call CopyName2
	dec hl
	ld a, c
	inc a
	cp 10
	jr c, .less
	sub 10
	ld [hl], "1"
	inc hl

.less
	add "0"
	ld [hli], a
	ld [hl], "@"
	pop hl
	ld de, 9
	add hl, de
	inc c
	ld a, c
	cp NUM_BOXES
	jr c, .loop
	ret

.Box
	db "Box@"

InitializeNPCNames:
	ld hl, .Rival
	ld de, RivalName
	call .Copy

	ld hl, .Mom
	ld de, MomsName
	jp .Copy

.Copy
	ld bc, NAME_LENGTH
	rst CopyBytes
	ret

.Rival  db "???@"
.Mom    db "MOM@"

InitializeWorld:
	xor a
	ld [hMinutes], a
	ld [hSeconds], a
	ld [hHours], a
	call ShrinkPlayer
	jpba SpawnPlayer

Continue:
	callba TryLoadSaveFile
	ret c
	call LoadStandardMenuDataHeader
	call DisplaySaveInfoOnContinue
	ld a, $1
	ld [hBGMapMode], a
	ld c, 20
	call DelayFrames
	call ConfirmContinue
	jr nc, .Check1Pass
	jp CloseWindow

.Check1Pass
	call Continue_CheckRTC_RestartClock
	jr nc, .Check2Pass
	jp CloseWindow

.Check2Pass
	ld a, $8
	ld [MusicFade], a
	ld a, MUSIC_NONE % $100
	ld [MusicFadeIDLo], a
	ld a, MUSIC_NONE / $100
	ld [MusicFadeIDHi], a
	call ClearBGPalettes
	call CloseWindow
	call ClearTileMap
	ld c, 20
	call DelayFrames
	callba JumpRoamMons
	callba Function140ae ; time-related
	ld a, [wSpawnAfterChampion]
	cp SPAWN_LANCE
	jr z, .SpawnAfterE4
	cp $3
	jr z, .ResumeBattleTower
	ld a, MAPSETUP_CONTINUE
	ld [hMapEntryMethod], a
	jp FinishContinueFunction

.SpawnAfterE4
	ld a, SPAWN_CAPER_CITY
	jr .ContinueAfterE4Spawn

.ResumeBattleTower
	ld a, SPAWN_BATTLE_TOWER_ENTRANCE
.ContinueAfterE4Spawn
	ld [DefaultSpawnpoint], a
	call PostCreditsSpawn
	jp FinishContinueFunction

SpawnAfterRed:
	ld a, SPAWN_SAFFRON_CITY
	ld [DefaultSpawnpoint], a

PostCreditsSpawn:
	xor a
	ld [wSpawnAfterChampion], a
	ld a, MAPSETUP_WARP
	ld [hMapEntryMethod], a
	ret

ConfirmContinue:
	call DelayFrame
	call GetJoypad
	ld a, [hJoyPressed]
	bit A_BUTTON_F, a
	ret nz
	rrca
	rrca
	jr nc, ConfirmContinue
	ret

Continue_CheckRTC_RestartClock:
	call CheckRTCStatus
	and %10000000 ; Day count exceeded 16383
	jr z, .pass
	callba RestartClock
	ld a, c
	and a
	jr z, .pass
	scf
	ret

.pass
	xor a
	ret

FinishContinueFunction:
	ld sp, Stack
.loop
	xor a
	ld [wDontPlayMapMusicOnReload], a
	ld [wLinkMode], a
	ld hl, GameTimerPause
	set 0, [hl]
	res 7, [hl]
	ld hl, wEnteredMapFromContinue
	set 1, [hl]
	callba OverworldLoop
	ld a, [wSpawnAfterChampion]
	cp SPAWN_RED
	jr z, .AfterRed
	jp Reset

.AfterRed
	call SpawnAfterRed
	jr .loop

DisplaySaveInfoOnContinue:
	call CheckRTCStatus
	and %10000000
	jr z, .clock_ok
	lb de, 4, 8
	jp DisplayContinueDataWithRTCError

.clock_ok
	lb de, 4, 8
	jp DisplayNormalContinueData

DisplaySaveInfoOnSave:
	lb de, 4, 0
	jr DisplayNormalContinueData

DisplayNormalContinueData:
	call Continue_LoadMenuHeader
	call Continue_DisplayBadgesDexPlayerName
	call Continue_PrintGameTime
	call LoadFontsExtra
	jp UpdateSprites

DisplayContinueDataWithRTCError:
	call Continue_LoadMenuHeader
	call Continue_DisplayBadgesDexPlayerName
	call Continue_UnknownGameTime
	call LoadFontsExtra
	jp UpdateSprites

Continue_LoadMenuHeader:
	xor a
	ld [hBGMapMode], a
	ld hl, .MenuDataHeader_Dex
	ld a, [wStatusFlags]
	bit 0, a ; pokedex
	jr nz, .pokedex_header
	ld hl, .MenuDataHeader_NoDex

.pokedex_header
	call _OffsetMenuDataHeader
	call MenuBox
	jp PlaceVerticalMenuItems

.MenuDataHeader_Dex
	db $40 ; flags
	db 00, 00 ; start coords
	db 09, 15 ; end coords
	dw .MenuData2_Dex
	db 1 ; default option

.MenuData2_Dex
	db $00 ; flags
	db 4 ; items
	db "Player@"
	db "Badges@"
	db "#dex@"
	db "Time@"

.MenuDataHeader_NoDex
	db $40 ; flags
	db 00, 00 ; start coords
	db 09, 15 ; end coords
	dw .MenuData2_NoDex
	db 1 ; default option

.MenuData2_NoDex
	db $00 ; flags
	db 4 ; items
	db "Player <PLAYER>@"
	db "Badges@"
	db " @"
	db "Time@"

Continue_DisplayBadgesDexPlayerName:
	call MenuBoxCoord2Tile
	push hl
	decoord 13, 4, 0
	add hl, de
	call Continue_DisplayBadgeCount
	pop hl
	push hl
	decoord 12, 6, 0
	add hl, de
	call Continue_DisplayPokedexNumCaught
	pop hl
	push hl
	decoord 8, 2, 0
	add hl, de
	ld de, .Player
	call PlaceString
	pop hl
	ret

.Player
	db "<PLAYER>@"

Continue_PrintGameTime:
	decoord 9, 8, 0
	add hl, de
	jp Continue_DisplayGameTime

Continue_UnknownGameTime:
	decoord 9, 8, 0
	add hl, de
	ld de, .three_question_marks
	jp PlaceString

.three_question_marks
	db " ???@"

Continue_DisplayBadgeCount:
	push hl
	ld hl, wNaljoBadges
	ld b, 3
	call CountSetBits
	pop hl
	ld de, wd265
	lb bc, 1, 2
	jp PrintNum

Continue_DisplayPokedexNumCaught:
	ld a, [wStatusFlags]
	bit 0, a ; Pokedex
	ret z
	push hl
	ld hl, PokedexCaught
IF NUM_POKEMON % 8
	ld b, NUM_POKEMON / 8 + 1
ELSE
	ld b, NUM_POKEMON / 8
ENDC
	call CountSetBits
	pop hl
	ld de, wd265
	lb bc, 1, 3
	jp PrintNum

Continue_DisplayGameTime:
	ld de, GameTimeHours
	lb bc, 2, 3
	call PrintNum
	ld [hl], "<COLON>"
	inc hl
	ld de, GameTimeMinutes
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	jp PrintNum

OakSpeech:
	callba CalendarSet
	ld c, 1
	call FadeBGToDarkestColor
	call ClearTileMap

	ld de, MUSIC_ROUTE_30
	call PlayMusic

	ld c, 1
	call FadeOutBGPals

	ld b, SCGB_SCROLLINGMENU
	predef GetSGBLayout
	call SetPalettes

	ld hl, IntroTextGreetings
	call PrintText
	ld c, 1
	call FadeBGToLightestColor
	call ClearTileMap

	ld a, LARVITAR
	ld [wCurSpecies], a
	ld [wCurPartySpecies], a
	call GetBaseData

	hlcoord 6, 4
	call PrepMonFrontpic

	xor a
	ld [TempMonDVs], a
	ld [TempMonDVs + 1], a

	ld b, SCGB_FRONTPICPALS
	predef GetSGBLayout
	call Intro_WipeInFrontpic

	ld hl, IntroTextInhabitedByPokemon
	call PrintText
	ld hl, IntroTextBriefHistory
	call PrintText
	call FadeOutIntroPic

	ld a, RED
	call Intro_PrepTrainerPic
	ld hl, IntroTextIntroduceRed
	call PrintText
	call FadeOutIntroPic

	ld a, GOLD
	call Intro_PrepTrainerPic
	ld hl, IntroTextIntroduceGold
	call PrintText
	call FadeOutIntroPic

	ld b, SCGB_SCROLLINGMENU
	predef GetSGBLayout
	call SetPalettes

	ld hl, IntroTextEnoughAboutThem
	call PrintText

	callba PlayerCustomization
	call FadeOutIntroPic

	xor a
	ld [TrainerClass], a
	ld b, SCGB_FRONTPICPALS
	predef GetSGBLayout

	xor a
	call DmgToCgbBGPals
	call DelayFrame
	callba DrawIntroPlayerPic
	call Intro_WaitBGMapAndFadeOutBGPals

	ld hl, IntroTextFinallyPleaseTellMeYourName
	call PrintText
	call NamePlayer
	ld hl, IntroTextEnding
	jp PrintText

IntroTextGreetings:
	text_jump _IntroTextGreetings

IntroTextInhabitedByPokemon:
	text_far _IntroTextInhabitedByPokemon
	start_asm
	ld a, LARVITAR
	call PlayCry
	call WaitSFX
	ld hl, IntroTextWaitButton
	ret

IntroTextWaitButton:
	text ""
	prompt

IntroTextBriefHistory:
	text_jump _IntroTextPokemonBriefHistory

IntroTextIntroduceRed:
	text_jump _IntroTextIntroduceRed

IntroTextIntroduceGold:
	text_jump _IntroTextIntroduceGold

IntroTextEnoughAboutThem:
	text_jump _IntroTextEnoughAboutThem

IntroTextFinallyPleaseTellMeYourName:
	text_jump _IntroTextFinallyPleaseTellMeYourName

IntroTextEnding:
	text_jump _IntroTextEnding

FadeOutIntroPic:
	ld c, 1
	call FadeBGToLightestColor
	jp ClearTileMap

NamePlayer:
	callba MovePlayerPicRight
	callba ShowPlayerNamingChoices
	ld a, [wMenuCursorY]
	dec a
	jr z, .NewName
	call StorePlayerName
	callba ApplyMonOrTrainerPals
	jpba MovePlayerPicLeft

.NewName
	ld b, 1
	ld de, PlayerName
	callba NamingScreen

	ld c, 1
	call FadeBGToLightestColor
	call ClearTileMap

	call LoadFontsExtra
	call ApplyTilemapInVBlank

	xor a
	ld [wCurPartySpecies], a
	callba DrawIntroPlayerPic

	xor a
	ld [TrainerClass], a
	ld b, SCGB_FRONTPICPALS
	predef GetSGBLayout
	ld c, 1
	call FadeOutBGPals

	ld hl, PlayerName
	ld de, .Chris
	ld a, [wPlayerGender]
	bit 0, a
	jr z, .Male
	ld de, .Kris
.Male
	jp InitName

.Chris
	db "Adam@@@@@@@"
.Kris
	db "Cyan@@@@@@@"

StorePlayerName:
	ld a, "@"
	ld bc, NAME_LENGTH
	ld hl, PlayerName
	call ByteFill
	ld hl, PlayerName
	ld de, wStringBuffer2
	jp CopyName2

ShrinkPlayer:

	ld a, 0 << 7 | 32 ; fade out
	ld [MusicFade], a
	ld de, MUSIC_NONE
	ld a, e
	ld [MusicFadeIDLo], a
	ld a, d
	ld [MusicFadeIDHi], a

	ld de, SFX_ESCAPE_ROPE
	call PlaySFX

	ld c, 8
	call DelayFrames

	ld hl, Shrink1Pic
	ld b, BANK(Shrink1Pic)
	call ShrinkFrame

	ld c, 8
	call DelayFrames

	ld hl, Shrink2Pic
	ld b, BANK(Shrink2Pic)
	call ShrinkFrame

	ld c, 8
	call DelayFrames

	hlcoord 6, 5
	lb bc, 7, 7
	call ClearBox

	call Delay2

	call Intro_PlacePlayerSprite
	call LoadFontsExtra

	ld c, 50
	call DelayFrames

	ld c, 1
	call FadeToLightestColor
	jp ClearTileMap

Intro_WipeInFrontpic:
	ld a, -$70
	ld [hSCX], a
	call DelayFrame
	ld a, %11100100
	call DmgToCgbBGPals
.loop
	call DelayFrame
	ld a, [hSCX]
	add $8
	ld [hSCX], a
	jr nc, .loop
	jp DelayFrame

Intro_PrepTrainerPic:
	ld [TrainerClass], a
	xor a
	ld [wCurPartySpecies], a
	ld b, SCGB_FRONTPICPALS
	predef GetSGBLayout
	xor a
	call DmgToCgbBGPals
	ld de, VTiles2
	predef GetTrainerPic
	xor a
	ld [hGraphicStartTile], a
	hlcoord 6, 4
	lb bc, 7, 7
	predef PlaceGraphic
Intro_WaitBGMapAndFadeOutBGPals:
	call ApplyTilemapInVBlank
	ld c, 1
	call FadeOutBGPals
	ld a, %11100100
	jp DmgToCgbBGPals

ShrinkFrame:
	ld de, VTiles2
	ld c, $31
	call DecompressRequest2bpp
	xor a
	ld [hGraphicStartTile], a
	hlcoord 6, 4
	lb bc, 7, 7
	predef_jump PlaceGraphic

Intro_PlacePlayerSprite:
	call GetPlayerIcon
	ld hl, VTiles0
	ld c, 12
	ld de, wDecompressScratch
	call Request2bppInWRA6

	ld hl, .PlayerSpriteOAM
	ld de, Sprites
	ld bc, 4 * 4
	rst CopyBytes
	ret

.PlayerSpriteOAM:
	db  9 * 8 + 4,  9 * 8, 0, 0
	db  9 * 8 + 4, 10 * 8, 1, 0
	db 10 * 8 + 4,  9 * 8, 2, 0
	db 10 * 8 + 4, 10 * 8, 3, 0

CrystalIntroSequence:
	callba Copyright_GFPresents
	;jr c, StartTitleScreen
	;callba CrystalIntro

StartTitleScreen:
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	callba _TitleScreen
	ld a, rSCX & $ff
	ld [wLCDCPointer], a
	ld hl, rIE
	set LCD_STAT, [hl]
	call DelayFrame
.loop
	call RunTitleScreen
	jr nc, .loop
	ld a, [wcf64]
	bit 1, a
	jr nz, .timed_out
	ld de, MUSIC_NONE
	call PlayMusic
	ld a, LARVITAR
	call PlayCry2
	jr .handleLoop
.wait
	callba SuicuneFrameIterator
.handleLoop
	call DelayFrame
	ld hl, Channel5Flags
	bit 0, [hl]
	jr nz, .wait
	ld hl, Channel6Flags
	bit 0, [hl]
	jr nz, .wait
	ld hl, Channel7Flags
	bit 0, [hl]
	jr nz, .wait
	ld hl, Channel8Flags
	bit 0, [hl]
	jr nz, .wait
.timed_out
	pop af
	ld [rSVBK], a
	ld hl, rIE
	res LCD_STAT, [hl]
	ld hl, rLCDC
	res 2, [hl]
	call DisableLCD
	call LoadLCDCode
	call ClearSprites
	call ForcePushOAM
	call ClearPalettes
	call ForceUpdateCGBPals
	call ClearScreen
	ld hl, VBGMap0
	ld bc, BG_MAP_WIDTH * SCREEN_HEIGHT
	ld a, " "
	call ByteFill
	xor a
	ld [hBGMapHalf], a
	ld a, 18
	ld [hTilesPerCycle], a
	ld a, 6
	ld [hBGMapMode], a
	call UpdateBGMap
	xor a
	ld [hBGMapAddress], a
	ld [hVBlank], a
	ld [hSCX], a
	ld [hSCY], a
	inc a
	ld [hBGMapMode], a
	ld a, $7
	ld [hWX], a
	ld a, $90
	ld [hWY], a
	ld b, SCGB_SCROLLINGMENU
	predef GetSGBLayout
	call UpdateTimePals
	call EnableLCD
	ld a, [wcf64]
	cp $5
	jr c, .ok
	xor a
.ok
	jumptable

.dw
	dw _MainMenu
	dw DeleteSaveData
	dw CrystalIntroSequence
	dw CrystalIntroSequence
	dw ResetClock

RunTitleScreen:
	ld a, [wJumptableIndex]
	bit 7, a
	jr nz, .done_title
	jumptable .scenes
	callba SuicuneFrameIterator
	call DelayFrame
	call Joypad
	and a
	ret

.done_title
	scf
	ret

.scenes
	dw TitleScreenEntrance
	dw TitleScreenTimer
	dw TitleScreenMain
	dw TitleScreenEnd

TitleScreenEntrance:

; Animate the logo:
; Move each line by 4 pixels until our count hits 0.
	ld a, [hSCX]
	and a
	jr z, .done
	sub 4
	ld [hSCX], a
	ld c, a

; Reversed signage for every other line's position.
; This is responsible for the interlaced effect.
	ld hl, wLYOverrides
.loop
	ld b, l
	bit 0, b
	push af
	ld a, c
	add b
	sub 80
	ld b, a
	jr nc, .plus
	pop af
	xor a
	jr .noinvert
.plus
	pop af
	ld a, b
	jr nz, .noinvert
	xor a
	sub b
.noinvert
	ld [hli], a
	ld a, l
	cp 78
	jr c, .loop

	jpba AnimateTitleCrystal

.done
; Next scene
	ld hl, wJumptableIndex
	inc [hl]
	xor a
	ld [wLCDCPointer], a

; Play the title screen music.
	ld de, MUSIC_ROUTE_A
	call PlayMusic

	ld a, $88
	ld [hWY], a
	ret

TitleScreenTimer:

; Next scene
	ld hl, wJumptableIndex
	inc [hl]

; Start a timer
	ld hl, wcf65
	ld a, 6400 & $ff
	ld [hli], a
	ld [hl], 6400 >> 8

	di
	ld a, 1
	ld [hVBlank], a
	ld hl, LCD_TitleScreenMain
	ld de, LCD
	ld bc, LCD_TitleScreenMainEnd - LCD_TitleScreenMain
	rst CopyBytes
	reti

LCD_TitleScreenMain:
	push af ; 1
	push hl ; 2
	ld a, [rLY] ; 4
	cp 57 ; 6
	jr nc, .secondSet ; 8
	add a ; 9
	add a ; 10
	ld l, a ; 11
	ld h, wTitleScreenBGPIListAndSpectrumColours >> 8 ; 13
	ld a, [hli] ; 14
	ld [rBGPI], a ; 16
	ld a, [hli] ; 17
	ld [rBGPD], a ; 19
	ld a, [hl] ; 20
	ld [rBGPD], a ; 22
.skip
	pop hl ; 23
	pop af ; 24
	reti ; 25
.secondSet
	cp 67 ; 27
	jr c, .skip ; 29
	cp 79 ; 31
	ld a, [hPrintNum7] ; 33
	jr c, .skip2 ; 35
	xor a ; 36
.skip2
	ld [rSCX], a ; 38
	jr .skip ; 40
LCD_TitleScreenMainEnd:

TitleScreenMain:
; Run the timer down.
	ld hl, wcf65
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, e
	or d
	jr z, .end

	dec de
	ld [hl], d
	dec hl
	ld [hl], e

; Save data can be deleted by pressing Up + B + Select.
	call GetJoypad
	ld hl, hJoyDown
	ld a, [hl]
	and D_UP + B_BUTTON + SELECT
	cp  D_UP + B_BUTTON + SELECT
	jr z, .delete_save_data

; To bring up the clock reset dialog:

; Hold Down + B + Select to initiate the sequence.
	ld a, [hClockResetTrigger]
	cp $34
	jr z, .check_clock_reset

	ld a, [hl]
	and D_DOWN + B_BUTTON + SELECT
	cp  D_DOWN + B_BUTTON + SELECT
	jr nz, .check_start

	ld a, $34
	ld [hClockResetTrigger], a
	jr .check_start

; Keep Select pressed, and hold Left + Up.
; Then let go of Select.
.check_clock_reset
	bit SELECT_F, [hl]
	jr nz, .check_start

	xor a
	ld [hClockResetTrigger], a

	ld a, [hl]
	and D_LEFT + D_UP
	cp  D_LEFT + D_UP
	jr z, .clock_reset

; Press Start or A to start the game.
.check_start
	ld a, [hl]
	and START | A_BUTTON
	jr nz, .incave
	ret

.incave
	ld a, 0
	jr .done

.delete_save_data
	ld a, 1

.done
	ld [wcf64], a

; Return to the intro sequence.
	ld hl, wJumptableIndex
	set 7, [hl]
	ret

.end
; Next scene
	ld hl, wJumptableIndex
	inc [hl]

; Fade out the title screen music
	xor a
	ld [MusicFadeIDLo], a
	ld [MusicFadeIDHi], a
	ld hl, MusicFade
	ld [hl], 8 ; 1 second

	ld hl, wcf65
	inc [hl]
	ret

.clock_reset
	ld a, 4
	ld [wcf64], a

; Return to the intro sequence.
	ld hl, wJumptableIndex
	set 7, [hl]
	ret

TitleScreenEnd:
; Wait until the music is done fading.

	ld hl, wcf65
	inc [hl]

	ld a, [MusicFade]
	and a
	ret nz

	ld a, 2
	ld [wcf64], a

; Back to the intro.
	ld hl, wJumptableIndex
	set 7, [hl]
	ret

DeleteSaveData:
	callba _DeleteSaveData
	jp Init

ResetClock:
	callba _ResetClock
	jp Init

Copyright:
	call ClearTileMap
	call LoadFontsExtra
	ld de, CopyrightGFX
	ld hl, VTiles2 tile $60
	lb bc, BANK(CopyrightGFX), $1d
	call Get2bpp
	hlcoord 2, 2
	ld de, .copyright_string
	call PlaceString
	ld de, .disclaimer_string
	ld hl, VTiles1 tile $14
	lb bc, 2, $3e
	predef PlaceVWFString
	hlcoord 1, 12
	ld a, $94
	ld b, 18
	call .fillinc
	hlcoord 1, 13
	ld b, 18
	call .fillinc
	hlcoord 3, 15
	ld b, 14
	call .fillinc
	hlcoord 4, 16
	ld b, 12
.fillinc
	ld [hli], a
	inc a
	dec b
	jr nz, .fillinc
	ret

.copyright_string
	; ©1995-2001 Nintendo
	db   $60, $61, $62, $63, $64, $65, $66
	db   $67, $68, $69, $6a, $6b, $6c

	; ©1995-2001 Creatures inc.
	next $60, $61, $62, $63, $64, $65, $66
	db   $6d, $6e, $6f, $70, $71, $72, $7a, $7b, $7c

	; ©1995-2001 GAME FREAK inc.
	next $60, $61, $62, $63, $64, $65, $66
	db   $73, $74, $75, $76, $77, $78, $79, $7a, $7b, $7c

	db "@"

.disclaimer_string
	db "This is a fan project based<LNBRK>"
	db " ┘on the Pokémon franchise.<LNBRK>"
	db " ┘┘┘Please support the<LNBRK>"
	db " official products.@"

GameInit::
	callba TryLoadSaveData
	call ClearWindowData
	call ClearBGPalettes
	call ClearTileMap
	ld a, VBGMap0 / $100
	ld [hBGMapAddress + 1], a
	xor a
	ld [hBGMapAddress], a
	ld [hJoyDown], a
	ld [hSCX], a
	ld [hSCY], a
	ld a, $90
	ld [hWY], a
	call ApplyTilemapInVBlank
	jp CrystalIntroSequence
