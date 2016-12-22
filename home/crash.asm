Crash::
	ld [hCrashRST], a
	ld a, [hCrashSavedA]
	ld [hCrashSP], sp
	ld sp, hCrashSP
	push hl
	push de
	push bc
	push af
	call DisableLCD
	xor a
	ld [rVBK], a
	ld hl, VTiles1
	call FarCopyFontToHL
	ld a, BANK(_Crash)
	ld [MBC3RomBank], a
	jp _Crash