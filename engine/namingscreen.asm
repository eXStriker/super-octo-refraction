_NamingScreen:
	call DisableSpriteUpdates
	call NamingScreen
	jp ReturnToMapWithSpeechTextbox

NamingScreen:
	ld hl, wNamingScreenDestinationPointer
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, wNamingScreenType
	ld [hl], b
	ld hl, wOptions
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]
	ld a, [hMapAnims]
	push af
	xor a
	ld [hMapAnims], a
	ld a, [hInMenu]
	push af
	ld a, $1
	ld [hInMenu], a
	call .SetUpNamingScreen
	call DelayFrame
.loop
	call NamingScreenJoypadLoop
	jr nc, .loop
	pop af
	ld [hInMenu], a
	pop af
	ld [hMapAnims], a
	pop af
	ld [wOptions], a
	jp ClearJoypad

.SetUpNamingScreen:
	call ClearBGPalettes
	ld b, SCGB_SCROLLINGMENU
	predef GetSGBLayout
	call DisableLCD
	call LoadNamingScreenGFX
	call NamingScreen_InitText
	call EnableLCD
	ld a, $e3
	ld [rLCDC], a
	call .GetNamingScreenSetup
	call ApplyTilemapInVBlank
	call WaitTop
	call SetPalettes
	jp NamingScreen_InitNameEntry

.GetNamingScreenSetup:
	ld a, [wNamingScreenType]
	and 7
	jumptable

	dw .Pokemon
	dw .Player
	dw .Rival
	dw .Unused
	dw .Box
	dw .Unused
	dw .Pokemon
	dw .Pokemon

.Pokemon:
	ld a, [wCurPartySpecies]
	ld [wd265], a
	ld e, $1
	callba LoadPokemonIconFromMem
	ld a, [wCurPartySpecies]
	ld [wd265], a
	call GetPokemonName
	hlcoord 5, 2
	call PlaceString
	ld l, c
	ld h, b
	ld de, .NicknameStrings
	call PlaceString
	inc de
	hlcoord 5, 4
	call PlaceString
	callba GetGender
	jr c, .genderless
	ld a, "♂"
	jr nz, .place_gender
	ld a, "♀"
.place_gender
	hlcoord 1, 2
	ld [hl], a
.genderless
	jp .StoreMonIconParams

.NicknameStrings:
	db "'s@"
	db "Nickname?@"

.Player:
	call GetPlayerIcon
	call .LoadSprite
	hlcoord 5, 2
	ld de, .PlayerNameString
	call PlaceText
	callba GetPlayerPalettePointer
	ld a, [rSVBK]
	push af
	ld a, BANK(UnknOBPals)
	ld [rSVBK], a
	ld de, UnknOBPals + 2
	ld bc, 4
	rst CopyBytes
	pop af
	ld [rSVBK], a
	callba ApplyPals
	jp .StoreSpriteIconParams

.PlayerNameString:
	ctxt "Your name?"
	done

.Rival:
	ld hl, SilverSpriteGFX
	ld a, BANK(SilverSpriteGFX)
	call FarDecompressWRA6
	call .LoadSprite
	hlcoord 5, 2
	ld de, .RivalNameString
	call PlaceText
	jp .StoreSpriteIconParams

.RivalNameString:
	ctxt "Rival's Name?"
	done

.Box:
	ld de, PokeBallSpriteGFX
	ld hl, VTiles0 tile $00
	lb bc, BANK(PokeBallSpriteGFX), $4
	call Request2bpp
	xor a
	ld hl, wSpriteAnimDict
	ld [hli], a
	ld [hl], a
	depixel 4, 4, 4, 0
	ld a, SPRITE_ANIM_INDEX_RED_WALK
	call _InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	ld [hl], $0
	hlcoord 5, 2
	ld de, .BoxNameString
	call PlaceText
	jp .StoreBoxIconParams

.BoxNameString:
	ctxt "Box Name?"
	done

.LoadSprite:
	ld de, wDecompressScratch
	ld hl, VTiles0 tile $00
	ld c, 4
	call Request2bppInWRA6
	ld de, wDecompressScratch + 12 tiles
	ld hl, VTiles0 tile $04
	ld c, 4
	call Request2bppInWRA6
	xor a
	ld hl, wSpriteAnimDict
	ld [hli], a
	ld [hl], a
	ld a, SPRITE_ANIM_INDEX_RED_WALK
	depixel 4, 4, 4, 0
	jp _InitSpriteAnimStruct

.StoreMonIconParams:
	ld a, PKMN_NAME_LENGTH - 1
	hlcoord 5, 6
	jr .StoreParams

.StoreSpriteIconParams:
	ld a, PLAYER_NAME_LENGTH - 1
	hlcoord 5, 6
	jr .StoreParams

.StoreBoxIconParams:
	ld a, BOX_NAME_LENGTH - 1
	hlcoord 5, 4
	jr .StoreParams

.StoreParams:
	ld [wNamingScreenMaxNameLength], a
	ld a, l
	ld [wNamingScreenStringEntryCoord], a
	ld a, h
	ld [wNamingScreenStringEntryCoord + 1], a
.Unused:
	ret

NamingScreen_IsTargetBox:
	push bc
	push af
	ld a, [wNamingScreenType]
	sub $3
	ld b, a
	pop af
	dec b
	pop bc
	ret

NamingScreen_InitText:
	call WaitTop
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, $60
	call ByteFill
	hlcoord 1, 1
	lb bc, 6, 18
	call NamingScreen_IsTargetBox
	jr nz, .not_box
	lb bc, 4, 18

.not_box
	call ClearBox
	ld de, NameInputUpper
NamingScreen_ApplyTextInputMode:
	call NamingScreen_IsTargetBox
	jr nz, .not_box
	ld hl, BoxNameInputLower - NameInputLower
	add hl, de
	ld d, h
	ld e, l

.not_box
	push de
	hlcoord 1, 8
	lb bc, 7, 18
	call NamingScreen_IsTargetBox
	jr nz, .not_box_2
	hlcoord 1, 6
	lb bc, 9, 18

.not_box_2
	call ClearBox
	hlcoord 1, 16
	lb bc, 1, 18
	call ClearBox
	pop de
	hlcoord 2, 8
	ld b, $5
	call NamingScreen_IsTargetBox
	jr nz, .row
	hlcoord 2, 6
	ld b, $6

.row
	ld c, $11
.col
	ld a, [de]
	ld [hli], a
	inc de
	dec c
	jr nz, .col
	push de
	ld de, 2 * SCREEN_WIDTH - $11
	add hl, de
	pop de
	dec b
	jr nz, .row
	ret

NamingScreenJoypadLoop:
	call JoyTextDelay
	ld a, [wJumptableIndex]
	bit 7, a
	jr nz, .quit
	call .RunJumptable
	callba PlaySpriteAnimationsAndDelayFrame
	call .UpdateStringEntry
	call DelayFrame
	and a
	ret

.quit
	callba ClearSpriteAnims
	call ClearSprites
	xor a
	ld [hSCX], a
	ld [hSCY], a
	scf
	ret

.UpdateStringEntry:
	xor a
	ld [hBGMapMode], a
	hlcoord 1, 5
	call NamingScreen_IsTargetBox
	jr nz, .got_coords
	hlcoord 1, 3

.got_coords
	lb bc, 1, 18
	call ClearBox
	ld hl, wNamingScreenDestinationPointer
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, wNamingScreenStringEntryCoord
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PlaceString
	ld a, $1
	ld [hBGMapMode], a
	ret

.RunJumptable:
	ld a, [wJumptableIndex]
	jumptable

	dw .InitCursor
	dw .ReadButtons

.InitCursor:
	depixel 10, 3
	call NamingScreen_IsTargetBox
	jr nz, .got_cursor_position
	ld d, 8 * 8
.got_cursor_position
	ld a, SPRITE_ANIM_INDEX_02
	call _InitSpriteAnimStruct
	ld a, c
	ld [wNamingScreenCursorObjectPointer], a
	ld a, b
	ld [wNamingScreenCursorObjectPointer + 1], a
	ld hl, SPRITEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	ld a, [hl]
	ld hl, SPRITEANIMSTRUCT_0E
	add hl, bc
	ld [hl], a
	; call RandomizeCursorPosition
	ld hl, wJumptableIndex
	inc [hl]
	ret

.ReadButtons:
	ld hl, hJoyPressed ; $ffa7
	ld a, [hl]
	and A_BUTTON
	jr nz, .a
	ld a, [hl]
	and B_BUTTON
	jr nz, .b
	ld a, [hl]
	and START
	jr nz, .start
	ld a, [hl]
	and SELECT
	jr nz, .select
	ret

.a
	call .GetCursorPosition
	cp $1
	jr z, .select
	cp $2
	jr z, .b
	cp $3
	jr z, .end
	call NamingScreen_GetLastCharacter
	call NamingScreen_TryAddCharacter
	ret nc

.start
	ld hl, wNamingScreenCursorObjectPointer
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld hl, SPRITEANIMSTRUCT_0C
	add hl, bc
	ld [hl], $8
	ld hl, SPRITEANIMSTRUCT_0D
	add hl, bc
	ld [hl], $4
	call NamingScreen_IsTargetBox
	ret nz
	inc [hl]
	ret

.b
	jp NamingScreen_DeleteCharacter

.end
	call NamingScreen_StoreEntry
	ld hl, wJumptableIndex
	set 7, [hl]
	ret

.select
	ld hl, wcf64
	ld a, [hl]
	xor 1
	ld [hl], a
	jr z, .upper
	ld de, NameInputLower
	jp NamingScreen_ApplyTextInputMode

.upper
	ld de, NameInputUpper
	jp NamingScreen_ApplyTextInputMode

.GetCursorPosition:
	ld hl, wNamingScreenCursorObjectPointer
	ld c, [hl]
	inc hl
	ld b, [hl]

NamingScreen_GetCursorPosition:
	ld hl, SPRITEANIMSTRUCT_0D
	add hl, bc
	ld a, [hl]
	push bc
	ld b, $4
	call NamingScreen_IsTargetBox
	jr nz, .not_box
	inc b
.not_box
	cp b
	pop bc
	jr nz, .not_bottom_row
	ld hl, SPRITEANIMSTRUCT_0C
	add hl, bc
	ld a, [hl]
	cp $3
	jr c, .case_switch
	cp $6
	jr c, .delete
	ld a, $3
	ret

.case_switch
	ld a, $1
	ret

.delete
	ld a, $2
	ret

.not_bottom_row
	xor a
	ret

; RandomizeCursorPosition:
	; call NamingScreen_IsTargetBox
	; push bc
	; ld a, 36
	; jr nz, .not_box
	; ld a, 45
; .not_box
	; call RandomRange
	; ld c, 9
	; call SimpleDivide
	; ld d, b
	; pop bc
	; ld hl, SPRITEANIMSTRUCT_0C
	; add hl, bc
	; ld [hli], a
	; ld [hl], d
	; ret

NamingScreen_AnimateCursor:
	call .GetDPad
	ld hl, SPRITEANIMSTRUCT_0D
	add hl, bc
	ld a, [hl]
	ld e, a
	swap e
	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], e
	ld d, $4
	call NamingScreen_IsTargetBox
	jr nz, .ok
	inc d
.ok
	cp d
	ld de, .LetterEntries
	ld a, $0
	jr nz, .ok2
	ld de, .CaseDelEnd
	ld a, $1
.ok2
	ld hl, SPRITEANIMSTRUCT_0E
	add hl, bc
	add [hl]
	ld hl, SPRITEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	ld [hl], a
	ld hl, SPRITEANIMSTRUCT_0C
	add hl, bc
	ld l, [hl]
	ld h, $0
	add hl, de
	ld a, [hl]
	ld hl, SPRITEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ret

.LetterEntries:
	db $00, $10, $20, $30, $40, $50, $60, $70, $80

.CaseDelEnd:
	db $00, $00, $00, $30, $30, $30, $60, $60, $60

.GetDPad:
	ld hl, hJoyLast
	ld a, [hl]
	and D_UP
	jr nz, .up
	ld a, [hl]
	and D_DOWN
	jr nz, .down
	ld a, [hl]
	and D_LEFT
	jr nz, .left
	ld a, [hl]
	and D_RIGHT
	jr nz, .right
	ret

.right
	call NamingScreen_GetCursorPosition
	and a
	jr nz, .asm_11ab7
	ld hl, SPRITEANIMSTRUCT_0C
	add hl, bc
	ld a, [hl]
	cp $8
	jr nc, .asm_11ab4
	inc [hl]
	ret

.asm_11ab4
	ld [hl], $0
	ret

.asm_11ab7
	cp $3
	jr nz, .asm_11abc
	xor a
.asm_11abc
	ld e, a
	add a
	add e
	ld hl, SPRITEANIMSTRUCT_0C
	add hl, bc
	ld [hl], a
	ret

.left
	call NamingScreen_GetCursorPosition
	and a
	jr nz, .asm_11ad8
	ld hl, SPRITEANIMSTRUCT_0C
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_11ad5
	dec [hl]
	ret

.asm_11ad5
	ld [hl], $8
	ret

.asm_11ad8
	cp $1
	jr nz, .asm_11ade
	ld a, $4
.asm_11ade
	dec a
	dec a
	ld e, a
	add a
	add e
	ld hl, SPRITEANIMSTRUCT_0C
	add hl, bc
	ld [hl], a
	ret

.down
	ld hl, SPRITEANIMSTRUCT_0D
	add hl, bc
	ld a, [hl]
	call NamingScreen_IsTargetBox
	jr nz, .asm_11af9
	cp $5
	jr nc, .asm_11aff
	inc [hl]
	ret

.asm_11af9
	cp $4
	jr nc, .asm_11aff
	inc [hl]
	ret

.asm_11aff
	ld [hl], $0
	ret

.up
	ld hl, SPRITEANIMSTRUCT_0D
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_11b0c
	dec [hl]
	ret

.asm_11b0c
	ld [hl], $4
	call NamingScreen_IsTargetBox
	ret nz
	inc [hl]
	ret

NamingScreen_TryAddCharacter:
	ld a, [wNamingScreenMaxNameLength]
	ld c, a
	ld a, [wNamingScreenCurrNameLength]
	cp c
	ret nc

	ld a, [wNamingScreenLastCharacter]

NamingScreen_LoadNextCharacter:
	call NamingScreen_GetTextCursorPosition
	ld [hl], a

NamingScreen_AdvanceCursor_CheckEndOfString:
	ld hl, wNamingScreenCurrNameLength
	inc [hl]
	call NamingScreen_GetTextCursorPosition
	ld a, [hl]
	cp "@"
	jr z, .end_of_string
	ld [hl], $f2
	and a
	ret

.end_of_string
	scf
	ret

NamingScreen_DeleteCharacter:
	ld hl, wNamingScreenCurrNameLength
	ld a, [hl]
	and a
	ret z
	dec [hl]
	call NamingScreen_GetTextCursorPosition
	ld [hl], $f2
	inc hl
	ld a, [hl]
	cp $f2
	ret nz
	ld [hl], $eb
	ret

NamingScreen_GetTextCursorPosition:
	push af
	ld hl, wNamingScreenDestinationPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wNamingScreenCurrNameLength]
	ld e, a
	ld d, 0
	add hl, de
	pop af
	ret

NamingScreen_InitNameEntry:
; load $f2, ($eb * [wNamingScreenMaxNameLength]), $50 into the dw address at wNamingScreenDestinationPointer
	ld hl, wNamingScreenDestinationPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld [hl], $f2
	inc hl
	ld a, [wNamingScreenMaxNameLength]
	dec a
	ld c, a
	ld a, $eb
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	ld [hl], "@"
	ret

NamingScreen_StoreEntry:
	ld hl, wNamingScreenDestinationPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wNamingScreenMaxNameLength]
	ld c, a
.loop
	ld a, [hl]
	cp $eb
	jr z, .terminator
	cp $f2
	jr nz, .not_terminator
.terminator
	ld [hl], "@"
.not_terminator
	inc hl
	dec c
	jr nz, .loop
	ret

NamingScreen_GetLastCharacter:
	ld hl, wNamingScreenCursorObjectPointer
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld hl, SPRITEANIMSTRUCT_XOFFSET
	add hl, bc
	ld a, [hl]
	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	add [hl]
	sub $8
	srl a
	srl a
	srl a
	ld e, a
	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld a, [hl]
	ld hl, SPRITEANIMSTRUCT_YCOORD
	add hl, bc
	add [hl]
	sub $10
	srl a
	srl a
	srl a
	ld d, a
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH
.loop
	ld a, d
	and a
	jr z, .done
	add hl, bc
	dec d
	jr .loop

.done
	add hl, de
	ld a, [hl]
	ld [wNamingScreenLastCharacter], a
	ret

LoadNamingScreenGFX:
	call ClearSprites
	callba ClearSpriteAnims
	call LoadStandardFont
	call LoadFontsExtra

	ld de, NamingScreenGFX_MiddleLine
	ld hl, VTiles1 tile $6b
	lb bc, BANK(NamingScreenGFX_MiddleLine), 1
	call Get1bpp

	ld de, NamingScreenGFX_UnderLine
	ld hl, VTiles1 tile $72
	lb bc, BANK(NamingScreenGFX_UnderLine), 1
	call Get1bpp

	ld de, VTiles2 tile $60
	ld hl, NamingScreenGFX_Border
	ld bc, 1 tiles
	ld a, BANK(NamingScreenGFX_Border)
	call FarCopyBytes

	ld de, VTiles0 tile $7e
	ld hl, NamingScreenGFX_Cursor
	ld bc, 2 tiles
	ld a, BANK(NamingScreenGFX_Cursor)
	call FarCopyBytes

	ld a, $5
	ld hl, wSpriteAnimDict + 9 * 2
	ld [hli], a
	ld [hl], $7e
	xor a
	ld [hSCY], a
	ld [wGlobalAnimYOffset], a
	ld [hSCX], a
	ld [wGlobalAnimXOffset], a
	ld [wJumptableIndex], a
	ld [wcf64], a
	ld [hBGMapMode], a
	ld [wNamingScreenCurrNameLength], a
	ld a, $7
	ld [hWX], a
	ret

NamingScreenGFX_Border: INCBIN "gfx/unknown/011cb7.2bpp"

NamingScreenGFX_Cursor: INCBIN "gfx/unknown/011cc7.2bpp"

NameInputLower:
	db "a b c d e f g h i"
	db "j k l m n o p q r"
	db "s t u v w x y z  "
	db "× ( ) : ; [ ] <PK> <MN>"
	db "UPPER  DEL   END "

BoxNameInputLower:
	db "a b c d e f g h i"
	db "j k l m n o p q r"
	db "s t u v w x y z  "
	db "é 'd 'l 'm 'r 's 't 'v 0"
	db "1 2 3 4 5 6 7 8 9"
	db "UPPER  DEL   END "

NameInputUpper:
	db "A B C D E F G H I"
	db "J K L M N O P Q R"
	db "S T U V W X Y Z  "
	db "- ? ! / . ,      "
	db "lower  DEL   END "

BoxNameInputUpper:
	db "A B C D E F G H I"
	db "J K L M N O P Q R"
	db "S T U V W X Y Z  "
	db "× ( ) : ; [ ] <PK> <MN>"
	db "- ? ! ♂ ♀ / . , &"
	db "lower  DEL   END "

NamingScreenGFX_MiddleLine: INCBIN "gfx/unknown/011e65.2bpp"

NamingScreenGFX_UnderLine: INCBIN "gfx/unknown/011e6d.2bpp"
