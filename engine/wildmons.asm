LoadWildMonData:
	ld a, $1
	ld [wEncounterRateStage], a
LoadWildMonData_KeepFlutes:
	call _GrassWildmonLookup
	jr c, .copy
	ld hl, wMornEncounterRate
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	jr .done_copy
.copy
	inc hl
	inc hl
	ld de, wMornEncounterRate
	ld bc, 3
	rst CopyBytes
.done_copy
; test
	call _WaterWildmonLookup
	ld a, 0
	jr nc, .no_copy
	inc hl
	inc hl
	ld a, [hl]
.no_copy
	ld [wWaterEncounterRate], a

	;flute effects
	ld hl, wMornEncounterRate
	ld c, 4

	ld a, [wEncounterRateStage]
	and a
	jr z, .halfRate
	dec a
	ret z
; double rate
.loop
	ld a, [hl]
	add a
	jr nc, .noOverflow
	ld a, $ff
.noOverflow
	ld [hli], a
	dec c
	jr nz, .loop
	ret
.halfRate
	srl [hl]
	jr nz, .notZero
	inc [hl]
.notZero
	inc hl
	dec c
	jr nz, .halfRate
	ret

GrassPointerTable:
	dw NaljoGrassWildMons
	dw RijonGrassWildMons
	dw JohtoGrassWildMons
	dw KantoGrassWildMons
	dw SeviiGrassWildMons
	dw TunodGrassWildMons
	dw MysteryGrassWildMons

WaterPointerTable:
	dw NaljoWaterWildMons
	dw RijonWaterWildMons
	dw JohtoWaterWildMons
	dw KantoWaterWildMons
	dw SeviiWaterWildMons
	dw TunodWaterWildMons
	dw MysteryWaterWildMons

;a: Region
;hl: Table
;Returns hl with pointer to correct table.

GetLandmark:
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
	call GetWorldMapLocation
	cp SPECIAL_MAP
	ret nz
	ld a, [BackupMapGroup]
	ld b, a
	ld a, [BackupMapNumber]
	ld c, a
	jp GetWorldMapLocation

GetWildLookupPointer:
	push hl
	push de
	callba RegionCheck
	ld a, e
	pop de
	pop hl
	push af
	push bc
	sla a
	ld c, a
	ld b, 0
	add hl, bc

	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	ld l, c
	ld h, b

	pop bc
	pop af
	ret

FindNest:
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	xor a
	call ByteFill
	decoord 0, 0
	ld hl, GrassPointerTable
	call GetWildLookupPointer
	call .FindGrass
	ld hl, WaterPointerTable
	call GetWildLookupPointer
	call .FindWater
	push de
	callba RegionCheck ; Roaming Pokemon only appear in Naljo
	ld a, e
	and a
	pop de
	ret nz
	ld a, [wRoamMon1Species]
	ld b, a
	ld a, [wNamedObjectIndexBuffer]
	cp b
	ret nz
	ld a, [wRoamMon1MapGroup]
	ld b, a
	ld a, [wRoamMon1MapNumber]
	ld c, a
	call .AppendNest
	ret nc
	ld [de], a
	inc de
	ret

.FindGrass
	ld a, [hl]
	cp -1
	ret z
	push hl
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	inc hl
	inc hl
	inc hl
	ld a, NUM_WILDMONS_PER_AREA_TIME_OF_DAY * 3
	call .SearchMapForMon
	jr nc, .next_grass
	ld [de], a
	inc de

.next_grass
	pop hl
	ld bc, WILDMON_GRASS_STRUCTURE_LENGTH
	add hl, bc
	jr .FindGrass

.FindWater
	ld a, [hl]
	cp -1
	ret z
	push hl
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	inc hl
	ld a, 3
	call .SearchMapForMon
	jr nc, .next_water
	ld [de], a
	inc de

.next_water
	pop hl
	ld bc, 3 * 3
	add hl, bc
	jr .FindWater

.SearchMapForMon
	inc hl
.ScanMapLoop
	push af
	ld a, [wNamedObjectIndexBuffer]
	cp [hl]
	jr z, .found
	inc hl
	inc hl
	pop af
	dec a
	jr nz, .ScanMapLoop
	and a
	ret

.found
	pop af
	; fallthrough

.AppendNest
	push de
	call GetWorldMapLocation
	ld c, a
	hlcoord 0, 0
	ld de, SCREEN_WIDTH * SCREEN_HEIGHT
.AppendNestLoop
	ld a, [hli]
	cp c
	jr z, .found_nest
	dec de
	ld a, e
	or d
	jr nz, .AppendNestLoop
	ld a, c
	pop de
	scf
	ret

.found_nest
	pop de
	and a
	ret

TryWildEncounter::
; Try to trigger a wild encounter.
	call .EncounterRate
	jr nc, .no_battle
	call ChooseWildEncounter
	jr nz, .no_battle
	call CheckRepelEffect
	jr nc, .no_battle
	xor a
	ret

.no_battle
	xor a ; BATTLETYPE_NORMAL
	ld [TempWildMonSpecies], a
	ld [wBattleType], a
	ld a, 1
	and a
	ret

.EncounterRate
	call GetMapEncounterRate
	call ApplyAbilityEffectOnEncounterRate
	call ApplyCleanseTagEffectOnEncounterRate
	call Random
	cp b
	ret

GetMapEncounterRate:
	ld hl, wMornEncounterRate
	call CheckOnWater
	ld c, 3
	jr z, .ok
	ld a, [TimeOfDay]
	ld c, a
.ok
	ld b, 0
	add hl, bc
	ld b, [hl]
	ret

;USE FLUTES HERE

ApplyAbilityEffectOnEncounterRate:
	push bc
	call GetFirstPartyMonAbility
	ld hl, .Abilities
	ld e, 3
	call IsInArray
	pop bc
	ret nc
	call CallLocalPointer_AfterIsInArray
	jr c, .capAt255
	ret nz
	inc a
	ret
.capAt255
	ld a, 255
	ret

.Abilities
	dbw ABILITY_VITAL_SPIRIT, .Pressure
	dbw ABILITY_PRESSURE,     .Pressure
	dbw ABILITY_STENCH,       .Stench
	dbw ABILITY_WHITE_SMOKE,  .Stench
	dbw ABILITY_ILLUMINATE,   .Illuminate
	dbw ABILITY_ARENA_TRAP,   .Illuminate
	dbw ABILITY_SWARM,        .Illuminate
	db $ff

.Illuminate
	sla b
	ret

.Stench
	srl b
	ret

.Pressure
	ld a, b
	srl a
	add b
	ld b, a
	ret

ApplyCleanseTagEffectOnEncounterRate::
; Cleanse Tag halves encounter rate.
	ld a, [wPartyCount]
	and a
	ret z
	ld hl, PartyMon1Item
	ld de, PARTYMON_STRUCT_LENGTH
	ld c, a
.loop
	ld a, [hl]
	cp CLEANSE_TAG
	jr z, .cleansetag
	add hl, de
	dec c
	jr nz, .loop
	ret

.cleansetag
	srl b
	ret

ChooseWildEncounter:
	call LoadWildMonDataPointer
	jp nc, .nowildbattle
	call CheckEncounterRoamMon
	jp c, .startwildbattle

	inc hl
	inc hl
	inc hl
	call CheckOnWater
	ld de, .WaterMonTable
	jr z, .watermon
	inc hl
	inc hl
	ld a, [TimeOfDay]
	ld bc, $e
	rst AddNTimes
	ld de, .GrassMonTable

.watermon
; hl contains the pointer to the wild mon data, let's save that to the stack
	push hl
.randomloop
	call Random
	cp 100
	jr nc, .randomloop
	inc a ; 1 <= a <= 100
	ld b, a
	ld h, d
	ld l, e
; This next loop chooses which mon to load up.
.prob_bracket_loop
	ld a, [hli]
	cp b
	jr nc, .got_it
	inc hl
	jr .prob_bracket_loop

.got_it
	ld c, [hl]
	ld b, 0
	pop hl
	add hl, bc ; this selects our mon
	ld a, [hli]
	ld b, a
; If the Pokemon is encountered by surfing, we need to give the levels some variety.
	call CheckOnWater
	jr nz, .ok
; Check if we buff the wild mon, and by how much.
	call Random
	cp 35 percent
	jr c, .ok
	inc b
	cp 65 percent
	jr c, .ok
	inc b
	cp 85 percent
	jr c, .ok
	inc b
	cp 95 percent
	jr c, .ok
	inc b
; Store the level
.ok
	ld a, b
	ld [CurPartyLevel], a
	ld b, [hl]
	; ld a, b
	call ValidateTempWildMonSpecies
	jr c, .nowildbattle

	ld a, b

.done
	jr .loadwildmon

.nowildbattle
	ld a, 1
	and a
	ret

.loadwildmon
	ld a, b
	ld [TempWildMonSpecies], a

.startwildbattle
	xor a
	ret

.GrassMonTable
	db 30,  $0 ; 30% chance
	db 60,  $2 ; 30% chance
	db 80,  $4 ; 20% chance
	db 90,  $6 ; 10% chance
	db 95,  $8 ;  5% chance
	db 99,  $a ;  4% chance
	db 100, $c ;  1% chance

.WaterMonTable
	db 60,  $0 ; 60% chance
	db 90,  $2 ; 30% chance
	db 100, $4 ; 10% chance

CheckRepelEffect::
; If there is no active Repel, there's no need to be here.
	ld hl, wRepelEffect
	ld a, [hli]
	or [hl]
	jr z, .encounter
; Get the first Pokemon in your party that isn't fainted.
	ld hl, PartyMon1HP
	ld bc, PARTYMON_STRUCT_LENGTH - 1
.loop
	ld a, [hli]
	or [hl]
	jr nz, .ok
	add hl, bc
	jr .loop

.ok
; to PartyMonLevel
rept 4
	dec hl
endr

	ld a, [CurPartyLevel]
	cp [hl]
	jr nc, .encounter
	and a
	ret

.encounter
	scf
	ret

LoadWildMonDataPointer:
	call CheckOnWater
	jr z, _WaterWildmonLookup

_GrassWildmonLookup:
	ld hl, SwarmGrassWildMons
	ld bc, GRASS_WILDDATA_LENGTH
	call _SwarmWildmonCheck
	ret c
	ld hl, GrassPointerTable
	call GetWildLookupPointer
	ld bc, GRASS_WILDDATA_LENGTH
	jr _NormalWildmonOK

_WaterWildmonLookup:
	ld hl, SwarmWaterWildMons
	ld bc, WATER_WILDDATA_LENGTH
	call _SwarmWildmonCheck
	ret c
	ld hl, WaterPointerTable
	call GetWildLookupPointer
	ld bc, WATER_WILDDATA_LENGTH
	jr _NormalWildmonOK

_SwarmWildmonCheck:
	call CopyCurrMapDE
	push hl
	ld hl, SwarmFlags
	bit 2, [hl]
	pop hl
	jr z, .CheckYanma
	ld a, [wDunsparceMapGroup]
	cp d
	jr nz, .CheckYanma
	ld a, [wDunsparceMapNumber]
	cp e
	jr nz, .CheckYanma
	call LookUpWildmonsForMapDE
	jr nc, _NoSwarmWildmon
	scf
	ret

.CheckYanma
	push hl
	ld hl, SwarmFlags
	bit 3, [hl]
	pop hl
	jr z, _NoSwarmWildmon
	ld a, [wYanmaMapGroup]
	cp d
	jr nz, _NoSwarmWildmon
	ld a, [wYanmaMapNumber]
	cp e
	jr nz, _NoSwarmWildmon
	call LookUpWildmonsForMapDE
	jr nc, _NoSwarmWildmon
	scf
	ret

_NoSwarmWildmon:
	and a
	ret

_NormalWildmonOK:
	call CopyCurrMapDE
	jr LookUpWildmonsForMapDE

CopyCurrMapDE:
	ld a, [MapGroup]
	ld d, a
	ld a, [MapNumber]
	ld e, a
	ret

LookUpWildmonsForMapDE:
.loop
	push hl
	ld a, [hl]
	inc a
	jr z, .nope
	ld a, d
	cp [hl]
	jr nz, .next
	inc hl
	ld a, e
	cp [hl]
	jr z, .yup

.next
	pop hl
	add hl, bc
	jr .loop

.nope
	pop hl
	and a
	ret

.yup
	pop hl
	scf
	ret

InitRoamMons:

	ld a, VARANEOUS
	ld [wRoamMon1Species], a

	ld a, 50
	ld [wRoamMon1Level], a

	ld a, GROUP_ROUTE_85
	ld [wRoamMon1MapGroup], a
	ld a, MAP_ROUTE_85
	ld [wRoamMon1MapNumber], a

	xor a
	ld [wRoamMon1HP], a
	ld [wRoamMon1HP + 1], a
	ret

CheckEncounterRoamMon:
	push hl
; Don't trigger an encounter if we're on water.
	call CheckOnWater
	jr z, .DontEncounterRoamMon
; Load the current map group and number to de
	call CopyCurrMapDE
; Randomly select a beast.
	call Random
	cp 100 ; 25/64 chance
	jr nc, .DontEncounterRoamMon
; Compare its current location with yours
	ld hl, wRoamMon1MapGroup
	ld a, d
	cp [hl]
	jr nz, .DontEncounterRoamMon
	inc hl
	ld a, e
	cp [hl]
	jr nz, .DontEncounterRoamMon
; We've decided to take on a beast, so stage its information for battle.
	dec hl
	dec hl
	dec hl
	ld a, [hli]
	ld [TempWildMonSpecies], a
	ld a, [hl]
	ld [CurPartyLevel], a
	ld a, BATTLETYPE_ROAMING
	ld [wBattleType], a

	pop hl
	scf
	ret

.DontEncounterRoamMon
	pop hl
	and a
	ret

UpdateRoamMons:
	ld a, [wRoamMon1MapGroup]
	cp GROUP_N_A
	jr z, .SkipRaikou
	ld b, a
	ld a, [wRoamMon1MapNumber]
	ld c, a
	call .Update
	ld a, b
	ld [wRoamMon1MapGroup], a
	ld a, c
	ld [wRoamMon1MapNumber], a

.SkipRaikou
	jp _BackUpMapIndices

.Update
	ld hl, RoamMaps
.loop
; Are we at the end of the table?
	ld a, [hl]
	cp -1
	ret z
; Is this the correct entry?
	ld a, b
	cp [hl]
	jr nz, .next
	inc hl
	ld a, c
	cp [hl]
	jr z, .yes
; We don't have the correct entry yet, so let's continue.  A 0 terminates each entry.
.next
	ld a, [hli]
	and a
	jr nz, .next
	jr .loop

; We have the correct entry now, so let's choose a random map from it.
.yes
	inc hl
	ld d, h
	ld e, l
.update_loop
	ld h, d
	ld l, e
; Choose which map to warp to.
	call Random
	and $1f ; 1/8n chance it moves to a completely random map, where n is the number of roaming connections from the current map.
	jr z, JumpRoamMon
	and 3
	cp [hl]
	jr nc, .update_loop ; invalid index, try again
	inc hl
	ld c, a
	ld b, $0
	add hl, bc
	add hl, bc
	ld a, [wRoamMons_LastMapGroup]
	cp [hl]
	jr nz, .done
	inc hl
	ld a, [wRoamMons_LastMapNumber]
	cp [hl]
	jr z, .update_loop
	dec hl

.done
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ret

JumpRoamMons:
	ld a, [wRoamMon1MapGroup]
	cp GROUP_N_A
	jr z, .SkipRaikou
	call JumpRoamMon
	ld a, b
	ld [wRoamMon1MapGroup], a
	ld a, c
	ld [wRoamMon1MapNumber], a
.SkipRaikou

	jp _BackUpMapIndices

JumpRoamMon:
.loop
	ld hl, RoamMaps
	call Random ; Choose a random number
	and $f ; Take the lower nybble only.  This gives a number between 0 and 15.
	inc a
	ld b, a
.innerloop2 ; Loop to get hl to the address of the chosen roam map.
	dec b
	jr z, .ok
.innerloop3 ; Loop to skip the current roam map, which is terminated by a 0.
	ld a, [hli]
	and a
	jr nz, .innerloop3
	jr .innerloop2
; Check to see if the selected map is the one the player is currently in.  If so, try again.
.ok
	ld a, [MapGroup]
	cp [hl]
	jr nz, .done
	inc hl
	ld a, [MapNumber]
	cp [hl]
	jr z, .loop
	dec hl
; Return the map group and number in bc.
.done
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ret

_BackUpMapIndices:
	ld a, [wRoamMons_CurrentMapNumber]
	ld [wRoamMons_LastMapNumber], a
	ld a, [wRoamMons_CurrentMapGroup]
	ld [wRoamMons_LastMapGroup], a
	ld a, [MapNumber]
	ld [wRoamMons_CurrentMapNumber], a
	ld a, [MapGroup]
	ld [wRoamMons_CurrentMapGroup], a
	ret

RoamMaps:
	roam_map ROUTE_85, 1, ROUTE_69, ROUTE_82
	roam_map ROUTE_69, 2, ROUTE_85, ROUTE_70
	roam_map ROUTE_70, 3, ROUTE_69, ROUTE_71, ROUTE_75
	roam_map ROUTE_71, 3, ROUTE_75, ROUTE_70, ROUTE_72
	roam_map ROUTE_72, 2, ROUTE_71, ROUTE_73
	roam_map ROUTE_73, 2, ROUTE_72, ROUTE_74
	roam_map ROUTE_74, 2, ROUTE_73, ROUTE_75
	roam_map ROUTE_75, 4, ROUTE_74, ROUTE_70, ROUTE_71, ROUTE_76
	roam_map ROUTE_76, 3, ROUTE_75, ROUTE_77, ROUTE_79
	roam_map ROUTE_77, 3, ROUTE_76, ROUTE_78, ROUTE_79
	roam_map ROUTE_78, 1, ROUTE_77
	roam_map ROUTE_79, 4, ROUTE_81, ROUTE_82, ROUTE_76, ROUTE_77
	roam_map ROUTE_81, 2, ROUTE_79, ROUTE_82
	roam_map ROUTE_82, 3, ROUTE_79, ROUTE_81, ROUTE_85
	db -1

ValidateTempWildMonSpecies:
; Due to a development oversight, this function is called with the wild Pokemon's level, not its species, in a.
	and a
	jr z, .nowildmon ; = 0
	cp NUM_POKEMON + 1 ; 252
	jr nc, .nowildmon ; >= 252
	and a ; 1 <= Species <= 251
	ret

.nowildmon
	scf
	ret

NaljoGrassWildMons:
INCLUDE "data/wild/naljo_grass.asm"
RijonGrassWildMons:
INCLUDE "data/wild/rijon_grass.asm"
JohtoGrassWildMons:
INCLUDE "data/wild/johto_grass.asm"
KantoGrassWildMons:
INCLUDE "data/wild/kanto_grass.asm"
SeviiGrassWildMons:
INCLUDE "data/wild/sevii_grass.asm"
TunodGrassWildMons:
INCLUDE "data/wild/tunod_grass.asm"
MysteryGrassWildMons:
INCLUDE "data/wild/mystery_grass.asm"
NaljoWaterWildMons:
INCLUDE "data/wild/naljo_water.asm"
RijonWaterWildMons:
INCLUDE "data/wild/rijon_water.asm"
JohtoWaterWildMons:
INCLUDE "data/wild/johto_water.asm"
KantoWaterWildMons:
INCLUDE "data/wild/kanto_water.asm"
SeviiWaterWildMons:
INCLUDE "data/wild/sevii_water.asm"
TunodWaterWildMons:
INCLUDE "data/wild/tunod_water.asm"
MysteryWaterWildMons:
INCLUDE "data/wild/mystery_water.asm"
SwarmGrassWildMons:
INCLUDE "data/wild/swarm_grass.asm"
SwarmWaterWildMons:
INCLUDE "data/wild/swarm_water.asm"
