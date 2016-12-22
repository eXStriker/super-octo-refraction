SpriteHeaders:
; Format:
;	Address
;	Length, Bank
;	Type, Palette

sprite_header: MACRO
; pointer, length, type, palette
	dw \1
	db \2 * 4 tiles, BANK(\1)
	db \3, \4
ENDM

Player0Sprite: ; 14736
	sprite_header Player0SpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
; 1473c

Player0BikeSprite: ; 1473c
	sprite_header Player0BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
; 14742

GameboyKidSprite: ; 14742
	sprite_header GameboyKidSpriteGFX, 3, STANDING_SPRITE, PAL_OW_GREEN
; 14748

SilverSprite: ; 14748
	sprite_header SilverSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
; 1474e

OakSprite: ; 1474e
	sprite_header OakSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN
; 14754

RedSprite: ; 14754
	sprite_header RedSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
; 1475a

BlueSprite: ; 1475a
	sprite_header BlueSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
; 14760

BillSprite: ; 14760
	sprite_header BillSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
; 14766

ElderSprite: ; 14766
	sprite_header ElderSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN
; 1476c

MuraSprite:
	sprite_header MuraSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN
	
KurtSprite: ; 14772
	sprite_header KurtSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN
; 14778

MomSprite: ; 14778
	sprite_header MomSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
; 1477e

BlaineSprite: ; 1477e
	sprite_header JoeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
; 14784

RedsMomSprite: ; 14784
	sprite_header RedsMomSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
; 1478a

DaisySprite: ; 1478a
	sprite_header DaisySpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
; 14790

ElmSprite: ; 14790
	sprite_header ElmSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN
; 14796

SoraSprite: ; 14796
	sprite_header SoraSpriteGFX, 3, STANDING_SPRITE, PAL_OW_BROWN
; 1479c

FalknerSprite: ; 1479c
	sprite_header FalknerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
; 147a2

WhitneySprite: ; 147a2
	sprite_header WhitneySpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
; 147a8

BugsySprite: ; 147a8
	sprite_header BugsySpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN
; 147ae

MortySprite: ; 147ae
	sprite_header MortySpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN
; 147b4

ChuckSprite: ; 147b4
	sprite_header AndreSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN
; 147ba

JasmineSprite: ; 147ba
	sprite_header JasmineSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN
; 147c0

PryceSprite: ; 147c0
	sprite_header PryceSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN
; 147c6

ClairSprite: ; 147c6
	sprite_header ClairSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
; 147cc

KarpmanSprite:
	sprite_header KarpmanSpriteGFX, 3, WALKING_SPRITE, PAL_OW_SILVER
; 147d2

YukiSprite: ; 147d2
	sprite_header YukiSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
; 147d8

DaichiSprite:
	sprite_header DaichiSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

LilySprite:
	sprite_header LilySpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

LanceSprite: ; 147e4
	sprite_header LanceSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
; 147ea

SparkySprite: ; 147ea
	sprite_header SparkSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN
; 147f0

LoisSprite: ; 147f0
	sprite_header LoisSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN
; 147f6

KojiSprite: ; 147f6
	sprite_header KojiSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN
; 147fc

SabrinaSprite: ; 147fc
	sprite_header SabrinaSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
; 14802

CooltrainerMSprite: ; 14802
	sprite_header CooltrainerMSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
; 14808

CooltrainerFSprite: ; 14808
	sprite_header CooltrainerFSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
; 1480e

BugCatcherSprite: ; 1480e
	sprite_header BugCatcherSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
; 14814

TwinSprite: ; 14814
	sprite_header TwinSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
; 1481a

YoungsterSprite: ; 1481a
	sprite_header YoungsterSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
; 14820

LassSprite: ; 14820
	sprite_header LassSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
; 14826

TeacherSprite: ; 14826
	sprite_header TeacherSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
; 1482c

BuenaSprite: ; 1482c
	sprite_header BuenaSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
; 14832

SuperNerdSprite: ; 14832
	sprite_header SuperNerdSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
; 14838

RockerSprite: ; 14838
	sprite_header RockerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN
; 1483e

PokefanMSprite: ; 1483e
	sprite_header PokefanMSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN
; 14844

PokefanFSprite: ; 14844
	sprite_header PokefanFSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN
; 1484a

GrampsSprite: ; 1484a
	sprite_header GrampsSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN
; 14850

GrannySprite: ; 14850
	sprite_header GrannySpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN
; 14856

SwimmerGuySprite: ; 14856
	sprite_header SwimmerGuySpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
; 1485c

SwimmerGirlSprite: ; 1485c
	sprite_header SwimmerGirlSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
; 14862

BigSnorlaxSprite: ; 14862
	sprite_header BigSnorlaxSpriteGFX, 3, STANDING_SPRITE, PAL_OW_BLUE
; 14868

SurfingPikachuSprite: ; 14868
	sprite_header SurfingPikachuSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
; 1486e

RocketSprite: ; 1486e
	sprite_header RocketSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN
; 14874

RocketGirlSprite: ; 14874
	sprite_header RocketGirlSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN
; 1487a

NurseSprite: ; 1487a
	sprite_header NurseSpriteGFX, 3, STANDING_SPRITE, PAL_OW_RED
; 14880

LinkReceptionistSprite: ; 14880
	sprite_header LinkReceptionistSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
; 14886

ClerkSprite: ; 14886
	sprite_header ClerkSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN
; 1488c

FisherSprite: ; 1488c
	sprite_header FisherSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
; 14892

FishingGuruSprite: ; 14892
	sprite_header FishingGuruSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
; 14898

ScientistSprite: ; 14898
	sprite_header ScientistSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
; 1489e

KimonoGirlSprite: ; 1489e
	sprite_header KimonoGirlSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
; 148a4

SageSprite: ; 148a4
	sprite_header SageSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN
; 148aa

GoldSprite:
	sprite_header GoldSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
; 148b0

GentlemanSprite: ; 148b0
	sprite_header GentlemanSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
; 148b6

BlackBeltSprite: ; 148b6
	sprite_header BlackBeltSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN
; 148bc

ReceptionistSprite: ; 148bc
	sprite_header ReceptionistSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
; 148c2

OfficerSprite: ; 148c2
	sprite_header OfficerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
; 148c8

CalSprite: ; 148c8
	sprite_header CalSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN
; 148ce

SlowpokeSprite: ; 148ce
	sprite_header SlowpokeSpriteGFX, 1, STILL_SPRITE, PAL_OW_RED
; 148d4

CaptainSprite: ; 148d4
	sprite_header CaptainSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN
; 148da

BigLaprasSprite: ; 148da
	sprite_header BigLaprasSpriteGFX, 3, STANDING_SPRITE, PAL_OW_BLUE
; 148e0

GymGuySprite: ; 148e0
	sprite_header GymGuySpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
; 148e6

SailorSprite: ; 148e6
	sprite_header SailorSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
; 148ec

BikerSprite: ; 148ec
	sprite_header BikerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN
; 148f2

PharmacistSprite: ; 148f2
	sprite_header PharmacistSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
; 148f8

MonsterSprite: ; 148f8
	sprite_header MonsterSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
; 148fe

FairySprite: ; 148fe
	sprite_header FairySpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
; 14904

BirdSprite: ; 14904
	sprite_header BirdSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
; 1490a

DragonSprite: ; 1490a
	sprite_header DragonSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
; 14910

BigOnixSprite: ; 14910
	sprite_header BigOnixSpriteGFX, 3, STANDING_SPRITE, PAL_OW_BROWN
; 14916

N64Sprite: ; 14916
	sprite_header N64SpriteGFX, 1, STILL_SPRITE, PAL_OW_BROWN
; 1491c

SudowoodoSprite: ; 1491c
	sprite_header SudowoodoSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN
; 14922

SurfSprite: ; 14922
	sprite_header SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
; 14928

PokeBallSprite: ; 14928
	sprite_header PokeBallSpriteGFX, 1, STILL_SPRITE, PAL_OW_RED
; 1492e

PokedexSprite: ; 1492e
	sprite_header PokedexSpriteGFX, 1, STILL_SPRITE, PAL_OW_BROWN
; 14934

PaperSprite: ; 14934
	sprite_header PaperSpriteGFX, 1, STILL_SPRITE, PAL_OW_BLUE
; 1493a

VirtualBoySprite: ; 1493a
	sprite_header VirtualBoySpriteGFX, 1, STILL_SPRITE, PAL_OW_RED
; 14940

OldLinkReceptionistSprite: ; 14940
	sprite_header OldLinkReceptionistSpriteGFX, 3, STANDING_SPRITE, PAL_OW_RED
; 14946

RockSprite: ; 14946
	sprite_header RockSpriteGFX, 1, STILL_SPRITE, PAL_OW_BROWN
; 1494c

BoulderSprite: ; 1494c
	sprite_header BoulderSpriteGFX, 1, STILL_SPRITE, PAL_OW_BROWN
; 14952

SnesSprite: ; 14952
	sprite_header SnesSpriteGFX, 1, STILL_SPRITE, PAL_OW_BLUE
; 14958

FamicomSprite: ; 14958
	sprite_header FamicomSpriteGFX, 1, STILL_SPRITE, PAL_OW_RED
; 1495e

FruitTreeSprite: ; 1495e
	sprite_header FruitTreeSpriteGFX, 1, STILL_SPRITE, PAL_OW_GREEN
; 14964

GoldTrophySprite: ; 14964
	sprite_header GoldTrophySpriteGFX, 1, STILL_SPRITE, PAL_OW_BROWN
; 1496a

SilverTrophySprite: ; 1496a
	sprite_header SilverTrophySpriteGFX, 1, STILL_SPRITE, PAL_OW_SILVER
; 14970

Player1Sprite: ; 14970
	sprite_header Player1SpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
; 14976

Player1BikeSprite: ; 14976
	sprite_header Player1BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
; 1497c

KurtOutsideSprite: ; 1497c
	sprite_header KurtOutsideSpriteGFX, 3, STANDING_SPRITE, PAL_OW_BROWN
; 14982

SuicuneSprite: ; 14982
	sprite_header SuicuneSpriteGFX, 1, STILL_SPRITE, PAL_OW_BLUE
; 14988

EnteiSprite: ; 14988
	sprite_header EnteiSpriteGFX, 1, STILL_SPRITE, PAL_OW_RED
; 1498e

RaikouSprite: ; 1498e
	sprite_header RaikouSpriteGFX, 1, STILL_SPRITE, PAL_OW_RED
; 14994

StandingYoungsterSprite: ; 14994
	sprite_header StandingYoungsterSpriteGFX, 3, STANDING_SPRITE, PAL_OW_BLUE
; 1499a

FireSprite:
	sprite_header FireSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
MagikarpWalk:
	sprite_header MagikarpWalkGFX, 3, WALKING_SPRITE, PAL_OW_RED

;player

Player0SurfSprite:
	sprite_header Player0SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player1SurfSprite:
	sprite_header Player1SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player2Sprite:
	sprite_header Player2SpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player2BikeSprite:
	sprite_header Player2BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player2SurfSprite:
	sprite_header Player2SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player3Sprite:
	sprite_header Player3SpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player3BikeSprite:
	sprite_header Player3BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player3SurfSprite:
	sprite_header Player3SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player4Sprite:
	sprite_header Player4SpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player4BikeSprite:
	sprite_header Player4BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player4SurfSprite:
	sprite_header Player4SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player5Sprite:
	sprite_header Player5SpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player5BikeSprite:
	sprite_header Player5BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player5SurfSprite:
	sprite_header Player5SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player6Sprite:
	sprite_header Player6SpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player6BikeSprite:
	sprite_header Player6BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player6SurfSprite:
	sprite_header Player6SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player7Sprite:
	sprite_header Player7SpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player7BikeSprite:
	sprite_header Player7BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player7SurfSprite:
	sprite_header Player7SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player8Sprite:
	sprite_header Player8SpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player8BikeSprite:
	sprite_header Player8BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player8SurfSprite:
	sprite_header Player8SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player9Sprite:
	sprite_header Player9SpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player9BikeSprite:
	sprite_header Player9BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player9SurfSprite:
	sprite_header Player9SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player10Sprite:
	sprite_header Player10SpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player10BikeSprite:
	sprite_header Player10BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player10SurfSprite:
	sprite_header Player10SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player11Sprite:
	sprite_header Player11SpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player11BikeSprite:
	sprite_header Player11BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
Player11SurfSprite:
	sprite_header Player11SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER

;new trainers
BoarderSprite:
	sprite_header BoarderSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

PsychicSprite:
	sprite_header PsychicSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PURPLE

SchoolboySprite:
	sprite_header SchoolboySpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

JugglerSprite:
	sprite_header JugglerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

BeautySprite:
	sprite_header BeautySpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

PokemaniacSprite:
	sprite_header PokemaniacSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PURPLE

FirebreatherSprite:
	sprite_header FirebreatherSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

HikerSprite:
	sprite_header HikerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

PicnickerSprite:
	sprite_header PicnickerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN

CamperSprite:
	sprite_header CamperSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN

BirdkeeperSprite:
	sprite_header BirdkeeperSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

;remade Gen 1		
R_BeautySprite:
	sprite_header R_BeautySpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

R_BikerSprite:
	sprite_header R_BikerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

R_BirdkeeperSprite:
	sprite_header R_BirdkeeperSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

R_BlackbeltSprite:
	sprite_header R_BlackbeltSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

R_BugcatcherSprite:
	sprite_header R_BugcatcherSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN

R_BurglerSprite:
	sprite_header R_BurglerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN

R_ChannelerSprite:
	sprite_header R_ChannelerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PURPLE

R_CooltrainerFSprite:
	sprite_header R_CooltrainerFSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

R_CooltrainerMSprite:
	sprite_header R_CooltrainerMSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

R_CueballSprite:
	sprite_header R_CueballSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

R_EngineerSprite:
	sprite_header R_EngineerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

R_GentlemanSprite:
	sprite_header R_GentlemanSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

R_FisherSprite:
	sprite_header R_FisherSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN

R_GamblerSprite:
	sprite_header R_GamblerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

R_HikerSprite:
	sprite_header R_HikerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN

R_JrTrainerFSprite:
	sprite_header R_JrTrainerFSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

R_JrTrainerMSprite:
	sprite_header R_JrTrainerMSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

R_JugglerSprite:
	sprite_header R_JugglerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PURPLE

R_LassSprite:
	sprite_header R_LassSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

R_ManiacSprite:
	sprite_header R_ManiacSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN

R_NerdSprite:
	sprite_header R_NerdSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

R_PsychicSprite:
	sprite_header R_PsychicSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

R_RockerSprite:
	sprite_header R_RockerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

R_SailorSprite:
	sprite_header R_SailorSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

R_ScientistSprite:
	sprite_header R_ScientistSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

R_SwimmerSprite:
	sprite_header R_SwimmerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN

R_TamerSprite:
	sprite_header R_TamerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN

R_YoungsterSprite:
	sprite_header R_YoungsterSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
	
;additional trainer classes

MinerSprite:
	sprite_header R_RockerSpriteGFX, 3, WALKING_SPRITE, PAL_OW_YELLOW

GuitaristFSprite:
	sprite_header R_SailorSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

DelinquentMSprite:
	sprite_header DelinquentMSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

DelinquentFSprite:
	sprite_header DelinquentFSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE

CheerleaderSprite:
	sprite_header CheerleaderSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PURPLE
	
;additional leaders and trainers
SheralSprite:
	sprite_header SheralSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PURPLE
	
BrownSprite:
	sprite_header BrownSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN
	
Player12BikeSprite:
	sprite_header Player12BikeSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
	
Player12SurfSprite:
	sprite_header Player12SurfSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PLAYER
	
BruceSprite:
	sprite_header BruceSpriteGFX, 3, WALKING_SPRITE, PAL_OW_SILVER
	
ErnestSprite:
	sprite_header ErnestSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
	
AyakaSprite:
	sprite_header AyakaSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
	
GiovanniSprite:
	sprite_header GiovanniSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN
	
KrisSprite:
	sprite_header KrisSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
	
RinjiSprite:
	sprite_header RinjiSpriteGFX, 3, WALKING_SPRITE, PAL_OW_GREEN
	
BlancheSprite:
	sprite_header BlancheSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BLUE
	
CadenceSprite:
	sprite_header CadenceSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
	
CandelaSprite:
	sprite_header CandelaSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

BrooklynSprite:
	sprite_header BrooklynSpriteGFX, 3, WALKING_SPRITE, PAL_OW_PURPLE
	
JosiahSprite:
	sprite_header JosiahSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED

SilverLeaderSprite:
	sprite_header SilverLeaderSpriteGFX, 3, WALKING_SPRITE, PAL_OW_RED
	
EdisonSprite:
	sprite_header EdisonSpriteGFX, 3, WALKING_SPRITE, PAL_OW_BROWN
