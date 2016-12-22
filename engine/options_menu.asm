OptionsMenu:
	ld hl, hInMenu
	ld a, [hl]
	push af
	ld [hl], $1
	call ClearBGPalettes
	hlcoord 0, 0
	lb bc, 16, 18
	call TextBox
	hlcoord 2, 2
	ld de, .options_string
	call PlaceText
	xor a
	ld [wJumptableIndex], a
	ld c, 6 ; number of items on the menu minus 1 (for cancel)

.print_text_loop ; this next will display the settings of each option when the menu is opened
	push bc
	xor a
	ld [hJoyLast], a
	call GetOptionPointer
	pop bc
	ld hl, wJumptableIndex
	inc [hl]
	dec c
	jr nz, .print_text_loop

	call UpdateFrame
	xor a
	ld [wJumptableIndex], a
	inc a
	ld [hBGMapMode], a
	call ApplyTilemapInVBlank
	ld b, SCGB_SCROLLINGMENU
	predef GetSGBLayout
	call SetPalettes

.joypad_loop
	call JoyTextDelay
	ld a, [hJoyPressed]
	and START | B_BUTTON
	jr nz, .ExitOptions
	call OptionsControl
	jr c, .dpad
	call GetOptionPointer
	jr c, .ExitOptions

.dpad
	call Options_UpdateCursorPosition
	call Delay2
	jr .joypad_loop

.ExitOptions
	ld de, SFX_TRANSACTION
	call PlayWaitSFX
	pop af
	ld [hInMenu], a
	ret

.options_string
	ctxt "Text Speed"
	nl   "        :"
	nl   "Battle Animations"
	nl   "        :"
	nl   "Battle Style"
	nl   "        :"
	nl   "Sound"
	nl   "        :"
	nl   "Printer Setting"
	nl   "        :"
	nl   "Turning Speed"
	nl   "        :"
	nl   "Text Frame"
	nl   "        :TYPE"
	nl   "Done"
	done

GetOptionPointer:
	call RunAnonymousJumptable

.Pointers
	dw Options_TextSpeed
	dw Options_BattleScene
	dw Options_BattleStyle
	dw Options_Sound
	dw Options_Print
	dw Options_TurningSpeed
	dw Options_Frame
	dw Options_Cancel

Options_TextSpeed:
	ld a, [wOptions]
	ld c, a
	ld a, [hJoyPressed]
	bit D_LEFT_F, a
	jr nz, .LeftPressed
	bit D_RIGHT_F, a
	jr z, .NonePressed
	inc c
	inc c

.LeftPressed
	dec c

.Save
	ld a, c
	and %11
	ld b, a
	ld a, [wOptions]
	and %11111100
	or b
	ld [wOptions], a

.NonePressed
	ld a, c
	and %11
	ld bc, 5
	ld hl, .Inst
	rst AddNTimes
	ld d, h
	ld e, l
	hlcoord 11, 3
	call PlaceString
	and a
	ret

.Inst
	db "Inst@"
.Fast
	db "Fast@"
.Mid
	db "Mid @"
.Slow
	db "Slow@"

Options_BattleScene:
	ld hl, wOptions
	ld a, [hJoyPressed]
	and D_RIGHT | D_LEFT
	ld a, [hl]
	jr nz, .switchBattleScene
	and 1 << BATTLE_SCENE
	jr .getString
.switchBattleScene
	xor 1 << BATTLE_SCENE
	ld [hl], a
.getString
	ld de, .On
	jr z, .gotString
	ld de, .Off
.gotString
	hlcoord 11, 5
	call PlaceString
	and a
	ret

.On
	db "On @"
.Off
	db "Off@"

Options_BattleStyle:
	ld hl, wOptions
	ld a, [hJoyPressed]
	and D_RIGHT | D_LEFT
	ld a, [hl]
	jr nz, .switchBattleStyle
	and 1 << BATTLE_SHIFT
	jr .getString
.switchBattleStyle
	xor 1 << BATTLE_SHIFT
	ld [hl], a
.getString
	ld de, .Shift
	jr z, .gotString
	ld de, .Set
.gotString
	hlcoord 11, 7
	call PlaceString
	and a
	ret

.Shift
	db "Shift@"
.Set
	db "Set  @"

Options_Sound:
	ld hl, wOptions
	ld a, [hJoyPressed]
	and D_LEFT | D_RIGHT
	ld a, [hl]
	jr nz, .switchSpeakers
	and 1 << STEREO
	jr .getString
.switchSpeakers
	xor 1 << STEREO
	ld [hl], a
.getString
	ld de, .Mono
	jr z, .gotString
	ld de, .Stereo
.gotString
	hlcoord 11, 9
	call PlaceString
	and a
	ret

.Mono
	db "Mono  @"
.Stereo
	db "Stereo@"

Options_Print:
	call GetPrinterSetting
	ld a, [hJoyPressed]
	bit D_LEFT_F, a
	jr nz, .LeftPressed
	bit D_RIGHT_F, a
	jr z, .NonePressed
	ld a, c
	cp 4
	jr c, .Increase
	ld c, -1

.Increase
	inc c
	ld a, e
	jr .Save

.LeftPressed
	ld a, c
	and a
	jr nz, .Decrease
	ld c, 5

.Decrease
	dec c
	ld a, d

.Save
	ld b, a
	ld [GBPrinter], a

.NonePressed
	ld a, c
	ld bc, 9
	ld hl, .Lightest
	rst AddNTimes
	ld d, h
	ld e, l
	hlcoord 11, 11
	call PlaceString
	and a
	ret

.Lightest
	db "Lightest@"
.Lighter
	db "Lighter @"
.Normal
	db "Normal  @"
.Darker
	db "Darker  @"
.Darkest
	db "Darkest @"

GetPrinterSetting:
	ld a, [GBPrinter] ; converts from the stored printer setting to 0,1,2,3,4
	and a
	ld c, a
	lb de, PRINT_DARKEST, PRINT_LIGHTER ; the 2 values next to this setting
	ret z
	ld c, 1
	cp PRINT_LIGHTER
	lb de, PRINT_LIGHTEST, PRINT_NORMAL ; the 2 values next to this setting
	ret z
	ld c, 3
	cp PRINT_DARKER
	lb de, PRINT_NORMAL, PRINT_DARKEST ; the 2 values next to this setting
	ret z
	inc c
	cp PRINT_DARKEST
	lb de, PRINT_DARKER, PRINT_LIGHTEST ; the 2 values next to this setting
	ret z
	ld c, 2 ; normal if none of the above
	lb de, PRINT_LIGHTER, PRINT_DARKER ; the 2 values next to this setting
	ret

Options_Frame:
	ld hl, TextBoxFrame
	ld a, [hJoyPressed]
	bit D_LEFT_F, a
	jr nz, .LeftPressed
	bit D_RIGHT_F, a
	jr nz, .RightPressed
	and a
	ret

.RightPressed
	ld a, [hl]
	inc a
	jr .Save

.LeftPressed
	ld a, [hl]
	dec a

.Save
	and $7
	ld [hl], a
UpdateFrame:
	ld a, [TextBoxFrame]
	add "1"
	ldcoord_a 16, 15
	call LoadFontsExtra
	and a
	ret

Options_TurningSpeed:
	ld hl, wOptions
	ld a, [hJoyPressed]
	and D_LEFT | D_RIGHT
	ld a, [hl]
	jr nz, .switchTurningSpeed
	and 1 << TURNING_SPEED
	jr .getString
.switchTurningSpeed
	xor 1 << TURNING_SPEED
	ld [hl], a
.getString
	ld de, .Slow
	jr z, .gotString
	ld de, .Fast
.gotString
	hlcoord 11, 13
	call PlaceString
	and a
	ret

.Fast
	db "Fast@"
.Slow
	db "Slow@"

Options_Cancel:
	ld a, [hJoyPressed]
	and A_BUTTON
	ret z
	scf
	ret

OptionsControl:
	ld hl, wJumptableIndex
	ld b, [hl]
	ld a, [hJoyLast]
	cp D_DOWN
	jr z, .DownPressed
	cp D_UP
	jr z, .UpPressed
	and a
	ret

.DownPressed
	inc b
	inc b
.UpPressed
	dec b
	ld a, b
	and 7
	ld [hl], a
	scf
	ret

Options_UpdateCursorPosition:
	hlcoord 1, 1
	ld de, SCREEN_WIDTH
	ld c, $10
.loop
	ld [hl], " "
	add hl, de
	dec c
	jr nz, .loop
	hlcoord 1, 2
	ld bc, 2 * SCREEN_WIDTH
	ld a, [wJumptableIndex]
	rst AddNTimes
	ld [hl], "▶"
	ret
