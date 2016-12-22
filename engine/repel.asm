RepelWoreOffScript::
	opentext
	writetext .RepelsEffectWoreOffText
	sif false
		endtext
	yesorno
	sif true
		callasm DoItemEffect
	closetext
	end

.RepelsEffectWoreOffText
	; REPEL's effect wore off.
	text_far UnknownText_0x1bd308
	start_asm
	xor a
	ld [hScriptVar], a
	ld [wWhichIndexSet], a
	CheckEngine ENGINE_POKEMON_MODE
	jr nz, .nope
	ld a, [wLastRepelUsed]
	and a
	jr z, .nope
	ld [wCurItem], a
	ld hl, NumItems
	call CheckItem
	jr nc, .nope
	ld a, 1
	ld [hScriptVar], a
	ld hl, .UseAnotherText
	ret

.nope
	ld hl, .Terminator
	ret

.UseAnotherText:
	text_far UseAnotherRepelText
.Terminator
	db "@"
