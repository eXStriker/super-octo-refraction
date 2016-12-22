SweetScentFromMenu:
	ld hl, UnknownScript_0x506c8
	call QueueScript
	ld a, $1
	ld [wFieldMoveSucceeded], a
	ret

UnknownScript_0x506c8:
	reloadmappart
	special UpdateTimePals
	callasm GetPartyNick
	writetext UnknownText_0x50726
	waitbutton
	closetext

	farscall FieldMovePokepicScript

	callasm SweetScentEncounter
	sif false
		jumptext UnknownText_0x5072b
	randomwildmon
	startbattle
	reloadmapafterbattle
	end

SweetScentEncounter:
	callba CanUseSweetScent
	jr nc, .no_battle
	callba GetMapEncounterRate
	ld a, b
	and a
	jr z, .no_battle
	callba ChooseWildEncounter
	jr nz, .no_battle
	jr .start_battle

.start_battle
	ld a, $1
	jr .load_var

.no_battle
	xor a
	ld [wBattleType], a
.load_var
	ld [hScriptVar], a
	ret

UnknownText_0x50726:
	; used SWEET SCENT!
	text_jump UnknownText_0x1c0b03

UnknownText_0x5072b:
	; Looks like there's nothing here…
	text_jump UnknownText_0x1c0b1a
