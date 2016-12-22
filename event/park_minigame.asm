StartParkMinigameScript::
	; in: [hScriptVar]: selected minigame option
	; out: [hScriptVar]: 1 if the game started, 0 if the player had no funds
	scriptstartasm
	ld a, [hScriptVar]
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, ParkMinigameGames
	add hl, de
	ld a, [hli]
	push hl
	call CheckParkMinigameMoney
	pop de
	ld hl, .no_money
	ret c
	ld a, [de]
	push de
	call InitializeParkMinigame
	pop hl
	inc hl
	inc hl
	ld a, [hld]
	cp -1
	jr nz, .not_time_of_day_based
	push hl
	callba GetTimeOfDay
	pop hl
	ld a, [TimeOfDay]
.not_time_of_day_based
	ld [wParkMinigameGameType], a
	ld a, [hl]
	ld [hScriptVar], a
	scriptstopasm
	waitsfx ;wait for the text's "click" sound to end
	special PlaceMoneyTopRight
	playwaitsfx SFX_TRANSACTION
	pushvar
	callasm BackupPlayerPokeballs
	writetext .keep_pokeballs_text
	waitbutton
	sif true, then
		sif <, 7, then
			scall .one_mon_holding_ball
		selse
			writetext .mons_holding_balls_text
		sendif
		waitbutton
	sendif
	popvar
	writetext .park_balls_given_text
	waitbutton
	callasm GiveInitialParkBalls
	sif true, then
		writetext .stocked_balls_given_text
		waitbutton
	sendif
	writetext .good_luck_text
	waitbutton
	waitsfx ;again, wait for the text's sound
	warpsound
	waitsfx
	warp PROVINCIAL_PARK_CONTEST, 19, 9
	spriteface PLAYER, DOWN
	writebyte 1
	callasm StartParkGameTimer
	end

.keep_pokeballs_text
	ctxt "I'll have to keep"
	line "your # balls"
	cont "while you are in"
	cont "the park."
	done
.mons_holding_balls_text
	ctxt "I'll hold onto the"
	line "ones that your"
	cont "#mon are"
	cont "holding, too."
	done
.one_mon_holding_ball
	scriptstartasm
	ld hl, wPartyMonNicknames - PKMN_NAME_LENGTH
	ld bc, PKMN_NAME_LENGTH
	ld a, [hScriptVar]
	rst AddNTimes
	ld d, h
	ld e, l
	call CopyName1
	scriptstopasm
	writetext .one_mon_holding_ball_text
	end
.one_mon_holding_ball_text
	ctxt "I'll hold onto the"
	line "one that your"
	cont "<STRBF2> is"
	cont "holding, too."
	done

.park_balls_given_text
	ctxt "Here you go,"
	line "@"
	deciram hScriptVar, 1, 3
	ctxt " Park Balls."
	done
.stocked_balls_given_text
	ctxt "And here are the"
	line "balls from your"
	cont "previous visits."
	done

.good_luck_text
	ctxt "Good luck. Now"
	line "please exit and"
	cont "catch #mon."
	done

.no_money
	writebyte 0
	end

CheckParkMinigameMoney:
	; in: a: cost of the park minigame (x100)
	; out: carry if the player can't afford it, no carry (and money taken away) if the player can
	ld e, a
	ld d, 0
	ld bc, 100
	call Multiply16
	xor a
	ld hl, hMoneyTemp
	ld [hli], a
	ld a, d
	ld [hli], a
	ld [hl], e
	ld de, Money
	ld bc, hMoneyTemp
	callba CompareMoney
	ret c
	callba TakeMoney
	and a
	ret

InitializeParkMinigame:
	; in: a: duration of the minigame
	push af
	SetEngine ENGINE_PARK_MINIGAME
	pop af
	ld [wParkMinigameTotalTime], a
	push af
	lb bc, STOPWATCH_RESET, STOPWATCH_PARK_MINIGAME
	callba ReadStopwatch
	call CalculateRemainingParkMinigameTime
	xor a
	ld [wParkMinigameRemainingTime], a
	ld hl, wParkMinigameSpot1
	ld bc, wParkMinigameSpotsEnd - wParkMinigameSpot1
	call ByteFill
	ld hl, wParkMinigameSpot1Cooldown
	ld bc, wParkMinigameSpot2 - wParkMinigameSpot1
	ld d, PARK_MINIGAME_SPOT_COUNT
	pop af
.reset_cooldown_loop
	ld [hl], a
	add hl, bc
	dec d
	jr nz, .reset_cooldown_loop
	ld hl, wParkMinigameSavedHeldItems
	ld bc, MAX_BALLS * 2 + 8 ; size of wParkMinigameSavedHeldItems and wParkMinigameSavedBalls
	xor a
	jp ByteFill

CalculateRemainingParkMinigameTime:
	lb bc, STOPWATCH_READ_FORMATTED, STOPWATCH_PARK_MINIGAME
	callba ReadStopwatch
	ld a, b
	and a
	jr nz, .exceeded
	ld a, [wParkMinigameTotalTime]
	dec a
	sub c
	jr c, .exceeded
	ld c, a
	ld a, 59
	sub d
	ld d, a
	ld a, 100
	sub e
	ld e, a
	cp 100
	jr nz, .got_value
	ld e, 0
	inc d
	ld a, d
	cp 60
	jr nz, .got_value
	ld d, 0
	inc c
.got_value
	ld hl, wParkMinigameRemainingTime + 1
	ld a, c
	ld [hli], a
	ld a, d
	ld [hli], a
	ld [hl], e
	or e
	or c
	ret
.exceeded
	xor a ; sets zero flag
	ld hl, wParkMinigameRemainingTime + 1
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

BackupPlayerPokeballs:
	; this function will back up the player's balls in the balls pocket, and also the ones being held by the party
	; returns in [hScriptVar]: 0 if no mon was holding a ball, 1-6 if a specific mon was holding one, or something >6 if several mons were
	ld hl, NumBalls
	ld bc, BallsEnd - NumBalls
	ld de, wParkMinigameSavedBalls
	push hl
	rst CopyBytes
	pop hl
	xor a
	ld [hli], a
	ld [hl], $ff
	ld a, [wPartyCount]
	and a
	jr z, .done ;I have no idea of how this could ever happen.
	ld de, 0
	ld hl, PartyMon1Item
	ld bc, PARTYMON_STRUCT_LENGTH
.loop
	inc e
	ld a, [hl]
	and a
	jr z, .continue
	push de
	ld d, a
	call GetItemPocket
	cp BALL
	ld a, d
	pop de
	jr nz, .continue
	ld [hl], 0
	push hl
	push de
	ld hl, wParkMinigameSavedHeldItems - 1
	ld d, 0
	add hl, de
	pop de
	ld [hl], a
	pop hl
	ld a, d
	swap a
	add a, e
	ld d, a
.continue
	add hl, bc
	ld a, [wPartyCount]
	cp e
	jr nz, .loop
	ld a, d
.done
	ld [hScriptVar], a
	ret

GiveInitialParkBalls:
	; gives the player the initial stock of Park Balls (an amount indicated by [hScriptVar]), plus whatever stock of balls they had in store
	; returns in [hScriptVar], 0 if there were no balls in stock or non-zero if there were some
	; no bag overflow checking since the max amount of bag slots this will take up is 15
	ld de, 0
	ld c, e
.loop
	ld hl, ParkMinigameBallsList
	push de
	ld d, 0
	add hl, de
	add hl, de
	add hl, de
	pop de
	ld b, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc b
	jr z, .done
	dec b
	ld a, [hl]
	and a
	jr z, .continue
	ld hl, Balls
	push bc
	ld b, 0
	add hl, bc
	add hl, bc
	pop bc
.inner_loop
	cp 100
	jr c, .not_over_99
	ld [hl], b
	inc hl
	ld [hl], 99
	inc hl
	inc c
	sub 99
	jr .inner_loop
.not_over_99
	ld [hl], b
	inc hl
	ld [hl], a
	inc c
	ld a, e
	and a
	jr z, .continue
	inc d
.continue
	inc e
	jr .loop
.done
	ld a, c
	ld [NumBalls], a
	sla a
	add a, Balls & $ff
	ld l, a
	ld h, Balls >> 8
	jr nc, .no_pointer_carry
	inc h
.no_pointer_carry
	ld [hl], $ff
	ld a, d
	ld [hScriptVar], a
; since the park balls are given without the use of ReceiveItem
	ld hl, wItemsObtained + (PARK_BALL / 8)
	set (PARK_BALL % 8), [hl]
	ret

ParkMinigameBallsList:
	dbw PARK_BALL, hScriptVar
ParkMinigameSpecialBallsList:
	dbw POKE_BALL, wParkMinigamePokeBalls
	dbw GREAT_BALL, wParkMinigameGreatBalls
	dbw ULTRA_BALL, wParkMinigameUltraBalls
	dbw MASTER_BALL, wParkMinigameMasterBalls
	db -1

StoreAndRemoveParkBalls:
	; removes the player's balls (both from inventory and held items) and stores the "special" ones (i.e., non-Park balls) for later visits
	; returns in [hScriptVar]: 0 if no balls were stocked, 1 if some balls were stocked, or 2 if the player just had too many of some kind of ball (>255)
	ld a, [NumBalls]
	ld e, a
	ld d, 0
	ld bc, Balls
.pack_loop
	ld a, [bc]
	cp $ff
	jr z, .pack_done
	inc bc
	push bc
	push de
	ld hl, ParkMinigameSpecialBallsList
	ld e, 3
	call IsInArray
	pop de
	pop bc
	jr nc, .skip_pack_entry
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [bc]
	and a
	jr z, .skip_pack_entry
	add a, [hl]
	jr nc, .pack_entry_did_not_overflow
	ld a, $ff
	set 1, d
.pack_entry_did_not_overflow
	ld [hl], a
	set 0, d
.skip_pack_entry
	inc bc
	dec e
	jr nz, .pack_loop
.pack_done
	ld a, [wPartyCount]
	and a
	jr z, .done ; ...if we somehow have an empty party
	ld e, a
	ld hl, PartyMon1Item
.party_loop
	ld a, [hl]
	and a
	jr z, .skip_party_member
	call GetItemPocket
	cp BALL
	jr nz, .skip_party_member
	ld a, [hl]
	ld [hl], 0
	push hl
	push de
	ld e, 3
	ld hl, ParkMinigameSpecialBallsList
	call IsInArray
	pop de
	jr nc, .done_party_member
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	set 0, d
	inc [hl]
	jr nz, .done_party_member
	set 1, d
	ld [hl], $ff
.done_party_member
	pop hl
.skip_party_member
	ld bc, PARTYMON_STRUCT_LENGTH
	add hl, bc
	dec e
	jr nz, .party_loop
.done
	ld a, d
	cp 2
	jr c, .not_over_2
	ld a, 2
.not_over_2
	ld [hScriptVar], a
	ret

RestorePlayerPokeballs:
	; restores the player's balls that had been backed up at the beginning of the event
	; returns in [hScriptVar]: 0 if only the pack was restored, 1 if some previously held balls were restored, or 2 if the player had no room for some of those
	ld hl, wParkMinigameSavedBalls
	ld de, NumBalls
	ld bc, MAX_BALLS * 2 + 2
	rst CopyBytes
	lb de, 0, 6
	ld hl, wParkMinigameSavedHeldItems
.loop
	ld a, [hli]
	and a
	jr z, .continue
	ld [wCurItem], a
	ld a, 1
	ld [wItemQuantityChangeBuffer], a
	set 0, d
	push hl
	ld hl, NumItems
	call ReceiveItem
	pop hl
	jr c, .continue
	set 1, d
.continue
	dec e
	jr nz, .loop
	ld a, d
	cp 2
	jr c, .not_over_2
	ld a, 2
.not_over_2
	ld [hScriptVar], a
	ret

StartParkGameTimer:
	ld hl, wTimeEventCallback
	ld a, ParkGameOverworldLoop >> 8
	ld [hli], a
	ld a, ParkGameOverworldLoop & $ff
	ld [hli], a
	ld [hl], BANK(ParkGameOverworldLoop)
	ld hl, wStopwatchControl
	set STOPWATCH_PARK_MINIGAME, [hl]
	ret

ParkGameOverworldLoop:
	; if the minigame flag isn't set, the contest is over and we shouldn't be here
	CheckEngine ENGINE_PARK_MINIGAME
	jr z, .abort
	; if we somehow managed to exit the park, end the contest immediately
	; this prevents a lot of Safari Zone-like glitches
	ld hl, MapGroup
	ld a, [hli]
	cp GROUP_PROVINCIAL_PARK_CONTEST
	jr nz, .not_in_park
	ld a, [hl]
	cp MAP_PROVINCIAL_PARK_CONTEST
	jr z, .in_park
.not_in_park
	call EndParkMinigame
	ld hl, ParkGameOverScript
	jr RunParkMinigameScript
.in_park
	; error handlers were unnecessary -- check the time and see if the game is over
	call CalculateRemainingParkMinigameTime
	jr z, .game_over
	xor a
	ret
.abort
	call EndParkMinigame
	xor a
	ret
.game_over
	call EndParkMinigame
	ld hl, ParkMinigameTimeUpScript
	; fallthrough

RunParkMinigameScript:
	ld a, BANK(RunParkMinigameScript)
	jp CallScript

StopParkMinigameScript::
	callasm EndParkMinigame
	jump ParkGameOverScript

EndParkMinigame:
	xor a
	ld hl, wTimeEventCallback
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, wStopwatchControl
	res STOPWATCH_PARK_MINIGAME, [hl]
	ret

ParkMinigameTimeUpScript:
	playmusic MUSIC_NONE
	playwaitsfx SFX_ELEVATOR_END
	opentext
	writetext .time_is_up_text
	closetext
	jump ParkGameOverScript
.time_is_up_text
	ctxt "PA: Ding-dong!"
	line "Your time is up!"
	sdone

GetParkSpotAddress:
	; returns in hl the address of the park spot a (1 to PARK_MINIGAME_SPOT_COUNT)
	push bc
	ld hl, wParkMinigameSpot1 - (wParkMinigameSpot2 - wParkMinigameSpot1)
	ld bc, wParkMinigameSpot2 - wParkMinigameSpot1
	rst AddNTimes
	pop bc
	ret

ResetParkSpot:
	; resets park spot a (1 to PARK_MINIGAME_SPOT_COUNT) to a random cooldown between 44 seconds and 1:15 minutes
	push hl
	push bc
	push de
	push af
	call CalculateRemainingParkMinigameTime
	pop af
	call GetParkSpotAddress
	xor a
	ld [hli], a
	ld bc, wParkMinigameRemainingTime + 1
	ld a, [bc]
	ld d, a
	inc bc
	ld a, [bc]
	ld e, a
	inc bc
	ld a, [bc]
	ld c, a
	call Random
	and 31
	add a, 44
	cp 60
	ld b, a
	jr c, .not_over_one_minute
	sub 60
	ld b, a
	ld a, d
	and a
	jr z, .remaining_time_too_low
	dec d
.not_over_one_minute
	ld a, e
	sub b
	ld e, a
	jr nc, .calculated
	add a, 60
	ld e, a
	ld a, d
	and a
	jr z, .remaining_time_too_low
	dec d
.calculated
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld [hl], c
.done
	pop de
	pop bc
	pop hl
	ret
.remaining_time_too_low
	ld [hli], a
	ld [hli], a
	ld [hl], a
	jr .done

GetRandomPercentage:
	call Random
	cp 200
	jr nc, .not_in_range
	srl a
	ret
.not_in_range
	cp 250
	jr nc, GetRandomPercentage
	ld a, [hRandomAdd]
	rra
	ld a, [hRandomSub]
	rla
	sub 144
	ret

GenerateParkSpot:
	; generates a park spot's contents; park spot passed in a (1 to PARK_MINIGAME_SPOT_COUNT)
	ld d, a
	ld bc, 5
	ld a, [wParkMinigameGameType]
	ld hl, ParkMinigameTables
	rst AddNTimes
	call GetRandomPercentage
	cp [hl]
	inc hl
	jr nc, .generate_item
	call .select
	ld b, [hl]
	ld a, d
	call GetParkSpotAddress
	ld a, b
	ld [hli], a
	call GetMaxPartyLevel
	push hl
	ld hl, hMultiplicand + 2
	ld [hld], a
	xor a
	ld [hld], a
	ld [hl], a
	pop hl
	call Random
	and 31
	add a, 50
	ld [hMultiplier], a
	predef Multiply
	ld a, 100
	ld [hDivisor], a
	ld b, 4
	predef Divide
	ld a, [hQuotient + 2]
	and a
	jr nz, .level_OK
	inc a
.level_OK
	ld [hli], a
	push hl
	call GenerateParkMinigameDVs
	pop hl
	ld a, b
	ld [hli], a
	ld [hl], c
	ret

.generate_item
	inc hl
	inc hl
	call .select
	ld a, [hl]
	push af
	and $f
	ld c, a
	pop af
	swap a
	and $f
	jr z, .empty_spot
	ld b, a
	; 1/32 chance of improving the item kind; 2/32 of increasing the amount given
	call Random
	and 31
	cp 3
	jr nc, .done_improving_item
	and a
	jr nz, .no_item_kind_improvement
	inc b
	ld c, 1 ; if we improve the kind of item, only give 1 of the improved item
.no_item_kind_improvement
	add a, c
	ld c, a
.done_improving_item
	dec b
	ld a, b
	cp .items_end - .items
	jr c, .valid_item
	ld a, (.items_end - .items) - 1
.valid_item
	add a, .items & $ff
	ld l, a
	ld h, .items >> 8
	jr nc, .no_items_overflow
	inc h
.no_items_overflow
	ld b, [hl]
	ld a, d
	call GetParkSpotAddress
	ld a, -1
	ld [hli], a
	ld a, b
	ld [hli], a
	ld [hl], c
	ret
.items
	db POKE_BALL
	db GREAT_BALL
	db ULTRA_BALL
	db MASTER_BALL
.items_end

.empty_spot
	ld a, d
	jp ResetParkSpot

.select
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call GetRandomPercentage
.loop
	sub [hl]
	inc hl
	ret c
	inc hl
	jr .loop

GetMaxPartyLevel:
	ld a, [wPartyCount]
	and a
	ret z
	push hl
	push de
	push bc
	ld e, a
	xor a
	ld bc, PARTYMON_STRUCT_LENGTH
	ld hl, PartyMon1Level
.loop
	ld d, [hl]
	cp d
	jr nc, .not_higher
	ld a, d
.not_higher
	add hl, bc
	dec e
	jr nz, .loop
	pop bc
	pop de
	pop hl
	ret

GenerateParkMinigameDVs:
	; returns the generated DVs in bc
	; note that this results in overall "better" DVs, along with a 1/512 chance of a shiny (16x the usual)
	call Random
	ld c, a
	ld a, [hRandomAdd]
	ld b, a
	set 3, b
	and $11
	jr z, .try_shiny
	ld a, c
	or $99
	ld c, a
	ret
.try_shiny
	set 4, b
	ld a, c
	or $88
	and $ee
	ld c, a
	ret

LoadCurrentParkSpot:
	; loads the spot indicated by [hScriptVar] (1 to PARK_MINIGAME_SPOT_COUNT) into wParkMinigameCurrentSpot
	ld a, [hScriptVar]
	ld [wParkMinigameCurrentSpotNumber], a
	call GetParkSpotAddress
	ld de, wParkMinigameCurrentSpot
	ld bc, wParkMinigameSpot2 - wParkMinigameSpot1
	jp _CopyBytes

CheckCurrentParkSpotCooldownExpired:
	; checks if the cooldown of the current park spot has expired
	; returns in [hScriptVar]
	ld hl, wParkMinigameCurrentSpot
	ld a, [hli]
	and a
	jr nz, .expired
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ld hl, wParkMinigameRemainingTime + 1
	ld a, [hli]
	cp c
	jr c, .expired
	jr nz, .not_expired
	ld a, [hli]
	cp d
	jr c, .expired
	jr nz, .not_expired
	ld a, [hl]
	cp e
	jr c, .expired
	jr z, .expired
.not_expired
	xor a
	jr .done
.expired
	ld a, 1
.done
	ld [hScriptVar], a
	ret

ParkSpotScript::
	; assuming that [hScriptVar] already contains the spot's number
	callasm LoadCurrentParkSpot
	copybytetovar wParkMinigameCurrentSpotFlags
	iffalse .empty_spot
	if_equal -1, .item
	; wild mon
	pokenamemem 0, 0
	opentext
	writetext .pokemon_text
	yesorno
	iffalse .end_script
	randomwildmon
	scriptstartasm
	ld hl, wParkMinigameCurrentSpot
	ld a, [hli]
	ld [TempWildMonSpecies], a
	ld a, [hl]
	ld [CurPartyLevel], a
	scriptstopasm
	startbattle
	reloadmap
	if_equal 1, .defeated
	scriptstartasm
	ld a, [wParkMinigameCurrentSpotNumber]
	call ResetParkSpot
	ld hl, 0
	ret
.pokemon_text
	ctxt "Spot No. @"
	deciram wParkMinigameCurrentSpotNumber, 1, 2
	ctxt ":"
	line "There is a"
	para "lv. @"
	deciram wParkMinigameCurrentSpotLevel, 1, 3
	ctxt " <STRBF3>"
	line "here. Battle it?"
	done

.item
	copybytetovar wParkMinigameCurrentSpotItem
	itemtotext 0, 0
	opentext
	writetext .item_text
	yesorno
	iffalse .end_script
	scriptstartasm
	ld hl, wParkMinigameCurrentSpotItem
	ld a, [hli]
	ld d, [hl]
	ld e, a
	push de
	ld a, [wParkMinigameCurrentSpotNumber]
	call ResetParkSpot
	pop de
	ld a, e
	ld [wCurItem], a
	ld a, d
	ld [wItemQuantityChangeBuffer], a
	push de
	ld hl, NumItems
	call ReceiveItem
	ld hl, .no_room_for_items
	pop bc
	ret nc
	ld a, c
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	ld a, b
	ld [wItemQuantityChangeBuffer], a
	scriptstopasm
	writetext .got_item_text
	playwaitsfx SFX_ITEM
	waitbutton
.end_script
	closetext
	end
.no_room_for_items
	jumptext .no_room_for_items_text
.item_text
	start_asm
	ld a, [wParkMinigameCurrentSpotQuantity]
	cp 2
	ld hl, .item_text_singular
	ret c
	ld hl, .item_text_plural
	ret
.item_text_singular
	ctxt "Spot No. @"
	deciram wParkMinigameCurrentSpotNumber, 1, 2
	ctxt ":"
	line "This spot contains"
	para "1 <STRBF3>."
	line "Pick it up?"
	done
.item_text_plural
	ctxt "Spot No. @"
	deciram wParkMinigameCurrentSpotNumber, 1, 2
	ctxt ":"
	line "This spot contains"
	para "@"
	deciram wParkMinigameCurrentSpotQuantity, 1, 2
	ctxt " <STRBF3>s."
	line "Pick them up?"
	done
.got_item_text
	start_asm
	ld a, [wItemQuantityChangeBuffer]
	dec a
	ld hl, .got_item_text_singular
	ret z
	ld hl, .got_item_text_plural
	ret
.got_item_text_singular
	ctxt "Picked up the"
	line "<STRBF1>."
	done
.got_item_text_plural
	ctxt "Picked up the"
	line "@"
	deciram wItemQuantityChangeBuffer, 1, 3
	ctxt " <STRBF1>s."
	done
.no_room_for_items_text
	ctxt "You had no room"
	line "for the items, so"
	cont "they were tossed."
	done

.empty_spot
	callasm CheckCurrentParkSpotCooldownExpired
	iftrue .reload
	jumptext .empty_spot_text
.empty_spot_text
	ctxt "Spot No. @"
	deciram wParkMinigameCurrentSpotNumber, 1, 2
	ctxt ":"
	line "The spot is empty<...>"
	done

.reload
	scriptstartasm
	ld a, [wParkMinigameCurrentSpotNumber]
	ld [hScriptVar], a
	call GenerateParkSpot
	ld hl, ParkSpotScript
	ret

.defeated
	callasm EndParkMinigame
	opentext
	writetext ParkMinigame_DefeatedText
	closetext
	special HealParty
	; fallthrough

ParkGameOverScript:
	warpsound
	special FadeOutPalettes
	waitsfx
	warp PROVINCIAL_PARK_GATE, 0, 4
	spriteface PLAYER, RIGHT
	applymovement PLAYER, .move_to_employee
	spriteface PLAYER, UP
	opentext
	writetext .welcome_back_text
	waitbutton
	callasm StoreAndRemoveParkBalls
	writetext .returned_balls_text
	waitbutton
	sif true, then
		writetext .stocked_balls_text
		waitbutton
		sif >=, 2, then
			writetext .wasted_balls_text
			waitbutton
		sendif
	sendif
	callasm RestorePlayerPokeballs
	writetext .restored_balls_text
	waitbutton
	sif true, then
		sif =, 1
			writetext .restored_held_balls_text
		sif =, 2
			writetext .wasted_held_balls_text
		waitbutton
	sendif
	writetext .final_text
	waitbutton
	closetext
	clearflag ENGINE_PARK_MINIGAME
	end

.move_to_employee
	rept 6
		step_right
	endr
	step_end

.welcome_back_text
	ctxt "Welcome back."
	done
.final_text
	ctxt "Come again!"
	done

.returned_balls_text
	ctxt "You'll have to"
	line "return the Park"
	cont "Balls that you"
	cont "didn't use."
	done
.stocked_balls_text
	ctxt "I'll also keep the"
	line "rest of the balls"
	cont "that you found in"
	cont "the park for your"
	cont "next visit."
	done
.wasted_balls_text
	ctxt "You found more of"
	line "them than I can"
	cont "keep, so I'll just"
	cont "throw away some."
	done

.restored_balls_text
	ctxt "Here are the #"
	line "Balls that I kept"
	cont "for you when you"
	cont "entered the park."
	done
.restored_held_balls_text
	ctxt "Including the ones"
	line "that your #mon"
	cont "were holding."
	done
.wasted_held_balls_text
	ctxt "You don't have room"
	line "for the ones that"
	cont "your #mon were"
	cont "holding, though;"
	cont "so I'll just throw"
	cont "some of them away."
	done

ParkMinigame_DefeatedText:
	ctxt "You are out of"
	line "usable #mon<...>"
	para "You will be taken"
	line "to the entrance."
	sdone