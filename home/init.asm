Reset::
	di
	call TurnSoundOff
	xor a
	ld [hMapAnims], a
	call ClearPalettes
	xor a
	ld [rIF], a
	ld a, 1 ; VBlank int
	ld [rIE], a
	ei

	; disable joypad
	ld hl, wcfbe
	set 7, [hl]

	ld c, 32
	call DelayFrames

	jr Init_NoDI

_Start::
	cp $11
	ld a, $1
	jr z, .cgb
	xor a
.cgb
	ld [hCGB], a
	ld a, $1
	ld [hFFEA], a
	; fallthrough

Init::
	di
	; fallthrough

Init_NoDI:
	xor a
	ld [rIF], a
	ld [rIE], a
	ld [rRP], a
	ld [rSCX], a
	ld [rSCY], a
	ld [rSB], a
	ld [rSC], a
	ld [rWX], a
	ld [rWY], a
	ld [rBGP], a
	ld [rOBP0], a
	ld [rOBP1], a
	ld [rTMA], a
	ld [rTAC], a
	ld [$d000], a

	ld a, %100 ; Start timer at 4096Hz
	ld [rTAC], a

.wait
	ld a, [rLY]
	cp 145
	jr nz, .wait

	xor a
	ld [rLCDC], a

; Clear WRAM bank 0
	ld hl, $c000
	ld bc, $d000 - $c000
.byteFill
	ld [hli], a
	dec c
	jr nz, .byteFill
	dec b
	jr nz, .byteFill

	ld sp, Stack

; Clear HRAM
	ld a, [hCGB]
	push af
	ld a, [hFFEA]
	push af
	xor a
	ld hl, HRAM_START
	ld bc, HRAM_END - HRAM_START
	call ByteFill
	pop af
	ld [hFFEA], a
	pop af
	ld [hCGB], a

	call ClearWRAM
	call ClearVRAM
	call ClearSprites

	; load the current build number to WRAM, in a place that should not be modified, ever
	ld hl, wBuildNumberCheck
	ld a, BUILD_NUMBER >> 8
	ld [hli], a
	ld [hl], BUILD_NUMBER & $ff

	; initialize RNG state. For now, we'll just pick a number.
	ld hl, wRNGState
	ld a, $12
	ld [hli], a
	ld a, $34
	ld [hli], a
	ld a, $56
	ld [hli], a
	ld [hl], $78

	callba LoadPushOAM

	xor a
	ld [hMapAnims], a
	ld [hSCX], a
	ld [hSCY], a
	ld [rJOYP], a

	ld a, $8 ; HBlank int enable
	ld [rSTAT], a

	ld a, $90
	ld [hWY], a
	ld [rWY], a

	ld a, 7
	ld [hWX], a
	ld [rWX], a

	ld a, %11100011
	; LCD on
	; Win tilemap 1
	; Win on
	; BG/Win tiledata 0
	; BG Tilemap 0
	; OBJ 8x8
	; OBJ on
	; BG on
	ld [rLCDC], a

	ld a, -1
	ld [hLinkPlayerNumber], a

	ld a, VBGMap1 / $100
	ld [hBGMapAddress + 1], a
	xor a ; VBGMap1 % $100
	ld [hBGMapAddress], a

	callba StartClock

	xor a
	ld [MBC3LatchClock], a
	ld [MBC3SRamEnable], a

	ld a, [hCGB]
	and a
	call nz, DoubleSpeed

	xor a
	ld [rIF], a
	ld a, 1 << VBLANK | 1 << SERIAL ; VBlank, LCDStat, Timer, Serial interrupts
	ld [rIE], a
	call LoadLCDCode
	ei

	call DelayFrame

	call TurnSoundOff
	xor a
	ld [wMapMusic], a
	ld a, BANK(GameInit)
	rst Bankswitch
	jp GameInit

ClearVRAM::
; Wipe VRAM banks 0 and 1

	ld a, 1
	ld [rVBK], a
	call .clear

	xor a
	ld [rVBK], a
.clear
	ld hl, VTiles0
	ld bc, SRAM_Begin - VTiles0
	xor a
	jp ByteFill

ClearWRAM::
; Wipe swappable WRAM banks (1-7)
	ld d, 7 ; count backwards from bank 7
.loop
	ld a, d
	ld [rSVBK], a
	xor a
	ld hl, $d000
	ld bc, $1000
	call ByteFill
	dec d
	jr nz, .loop
	ret
