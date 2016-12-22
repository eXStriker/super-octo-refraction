; VBlank is the interrupt responsible for updating VRAM.

; In Pokemon Crystal, VBlank has been hijacked to act as the
; main loop. After time-sensitive graphics operations have been
; performed, joypad input and sound functions are executed.

; This prevents the display and audio output from lagging.


VBlank:: ; 283
	push af
	push bc
	push de
	push hl

	ld [hVBlankSavedA], a

	ld a, [hBuffer]
	push af

	ld a, [hVBlank]
	cp 7
	jr z, .skipToGameTime

	ld a, h
	ld [hCrashSavedHL], a
	ld a, l
	ld [hCrashSavedHL + 1], a

; Best way to get hl = sp

	ld hl, sp + 0
	ld a, h
	cp StackBottom / $100
	jr c, .SPTooLow
	cp (StackBottom / $100) + $1
	jr nc, .SPTooHigh

	ld hl, sp + 11
	ld h, [hl]
	bit 7, h ; highest bit of return point
	ld l, $5
	jr nz, .crash_screen

	ld hl, wBuildNumberCheck
	ld a, [hli]
	cp BUILD_NUMBER >> 8
	jr nz, .invalid_build_number
	ld a, [hl]
	cp BUILD_NUMBER & $ff
	jr nz, .invalid_build_number

	ld a, [hROMBank]
	ld [hROMBankBackup], a

	ld a, [hVBlank]
	and 7
	add a
	ld e, a
	ld d, 0

	ld hl, .VBlanks
	add hl, de

	ld a, [hli]
	ld h, [hl]
	ld l, a

	call _hl_

.doGameTime
	call GameTimer

; debugging, remove this for release
	ld a, [wVBlankOccurred]
	and a
	jr nz, .vblankOccurred
	jr .notDelayFrame
.vblankOccurred
	xor a
	ld [wVBlankOccurred], a
.notDelayFrame

	pop af
	ld [hBuffer], a

	ld a, [hROMBankBackup]
	rst Bankswitch

	pop hl
	pop de
	pop bc
	pop af
	reti

.skipToGameTime
	ld a, [hROMBank]
	ld [hROMBankBackup], a
	ld a, [hRunPicAnim]
	and a
	jr z, .doGameTime
	dec a
	jr z, .doPokeAnim
	dec a
	jr z, .doGrowlOrRoarAnim
; pokepic in overworld
	call AnimateTileset
	jr .doGameTime
.doGrowlOrRoarAnim
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a

	call ForcePushOAM

	ld a, BANK(CopyGrowlOrRoarPals)
	rst Bankswitch

	ld a, [hCGBPalUpdate]
	and a
	call nz, CopyGrowlOrRoarPals
	call RunOneFrameOfGrowlOrRoarAnim
	pop af
	ld [rSVBK], a
	jr .doGameTime

.invalid_build_number
	ld l, $8
	jr .crash_screen

.SPTooLow
	ld l, $7
	jr .crash_screen

.SPTooHigh
	ld l, $6
	; fallthrough

.crash_screen
; unfortunately, flags aren't preserved
	ld a, [hCrashSavedHL]
	ld h, a
	ld a, l
	ld [hCrashSavedErrorCode], a
	ld a, [hCrashSavedHL + 1]
	ld l, a ; retrieve hl while storing the crash error code in hCrashSavedErrorCodes
	ld a, [hVBlankSavedA]
	ld [hCrashSavedA], a
	add sp, $8
	ld a, [hCrashSavedErrorCode]
	jp Crash

.doPokeAnim
	call TransferAnimatingPicDuringHBlank
	ld a, BANK(SetUpPokeAnim)
	rst Bankswitch
	call SetUpPokeAnim
	jr .doGameTime

.VBlanks
	dw VBlank0
	dw VBlank1
	dw VBlank2
	dw VBlank3
	dw VBlank4
	dw VBlank5
	dw VBlank6
	dw VBlank7

VBlank0::
; normal operation

; rng
; scx, scy, wy, wx
; bg map buffer
; palettes
; dma transfer
; bg map
; tiles
; oam
; joypad
; sound

	ld a, [hSCX]
	ld [rSCX], a
	ld a, [hSCY]
	ld [rSCY], a
	ld a, [hWY]
	ld [rWY], a
	ld a, [hWX]
	ld [rWX], a

	; There's only time to call one of these in one vblank.
	; Calls are in order of priority.

	call UpdateBGMapBuffer
	jr c, .done
	call UpdatePals
	jr c, .done
	call DMATransfer
	jr c, .done
	call UpdateBGMap

	; These have their own timing checks.

	call Serve2bppRequest
	call Serve1bppRequest
	call AnimateTileset

.done
	call PushOAM
	; vblank-sensitive operations are done

	; inc frame counter
	ld hl, hVBlankCounter
	inc [hl]

	; advance random variables
	call UpdateDividerCounters
	call AdvanceRNGState

	call Joypad

	ld a, [hSeconds]
	ld [hSecondsBackup], a
; fallthrough

VBlankUpdateSound::
; sound only
	ld a, BANK(_UpdateSound)
	rst Bankswitch
	jp _UpdateSound

VBlank2::
	call AnimateTileset
	jr VBlankUpdateSound

VBlank6::
; palettes
; tiles
; dma transfer
; sound
	; inc frame counter
	ld hl, hVBlankCounter
	inc [hl]

	call UpdatePals
	jr c, VBlankUpdateSound

	call Serve2bppRequest
	call Serve1bppRequest
	call DMATransfer
	jr VBlankUpdateSound

VBlank4::
; bg map
; tiles
; oam
; joypad
; serial
; sound
	call UpdateBGMap
	call Serve2bppRequest
	call PushOAM
	call Joypad
	call AskSerial
	jr VBlankUpdateSound

VBlank1::
; exclusively for the title screen
; prevents rainbow flickering

; scx
; tiles
; oam
; sound / lcd stat
	ld a, [hSCX]
	ld [rSCX], a
	call Serve2bppRequest
	jr VBlank1EntryPoint
	
VBlank3::
; scx, scy
; palettes
; bg map
; tiles
; oam
; sound / lcd stat
	ld a, [hSCX]
	ld [rSCX], a
	ld a, [hSCY]
	ld [rSCY], a

	call UpdatePals
	jr c, VBlank1EntryPoint

	call UpdateBGMap
	call Serve2bppRequest
	call LYOverrideStackCopy

VBlank1EntryPoint:
	call PushOAM

	ld a, [rIE]
	push af
	ld a, [rIF]
	push af
	xor a
	ld [rIF], a
	ld a, %10 ; lcd stat
	ld [rIE], a
	ld [rIF], a

	ei
	call VBlankUpdateSound
	ld a, [hVBlank]
	dec a
	jr z, .noDI
	di
.noDI
	; request lcdstat
	ld a, [rIF]
	ld b, a
	; and any other ints
	pop af
	or b
	ld b, a
	; reset ints
	xor a
	ld [rIF], a
	pop af
	ld [rIE], a
	; enable ints besides joypad
	ld a, b
	ld [rIF], a
	ret

VBlank7::
; special vblank routine
; copies tilemap in one frame without any tearing
; also updates oam, and pals if specified
	ld a, BANK(VBlankSafeCopyTilemapAtOnce)
	rst Bankswitch
	jp VBlankSafeCopyTilemapAtOnce
	
VBlank5::
; scx
; palettes
; bg map
; tiles
; joypad
; sound
	ld a, [hSCX]
	ld [rSCX], a

	call UpdatePals
	jr c, .done

	call UpdateBGMap
	call Serve2bppRequest
.done
	call Joypad

	xor a
	ld [rIF], a
	ld a, [rIE]
	push af
	ld a, %10 ; lcd stat
	ld [rIE], a
	; request lcd stat
	ld [rIF], a

	ei
	call VBlankUpdateSound
	di

	xor a
	ld [rIF], a
	; enable ints besides joypad
	pop af
	ld [rIE], a
	ret