region_def: macro
	enum REGION_\1
\1_LANDMARK EQU const_value
	endm

	enum_start

	const_def
	const SPECIAL_MAP ; 00

	region_def NALJO
	const HEATH_VILLAGE
	const ROUTE_69
	const ROUTE_70
	const CAPER_CITY
	const ROUTE_71
	const ROUTE_72
	const OXALIS_CITY
	const ROUTE_73
	const MOUND_CAVE
	const SPURGE_CITY
	const ROUTE_74
	const ROUTE_75
	const LAUREL_CITY
	const ROUTE_76
	const LAUREL_FOREST
	const TORENIA_CITY
	const ROUTE_83
	const ROUTE_77
	const MILOS_CATACOMBS
	const PHACELIA_TOWN
	const BATTLE_TOWER
	const ROUTE_78
	const ROUTE_79
	const SAXIFRAGE_ISLAND
	const ROUTE_80
	const ROUTE_81
	const PROVINICIAL_PARK
	const MAGMA_CAVERNS
	const ROUTE_85
	const NALJO_RUINS
	const CLATHRITE_TUNNEL
	const ROUTE_84
	const PHLOX_TOWN
	const ACQUA_MINES
	const ROUTE_82
	const ACANIA_DOCKS
	const ROUTE_68
	const NALJO_BORDER
	const ROUTE_86
	const CHAMPION_ISLE
	const TUNNEL
	const ROUTE_87
	const FARAWAY_ISLAND
	const DUMMY2
	const DUMMY3
	const DUMMY4

	region_def RIJON
	const SEASHORE_CITY
	const ROUTE_53
	const GRAVEL_TOWN
	const MERSON_CAVE
	const ROUTE_54
	const MERSON_CITY
	const ROUTE_55
	const RIJON_UNDERGROUND
	const ROUTE_52
	const HAYWARD_CITY
	const ROUTE_64
	const ROUTE_51
	const ROUTE_50
	const ROUTE_49
	const OWSAURI_CITY
	const ROUTE_66
	const ROUTE_48
	const ROUTE_63
	const SILK_TUNNEL
	const MORAGA_TOWN
	const ROUTE_60
	const JAERU_CITY
	const ROUTE_59
	const SILPH_WAREHOUSE
	const BOTAN_CITY
	const HAUNTED_FOREST
	const POWER_PLANT
	const ROUTE_58
	const CASTRO_VALLEY
	const MANSION
	const CASTRO_FOREST
	const ROUTE_62
	const ROUTE_61
	const ROUTE_57
	const ROUTE_56
	const EAGULOU_CITY
	const EAGULOU_PARK
	const ROUTE_65
	const RIJON_LEAGUE
	const ROUTE_67
	const MT_BOULDER
	const SENECA_CAVERNS

	region_def JOHTO
	const ROUTE_47
	const ILEX_FOREST
	const AZALEA_TOWN
	const ROUTE_34
	const GOLDENROD_CITY
	const GOLDENROD_CAPE

	region_def KANTO
	const SAFFRON_CITY

	region_def SEVII
	const EMBER_BROOK
	const MT_EMBER
	const KINDLE_ROAD

	region_def TUNOD
	const TUNOD_WATERWAY
	const SOUTH_SOUTHERLY
	const SOUTHERLY_CITY

	region_def MYSTERY
	const MYSTERY_ZONE
