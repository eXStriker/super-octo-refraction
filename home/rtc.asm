RTC::
; update time and time-sensitive palettes

; RTC enabled?
	ld a, [wSpriteUpdatesEnabled]
	and a
	ret z

	call UpdateTime

; obj update on?
	ld a, [VramState]
	bit 0, a ; obj update
	ret z

TimeOfDayPals:: ; 47e
	jpba _TimeOfDayPals
