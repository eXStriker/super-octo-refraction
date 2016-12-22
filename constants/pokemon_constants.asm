; pokemon
const_value set 0
	const NO_POKEMON
	const BULBASAUR
	const IVYSAUR
	const VENUSAUR
	const CHARMANDER
	const CHARMELEON
	const CHARIZARD
	const SQUIRTLE
	const WARTORTLE
	const BLASTOISE
	const CATERPIE
	const METAPOD
	const BUTTERFREE
	const CHINGLING
	const CHIMECHO
	const TORKOAL
	const PIDGEY
	const PIDGEOTTO
	const PIDGEOT
	const TAILLOW
	const SWELLOW
	const SPEAROW
	const FEAROW
	const BUNEARY
	const LOPUNNY
	const PIKACHU
	const RAICHU
	const SHINX
	const LUXIO
	const LUXRAY
	const ELECTRIKE
	const MANECTRIC
	const SNORUNT
	const GLALIE
	const FROSLASS
	const VOLBEAT
	const ILLUMISE
	const VULPIX
	const NINETALES
	const JIGGLYPUFF
	const WIGGLYTUFF
	const ZUBAT
	const GOLBAT
	const ARON
	const LAIRON
	const AGGRON
	const PARAS
	const PARASECT
	const VENONAT
	const VENOMOTH
	const BRONZOR
	const BRONZONG
	const SKORUPI
	const DRAPION
	const CRANIDOS
	const RAMPARDOS
	const SHIELDON
	const BASTIODON
	const GROWLITHE
	const ARCANINE
	const WHISMUR
	const LOUDRED
	const EXPLOUD
	const ABRA
	const KADABRA
	const ALAKAZAM
	const MACHOP
	const MACHOKE
	const MACHAMP
	const BELLSPROUT
	const WEEPINBELL
	const VICTREEBEL
	const TENTACOOL
	const TENTACRUEL
	const GEODUDE
	const GRAVELER
	const GOLEM
	const PONYTA
	const RAPIDASH
	const SLOWPOKE
	const SLOWBRO
	const MAGNEMITE
	const MAGNETON
	const MAGNEZONE
	const DRIFLOON
	const DRIFBLIM
	const SABLEYE
	const SPIRITOMB
	const SHUPPET
	const BANETTE
	const DUSKULL
	const DUSCLOPS
	const GASTLY
	const HAUNTER
	const GENGAR
	const ONIX
	const LUNATONE
	const SOLROCK
	const VIBRAVA
	const FLYGON
	const MAKUHITA
	const HARIYAMA
	const EXEGGCUTE
	const EXEGGUTOR
	const CACNEA
	const CACTURNE
	const HITMONLEE
	const HITMONCHAN
	const TRAPINCH
	const KOFFING
	const WEEZING
	const RHYHORN
	const RHYDON
	const CHANSEY
	const TANGELA
	const KANGASKHAN
	const TANGROWTH
	const MAWILE
	const GOLDEEN
	const SEAKING
	const LOTAD
	const LOMBRE
	const LUDICOLO
	const SCYTHER
	const RELICANTH
	const ELECTABUZZ
	const MAGMAR
	const ELECTIVIRE
	const MAGMORTAR
	const MAGIKARP
	const GYARADOS
	const ABSOL
	const DITTO
	const EEVEE
	const VAPOREON
	const JOLTEON
	const FLAREON
	const PORYGON
	const VARANEOUS
	const LILEEP
	const CRADILY
	const ANORITH
	const ARMALDO
	const SNORLAX
	const ARTICUNO
	const ZAPDOS
	const MOLTRES
	const BELDUM
	const METANG
	const METAGROSS
	const MEWTWO
	const MEW
	const CHIKORITA
	const BAYLEEF
	const MEGANIUM
	const CYNDAQUIL
	const QUILAVA
	const TYPHLOSION
	const TOTODILE
	const CROCONAW
	const FERALIGATR
	const SENTRET
	const FURRET
	const RALTS
	const KIRLIA
	const GARDEVOIR
	const GALLADE
	const SPINARAK
	const ARIADOS
	const CROBAT
	const CHINCHOU
	const LANTURN
	const PICHU
	const CARNIVINE
	const IGGLYBUFF
	const TOGEPI
	const TOGETIC
	const NATU
	const XATU
	const MAREEP
	const FLAAFFY
	const AMPHAROS
	const TOGEKISS
	const MARILL
	const AZUMARILL
	const NUMEL
	const CAMERUPT
	const WAILMER
	const WAILORD
	const SURSKIT
	const MASQUERAIN
	const SHROOMISH
	const BRELOOM
	const YANMA
	const YANMEGA
	const LEAFEON
	const ESPEON
	const UMBREON
	const GLACEON
	const SLOWKING
	const MISDREAVUS
	const MISMAGIUS
	const SWABLU
	const ALTARIA
	const PINECO
	const FORRETRESS
	const RHYPERIOR
	const GLIGAR
	const STEELIX
	const GLISCOR
	const FEEBAS
	const MILOTIC
	const SCIZOR
	const RIOLU
	const LUCARIO
	const SNEASEL
	const TEDDIURSA
	const URSARING
	const SLUGMA
	const MAGCARGO
	const SWINUB
	const PILOSWINE
	const GIBLE
	const GABITE
	const GARCHOMP
	const BAGON
	const SHELGON
	const SALAMENCE
	const HOUNDOUR
	const HOUNDOOM
	const MAMOSWINE
	const PHANPY
	const DONPHAN
	const PORYGON2
	const PORYGONZ
	const WEAVILE
	const TYROGUE
	const HITMONTOP
	const FAMBACO
	const ELEKID
	const MAGBY
	const SYLVEON
	const BLISSEY
	const GROUDON
	const KYOGRE
	const RAYQUAZA
	const LARVITAR
	const PUPITAR
	const TYRANITAR
	const LUGIA
	const HO_OH
	const RAIWATO
	const PHANCERO
	const EGG
	const LIBABEEL

const_value SET const_value + -1

NUM_POKEMON EQU const_value

const_value SET 1 ;Get rid of these constants so the game can run


; pokemon structure in RAM
MON_SPECIES              EQUS "(PartyMon1Species - wPartyMon1)"
MON_ITEM                 EQUS "(PartyMon1Item - wPartyMon1)"
MON_MOVES                EQUS "(PartyMon1Moves - wPartyMon1)"
MON_ID                   EQUS "(PartyMon1ID - wPartyMon1)"
MON_EXP                  EQUS "(PartyMon1Exp - wPartyMon1)"
MON_STAT_EXP             EQUS "(PartyMon1StatExp - wPartyMon1)"
MON_HP_EXP               EQUS "(PartyMon1HPExp - wPartyMon1)"
MON_ATK_EXP              EQUS "(PartyMon1AtkExp - wPartyMon1)"
MON_DEF_EXP              EQUS "(PartyMon1DefExp - wPartyMon1)"
MON_SPD_EXP              EQUS "(PartyMon1SpdExp - wPartyMon1)"
MON_SPC_EXP              EQUS "(PartyMon1SpcExp - wPartyMon1)"
MON_DVS                  EQUS "(PartyMon1DVs - wPartyMon1)"
MON_PP                   EQUS "(PartyMon1PP - wPartyMon1)"
MON_HAPPINESS            EQUS "(PartyMon1Happiness - wPartyMon1)"
MON_PKRUS                EQUS "(PartyMon1PokerusStatus - wPartyMon1)"
MON_CAUGHTDATA           EQUS "(PartyMon1CaughtData - wPartyMon1)"
MON_CAUGHTLEVEL          EQUS "(PartyMon1CaughtLevel - wPartyMon1)"
MON_CAUGHTTIME           EQUS "(PartyMon1CaughtTime - wPartyMon1)"
MON_CAUGHTGENDER         EQUS "(PartyMon1CaughtGender - wPartyMon1)"
MON_CAUGHTLOCATION       EQUS "(PartyMon1CaughtLocation - wPartyMon1)"
MON_LEVEL                EQUS "(PartyMon1Level - wPartyMon1)"
MON_STATUS               EQUS "(PartyMon1Status - wPartyMon1)"
MON_HP                   EQUS "(PartyMon1HP - wPartyMon1)"
MON_MAXHP                EQUS "(PartyMon1MaxHP - wPartyMon1)"
MON_ATK                  EQUS "(PartyMon1Attack - wPartyMon1)"
MON_DEF                  EQUS "(PartyMon1Defense - wPartyMon1)"
MON_SPD                  EQUS "(PartyMon1Speed - wPartyMon1)"
MON_SAT                  EQUS "(PartyMon1SpclAtk - wPartyMon1)"
MON_SDF                  EQUS "(PartyMon1SpclDef - wPartyMon1)"
BOXMON_STRUCT_LENGTH     EQUS "(PartyMon1End - wPartyMon1)"
PARTYMON_STRUCT_LENGTH   EQUS "(PartyMon1StatsEnd - wPartyMon1)"
REDMON_STRUCT_LENGTH EQU 44

const_value SET 1
	const MONMENU_CUT        ; 1
	const MONMENU_FLY        ; 2
	const MONMENU_SURF       ; 3
	const MONMENU_STRENGTH   ; 4
	const MONMENU_WATERFALL  ; 5
	const MONMENU_FLASH      ; 6
	const MONMENU_WHIRLPOOL  ; 7
	const MONMENU_DIG        ; 8
	const MONMENU_TELEPORT   ; 9
	const MONMENU_SOFTBOILED ; 10
	const MONMENU_HEADBUTT   ; 11
	const MONMENU_ROCKSMASH  ; 12
	const MONMENU_MILKDRINK  ; 13
	const MONMENU_SWEETSCENT ; 14

	const MONMENU_STATS      ; 15
	const MONMENU_SWITCH     ; 16
	const MONMENU_ITEM       ; 17
	const MONMENU_CANCEL     ; 18
	const MONMENU_MOVE       ; 19
	const MONMENU_MAIL       ; 20
	const MONMENU_ERROR      ; 21
	const MONMENU_PMODE_ITEM ; 22

MONMENU_FIELD_MOVE EQU 0
MONMENU_MENUOPTION EQU 1
