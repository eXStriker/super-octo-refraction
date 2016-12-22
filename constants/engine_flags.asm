	const_def

	def_engine_flag ENGINE_HAS_MAP, wPokegearFlags, 7 ; on/off ; $0

	def_engine_flag ENGINE_DAYCARE_MAN_HAS_EGG, wDaycareMan, 6 ; egg is ready

	def_engine_flag ENGINE_DAYCARE_MAN_HAS_MON, wDaycareMan, 0 ; monster 1 in daycare
	def_engine_flag ENGINE_DAYCARE_LADY_HAS_MON, wDaycareLady, 0 ; monster 2 in daycare

	def_engine_flag ENGINE_MOM_SAVING_MONEY, wBankSavingMoney, 0 ; mom saving money
	def_engine_flag ENGINE_DST, wBankSavingMoney, 7 ; dst

	def_engine_flag ENGINE_TIME_ENABLED, wClockEnabled, 0 ; unused, possibly related to a 2-day timer

	def_engine_flag ENGINE_POKEDEX, wStatusFlags, 0 ; pokedex
	def_engine_flag ENGINE_POKEMON_MODE, wStatusFlags, 1 ; used to tell if we are in pokemon only mode
	def_engine_flag ENGINE_CUSTOM_PLAYER_SPRITE, wStatusFlags, 2
	def_engine_flag ENGINE_POKERUS, wStatusFlags, 3 ; pokerus
	def_engine_flag ENGINE_USE_TREASURE_BAG, wStatusFlags, 4 ; rocket signal on ch20
	def_engine_flag ENGINE_CREDITS_SKIP, wStatusFlags, 6 ; credits skip
	def_engine_flag ENGINE_BUG_CONTEST_ON, wStatusFlags, 7 ; bug contest on

	def_engine_flag ENGINE_PARK_MINIGAME, wStatusFlags2, 2 ; park minigame is on
	def_engine_flag ENGINE_SAFARI_ZONE, wStatusFlags2, 1 ; safari zone?
	def_engine_flag ENGINE_ROCKETS_IN_RADIO_TOWER, wStatusFlags2, 0 ; rockets in radio tower
	def_engine_flag ENGINE_BIKE_SHOP_CALL_ENABLED, wStatusFlags2, 4 ; bike shop call enabled (1024 bike steps required) ; $10
	def_engine_flag ENGINE_GIVE_POKERUS, wStatusFlags2, 5 ; give pokerus
	def_engine_flag ENGINE_FLORIA, wStatusFlags2, 6 ; berry -> berry juice when trading?
	def_engine_flag ENGINE_ROCKETS_IN_MAHOGANY, wStatusFlags2, 7 ; rockets in mahogany

	def_engine_flag ENGINE_STRENGTH_ACTIVE, wBikeFlags, 0 ; strength active
	def_engine_flag ENGINE_ALWAYS_ON_BIKE, wBikeFlags, 1 ; always on bike (cant surf)
	def_engine_flag ENGINE_DOWNHILL, wBikeFlags, 2 ; downhill (cycling road)

	def_engine_flag ENGINE_PYREBADGE, wNaljoBadges, 0 ; zephyrbadge
	def_engine_flag ENGINE_NATUREBADGE, wNaljoBadges, 1 ; hivebadge
	def_engine_flag ENGINE_GULFBADGE, wNaljoBadges, 2 ; plainbadge ; $18
	def_engine_flag ENGINE_ELECTRONBADGE, wNaljoBadges, 3 ; fogbadge
	def_engine_flag ENGINE_MUSCLEBADGE, wNaljoBadges, 4 ; mineralbadge
	def_engine_flag ENGINE_HAZEBADGE, wNaljoBadges, 5 ; stormbadge
	def_engine_flag ENGINE_RAUCOUSBADGE, wNaljoBadges, 6 ; glacierbadge
	def_engine_flag ENGINE_NALJOBADGE, wNaljoBadges, 7 ; risingbadge

	def_engine_flag ENGINE_MARINEBADGE, wRijonBadges, 0 ; boulderbadge
	def_engine_flag ENGINE_HAILBADGE, wRijonBadges, 1 ; cascadebadge
	def_engine_flag ENGINE_SPROUTBADGE, wRijonBadges, 2 ; thunderbadge ; $20
	def_engine_flag ENGINE_SPARKYBADGE, wRijonBadges, 3 ; rainbowbadge
	def_engine_flag ENGINE_FISTBADGE, wRijonBadges, 4 ; soulbadge
	def_engine_flag ENGINE_PSIBADGE, wRijonBadges, 5 ; marshbadge
	def_engine_flag ENGINE_WHITEBADGE, wRijonBadges, 6 ; volcanobadge
	def_engine_flag ENGINE_STARBADGE, wRijonBadges, 7 ; earthbadge

	def_engine_flag ENGINE_HIVEBADGE, wOtherBadges, 0 ; 1
	def_engine_flag ENGINE_PLAINBADGE, wOtherBadges, 1 ; 2
	def_engine_flag ENGINE_MARSHBADGE, wOtherBadges, 2 ; 3 ;  $28
	def_engine_flag ENGINE_BLAZEBADGE, wOtherBadges, 3 ; 4
	def_engine_flag ENGINE_FLASH, wStatusFlags2, 0 ; 5
	def_engine_flag ENGINE_WILDS_DISABLED, wStatusFlags, 5 ; 6
	def_engine_flag ENGINE_UNUSED_3, wStatusFlags2, 3 ; 7
	def_engine_flag ENGINE_UNUSED_4, wOtherBadges, 7 ; 8

	def_engine_flag ENGINE_FLYPOINT_START, VisitedSpawns, 0
	def_engine_flag ENGINE_FLYPOINT_CAPER_CITY, VisitedSpawns, 1
	def_engine_flag ENGINE_FLYPOINT_OXALIS_CITY, VisitedSpawns, 2 ; $30
	def_engine_flag ENGINE_FLYPOINT_SPURGE_CITY, VisitedSpawns, 3
	def_engine_flag ENGINE_FLYPOINT_HEATH_VILLAGE, VisitedSpawns, 4
	def_engine_flag ENGINE_FLYPOINT_LAUREL_CITY, VisitedSpawns, 5
	def_engine_flag ENGINE_FLYPOINT_TORENIA_CITY, VisitedSpawns, 6
	def_engine_flag ENGINE_FLYPOINT_PHACELIA_TOWN, VisitedSpawns, 7
	def_engine_flag ENGINE_FLYPOINT_ACANIA_DOCKS, VisitedSpawns + 1, 0
	def_engine_flag ENGINE_FLYPOINT_SAXIFRAGE_ISLAND, VisitedSpawns + 1, 1
	def_engine_flag ENGINE_FLYPOINT_PHLOX_TOWN, VisitedSpawns + 1, 2 ; $38
	def_engine_flag ENGINE_FLYPOINT_BATTLE_ARCADE, VisitedSpawns + 1, 3
	def_engine_flag ENGINE_FLYPOINT_SEASHORE_CITY, VisitedSpawns + 1, 4
	def_engine_flag ENGINE_FLYPOINT_GRAVEL_TOWN, VisitedSpawns + 1, 5
	def_engine_flag ENGINE_FLYPOINT_MERSON_CITY, VisitedSpawns + 1, 6
	def_engine_flag ENGINE_FLYPOINT_HAYWARD_CITY, VisitedSpawns + 1, 7
	def_engine_flag ENGINE_FLYPOINT_OWSAURI_CITY, VisitedSpawns + 2, 0
	def_engine_flag ENGINE_FLYPOINT_MORAGA_TOWN, VisitedSpawns + 2, 1
	def_engine_flag ENGINE_FLYPOINT_JAERU_CITY, VisitedSpawns + 2, 2 ; $40
	def_engine_flag ENGINE_FLYPOINT_BOTAN_CITY, VisitedSpawns + 2, 3
	def_engine_flag ENGINE_FLYPOINT_CASTRO_VALLEY, VisitedSpawns + 2, 4
	def_engine_flag ENGINE_FLYPOINT_EAGULOU_CITY, VisitedSpawns + 2, 5
	def_engine_flag ENGINE_FLYPOINT_RIJON_LEAGUE, VisitedSpawns + 2, 6
	def_engine_flag ENGINE_FLYPOINT_SENECA_CAVERNS, VisitedSpawns + 2, 7
	def_engine_flag ENGINE_FLYPOINT_AZALEA_TOWN, VisitedSpawns + 3, 0
	def_engine_flag ENGINE_FLYPOINT_GOLDENROD_CITY, VisitedSpawns + 3, 1
	def_engine_flag ENGINE_FLYPOINT_SOUTHERLY_CITY, VisitedSpawns + 3, 3 ; $48 ; skipping Saffron's fly bit that's never used

	def_engine_flag ENGINE_LUCKY_NUMBER_SHOW, wLuckyNumberShowFlag, 0 ; lucky number show
	def_engine_flag ENGINE_4F, wStatusFlags2, 3 ; ????

	def_engine_flag ENGINE_KURT_MAKING_BALLS, DailyFlags, 0 ; kurt making balls
	def_engine_flag ENGINE_DAILY_BUG_CONTEST, DailyFlags, 1 ; ????
	def_engine_flag ENGINE_SPECIAL_WILDDATA, DailyFlags, 2 ; special wilddata?
	def_engine_flag ENGINE_TIME_CAPSULE, DailyFlags, 3 ; time capsule (24h wait)
	def_engine_flag ENGINE_ALL_FRUIT_TREES, DailyFlags, 4 ; all fruit trees
	def_engine_flag ENGINE_SHUCKLE_GIVEN, DailyFlags, 5 ; shuckle given ; $50
	def_engine_flag ENGINE_GOLDENROD_UNDERGROUND_MERCHANT_CLOSED, DailyFlags, 6 ; goldenrod underground merchant closed
	def_engine_flag ENGINE_FOUGHT_IN_TRAINER_HALL_TODAY, DailyFlags, 7 ; fought in trainer hall today

	def_engine_flag ENGINE_MT_MOON_SQUARE_CLEFAIRY, WeeklyFlags, 0 ; mt moon square clefairy
	def_engine_flag ENGINE_UNION_CAVE_LAPRAS, WeeklyFlags, 1 ; union cave lapras
	def_engine_flag ENGINE_GOLDENROD_UNDERGROUND_GOT_HAIRCUT, WeeklyFlags, 2 ; goldenrod underground haircut used
	def_engine_flag ENGINE_GOLDENROD_MALL_5F_HAPPINESS_EVENT, WeeklyFlags, 3 ; goldenrod mall happiness event floor05 person07
	def_engine_flag ENGINE_TEA_IN_BLUES_HOUSE, WeeklyFlags, 4 ; tea in blues house
	def_engine_flag ENGINE_INDIGO_PLATEAU_RIVAL_FIGHT, WeeklyFlags, 5 ; indigo plateau rival fight ; $58
	def_engine_flag ENGINE_DAILY_MOVE_TUTOR, WeeklyFlags, 6 ; move tutor
	def_engine_flag ENGINE_BUENAS_PASSWORD, WeeklyFlags, 7 ; buenas password

	def_engine_flag ENGINE_BUENAS_PASSWORD_2, SwarmFlags, 0
	def_engine_flag ENGINE_GOLDENROD_DEPT_STORE_SALE_IS_ON, SwarmFlags, 1 ; goldenrod dept store sale is on

	def_engine_flag ENGINE_62, GameTimerPause, 7

	def_engine_flag ENGINE_PLAYER_IS_FEMALE, wPlayerGender, 0 ; player is female

	def_engine_flag ENGINE_HAVE_EXAMINED_GS_BALL, wCelebiEvent, 2 ; have gs ball after kurt examined it

	def_engine_flag ENGINE_KRIS_IN_CABLE_CLUB, wPlayerSpriteSetupFlags, 2 ; female player has been transformed into male ; $60

	def_engine_flag ENGINE_DUNSPARCE_SWARM, SwarmFlags, 2 ; dunsparce swarm
	def_engine_flag ENGINE_YANMA_SWARM, SwarmFlags, 3 ; yanma swarm

NUM_ENGINE_FLAGS EQU const_value
