GetLandmarkCoords:
; Return coordinates (d, e) of landmark e.
	push hl
	ld l, e
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, Landmarks
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	pop hl
	ret

GetLandmarkName::
; Copy the name of landmark e to wStringBuffer1.
	push hl
	push de
	push bc

	ld l, e
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, Landmarks + 2
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld de, wStringBuffer1
	ld c, 18
.copy
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copy

	pop bc
	pop de
	pop hl
	ret
; 0x1ca8c3


Landmarks:

landmark: MACRO
	db \1, \2
	dw \3
ENDM

	landmark   0,   0, SpecialMapName
	landmark   $34, $3C, HeathVillageName
	landmark   $34, $4C, Route69Name
	landmark   $2C, $6C, Route70Name
	landmark   $2C, $7C, CaperCityName
	landmark   $4A, $7C, Route71Name
	landmark   $44, $70, Route72Name
	landmark   $44, $64, OxalisCityName
	landmark   $44, $58, Route73Name
	landmark   $44, $54, MoundCaveName
	landmark   $44, $4C, SpurgeCityName
	landmark   $44, $40, Route74Name
	landmark   $50, $3C, Route75Name
	landmark   $64, $3C, LaurelCityName
	landmark   $64, $48, Route76Name
	landmark   $64, $4C, LaurelForestName
	landmark   $64, $54, ToreniaCityName
	landmark   $54, $54, Route83Name
	landmark   $64, $64, Route77Name
	landmark   $64, $74, MilosCatacombsName
	landmark   $64, $7C, PhaceliaTownName
	landmark   $58, $78, BattleTowerName
	landmark   $64, $88, Route78Name
	landmark   $78, $8C, Route79Name
	landmark   $84, $8C, SaxifrageIslandName
	landmark   $8C, $7C, Route80Name
	landmark   $84, $64, Route81Name
	landmark   $7C, $6C, ProvincialParkName
	landmark   $7C, $74, MagmaCavernsName
	landmark   $74, $7C, Route85Name
	landmark   $54, $8C, NaljoRuinsName
	landmark   $44, $84, ClathriteTunnelName
	landmark   $34, $8C, Route84Name
	landmark   $24, $84, PhloxTownName
	landmark   $24, $7C, AcquaMinesName
	landmark   $74, $54, Route82Name
	landmark   $84, $54, AcaniaDockName
	landmark   $90, $54, Route68Name
	landmark   $9C, $54, NaljoBorderName
	landmark   $1C, $34, Route86Name
	landmark   $1C, $2C, ChampionIsleName
	landmark   $D0, $68, TunnelName
	landmark   $64, $24, Route87Name
	landmark   $18, $58, FarawayIslandName
	landmark   0,   0, SpecialMapName
	landmark   0,   0, SpecialMapName
	landmark   0,   0, SpecialMapName

	landmark   $1C, $7C, SeashoreCityName
	landmark   $1C, $88, Route53Name
	landmark   $1C, $94, GravelTownName
	landmark   $24, $94, MersonCaveName
	landmark   $30, $94, Route54Name
	landmark   $3C, $94, MersonCityName
	landmark   $3C, $74, Route55Name
	landmark   0,   0, RijonUnderground
	landmark   $1C, $6C, Route52Name
	landmark   $1C, $54, HaywardCityName
	landmark   $10, $54, Route64Name
	landmark   $1C, $40, Route51Name
	landmark   $24, $3C, Route50Name
	landmark   $30, $30, Route49Name
	landmark   $3C, $2C, OwsauriCityName
	landmark   $3C, $3C, Route66Name
	landmark   $24, $24, Route48Name
	landmark   $3C, $54, Route63Name
	landmark   $4C, $54, SilkTunnelName
	landmark   $5C, $54, MoragaTownName
	landmark   $64, $54, Route60Name
	landmark   $6C, $54, JaeruCityName
	landmark   $7C, $54, Route59Name
	landmark   $84, $50, SilphWarehouseName
	landmark   $8C, $54, BotanCityName
	landmark   $8C, $4C, HauntedForestName
	landmark   $64, $54, PowerPlantName
	landmark   $8C, $60, Route58Name
	landmark   $8C, $6C, CastroValleyName
	landmark   $90, $70, CastroMansionName
	landmark   $84, $6C, CastroForestName
	landmark   $74, $6C, Route62Name
	landmark   $64, $60, Route61Name
	landmark   $84, $74, Route57Name
	landmark   $64, $7C, Route56Name
	landmark   $4C, $7C, EagulouCityName
	landmark   $4C, $74, EagulouParkName
	landmark   $6C, $40, Route65Name
	landmark   $6C, $24, RijonLeagueName
	landmark   $74, $44, Route67Name
	landmark   $4C, $7C, MtBoulderName
	landmark   $84, $44, SenecaCavernsName
	landmark   $30, $8C, Route47Name
	landmark   $3C, $8C, IlexForestName
	landmark   $4C, $8C, AzaleaTownName
	landmark   $3C, $7C, Route34Name
	landmark   $3C, $6C, GoldenrodCityName
	landmark   $34, $6C, GoldenrodCapeName
	landmark   $6C, $54, SaffronCityName
	landmark   $14, $44, EmberBrookName
	landmark   $24, $44, MtEmberName
	landmark   $24, $54, KindleRoadName
	landmark   $7C, $94, TunodWaterwayName
	landmark   $8C, $84, SouthSoutherlyName
	landmark   $8C, $74, SoutherlyCityName
	landmark   0,   0, MysteryZoneName

SpecialMapName:      db "Special@"

CaperCityName:       db "Caper City@"
OxalisCityName:      db "Oxalis City@"
SpurgeCityName:      db "Spurge City@"
HeathVillageName:    db "Heath Village@"
LaurelCityName:      db "Laurel City@"
ToreniaCityName:     db "Torenia City@"
PhaceliaTownName:    db "Phacelia Town@"
AcaniaDockName:      db "Acania Dock@"
SaxifrageIslandName: db "Saxifrage Island@"
PhloxTownName:       db "Phlox Town@"
MoundCaveName:       db "Mound Cave@"
MagikarpCavernsName: db "Magikarp Caverns@"
LaurelForestName:    db "Laurel Forest@"
MilosCatacombsName:  db "Milos Catacombs@"
ProvincialParkName:  db "Provincial Park@"
MagmaCavernsName:    db "Firelight Caverns@"
NaljoRuinsName:      db "Naljo Ruins@"
ClathriteTunnelName: db "Clathrite Tunnel@"
AcquaMinesName:      db "Acqua Mines@"
NaljoBorderName:     db "Naljo Border@"
ChampionIsleName:    db "Battle Arcade@"
TunnelName:          db "Tunnel@"
BattleTowerName:     db "Battle Tower@"
SeashoreCityName:    db "Seashore City@"
GravelTownName:      db "Gravel Town@"
MersonCityName:      db "Merson City@"
HaywardCityName:     db "Hayward City@"
OwsauriCityName:     db "Owsauri City@"
MoragaTownName:      db "Moraga Town@"
JaeruCityName:       db "Jaeru City@"
BotanCityName:       db "Botan City@"
CastroValleyName:    db "Castro Valley@"
EagulouCityName:     db "Eagulou City@"
RijonLeagueName:     db "Rijon League@"
MersonCaveName:      db "Merson Cave@"
RijonUnderground:    db "Rijon Underground@"
SilkTunnelName:      db "Silk Tunnel@"
PowerPlantName:      db "Power Plant@"
SilphWarehouseName:  db "Silph Warehouse@"
HauntedForestName:   db "Haunted Forest@"
CastroMansionName:   db "Castro Mansion@"
CastroForestName:    db "Castro Forest@"
RijonHideoutName:    db "Rijon Hideout@"
EagulouParkName      db "Eagulou Park@"
MtBoulderName:       db "Mt. Boulder@"
SenecaCavernsName:   db "Seneca Caverns@"

AzaleaTownName:      db "Azalea Town@"
GoldenrodCityName:   db "Goldenrod City@"
GoldenrodCapeName:   db "Goldenrod Cape@"
IlexForestName:      db "Ilex Forest@"
SlowpokeWellName:    db "Slowpoke Well@"
SaffronCityName:     db "Saffron City@"
EmberBrookName:      db "Ember Brook@"
MtEmberName:         db "Mt. Ember@"
KindleRoadName:      db "Kindle Road@"
TunodWaterwayName:   db "Tunod Waterway@"
SouthSoutherlyName:  db "South Southerly@"
SoutherlyCityName:   db "Southerly City@"
MysteryZoneName:     db "Mystery Zone@"

Route34Name:         db "Route 34@"
Route47Name:         db "Route 47-B@"
Route48Name:         db "Route 48-B@"
Route49Name:         db "Route 49@"
Route50Name:         db "Route 50@"
Route51Name:         db "Route 51@"
Route52Name:         db "Route 52@"
Route53Name:         db "Route 53@"
Route54Name:         db "Route 54@"
Route55Name:         db "Route 55@"
Route56Name:         db "Route 56@"
Route57Name:         db "Route 57@"
Route58Name:         db "Route 58@"
Route59Name:         db "Route 59@"
Route60Name:         db "Route 60@"
Route61Name:         db "Route 61@"
Route62Name:         db "Route 62@"
Route63Name:         db "Route 63@"
Route64Name:         db "Route 64@"
Route65Name:         db "Route 65@"
Route66Name:         db "Route 66@"
Route67Name:         db "Route 67@"
Route68Name:         db "Route 68@"
Route69Name:         db "Route 69@"
Route70Name:         db "Route 70@"
Route71Name:         db "Route 71@"
Route72Name:         db "Route 72@"
Route73Name:         db "Route 73@"
Route74Name:         db "Route 74@"
Route75Name:         db "Route 75@"
Route76Name:         db "Route 76@"
Route77Name:         db "Route 77@"
Route78Name:         db "Route 78@"
Route79Name:         db "Route 79@"
Route80Name:         db "Route 80@"
Route81Name:         db "Route 81@"
Route82Name:         db "Route 82@"
Route83Name:         db "Route 83@"
Route84Name:         db "Route 84@"
Route85Name:         db "Route 85@"
Route86Name:         db "Route 86@"
Route87Name:         db "Route 87@"
FarawayIslandName:	 db "Faraway Island@"

RegionCheck:
; Checks the region stores in E
; Naljo: 0
; Rijon: 1
; Johto: 2
; Kanto: 3
; Sevii: 4
; Tunod: 5
; Mystery Zone: 6
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
	call GetWorldMapLocation
	cp DUMMY4 ; S.S. Aqua
	ld e, REGION_RIJON
	ret z
	and a ; cp SPECIAL_MAP
	jr nz, .checkagain

; In a special map, get the backup map group / map id
	ld a, [BackupMapGroup]
	ld b, a
	ld a, [BackupMapNumber]
	ld c, a
	call GetWorldMapLocation

.checkagain
	ld e, REGION_MYSTERY
	cp $ff
	ret z ; landmark ID of $ff defaults to Mystery Zone
	ld e, REGION_NALJO ; 0
	ld hl, .Thresholds
.loop
	cp [hl]
	ret c
	inc e
	inc hl
	jr .loop

.Thresholds:
	db RIJON_LANDMARK
	db JOHTO_LANDMARK
	db KANTO_LANDMARK
	db SEVII_LANDMARK
	db TUNOD_LANDMARK
	db MYSTERY_LANDMARK
	db $ff
