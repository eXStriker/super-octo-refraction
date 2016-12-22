SetSeenAndCaughtMon::
	push af
	ld b, SET_FLAG
	call PokedexCaughtFlagAction
	pop af
	; fallthrough

SetSeenMon::
	ld b, SET_FLAG
PokedexSeenFlagAction:
	ld hl, PokedexSeen
PokedexFlagAction:
	ld c, a
	predef_jump FlagAction

CheckCaughtMon::
	ld b, CHECK_FLAG
PokedexCaughtFlagAction:
	ld hl, PokedexCaught
	jr PokedexFlagAction

CheckSeenMon::
	ld b, CHECK_FLAG
	jr PokedexSeenFlagAction
