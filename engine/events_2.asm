INCLUDE "engine/landmarksigns.asm"

CheckForHiddenItems:
; Checks to see if there are hidden items on the screen that have not yet been found.  If it finds one, returns carry.
	ld a, [MapScriptHeaderBank]
	ld [wItemfinderSignpostsBank], a
; Get the coordinate of the bottom right corner of the screen, and load it in wItemfinderScreenBottom/wItemfinderScreenRight.
	ld a, [XCoord]
	add SCREEN_WIDTH / 4
	ld [wItemfinderScreenRight], a
	ld a, [YCoord]
	add SCREEN_HEIGHT / 4
	ld [wItemfinderScreenBottom], a
; Get the pointer for the first signpost header in the map...
	ld hl, wCurrentMapSignpostHeaderPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
; ... before even checking to see if there are any signposts on this map.
	ld a, [wCurrentMapSignpostCount]
	and a
	jr z, .nosignpostitems
; For i = 1:wCurrentMapSignpostCount...
.loop
; Store the counter in wItemfinderSignpostsCount, and store the signpost header pointer in the stack.
	ld [wItemfinderSignpostsCount], a
	push hl
; Get the Y coordinate of the signpost.
	call .GetFarByte
	ld e, a
; Is the Y coordinate of the signpost on the screen?  If not, go to the next signpost.
	ld a, [wItemfinderScreenBottom]
	sub e
	jr c, .next
	cp SCREEN_HEIGHT / 2
	jr nc, .next
; Is the X coordinate of the signpost on the screen?  If not, go to the next signpost.
	call .GetFarByte
	ld d, a
	ld a, [wItemfinderScreenRight]
	sub d
	jr c, .next
	cp SCREEN_WIDTH / 2
	jr nc, .next
; Is this signpost a hidden item?  If not, go to the next signpost.
	call .GetFarByte
	cp SIGNPOST_ITEM
	jr nz, .next
; Has this item already been found?  If not, set off the Itemfinder.
	ld a, [wItemfinderSignpostsBank]
	call GetFarHalfword
	ld a, [wItemfinderSignpostsBank]
	call GetFarHalfword
	ld d, h
	ld e, l
	ld b, CHECK_FLAG
	predef EventFlagAction
	ld a, c
	and a
	jr z, .itemnearby

.next
; Restore the signpost header pointer and increment it by the length of a signpost header.
	pop hl
	ld bc, 5
	add hl, bc
; Restore the signpost counter and decrement it.  If it hits zero, there are no hidden items in range.
	ld a, [wItemfinderSignpostsCount]
	dec a
	jr nz, .loop

.nosignpostitems
	xor a
	ret

.itemnearby
	pop hl
	scf
	ret

.GetFarByte
	ld a, [wItemfinderSignpostsBank]
	jp GetFarByteAndIncrement

TreeMonEncounter:
	xor a
	ld [TempWildMonSpecies], a
	ld [CurPartyLevel], a

	ld hl, TreeMonMaps
	call GetTreeMonSet
	jr nc, .no_battle

	call GetTreeMons
	jr nc, .no_battle

	call GetTreeMon
	jr nc, .no_battle

	ld a, BATTLETYPE_TREE
	ld [wBattleType], a
	ld a, 1
	ld [hScriptVar], a
	ret

.no_battle
	xor a
	ld [hScriptVar], a
	ret

RockMonEncounter:

	xor a
	ld [TempWildMonSpecies], a
	ld [CurPartyLevel], a

	ld hl, RockMonMaps
	call GetTreeMonSet
	jr nc, .no_battle

	call GetTreeMons
	jr nc, .no_battle

	ld a, 10
	call RandomRange
	cp 4
	jr nc, .no_battle

	call SelectTreeMon
	ret c

.no_battle
	xor a
	ret

GetTreeMonSet:
; Return carry and treemon set in a
; if the current map is in table hl.
	ld a, [MapNumber]
	ld e, a
	ld a, [MapGroup]
	ld d, a
.loop
	ld a, [hli]
	cp -1
	jr z, .not_in_table

	cp d
	jr nz, .skip2

	ld a, [hli]
	cp e
	jr nz, .skip1

	ld a, [hl]
	scf
	ret

.skip2
	inc hl
.skip1
	inc hl
	jr .loop

.not_in_table
	xor a
	ret

TreeMonMaps:
treemon_map: macro
	map \1
	db  \2 ; treemon set
endm
	treemon_map ROUTE_67, 2
	treemon_map ROUTE_65, 1
	treemon_map RIJON_LEAGUE_OUTSIDE, 1
	treemon_map ILEX_FOREST, 6
	treemon_map ROUTE_34, 3
	treemon_map AZALEA_TOWN, 4
	db -1

RockMonMaps:
	;treemon_map CIANWOOD_CITY, 7
	db -1

GetTreeMons:
; Return the address of TreeMon table a in hl.
; Return nc if table a doesn't exist.

	cp 8
	jr nc, .quit

	and a
	;jr z, .quit
	ret z

	ld e, a
	ld d, 0
	ld hl, TreeMons
	add hl, de
	add hl, de

	ld a, [hli]
	ld h, [hl]
	ld l, a

	scf
	ret

.quit
	xor a
	ret

TreeMons:
	dw TreeMons1
	dw TreeMons1
	dw TreeMons2
	dw TreeMons3
	dw TreeMons4
	dw TreeMons5
	dw TreeMons6
	dw RockMons
	dw TreeMons1

; Two tables each (normal, rare).
; Structure:
;	db  %, species, level

TreeMons1:
	db 50, SPEAROW,    10
	db 15, SPEAROW,    10
	db 15, SPEAROW,    10
	db 10, SPINARAK,   10
	db  5, SPINARAK,   10
	db  5, ARIADOS,    10
	db -1

	db 50, SPEAROW,    10
	db 15, TANGELA,    10
	db 15, TANGELA,    10
	db 10, SPINARAK,   10
	db  5, SPINARAK,   10
	db  5, ARIADOS,    10
	db -1

TreeMons2:
	db 50, SPEAROW,    10
	db 15, METAPOD,    10
	db 15, SPEAROW,    10
	db 10, SPINARAK,   10
	db  5, SPINARAK,   10
	db  5, ARIADOS,    10
	db -1

	db 50, SPEAROW,    10
	db 15, TANGELA,    10
	db 15, TANGELA,    10
	db 10, SPINARAK,   10
	db  5, SPINARAK,   10
	db  5, ARIADOS,    10
	db -1

TreeMons3:
	db 50, TAILLOW,    10
	db 15, SPINARAK,   10
	db 15, ARIADOS,    10
	db 10, EXEGGCUTE,  10
	db  5, EXEGGCUTE,  10
	db  5, EXEGGCUTE,  10
	db -1

	db 50, TAILLOW,    10
	db 15, PINECO,     10
	db 15, PINECO,     10
	db 10, EXEGGCUTE,  10
	db  5, EXEGGCUTE,  10
	db  5, EXEGGCUTE,  10
	db -1

TreeMons4:
	db 50, TAILLOW,    10
	db 15, METAPOD,    10
	db 15, NATU,       10
	db 10, EXEGGCUTE,  10
	db  5, EXEGGCUTE,  10
	db  5, EXEGGCUTE,  10
	db -1

	db 50, TAILLOW,    10
	db 15, PINECO,     10
	db 15, PINECO,     10
	db 10, EXEGGCUTE,  10
	db  5, EXEGGCUTE,  10
	db  5, EXEGGCUTE,  10
	db -1

TreeMons5:
	db 50, TAILLOW,    10
	db 15, VENONAT,    10
	db 15, NATU,       10
	db 10, EXEGGCUTE,  10
	db  5, EXEGGCUTE,  10
	db  5, EXEGGCUTE,  10
	db -1

	db 50, TAILLOW,    10
	db 15, PINECO,     10
	db 15, PINECO,     10
	db 10, EXEGGCUTE,  10
	db  5, EXEGGCUTE,  10
	db  5, EXEGGCUTE,  10
	db -1

TreeMons6:
	db 50, TAILLOW,    10
	db 15, PINECO,     10
	db 15, PINECO,     10
	db 10, SWELLOW,    10
	db  5, SHROOMISH,  10
	db  5, BUTTERFREE, 10
	db -1

	db 50, TAILLOW,    10
	db 15, CATERPIE,   10
	db 15, METAPOD,    10
	db 10, TAILLOW,    10
	db  5, SHROOMISH,  10
	db  5, BUTTERFREE, 10
	db -1

;Rock Smash Pokemon:
;Geodude
;Slugma
;Graveler
;

RockMons: ; b83de (Change to check certain maps)
	;db 90, KRABBY,     15
	;db 10, SHUCKLE,    15
	db -1

GetTreeMon:
	push hl
	call GetTreeScore
	pop hl
	and a
	jr z, .bad
	cp 1
	jr z, .good
	cp 2
	jr z, .rare
	ret

.bad
	ld a, 10
	call RandomRange
	and a
	jr nz, NoTreeMon
	jr SelectTreeMon

.good
	ld a, 10
	call RandomRange
	cp 5
	jr nc, NoTreeMon
	jr SelectTreeMon

.rare
	ld a, 10
	call RandomRange
	cp 8
	jr nc, NoTreeMon
	jr .skip
.skip
	ld a, [hli]
	cp -1
	jr nz, .skip
	; fallthrough

SelectTreeMon:
; Read a TreeMons table and pick one monster at random.

	ld a, 100
	call RandomRange
.loop
	sub [hl]
	jr c, .ok
	inc hl
	inc hl
	inc hl
	jr .loop

.ok
	ld a, [hli]
	cp $ff
	jr z, NoTreeMon

	ld a, [hli]
	ld [TempWildMonSpecies], a
	ld a, [hl]
	ld [CurPartyLevel], a
	scf
	ret

NoTreeMon:
	xor a
	ld [TempWildMonSpecies], a
	ld [CurPartyLevel], a
	ret

GetTreeScore:
	call .CoordScore
	ld [wTreeCoordScore], a
	call .OTIDScore
	ld [wTreeIDScore], a
	ld c, a
	ld a, [wTreeCoordScore]
	sub c
	jr z, .rare
	jr nc, .ok
	add 10
.ok
	cp 5
	jr c, .good

.bad
	xor a
	ret

.good
	ld a, 1
	ret

.rare
	ld a, 2
	ret

.CoordScore
	call GetFacingTileCoord
	ld hl, 0
	ld c, e
	ld b, 0
	ld a, d

	and a
	jr z, .next
.loop
	add hl, bc
	dec a
	jr nz, .loop
.next

	add hl, bc
	ld c, d
	add hl, bc

	ld a, h
	ld [hDividend], a
	ld a, l
	ld [hDividend + 1], a
	ld a, 5
	ld [hDivisor], a
	ld b, 2
	predef Divide

	ld a, [hQuotient + 1]
	ld [hDividend], a
	ld a, [hQuotient + 2]
	ld [hDividend + 1], a
	ld a, 10
	ld [hDivisor], a
	ld b, 2
	predef Divide

	ld a, [hRemainder]
	ret

.OTIDScore
	ld a, [PlayerID]
	ld [hDividend], a
	ld a, [PlayerID + 1]
	ld [hDividend + 1], a
	ld a, 10
	ld [hDivisor], a
	ld b, 2
	predef Divide
	ld a, [hRemainder]
	ret

LoadFishingGFX:
	ld a, [rVBK]
	push af
	ld a, 1
	ld [rVBK], a
	ld a, [wPlayerCharacteristics]
	ld hl, FishingGFX7
	and $f
	cp $c
	jr nc, .setGFX

	ld hl, FishingGFX
	ld bc, 24 tiles
	rst AddNTimes

.setGFX
	push hl
	ld d, h
	ld e, l
	ld hl, VTiles0 tile $00
	lb bc, BANK(FishingGFX), 12
	call Get2bpp
	pop hl
	ld de, 12 tiles
	add hl, de
	ld d, h
	ld e, l
	ld hl, VTiles1 tile $00
	lb bc, BANK(FishingGFX), 12
	call Get2bpp
	ld hl, VTiles0 tile $7c
	ld de, FishingGFXExtra
	lb bc, BANK(FishingGFXExtra), 4
	call Get2bpp
	pop af
	ld [rVBK], a
	ld hl, ScriptFlags2
	set 0, [hl]
	ret
