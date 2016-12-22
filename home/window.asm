Script_refreshscreen::
RefreshScreen::

	call ClearWindowData
	anonbankpush AnchorBGMap

.Function:
	call AnchorBGMap
	jr BGMapAnchorTopLeftAndLoadFont

Script_opentext::
; script command 0x47
OpenText::
	lda_coord 0, 12
	cp $79
	ret z
	call ClearWindowData
	anonbankpush AnchorBGMap

.Function:
	call AnchorBGMap
	call SpeechTextBox
BGMapAnchorTopLeftAndLoadFont:
	call BGMapAnchorTopLeft
	jp LoadFont

CloseText::
	ld a, [hOAMUpdate]
	push af
	ld a, $1
	ld [hOAMUpdate], a

	call ClearWindowData
	xor a
	ld [hBGMapMode], a
	call OverworldTextModeSwitch
	call BGMapAnchorTopLeft
	xor a
	ld [hBGMapMode], a
	call Function2e31
	ld a, $90
	ld [hWY], a
	call ReplaceKrisSprite

	pop af
	ld [hOAMUpdate], a
	ld hl, VramState
	res 6, [hl]
	ret

BGMapAnchorTopLeft::
	ld a, [hOAMUpdate]
	push af
	ld a, $1
	ld [hOAMUpdate], a

	ld b, 0
	call SafeCopyTilemapAtOnce

	pop af
	ld [hOAMUpdate], a
	ret

Function2e31::
	ld a, [hOAMUpdate]
	push af
	ld a, [hBGMapMode]
	push af
	xor a
	ld [hBGMapMode], a
	inc a
	ld [hOAMUpdate], a
	call UpdateSprites
	xor a
	ld [hOAMUpdate], a
	call DelayFrame
	pop af
	ld [hBGMapMode], a
	pop af
	ld [hOAMUpdate], a
	ret
