ResetGameTime::
	xor a
	ld [GameTimeCap], a
	ld [GameTimeHours], a
	ld [GameTimeHours + 1], a
	ld [GameTimeMinutes], a
	ld [GameTimeSeconds], a
	ld [GameTimeFrames], a
	ret

GameTimer:
	ld c, (wTextDelayFrames - wGenericDelay) + 1
	ld hl, wGenericDelay
.delayCountersLoop
; handle delay counters
	ld a, [hl]
	and a
	jr z, .noDelay
	dec [hl]
.noDelay
	inc hl
	dec c
	jr nz, .delayCountersLoop
	ld a, [rSVBK]
	push af
	call UpdateGameTimer
	call UpdateStopwatches
	pop af
	ld [rSVBK], a
	ret

UpdateGameTimer::
; Increment the game timer by one frame.
; The game timer is capped at 9999:59:59.00.


; Don't update if game logic is paused.
	ld a, [wGameLogicPause]
	and a
	ret nz

; Is the timer paused?
	ld hl, GameTimerPause
	bit 0, [hl]
	ret z

	ld a, BANK(GameTimeCap)
	ld [rSVBK], a

; Is the timer already capped?
	ld hl, GameTimeCap
	bit 0, [hl]
	ret nz
	ld a, 60
	ld b, a

; +1 frame
	ld hl, GameTimeFrames
	inc [hl]
	sub [hl]
	ret nz
	ld [hld], a
; +1 second
	ld a, b
	inc [hl]
	sub [hl]
	ret nz
	ld [hld], a
; +1 minute
	ld a, b
	inc [hl]
	sub [hl]
	ret nz
	ld [hld], a
; +1 hour
	ld a, [hld]
	ld d, [hl]
	ld e, a
	inc de
; Cap the timer after 10000 hours.
	ld a, d
	cp 10000 >> 8
	jr c, .ok

	ld a, e
	cp 10000 & $ff
	jr nc, .maxIGT
.ok
	ld a, d
	ld [hli], a
	ld [hl], e
	ret

.maxIGT
	ld hl, GameTimeCap
	set 0, [hl]

	ld a, b ; 9999:59:59.00
	ld [GameTimeMinutes], a
	ld [GameTimeSeconds], a
	ret
