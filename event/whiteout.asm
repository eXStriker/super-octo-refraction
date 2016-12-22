Script_BattleWhiteout::
	callasm BattleBGMap
	jump Script_Whiteout

Script_OverworldWhiteout::
	refreshscreen $0
	callasm OverworldBGMap
	loadvar wWhiteOutFlags, 0
Script_Whiteout:
	checkflag ENGINE_POKEMON_MODE
	iftrue .skipWhiteOutText
	writetext .WhitedOutText
	waitbutton

.skipWhiteOutText
	special Special_FadeOutMusic
	special FadeOutPalettes
	pause 40
	special HealParty
	callasm GetWhiteoutSpawn
	special ClearSafariZoneFlag
	newloadmap MAPSETUP_WARP
	end_all

.WhitedOutText
	; is out of useable #mon!  whited out!
	text_far UnknownText_0x1c0a4e
	start_asm
	ld a, [rSVBK]
	push af
	ld a, BANK(wSoundStackSize)
	ld [rSVBK], a
	xor a
	ld [wSoundStackSize], a
	pop af
	ld [rSVBK], a
	call Gen6Payout
	ld hl, wWhiteOutFlags
	ld a, [hl]
	ld [hl], 0
	bit 0, a
	jr z, .wild_panic
	ld hl, .PaidToWinnerText
	jr .okay

.wild_panic
	ld hl, .PanickedAndDroppedText
.okay
	call PrintText
	ld hl, .FinishWhiteOutText
	ret

.PaidToWinnerText
	text_jump PaidToWinnerText

.PanickedAndDroppedText
	text_jump PanickedAndDroppedText

.FinishWhiteOutText
	text_jump FinishWhiteOutText

OverworldBGMap:
	ld c, 1
	call FadeOutPals
	call ClearPalettes
	call ClearScreen
	call ApplyAttrAndTilemapInVBlank
	jp HideSprites

BattleBGMap:
	ld b, SCGB_BATTLE_GRAYSCALE
	predef GetSGBLayout
	jp SetPalettes

Gen6Payout:
	ld hl, Badges
	ld b, 2
	call CountSetBits
	cp 8
	jr c, .less_than_8_badges
	ld a, 120
	jr .got_base

.less_than_8_badges
	ld hl, .Payouts
	add l
	ld l, a
	jr nc, .okay
	inc h
.okay
	ld a, [hl]
.got_base
	ld [hMultiplier], a
	ld hl, PartyMon1Level
	ld a, [wPartyCount]
	ld e, a
	ld d, 1
	jr .loop

.next
	ld bc, PARTYMON_STRUCT_LENGTH
	add hl, bc
.loop
	ld a, [hl]
	cp d
	jr c, .skip
	ld d, a
.skip
	dec e
	jr nz, .next
	ld a, d
	ld [hMultiplicand + 2], a
	xor a
	ld [hMultiplicand + 1], a
	ld [hMultiplicand], a
	predef Multiply
	ld a, [hProduct + 1]
	ld [hMoneyTemp], a
	ld a, [hProduct + 2]
	ld [hMoneyTemp + 1], a
	ld a, [hProduct + 3]
	ld [hMoneyTemp + 2], a
	ld bc, hMoneyTemp
	ld de, Money
	callba CompareMoney
	jr c, .zero_out
	ld bc, hMoneyTemp
	ld de, Money
	jpba TakeMoney

.zero_out
	ld hl, Money
	ld a, [hli]
	ld [hMoneyTemp], a
	ld a, [hli]
	ld [hMoneyTemp + 1], a
	ld a, [hl]
	ld [hMoneyTemp + 2], a
	xor a
	ld [hld], a
	ld [hld], a
	ld [hl], a
	ret

.Payouts:
	db 8, 16, 24, 36, 64, 80, 100, 120

GetWhiteoutSpawn:
	ld a, [wLastSpawnMapGroup]
	ld d, a
	ld a, [wLastSpawnMapNumber]
	ld e, a
	callba IsSpawnPoint
	ld a, c
	jr c, .yes
	xor a ; SPAWN_HOME

.yes
	ld [wd001], a
	ret
