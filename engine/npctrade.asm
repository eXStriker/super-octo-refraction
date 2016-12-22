; Trade struct
TRADE_DIALOG  EQU 0
TRADE_GIVEMON EQU 1
TRADE_GETMON  EQU 2
TRADE_NICK    EQU 3
TRADE_DVS     EQU 14
TRADE_ITEM    EQU 16
TRADE_OT_ID   EQU 17
TRADE_OT_NAME EQU 19
TRADE_GENDER  EQU 30
TRADE_PADDING EQU 31

; Trade dialogs
TRADE_INTRO    EQU 0
TRADE_CANCEL   EQU 1
TRADE_WRONG    EQU 2
TRADE_COMPLETE EQU 3
TRADE_AFTER    EQU 4

TRADE_EITHER_GENDER EQU 0
TRADE_MALE_ONLY     EQU 1
TRADE_FEMALE_ONLY   EQU 2

NPCTrade::
	ld a, e
	ld [wJumptableIndex], a
	call Trade_GetDialog
	ld b, CHECK_FLAG
	call TradeFlagAction
	ld a, TRADE_AFTER
	jr nz, .done

	ld a, TRADE_INTRO
	call PrintTradeText

	call YesNoBox
	ld a, TRADE_CANCEL
	jr c, .done

; Select givemon from party
	ld b, 6
	callba SelectTradeOrDaycareMon
	ld a, TRADE_CANCEL
	jr c, .done

	ld e, TRADE_GIVEMON
	call GetTradeAttribute
	ld a, [wCurPartySpecies]
	cp [hl]
	ld a, TRADE_WRONG
	jr nz, .done

	call CheckTradeGender
	ld a, TRADE_WRONG
	jr c, .done

	ld b, SET_FLAG
	call TradeFlagAction

	ld hl, ConnectLinkCableText
	call PrintText

	call DoNPCTrade
	call PushSoundstate
	call .TradeAnimation
	call GetTradeMonNames

	ld hl, TradedForText
	call PrintText

	call PopSoundstate

	ld a, TRADE_COMPLETE

.done
	jp PrintTradeText

.TradeAnimation
	call DisableSpriteUpdates
	ld a, [wJumptableIndex]
	push af
	ld a, [wcf64]
	push af
	callba TradeAnimation
	pop af
	ld [wcf64], a
	pop af
	ld [wJumptableIndex], a
	jp ReturnToMapWithSpeechTextbox

CheckTradeGender:
	xor a
	ld [wMonType], a

	ld e, TRADE_GENDER
	call GetTradeAttribute
	ld a, [hl]
	and a
	jr z, .matching
	cp 1
	jr z, .check_male

	callba GetGender
	jr nz, .not_matching
	jr .matching

.check_male
	callba GetGender
	jr z, .not_matching

.matching
	and a
	ret

.not_matching
	scf
	ret

TradeFlagAction:
	ld hl, wTradeFlags
	ld a, [wJumptableIndex]
	ld c, a
	predef FlagAction
	ld a, c
	and a
	ret

Trade_GetDialog:
	ld e, TRADE_DIALOG
	call GetTradeAttribute
	ld a, [hl]
	ld [wcf64], a
	ret

DoNPCTrade:
	ld e, TRADE_GIVEMON
	call GetTradeAttribute
	ld a, [hl]
	ld [wPlayerTrademonSpecies], a

	ld e, TRADE_GETMON
	call GetTradeAttribute
	ld a, [hl]
	ld [wOTTrademonSpecies], a

	ld a, [wPlayerTrademonSpecies]
	ld de, wPlayerTrademonSpeciesName
	call GetTradeMonName
	call CopyTradeName

	ld a, [wOTTrademonSpecies]
	ld de, wOTTrademonSpeciesName
	call GetTradeMonName
	call CopyTradeName

	ld hl, wPartyMonOT
	ld bc, NAME_LENGTH
	call Trade_GetAttributeOfCurrentPartymon
	ld de, wPlayerTrademonOTName
	call CopyTradeName

	ld hl, PlayerName
	ld de, wPlayerTrademonSenderName
	call CopyTradeName

	ld hl, PartyMon1ID
	ld bc, PARTYMON_STRUCT_LENGTH
	call Trade_GetAttributeOfCurrentPartymon
	ld de, wPlayerTrademonID
	call Trade_CopyTwoBytes

	ld hl, PartyMon1DVs
	ld bc, PARTYMON_STRUCT_LENGTH
	call Trade_GetAttributeOfCurrentPartymon
	ld de, wPlayerTrademonDVs
	call Trade_CopyTwoBytes

	ld hl, PartyMon1Species
	ld bc, PARTYMON_STRUCT_LENGTH
	call Trade_GetAttributeOfCurrentPartymon
	ld b, h
	ld c, l
	callba GetCaughtGender
	ld a, c
	ld [wPlayerTrademonCaughtData], a

	ld e, TRADE_DIALOG
	call GetTradeAttribute
	ld a, [hl]
	cp 3
	ld a, 1
	jr c, .okay
	ld a, 2
.okay
	ld [wOTTrademonCaughtData], a

	ld hl, PartyMon1Level
	ld bc, PARTYMON_STRUCT_LENGTH
	call Trade_GetAttributeOfCurrentPartymon
	ld a, [hl]
	ld [CurPartyLevel], a
	ld a, [wOTTrademonSpecies]
	ld [wCurPartySpecies], a
	xor a
	ld [wMonType], a
	ld [wPokemonWithdrawDepositParameter], a
	callba RemoveMonFromPartyOrBox
	predef TryAddMonToParty

	ld e, TRADE_DIALOG
	call GetTradeAttribute
	ld a, [hl]
	cp TRADE_COMPLETE
	ld b, RESET_FLAG
	jr c, .incomplete
	ld b, SET_FLAG
.incomplete
	callba SetGiftPartyMonCaughtData

	ld e, TRADE_NICK
	call GetTradeAttribute
	ld de, wOTTrademonNickname
	call CopyTradeName

	ld hl, wPartyMonNicknames
	ld bc, PKMN_NAME_LENGTH
	call Trade_GetAttributeOfLastPartymon
	ld hl, wOTTrademonNickname
	call CopyTradeName

	ld e, TRADE_OT_NAME
	call GetTradeAttribute
	push hl
	ld de, wOTTrademonOTName
	call CopyTradeName
	pop hl
	ld de, wOTTrademonSenderName
	call CopyTradeName

	ld hl, wPartyMonOT
	ld bc, NAME_LENGTH
	call Trade_GetAttributeOfLastPartymon
	ld hl, wOTTrademonOTName
	call CopyTradeName

	ld e, TRADE_DVS
	call GetTradeAttribute
	ld de, wOTTrademonDVs
	call Trade_CopyTwoBytes

	ld hl, PartyMon1DVs
	ld bc, PARTYMON_STRUCT_LENGTH
	call Trade_GetAttributeOfLastPartymon
	ld hl, wOTTrademonDVs
	call Trade_CopyTwoBytes

	ld e, TRADE_OT_ID
	call GetTradeAttribute
	ld de, wOTTrademonID + 1
	call Trade_CopyTwoBytesReverseEndian

	ld hl, PartyMon1ID
	ld bc, PARTYMON_STRUCT_LENGTH
	call Trade_GetAttributeOfLastPartymon
	ld hl, wOTTrademonID
	call Trade_CopyTwoBytes

	ld e, TRADE_ITEM
	call GetTradeAttribute
	push hl
	ld hl, PartyMon1Item
	ld bc, PARTYMON_STRUCT_LENGTH
	call Trade_GetAttributeOfLastPartymon
	pop hl
	ld a, [hl]
	ld [de], a

	push af
	push bc
	push de
	push hl
	ld a, [wCurPartyMon]
	push af
	ld a, [wPartyCount]
	dec a
	ld [wCurPartyMon], a
	callba ComputeNPCTrademonStats
	pop af
	ld [wCurPartyMon], a
	pop hl
	pop de
	pop bc
	pop af
	ret

GetTradeAttribute:
	ld d, 0
	push de
	ld a, [wJumptableIndex]
	and $f
	swap a
	ld e, a
	ld d, 0
	ld hl, NPCTrades
	add hl, de
	add hl, de
	pop de
	add hl, de
	ret

Trade_GetAttributeOfCurrentPartymon:
	ld a, [wCurPartyMon]
	rst AddNTimes
	ret

Trade_GetAttributeOfLastPartymon:
	ld a, [wPartyCount]
	dec a
	rst AddNTimes
	ld e, l
	ld d, h
	ret

GetTradeMonName:
	push de
	ld [wd265], a
	call GetBasePokemonName
	ld hl, wStringBuffer1
	pop de
	ret

CopyTradeName:
	ld bc, NAME_LENGTH
	rst CopyBytes
	ret

Trade_CopyTwoBytes:
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ret

Trade_CopyTwoBytesReverseEndian:
	ld a, [hli]
	ld [de], a
	dec de
	ld a, [hl]
	ld [de], a
	ret

GetTradeMonNames:
	ld e, TRADE_GETMON
	call GetTradeAttribute
	ld a, [hl]
	call GetTradeMonName

	ld de, wStringBuffer2
	call CopyTradeName

	ld e, TRADE_GIVEMON
	call GetTradeAttribute
	ld a, [hl]
	call GetTradeMonName

	ld de, wMonOrItemNameBuffer
	call CopyTradeName

	ld hl, wStringBuffer1
.loop
	ld a, [hli]
	cp "@"
	jr nz, .loop

	dec hl
	push hl
	ld e, TRADE_GENDER
	call GetTradeAttribute
	ld a, [hl]
	pop hl
	and a
	ret z

	cp 1
	ld a, "♂"
	jr z, .done
	ld a, "♀"
.done
	ld [hli], a
	ld [hl], "@"
	ret

NPCTrades:
npctrade: MACRO
	db \1, \2, \3, \4 ; dialog set, requested mon, offered mon, nickname
	db \5, \6 ; dvs
	shift
	db \6 ; item
	dw \7 ; OT ID
	db \8, \9, 0 ; OT name, gender requested
ENDM


	npctrade 0, ABRA,       MACHOP,     "MUSCLE@@@@@", $37, $66, SITRUS_BERRY, 37460, "Mike@@@@@@@", TRADE_EITHER_GENDER ; 0
	npctrade 0, EXEGGCUTE,  DRIFLOON,   "DRIFLOON@@@", $96, $66, PERSIM_BERRY, 48926, "Johnny@@@@@", TRADE_EITHER_GENDER ; 1
	npctrade 2, TYROGUE,    CHINGLING,  "Chimer@@@@@", $96, $86, LEPPA_BERRY,  15616, "Chris@@@@@@", TRADE_EITHER_GENDER ; 2
	npctrade 0, SOLROCK,    LUNATONE,   "Lunala@@@@@", $00, $00, MOON_STONE,   11187, "Lana@@@@@@@", TRADE_EITHER_GENDER ; 3
	npctrade 0, GYARADOS,   RELICANTH,  "Canth@@@@@@", $00, $00, NO_ITEM,      23864, "Kelly@@@@@@", TRADE_EITHER_GENDER ; 4
	npctrade 0, MAGMAR,     ELECTABUZZ, "Oni@@@@@@@@", $00, $00, NO_ITEM,      26483, "Marcus@@@@@", TRADE_EITHER_GENDER ; 5

PrintTradeText:
	push af
	call GetTradeMonNames
	pop af
	ld bc, 2 * 4
	ld hl, TradeTexts
	rst AddNTimes
	ld a, [wcf64]
	ld c, a
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp PrintText

TradeTexts:
; intro
	dw TradeIntroText1
	dw TradeIntroText2
	dw TradeIntroText3
	dw TradeIntroText4

; cancel
	dw TradeCancelText1
	dw TradeCancelText2
	dw TradeCancelText3
	dw TradeCancelText4

; wrong mon
	dw TradeWrongText1
	dw TradeWrongText2
	dw TradeWrongText3
	dw TradeWrongText4

; completed
	dw TradeCompleteText1
	dw TradeCompleteText2
	dw TradeCompleteText3
	dw TradeCompleteText4

; after
	dw TradeAfterText1
	dw TradeAfterText2
	dw TradeAfterText3
	dw TradeAfterText4

ConnectLinkCableText:
	; OK, connect the Game Link Cable.
	text_jump UnknownText_0x1bd407

TradedForText:
	; traded givemon for getmon
	text_far UnknownText_0x1bd429
	start_asm
	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame
	ld de, SFX_DEX_FANFARE_80_109
	call PlaySFX
	call WaitSFX
	ld hl, .done
	ret

.done
	db "@"

TradeIntroText1:
	; I collect #mon. Do you have @ ? Want to trade it for my @ ?
	text_jump UnknownText_0x1bd449

TradeCancelText1:
	; You don't want to trade? Aww…
	text_jump UnknownText_0x1bd48c

TradeWrongText1:
	; Huh? That's not @ .  What a letdown…
	text_jump UnknownText_0x1bd4aa

TradeCompleteText1:
	; Yay! I got myself @ ! Thanks!
	text_jump UnknownText_0x1bd4d2

TradeAfterText1:
	; Hi, how's my old @  doing?
	text_jump UnknownText_0x1bd4f4

TradeIntroText2:
TradeIntroText3:
	; Hi, I'm looking for this #mon. If you have @ , would you trade it for my @ ?
	text_jump UnknownText_0x1bd512

TradeCancelText2:
TradeCancelText3:
	; You don't have one either? Gee, that's really disappointing…
	text_jump UnknownText_0x1bd565

TradeWrongText2:
TradeWrongText3:
	; You don't have @ ? That's too bad, then.
	text_jump UnknownText_0x1bd5a1

TradeCompleteText2:
	; Great! Thank you! I finally got @ .
	text_jump UnknownText_0x1bd5cc

TradeAfterText2:
	; Hi! The @ you traded me is doing great!
	text_jump UnknownText_0x1bd5f4

TradeIntroText4:
	; 's cute, but I don't have it. Do you have @ ? Want to trade it for my @ ?
	text_jump UnknownText_0x1bd621

TradeCancelText4:
	; You don't want to trade? Oh, darn…
	text_jump UnknownText_0x1bd673

TradeWrongText4:
	; That's not @ . Please trade with me if you get one.
	text_jump UnknownText_0x1bd696

TradeCompleteText4:
	; Wow! Thank you! I always wanted @ !
	text_jump UnknownText_0x1bd6cd

TradeAfterText4:
	; How is that @  I traded you doing? Your @ 's so cute!
	text_jump UnknownText_0x1bd6f5

TradeCompleteText3:
	; Uh? What happened?
	text_jump UnknownText_0x1bd731

TradeAfterText3:
	; Trading is so odd… I still have a lot to learn about it.
	text_jump UnknownText_0x1bd745
