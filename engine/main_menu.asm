MainMenu:
	xor a
	ld [wLinkSuppressTextScroll], a
	ld [hMapAnims], a
	call ClearTileMap
	call LoadFontsExtra
	call LoadStandardFont
	call ClearWindowData
	ld b, SCGB_SCROLLINGMENU
	predef GetSGBLayout
	call SetPalettes
	ld hl, GameTimerPause
	res 0, [hl]
	ld a, [wSaveFileExists]
	ld [wWhichIndexSet], a
	call MainMenu_PrintCurrentTimeAndDay
	call MainMenu_PrintVersion
	ld hl, .MenuDataHeader
	call LoadMenuDataHeader
	call MainMenuJoypadLoop
	call CloseWindow
	ret c
	call ClearTileMap
	call .DoMenuChoice
	jr MainMenu

.MenuDataHeader
	db $40 ; flags
	db 00, 00 ; start coords
	db 07, 16 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2
	db $80 ; flags
	db 0 ; items
	dw MainMenuItems
	dw PlaceMenuStrings
	dw .Strings

.Strings
	db "Continue@"
	db "New Game@"
	db "Option@"

.DoMenuChoice:
	ld a, [wMenuSelection]
	and a
	jr z, .doContinue
	dec a
	jr z, .doNewGame
	jpba OptionsMenu

.doContinue
	jpba Continue
	
.doNewGame
	jpba NewGame

CONTINUE       EQU 0
NEW_GAME       EQU 1
OPTION         EQU 2

MainMenuItems:
NewGameMenu:
	db 2
	db NEW_GAME
	db OPTION
	db -1

ContinueMenu:
	db 3
	db CONTINUE
	db NEW_GAME
	db OPTION
	db -1

MainMenuJoypadLoop:
	call SetUpMenu
.loop
	call MainMenu_PrintCurrentTimeAndDay
	ld a, [w2DMenuFlags1]
	set 5, a
	ld [w2DMenuFlags1], a
	call ReadMenuJoypad
	ld a, [wMenuJoypad]
	cp B_BUTTON
	jr z, .b_button
	cp A_BUTTON
	jr nz, .loop
	call PlayClickSFX
	and a
	ret

.b_button
	scf
	ret

MainMenu_PrintVersion:
	ld de, BuildNumber
	lb bc, $82, 4
	ld hl, wStringBuffer3
	call PrintNum
	ld a, "@"
	ld [wStringBuffer3 + 4], a
	ld hl, VersionNumber
	ld c, 0
	ld a, [hli]
	call .check_extra_digits
	ld a, [hl]
	call .check_extra_digits
	ld de, .version_string_debug
	hlcoord 2, 12
	debug_mode_flag
	jr c, .ok
	ld de, .version_string_release
	hlcoord 8, 12
.ok
	ld a, l
	sub c
	ld l, a
	jr nc, .no_carry
	dec h
.no_carry
	call PlaceText
	hlcoord 9, 13
	ld de, .build_string
	jp PlaceText
.version_string_debug
	ctxt "debug @"
.version_string_release
	ctxt "version @"
	deciram VersionNumber, 1, 2
	text ".@"
	deciram VersionNumber + 1, 1, 2
	done
.build_string
	ctxt "build <STRBF3>"
	done
.check_extra_digits
	cp 10
	ret c
	inc c
	cp 100
	ret c
	inc c
	ret

MainMenu_PrintCurrentTimeAndDay:
	ld a, [wSaveFileExists]
	and a
	ret z
	call .LoadTimeData
	xor a
	ld [hBGMapMode], a
	call .PlaceBox
	ld hl, wOptions
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]
	call .PlaceTime
	pop af
	ld [wOptions], a
	ld a, $1
	ld [hBGMapMode], a
	ret

.LoadTimeData
	ld a, BANK(sPlayerData)
	call GetSRAMBank
	ld hl, sPlayerData - wPlayerData + StartDay
	ld de, StartDay
	ld bc, wTimeDataEnd - StartDay
	rst CopyBytes
	jp CloseSRAM

.PlaceBox
	call CheckRTCStatus
	and $80
	jp nz, SpeechTextBox
	hlcoord 0, 14
	lb bc, 2, 18
	jp TextBox

.PlaceTime
	ld a, [wSaveFileExists]
	and a
	ret z
	call CheckRTCStatus
	and $80
	jp nz, .PrintTimeNotSet
	call ForceUpdateTime
	call GetWeekday
	ld c, a
	decoord 1, 15
	call MainMenu_PlaceCurrentDay
	hlcoord 5, 15
	ld b, 1
	call MainMenu_PrintDate
	decoord 4, 16
	ld a, [hHours]
	ld c, a
	callba PrintHour
	ld [hl], ":"
	inc hl
	ld de, hMinutes
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	push bc
	call PrintNum
	ld [hl], ":"
	inc hl
	ld de, hSeconds
	pop bc
	jp PrintNum

.PrintTimeNotSet
	hlcoord 1, 14
	ld de, .TimeNotSet
	jp PlaceText

.TimeNotSet
	ctxt "Time not set"
	done

MainMenu_PlaceCurrentDay:
	ld b, 0
	ld hl, .Days
	add hl, bc
	add hl, bc
	add hl, bc
	ld bc, 3
	jp CopyBytes

.Days
	db "Sun"
	db "Mon"
	db "Tue"
	db "Wed"
	db "Thu"
	db "Fri"
	db "Sat"

MainMenu_PrintDate:
	push bc
	push hl
	ld a, [CurDay]
	inc a
	ld de, wd265
	ld [de], a
	pop hl
	lb bc, 1, 2
	call PrintNum
	inc hl
	push hl

	ld a, [CurMonth]
	ld c, a
	ld b, 0
	ld hl, .MonthStrings
	add hl, bc
	add hl, bc
	add hl, bc
	pop de
	ld bc, 3
	rst CopyBytes

	pop af
	and a
	ret z
	inc de
	ld h, d
	ld l, e
	ld [hl], "2"
	inc hl
	ld de, CurYear
	lb bc, PRINTNUM_LEADINGZEROS | 1, 3
	jp PrintNum

.MonthStrings
	db "Jan"
	db "Feb"
	db "Mar"
	db "Apr"
	db "May"
	db "Jun"
	db "Jul"
	db "Aug"
	db "Sep"
	db "Oct"
	db "Nov"
	db "Dec"
