PrintPage1:
	hlcoord 0, 0
	ld de, wca90
	ld bc, 17 * SCREEN_WIDTH
	rst CopyBytes
	ld hl, wcab5
	ld a, $62
	ld [hli], a
	inc a
	ld [hl], a
	ld hl, wcac9
	ld a, $64
	ld [hli], a
	inc a
	ld [hl], a
	ld hl, wcb45
	ld a, " "
	ld [hli], a
	ld [hl], a
	ld hl, wcb59
	ld a, $61
	ld [hli], a
	ld [hl], a
	ld hl, wcb6e
	lb bc, 5, 18
	call ClearBox
	ld a, [wd265]
	dec a
	call CheckCaughtMon
	push af
	ld a, [wd265]
	ld b, a
	ld c, 1 ; get page 1
	callba GetDexEntryPagePointer
	pop af
	ld a, b
	ld hl, wcb6d
	call nz, FarText
	ld hl, wcaa3
	ld [hl], $35
	ld de, SCREEN_WIDTH
	add hl, de
	ld b, $f
.column_loop
	ld [hl], $37
	add hl, de
	dec b
	jr nz, .column_loop
	ld [hl], $3a
	ret

PrintPage2:
	ld hl, wca90
	ld bc, $a0
	ld a, " "
	call ByteFill
	ld hl, wca90
	ld a, $36
	ld b, $6
	call .FillColumn
	ld hl, wcaa3
	ld a, $37
	ld b, $6
	call .FillColumn
	ld hl, wcb08
	ld [hl], $38
	inc hl
	ld a, $39
	ld bc, SCREEN_HEIGHT
	call ByteFill
	ld [hl], $3a
	ld hl, wcb1c
	ld bc, SCREEN_WIDTH
	ld a, $32
	call ByteFill
	ld a, [wd265]
	dec a
	call CheckCaughtMon
	push af
	ld a, [wd265]
	ld b, a
	ld c, 2 ; get page 2
	callba GetDexEntryPagePointer
	pop af
	ld hl, wcaa5
	ld a, b
	jp nz, FarText
	ret

.FillColumn
	push de
	ld de, SCREEN_WIDTH
.column_loop
	ld [hl], a
	add hl, de
	dec b
	jr nz, .column_loop
	pop de
	ret

GBPrinterStrings:
String_Printer_Blank:
	done
String_Printer_CheckingLink:
	text ""
	next " CHECKING LINK..."
	done
String_Printer_Transmitting:
	ctxt ""
	next "  TRANSMITTING..."
	done
String_Printer_Printing:
	ctxt ""
	next "    PRINTING..."
	done
String_Printer_Error1:
	start_asm
	ld a, 1
	jr StringPrinterError
String_Printer_Error2:
	start_asm
	ld a, 2
	jr StringPrinterError
String_Printer_Error3:
	start_asm
	ld a, 3
	jr StringPrinterError
String_Printer_Error4:
	start_asm
	ld a, 4
StringPrinterError:
	ld [TempNumber], a
	ld hl, .text
	ret
.text
	ctxt " Printer Error @"
	deciram TempNumber, 1, 1
	ctxt ""
	next ""
	next "Check the Game Boy"
	next "Printer Manual."
	done

Function1dc381:
	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites
	xor a
	ld [hBGMapMode], a
	call LoadFontsBattleExtra

	ld de, PrinterHPIcon
	ld hl, VTiles2 tile $71
	lb bc, BANK(PrinterHPIcon), 1
	call Request1bpp

	ld de, PrinterLvIcon
	ld hl, VTiles2 tile $6e
	lb bc, BANK(PrinterLvIcon), 1
	call Request1bpp

	ld de, ShinyIcon
	ld hl, VTiles2 tile $3f
	lb bc, BANK(ShinyIcon), 1
	call Get2bpp

	xor a
	ld [wMonType], a
	callba CopyPkmnToTempMon
	hlcoord 0, 7
	lb bc, 9, 18
	call TextBox
	hlcoord 8, 2
	ld a, [TempMonLevel]
	call PrintFullLevel
	hlcoord 12, 2
	ld [hl], "◀" ; Filled left triangle
	inc hl
	ld de, TempMonMaxHP
	lb bc, 2, 3
	call PrintNum
	ld a, [wCurPartySpecies]
	ld [wd265], a
	ld [wCurSpecies], a
	ld hl, wPartyMonNicknames
	call Function1dc50e
	hlcoord 8, 4
	call PlaceString
	hlcoord 9, 6
	ld [hl], "/"
	call GetPokemonName
	hlcoord 10, 6
	call PlaceString
	hlcoord 8, 0
	ld [hl], "№"
	inc hl
	ld [hl], "."
	inc hl
	ld de, wd265
	lb bc, PRINTNUM_LEADINGZEROS | 1, 3
	call PrintNum
	hlcoord 1, 9
	ld de, .OT_string
	call PlaceString
	ld hl, wPartyMonOT
	call Function1dc50e
	hlcoord 4, 9
	call PlaceString
	hlcoord 1, 11
	ld de, .id_no_string
	call PlaceString
	hlcoord 4, 11
	ld de, TempMonID
	lb bc, PRINTNUM_LEADINGZEROS | 2, 5
	call PrintNum
	hlcoord 1, 14
	ld de, .move_string
	call PlaceString
	hlcoord 7, 14
	ld a, [TempMonMoves + 0]
	call PrintMoveName
	call PrintMonGenderShininess
	ld hl, wBoxAlignment
	xor a
	ld [hl], a
	ld a, [wCurPartySpecies]
	inc [hl]
	hlcoord 0, 0
	call _PrepMonFrontpic
	call ApplyTilemapInVBlank
	ld b, SCGB_STATS_SCREEN_HP_PALS
	predef GetSGBLayout
	jp SetPalettes

.OT_string
	db "OT/@"

.move_string
	db "MOVE@"

.id_no_string
	db "<ID>№.@"

Function1dc47b:
	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites
	xor a
	ld [hBGMapMode], a
	call LoadFontsBattleExtra
	xor a
	ld [wMonType], a
	callba CopyPkmnToTempMon
	hlcoord 0, 0
	lb bc, 15, 18
	call TextBox
	ld bc, SCREEN_WIDTH
	decoord 0, 0
	hlcoord 0, 1
	rst CopyBytes
	hlcoord 7, 0
	ld a, [TempMonMoves + 1]
	call PrintMoveName
	hlcoord 7, 2
	ld a, [TempMonMoves + 2]
	call PrintMoveName
	hlcoord 7, 4
	ld a, [TempMonMoves + 3]
	call PrintMoveName
	hlcoord 7, 7
	ld de, .stat_names
	call PlaceText
	hlcoord 16, 7
	ld de, TempMonAttack
	call .PrintTempMonStats
	hlcoord 16, 9
	ld de, TempMonDefense
	call .PrintTempMonStats
	hlcoord 16, 11
	ld de, TempMonSpclAtk
	call .PrintTempMonStats
	hlcoord 16, 13
	ld de, TempMonSpclDef
	call .PrintTempMonStats
	hlcoord 16, 15
	ld de, TempMonSpeed
	call .PrintTempMonStats
	call ApplyTilemapInVBlank
	ld b, SCGB_STATS_SCREEN_HP_PALS
	predef GetSGBLayout
	jp SetPalettes

.PrintTempMonStats
	lb bc, 2, 3
	jp PrintNum

.stat_names
	text "ATTACK"
	next "DEFENSE"
	next "SPCL.ATK"
	next "SPCL.DEF"
	next "SPEED"
	done

Function1dc50e:
	ld bc, NAME_LENGTH
	ld a, [wCurPartyMon]
	rst AddNTimes
	ld e, l
	ld d, h
	ret

PrintMoveName:
	and a
	jr z, .no_move
	ld [wd265], a
	call GetMoveName
	jr .got_string
.no_move
	ld de, .no_move_string
.got_string
	jp PlaceString
.no_move_string
	db "------------@"

PrintMonGenderShininess:
	callba GetGender
	ld a, " "
	jr c, .got_gender
	ld a, "♂"
	jr nz, .got_gender
	ld a, "♀"

.got_gender
	hlcoord 17, 2
	ld [hl], a
	ld bc, TempMonDVs
	callba CheckShininess
	ret nc
	hlcoord 18, 2
	ld [hl], "<SHINY>"
	ret
