PlaceWaitingText::
	hlcoord 3, 10
	lb bc, 1, 11

	ld a, [wBattleMode]
	and a
	jr z, .notinbattle

	call TextBox
	jr .proceed

.notinbattle
	predef Predef_LinkTextbox

.proceed
	hlcoord 4, 11
	ld de, .Waiting
	call PlaceText
	ld c, 50
	jp DelayFrames

.Waiting
	ctxt "Waiting...!"
	done
