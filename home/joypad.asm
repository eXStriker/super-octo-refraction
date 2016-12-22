ClearJoypad::
	xor a
; Pressed this frame (delta)
	ld [hJoyPressed], a
; Currently pressed
	ld [hJoyDown], a
	ret

Joypad::
; Read the joypad register and translate it to something more
; workable for use in-game. There are 8 buttons, so we can use
; one byte to contain all player input.

; Updates:

; hJoypadReleased: released this frame (delta)
; hJoypadPressed: pressed this frame (delta)
; hJoypadDown: currently pressed
; hJoypadSum: pressed so far

; Any of these three bits can be used to disable input.
	ld a, [wcfbe]
	and %11010000
	ret nz

; If we're saving, input is disabled.
	ld a, [wGameLogicPause]
	and a
	ret nz

; We can only get four inputs at a time.
; We take d-pad first for no particular reason.
	ld a, R_DPAD
	ld [rJOYP], a
; Read twice to give the request time to take.
	ld a, [rJOYP]
	ld a, [rJOYP]

; The Joypad register output is in the lo nybble (inversed).
; We make the hi nybble of our new container d-pad input.
	cpl
	and $f
	swap a

; We'll keep this in b for now.
	ld b, a

; Buttons make 8 total inputs (A, B, Select, Start).
; We can fit this into one byte.
	ld a, R_BUTTONS
	ld [rJOYP], a
; Wait for input to stabilize.
rept 6
	ld a, [rJOYP]
endr
; Buttons take the lo nybble.
	cpl
	and $f
	or b
	ld b, a

; Reset the joypad register since we're done with it.
	ld a, $30
	ld [rJOYP], a

; To get the delta we xor the last frame's input with the new one.
	ld a, [hJoypadDown] ; last frame
	ld e, a
	xor b
	ld d, a
; Released this frame:
	and e
	ld [hJoypadReleased], a
; Pressed this frame:
	ld a, d
	and b
	ld [hJoypadPressed], a

; Add any new presses to the list of collective presses:
	ld c, a
	ld a, [hJoypadSum]
	or c
	ld [hJoypadSum], a

; Currently pressed:
	ld a, b
	ld [hJoypadDown], a

; Now that we have the input, we can do stuff with it.

; For example, soft reset:
	and A_BUTTON | B_BUTTON | SELECT | START
	cp  A_BUTTON | B_BUTTON | SELECT | START
	jp z, Reset

; Or update input counters:
	ld a, [hJoypadPressed]
	ld hl, wAButtonCount
	ld b, a
	ld c, 8
.loop
	srl b
	rept 4
		ld a, [hl]
		adc 0
		ld [hli], a
	endr		
	dec c
	jr nz, .loop

	ret

GetJoypad::
; Update mirror joypad input from hJoypadDown (real input)

; hJoyReleased: released this frame (delta)
; hJoyPressed: pressed this frame (delta)
; hJoyDown: currently pressed

; bit 0 A
;     1 B
;     2 SELECT
;     3 START
;     4 RIGHT
;     5 LEFT
;     6 UP
;     7 DOWN

	push hl
	push de
	push bc
	push af
; The player input can be automated using an input stream.
; See more below.
	ld a, [InputType]
	inc a
	jr z, .auto	

; To get deltas, take this and last frame's input.
	ld a, [hJoypadDown] ; real input
	ld b, a
	ld a, [hJoyDown] ; last frame mirror
	ld e, a

; Released this frame:
	xor b
	ld d, a
	and e
	ld [hJoyReleased], a

; Pressed this frame:
	ld a, d
	and b
	ld [hJoyPressed], a

; It looks like the collective presses got commented out here.
;	ld c, a

; Currently pressed:
	ld a, b
	ld [hJoyDown], a ; frame input
.done
	jp PopOffRegsAndReturn

.auto
; Use a predetermined input stream (used in the catching tutorial).

; Stream format: [input][duration]
; A value of $ff will immediately end the stream.

; Read from the input stream.

	ld a, [AutoInputLength]
	and a
	jr z, .updateauto
	dec a
	ld [AutoInputLength], a
	jr .done
.updateauto
	ld hl, .done
	push hl
	ld a, [AutoInputBank]
	call StackCallInBankA

.Function:
	ld hl, AutoInputAddress
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [hli]
	cp $ff
	jr z, .stopAuto
	ld b, a

	ld a, [hli]
	ld [AutoInputLength], a
	inc a
	jr z, .noInput
	ld a, l
	ld [AutoInputAddress], a
	ld a, h
	ld [AutoInputAddress+1], a
	jr .finishAuto
.stopAuto
	call StopAutoInput
.noInput
	ld b, NO_INPUT
.finishAuto
	ld a, b
	ld [hJoyPressed], a ; pressed
	ld [hJoyDown], a ; input
	ret

StartAutoInput::
; Start reading automated input stream at a:hl.

	ld [AutoInputBank], a
	ld a, l
	ld [AutoInputAddress], a
	ld a, h
	ld [AutoInputAddress+1], a
; Start reading the stream immediately.
	xor a
	ld [AutoInputLength], a
; Reset input mirrors.
	ld [hJoyPressed], a ; pressed this frame
	ld [hJoyReleased], a ; released this frame
	ld [hJoyDown], a ; currently pressed

	dec a
	ld [InputType], a
	ret

StopAutoInput::
; Clear variables related to automated input.
	xor a
	ld [AutoInputBank], a
	ld [AutoInputAddress], a
	ld [AutoInputAddress+1], a
	ld [AutoInputLength], a
; Back to normal input.
	ld [InputType], a
	ret

JoyTitleScreenInput::
	call JoyTextDelay

	ld a, [hJoyDown]
	cp D_UP | SELECT | B_BUTTON
	jr z, .keyCombo
	ld a, [hJoyLast]
	and START | A_BUTTON
	jr nz, .keyCombo

	call DelayFrame
	dec c
	jr nz, JoyTitleScreenInput
; a key combo wasn't pressed
	and a
	ret
.keyCombo
	scf
	ret

JoyWaitAorB::
	call GetJoypad
	ld a, [hJoyPressed]
	and A_BUTTON | B_BUTTON
	ret nz
	call RTC
	call DelayFrame
	jr JoyWaitAorB

Script_waitbutton::
; script command 0x54
WaitButton::
	ld a, [hOAMUpdate]
	push af
	ld a, 1
	ld [hOAMUpdate], a
	call ApplyTilemapInVBlank
	call JoyWaitAorB
	pop af
	ld [hOAMUpdate], a
	ret

Script_endtext::
; will crash if not called in BANK 25
	ld a, [hOAMUpdate]
	push af
	ld a, 1
	ld [hOAMUpdate], a
	call ApplyTilemapInVBlank
	jr .handleLoop

.loop
	call RTC
	call DelayFrame
.handleLoop
	call GetJoypad
	ld a, [hJoyPressed]
	and A_BUTTON | B_BUTTON | D_PAD
	jr z, .loop
	pop af
	ld [hOAMUpdate], a
	call Script_closetext
	jp Script_end

JoyTextDelay::
	call GetJoypad
	ld a, [hInMenu]
	and a
	ld a, [hJoyPressed]
	jr z, .inMenu
	ld a, [hJoyDown]
.inMenu
	ld [hJoyLast], a
	ld a, [hJoyPressed]
	and a
	jr z, .checkFrameDelay
	ld a, 15
	ld [wTextDelayFrames], a
	ret

.checkFrameDelay
	ld a, [wTextDelayFrames]
	and a
	jr z, .restartFrameDelay
	xor a
	ld [hJoyLast], a
	ret

.restartFrameDelay
	ld a, 5
	ld [wTextDelayFrames], a
	ret

WaitPressAorB_BlinkCursor::
	call BlinkCursor
	call CheckIfAOrBPressed
	ret nz
	call DelayFrame
	jr WaitPressAorB_BlinkCursor

SimpleWaitPressAorB::
	call CheckIfAOrBPressed
	ret nz
	call DelayFrame
	jr SimpleWaitPressAorB

CheckIfAOrBPressed:
	call JoyTextDelay
	ld a, [hJoyLast]
	and A_BUTTON | B_BUTTON
	ret

ButtonSound::
	ld a, [wLinkMode]
	and a
	jr nz, .linkMode
	call .doInputLoop
	push de
	ld de, SFX_READ_TEXT_2
	call PlaySFX
	pop de
	ret

.linkMode
	ld c, 65
	jp DelayFrames

.doInputLoop
	ld a, [hOAMUpdate]
	push af
	ld a, $1
	ld [hOAMUpdate], a
	ld a, [InputType]
	and a
	jr z, .inputWaitLoop
	callba _DudeAutoInput_A

.inputWaitLoop
	call BlinkCursor
	call CheckIfAOrBPressed
	jr nz, .receivedInput
	call RTC
	ld a, $1
	ld [hBGMapMode], a
	call DelayFrame
	jr .inputWaitLoop

.receivedInput
	pop af
	ld [hOAMUpdate], a
	ret

BlinkCursor:
	ld a, [hVBlankCounter]
	bit 4, a ; change cursor state every 16 frames
	ld a, "▼"
	jr nz, .cursorOn
	lda_coord 17, 17
.cursorOn
	ldcoord_a 18, 17
	ret
