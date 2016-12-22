AnchorBGMap::
	ld a, [hOAMUpdate]
	push af

	ld a, $1
	ld [hOAMUpdate], a
	ld a, [hBGMapMode]
	push af

	xor a
	ld [hBGMapMode], a
	ld [wLCDCPointer], a
	ld a, $90
	ld [hWY], a
	call OverworldTextModeSwitch

	ld a, VBGMap1 / $100 ; window
	ld [hBGMapAddress + 1], a
	xor a
	ld [hBGMapAddress], a
	call BGMapAnchorTopLeft
	callba LoadOW_BGPal7
	callba ApplyPals
	xor a
	ld [hBGMapMode], a
	ld [hWY], a
	ld [hBGMapAddress], a
	ld [wBGMapAnchor], a
	ld [hSCX], a
	ld [hSCY], a
	inc a
	ld [hCGBPalUpdate], a
	ld a, VBGMap0 / $100 ; overworld
	ld [hBGMapAddress + 1], a
	ld [wBGMapAnchor + 1], a
	call ReanchorOverworldSprites

	pop af
	ld [hBGMapMode], a
	pop af
	ld [hOAMUpdate], a
	ld hl, VramState
	set 6, [hl]
	ret

LoadFont::
	ld a, [hOAMUpdate]
	push af
	ld a, $1
	ld [hOAMUpdate], a

	call LoadFontsExtra
	ld a, $90
	ld [hWY], a
	call Function2e31
	call LoadStandardFont

	pop af
	ld [hOAMUpdate], a
	ret
