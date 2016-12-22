TimeMachine:
	callba CalcTimeElapsedSinceTimeMachine
	jr nz, .continue
	ld hl, .NotEnoughTimePassed
	jp PrintText

.NotEnoughTimePassed:
	ctxt "The Time Machine"
	line "needs to recharge!"
	done

.continue
	ld hl, .BootedUpTheTimeMachine
	call PrintText
	ld de, SFX_BOOT_PC
	call PlayWaitSFX
	call ButtonSound
	; bring up clock interface
	; bail if player cancels
	jpba RestartTimeMachineTimer

.BootedUpTheTimeMachine:
	ctxt "<PLAYER> booted up"
	line "the Time Machine!"
	done
