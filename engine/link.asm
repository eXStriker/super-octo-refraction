	const_def 
	const GAME_GSC
	const GAME_TPP
	const GAME_PRISM

LinkCommunications:
	call ClearBGPalettes
	ld c, 80
	call DelayFrames
	call ClearScreen
	call ClearSprites
	call UpdateSprites
	xor a
	ld [hSCX], a
	ld [hSCY], a
	ld c, 80
	call DelayFrames
	call ClearScreen
	call UpdateSprites
	call LoadStandardFont
	call LoadFontsBattleExtra
	callba LinkComms_LoadPleaseWaitTextboxBorderGFX
	call ApplyAttrAndTilemapInVBlank
	hlcoord 3, 8
	lb bc, 2, 12
	ld d, h
	ld e, l
	callba LinkTextbox2
	hlcoord 4, 10
	ld de, String_PleaseWait
	call PlaceText
	call Function28eff
	call ApplyAttrAndTilemapInVBlank
	ld hl, wcf5d
	xor a
	ld [hli], a
	ld [hl], $50
	ld a, [wLinkMode]
	cp LINK_TIMECAPSULE
	jp nz, Gen2ToGen2LinkComms

TimeCapsule:
	call ClearLinkData
	call Link_PrepPartyData_Gen1
	call FixDataForLinkTransfer
	xor a
	ld [wPlayerLinkAction], a
	call Function87d
	ld a, [hLinkPlayerNumber]
	cp $2
	jr nz, .player_1
	ld c, 2
	call DelayFrames
	xor a
	ld [hSerialSend], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
	call DelayFrame
	xor a
	ld [hSerialSend], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a

.player_1
	ld de, MUSIC_NONE
	call PlayMusic
	ld c, $2
	call DelayFrames
	xor a
	ld [rIF], a
	ld a, $8
	ld [rIE], a
	ld hl, wLinkBuffer_D1F3
	ld de, EnemyMonSpecies
	ld bc, $11
	call Function75f
	ld a, $fe
	ld [de], a
	ld hl, wLinkData
	ld de, OTPlayerName
	ld bc, $1a8
	call Function75f
	ld a, $fe
	ld [de], a
	ld hl, wMisc
	ld de, wPlayerTrademonSpecies
	ld bc, wPlayerTrademonSpecies - wMisc
	call Function75f
	xor a
	ld [rIF], a
	ld a, $1d
	ld [rIE], a
	call Link_CopyRandomNumbers
	ld hl, OTPlayerName
	call Link_FindFirstNonControlCharacter_SkipZero
	push hl
	ld bc, NAME_LENGTH
	add hl, bc
	ld a, [hl]
	pop hl
	and a
	jp z, Function28b22
	cp $7
	jp nc, Function28b22
	ld de, wLinkData
	ld bc, $1a2
	call Link_CopyOTData
	ld de, wPlayerTrademonSpecies
	ld hl, wTimeCapsulePartyMon1Species
	ld c, $2
.loop
	ld a, [de]
	inc de
	and a
	jr z, .loop
	cp $fd
	jr z, .loop
	cp $fe
	jr z, .loop
	cp $ff
	jr z, .next
	push hl
	push bc
	ld b, $0
	dec a
	ld c, a
	add hl, bc
	ld a, $fe
	ld [hl], a
	pop bc
	pop hl
	jr .loop

.next
	ld hl, wc90f
	dec c
	jr nz, .loop
	ld hl, wLinkPlayerName
	ld de, OTPlayerName
	ld bc, NAME_LENGTH
	rst CopyBytes
	ld de, OTPartyCount
	ld a, [hli]
	ld [de], a
	inc de
.party_loop
	ld a, [hli]
	cp -1
	jr z, .done_party
	ld [wd265], a
	push hl
	push de
	callba ConvertMon_1to2
	pop de
	pop hl
	ld a, [wd265]
	ld [de], a
	inc de
	jr .party_loop

.done_party
	ld [de], a
	ld hl, wTimeCapsulePartyMon1Species
	call Function2868a
	ld de, MUSIC_NONE
	call PlayMusic
	ld a, [hLinkPlayerNumber]
	cp $2
	ld c, 66
	call z, DelayFrames
	ld de, MUSIC_ROUTE_30
	call PlayMusic
	jp InitTradeMenuDisplay

Gen2ToGen2LinkComms::
	call ClearLinkData
	call Link_PrepPartyData_Gen2
	call FixDataForLinkTransfer
	call Function29dba
	ld a, [hScriptVar]
	and a
	jp z, LinkTimeout
	ld a, [hLinkPlayerNumber]
	cp $2
	jr nz, .Player1
	ld c, 2
	call DelayFrames
	xor a
	ld [hSerialSend], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
	call DelayFrame
	xor a
	ld [hSerialSend], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a

.Player1
	ld de, MUSIC_NONE
	call PlayMusic
	ld c, 2
	call DelayFrames
	xor a
	ld [rIF], a
	ld a, $8
	ld [rIE], a
	ld hl, wLinkBuffer_D1F3
	ld de, EnemyMonSpecies
	ld bc, $11
	call Function75f
	ld a, $fe
	ld [de], a
	ld hl, wLinkData
	ld de, OTPlayerName
	ld bc, $1c2
	call Function75f
	ld a, $fe
	ld [de], a
	ld hl, wMisc
	ld de, wPlayerTrademonSpecies
	ld bc, $c8
	call Function75f
	ld a, [wLinkMode]
	cp LINK_TRADECENTER
	jr nz, .not_trading
	ld hl, wc9f4
	ld de, wcb84
	ld bc, $186
	call Function283f2

.not_trading
	xor a
	ld [rIF], a
	ld a, $1d
	ld [rIE], a
	ld de, MUSIC_NONE
	call PlayMusic
	call Link_CopyRandomNumbers
	ld hl, OTPlayerName
	call Link_FindFirstNonControlCharacter_SkipZero
	ld de, wLinkData
	ld bc, $1b9
	call Link_CopyOTData
	ld de, wPlayerTrademonSpecies
	ld hl, wLinkPlayerPartyMon1Species
	ld c, $2
.loop1
	ld a, [de]
	inc de
	and a
	jr z, .loop1
	cp $fd
	jr z, .loop1
	cp $fe
	jr z, .loop1
	cp $ff
	jr z, .next1
	push hl
	push bc
	ld b, $0
	dec a
	ld c, a
	add hl, bc
	ld a, $fe
	ld [hl], a
	pop bc
	pop hl
	jr .loop1

.next1
	ld hl, wc90f
	dec c
	jr nz, .loop1

	ld hl, wLinkData
	ld de, OTPlayerName
	ld bc, NAME_LENGTH
	rst CopyBytes
	ld de, OTPartyCount
	ld bc, 8
	rst CopyBytes
	ld de, OTPlayerID
	ld bc, 2
	rst CopyBytes
	ld de, OTPartyMons
	ld bc, OTPartyDataEnd - OTPartyMons
	rst CopyBytes

	ld a, [OTPlayerName + 8]
	cp GAME_PRISM
	call nz, MaskPokemon

	ld de, MUSIC_NONE
	call PlayMusic
	ld a, [hLinkPlayerNumber]
	cp $2
	ld c, 66
	call z, DelayFrames
	ld a, [wLinkMode]
	cp LINK_COLOSSEUM
	jr nz, .ready_to_trade
	ld a, CAL
	ld [OtherTrainerClass], a
	call ClearScreen
	callba Link_WaitBGMap
	ld hl, wOptions
	ld a, [hl]
	push af
	and $20
	or $3
	ld [hl], a
	ld hl, OTPlayerName
	ld de, OTClassName
	ld bc, NAME_LENGTH
	rst CopyBytes
	call ReturnToMapFromSubmenu
	ld a, [wLinkSuppressTextScroll]
	push af
	ld a, $1
	ld [wLinkSuppressTextScroll], a
	ld a, [rIE]
	push af
	ld a, [rIF]
	push af
	xor a
	ld [rIF], a
	ld a, [rIE]
	set 1, a
	ld [rIE], a
	pop af
	ld [rIF], a
	predef StartBattle
	ld a, [rIF]
	ld h, a
	xor a
	ld [rIF], a
	pop af
	ld [rIE], a
	ld a, h
	ld [rIF], a
	pop af
	ld [wLinkSuppressTextScroll], a
	pop af
	ld [wOptions], a
	callba LoadPokemonData
	jp Function28b22

.ready_to_trade
	ld de, MUSIC_ROUTE_30
	call PlayMusic
	jp InitTradeMenuDisplay

MaskPokemon:
	ld b, 6
	push hl
	ld hl, OTPartySpecies
.maskLoop ;This isn't Prism so mask all the Pokemon that don't appear in Prism as ID 00
	ld a, [hl]
	push hl
	push bc
	ld hl, PrismMons
	call IsInSingularArray
	pop bc
	pop hl
	jr nc, .pokemonOK
	xor a 
	ld [hl], a
.pokemonOK
	inc hl
	dec b
	jr nz, .maskLoop
	pop hl
	ret

LinkTimeout:
	ld de, .TooMuchTimeHasElapsed
	ld b, 10
.loop
	call DelayFrame
	call LinkDataReceived
	dec b
	jr nz, .loop
	xor a
	ld [hld], a
	ld [hl], a
	ld [hVBlank], a
	push de
	hlcoord 0, 12
	lb bc, 4, 18
	push de
	ld d, h
	ld e, l
	callba LinkTextbox2
	pop de
	pop hl
	bccoord 1, 14
	call ProcessTextCommands_
	ld c, 1
	call FadeBGToLightestColor
	call ClearScreen
	ld b, SCGB_SCROLLINGMENU
	predef GetSGBLayout
	jp ApplyAttrAndTilemapInVBlank

.TooMuchTimeHasElapsed:
	; Too much time has elapsed. Please try again.
	text_jump UnknownText_0x1c4183

Function283f2:
	ld a, $1
	ld [hFFCC], a
.loop
	ld a, [hl]
	ld [hSerialSend], a
	call Function78a
	push bc
	ld b, a
	inc hl
	ld a, $30
.delay_cycles
	dec a
	jr nz, .delay_cycles
	ld a, [hFFCC]
	and a
	ld a, b
	pop bc
	jr z, .load
	dec hl
	xor a
	ld [hFFCC], a
	jr .loop

.load
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ret

String_PleaseWait:
	text "PLEASE WAIT!"
	done

ClearLinkData:
	ld hl, wLinkData
	ld bc, wLinkDataEnd - wLinkData
	xor a
	jp ByteFill

FixDataForLinkTransfer:
	ld hl, wLinkBuffer_D1F3
	ld a, $fd
	ld b, LinkBattleRNs - wLinkBuffer_D1F3
.loop1
	ld [hli], a
	dec b
	jr nz, .loop1
	ld b, TempEnemyMonSpecies - LinkBattleRNs
.loop2
	call Random
	cp $fd
	jr nc, .loop2
	ld [hli], a
	dec b
	jr nz, .loop2
	ld hl, wMisc
	ld a, $fd
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld b, $c8
	xor a
.loop3
	ld [hli], a
	dec b
	jr nz, .loop3
	ld hl, wTimeCapsulePartyMon1 - 1 + 6
	ld de, wc612
	lb bc, 0, 0
.loop4
	inc c
	ld a, c
	cp $fd
	jr z, .next1
	ld a, b
	dec a
	jr nz, .next2
	push bc
	ld a, [wLinkMode]
	cp LINK_TIMECAPSULE
	ld b, $d
	jr z, .got_value
	ld b, $27
.got_value
	ld a, c
	cp b
	pop bc
	jr z, .done
.next2
	inc hl
	ld a, [hl]
	cp $fe
	jr nz, .loop4
	ld a, c
	ld [de], a
	inc de
	ld [hl], $ff
	jr .loop4

.next1
	ld a, $ff
	ld [de], a
	inc de
	lb bc, 1, 0
	jr .loop4

.done
	ld a, $ff
	ld [de], a
	ret

Link_PrepPartyData_Gen1:
	ld de, wLinkData
	ld a, $fd
	ld b, 6
.loop1
	ld [de], a
	inc de
	dec b
	jr nz, .loop1
	ld hl, PlayerName
	ld bc, NAME_LENGTH
	rst CopyBytes
	push de
	ld hl, wPartyCount
	ld a, [hli]
	ld [de], a
	inc de
.loop2
	ld a, [hli]
	cp -1
	jr z, .done_party
	ld [wd265], a
	push hl
	push de
	callba ConvertMon_2to1
	pop de
	pop hl
	ld a, [wd265]
	ld [de], a
	inc de
	jr .loop2

.done_party
	ld [de], a
	pop de
	ld hl, 1 + PARTY_LENGTH + 1
	add hl, de
	ld d, h
	ld e, l
	ld hl, PartyMon1Species
	ld c, PARTY_LENGTH
.mon_loop
	push bc
	call .ConvertPartyStruct2to1
	ld bc, PARTYMON_STRUCT_LENGTH
	add hl, bc
	pop bc
	dec c
	jr nz, .mon_loop
	ld hl, wPartyMonOT
	call .copy_ot_nicks
	ld hl, wPartyMonNicknames
.copy_ot_nicks
	ld bc, PARTY_LENGTH * NAME_LENGTH
	rst CopyBytes
	ret

.ConvertPartyStruct2to1
	ld b, h
	ld c, l
	push de
	push bc
	ld a, [hl]
	ld [wd265], a
	callba ConvertMon_2to1
	pop bc
	pop de
	ld a, [wd265]
	ld [de], a
	inc de
	ld hl, MON_HP
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	xor a
	ld [de], a
	inc de
	ld hl, MON_STATUS
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc de
	ld a, [bc]
	cp MAGNEMITE
	jr z, .steel_type
	cp MAGNETON
	jr nz, .skip_steel

.steel_type
	ld a, ELECTRIC
	ld [de], a
	inc de
	ld [de], a
	inc de
	jr .done_steel

.skip_steel
	push bc
	dec a
	ld hl, BaseData + 7 ; type
	ld bc, BaseData1 - BaseData0
	rst AddNTimes
	ld bc, 2
	ld a, BANK(BaseData)
	call FarCopyBytes
	pop bc

.done_steel
	push bc
	ld hl, MON_ITEM
	add hl, bc
	ld bc, MON_HAPPINESS - MON_ITEM
	rst CopyBytes
	pop bc

	ld hl, MON_LEVEL
	add hl, bc
	ld a, [hl]
	ld [de], a
	ld [CurPartyLevel], a
	inc de

	push bc
	ld hl, MON_MAXHP
	add hl, bc
	ld bc, MON_SAT - MON_MAXHP
	rst CopyBytes
	pop bc

	push de
	push bc

	ld a, [bc]
	dec a
	push bc
	ld b, 0
	ld c, a
	ld hl, KantoMonSpecials
	add hl, bc
	ld a, BANK(KantoMonSpecials)
	call GetFarByte
	ld [BaseSpecialAttack], a
	pop bc

	ld hl, MON_STAT_EXP - 1
	add hl, bc
	ld c, STAT_SATK
	ld b, TRUE
	predef CalcPkmnStatC

	pop bc
	pop de

	ld a, [hQuotient + 1]
	ld [de], a
	inc de
	ld a, [hQuotient + 2]
	ld [de], a
	inc de
	ld h, b
	ld l, c
	ret

Link_PrepPartyData_Gen2:
	ld de, wLinkData
	ld a, $fd
	ld b, 6
.loop1
	ld [de], a
	inc de
	dec b
	jr nz, .loop1
	; de = $c806
	ld hl, PlayerName
	ld bc, NAME_LENGTH
	rst CopyBytes
	; de = $c811
	ld hl, wPartyCount
	ld bc, 1 + PARTY_LENGTH + 1
	rst CopyBytes
	; de = $c819
	ld hl, PlayerID
	ld bc, 2
	rst CopyBytes
	; de = $c81b
	ld hl, PartyMon1Species
	ld bc, PARTY_LENGTH * PARTYMON_STRUCT_LENGTH
	rst CopyBytes
	; de = $c93b
	ld hl, wPartyMonOT
	ld bc, PARTY_LENGTH * NAME_LENGTH
	rst CopyBytes
	; de = $c97d
	ld hl, wPartyMonNicknames
	ld bc, PARTY_LENGTH * PKMN_NAME_LENGTH
	rst CopyBytes
	; de = $c9bf

; Okay, we did all that.  Now, are we in the trade center?
	ld a, [wLinkMode]
	cp LINK_TRADECENTER
	ret nz

; Fill 5 bytes at wc9f4 with $20
	ld de, wc9f4
	ld a, $20
	call FillFiveBytesAtDE

; Prism has no mail, but other gen 2 games do.
; Emulate a state where no party Pokemon has mail.
	ld h, d
	ld l, e
	ld bc, 12 * 47
	xor a
	call ByteFill
	ld hl, wcb13
	ld [hl], $ff
	ret

FillFiveBytesAtDE:
	ld c, $5
.loop
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	ret

Function2868a:
	push hl
	ld d, h
	ld e, l
	ld bc, wLinkOTPartyMonTypes
	ld hl, wcbe8
	ld a, c
	ld [hli], a
	ld [hl], b
	ld hl, OTPartyMon1Species
	ld c, PARTY_LENGTH
.loop
	push bc
	call .ConvertToGen2
	pop bc
	dec c
	jr nz, .loop
	pop hl
	ld bc, PARTY_LENGTH * REDMON_STRUCT_LENGTH
	add hl, bc
	ld de, wOTPartyMonOT
	ld bc, PARTY_LENGTH * NAME_LENGTH
	rst CopyBytes
	ld de, OTPartyMonNicknames
	ld bc, PARTY_LENGTH * PKMN_NAME_LENGTH
	rst CopyBytes
	ret

.ConvertToGen2
	ld b, h
	ld c, l
	ld a, [de]
	inc de
	push bc
	push de
	ld [wd265], a
	callba ConvertMon_1to2
	pop de
	pop bc
	ld a, [wd265]
	ld [bc], a
	ld [wCurSpecies], a
	ld hl, MON_HP
	add hl, bc
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hl], a
	inc de
	ld hl, MON_STATUS
	add hl, bc
	ld a, [de]
	inc de
	ld [hl], a
	ld hl, wcbe8
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, l
	ld [wcbe8], a
	ld a, h
	ld [wcbe8 + 1], a
	push bc
	ld hl, MON_ITEM
	add hl, bc
	push hl
	ld h, d
	ld l, e
	pop de
	push bc
	ld a, [hli]
	ld b, a
	call TimeCapsule_ReplaceTeruSama
	ld a, b
	ld [de], a
	inc de
	pop bc
	ld bc, $19
	rst CopyBytes
	pop bc
	ld d, h
	ld e, l
	ld hl, $1f
	add hl, bc
	ld a, [de]
	inc de
	ld [hl], a
	ld [CurPartyLevel], a
	push bc
	ld hl, $24
	add hl, bc
	push hl
	ld h, d
	ld l, e
	pop de
	ld bc, 8
	rst CopyBytes
	pop bc
	call GetBaseData
	push de
	push bc
	ld d, h
	ld e, l
	ld hl, MON_STAT_EXP - 1
	add hl, bc
	ld c, STAT_SATK
	ld b, TRUE
	predef CalcPkmnStatC
	pop bc
	pop hl
	ld a, [hQuotient + 1]
	ld [hli], a
	ld a, [hQuotient + 2]
	ld [hli], a
	push hl
	push bc
	ld hl, MON_STAT_EXP - 1
	add hl, bc
	ld c, STAT_SDEF
	ld b, TRUE
	predef CalcPkmnStatC
	pop bc
	pop hl
	ld a, [hQuotient + 1]
	ld [hli], a
	ld a, [hQuotient + 2]
	ld [hli], a
	push hl
	ld hl, $1b
	add hl, bc
	ld a, $46
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	pop hl
	inc de
	inc de
	ret

TimeCapsule_ReplaceTeruSama:
	ld a, b
	and a
	ret z
	push hl
	ld hl, .TimeCapsuleAlt
.loop
	ld a, [hli]
	and a
	jr z, .end
	cp b
	jr z, .found
	inc hl
	jr .loop

.found
	ld b, [hl]

.end
	pop hl
	ret

.TimeCapsuleAlt
; Pokémon traded from RBY do not have held items, so GSC usually interprets the
; catch rate as an item. However, if the catch rate appears in this table, the
; item associated with the table entry is used instead.
	;db ITEM_19, LEFTOVERS
	;db ITEM_2D, PERSIM_BERRY
	;db ITEM_32, SITRUS_BERRY
	;db ITEM_5A, ORAN_BERRY
	;db ITEM_64, ORAN_BERRY
	;db ITEM_78, ORAN_BERRY
	;db ITEM_87, ORAN_BERRY
	;db ITEM_BE, ORAN_BERRY
	;db ITEM_C3, ORAN_BERRY
	;db ITEM_DC, ORAN_BERRY
	;db HM_08,   ORAN_BERRY
	db -1,      ORAN_BERRY
	db  0

Link_CopyOTData:
.loop
	ld a, [hli]
	cp $fe
	jr z, .loop
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ret

Link_CopyRandomNumbers:
	ld a, [hLinkPlayerNumber]
	cp $2
	ret z
	ld hl, EnemyMonSpecies
	call Link_FindFirstNonControlCharacter_AllowZero
	ld de, LinkBattleRNs
	ld c, 10
.loop
	ld a, [hli]
	cp $fe
	jr z, .loop
	cp $fd
	jr z, .loop
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	ret

Link_FindFirstNonControlCharacter_SkipZero:
.loop
	ld a, [hli]
	and a
	jr z, .loop
	cp $fd
	jr z, .loop
	cp $fe
	jr z, .loop
	dec hl
	ret

Link_FindFirstNonControlCharacter_AllowZero:
.loop
	ld a, [hli]
	cp $fd
	jr z, .loop
	cp $fe
	jr z, .loop
	dec hl
	ret

WaitAndInitTradeMenuDisplay:
	ld c, 100
	call DelayFrames
	; fallthrough

InitTradeMenuDisplay:
	call ClearScreen
	call LoadTradeScreenBorder
	callba InitTradeSpeciesList
	xor a
	ld hl, wOtherPlayerLinkMode
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, 1
	ld [wMenuCursorY], a
	inc a
	ld [wPlayerLinkAction], a
	jp LinkTrade_PlayerPartyMenu

LinkTrade_OTPartyMenu:
	ld a, OTPARTYMON
	ld [wMonType], a
	ld a, A_BUTTON | D_UP | D_DOWN
	ld [wMenuJoypadFilter], a
	ld a, [OTPartyCount]
	ld [w2DMenuNumRows], a
	ld a, 1
	ld [w2DMenuNumCols], a
	ld a, 9
	ld [w2DMenuCursorInitY], a
	ld a, 6
	ld [w2DMenuCursorInitX], a
	ld a, 1
	ld [wMenuCursorX], a
	ln a, 1, 0
	ld [w2DMenuCursorOffsets], a
	ld a, $20
	ld [w2DMenuFlags1], a
	xor a
	ld [w2DMenuFlags2], a

LinkTradeOTPartymonMenuLoop:
	callba LinkTradeMenu
	ld a, d
	and a
	jp z, LinkTradePartiesMenuMasterLoop
	bit A_BUTTON_F, a
	jr z, .not_a_button
	ld a, [wMenuCursorY]
	dec a
	ld hl, OTPartySpecies
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	ld a, [hl]
	and a
	jr nz, .notUnknownMon
	ld de, SFX_WRONG
	call PlayWaitSFX
	jr .linkTradepartiesMenuMasterLoop
.notUnknownMon
	callba LinkMonStatsScreen
.linkTradepartiesMenuMasterLoop
	jp LinkTradePartiesMenuMasterLoop

.not_a_button
	bit D_UP_F, a
	jr z, .not_d_up
	ld a, [wMenuCursorY]
	ld b, a
	ld a, [OTPartyCount]
	cp b
	jp nz, LinkTradePartiesMenuMasterLoop
	xor a
	ld [wMonType], a
	call HideCursor
	push hl
	push bc
	ld bc, NAME_LENGTH
	add hl, bc
	ld [hl], " "
	pop bc
	pop hl
	ld a, [wPartyCount]
	ld [wMenuCursorY], a
	jr LinkTrade_PlayerPartyMenu

.not_d_up
	bit D_DOWN_F, a
	jp z, LinkTradePartiesMenuMasterLoop
	jp Function28ac9

LinkTrade_PlayerPartyMenu:
	callba InitMG_Mobile_LinkTradePalMap
	xor a
	ld [wMonType], a
	ld a, A_BUTTON | D_UP | D_DOWN
	ld [wMenuJoypadFilter], a
	ld a, [wPartyCount]
	ld [w2DMenuNumRows], a
	ld a, 1
	ld [w2DMenuNumCols], a
	ld a, 1
	ld [w2DMenuCursorInitY], a
	ld a, 6
	ld [w2DMenuCursorInitX], a
	ld a, 1
	ld [wMenuCursorX], a
	ln a, 1, 0
	ld [w2DMenuCursorOffsets], a
	ld a, $20
	ld [w2DMenuFlags1], a
	xor a
	ld [w2DMenuFlags2], a
	call ApplyAttrAndTilemapInVBlank

LinkTradePartymonMenuLoop:
	callba LinkTradeMenu
	ld a, d
	and a
	jr nz, .check_joypad
	jp LinkTradePartiesMenuMasterLoop

.check_joypad
	bit A_BUTTON_F, a
	jr z, .not_a_button
	jp Function28926

.not_a_button
	bit D_DOWN_F, a
	jr z, .not_d_down
	ld a, [wMenuCursorY]
	dec a
	jp nz, LinkTradePartiesMenuMasterLoop
	ld a, OTPARTYMON
	ld [wMonType], a
	call HideCursor
	push hl
	push bc
	ld bc, NAME_LENGTH
	add hl, bc
	ld [hl], " "
	pop bc
	pop hl
	ld a, 1
	ld [wMenuCursorY], a
	jp LinkTrade_OTPartyMenu

.not_d_down
	bit D_UP_F, a
	jr z, LinkTradePartiesMenuMasterLoop
	ld a, [wMenuCursorY]
	ld b, a
	ld a, [wPartyCount]
	cp b
	jr nz, LinkTradePartiesMenuMasterLoop
	call HideCursor
	push hl
	push bc
	ld bc, NAME_LENGTH
	add hl, bc
	ld [hl], " "
	pop bc
	pop hl
	jp Function28ade

LinkTradePartiesMenuMasterLoop:
	ld a, [wMonType]
	and a
	jp z, LinkTradePartymonMenuLoop ; PARTYMON
	jp LinkTradeOTPartymonMenuLoop  ; OTPARTYMON

Function28926:
	call LoadTileMapToTempTileMap
	ld a, [wMenuCursorY]
	push af
	hlcoord 0, 15
	lb bc, 1, 18
	predef Predef_LinkTextbox
	hlcoord 2, 16
	ld de, .String_Stats_Trade
	call PlaceText
	callba Link_WaitBGMap

.joy_loop
	ld a, " "
	ldcoord_a 11, 16
	ld a, A_BUTTON | B_BUTTON | D_RIGHT
	ld [wMenuJoypadFilter], a
	ld a, 1
	ld [w2DMenuNumRows], a
	ld a, 1
	ld [w2DMenuNumCols], a
	ld a, 16
	ld [w2DMenuCursorInitY], a
	ld a, 1
	ld [w2DMenuCursorInitX], a
	ld a, 1
	ld [wMenuCursorY], a
	ld [wMenuCursorX], a
	ln a, 2, 0
	ld [w2DMenuCursorOffsets], a
	xor a
	ld [w2DMenuFlags1], a
	ld [w2DMenuFlags2], a
	call DoMenuJoypadLoop
	bit D_RIGHT_F, a
	jr nz, .d_right
	bit B_BUTTON_F, a
	jr z, .show_stats
.b_button
	pop af
	ld [wMenuCursorY], a
	call Call_LoadTempTileMapToTileMap
	jp LinkTrade_PlayerPartyMenu

.d_right
	ld a, " "
	ldcoord_a 1, 16
	ld a, A_BUTTON | B_BUTTON | D_LEFT
	ld [wMenuJoypadFilter], a
	ld a, 1
	ld [w2DMenuNumRows], a
	ld a, 1
	ld [w2DMenuNumCols], a
	ld a, 16
	ld [w2DMenuCursorInitY], a
	ld a, 11
	ld [w2DMenuCursorInitX], a
	ld a, 1
	ld [wMenuCursorY], a
	ld [wMenuCursorX], a
	ln a, 2, 0
	ld [w2DMenuCursorOffsets], a
	xor a
	ld [w2DMenuFlags1], a
	ld [w2DMenuFlags2], a
	call DoMenuJoypadLoop
	bit D_LEFT_F, a
	jp nz, .joy_loop
	bit B_BUTTON_F, a
	jr nz, .b_button
	jr .try_trade

.show_stats
	pop af
	ld [wMenuCursorY], a
	callba LinkMonStatsScreen
	call Call_LoadTempTileMapToTileMap
	hlcoord 6, 1
	lb bc, 6, 1
	ld a, " "
	call LinkEngine_FillBox
	hlcoord 17, 1
	lb bc, 6, 1
	ld a, " "
	call LinkEngine_FillBox
	jp LinkTrade_PlayerPartyMenu

.try_trade
	call PlaceHollowCursor
	pop af
	ld [wMenuCursorY], a
	dec a
	ld [wd002], a
	ld [wPlayerLinkAction], a
	callba Function16d6ce
	ld a, [wOtherPlayerLinkMode]
	cp $f
	jp z, InitTradeMenuDisplay
	ld [wd003], a
	call Function28b68
	ld c, 100
	call DelayFrames
	callba ValidateOTTrademon
	jr c, .abnormal

	ld a, [OTPlayerName + 8]
	cp GAME_PRISM
	jr z, .skipMoveChecks

	ld hl, OTPartyMon1Moves
	ld a, [wd003]
	call .CheckIfMonHasIllegalMove
	jr c, .badMoveFriend
	ld hl, PartyMon1Moves
	ld a, [wd002]
	call .CheckIfMonHasIllegalMove
	jr c, .badMove

.skipMoveChecks
	callba CheckIfTradedMonIsOnlyAliveMon
	jp nc, LinkTrade
	call TradeErrorWindow
	ld hl, .Text_CantTradeLastMon
	jr .printCancelTradeTextAndCancelTrade

.badMoveFriend
	call TradeErrorWindow
	ld hl, .Text_BadMoveFriend
	jr .printCancelTradeTextAndCancelTrade

.badMove
	ld a, [hl]
	ld [wd265], a
	call GetMoveName
	call CopyName1
	ld a, [wMenuCursorY]
	dec a
	ld hl, wPartyMonNicknames
	call SkipNames
	ld d, h
	ld e, l
	ld hl, wStringBuffer1
	call CopyName2
	xor a
	ld [wcf57], a
	ld [wOtherPlayerLinkAction], a
	hlcoord 0, 12
	lb bc, 4, 18
	predef Predef_LinkTextbox
	callba Link_WaitBGMap
	bccoord 1, 14
	ld hl, .Text_BadMove
	jr .printCancelTradeTextAndCancelTrade

.abnormal
	call TradeErrorWindow
	ld hl, .Text_Abnormal
.printCancelTradeTextAndCancelTrade
	call ProcessTextCommands_

.cancel_trade
	hlcoord 0, 12
	lb bc, 4, 18
	predef Predef_LinkTextbox
	hlcoord 1, 14
	ld de, String_TooBadTheTradeWasCanceled
	call PlaceText
	ld a, $1
	ld [wPlayerLinkAction], a
	callba Function16d6ce
	ld c, 100
	call DelayFrames
	jp InitTradeMenuDisplay

.CheckIfMonHasIllegalMove:
	call GetPartyLocation
	ld c, NUM_MOVES
.moveCheckLoop
	ld a, [hli]
	and a
	ret z ; doubles as setting carry
	push hl
	push bc
	ld b, a
	ld hl, PrismMoves
	push bc
	call IsInSingularArray
	pop bc
	jr c, .nonexistantMove
	ld a, [OTPlayerName + 8]
	cp GAME_TPP
	jr z, .skipTPPChecks
	ld a, b
	ld hl, TPPMoves
	call IsInSingularArray
	jr c, .nonexistantMove
.skipTPPChecks
	pop bc
	pop hl
	dec c
	jr nz, .moveCheckLoop
	and a
	ret
.nonexistantMove
	pop bc
	pop hl
	dec hl
	ret

.Text_BadMove
	text_jump TradeBadMove

.Text_BadMoveFriend
	text_jump TradeBadMoveFriend

.Text_CantTradeLastMon
	; If you trade that #mon, you won't be able to battle.
	text_jump UnknownText_0x1c41b1

.String_Stats_Trade
	ctxt "Stats     Trade"
	done

.Text_Abnormal
	; Your friend's @  appears to be abnormal!
	text_jump UnknownText_0x1c41e6

TradeErrorWindow:
	xor a
	ld [wcf57], a
	ld [wOtherPlayerLinkAction], a
	call LinkedPartyPokemonName
	hlcoord 0, 12
	lb bc, 4, 18
	predef Predef_LinkTextbox
	callba Link_WaitBGMap
	bccoord 1, 14
	ret

Function28ac9:
	ld a, [wMenuCursorY]
	cp 1
	jp nz, LinkTradePartiesMenuMasterLoop
	call HideCursor
	push hl
	push bc
	ld bc, NAME_LENGTH
	add hl, bc
	ld [hl], " "
	pop bc
	pop hl
Function28ade:
.loop1
	ld a, "▶"
	ldcoord_a 9, 17
.loop2
	call JoyTextDelay
	ld a, [hJoyLast]
	and a
	jr z, .loop2
	bit A_BUTTON_F, a
	jr nz, .a_button
	push af
	ld a, " "
	ldcoord_a 9, 17
	pop af
	bit D_UP_F, a
	jr z, .d_up
	ld a, [OTPartyCount]
	ld [wMenuCursorY], a
	jp LinkTrade_OTPartyMenu

.d_up
	ld a, $1
	ld [wMenuCursorY], a
	jp LinkTrade_PlayerPartyMenu

.a_button
	ld a, "▷"
	ldcoord_a 9, 17
	ld a, $f
	ld [wPlayerLinkAction], a
	callba Function16d6ce
	ld a, [wOtherPlayerLinkMode]
	cp $f
	jr nz, .loop1
Function28b22:
	ld c, 1
	call FadeBGToLightestColor
	call ClearScreen
	ld b, SCGB_SCROLLINGMENU
	predef GetSGBLayout
	call ApplyAttrAndTilemapInVBlank
	xor a
	ld [wcfbb], a
	xor a
	ld [rSB], a
	ld [hSerialSend], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
	ret

LinkedPartyPokemonName:
	ld a, [wd003]
	ld hl, OTPartySpecies
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	ld [wd265], a
	jp GetPokemonName

Function28b68:
	ld a, [wOtherPlayerLinkMode]
	hlcoord 6, 9
	ld bc, SCREEN_WIDTH
	rst AddNTimes
	ld [hl], "▷"
	ret

LinkEngine_FillBox:
.row
	push bc
	push hl
.col
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	ret

GetTradePokemonName:
	ld a, [wd002]
	ld hl, wPartySpecies
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	ld [wd265], a
	call GetPokemonName
	ld hl, wStringBuffer1
	ld de, wd004
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	ret

LinkTrade:
	xor a
	ld [wcf57], a
	ld [wOtherPlayerLinkAction], a
	hlcoord 0, 12
	lb bc, $4, $12
	predef Predef_LinkTextbox
	callba Link_WaitBGMap
	call GetTradePokemonName
	call LinkedPartyPokemonName
	ld hl, UnknownText_0x28eb8
	bccoord 1, 14
	call ProcessTextCommands_
	call LoadStandardMenuDataHeader
	hlcoord 10, 7
	lb bc, 3, 7
	predef Predef_LinkTextbox
	ld de, .string_trade_cancel
	hlcoord 12, 8
	call PlaceText
	ld a, 8
	ld [w2DMenuCursorInitY], a
	ld a, 11
	ld [w2DMenuCursorInitX], a
	ld a, 1
	ld [w2DMenuNumCols], a
	ld a, 2
	ld [w2DMenuNumRows], a
	xor a
	ld [w2DMenuFlags1], a
	ld [w2DMenuFlags2], a
	ld a, $20
	ld [w2DMenuCursorOffsets], a
	ld a, A_BUTTON | B_BUTTON
	ld [wMenuJoypadFilter], a
	ld a, 1
	ld [wMenuCursorY], a
	ld [wMenuCursorX], a
	callba Link_WaitBGMap
	call DoMenuJoypadLoop
	push af
	call ExitMenu
	call ApplyAttrAndTilemapInVBlank
	pop af
	bit 1, a
	jr nz, .asm_28c33
	ld a, [wMenuCursorY]
	dec a
	jr z, .asm_28c54

.asm_28c33
	ld a, $1
	ld [wPlayerLinkAction], a
	hlcoord 0, 12
	lb bc, 4, 18
	predef Predef_LinkTextbox
	hlcoord 1, 14
	ld de, String_TooBadTheTradeWasCanceled
	call PlaceText
	callba Function16d6ce
	jp WaitAndInitTradeMenuDisplay

.asm_28c54
	ld a, $2
	ld [wPlayerLinkAction], a
	callba Function16d6ce
	ld a, [wOtherPlayerLinkMode]
	dec a
	jr nz, .asm_28c7b
	hlcoord 0, 12
	lb bc, 4, 18
	predef Predef_LinkTextbox
	hlcoord 1, 14
	ld de, String_TooBadTheTradeWasCanceled
	call PlaceText
	jp WaitAndInitTradeMenuDisplay

.asm_28c7b
	ld hl, PlayerName
	ld de, wPlayerTrademonSenderName
	ld bc, NAME_LENGTH
	rst CopyBytes
	ld a, [wd002]
	ld hl, wPartySpecies
	ld b, $0
	ld c, a
	add hl, bc
	ld a, [hl]
	ld [wPlayerTrademonSpecies], a
	push af
	ld a, [wd002]
	ld hl, wPartyMonOT
	call SkipNames
	ld de, wPlayerTrademonOTName
	ld bc, NAME_LENGTH
	rst CopyBytes
	ld hl, PartyMon1ID
	ld a, [wd002]
	call GetPartyLocation
	ld a, [hli]
	ld [wPlayerTrademonID], a
	ld a, [hl]
	ld [wPlayerTrademonID + 1], a
	ld hl, PartyMon1DVs
	ld a, [wd002]
	call GetPartyLocation
	ld a, [hli]
	ld [wPlayerTrademonDVs], a
	ld a, [hl]
	ld [wPlayerTrademonDVs + 1], a
	ld a, [wd002]
	ld hl, PartyMon1Species
	call GetPartyLocation
	ld b, h
	ld c, l
	callba GetCaughtGender
	ld a, c
	ld [wPlayerTrademonCaughtData], a
	ld hl, OTPlayerName
	ld de, wOTTrademonSenderName
	ld bc, NAME_LENGTH
	rst CopyBytes
	ld a, [wd003]
	ld hl, OTPartySpecies
	ld b, $0
	ld c, a
	add hl, bc
	ld a, [hl]
	ld [wOTTrademonSpecies], a
	ld a, [wd003]
	ld hl, wOTPartyMonOT
	call SkipNames
	ld de, wOTTrademonOTName
	ld bc, NAME_LENGTH
	rst CopyBytes
	ld hl, OTPartyMon1ID
	ld a, [wd003]
	call GetPartyLocation
	ld a, [hli]
	ld [wOTTrademonID], a
	ld a, [hl]
	ld [wOTTrademonID + 1], a
	ld hl, OTPartyMon1DVs
	ld a, [wd003]
	call GetPartyLocation
	ld a, [hli]
	ld [wOTTrademonDVs], a
	ld a, [hl]
	ld [wOTTrademonDVs + 1], a
	ld a, [wd003]
	ld hl, OTPartyMon1Species
	call GetPartyLocation
	ld b, h
	ld c, l
	callba GetCaughtGender
	ld a, c
	ld [wOTTrademonCaughtData], a
	ld a, [wd002]
	ld [wCurPartyMon], a
	ld hl, wPartySpecies
	ld b, $0
	ld c, a
	add hl, bc
	ld a, [hl]
	ld [wd002], a
	xor a
	ld [wPokemonWithdrawDepositParameter], a
	callba RemoveMonFromPartyOrBox
	ld a, [wPartyCount]
	dec a
	ld [wCurPartyMon], a
	ld a, $1
	ld [wForceEvolution], a
	ld a, [wd003]
	push af
	ld hl, OTPartySpecies
	ld b, $0
	ld c, a
	add hl, bc
	ld a, [hl]
	ld [wd003], a
	ld c, 100
	call DelayFrames
	call ClearTileMap
	call LoadFontsBattleExtra
	ld b, SCGB_SCROLLINGMENU
	predef GetSGBLayout
	ld a, [hLinkPlayerNumber]
	cp $1
	jr z, .player_2
	call TradeAnimation
	jr .done_animation

.player_2
	call TradeAnimationPlayer2

.done_animation
	pop af
	ld c, a
	ld [wCurPartyMon], a
	ld hl, OTPartySpecies
	ld d, $0
	ld e, a
	add hl, de
	ld a, [hl]
	ld [wCurPartySpecies], a
	ld hl, OTPartyMon1Species
	ld a, c
	call GetPartyLocation
	ld de, TempMonSpecies
	ld bc, PARTYMON_STRUCT_LENGTH
	rst CopyBytes
	callba AddTempmonToParty
	ld a, [wPartyCount]
	dec a
	ld [wCurPartyMon], a
	callba EvolvePokemon
	call ClearScreen
	call LoadTradeScreenBorder
	call Function28eff
	callba Link_WaitBGMap
	ld b, $1
	pop af
	ld c, a
	cp MEW
	jr z, .asm_28e49
	ld a, [wCurPartySpecies]
	cp MEW
	jr z, .asm_28e49
	inc b

.asm_28e49
	ld a, b
	ld [wPlayerLinkAction], a
	push bc
	call Function862
	pop bc
	ld a, [wLinkMode]
	cp LINK_TIMECAPSULE
	jr z, .asm_28e63
	ld a, b
	and a
	jr z, .asm_28e63
	ld a, [wOtherPlayerLinkAction]
	cp b
	jr nz, .asm_28e49

.asm_28e63
	callba Function14a58
	ld c, 40
	call DelayFrames
	hlcoord 0, 12
	lb bc, 4, 18
	predef Predef_LinkTextbox
	hlcoord 1, 14
	ld de, .string_trade_completed
	call PlaceText
	callba Link_WaitBGMap
	ld c, 50
	call DelayFrames
	ld a, [wLinkMode]
	cp LINK_TIMECAPSULE
	jp z, TimeCapsule
	jp Gen2ToGen2LinkComms

.string_trade_cancel
	ctxt "Trade"
	next "Cancel"
	done

.string_trade_completed
	ctxt "Trade completed!"
	done

UnknownText_0x28eb8:
	; Trade @ for @ ?
	text_jump UnknownText_0x1c4212

String_TooBadTheTradeWasCanceled:
	ctxt "Too bad! The trade"
	next "was canceled!"
	done

LoadTradeScreenBorder:
	jpba _LoadTradeScreenBorder

Function28eff:
	callba Function49811
	jp SetPalettes

INCLUDE "engine/trade_animation.asm"

Special_CheckTimeCapsuleCompatibility:
; Checks to see if your Party is compatible with the generation 1 games.  Returns the following in hScriptVar:
; 0: Party is okay
; 1: At least one Pokemon was introduced in GS
; 2: At least one Pokemon has a move that was introduced in GS

; If any party Pokemon was introduced in the generation 2 games, don't let it in.
	ld hl, wPartySpecies
	ld b, PARTY_LENGTH ; 6
.loop
	ld a, [hli]
	cp -1
	jr z, .checkmoves
	ld c, a
	push hl
	push bc
	ld hl, PrismMons
	call IsInSingularArray
	pop bc
	pop hl
	jr c, .checkIfOKBrown
.checkOK
	dec b
	jr nz, .loop

.checkmoves ; If any party Pokemon has a move that doesn't appear in any of the other games, don't let them in
	ld hl, wPartyMon1
	ld a, [wPartyCount]
	ld b, a
	dec b
.move_loop
	ld a, [hli]
	cp -1
	jr z, .moveOK
	inc hl
	ld [wd265], a
	ld c, NUM_MOVES
.move_next
	ld a, [hli]
	push hl
	push bc
	ld hl, PrismMoves
	call IsInSingularArray
	pop bc
	pop hl
	jr c, .move_too_new
	dec c
	jr nz, .move_next
	ld de, wPartyMon2 - (wPartyMon1 + NUM_MOVES) - 2
	add hl, de
	dec b
	jr nz, .move_loop
.moveOK
	xor a
	ld [hScriptVar], a
	ret

.checkIfOKBrown
	push hl
	push bc
	ld a, c
	ld hl, OKBrownMons
	call IsInSingularArray
	pop bc
	pop hl
	jr c, .checkOK

.mon_too_new
	ld a, c
	ld [wd265], a
	call GetPokemonName
	ld a, $1
	ld [hScriptVar], a
	ret

.move_too_new
	dec hl
	push bc
	ld a, [wd265]

	push af
	ld a, [hl]
	ld [wd265], a
	call GetMoveName
	call CopyName1
	pop af

	ld [wd265], a
	call GetPokemonName

	pop bc
.done
	ld a, $2
	ld [hScriptVar], a
	ret

PrismOnlyItems:
	db COAL
	db ORE
	db BURGER
	db CORONETSTONE
	db HEART_SCALE
	db FRIES
	db SILK
	db MEGAPHONE
	db CIGARETTE
	db GIANT_ROCK
	db BLUE_FLUTE
	db X_SP_DEF
	db CAGE_KEY
	db GOLD_TOKEN
	db DIVE_BALL
	db BURNT_BERRY
	db SULLEN_STONE
	db DYNAMITE
	db DAWN_STONE
	db GOLD_DUST
	db PARK_BALL
	db SHINY_STONE
	db RED_FLUTE
	db YELLOW_FLUTE
	db BLACK_FLUTE
	db WHITE_FLUTE
	db GREEN_FLUTE
	db ORANGE_FLUTE
	db PURPLE_FLUTE
	db MINING_PICK
	db SAFE_GOGGLES
	db BIG_NUGGET
	db HEAT_ROCK
	db DAMP_ROCK
	db SMOOTH_ROCK
	db ICY_ROCK
	db LIGHT_CLAY
	db SHELL_BELL
	db KEG_OF_BEER
	db FIRE_RING
	db GRASS_RING
	db WATER_RING
	db THUNDER_RING
	db SHINY_RING
	db DAWN_RING
	db DUSK_RING
	db MOON_RING
	db DUSK_STONE
	db TRADE_STONE
	db SHINY_BALL
	db MAGMARIZER
	db ELECTRIZER
	db PRISM_SCALE
	db DUBIOUS_DISC
	db RAZOR_CLAW
	db RAZOR_FANG
	db PROTECTOR
	db ORNGAPRICORN
	db CYANAPRICORN
	db GREYAPRICORN
	db PRPLAPRICORN
	db SHNYAPRICORN
	db POKEBALLCORE
	db QUICK_BALL
	db DUSK_BALL
	db REPEAT_BALL
	db TIMER_BALL
	db -1

TPPItems:
	db POISON_GUARD
	db BURN_GUARD
	db FREEZE_GUARD
	db SLEEP_GUARD
	db PRZ_GUARD
	db CONFUSEGUARD
	db -1

OKBrownMons:
	db TOGEKISS
	db YANMEGA
	db LEAFEON
	db GLACEON
	db MISMAGIUS
	db RHYPERIOR
	db GLISCOR
	db MAMOSWINE
	db PORYGONZ
	db WEAVILE
	db SYLVEON
	db CRANIDOS
	db RAMPARDOS
	db TANGROWTH
	db ELECTIVIRE
	db MAGMORTAR
	db $ff

TPPMoves:
	db DRAIN_PUNCH  ; $05
	db FAIRY_WIND   ; $06
	db EARTH_POWER  ; $0d
	db DRAGON_PULSE ; $1b
	db AQUA_JET     ; $1e
	db BUG_BUZZ     ; $20
	db MOONBLAST    ; $29
	db IRON_HEAD    ; $31
	db ZEN_HEADBUTT ; $43
	db NASTY_PLOT   ; $5a
	db ENERGY_BALL  ; $66
	db WILD_CHARGE  ; $95
	db X_SCISSOR    ; $9a
	db SHADOW_CLAW  ; $a6
	db FLASH_CANNON ; $a9
	db FLARE_BLITZ  ; $ad
	db PLAY_ROUGH   ; $be
	db SEED_BOMB    ; $c5
	db WILL_O_WISP  ; $c6
	db DARK_PULSE   ; $c7
	db POISON_JAB   ; $fc
	db AIR_SLASH    ; $82
	db $ff

PrismMoves:
	db FINAL_CHANCE ; $04
	db BULK_UP      ; $0b
	db DRAININGKISS ; $0c
	db BRAVE_BIRD   ; $14
	db NATURE_POWER ; $15
	db COSMIC_POWER ; $19
	db LAUGHING_GAS ; $1a
	db POWER_BALLAD ; $1f
	db FREEZE_BURN  ; $3e
	db LAVA_POOL    ; $42
	db HYPER_VOICE  ; $50
	db BULLET_PUNCH ; $52
	db DRAGON_DANCE ; $60
	db HEAD_SMASH   ; $6e
	db ASTONISH     ; $75
	db METALLURGY   ; $79
	db THUNDER_FANG ; $7d
	db STORM_FRONT  ; $80
	db DUST_DEVIL   ; $83
	db AURA_SPHERE  ; $84
	db MUSTARD_GAS  ; $89
	db PRISM_SPRAY  ; $8c
	db SARIN        ; $8e
	db SPRING_BUDS  ; $93
	db NIGHT_SLASH  ; $98
	db SIGNAL_BEAM  ; $9b
	db METEOR_MASH  ; $9e
	db VOID_SPHERE  ; $9f
	db DRAGON_CLAW  ; $a2
	db BASE_TREMOR  ; $a7
	db AERIAL_ACE   ; $ab
	db VAPORIZE     ; $ce
	db PSYCHO_CUT   ; $d9
	db LEWISITE     ; $e9
	db BOIL         ; $f3
	db CRYSTAL_BOLT ; $f4
	db STEEL_EATER  ; $fa
	db GHOST_HAMMER ; $fb
	db POWER_GEM    ; $fd
	db $ff

PrismMons:
	db RALTS
	db KIRLIA
	db GARDEVOIR
	db GALLADE
	db CARNIVINE
	db TOGEKISS
	db NUMEL
	db CAMERUPT
	db WAILMER
	db WAILORD
	db SURSKIT
	db MASQUERAIN
	db SHROOMISH
	db BRELOOM
	db YANMEGA
	db LEAFEON
	db GLACEON
	db MISMAGIUS
	db SWABLU
	db ALTARIA
	db RHYPERIOR
	db GLISCOR
	db FEEBAS
	db MILOTIC
	db RIOLU
	db LUCARIO
	db GIBLE
	db GABITE
	db GARCHOMP
	db BAGON
	db SHELGON
	db SALAMENCE
	db MAMOSWINE
	db PORYGONZ
	db WEAVILE
	db FAMBACO
	db SYLVEON
	db GROUDON
	db KYOGRE
	db RAYQUAZA
	db VARANEOUS
	db RAIWATO
	db LIBABEEL
	db CHINGLING
	db CHIMECHO
	db TORKOAL
	db BUNEARY
	db LOPUNNY
	db SHINX
	db LUXIO
	db LUXRAY
	db ELECTRIKE
	db MANECTRIC
	db SNORUNT
	db GLALIE
	db FROSLASS
	db VOLBEAT
	db ILLUMISE
	db ARON
	db LAIRON
	db AGGRON
	db BRONZOR
	db BRONZONG
	db SKORUPI
	db DRAPION
	db CRANIDOS
	db RAMPARDOS
	db SHIELDON
	db BASTIODON
	db WHISMUR
	db LOUDRED
	db EXPLOUD
	db DRIFLOON
	db DRIFBLIM
	db SABLEYE
	db SPIRITOMB
	db SHUPPET
	db BANETTE
	db DUSKULL
	db DUSCLOPS
	db LUNATONE
	db SOLROCK
	db VIBRAVA
	db FLYGON
	db MAKUHITA
	db HARIYAMA
	db CACNEA
	db CACTURNE
	db TRAPINCH
	db TANGROWTH
	db MAWILE
	db LOTAD
	db LOMBRE
	db LUDICOLO
	db RELICANTH
	db ELECTIVIRE
	db MAGMORTAR
	db ABSOL
	db PHANCERO
	db LILEEP
	db CRADILY
	db ANORITH
	db ARMALDO
	db BELDUM
	db METANG
	db METAGROSS
	db $ff

Special_EnterTimeCapsule:
	ld c, 10
	call DelayFrames
	ld a, $4
	call Function29f17
	ld c, 40
	call DelayFrames
	xor a
	ld [hVBlank], a
	inc a
	ld [wLinkMode], a
	ret

WaitForOtherPlayerToExit:
	call Delay2
	ld a, -1
	ld [hLinkPlayerNumber], a
	xor a
	ld [rSB], a
	ld [hSerialReceive], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
	call Delay2
	xor a
	ld [rSB], a
	ld [hSerialReceive], a
	ld a, $0
	ld [rSC], a
	ld a, $80
	ld [rSC], a
	call Delay2
	xor a
	ld [rSB], a
	ld [hSerialReceive], a
	ld [rSC], a
	call Delay2
	ld a, -1
	ld [hLinkPlayerNumber], a
	ld a, [rIF]
	push af
	xor a
	ld [rIF], a
	ld a, $f
	ld [rIE], a
	pop af
	ld [rIF], a
	ld hl, wcf5b
	xor a
	ld [hli], a
	ld [hl], a
	ld [hVBlank], a
	ld [wLinkMode], a
	ret

Special_SetBitsForLinkTradeRequest:
	ld a, LINK_TRADECENTER - 1
	ld [wPlayerLinkAction], a
	ld [wd265], a
	ret

Special_SetBitsForBattleRequest:
	ld a, LINK_COLOSSEUM - 1
	ld [wPlayerLinkAction], a
	ld [wd265], a
	ret

Special_SetBitsForTimeCapsuleRequest:
	ld a, $2
	ld [rSB], a
	xor a
	ld [hSerialReceive], a
	ld a, $0
	ld [rSC], a
	ld a, $80
	ld [rSC], a
	xor a ; LINK_TIMECAPSULE - 1
	ld [wPlayerLinkAction], a
	ld [wd265], a
	ret

Special_WaitForLinkedFriend:
	ld a, [wPlayerLinkAction]
	and a
	jr z, .asm_29d2f
	ld a, $2
	ld [rSB], a
	xor a
	ld [hSerialReceive], a
	ld a, $0
	ld [rSC], a
	ld a, $80
	ld [rSC], a
	push bc
	ld c, 3
	call DelayFrames
	pop bc

.asm_29d2f
	ld a, $2
	ld [wcf5c], a
	ld a, $ff
	ld [wcf5b], a
.asm_29d39
	ld a, [hLinkPlayerNumber]
	cp $2
	jr z, .asm_29d79
	cp $1
	jr z, .asm_29d79
	ld a, -1
	ld [hLinkPlayerNumber], a
	ld a, $2
	ld [rSB], a
	xor a
	ld [hSerialReceive], a
	ld a, $0
	ld [rSC], a
	ld a, $80
	ld [rSC], a
	ld a, [wcf5b]
	dec a
	ld [wcf5b], a
	jr nz, .asm_29d68
	ld a, [wcf5c]
	dec a
	ld [wcf5c], a
	jr z, .asm_29d8d

.asm_29d68
	ld a, $1
	ld [rSB], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
	call DelayFrame
	jr .asm_29d39

.asm_29d79
	call LinkDataReceived
	call DelayFrame
	call LinkDataReceived
	ld c, $32
	call DelayFrames
	ld a, $1
	ld [hScriptVar], a
	ret

.asm_29d8d
	xor a
	ld [hScriptVar], a
	ret

Special_CheckLinkTimeout:
	ld a, $1
	ld [wPlayerLinkAction], a
	ld hl, wcf5b
	ld a, $3
	ld [hli], a
	xor a
	ld [hl], a
	call ApplyTilemapInVBlank
	ld a, $2
	ld [hVBlank], a
	call DelayFrame
	call DelayFrame
	call Function29e0c
	xor a
	ld [hVBlank], a
	ld a, [hScriptVar]
	and a
	ret nz
	jp Function29f04

Function29dba:
	ld a, $5
	ld [wPlayerLinkAction], a
	ld hl, wcf5b
	ld a, $3
	ld [hli], a
	xor a
	ld [hl], a
	call ApplyTilemapInVBlank
	ld a, $2
	ld [hVBlank], a
	call DelayFrame
	call DelayFrame
	call Function29e0c
	ld a, [hScriptVar]
	and a
	jr z, .vblank
	ld bc, -1
.wait
	dec bc
	ld a, b
	or c
	jr nz, .wait
	ld a, [wOtherPlayerLinkMode]
	cp $5
	jr nz, .script_var
	ld a, $6
	ld [wPlayerLinkAction], a
	ld hl, wcf5b
	ld a, $1
	ld [hli], a
	ld [hl], $32
	call Function29e0c
	ld a, [wOtherPlayerLinkMode]
	cp $6
	jr z, .vblank

.script_var
	xor a
	ld [hScriptVar], a
	ret

.vblank
	xor a
	ld [hVBlank], a
	ret

Function29e0c:
	xor a
	ld [hFFCA], a
	ld a, [wcf5b]
	ld h, a
	ld a, [wcf5c]
	ld l, a
	push hl
	call Function29e3b
	pop hl
	jr nz, .asm_29e2f
	call Function29e47
	call Function29e53
	call Function29e3b
	jr nz, .asm_29e2f
	call Function29e47
	xor a
	jr .asm_29e31

.asm_29e2f
	ld a, $1

.asm_29e31
	ld [hScriptVar], a
	ld hl, wcf5b
	xor a
	ld [hli], a
	ld [hl], a
	ret

Function29e3b:
	call Function87d
	ld hl, wcf5b
	ld a, [hli]
	inc a
	ret nz
	ld a, [hl]
	inc a
	ret

Function29e47:
	ld b, $a
.asm_29e49
	call DelayFrame
	call LinkDataReceived
	dec b
	jr nz, .asm_29e49
	ret

Function29e53:
	dec h
	srl h
	rr l
	srl h
	rr l
	inc h
	ld a, h
	ld [wcf5b], a
	ld a, l
	ld [wcf5c], a
	ret

Special_CheckBothSelectedSameRoom:
	ld a, [wd265]
	call Function29f17
	push af
	call LinkDataReceived
	call DelayFrame
	call LinkDataReceived
	pop af
	ld b, a
	ld a, [wd265]
	cp b
	jr nz, .fail
	ld a, [wd265]
	inc a
	ld [wLinkMode], a
	xor a
	ld [hVBlank], a
	ld a, $1
	ld [hScriptVar], a
	ret

.fail
	xor a
	ld [hScriptVar], a
	ret

PrepareTradeCenter:
	ld [wLinkMode], a
	call DisableSpriteUpdates
	call LinkCommunications
	call EnableSpriteUpdates
	xor a
	ld [hVBlank], a
	ret

Special_TimeCapsule:
	ld a, LINK_TIMECAPSULE
	jr PrepareTradeCenter

Special_TradeCenter:
	ld a, LINK_TRADECENTER
	jr PrepareTradeCenter

Special_Colosseum:
	ld a, LINK_COLOSSEUM
	jr PrepareTradeCenter

Special_CloseLink:
	xor a
	ld [wLinkMode], a
	ld c, $2
	call DelayFrames
	; fallthrough

Function29f04:
	call Delay2
	ld a, -1
	ld [hLinkPlayerNumber], a
	ld a, $2
	ld [rSB], a
	xor a
	ld [hSerialReceive], a
	ld [rSC], a
	ret

Special_FailedLinkToPast:
	ld c, 40
	call DelayFrames
	ld a, $e
	; fallthrough

Function29f17:
	add $d0
	ld [wPlayerLinkAction], a
	ld [wcf57], a
	ld a, $2
	ld [hVBlank], a
	call Delay2
.receive_loop
	call Function83b
	ld a, [wOtherPlayerLinkMode]
	ld b, a
	and $f0
	cp $d0
	jr z, .done
	ld a, [wOtherPlayerLinkAction]
	ld b, a
	and $f0
	cp $d0
	jr nz, .receive_loop

.done
	xor a
	ld [hVBlank], a
	ld a, b
	and $f
	ret

Special_CableClubCheckWhichChris:
	ld a, [hLinkPlayerNumber]
	cp 1
	jr z, .yes
	xor a

.yes
	ld [hScriptVar], a
	ret
