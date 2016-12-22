EngineFlagAction:: ; 80430
; Do action b on engine flag de
;
;   b = 0: reset flag
;     = 1: set flag
;     > 1: check flag, result in c
;
; Setting/resetting does not return a result.


; 16-bit flag ids are considered invalid, but it's nice
; to know that the infrastructure is there.

	ld a, d
	cp NUM_ENGINE_FLAGS / $100 ; fixed to actually allow 16-bit flag IDs if the need ever arises
	jr z, .ceiling
	jr c, .read
	jr .invalid

; There are only $a2 engine flags, so
; anything beyond that is invalid too.

.ceiling
	ld a, e
	cp NUM_ENGINE_FLAGS % $100
	jr c, .read

; Invalid flags are treated as flag 00.

.invalid
	xor a
	ld e, a
	ld d, a

; Get this flag's location.

.read
	ld hl, EngineFlags
; location
	add hl, de
	add hl, de
; bit
	add hl, de

; location
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
; bit
	ld c, [hl]

; What are we doing with this flag?

	ld a, b
	cp 1
	jr c, .reset ; b = 0
	jr z, .set   ; b = 1

; Return the given flag in c.
.check
	ld a, [de]
	and c
	ld c, a
	ret

; Set the given flag.
.set
	ld a, [de]
	or c
	ld [de], a
	ret

; Reset the given flag.
.reset
	ld a, c
	cpl ; AND all bits except the one in question
	ld c, a
	ld a, [de]
	and c
	ld [de], a
	ret
; 80462


EngineFlags: ; 80462
; All locations are in WRAM bank 1.

	engine_flag ENGINE_HAS_MAP
	engine_flag ENGINE_DAYCARE_MAN_HAS_EGG
	engine_flag ENGINE_DAYCARE_MAN_HAS_MON
	engine_flag ENGINE_DAYCARE_LADY_HAS_MON
	engine_flag ENGINE_MOM_SAVING_MONEY
	engine_flag ENGINE_DST
	engine_flag ENGINE_TIME_ENABLED
	engine_flag ENGINE_POKEDEX
	engine_flag ENGINE_POKEMON_MODE
	engine_flag ENGINE_CUSTOM_PLAYER_SPRITE
	engine_flag ENGINE_POKERUS
	engine_flag ENGINE_USE_TREASURE_BAG
	engine_flag ENGINE_CREDITS_SKIP
	engine_flag ENGINE_BUG_CONTEST_ON ; 10
	engine_flag ENGINE_PARK_MINIGAME
	engine_flag ENGINE_SAFARI_ZONE
	engine_flag ENGINE_ROCKETS_IN_RADIO_TOWER
	engine_flag ENGINE_BIKE_SHOP_CALL_ENABLED
	engine_flag ENGINE_GIVE_POKERUS
	engine_flag ENGINE_FLORIA
	engine_flag ENGINE_ROCKETS_IN_MAHOGANY
	engine_flag ENGINE_STRENGTH_ACTIVE
	engine_flag ENGINE_ALWAYS_ON_BIKE
	engine_flag ENGINE_DOWNHILL
	engine_flag ENGINE_PYREBADGE
	engine_flag ENGINE_NATUREBADGE
	engine_flag ENGINE_GULFBADGE
	engine_flag ENGINE_ELECTRONBADGE
	engine_flag ENGINE_MUSCLEBADGE
	engine_flag ENGINE_HAZEBADGE ; 20
	engine_flag ENGINE_RAUCOUSBADGE
	engine_flag ENGINE_NALJOBADGE
	engine_flag ENGINE_MARINEBADGE
	engine_flag ENGINE_HAILBADGE
	engine_flag ENGINE_SPROUTBADGE
	engine_flag ENGINE_SPARKYBADGE
	engine_flag ENGINE_FISTBADGE
	engine_flag ENGINE_PSIBADGE
	engine_flag ENGINE_WHITEBADGE
	engine_flag ENGINE_STARBADGE
	engine_flag ENGINE_HIVEBADGE
	engine_flag ENGINE_PLAINBADGE
	engine_flag ENGINE_MARSHBADGE
	engine_flag ENGINE_BLAZEBADGE
	engine_flag ENGINE_FLASH
	engine_flag ENGINE_WILDS_DISABLED
	engine_flag ENGINE_UNUSED_3
	engine_flag ENGINE_UNUSED_4
	engine_flag ENGINE_FLYPOINT_START
	engine_flag ENGINE_FLYPOINT_CAPER_CITY
	engine_flag ENGINE_FLYPOINT_OXALIS_CITY
	engine_flag ENGINE_FLYPOINT_SPURGE_CITY
	engine_flag ENGINE_FLYPOINT_HEATH_VILLAGE
	engine_flag ENGINE_FLYPOINT_LAUREL_CITY
	engine_flag ENGINE_FLYPOINT_TORENIA_CITY
	engine_flag ENGINE_FLYPOINT_PHACELIA_TOWN
	engine_flag ENGINE_FLYPOINT_ACANIA_DOCKS
	engine_flag ENGINE_FLYPOINT_SAXIFRAGE_ISLAND
	engine_flag ENGINE_FLYPOINT_PHLOX_TOWN
	engine_flag ENGINE_FLYPOINT_BATTLE_ARCADE
	engine_flag ENGINE_FLYPOINT_SEASHORE_CITY
	engine_flag ENGINE_FLYPOINT_GRAVEL_TOWN ; 40
	engine_flag ENGINE_FLYPOINT_MERSON_CITY
	engine_flag ENGINE_FLYPOINT_HAYWARD_CITY
	engine_flag ENGINE_FLYPOINT_OWSAURI_CITY
	engine_flag ENGINE_FLYPOINT_MORAGA_TOWN
	engine_flag ENGINE_FLYPOINT_JAERU_CITY
	engine_flag ENGINE_FLYPOINT_BOTAN_CITY
	engine_flag ENGINE_FLYPOINT_CASTRO_VALLEY
	engine_flag ENGINE_FLYPOINT_EAGULOU_CITY
	engine_flag ENGINE_FLYPOINT_RIJON_LEAGUE
	engine_flag ENGINE_FLYPOINT_SENECA_CAVERNS
	engine_flag ENGINE_FLYPOINT_AZALEA_TOWN
	engine_flag ENGINE_FLYPOINT_GOLDENROD_CITY
	engine_flag ENGINE_FLYPOINT_SOUTHERLY_CITY
	engine_flag ENGINE_LUCKY_NUMBER_SHOW
	engine_flag ENGINE_4F
	engine_flag ENGINE_KURT_MAKING_BALLS ; 50
	engine_flag ENGINE_DAILY_BUG_CONTEST
	engine_flag ENGINE_SPECIAL_WILDDATA
	engine_flag ENGINE_TIME_CAPSULE
	engine_flag ENGINE_ALL_FRUIT_TREES
	engine_flag ENGINE_SHUCKLE_GIVEN
	engine_flag ENGINE_GOLDENROD_UNDERGROUND_MERCHANT_CLOSED
	engine_flag ENGINE_FOUGHT_IN_TRAINER_HALL_TODAY
	engine_flag ENGINE_MT_MOON_SQUARE_CLEFAIRY
	engine_flag ENGINE_UNION_CAVE_LAPRAS
	engine_flag ENGINE_GOLDENROD_UNDERGROUND_GOT_HAIRCUT
	engine_flag ENGINE_GOLDENROD_MALL_5F_HAPPINESS_EVENT
	engine_flag ENGINE_TEA_IN_BLUES_HOUSE
	engine_flag ENGINE_INDIGO_PLATEAU_RIVAL_FIGHT
	engine_flag ENGINE_DAILY_MOVE_TUTOR
	engine_flag ENGINE_BUENAS_PASSWORD
	engine_flag ENGINE_BUENAS_PASSWORD_2 ; 60
	engine_flag ENGINE_GOLDENROD_DEPT_STORE_SALE_IS_ON
	engine_flag ENGINE_62
	engine_flag ENGINE_PLAYER_IS_FEMALE
	engine_flag ENGINE_HAVE_EXAMINED_GS_BALL
	engine_flag ENGINE_KRIS_IN_CABLE_CLUB
	engine_flag ENGINE_DUNSPARCE_SWARM ; a0
	engine_flag ENGINE_YANMA_SWARM
