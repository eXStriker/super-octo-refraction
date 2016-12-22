RIJON_LATITUDE EQU 33.2 ; don't set this too high
EARTH_AXIAL_TILT EQU 23.43712

StartRTC:
	ld a, SRAM_ENABLE
	ld [MBC3SRamEnable], a
	call LatchClock
	ld a, RTC_DH
	ld [MBC3SRamBank], a
	ld a, [MBC3RTC]
	res 6, a ; halt
	ld [MBC3RTC], a
	jp CloseSRAM

GetNthDayOfYear:
	ld a, [CurYear]
	call IsLeapYear
	ld de, MaxDatesCommon
	jr nc, .common
	ld de, MaxDatesLeap
.common
	ld hl, 0
	ld b, l
.loop
	ld a, [CurMonth]
	cp b
	jr z, .done
	push bc
	ld a, [de]
	ld c, a
	ld b, 0
	add hl, bc
	pop bc
	inc b
	inc de
	jr .loop
.done
	ld b, 0
	ld a, [CurDay]
	ld c, a
	add hl, bc
	ret

GetTimeOfDay::
	call GetNthDayOfYear
	inc hl
	ld c, l
	ld b, h
	ld hl, wSunriseOffsetDate
	ld a, [hli]
	cp c
	jr nz, .calcsunrise
	ld a, [hl]
	cp b
	jp z, .skipsunrisecalc
	; recalculate sunrise time again if the saved date is different
.calcsunrise
	; -tan(lat)*tan(arcsin(sin(-eat)*cos(n+10/365)))
	ld a, b
	ld [hld], a
	ld [hl], c
	ld l, c
	ld h, b
	ld bc, 9 ; offset this from winter solstice (Dec 21) instead
	add hl, bc
	xor a
	ld [hDividend], a
	ld [hDividend + 3], a
	ld a, h
	ld [hDividend + 1], a
	ld a, l
	ld [hDividend + 2], a
	ld a, 365 / $100
	ld [hDivisor], a
	ld a, [CurYear]
	call IsLeapYear
	ld a, 365 % $100
	jr nc, .common
	ld a, 366 % $100
.common
	ld [hDivisor + 1], a
	predef DivideLong
	ld a, [hLongQuotient + 3]
	add $40 ; cos
	call GetDemoSine
	cp $80
	push af ; store sign
	jr c, .plus1
	cpl
.plus1
	add a
	ld c, a
	ld b, 0
	ld de, SIN(DIV(EARTH_AXIAL_TILT, 360.0) << 16)
	call Multiply16
	; tan(arcsin(x)) = x/√(1-x^2)
	ld a, c
	ld [hDividend], a
	ld a, b ; should be 0
	ld [hDividend + 1], a
	ld hl, 0
	rst AddNTimes
	xor a
	sub l
	ld e, a
	xor a
	sbc h
	ld d, a
	callba GetSquareRoot
	ld a, b
	ld [hDivisor], a
	ld b, 2
	predef Divide
	ld a, [hQuotient]
	ld b, a
	ld a, [hQuotient + 1]
	ld c, a
	ld de, TAN(DIV(RIJON_LATITUDE, 360.0) << 16)
	call Multiply16
	srl b
	rr c
	ld a, b
	and a
	jr nz, .max
	pop af
	ld a, c
	jr c, .plus2
	xor a
	sub c
.plus2
	ld [wSunriseOffset], a
	jr .skipsunrisecalc
.max
	pop af
	ld a, $7f
	jr c, .plus3
	inc a
.plus3
	ld [wSunriseOffset], a
.skipsunrisecalc
	ld a, [hHours]
	ld b, a
; remove this if you want to purge DST
	ld a, [wDST]
	and a
	ld a, b
	jr z, .skipdst
	dec a
	cp $ff
	jr nz, .skipdst
	add 24
.skipdst
	push af
	ld hl, 0
	ld bc, 60
	rst AddNTimes
	ld a, [hMinutes]
	ld c, a
	add hl, bc
	ld d, b
	rept 3
	srl h
	rr l
	rr d
	endr
	ld a, h
	ld [hDividend], a
	ld a, l
	ld [hDividend + 1], a
	ld a, d
	ld [hDividend + 2], a
	ld a, 1440 / 8
	ld [hDivisor], a
	ld b, 3
	predef Divide
	ld a, [hQuotient + 2]
	sub $40
	call GetDemoSine
	ld b, a
	pop af
	cp 12
	jr nc, .pm
	ld a, [wSunriseOffset]
	sub 11
	call .compare
	jr c, .nite
	ld a, [wSunriseOffset]
	add 44
	call .compare
	jr c, .morn
	jr .day
.pm
	ld a, [wSunriseOffset]
	call .compare
	jr c, .nite
.day
	ld a, DAY
	ld [TimeOfDay], a
	ret
.morn
	ld a, MORN
	ld [TimeOfDay], a
	ret
.nite
	ld a, NITE
	ld [TimeOfDay], a
	ret

.compare
	ld c, a
	cp $80
	jr nc, .minus
	ld a, b
	cp $80
	jr nc, .cc
	cp c
	ret
.minus
	ld a, b
	cp $80
	jr c, .cc
	cp c
	ret
.cc
	ccf
	ret

StageRTCTimeForSave:
	call UpdateTime
	ld hl, wRTC
	ld a, [StartDay]
	ld [hli], a
	ld a, [hHours]
	ld [hli], a
	ld a, [hMinutes]
	ld [hli], a
	ld a, [hSeconds]
	ld [hli], a
	ret

SaveRTC:
	ld a, $a
	ld [MBC3SRamEnable], a
	call LatchClock
	ld hl, MBC3RTC
	ld a, $c
	ld [MBC3SRamBank], a
	res 7, [hl]
	ld a, BANK(sRTCStatusFlags)
	ld [MBC3SRamBank], a
	xor a
	ld [sRTCStatusFlags], a
	jp CloseSRAM

StartClock::
	call GetClock
	call Function1409b
	jr nc, .skip_set
	; bit 5: Day count exceeds 139
	; bit 6: Day count exceeds 255
	call RecordRTCStatus ; set flag on sRTCStatusFlags

.skip_set
	jp StartRTC

Function1409b:
	ld hl, hRTCDayHi
	bit 7, [hl]
	jr nz, .set_bit_7
	bit 6, [hl]
	jr nz, .set_bit_7
	xor a
	ret

.set_bit_7
	; Day count exceeds 16383
	ld a, %10000000
	jp RecordRTCStatus ; set bit 7 on sRTCStatusFlags

Function140ae:
	call CheckRTCStatus
	ld c, a
	and %11000000 ; Day count exceeded 255 or 16383
	jr nz, .time_overflow

	ld a, c
	and %00100000 ; Day count exceeded 139
	jr z, .dont_update

	call UpdateTime
	ld a, [wRTC + 0]
	ld b, a
	ld a, [StartDay]
	cp b
	jr c, .dont_update

.time_overflow
	callba ClearDailyTimers
	jp CloseSRAM

.dont_update
	xor a
	ret

_InitTime::
	call GetClock
	call FixDays
	ld hl, hRTCSeconds
	ld de, StartSecond

	ld a, [wStringBuffer2 + 3]
	sub [hl]
	dec hl
	jr nc, .okay_secs
	add 60
.okay_secs
	ld [de], a
	dec de

	ld a, [wStringBuffer2 + 2]
	sbc [hl]
	dec hl
	jr nc, .okay_mins
	add 60
.okay_mins
	ld [de], a
	dec de

	ld a, [wStringBuffer2 + 1]
	sbc [hl]
	dec hl
	jr nc, .okay_hrs
	add 24
.okay_hrs
	ld [de], a
	dec de

	jr nc, .skipdaypad
	ld a, [wStringBuffer2]
	and a
	jr z, .padmonth
	dec a
	ld [wStringBuffer2], a
	jr .skipdaypad
.padmonth
	ld a, [wStringBuffer2 + 4]
	and a
	jr nz, .skipyearpad
	ld a, [wStringBuffer2 + 5]
	dec a
	ld [wStringBuffer2 + 5], a
	ld a, 12
.skipyearpad
	dec a
	push de
	ld e, a
	ld d, 0
	ld a, [wStringBuffer2 + 5]
	call IsLeapYear
	ld hl, MaxDatesCommon
	jr nc, .common
	ld hl, MaxDatesLeap
.common
	add hl, de
	ld a, [hl]
	pop de
	ld [wStringBuffer2], a
.skipdaypad
	ld a, [wStringBuffer2]
	ld [StartDay], a
	ld a, [wStringBuffer2 + 4]
	ld [CurMonth], a
	ld a, [wStringBuffer2 + 5]
	ld [CurYear], a
	xor a
	ld [hRTCDayLo], a
	ld [hRTCDayHi], a
	ret
