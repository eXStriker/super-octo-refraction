GetEmote2bpp:
	ld a, $1
	ld [rVBK], a
	call Get2bpp
	xor a
	ld [rVBK], a
	ret

_ReplaceKrisSprite::
	call GetPlayerSprite
	ld a, [UsedSprites]
	ld [hUsedSpriteIndex], a
	ld a, [UsedSprites + 1]
	ld [hUsedSpriteTile], a
	jp GetUsedSprite

RefreshSprites::
	xor a
	ld bc, UsedSpritesEnd - UsedSprites
	ld hl, UsedSprites
	call ByteFill
	call GetPlayerSprite
	call AddMapSprites
	call LoadAndSortSprites
	jp RunCallback_04

GetPlayerSprite:
; Get Chris or Kris's sprite.
	CheckEngine ENGINE_CUSTOM_PLAYER_SPRITE
	ld a, [PlayerSprite]
	jr nz, .finishCustomSprite
	CheckEngine ENGINE_POKEMON_MODE
	jr nz, .GetPlayerSprite_PokemonMode
	ld hl, .Male0
	CheckEngine ENGINE_KRIS_IN_CABLE_CLUB
	jr nz, .go
	ld a, [wPlayerCharacteristics]
	and $f
	jr z, .go
	cp 14
	jr nc, .go
	ld e, a
	ld d, 0
	; add 9 times
	add hl, de
	swap e
	srl e
	add hl, de
.go
	ld a, [PlayerState]
	ld e, 2
	call IsInArray
	inc hl
	jr c, .good
; Any player state not in the array defaults to Chris's sprite.
	xor a ; ld a, PLAYER_NORMAL
	ld [PlayerState], a
.fail
	ld a, SPRITE_P0
	jr .finish

.GetPlayerSprite_PokemonMode
	ld a, [wPokeonlyMainSpecies]
	and a
	jr nz, .get_pkmn_sprite
	ld hl, wPartyMon1 + MON_HP
	ld de, wPartySpecies
	ld bc, PARTYMON_STRUCT_LENGTH - 1
	jr .handleLoop

.nextMon
	inc de
	add hl, bc
.handleLoop
	ld a, [de]
	and a
	jr z, .fail
	cp $ff
	jr z, .fail
	cp EGG
	jr z, .nextMon
	ld a, [hli]
	or [hl]
	jr z, .nextMon
	ld bc, MON_DVS - (MON_HP + 1)
	add hl, bc
	ld bc, wPokeonlyMainDVs
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hl]
	ld [bc], a
	ld a, [de]
	ld [wPokeonlyMainSpecies], a
.get_pkmn_sprite
	ld a, SPRITE_POKEMON - 1
	jr .finish

.good
	ld a, [hl]
.finish
	ld [PlayerSprite], a
.finishCustomSprite
	ld [UsedSprites + 0], a
	ld [PlayerObjectSprite], a
	ret

.PlayerSprites
.Male0
	db PLAYER_NORMAL,    SPRITE_P0
	db PLAYER_BIKE,      SPRITE_P0_BIKE
	db PLAYER_SURF,      SPRITE_P0_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.Female0
	db PLAYER_NORMAL,    SPRITE_P1
	db PLAYER_BIKE,      SPRITE_P1_BIKE
	db PLAYER_SURF,      SPRITE_P1_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.Male1
	db PLAYER_NORMAL,    SPRITE_P2
	db PLAYER_BIKE,      SPRITE_P2_BIKE
	db PLAYER_SURF,      SPRITE_P2_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.Female1
	db PLAYER_NORMAL,    SPRITE_P3
	db PLAYER_BIKE,      SPRITE_P3_BIKE
	db PLAYER_SURF,      SPRITE_P3_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.Male2
	db PLAYER_NORMAL,    SPRITE_P4
	db PLAYER_BIKE,      SPRITE_P4_BIKE
	db PLAYER_SURF,      SPRITE_P4_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.Female2
	db PLAYER_NORMAL,    SPRITE_P5
	db PLAYER_BIKE,      SPRITE_P5_BIKE
	db PLAYER_SURF,      SPRITE_P5_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.Male3
	db PLAYER_NORMAL,    SPRITE_P6
	db PLAYER_BIKE,      SPRITE_P6_BIKE
	db PLAYER_SURF,      SPRITE_P6_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.Female3
	db PLAYER_NORMAL,    SPRITE_P7
	db PLAYER_BIKE,      SPRITE_P7_BIKE
	db PLAYER_SURF,      SPRITE_P7_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.Male4
	db PLAYER_NORMAL,    SPRITE_P8
	db PLAYER_BIKE,      SPRITE_P8_BIKE
	db PLAYER_SURF,      SPRITE_P8_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.Female4
	db PLAYER_NORMAL,    SPRITE_P9
	db PLAYER_BIKE,      SPRITE_P9_BIKE
	db PLAYER_SURF,      SPRITE_P9_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.Male5
	db PLAYER_NORMAL,    SPRITE_P10
	db PLAYER_BIKE,      SPRITE_P10_BIKE
	db PLAYER_SURF,      SPRITE_P10_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.Female5
	db PLAYER_NORMAL,    SPRITE_P11
	db PLAYER_BIKE,      SPRITE_P11_BIKE
	db PLAYER_SURF,      SPRITE_P11_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.PalettePatroller
	db PLAYER_NORMAL,    SPRITE_PALETTE_PATROLLER
	db PLAYER_BIKE,      SPRITE_P12_BIKE
	db PLAYER_SURF,      SPRITE_P12_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.PalettePatrollerF
	db PLAYER_NORMAL,    SPRITE_PALETTE_PATROLLER
	db PLAYER_BIKE,      SPRITE_P12_BIKE
	db PLAYER_SURF,      SPRITE_P12_BIKE
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

AddMapSprites:
	call GetMapPermission
	call CheckOutdoorMap
	jp z, .outdoor
	ld hl, Map1ObjectSprite
	ld a, 1
.loop
	push af
	ld a, [hl]
	call AddSpriteGFX
	ld de, OBJECT_LENGTH
	add hl, de
	pop af
	inc a
	cp NUM_OBJECTS
	jr nz, .loop
	ret

.outdoor:
	ld a, [MapGroup]
	dec a
	ld c, a
	ld b, 0
	ld hl, OutdoorSprites
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld c, MAX_OUTDOOR_SPRITES
.loop2
	push bc
	ld a, [hli]
	call AddSpriteGFX
	pop bc
	dec c
	jr nz, .loop2
	ret

RunCallback_04:
	ld a, MAPCALLBACK_SPRITES
	call RunMapCallback
	call GetUsedSprites

	ld c, EMOTE_SHADOW
	call LoadEmote
	call GetMapPermission
	call CheckOutdoorMap
	ld c, EMOTE_0B
	jr z, .outdoor
	ld c, EMOTE_BOULDER_DUST
.outdoor
	jp LoadEmote

GetSpriteHeaderFromFar:
	ld a, b
GetSprite:
	call GetMonSprite
	ret c

	ld hl, SpriteHeaders ; address
	dec a
	ld bc, 6
	rst AddNTimes
	; load the address into de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	; load the length into c
	ld a, [hli]
	swap a
	ld c, a
	; load the sprite bank into both b
	ld b, [hl]
	inc hl
	; load the sprite type into l and the default palette into h
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

GetMonSprite:
; Return carry if a monster sprite was loaded.
	cp SPRITE_POKEMON - 1
	jp z, .WalkingPokemon
	cp SPRITE_POKEMON
	jr c, .Normal
	cp SPRITE_DAYCARE_MON_1
	jr z, .wBreedMon1
	cp SPRITE_DAYCARE_MON_2
	jr z, .wBreedMon2
	cp SPRITE_VARS
	jr nc, .Variable
; icon
	sub SPRITE_POKEMON
	ld e, a
	ld d, 0
	ld hl, SpriteMons
	add hl, de
	ld a, [hl]
	jr .NPCPokemon

.wBreedMon1
	ld a, [wBreedMon1Species]
	jr .Mon

.wBreedMon2
	ld a, [wBreedMon2Species]

.Mon
	and a
	jr z, .NoBreedmon
	jr .NPCPokemon

.Variable
	sub SPRITE_VARS
	ld e, a
	ld d, 0
	ld hl, VariableSprites
	add hl, de
	ld a, [hl]
	and a
	jp nz, GetMonSprite

.NoBreedmon
	ld a, SPRITE_P0
	lb hl, PAL_OW_PLAYER, WALKING_SPRITE

.Normal
	and a
	ret

.WalkingPokemon
	ld a, [wPokeonlyMainSpecies]
.NPCPokemon
	dec a
	ld e, a
	ld d, 0
	ld hl, PokemonOWSpritePointers
	add hl, de
	add hl, de
	add hl, de
	ld a, BANK(PokemonOWSpritePointers)
	call GetFarByteHalfword
	ld b, a
	ld d, h
	ld e, l
	ld c, 12
	lb hl, PAL_OW_PLAYER, WALKING_SPRITE
	scf
	ret

_DoesSpriteHaveFacings::
; Checks to see whether we can apply a facing to a sprite.
; Returns carry unless the sprite is a Pokemon or a Still Sprite.
	ld a, b
_DoesSpriteHaveFacings_IDInA:
	cp SPRITE_POKEMON - 1
	jr z, .has_facings
	cp SPRITE_POKEMON
	jr nc, .has_facings

	push hl
	push bc
	ld hl, SpriteHeaders + SPRITEHEADER_TYPE ; type
	dec a
	ld c, a
	ld b, 0
	ld a, NUM_SPRITEHEADER_FIELDS
	rst AddNTimes
	ld a, [hl]
	pop bc
	pop hl
	cp STILL_SPRITE
	jr nz, .has_facings
	scf
	ret

.has_facings
	and a
	ret

LoadAndSortSprites:
	call LoadSpriteGFX
	call SortUsedSprites
	jp ArrangeUsedSprites

AddSpriteGFX:
; Add any new sprite ids to a list of graphics to be loaded.
; Return carry if the list is full.

	push hl
	push bc
	ld b, a
	ld hl, UsedSprites + 2
	ld c, SPRITE_GFX_LIST_CAPACITY - 1
.loop
	ld a, [hl]
	and a
	jr z, .new
	cp b
	jr nz, .next
	inc hl
	ld a, [hld]
	cp d
	jr z, .exists
.next
	inc hl
	inc hl
	dec c
	jr nz, .loop

	pop bc
	pop hl
	scf
	ret

.new
	ld [hl], b
	inc hl
	ld [hl], d
.exists
	pop bc
	pop hl
	and a
	ret

LoadSpriteGFX:
; Bug: b is not preserved, so
; it's useless as a next count.

	ld hl, UsedSprites
	ld b, SPRITE_GFX_LIST_CAPACITY
.loop
	ld a, [hli]
	and a
	ret z
	push hl
	push bc
	call GetSprite
	ld a, l
	pop bc
	pop hl
	ld [hli], a
	dec b
	jr nz, .loop
	ret

SortUsedSprites:
; Bubble-sort sprites by type.

; Run backwards through UsedSprites to find the last one.

	ld c, SPRITE_GFX_LIST_CAPACITY
	ld de, UsedSprites + (SPRITE_GFX_LIST_CAPACITY - 1) * 2
.FindLastSprite
	ld a, [de]
	and a
	jr nz, .FoundLastSprite
	dec de
	dec de
	dec c
	jr nz, .FindLastSprite
.FoundLastSprite
	dec c
	ret z

; If the length of the current sprite is
; higher than a later one, swap them.

	inc de
	ld hl, UsedSprites + 1

.CheckSprite
	push bc
	push de
	push hl

.CheckFollowing
	ld a, [de]
	cp [hl]
	jr nc, .loop

; Swap the two sprites.

	ld b, a
	ld a, [hl]
	ld [hl], b
	ld [de], a
	dec de
	dec hl
	ld a, [de]
	ld b, a
	ld a, [hl]
	ld [hl], b
	ld [de], a
	inc de
	inc hl

; Keep doing this until everything's in order.

.loop
	dec de
	dec de
	dec c
	jr nz, .CheckFollowing

	pop hl
	inc hl
	inc hl
	pop de
	pop bc
	dec c
	jr nz, .CheckSprite

	ret

ArrangeUsedSprites:
; Get the length of each sprite and space them out in VRAM.
; Crystal introduces a second table in VRAM bank 0.

	ld hl, UsedSprites
	ld c, SPRITE_GFX_LIST_CAPACITY
	ld b, 0
.FirstTableLength
; Keep going until the end of the list.
	ld a, [hli]
	and a
	ret z

	ld a, [hl]
	call GetSpriteLength

; Spill over into the second table after $80 tiles.
	add b
	cp $80
	jr z, .loop
	jr nc, .SecondTable

.loop
	ld [hl], b
	inc hl
	ld b, a

; Assumes the next table will be reached before c hits 0.
	dec c
	jr nz, .FirstTableLength

.SecondTable
; The second tile table starts at tile $80.
	ld b, $80
	dec hl
.SecondTableLength
; Keep going until the end of the list.
	ld a, [hli]
	and a
	ret z

	ld a, [hl]
	call GetSpriteLength

; There are only two tables, so don't go any further than that.
	add b
	ret c

	ld [hl], b
	ld b, a
	inc hl

	dec c
	jr nz, .SecondTableLength

	ret

GetSpriteLength:
; Return the length of sprite type a in tiles.
	cp STILL_SPRITE
	ld a, 4
	ret z
	ld a, 12
	ret

GetUsedSprites:
	ld hl, UsedSprites
	ld c, SPRITE_GFX_LIST_CAPACITY

.loop
	xor a
	ld [wSpriteFlags], a

	ld a, [hli]
	and a
	ret z
	ld [hUsedSpriteIndex], a

	ld a, [hli]
	ld [hUsedSpriteTile], a

	rlca
	and $1
	ld [wSpriteFlags], a

	push bc
	push hl
	call GetUsedSprite
	pop hl
	pop bc
	dec c
	jr nz, .loop

	ret

GetUsedSprite::
	ld a, [hUsedSpriteIndex]
	push hl
	call GetSprite
	push bc
	ld h, d
	ld l, e
	ld a, b
	call FarDecompressWRA6
	pop bc
	pop hl

	ld a, [hUsedSpriteTile]
	call .GetTileAddr
	push hl
	push bc
	ld de, wDecompressScratch
	call .CopyToVram
	pop bc
	pop hl

	ld a, [wSpriteFlags]
	and a
	ret nz

	ld a, [hUsedSpriteIndex]
	call _DoesSpriteHaveFacings_IDInA
	ret c

	ld e, c
	swap e
	ld a, e
	and $f
	add (wDecompressScratch >> 8)
	ld d, a
	ld a, e
	and $f0
	ld e, a

	ld a, h
	add (VTiles1 - VTiles0) >> 8
	ld h, a

.CopyToVram:
	ld a, [rVBK]
	push af
	ld a, [wSpriteFlags]
	xor 1
	ld [rVBK], a
	call Request2bppInWRA6
	pop af
	ld [rVBK], a
	ret

.GetTileAddr
; Return the address of tile (a) in (hl).
	and $7f
	ld l, a
	ld h, (VTiles0 >> 12)
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ret

LoadEmote::
; Get the address of the pointer to emote c.
	ld a, c
	ld bc, 8
	ld hl, EmotesPointers
	rst AddNTimes
; Load the SFX into RAM
	ld a, [hli]
	and a
	ld [wEmoteSFX], a
	ld a, [hli]
	ld [wEmoteSFX + 1], a
	jr nz, .okay
	ld [wPlayEmoteSFX], a
.okay
; Load the emote address into de
	ld e, [hl]
	inc hl
	ld d, [hl]
; load the length of the emote (in tiles) into c
	inc hl
	ld c, [hl]
	swap c
; load the emote pointer bank into b
	inc hl
	ld b, [hl]
; load the VRAM destination into hl
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
; if the emote has a length of 0, do not proceed (error handling)
	ld a, c
	and a
	ret z
	jp GetEmote2bpp

emote_header: MACRO
	dw \1, \2
	db \3 tiles, BANK(\2)
	dw VTiles1 tile \4
ENDM

EmotesPointers:
; dw source address
; db length, bank
; dw dest address

	emote_header SFX_GLASS_TING, ShockEmote,     4, $78
	emote_header SFX_SQUEAK,     QuestionEmote,  4, $78
	emote_header SFX_SWEET_KISS, HappyEmote,     4, $78
	emote_header SFX_POISON,     SadEmote,       4, $78
	emote_header SFX_UNKNOWN_7F, HeartEmote,     4, $78
	emote_header SFX_THUNDER,    BoltEmote,      4, $78
	emote_header SFX_TAIL_WHIP,  SleepEmote,     4, $78
	emote_header SFX_2_BOOPS,    FishEmote,      4, $78
	emote_header 0,              JumpShadowGFX,  1, $7c
	emote_header 0,              FishingRodGFX2, 2, $7c
	emote_header 0,              BoulderDustGFX, 2, $7e
	emote_header 0,              FishingRodGFX4, 2, $7e

SpriteMons:
	db BAGON
	db CATERPIE
	db METAPOD
	db BUTTERFREE
	db WARTORTLE
	db CHARIZARD
	db XATU
	db SURSKIT
	db TOTODILE
	db GENGAR
	db EGG
	db MACHOKE
	db GROUDON
	db AGGRON
	db FAMBACO
	db ELECTABUZZ
	db RAICHU
	db FLAAFFY
	db BRONZONG
	db HARIYAMA
	db METAGROSS
	db KYOGRE
	db RHYDON
	db MOLTRES
	db TYPHLOSION
	db FEAROW
	db PIDGEOT
	db SWELLOW
	db ARTICUNO
	db PHANCERO
	db HITMONCHAN
	db GLACEON
	db BLASTOISE
	db MAGMORTAR
	db AMPHAROS
	db MILOTIC
	db LIBABEEL
	db RAIWATO
	db ABRA
	db PIKACHU
	db CHARMANDER
	db LARVITAR
	db VARANEOUS
	db RAYQUAZA

OutdoorSprites:
; Valid sprite IDs for each map group.
	dw IntroSprites
	dw CaperCitySprites
	dw OxalisCitySprites ;3
	dw SpurgeCitySprites ;4
	dw HeathVillageSprites ;5
	dw LaurelCitySprites ;6
	dw ToreniaCitySprites ;7
	dw PhaceliaTownSprites
	dw SaxifrageIslandSprites
	dw PhloxTownSprites
	dw AcaniaDocksSprites
	dw AcaniaDocksSprites
	dw HeathVillageSprites ;Route 69
	dw CaperCitySprites ;Route 70
	dw CaperCitySprites ;Route 71
	dw OxalisCitySprites ;72
	dw ToreniaCitySprites ;73
	dw SpurgeCitySprites ;74
	dw SpurgeCitySprites ;75
	dw LaurelCitySprites ;76
	dw Route77Sprites ;77
	dw PhaceliaTownSprites ;78
	dw Route85Sprites ;79
	dw SaxifrageIslandSprites ;80
	dw Route81Sprites ;81
	dw AcaniaDocksSprites ;82
	dw ToreniaCitySprites ;83
	dw Route84Sprites ;84
	dw Route85Sprites ;85
	dw Route86Sprites ;86
	dw Group13Sprites ;Acqua Mines
	dw Group13Sprites ;Mound Cave
	dw LaurelForestSprites ;Laurel Forest
	dw Group13Sprites ;Milos Catacombs
	dw Group13Sprites ;Municipal Park
	dw Group13Sprites ;Magma Caverns
	dw Group13Sprites ;Naljo Ruins
	dw Group13Sprites ;Clathrite Tunnel
	dw Group13Sprites ;Naljo Border
	dw Group13Sprites ;Champion Isle
	dw Group13Sprites ;Long Tunnel
	dw SeashoreGravelSprites ; Seashore
	dw SeashoreGravelSprites ; Gravel
	dw MersonCitySprites ;  Merson
	dw HaywardCitySprites ;  Hayward
	dw OwsauriCitySprites ;  46
	dw MoragaTownSprites ;  47
	dw JaeruCitySprites ;  48
	dw BotanCitySprites ;  49
	dw CastroValleySprites ;  50
	dw EagulouLeagueSprites ;  51
	dw RijonLeagueSprites ;  52
	dw OwsauriCitySprites ;  53
	dw OwsauriCitySprites ;  54
	dw OwsauriCitySprites ;  55
	dw HaywardCitySprites ;  56
	dw HaywardCitySprites ;  57
	dw SeashoreGravelSprites ;  58
	dw SeashoreGravelSprites ;  59
	dw MersonCitySprites ; 60
	dw MersonCitySprites ; 61
	dw EagulouLeagueSprites ;  62
	dw CastroValleySprites ;  63
	dw CastroValleySprites ;  64
	dw JaeruCitySprites ;  65
	dw MoragaTownSprites ;  66
	dw EagulouLeagueSprites ;  67
	dw EagulouLeagueSprites ;  68
	dw HaywardCitySprites ;  69
	dw HaywardCitySprites ;  70
	dw RijonLeagueSprites ;  71
	dw OwsauriCitySprites ;  72
	dw EagulouLeagueSprites ;  73
	dw Group13Sprites ;  74
	dw Group13Sprites ;  75
	dw Group13Sprites ;  76
	dw Group13Sprites ;  77
	dw Group13Sprites ;  78
	dw Group13Sprites ;  79
	dw Group13Sprites ;  80
	dw AzaleaTownSprites ;  81
	dw Group13Sprites ;  82
	dw GoldenrodSprites ;  83
	dw GoldenrodSprites ;  84
	dw SaffronSprites ;  85
	dw SaffronSprites ;  86
	dw SaffronSprites ;  87
	dw SaffronSprites ;  88
	dw SoutherlySprites ;  89
	dw SoutherlySprites ;  90
	dw SoutherlySprites ;  91
	dw CaperCitySprites ;  92
	dw CaperCitySprites ;  93
	dw CaperCitySprites ;  94

SoutherlySprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_COOLTRAINER_F
	db SPRITE_LASS
	db SPRITE_SWIMMER_GUY
	db SPRITE_SWIMMER_GIRL
	db SPRITE_FISHER
	db SPRITE_BLACK_BELT
	db SPRITE_OFFICER
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
	db SPRITE_TYPHLOSION

SaffronSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_COOLTRAINER_F
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_POKEFAN_M
	db SPRITE_FISHER
	db SPRITE_POKE_BALL
	db SPRITE_MOLTRES

GoldenrodSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_COOLTRAINER_F
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_POKEFAN_M
	db SPRITE_GRAMPS
	db SPRITE_OFFICER
	db SPRITE_POKE_BALL
	db SPRITE_ROCK

AzaleaTownSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_YOUNGSTER
	db SPRITE_TEACHER
	db SPRITE_GRAMPS
	db SPRITE_FRUIT_TREE

RijonLeagueSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_LANCE
	db SPRITE_MOM
	db SPRITE_FIRE
	db SPRITE_SILVER

EagulouLeagueSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_SWIMMER_GUY
	db SPRITE_SWIMMER_GIRL
	db SPRITE_FISHER
	db SPRITE_SAGE
	db SPRITE_GENTLEMAN
	db SPRITE_BLACK_BELT
	db SPRITE_POKE_BALL

CastroValleySprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_YOUNGSTER
	db SPRITE_ROCKER
	db SPRITE_POKEFAN_F
	db SPRITE_FISHING_GURU
	db SPRITE_SAGE
	db SPRITE_SAILOR

BotanCitySprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_YOUNGSTER
	db SPRITE_ROCKER
	db SPRITE_POKEFAN_F
	db SPRITE_FISHER
	db SPRITE_FISHING_GURU
	db SPRITE_SAGE

JaeruCitySprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_COOLTRAINER_M
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_FISHER
	db SPRITE_SAGE
	db SPRITE_PHARMACIST
	db SPRITE_FIREBREATHER
	db SPRITE_JUGGLER
	db SPRITE_POKE_BALL

MoragaTownSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_COOLTRAINER_M
	db SPRITE_TEACHER
	db SPRITE_POKEFAN_F
	db SPRITE_SAGE
	db SPRITE_POKE_BALL

OwsauriCitySprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_LASS
	db SPRITE_SUPER_NERD
	db SPRITE_SWIMMER_GUY
	db SPRITE_SWIMMER_GIRL
	db SPRITE_FISHER
	db SPRITE_KIMONO_GIRL
	db SPRITE_BIKER
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE

HaywardCitySprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_BUG_CATCHER
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_PALETTE_PATROLLER
	db SPRITE_FISHER
	db SPRITE_GYM_GUY
	db SPRITE_PHARMACIST
	db SPRITE_POKE_BALL
	db SPRITE_ROCK
	db SPRITE_FRUIT_TREE

MersonCitySprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_COOLTRAINER_F
	db SPRITE_LASS
	db SPRITE_FISHER
	db SPRITE_FISHING_GURU
	db SPRITE_SAGE
	db SPRITE_GENTLEMAN
	db SPRITE_BLACK_BELT
	db SPRITE_FRUIT_TREE

SeashoreGravelSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_DAISY
	db SPRITE_COOLTRAINER_M
	db SPRITE_YOUNGSTER
	db SPRITE_SUPER_NERD
	db SPRITE_FISHING_GURU
	db SPRITE_POKE_BALL
	db SPRITE_ROCK
	db SPRITE_FRUIT_TREE

Route84Sprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_COOLTRAINER_M
	db SPRITE_BUENA
	db SPRITE_HIKER
	db SPRITE_POKE_BALL
	db SPRITE_BOULDER
	db SPRITE_FRUIT_TREE

PhloxTownSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_COOLTRAINER_M
	db SPRITE_YOUNGSTER
	db SPRITE_POKEFAN_F
	db SPRITE_SURFING_PIKACHU
	db SPRITE_FISHING_GURU
	db SPRITE_OFFICER
	db SPRITE_SLOWPOKE
	db SPRITE_POKE_BALL
	db SPRITE_ROCK
	db SPRITE_FRUIT_TREE
	db SPRITE_PALETTE_PATROLLER
	db SPRITE_PAPER

Route81Sprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_COOLTRAINER_M
	db SPRITE_COOLTRAINER_F
	db SPRITE_YOUNGSTER
	db SPRITE_FISHER
	db SPRITE_BLACK_BELT
	db SPRITE_BIRDKEEPER
	db SPRITE_PICNICKER
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE

AcaniaDocksSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_COOLTRAINER_F
	db SPRITE_LASS
	db SPRITE_POKEFAN_M
	db SPRITE_GRAMPS
	db SPRITE_SWIMMER_GUY
	db SPRITE_SWIMMER_GIRL
	db SPRITE_FISHER
	db SPRITE_OFFICER
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE

SaxifrageIslandSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_COOLTRAINER_M
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_POKEFAN_M
	db SPRITE_SWIMMER_GUY
	db SPRITE_SWIMMER_GIRL
	db SPRITE_FISHER
	db SPRITE_OFFICER
	db SPRITE_PALETTE_PATROLLER
	db SPRITE_POKE_BALL
	db SPRITE_BOULDER

PhaceliaTownSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_LASS
	db SPRITE_SWIMMER_GUY
	db SPRITE_SWIMMER_GIRL
	db SPRITE_FISHER
	db SPRITE_BLACK_BELT
	db SPRITE_OFFICER
	db SPRITE_POKE_BALL
	db SPRITE_ROCK
	db SPRITE_BOULDER
	db SPRITE_FRUIT_TREE
	db SPRITE_MACHOKE

LaurelCitySprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_GRAMPS
	db SPRITE_FISHER
	db SPRITE_TOTODILE
	db SPRITE_TWIN
	db SPRITE_PSYCHIC
	db SPRITE_FIREBREATHER
	db SPRITE_POKE_BALL

HeathVillageSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_COOLTRAINER_F
	db SPRITE_YOUNGSTER
	db SPRITE_POKEFAN_M
	db SPRITE_BLACK_BELT
	db SPRITE_POKE_BALL
	db SPRITE_HIKER
	db SPRITE_COOLTRAINER_M

SpurgeCitySprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_SAILOR
	db SPRITE_POKEFAN_M
	db SPRITE_POKEFAN_F
	db SPRITE_PSYCHIC
	db SPRITE_POKE_BALL
	db SPRITE_SCHOOLBOY
	db SPRITE_LASS
	db SPRITE_BEAUTY
	db SPRITE_BIRDKEEPER
	db SPRITE_FRUIT_TREE

ToreniaCitySprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_PICNICKER
	db SPRITE_BIRDKEEPER
	db SPRITE_BUG_CATCHER
	db SPRITE_JUGGLER
	db SPRITE_FISHER
	db SPRITE_YOUNGSTER
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
	db SPRITE_GRAMPS
	db SPRITE_SCHOOLBOY

OxalisCitySprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_COOLTRAINER_F
	db SPRITE_PICNICKER
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_TEACHER
	db SPRITE_SUPER_NERD
	db SPRITE_ROCKER
	db SPRITE_POKEFAN_M
	db SPRITE_GRAMPS
	db SPRITE_FRUIT_TREE
	db SPRITE_POKE_BALL

CaperCitySprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_YOUNGSTER
	db SPRITE_BUG_CATCHER
	db SPRITE_TEACHER
	db SPRITE_COOLTRAINER_M
	db SPRITE_FISHER
	db SPRITE_HIKER
	db SPRITE_JUGGLER
	db SPRITE_FIREBREATHER
	db SPRITE_FRUIT_TREE
	db SPRITE_POKE_BALL

LaurelForestSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_PIKACHU

Group13Sprites::
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_YOUNGSTER
	db SPRITE_BLUE
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_SWIMMER_GIRL
	db SPRITE_SWIMMER_GUY
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE

IntroSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_MOM
	db SPRITE_FIRE

Route77Sprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_FISHER
	db SPRITE_DAYCARE_MON_1
	db SPRITE_DAYCARE_MON_2
	db SPRITE_YOUNGSTER
	db SPRITE_PICNICKER
	db SPRITE_BOULDER
	db SPRITE_OFFICER
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
	db SPRITE_EGG

Route85Sprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_BIRDKEEPER
	db SPRITE_OFFICER
	db SPRITE_ROCK
	db SPRITE_PALETTE_PATROLLER
	db SPRITE_PSYCHIC
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
	db SPRITE_COOLTRAINER_M
	db SPRITE_POKEFAN_M
	db SPRITE_BLACK_BELT
	db SPRITE_PICNICKER

Route86Sprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SORA
	db SPRITE_YUKI
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_SAILOR
	db SPRITE_YOUNGSTER
	db SPRITE_COOLTRAINER_F

INCLUDE "data/sprite_headers.asm"
