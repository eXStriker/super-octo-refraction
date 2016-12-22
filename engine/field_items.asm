FishFunction: ; cf8e
	ld a, e
	push af
	call ClearFieldMoveBuffer
	pop af
	ld [wRodType], a
.loop
	ld hl, .FishTable
	call FieldMoveJumptable
	jr nc, .loop
	and $7f
	ld [wFieldMoveSucceeded], a
	ret

.FishTable: ; cfa5
	dw .TryFish
	dw .FishNoBite
	dw .FishGotSomething
	dw .FailFish
	dw .FishNoFish

.TryFish: ; cfaf
	ld a, [PlayerState]
	cp PLAYER_SURF
	jr z, .fail
	cp PLAYER_SURF_PIKA
	jr z, .fail
	call GetFacingTileCoord
	call GetTileCollision
	cp $1
	jr z, .facingwater
.fail
	ld a, $3
	ret

.facingwater
	call GetFishingGroup
	and a
	jr nz, .goodtofish
	ld a, $4
	ret

.goodtofish
	ld d, a
	ld a, [wRodType]
	ld e, a
	callba Fish
	ld a, d
	and a
	jr z, .nonibble
	ld [TempWildMonSpecies], a
	ld a, e
	ld [CurPartyLevel], a
	ld a, BATTLETYPE_FISH
	ld [wBattleType], a
	ld a, $2
	ret

.nonibble
	ld a, $1
	ret

.FailFish: ; cff1
	ld a, $80
	ret

.FishGotSomething: ; cff4
	ld a, $1
	ld [wFishResponse], a
	ld hl, Script_GotABite
	call QueueScript
	ld a, $81
	ret

.FishNoBite: ; d002
	ld a, $2
	jr .not_even_a_nibble

.FishNoFish: ; d010
	ld a, $0
.not_even_a_nibble
	ld [wFishResponse], a
	ld hl, Script_NotEvenANibble
	call QueueScript
	ld a, $81
	ret

Script_NotEvenANibble: ; 0xd01e
	scall Script_FishCastRod
	writetext UnknownText_0xd0a9
	loademote EMOTE_SHADOW
	callasm PutTheRodAway
	closetext
	end

Script_GotABite: ; 0xd035
	scall Script_FishCastRod
	callasm Fishing_CheckFacingUp
	iffalse .NotFacingUp
	applymovement PLAYER, .Movement_FacingUp
	jump .FightTheHookedPokemon

.NotFacingUp: ; 0xd046
	applymovement PLAYER, .Movement_NotFacingUp

.FightTheHookedPokemon: ; 0xd04a
	pause 40
	applymovement PLAYER, .Movement_RestoreRod
	writetext UnknownText_0xd0a4
	callasm PutTheRodAway
	closetext
	randomwildmon
	startbattle
	reloadmapafterbattle
	end

.Movement_NotFacingUp: ; d05c
	fish_got_bite
	fish_got_bite
	fish_got_bite
	fish_got_bite
	show_emote
	step_end

.Movement_FacingUp: ; d062
	fish_got_bite
	fish_got_bite
	fish_got_bite
	fish_got_bite
	step_sleep_1
	show_emote
	step_end

.Movement_RestoreRod: ; d069
	hide_emote
	step_end

Fishing_CheckFacingUp: ; d06c
	ld a, [PlayerDirection]
	and $c
	cp OW_UP
	ld a, $1
	jr z, .up
	xor a

.up
	ld [hScriptVar], a
	ret

Script_FishCastRod: ; 0xd07c
	reloadmappart
	loadvar hBGMapMode, $0
	special UpdateTimePals
	callasm LoadFishingGFX
	loademote EMOTE_SHOCK
	applymovement PLAYER, .Movement
	end

.Movement
	fish_cast_rod
	step_end

PutTheRodAway: ; d095
	xor a
	ld [hBGMapMode], a
	ld a, PERSON_ACTION_STAND
	ld [PlayerAction], a
	ld hl, ScriptFlags2
	res 0, [hl]
	call UpdateSprites
	jp ReplaceKrisSprite

UnknownText_0xd0a4: ; 0xd0a4
	; Oh! A bite!
	text_jump UnknownText_0x1c0958

UnknownText_0xd0a9: ; 0xd0a9
	; Not even a nibble!
	text_jump UnknownText_0x1c0965

BikeFunction: ; d0b3
	call .TryBike
	and $7f
	ld [wFieldMoveSucceeded], a
	ret

.TryBike: ; d0bc
	ld a, [wTileset]
	cp TILESET_SIDESCROLL
	jr z, .CannotUseBike
	call .CheckEnvironment
	jr c, .CannotUseBike
	ld a, [PlayerState]
	and a ; PLAYER_NORMAL
	jr z, .GetOnBike
	cp PLAYER_BIKE
	jr nz, .CannotUseBike

.GetOffBike
	ld hl, wBikeFlags
	bit 1, [hl]
	jr nz, .CantGetOffBike
	ld hl, Script_GetOffBike
	ld de, Script_GetOffBike_Register
	call .CheckIfRegistered
	ld a, BANK(Script_GetOffBike)
	jr .done

.GetOnBike
	ld hl, Script_GetOnBike
	ld de, Script_GetOnBike_Register
	call .CheckIfRegistered
	call QueueScript
	xor a
	ld [MusicFade], a
	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame
	call MaxVolume
	ld de, MUSIC_BICYCLE
	ld a, e
	ld [wMapMusic], a
	call PlayMusic
	ld a, $1
	ret

.CannotUseBike
	ld a, $0
	ret

.CantGetOffBike
	ld hl, Script_CantGetOffBike
.done
	call QueueScript
	ld a, $1
	ret

.CheckIfRegistered: ; d119
	ld a, [wUsingItemWithSelect]
	and a
	ret z
	ld h, d
	ld l, e
	ret

.CheckEnvironment: ; d121
	call GetMapPermission
	call CheckOutdoorMap
	jr z, .ok
	cp CAVE
	jr z, .ok
	cp GATE
	jr z, .ok
	jr .nope

.ok
	call GetPlayerStandingTile
	and $f ; can't use our bike in a wall or on water
	jr nz, .nope
	xor a
	ret

.nope
	scf
	ret

Script_GetOnBike: ; 0xd13e
	reloadmappart
	special UpdateTimePals
	writecode VAR_MOVEMENT, PLAYER_BIKE
	writetext GotOnTheBikeText
	waitbutton
	closetext
	special ReplaceKrisSprite
	end

Script_GetOnBike_Register: ; 0xd14e
	writecode VAR_MOVEMENT, PLAYER_BIKE
	closetext
	special ReplaceKrisSprite
	end

Script_GetOffBike: ; 0xd158
	reloadmappart
	special UpdateTimePals
	writecode VAR_MOVEMENT, PLAYER_NORMAL
	writetext GotOffTheBikeText
	waitbutton

FinishGettingOffBike:
	closetext
	special ReplaceKrisSprite
	playmapmusic
	end

Script_GetOffBike_Register: ; 0xd16b
	writecode VAR_MOVEMENT, PLAYER_NORMAL
	jump FinishGettingOffBike

Script_CantGetOffBike: ; 0xd171
	writetext .CantGetOffBikeText
	endtext

.CantGetOffBikeText: ; 0xd177
	; You can't get off here!
	text_jump UnknownText_0x1c099a

GotOnTheBikeText: ; 0xd17c
	; got on the @ .
	text_jump UnknownText_0x1c09b2

GotOffTheBikeText: ; 0xd181
	; got off the @ .
	text_jump UnknownText_0x1c09c7
