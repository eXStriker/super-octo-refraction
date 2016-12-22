SelectMonFromParty:
	call DisableSpriteUpdates
	xor a
	ld [wPartyMenuActionText], a
	call ClearBGPalettes
	call InitPartyMenuLayout
	call ApplyTilemapInVBlank
	call SetPalettes
	call DelayFrame
	call PartyMenuSelect
	jp ReturnToMapWithSpeechTextbox

ChooseThreePartyMonsForBattle::
	call DisableSpriteUpdates
	xor a
	ld [hScriptVar], a
	call ClearBGPalettes
	call ClearAttrMap
	call ApplyAttrAndTilemapInVBlank
.dereg_all
	xor a
	ld hl, wTowerArcadePartyCount
	ld [hli], a
	dec a
	ld [hl], a
	ld a, 10
	ld [wPartyMenuActionText], a
	call InitPartyMenuLayout
	call .Redraw_WaitBGMap
	jr .handleLoop

.loop
	call .Redraw
.handleLoop
	call PartyMenuSelect
	jr c, .back
	call .CheckLegal
	jr c, .nope_loop
	ld hl, wSelectedParty
	ld a, [wCurPartyMon]
	call IsInSingularArray
	jr c, .remove_this_mon
	ld hl, wTowerArcadePartyCount
	inc [hl]
	ld a, [hl]
	cp 3
	push af
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	ld a, [wCurPartyMon]
	ld [hli], a
	ld [hl], $ff
	pop af
	jr nz, .loop
	call .Redraw
	ld hl, .Text_IsThisOkay
	call PrintText
	call YesNoBox
	jr c, .dereg_all
	ld a, 1
	ld [hScriptVar], a
.done
	jp ReturnToMapWithSpeechTextbox

.nope_loop
	ld de, SFX_WRONG
	call PlayWaitSFX
	jr .loop

.back
	ld hl, wTowerArcadePartyCount
	ld a, [hl]
	and a
	jr z, .done
	dec [hl]
	add l
	ld l, a
	jr nc, .noCarry2
	inc h
.noCarry2
	ld [hl], $ff
	jr .loop

.remove_this_mon
	ld a, [wTowerArcadePartyCount]
	dec a
	ld [wTowerArcadePartyCount], a
	ld a, 2
	sub b
	ld b, a
	ld e, l
	ld d, h
	inc e
.copy_back
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, .copy_back
	jp .loop

.Text_IsThisOkay:
	text_jump Text_BattleTowerSelect_IsThisOkay

.Redraw:
	ld a, 10
	ld [wPartyMenuActionText], a
	call RedrawPartyMenu
.Redraw_WaitBGMap:
	call ApplyTilemapInVBlank
	call SetPalettes
	jp DelayFrame

.CheckLegal:
	ld a, [MapGroup]
	cp GROUP_BATTLE_TOWER_ENTRANCE
	jr z, .BattleTowerLegality
	cp GROUP_BATTLE_ARCADE_LOBBY
	ccf
	ret nz
	ld a, MON_LEVEL
	call GetPartyParamLocation
	ld a, [hl]
	cp 40
	ret

.BattleTowerLegality
	ld a, [wCurPartySpecies]
	ld b, a
	jpba BattleTower_IsCurSpeciesLegal_Far

SetBattleTowerParty::
	; back up the party
	xor a
	call GetSRAMBank
	ld hl, wPartyCount
	ld de, sBattleTowerPartyBackup
	ld bc, wPartyMonNicknamesEnd - wPartyCount
	rst CopyBytes

	; reset the party
	ld hl, wPartyCount
	xor a
	ld [hli], a
	dec a
	ld [hl], a

	ld hl, wSelectedParty
	ld c, 3
.loop
	ld a, [hli]
	ld [wCurPartyMon], a
	push bc
	push hl

	; store and increment the party count
	ld a, [wPartyCount]
	ld [hMoveMon], a
	ld c, a
	inc a
	ld [wPartyCount], a
	ld b, 0

	; copy the party list species index
	ld hl, wPartySpecies
	add hl, bc
	ld d, h
	ld e, l
	ld hl, sBattleTowerPartyBackup + wPartySpecies - wPartyCount
	ld a, [wCurPartyMon]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc de
	ld a, $ff
	ld [de], a

	ld hl, wPartyMon1
	ld a, [hMoveMon]
	call GetPartyLocation
	ld d, h
	ld e, l
	ld hl, sBattleTowerPartyBackup + wPartyMon1 - wPartyCount
	ld a, [wCurPartyMon]
	call GetPartyLocation
	rst CopyBytes

	ld hl, wPartyMonOT
	ld a, [hMoveMon]
	call SkipNames
	ld d, h
	ld e, l
	ld hl, sBattleTowerPartyBackup + wPartyMonOT - wPartyCount
	ld a, [wCurPartyMon]
	call SkipNames
	rst CopyBytes

	ld hl, wPartyMonNicknames
	ld a, [hMoveMon]
	call SkipNames
	ld d, h
	ld e, l
	ld hl, sBattleTowerPartyBackup + wPartyMonNicknames - wPartyCount
	ld a, [wCurPartyMon]
	call SkipNames
	rst CopyBytes

	pop hl
	pop bc
	dec c
	jr nz, .loop
	call CloseSRAM

	ld hl, wBTChoiceOfLvlGroup
	ld a, BANK(wBTChoiceOfLvlGroup)
	call GetFarWRAMByte
	cp 50
	jr z, .level_cap

	ld hl, PartyMon1Level
	ld bc, PARTYMON_STRUCT_LENGTH
	lb de, 3, 50
.level_loop
	ld a, [hl]
	cp e
	jr c, .level_next
	ld e, a
.level_next
	add hl, bc
	dec d
	jr nz, .level_loop
	ld a, [rSVBK]
	push af
	ld a, BANK(wBTChoiceOfLvlGroup)
	ld [rSVBK], a
	ld a, e
	ld [wBTChoiceOfLvlGroup], a
	pop af
	ld [rSVBK], a
	jr .heal

.level_cap
	ld a, 3
	ld bc, wPartyMon1
.level_cap_loop
	push af
	call Level50Cap
	ld hl, PARTYMON_STRUCT_LENGTH
	add hl, bc
	ld c, l
	ld b, h
	pop af
	dec a
	jr nz, .level_cap_loop
.heal
	predef_jump HealParty

Level50Cap:
	ld a, 50
LevelCap:
; a is max level
; bc points to mon struct
	ld hl, MON_LEVEL
	add hl, bc
	cp [hl]
	ret nc
	ld [hl], a
	ld d, a
	ld a, [bc]
	ld [wCurSpecies], a
	call GetBaseData
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
	push hl
	ld hl, MON_MAXHP
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	push de
	push de
	push bc
	ld b, 1
	ld a, 50
	ld [CurPartyLevel], a
	predef CalcPkmnStats
	pop bc
	pop hl
	pop de
	dec de
	dec de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ret

RestorePartyAfterBattleTower::
	xor a
	call GetSRAMBank
	ld hl, sBattleTowerPartyBackup
	ld a, [hl]
	and a
	jr z, .FailedToRestore
	cp 7
	jr nc, .FailedToRestore
	ld de, wPartyCount
	ld bc, wPartyMonNicknamesEnd - wPartyCount
	rst CopyBytes
	jp CloseSRAM

.FailedToRestore
	call OpenText
	ld hl, .Whoops
	call PrintText
	call ApplyTilemapInVBlank
	jr @
; 24468

.Whoops: ; 24468
	ctxt "Failed to restore"
	line "your #mon team."
	done

SelectTradeOrDaycareMon:
	ld a, b
	ld [wPartyMenuActionText], a
	call DisableSpriteUpdates
	call ClearBGPalettes
	call InitPartyMenuLayout
	call ApplyTilemapInVBlank
	ld b, SCGB_0A
	predef GetSGBLayout
	call SetPalettes
	call DelayFrame
	call PartyMenuSelect
	jp ReturnToMapWithSpeechTextbox

InitPartyMenuLayout:
	call LoadPartyMenuGFX
	call InitPartyMenuWithCancel
	call InitPartyMenuGFX
RedrawPartyMenu:
	call WritePartyMenuTilemap
	jp PrintPartyMenuText

LoadPartyMenuGFX:
	call LoadFontsBattleExtra
	callba InitPartyMenuPalettes
	jpba ClearSpriteAnims2

WritePartyMenuTilemap:
	ld hl, wOptions
	ld a, [hl]
	push af
	set 4, [hl] ; Disable text delay
	xor a
	ld [hBGMapMode], a
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, " "
	call ByteFill ; blank the tilemap
	call GetPartyMenuTilemapPointers ; This reads from a pointer table???
.loop
	ld a, [hli]
	cp $ff
	jr z, .end
	push hl
	jumptable .Jumptable
	pop hl
	jr .loop
.end
	pop af
	ld [wOptions], a
	ret

.Jumptable
	dw PlacePartyNicknames
	dw PlacePartyHPBar
	dw PlacePartyMenuHPDigits
	dw PlacePartyMonLevel
	dw PlacePartyMonStatus
	dw PlacePartyMonTMHMCompatibility
	dw PlacePartyMonEvoStoneCompatibility
	dw PlacePartyMonGender
	dw PlaceFirstSecondThird

PlacePartyNicknames:
	hlcoord 3, 1
	ld a, [wPartyCount]
	and a
	jr z, .end
	ld c, a
	ld b, $0
.loop
	push bc
	push hl
	push hl
	ld hl, wPartyMonNicknames
	ld a, b
	call GetNick
	pop hl
	call PlaceString
	pop hl
	ld de, 2 * SCREEN_WIDTH
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .loop

.end
	dec hl
	dec hl
	ld de, .CANCEL
	jp PlaceText

.CANCEL
	text "Cancel"
	done

PlacePartyHPBar:
	xor a
	ld [wSGBPals], a
	ld a, [wPartyCount]
	and a
	ret z
	ld c, a
	ld b, $0
	hlcoord 11, 2
.loop
	push bc
	push hl
	call PartyMenuCheckEgg
	jr z, .skip
	push hl
	call PlacePartymonHPBar
	pop hl
	ld d, $6
	ld b, $0
	call DrawBattleHPBar
	ld hl, wHPPals
	ld a, [wSGBPals]
	ld c, a
	ld b, $0
	add hl, bc
	call SetHPPal
	ld b, SCGB_PARTY_MENU_HP_PALS
	predef GetSGBLayout
.skip
	ld hl, wSGBPals
	inc [hl]
	pop hl
	ld de, 2 * SCREEN_WIDTH
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .loop
	ld b, SCGB_0A
	predef_jump GetSGBLayout

PlacePartymonHPBar:
	ld a, b
	ld bc, PARTYMON_STRUCT_LENGTH
	ld hl, PartyMon1HP
	rst AddNTimes
	ld a, [hli]
	or [hl]
	jr nz, .not_fainted
	xor a
	ld e, a
	ld c, a
	ret

.not_fainted
	dec hl
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld e, a
	predef_jump ComputeHPBarPixels

PlacePartyMenuHPDigits:
	ld a, [wPartyCount]
	and a
	ret z
	ld c, a
	ld b, $0
	hlcoord 13, 1
.loop
	push bc
	push hl
	call PartyMenuCheckEgg
	jr z, .next
	push hl
	ld a, b
	ld bc, PARTYMON_STRUCT_LENGTH
	ld hl, PartyMon1HP
	rst AddNTimes
	ld e, l
	ld d, h
	pop hl
	push de
	lb bc, 2, 3
	call PrintNum
	pop de
	ld a, "/"
	ld [hli], a
	inc de
	inc de
	lb bc, 2, 3
	call PrintNum

.next
	pop hl
	ld de, 2 * SCREEN_WIDTH
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .loop
	ret

PlacePartyMonLevel:
	ld a, [wPartyCount]
	and a
	ret z
	ld c, a
	ld b, 0
	hlcoord 8, 2
.loop
	push bc
	push hl
	call PartyMenuCheckEgg
	jr z, .next
	push hl
	ld a, b
	ld bc, PARTYMON_STRUCT_LENGTH
	ld hl, PartyMon1Level
	rst AddNTimes
	ld e, l
	ld d, h
	pop hl
	ld a, [de]
	cp 100 ; This is distinct from MAX_LEVEL.
	jr nc, .ThreeDigits
	ld a, "<LV>"
	ld [hli], a
.ThreeDigits
	lb bc, PRINTNUM_RIGHTALIGN | 1, 3
	call PrintNum

.next
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .loop
	ret

PlacePartyMonStatus:
	ld a, [wPartyCount]
	and a
	ret z
	ld c, a
	ld b, 0
	hlcoord 5, 2
.loop
	push bc
	push hl
	call PartyMenuCheckEgg
	jr z, .next
	push hl
	ld a, b
	ld bc, PARTYMON_STRUCT_LENGTH
	ld hl, PartyMon1Status
	rst AddNTimes
	ld e, l
	ld d, h
	pop hl
	call PlaceStatusString

.next
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .loop
	ret

PlacePartyMonTMHMCompatibility:
	ld a, [wPartyCount]
	and a
	ret z
	ld c, a
	ld b, 0
	hlcoord 12, 2
.loop
	push bc
	push hl
	call PartyMenuCheckEgg
	jr z, .next
	push hl
	ld hl, wPartySpecies
	ld e, b
	ld d, 0
	add hl, de
	ld a, [hl]
	ld [wCurPartySpecies], a
	predef CanLearnTMHMMove
	pop hl
	call .PlaceAbleNotAble
	call PlaceText

.next
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .loop
	ret

.PlaceAbleNotAble
	ld a, c
	and a
	ld de, String_NotAble
	ret z
	ld de, String_Able
	ret

PlacePartyMonEvoStoneCompatibility:
	ld a, [wPartyCount]
	and a
	ret z
	ld c, a
	ld b, 0
	hlcoord 12, 2
.loop
	push bc
	push hl
	call PartyMenuCheckEgg
	jr z, .next
	push hl
	ld a, b
	push af
	ld bc, PARTYMON_STRUCT_LENGTH
	ld hl, PartyMon1Species
	rst AddNTimes
	ld e, [hl]
	ld bc, MON_ITEM
	add hl, bc
	ld b, [hl]
	pop af
	call .GetGenderAndWriteInC

	dec e
	ld d, 0
	ld hl, EvosAttacksPointers
	add hl, de
	add hl, de

	call .DetermineCompatibility
	pop hl
	call PlaceText

.next
	pop hl
	ld de, 2 * SCREEN_WIDTH
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .loop
	ret

.GetGenderAndWriteInC
	push bc
	push hl
	ld b, a
	ld hl, wCurPartyMon
	ld a, [hl]
	push af
	ld [hl], b
	xor a
	ld [wMonType], a
	predef GetGender
	ld c, a
	pop af
	ld [wCurPartyMon], a
	ld a, c
	pop hl
	pop bc
	ld c, a
	ret

.DetermineCompatibility
	push bc
	ld a, BANK(EvosAttacksPointers)
	call GetFarHalfword
	ld de, wStringBuffer1
	ld bc, 9
	ld a, BANK(EvosAttacks)
	call FarCopyBytes
	xor a
	ld [de], a
	ld hl, wStringBuffer1
	pop bc
.loop2
	ld a, [hli]
	and a
	jr z, .nope
	inc hl
	inc hl
	cp EVOLVE_STAT
	jr z, .nope ; reasons
	cp EVOLVE_ITEM
	jr z, .checkItem
	cp EVOLVE_ITEM_MALE
	jr z, .checkItemMale
	cp EVOLVE_ITEM_FEMALE
	jr z, .checkItemFemale
	cp EVOLVE_TRADE
	jr nz, .loop2
; trade
	ld a, b
	cp EVERSTONE
	jr z, .loop2
	jr .checkHeldItem
.checkItemMale
	ld a, c
	dec a
	jr .goBackToLoop2IfNonZero
.checkItemFemale
	ld a, c
	and a
.goBackToLoop2IfNonZero
	jr nz, .loop2
.checkItem
	ld a, [wCurItem]
.checkHeldItem
	dec hl
	dec hl
	cp [hl]
	jr z, .able
	ld a, [hli]
	inc hl
	inc a
	jr nz, .loop2
.able
	ld de, String_Able
	ret
.nope
	ld de, String_NotAble
	ret

String_Able:
	text "Able"
	done

String_NotAble:
	text "Not able"
	done

PlacePartyMonGender:
	ld a, [wPartyCount]
	and a
	ret z
	ld c, a
	ld b, 0
	hlcoord 12, 2
.loop
	push bc
	push hl
	call PartyMenuCheckEgg
	jr z, .next
	ld [wCurPartySpecies], a
	push hl
	ld a, b
	ld [wCurPartyMon], a
	xor a
	ld [wMonType], a
	call GetGender
	ld de, .unknown
	jr c, .got_gender
	ld de, .male
	jr nz, .got_gender
	ld de, .female

.got_gender
	pop hl
	call PlaceText

.next
	pop hl
	ld de, 2 * SCREEN_WIDTH
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .loop
	ret

.male
	text "♂…Male"
	done

.female
	text "♀…Female"
	done

.unknown
	text "…Unknown"
	done

PlaceFirstSecondThird:
	ld a, [wBattleTowerLegalPokemonFlags]
	ld e, a
	ld a, [wPartyCount]
	ld c, a
	ld b, 0
	hlcoord 12, 2
.loop
	push bc
	srl e
	push de
	push hl
	jr nc, .unable
	ld a, b
	ld hl, wSelectedParty
	call IsInSingularArray
	jr nc, .not_regged
	ld a, b
	ld hl, .Strings
	call GetNthString
	ld d, h
	ld e, l
	jr .print

.not_regged
	ld de, .NotRegistered
	jr .print

.unable
	ld de, .Unable
.print
	pop hl
	call PlaceString ; preserves hl
	ld de, 2 * SCREEN_WIDTH
	add hl, de
	pop de
	pop bc
	inc b
	dec c
	jr nz, .loop
	ret

.Strings:
	db "FIRST@"
	db "SECOND@"
	db "THIRD@"
.Unable
	db "UNABLE@"
.NotRegistered
	db "ABLE@"

PartyMenuCheckEgg:
	ld a, wPartySpecies % $100
	add b
	ld e, a
	ld a, wPartySpecies / $100
	adc 0
	ld d, a
	ld a, [de]
	cp EGG
	ret

GetPartyMenuTilemapPointers:
party_menu_components: MACRO
rept _NARG
	db PARTY_TILES_\1
	shift
endr
	db -1
endm

	const_def
	const PARTY_TILES_NICKS
	const PARTY_TILES_HP_BAR
	const PARTY_TILES_HP_VAL
	const PARTY_TILES_LEVEL
	const PARTY_TILES_STATUS
	const PARTY_TILES_TMHM
	const PARTY_TILES_STONE
	const PARTY_TILES_GENDER
	const PARTY_TILES_TOWER

	ld a, [wPartyMenuActionText]
	and $f0
	ld hl, .Default
	ret nz
	ld a, [wPartyMenuActionText]
	and $f
	ld e, a
	ld d, 0
	ld hl, .Pointers
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

.Pointers
	dw .Default  ; 0
	dw .Default  ; 1
	dw .Default  ; 2
	dw .TMHM     ; 3
	dw .Default  ; 4
	dw .EvoStone ; 5
	dw .Gender   ; 6
	dw .Gender   ; 7
	dw .Default  ; 8
	dw .Default  ; 9
	dw .Tower    ; a

.Default:  party_menu_components NICKS, HP_BAR, HP_VAL, LEVEL, STATUS
.TMHM:     party_menu_components NICKS, TMHM,           LEVEL, STATUS
.EvoStone: party_menu_components NICKS, STONE,          LEVEL, STATUS
.Gender:   party_menu_components NICKS, GENDER,         LEVEL, STATUS
.Tower:    party_menu_components NICKS, TOWER,          LEVEL, STATUS

InitPartyMenuGFX:
	ld hl, wPartyCount
	ld a, [hli]
	and a
	ret z
	ld c, a
	xor a
	ld [hObjectStructIndexBuffer], a
.loop
	push bc
	push hl
	ld e, $0
	callba LoadPartyIcons
	ld a, [hObjectStructIndexBuffer]
	inc a
	ld [hObjectStructIndexBuffer], a
	pop hl
	pop bc
	dec c
	jr nz, .loop
	jpba PlaySpriteAnimations

InitPartyMenuWithCancel:
; with cancel
	xor a
	ld [wSwitchMon], a
	ld de, PartyMenuAttributes
	call SetMenuAttributes
	ld a, [wPartyCount]
	inc a
	ld [w2DMenuNumRows], a ; list length
	dec a
	ld b, a
	ld a, [wPartyMenuCursor]
	and a
	jr z, .skip
	inc b
	cp b
	jr c, .done

.skip
	ld a, 1

.done
	ld [wMenuCursorY], a
	ld a, A_BUTTON | B_BUTTON
	ld [wMenuJoypadFilter], a
	ret

InitPartyMenuNoCancel:
; no cancel
	ld de, PartyMenuAttributes
	call SetMenuAttributes
	ld a, [wPartyCount]
	ld [w2DMenuNumRows], a ; list length
	ld b, a
	ld a, [wPartyMenuCursor]
	and a
	jr z, .skip
	inc b
	cp b
	jr c, .done
.skip
	ld a, 1
.done
	ld [wMenuCursorY], a
	ld a, A_BUTTON | B_BUTTON
	ld [wMenuJoypadFilter], a
	ret

PartyMenuAttributes:
; cursor y
; cursor x
; num rows
; num cols
; bit 6: animate sprites  bit 5: wrap around
; ?
; distance between items (hi: y, lo: x)
; allowed buttons (mask)
	db 1, 0
	db 0, 1
	db $60, $00
	dn 2, 0
	db 0

PartyMenuSelect:
; sets carry if exited menu.
	call DoMenuJoypadLoop
	call PlaceHollowCursor
	ld a, [wPartyCount]
	inc a
	ld b, a
	ld a, [wMenuCursorY] ; menu selection?
	cp b
	jr z, .exitmenu ; CANCEL
	ld [wPartyMenuCursor], a
	ld a, [hJoyLast]
	ld b, a
	bit 1, b
	jr nz, .exitmenu ; B button?
	ld a, [wMenuCursorY]
	dec a
	ld [wCurPartyMon], a
	ld c, a
	ld b, $0
	ld hl, wPartySpecies
	add hl, bc
	ld a, [hl]
	ld [wCurPartySpecies], a

	ld de, SFX_READ_TEXT_2
	call PlaySFX
	and a
	ret

.exitmenu
	ld de, SFX_READ_TEXT_2
	call PlaySFX
	scf
	ret

PrintPartyMenuText:
	hlcoord 0, 14
	lb bc, 2, 18
	call TextBox
	ld a, [wPartyCount]
	and a
	jr nz, .haspokemon
	ld de, .YouHaveNoPKMNString
	jr .gotstring
.haspokemon
	ld a, [wPartyMenuActionText]
	and $f ; drop high nibble
	ld hl, PartyMenuStrings
	ld e, a
	ld d, $0
	add hl, de
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
.gotstring
	ld a, [wOptions]
	push af
	set 4, a ; disable text delay
	ld [wOptions], a
	hlcoord 1, 16 ; Coord
	call PlaceText
	pop af
	ld [wOptions], a
	ret

.YouHaveNoPKMNString
	text "You have no <PK><MN>!"
	done

PartyMenuStrings:
	dw .ChooseAMonString
	dw .UseOnWhichPKMNString
	dw .WhichPKMNString
	dw .TeachWhichPKMNString
	dw .MoveToWhereString
	dw .UseOnWhichPKMNString
	dw .ChooseAMonString ; Probably used to be ChooseAFemalePKMNString
	dw .ChooseAMonString ; Probably used to be ChooseAMalePKMNString
	dw .ToWhichPKMNString
	dw .SwapItemWhereString
	dw .ChooseAMonString

.ChooseAMonString
	ctxt "Choose a #mon."
	done

.UseOnWhichPKMNString
	text "Use on@"
	text_jump .SpaceWhichPKMNString

.WhichPKMNString
	text "Which <PK><MN>?"
	done

.TeachWhichPKMNString
	text "Teach@"
	text_jump .SpaceWhichPKMNString

.MoveToWhereString
	ctxt "Move to where?"
	done

.ToWhichPKMNString
	text "To@"
.SpaceWhichPKMNString
	text " which <PK><MN>?"
	done

.SwapItemWhereString
	ctxt "Move item where?"
	done

PrintPartyMenuActionText:
	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames
	call GetNick
	ld a, [wPartyMenuActionText]
	and $f
	ld hl, .MenuActionTexts
	jp .PrintText

.MenuActionTexts
	dw .Text_CuredOfPoison
	dw .Text_BurnWasHealed
	dw .Text_Defrosted
	dw .Text_WokeUp
	dw .Text_RidOfParalysis
	dw .Text_RecoveredSomeHP
	dw .Text_HealthReturned
	dw .Text_Revitalized
	dw .Text_GrewToLevel
	dw .Text_CameToItsSenses

.Text_RecoveredSomeHP
	; recovered @ HP!
	text_jump UnknownText_0x1bc0a2

.Text_CuredOfPoison
	; 's cured of poison.
	text_jump UnknownText_0x1bc0bb

.Text_RidOfParalysis
	; 's rid of paralysis.
	text_jump UnknownText_0x1bc0d2

.Text_BurnWasHealed
	; 's burn was healed.
	text_jump UnknownText_0x1bc0ea

.Text_Defrosted
	; was defrosted.
	text_jump UnknownText_0x1bc101

.Text_WokeUp
	; woke up.
	text_jump UnknownText_0x1bc115

.Text_HealthReturned
	; 's health returned.
	text_jump UnknownText_0x1bc123

.Text_Revitalized
	; is revitalized.
	text_jump UnknownText_0x1bc13a

.Text_GrewToLevel
	; grew to level @ !@ @
	text_far UnknownText_0x1bc14f
	start_asm
	ld de, SFX_DEX_FANFARE_50_79
	jp Text_PlaySFXAndPrompt

.Text_CameToItsSenses
	; came to its senses.
	text_jump UnknownText_0x1bc16e

.PrintText
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wOptions]
	push af
	set NO_TEXT_SCROLL, a
	ld [wOptions], a
	call PrintText
	pop af
	ld [wOptions], a
	ret
