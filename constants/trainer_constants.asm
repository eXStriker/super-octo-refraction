; trainer groups
	enum_start
CHRIS EQU __enum__
	trainerclass TRAINER_NONE
	const PHONECONTACT_MOM
	const PHONECONTACT_BIKESHOP
	const PHONECONTACT_BILL
	const PHONECONTACT_ELM
	const PHONECONTACT_BUENA

KRIS EQU __enum__
	trainerclass JOSIAH
	const JOSIAH_GYM
	const JOSIAH_SPURGE

	trainerclass BROOKLYN

	trainerclass RINJI
	const RINJI_GYM
	const RINJI_SPURGE

	trainerclass EDISON
	const EDISON_GYM
	const EDISON_SPURGE

	trainerclass AYAKA

	trainerclass CADENCE
	const CADENCE_GYM
	const CADENCE_SPURGE

	trainerclass ANDRE

	trainerclass BRUCE

	trainerclass RIVAL1
	const RIVAL1_1
	const RIVAL1_2
	const RIVAL1_3
	const RIVAL1_4
	const RIVAL1_5
	const RIVAL1_6
	const RIVAL1_7

	trainerclass MURA

	trainerclass YUKI

	trainerclass KOJI

	trainerclass DAICHI

	trainerclass DELINQUENTF

	trainerclass SORA

	trainerclass CHAMPION

	trainerclass PATROLLER

	trainerclass SCIENTIST

	trainerclass YOUNGSTER

	trainerclass SCHOOLBOY

	trainerclass BIRD_KEEPER

	trainerclass LASS

	trainerclass CHEERLEADER

	trainerclass COOLTRAINERM

	trainerclass COOLTRAINERF

	trainerclass BEAUTY

	trainerclass POKEMANIAC

	trainerclass GRUNTM

	trainerclass GENTLEMAN

	trainerclass SKIER

	trainerclass TEACHER

	trainerclass SHERYL

	trainerclass BUG_CATCHER

	trainerclass FISHER

	trainerclass SWIMMERM

	trainerclass SWIMMERF

	trainerclass SAILOR

	trainerclass SUPER_NERD

	trainerclass SILVER

	trainerclass GUITARIST

	trainerclass HIKER

	trainerclass BIKER

	trainerclass JOE

	trainerclass BURGLAR

	trainerclass FIREBREATHER

	trainerclass JUGGLER

	trainerclass BLACKBELT_T

	trainerclass PSYCHIC_T

	trainerclass PICNICKER

	trainerclass CAMPER

	trainerclass SAGE

	trainerclass MEDIUM

	trainerclass BOARDER

	trainerclass POKEFANM

	trainerclass DELINQUENTM

	trainerclass TWINS

	trainerclass POKEFANF

	trainerclass RED

	trainerclass BLUE

	trainerclass OFFICER

	trainerclass MINER

	trainerclass KARPMAN

	trainerclass ARCADEPC_GROUP
	const ARCADEPC_TRAINER

	trainerclass LILY

	trainerclass LOIS

	trainerclass SPARKY

	trainerclass GOLD

	trainerclass GIOVANNI

	trainerclass ERNEST

	trainerclass TRAINERKRIS

	trainerclass KIMONO_GIRL

	trainerclass BUGSY

	trainerclass WHITNEY

	trainerclass SABRINA

	trainerclass CANDELA

	trainerclass BLANCHE

	trainerclass SPARK_T

	trainerclass BROWN

	trainerclass GUITARISTF

	trainerclass CAL

NUM_TRAINER_CLASSES EQU __enum__

	const_def
	const       NO_AI
const_value = 0
	shift_const AI_BASIC
	shift_const AI_SETUP
	shift_const AI_TYPES
	shift_const AI_OFFENSIVE
	shift_const AI_SMART
	shift_const AI_OPPORTUNIST
	shift_const AI_AGGRESSIVE
	shift_const AI_CAUTIOUS
	shift_const AI_STATUS
	shift_const AI_RISKY
	shift_const AI_10
	shift_const AI_11
	shift_const AI_12
	shift_const AI_13
	shift_const AI_14
	shift_const AI_15

	const_def
	const TRNATTR_ITEM1
	const TRNATTR_ITEM2
	const TRNATTR_BASEMONEY
	const TRNATTR_AI_MOVE_WEIGHTS
	const TRNATTR_AI2
	const TRNATTR_AI_ITEM_SWITCH
	const TRNATTR_AI4
NUM_TRAINER_ATTRIBUTES EQU const_value
