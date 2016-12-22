InitClock:
; Ask the player to set the time.
	ld a, [hInMenu]
	push af
	ld a, $1
	ld [hInMenu], a

	call ClearTileMap
	call ClearSprites
	call DisableSpriteUpdates

	xor a
	ld [hSCX], a
	ld [hSCY], a
	ld [rSCX], a
	ld [rSCY], a

	ld a, $10
	ld [MusicFade], a
	ld a, MUSIC_NONE % $100
	ld [MusicFadeIDLo], a
	ld a, MUSIC_NONE / $100
	ld [MusicFadeIDHi], a
	ld c, 8
	call DelayFrames
	ld c, 1
	call FadeBGToDarkestColor

	ld b, SCGB_SCROLLINGMENU
	predef GetSGBLayout
	xor a
	ld [hBGMapMode], a
	call LoadStandardFont

	ld de, GFX_908fb
	ld hl, VTiles2 tile $00
	lb bc, BANK(GFX_908fb), 3
	call Request1bpp

	call .ClearScreen
	call ApplyTilemapInVBlank
	ld c, 1
	call FadeOutBGPals
	ld hl, Text_WokeUpOak
	call PrintText
	ld hl, wc608
	ld bc, 50
	xor a
	call ByteFill
	ld a, 10
	ld [wInitHourBuffer], a

.loop
	ld hl, Text_WhatTimeIsIt
	call PrintText
	hlcoord 3, 7
	lb bc, 2, 15
	call TextBox
	hlcoord 11, 7
	ld [hl], $1
	hlcoord 11, 10
	ld [hl], $2
	hlcoord 4, 9
	call DisplayHourOClock
	ld c, 10
	call DelayFrames

.SetHourLoop
	call JoyTextDelay
	call SetHour
	jr nc, .SetHourLoop

	ld a, [wInitHourBuffer]
	ld [wStringBuffer2 + 1], a
	call .ClearScreen
	ld hl, Text_WhatHrs
	call PrintText
	call YesNoBox
	jr nc, .HourIsSet
	call .ClearScreen
	jr .loop

.HourIsSet
	ld hl, Text_HowManyMinutes
	call PrintText
	hlcoord 11, 7
	lb bc, 2, 7
	call TextBox
	hlcoord 15, 7
	ld [hl], $1
	hlcoord 15, 10
	ld [hl], $2
	hlcoord 12, 9
	call DisplayMinutesWithMinString
	ld c, 10
	call DelayFrames

.SetMinutesLoop
	call JoyTextDelay
	call SetMinutes
	jr nc, .SetMinutesLoop

	ld a, [wInitMinuteBuffer]
	ld [wStringBuffer2 + 2], a
	call .ClearScreen
	ld hl, Text_WhoaMins
	call PrintText
	call YesNoBox
	jr nc, .MinutesAreSet
	call .ClearScreen
	jr .HourIsSet

.MinutesAreSet
	ld a, [CurDay]
	ld [wStringBuffer2], a
	ld a, [CurMonth]
	ld [wStringBuffer2 + 4], a
	ld a, [CurYear]
	ld [wStringBuffer2 + 5], a
	call SetTimeOfDay
	ld hl, OakText_ResponseToSetTime
	call PrintText
	call WaitPressAorB_BlinkCursor
	pop af
	ld [hInMenu], a
	SetEngine ENGINE_TIME_ENABLED
	call EnableSpriteUpdates
	jpba InitializeStartDay

.ClearScreen
	xor a
	ld [hBGMapMode], a
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	xor a
	call ByteFill
	ld a, $1
	ld [hBGMapMode], a
	ret

SetHour:
	ld a, [hJoyPressed]
	and A_BUTTON
	jr nz, .Confirm

	ld hl, hJoyLast
	ld a, [hl]
	and D_UP
	jr nz, .up
	ld a, [hl]
	and D_DOWN
	jr nz, .down
	call DelayFrame
	and a
	ret

.down
	ld hl, wInitHourBuffer
	ld a, [hl]
	and a
	jr nz, .DecreaseThroughMidnight
	ld a, 23 + 1
.DecreaseThroughMidnight
	dec a
	ld [hl], a
	jr .okay

.up
	ld hl, wInitHourBuffer
	ld a, [hl]
	cp 23
	jr c, .AdvanceThroughMidnight
	ld a, -1
.AdvanceThroughMidnight
	inc a
	ld [hl], a

.okay
	hlcoord 4, 9
	ld a, " "
	ld bc, 15
	call ByteFill
	hlcoord 4, 9
	call DisplayHourOClock
	call ApplyTilemapInVBlank
	and a
	ret

.Confirm
	scf
	ret

DisplayHourOClock:
	push hl
	ld a, [wInitHourBuffer]
	ld c, a
	ld e, l
	ld d, h
	call PrintHour
	inc hl
	ld de, .oclock_text
	call PlaceText
	pop hl
	ret

.oclock_text
	text "o'clock"
	done

SetMinutes:
	ld a, [hJoyPressed]
	and A_BUTTON
	jr nz, .a_button
	ld hl, hJoyLast
	ld a, [hl]
	and D_UP
	jr nz, .d_up
	ld a, [hl]
	and D_DOWN
	jr nz, .d_down
	call DelayFrame
	and a
	ret

.d_down
	ld hl, wInitMinuteBuffer
	ld a, [hl]
	and a
	jr nz, .decrease
	ld a, 59 + 1
.decrease
	dec a
	ld [hl], a
	jr .finish_dpad

.d_up
	ld hl, wInitMinuteBuffer
	ld a, [hl]
	cp 59
	jr c, .increase
	ld a, -1
.increase
	inc a
	ld [hl], a
.finish_dpad
	hlcoord 12, 9
	ld a, " "
	ld bc, 7
	call ByteFill
	hlcoord 12, 9
	call DisplayMinutesWithMinString
	call ApplyTilemapInVBlank
	and a
	ret
.a_button
	scf
	ret

DisplayMinutesWithMinString:
	ld de, wInitMinuteBuffer
	call PrintTwoDigitNumberRightAlign
	inc hl
	ld de, .min_text
	jp PlaceText

.min_text
	text "min."
	done

PrintTwoDigitNumberRightAlign:
	push hl
	ld a, " "
	ld [hli], a
	ld [hl], a
	pop hl
	lb bc, PRINTNUM_RIGHTALIGN | 1, 2
	jp PrintNum

Text_WokeUpOak:
	; Zzz… Hm? Wha…? You woke me up! Will you check the clock for me?
	text_jump UnknownText_0x1bc29c

Text_WhatTimeIsIt:
	; What time is it?
	text_jump UnknownText_0x1bc2eb

Text_WhatHrs:
	; What?@ @
	text_far UnknownText_0x1bc2fd
	start_asm
	hlcoord 1, 16
	call DisplayHourOClock
	ld hl, .QuestionMark
	ret

.QuestionMark
	; ?
	text_jump UnknownText_0x1bc305

Text_HowManyMinutes:
	; How many minutes?
	text_jump UnknownText_0x1bc308

Text_WhoaMins:
	; Whoa!@ @
	text_far UnknownText_0x1bc31b
	start_asm
	hlcoord 10, 14
	call DisplayMinutesWithMinString
	ld hl, .QuestionMark
	ret

.QuestionMark
	; ?
	text_jump UnknownText_0x1bc323

OakText_ResponseToSetTime:
	start_asm
	decoord 1, 14
	ld a, [wInitHourBuffer]
	ld c, a
	call PrintHour
	ld [hl], ":"
	inc hl
	ld de, wInitMinuteBuffer
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	call PrintNum
	ld b, h
	ld c, l
	ld hl, .settime
	ret

.settime
	text_jump ClockSetMorningText

GFX_908fb:
INCBIN "gfx/unknown/0908fb.2bpp"
GFX_90903:
INCBIN "gfx/unknown/090903.2bpp"
GFX_9090b:
INCBIN "gfx/unknown/09090b.2bpp"

PrintHour:
	ld l, e
	ld h, d
	push bc
	call .GetTimeOfDayString
	call PlaceString
	ld l, c
	ld h, b
	inc hl
	pop bc
	call .AdjustHourForAMorPM
	ld [wd265], a
	ld de, wd265
	jp PrintTwoDigitNumberRightAlign

.GetTimeOfDayString:
	ld a, c
	cp 4
	jr c, .nite
	cp 10
	jr c, .morn
	cp 18
	jr c, .day
.nite
	ld de, .NITE
	ret
.morn
	ld de, .MORN
	ret
.day
	ld de, .DAY
	ret

.NITE: db "Nite@"
.MORN: db "Morn@"
.DAY: db "Day@"

.AdjustHourForAMorPM:
; Convert the hour stored in c (0-23) to a 1-12 value
	ld a, c
	or a
	jr z, .midnight
	cp 12
	ret c
	ret z
	sub 12
	ret

.midnight
	ld a, 12
	ret
