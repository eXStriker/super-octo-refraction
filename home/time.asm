; Functions relating to the timer interrupt and the real-time-clock.

LatchClock::
; latch clock counter data
	ld a, 0
	ld [MBC3LatchClock], a
	ld a, 1
	ld [MBC3LatchClock], a
	ret

UpdateTime::
	CheckEngine ENGINE_TIME_ENABLED
	ret z
ForceUpdateTime::
	call GetClock
	call FixDays
	call FixTime
	jpba GetTimeOfDay

GetClock::
; store clock data in hRTCDayHi-hRTCSeconds

; enable clock r/w
	ld a, SRAM_ENABLE
	ld [MBC3SRamEnable], a

; clock data is 'backwards' in hram

	call LatchClock
	ld hl, MBC3SRamBank
	ld de, MBC3RTC

	ld [hl], RTC_S
	ld a, [de]
	and $3f
	ld [hRTCSeconds], a

	ld [hl], RTC_M
	ld a, [de]
	and $3f
	ld [hRTCMinutes], a

	ld [hl], RTC_H
	ld a, [de]
	and $1f
	ld [hRTCHours], a

	ld [hl], RTC_DL
	ld a, [de]
	ld [hRTCDayLo], a

	ld [hl], RTC_DH
	ld a, [de]
	ld [hRTCDayHi], a

; unlatch clock / disable clock r/w
	jp CloseSRAM

FixDays::
	ld a, SRAM_ENABLE
	ld [MBC3SRamEnable], a

	call LatchClock
	ld hl, MBC3SRamBank
	ld de, MBC3RTC

	ld [hl], RTC_DL
	xor a
	ld [de], a

	ld [hl], RTC_DH
	ld a, [de]
	and $c0 ; keep overflow flag and running flag for something else
	ld [de], a

	jp CloseSRAM

FixTime::
; add ingame time (set at newgame) to current time
;                   yr       mo       day     hr       min       sec
; store time in CurYear, CurMonth, CurDay, hHours, hMinutes, hSeconds

	ld a, [hRTCDayHi] ; DH
	bit 7, a
	ret nz ; don't update if rtc overflowed

; second
	ld a, [hRTCSeconds] ; S
	ld c, a
	ld a, [StartSecond]
	add c
	sub 60
	jr nc, .updatesec
	add 60
.updatesec
	ld [hSeconds], a

; minute
	ccf ; rotate carry
	ld a, [hRTCMinutes] ; M
	ld c, a
	ld a, [StartMinute]
	adc c
	sub 60
	jr nc, .updatemin
	add 60
.updatemin
	ld [hMinutes], a

; hour
	ccf ; rotate carry
	ld a, [hRTCHours] ; H
	ld c, a
	ld a, [StartHour]
	adc c
	sub 24
	jr nc, .updatehr
	add 24
.updatehr
	ld [hHours], a
	ld a, [StartDay]
	ld bc, 0
	jr nc, .hroverflow
	and a
	jr z, .skiphr
	xor a
	ld [StartDay], a
	dec bc
	jr .skiphr
.hroverflow
	and a
	jr nz, .skiphr
	ld a, 1
	ld [StartDay], a
	inc bc

.skiphr
; day
	ld a, [hRTCDayHi] ; DH
	and 1
	ld e, a
	ld a, [hRTCDayLo] ; DL
	add c
	ld c, a
	ld a, e
	adc b
	ld b, a
	ld a, [CurDay]
	add c
	ld c, a
	jr nc, .nocarry
	inc b
.nocarry
	ld a, [CurMonth]
	ld e, a
	ld d, 0
	ld a, [CurYear]
	call IsLeapYear
	ld hl, MaxDatesCommon
	jr nc, .common
	ld hl, MaxDatesLeap
.common
	add hl, de
.monthdecloop
	ld a, b
	and a
	ld a, c
	jr z, .notzero
	sub [hl]
	ld c, a
	jr nc, .nocarry2
	dec b
.nocarry2
	inc hl
	inc e
	ld a, e
	cp 12
	jr c, .monthdecloop
	ld a, [CurYear]
	inc a
	ld [CurYear], a
	call IsLeapYear
	ld hl, MaxDatesCommon
	jr nc, .common2
	ld hl, MaxDatesLeap
.common2
	ld e, 0
	jr .monthdecloop
.notzero
	sub [hl]
	ld c, a
	jr nc, .nocarry
.monthdecdone
	add [hl]
	ld [CurDay], a
	ld a, e
	ld [CurMonth], a
	ret

MaxDatesCommon::
	; jan feb mar apr may jun jul aug sep oct nov dec
	db 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
MaxDatesLeap::
	db 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31

IsLeapYear::
; return carry if year 2000+a is a leap year
; in the Gregorian calendar, 2100 and 2200 are not leap years
	cp 100
	ret z
	cp 200
	ret z
	and 3
	ret nz
	scf
	ret

SetTimeOfDay::
	xor a
	ld [wStringBuffer2], a ; days
	ld [wStringBuffer2 + 3], a ; seconds
	jr InitTime

SetDayOfWeek::
	call UpdateTime
	ld a, [hHours]
	ld [wStringBuffer2 + 1], a ; hours
	ld a, [hMinutes]
	ld [wStringBuffer2 + 2], a ; minutes
	ld a, [hSeconds]
	ld [wStringBuffer2 + 3], a ; seconds

InitTime::
	jpba _InitTime

ClearhRTC:
	xor a
	ld [hRTCSeconds], a
	ld [hRTCMinutes], a
	ld [hRTCHours], a
	ld [hRTCDayLo], a
	ld [hRTCDayHi], a
	ret

PanicResetClock::
	call ClearhRTC

SetClock::
; set clock data from hram

; enable clock r/w
	ld a, SRAM_ENABLE
	ld [MBC3SRamEnable], a

; set clock data
; stored 'backwards' in hram

	call LatchClock
	ld hl, MBC3SRamBank
	ld de, MBC3RTC

; seconds
	ld [hl], RTC_S
	ld a, [hRTCSeconds]
	ld [de], a
; minutes
	ld [hl], RTC_M
	ld a, [hRTCMinutes]
	ld [de], a
; hours
	ld [hl], RTC_H
	ld a, [hRTCHours]
	ld [de], a
; day lo
	ld [hl], RTC_DL
	ld a, [hRTCDayLo]
	ld [de], a
; day hi
	ld [hl], RTC_DH
	ld a, [hRTCDayHi]
	res 6, a ; make sure timer is active
	ld [de], a

; cleanup
	jp CloseSRAM ; unlatch clock, disable clock r/w

ClearRTCStatus::
; clear sRTCStatusFlags
	xor a
	push af
	ld a, BANK(sRTCStatusFlags)
	call GetSRAMBank
	pop af
	ld [sRTCStatusFlags], a
	jp CloseSRAM

RecordRTCStatus::
; append flags to sRTCStatusFlags
	ld hl, sRTCStatusFlags
	push af
	ld a, BANK(sRTCStatusFlags)
	call GetSRAMBank
	pop af
	or [hl]
	ld [hl], a
	jp CloseSRAM

CheckRTCStatus::
; check sRTCStatusFlags
	ld a, BANK(sRTCStatusFlags)
	call GetSRAMBank
	ld a, [sRTCStatusFlags]
	jp CloseSRAM
