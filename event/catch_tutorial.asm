CatchTutorial::
; Back up your name to your Mom's name.
	ld hl, PlayerName
	ld de, MomsName
	ld bc, NAME_LENGTH
	rst CopyBytes
; Copy Dude's name to your name
	ld hl, .Dude
	ld de, PlayerName
	ld bc, NAME_LENGTH
	rst CopyBytes

	call .LoadDudeData

	xor a
	ld [hJoyDown], a
	ld [hJoyPressed], a
	ld a, [wOptions]
	push af
	and $f8
	add $3
	ld [wOptions], a
	ld hl, .AutoInput
	ld a, BANK(.AutoInput)
	call StartAutoInput
	callba StartBattle
	call StopAutoInput
	pop af

	ld [wOptions], a
	ld hl, MomsName
	ld de, PlayerName
	ld bc, NAME_LENGTH
	rst CopyBytes
	ret

.LoadDudeData
	ld hl, wDudeNumItems
	ld [hl], 1
	inc hl
	ld [hl], POTION
	inc hl
	ld [hl], 1
	inc hl
	ld [hl], -1
	ld hl, wDudeNumKeyItems
	ld [hl], 0
	inc hl
	ld [hl], -1
	ld hl, wDudeNumBalls
	ld a, 1
	ld [hli], a
	ld a, POKE_BALL ; 5
	ld [hli], a
	ld [hli], a
	ld [hl], -1
	ret

.Dude
	db "Dude@"

.AutoInput
	db NO_INPUT, $ff ; end
