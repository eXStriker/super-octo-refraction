UpdateItemDescription::
	ld a, [wMenuSelection]
	ld [wCurSpecies], a
	call SpeechTextBox
	ld a, [wMenuSelection]
	cp -1
	ret z
	decoord 1, 14
	; fallthrough

PrintItemDescription:
; Print the description for item [wCurSpecies] at de.

	ld a, [wCurSpecies]
	push de
	ld hl, ItemDescriptions
	ld a, [wCurSpecies]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	jp PlaceText

ItemDescriptions:
	dw MasterballDesc
	dw UltraballDesc
	dw BrightpowderDesc
	dw GreatballDesc
	dw PokeballDesc
	dw CoalDesc
	dw BicycleDesc
	dw MoonStoneDesc
	dw AntidoteDesc
	dw BurnHealDesc
	dw IceHealDesc
	dw AwakeningDesc
	dw ParlyzHealDesc
	dw FullRestoreDesc
	dw MaxPotionDesc
	dw HyperPotionDesc
	dw SuperPotionDesc
	dw PotionDesc
	dw EscapeRopeDesc
	dw RepelDesc
	dw MaxElixerDesc
	dw FireStoneDesc
	dw ThunderStoneDesc
	dw WaterStoneDesc
	dw PoisonGuardDesc
	dw HPUpDesc
	dw ProteinDesc
	dw IronDesc
	dw CarbosDesc
	dw LuckyPunchDesc
	dw CalciumDesc
	dw RareCandyDesc
	dw XAccuracyDesc
	dw LeafStoneDesc
	dw MetalPowderDesc
	dw NuggetDesc
	dw PokeDollDesc
	dw FullHealDesc
	dw ReviveDesc
	dw MaxReviveDesc
	dw GuardSpecDesc
	dw SuperRepelDesc
	dw MaxRepelDesc
	dw DireHitDesc
	dw BurnGuardDesc
	dw FreshWaterDesc
	dw SodaPopDesc
	dw LemonadeDesc
	dw XAttackDesc
	dw FreezeGuardDesc
	dw XDefendDesc
	dw XSpeedDesc
	dw XSpecialDesc
	dw CoinCaseDesc
	dw TokenFinderDesc
	dw HeartScaleDesc
	dw ExpShareDesc
	dw OldRodDesc
	dw GoodRodDesc
	dw SilverLeafDesc
	dw SuperRodDesc
	dw PPUpDesc
	dw EtherDesc
	dw MaxEtherDesc
	dw ElixerDesc
	dw CellCardDesc
	dw RijonPassDesc
	dw FerryTicketDesc
	dw CellCardDesc
	dw CellCardDesc
	dw CellCardDesc
	dw MoomooMilkDesc
	dw QuickClawDesc
	dw PsnCureBerryDesc
	dw GoldLeafDesc
	dw SoftSandDesc
	dw SharpBeakDesc
	dw PrzCureBerryDesc
	dw AspearBerryDesc
	dw IceBerryDesc
	dw PoisonBarbDesc
	dw KingsRockDesc
	dw BitterBerryDesc
	dw MintBerryDesc
	dw RedApricornDesc
	dw TinyMushroomDesc
	dw BigMushroomDesc
	dw SilverPowderDesc
	dw BluApricornDesc
	dw SleepGuardDesc
	dw AmuletCoinDesc
	dw YlwApricornDesc
	dw GrnApricornDesc
	dw CleanseTagDesc
	dw MysticWaterDesc
	dw TwistedSpoonDesc
	dw WhtApricornDesc
	dw BlackbeltDesc
	dw BlkApricornDesc
	dw ParlyzGuardDesc
	dw PnkApricornDesc
	dw BlackGlassesDesc
	dw SlowpokeTailDesc
	dw PinkBowDesc
	dw StickDesc
	dw SmokeballDesc
	dw NeverMeltIceDesc
	dw MagnetDesc
	dw MiracleBerryDesc
	dw PearlDesc
	dw BigPearlDesc
	dw EverStoneDesc
	dw SpellTagDesc
	dw SilverEggDesc
	dw CrystalEggDesc
	dw RubyEggDesc
	dw MiracleSeedDesc
	dw GoldEggDesc
	dw FocusBandDesc
	dw ConfuseGuardDesc
	dw EnergyPowderDesc
	dw EnergyRootDesc
	dw HealPowderDesc
	dw RevivalHerbDesc
	dw HardStoneDesc
	dw LuckyEggDesc
	dw EmeraldEggDesc
	dw PrismKeyDesc
	dw RedOrbDesc
	dw GreenOrbDesc
	dw StardustDesc
	dw StarPieceDesc
	dw MansionKeyDesc
	dw BlueOrbDesc
	dw SapphireEggDesc
	dw CuroShardDesc
	dw BedroomKeyDesc
	dw CharcoalDesc
	dw BerryJuiceDesc
	dw ScopeLensDesc
	dw MegaphoneDesc
	dw CigaretteDesc
	dw MetalCoatDesc
	dw DragonFangDesc
	dw CellCardDesc
	dw LeftoversDesc
	dw CellCardDesc
	dw EagulouBallDesc
	dw GiantRockDesc
	dw MysteryBerryDesc
	dw DragonScaleDesc
	dw BerserkGeneDesc
	dw BlueFluteDesc
	dw XSpDefDesc
	dw CageKeyDesc
	dw SacredAshDesc
	dw UnusedItemDesc
	dw GoldTokenDesc
	dw UnusedItemDesc
	dw DiveballDesc
	dw FastballDesc
	dw UnusedItemDesc
	dw LightballDesc
	dw FriendballDesc
	dw UnusedItemDesc
	dw UnusedItemDesc
	dw BurntBerryDesc
	dw SullenStoneDesc
	dw SunStoneDesc
	dw PolkadotBowDesc
	dw DynamiteDesc
	dw UpGradeDesc
	dw BerryDesc
	dw GoldBerryDesc
	dw DawnStoneDesc
	dw GoldDustDesc
	dw ParkballDesc
	dw UnusedItemDesc
	dw ShinyStoneDesc
	dw BrickPieceDesc
	dw RedFluteDesc
	dw YellowFluteDesc
	dw BlackFluteDesc
	dw WhiteFluteDesc
	dw GreenFluteDesc
	dw OrangeFluteDesc
	dw SootSackDesc
	dw PurpleFluteDesc
	dw UnusedItemDesc
	dw MiningPickDesc
	dw TMCaseDesc
	dw SafeGogglesDesc
	dw RedJewelDesc
	dw BlueJewelDesc
	dw BrownJewelDesc
	dw WhiteJewelDesc
	dw PrismJewelDesc
	dw BigNuggetDesc
	dw HeatRockDesc
	dw DampRockDesc
	dw SmoothRockDesc
	dw IcyRockDesc
	dw LightClayDesc
	dw ShellBellDesc
	dw KegofBeerDesc
	dw FireRingDesc
	dw GrassRingDesc
	dw WaterRingDesc
	dw ThunderRingDesc
	dw ShinyRingDesc
	dw DawnRingDesc
	dw DuskRingDesc
	dw MoonRingDesc
	dw DuskStoneDesc
	dw UnusedItemDesc
	dw TradeStoneDesc
	dw ShinyBallDesc
	dw OreDesc
	dw BurgerDesc
	dw CoronetStoneDesc
	dw FriesDesc
	dw FossilCaseDesc
	dw SilkDesc
	dw MagmarizerDesc
	dw ElectrizerDesc
	dw PrismScaleDesc
	dw DubiousDiscDesc
	dw RazorClawDesc
	dw RazorFangDesc
	dw ProtectorDesc
	dw OrngApricornDesc
	dw CyanApricornDesc
	dw GreyApricornDesc
	dw PrplApricornDesc
	dw ShnyApricornDesc
	dw PokeballCoreDesc
	dw MysteryTcktDesc
	dw OrphanCardDesc
	dw QRReaderDesc
	dw GasMaskDesc
	dw FakeIDDesc
	dw FluffyCoatDesc
	dw RoofCardDesc
	dw LabCardDesc
	dw GrappleHookDesc
	dw QuickBallDesc
	dw DuskBallDesc
	dw RepeatBallDesc
	dw TimerBallDesc
	dw MagnetPassDesc

MasterballDesc:
	ctxt "The best ball. It"
	next "never misses."
	done

UltraballDesc:
	ctxt "A ball with a high"
	next "rate of success."
	done

BrightpowderDesc:
	ctxt "Lowers the foe's"
	next "accuracy. (Hold)"
	done

GreatballDesc:
	ctxt "A ball with a de-"
	next "cent success rate."
	done

PokeballDesc:
	ctxt "An item for catch-"
	next "ing #mon."
	done

AntidoteDesc:
	ctxt "Cures poisoned"
	next "#mon."
	done

BurnHealDesc:
	ctxt "Heals burned"
	next "#mon."
	done

IceHealDesc:
	ctxt "Defrosts frozen"
	next "#mon."
	done

AwakeningDesc:
	ctxt "Awakens sleeping"
	next "#mon."
	done

ParlyzHealDesc:
	ctxt "Heals paralyzed"
	next "#mon."
	done

FullRestoreDesc:
	ctxt "Fully restores HP"
	next "& status."
	done

MaxPotionDesc:
	ctxt "Fully restores"
	next "#mon HP."
	done

HyperPotionDesc:
	ctxt "Restores #mon"
	next "HP by 200."
	done

SuperPotionDesc:
	ctxt "Restores #mon"
	next "HP by 50."
	done

PotionDesc:
	ctxt "Restores #mon"
	next "HP by 20."
	done

EscapeRopeDesc:
	ctxt "Use for escaping"
	next "from caves, etc."
	done

RepelDesc:
	ctxt "Repels weak #-"
	next "MON for 100 steps."
	done

MaxElixerDesc:
	ctxt "Fully restores the"
	next "PP of one #mon."
	done

HPUpDesc:
	ctxt "Raises the HP of"
	next "one #mon."
	done

ProteinDesc:
	ctxt "Raises Attack of"
	next "one #mon."
	done

IronDesc:
	ctxt "Raises Defense of"
	next "one #mon."
	done

CarbosDesc:
	ctxt "Raises Speed of"
	next "one #mon."
	done

LuckyPunchDesc:
	ctxt "Ups critical hit"
	next "ratio of Chansey."
	done

CalciumDesc:
	ctxt "Ups Special stats"
	next "of one #mon."
	done

RareCandyDesc:
	ctxt "Raises level of a"
	next "#mon by one."
	done

XAccuracyDesc:
	ctxt "Raises accuracy."
	next "(1 battle)"
	done

MetalPowderDesc:
	ctxt "Raises Defense of"
	next "Ditto. (Hold)"
	done

NuggetDesc:
	ctxt "Made of pure gold."
	next "Sell high."
	done

PokeDollDesc:
	ctxt "Use to escape from"
	next "a wild #mon."
	done

FullHealDesc:
	ctxt "Eliminates all"
	next "status problems."
	done

ReviveDesc:
	ctxt "Restores a fainted"
	next "#mon to 1/2 HP."
	done

MaxReviveDesc:
	ctxt "Fully restores a"
	next "fainted #mon."
	done

GuardSpecDesc:
	ctxt "Prevents stats"
	next "reduction. (1 btl)"
	done

SuperRepelDesc:
	ctxt "Repels weak #-"
	next "mon for 200 steps."
	done

MaxRepelDesc:
	ctxt "Repels weak #-"
	next "mon for 300 steps."
	done

DireHitDesc:
	ctxt "Ups critical hit"
	next "ratio. (1 battle)"
	done

FreshWaterDesc:
	ctxt "Restores #mon"
	next "HP by 50."
	done

SodaPopDesc:
	ctxt "Restores #mon"
	next "HP by 60."
	done

LemonadeDesc:
	ctxt "Restores #mon"
	next "HP by 80."
	done

XAttackDesc:
	ctxt "Raises Attack."
	next "(1 battle)"
	done

XDefendDesc:
	ctxt "Raises Defense."
	next "(1 battle)"
	done

XSpeedDesc:
	ctxt "Raises Speed."
	next "(1 battle)"
	done

XSpecialDesc:
	ctxt "Raises Special"
	next "Attack. (1 battle)"
	done

XSpDefDesc:
	ctxt "Raises Special"
	next "Defense. (1 btl)"
	done

CoinCaseDesc:
	ctxt "Holds up to 9,999"
	next "game coins."
	done

ExpShareDesc:
	ctxt "Shares battle EXP."
	next "Points. (Hold)"
	done

OldRodDesc:
	ctxt "Use by water to"
	next "fish for #mon."
	done

GoodRodDesc:
	ctxt "A good rod for"
	next "catching #mon."
	done

SilverLeafDesc:
	ctxt "A strange, silver-"
	next "colored leaf."
	done

SuperRodDesc:
	ctxt "The best rod for"
	next "catching #mon."
	done

PPUpDesc:
	ctxt "Raises max PP of"
	next "a selected move."
	done

EtherDesc:
	ctxt "Restores PP of one"
	next "move by 10."
	done

MaxEtherDesc:
	ctxt "Fully restores PP"
	next "of one move."
	done

ElixerDesc:
	ctxt "Restores PP of all"
	next "moves by 10."
	done

MagnetPassDesc:
	ctxt "A pass for the"
	next "magnet train."
	done

SecretPotionDesc:
	ctxt "Fully heals any"
	next "#mon."
	done

MoomooMilkDesc:
	ctxt "Restores #mon"
	next "HP by 100."
	done

QuickClawDesc:
	ctxt "Raises 1st strike"
	next "ratio. (Hold)"
	done

PsnCureBerryDesc:
	ctxt "A self-cure for"
	next "poison. (Hold)"
	done

GoldLeafDesc:
	ctxt "A strange, gold-"
	next "colored leaf."
	done

SoftSandDesc:
	ctxt "Powers up ground-"
	next "type moves. (Hold)"
	done

SharpBeakDesc:
	ctxt "Powers up flying-"
	next "type moves. (Hold)"
	done

PrzCureBerryDesc:
	ctxt "A self-cure for"
	next "paralysis. (Hold)"
	done

AspearBerryDesc:
	ctxt "A self-cure for"
	next "freezing. (Hold)"
	done

IceBerryDesc:
	ctxt "A self-heal for a"
	next "burn. (Hold)"
	done

PoisonBarbDesc:
	ctxt "Powers up poison-"
	next "type moves. (Hold)"
	done

KingsRockDesc:
	ctxt "May make the foe"
	next "flinch. (Hold)"
	done

BitterBerryDesc:
	ctxt "A self-cure for"
	next "confusion. (Hold)"
	done

MintBerryDesc:
	ctxt "A self-awakening"
	next "for sleep. (Hold)"
	done

RedApricornDesc:
	ctxt "A red Apricorn."
	done

TinyMushroomDesc:
	ctxt "An ordinary mush-"
	next "room. Sell low."
	done

BigMushroomDesc:
	ctxt "A rare mushroom."
	next "Sell high."
	done

SilverPowderDesc:
	ctxt "Powers up bug-type"
	next "moves. (Hold)"
	done

BluApricornDesc:
	ctxt "A blue Apricorn."
	done

AmuletCoinDesc:
	ctxt "Doubles monetary"
	next "earnings. (Hold)"
	done

YlwApricornDesc:
	ctxt "A yellow Apricorn."
	done

GrnApricornDesc:
	ctxt "A green Apricorn."
	done

CleanseTagDesc:
	ctxt "Helps repel wild"
	next "#mon. (Hold)"
	done

MysticWaterDesc:
	ctxt "Powers up water-"
	next "type moves. (Hold)"
	done

TwistedSpoonDesc:
	ctxt "Powers up psychic-"
	next "type moves. (Hold)"
	done

WhtApricornDesc:
	ctxt "A white Apricorn."
	done

BlackbeltDesc:
	ctxt "Boosts fighting-"
	next "type moves. (Hold)"
	done

BlkApricornDesc:
	ctxt "A black Apricorn."
	done

PnkApricornDesc:
	ctxt "A pink Apricorn."
	done

BlackGlassesDesc:
	ctxt "Powers up dark-"
	next "type moves. (Hold)"
	done

SlowpokeTailDesc:
	ctxt "Very tasty. Sell"
	next "high."
	done

PinkBowDesc:
	ctxt "Powers up normal-"
	next "type moves. (Hold)"
	done

StickDesc:
	ctxt "An ordinary stick."
	next "Sell low."
	done

SmokeballDesc:
	ctxt "Escape from wild"
	next "#mon. (Hold)"
	done

NeverMeltIceDesc:
	ctxt "Powers up ice-type"
	next "moves. (Hold)"
	done

MagnetDesc:
	ctxt "Boosts electric-"
	next "type moves. (Hold)"
	done

MiracleBerryDesc:
	ctxt "Cures all status"
	next "problems. (Hold)"
	done

PearlDesc:
	ctxt "A beautiful pearl."
	next "Sell low."
	done

BigPearlDesc:
	ctxt "A big, beautiful"
	next "pearl. Sell high."
	done

EverStoneDesc:
	ctxt "Stops evolution."
	next "(Hold)"
	done

SpellTagDesc:
	ctxt "Powers up ghost-"
	next "type moves. (Hold)"
	done

RageCandyBarDesc:
	ctxt "Restores #mon"
	next "HP by 20."
	done

MiracleSeedDesc:
	ctxt "Powers up grass-"
	next "type moves. (Hold)"
	done

ThickClubDesc:
	ctxt "A bone of some"
	next "sort. Sell low."
	done

FocusBandDesc:
	ctxt "May prevent faint-"
	next "ing. (Hold)"
	done

EnergyPowderDesc:
	ctxt "Restores #mon"
	next "HP by 50. Bitter."
	done

EnergyRootDesc:
	ctxt "Restores #mon"
	next "HP by 200. Bitter."
	done

HealPowderDesc:
	ctxt "Cures all status"
	next "problems. Bitter."
	done

RevivalHerbDesc:
	ctxt "Revives fainted"
	next "#mon. Bitter."
	done

HardStoneDesc:
	ctxt "Powers up rock-"
	next "type moves. (Hold)"
	done

LuckyEggDesc:
	ctxt "Earns extra EXP."
	next "points. (Hold)"
	done

EggTicketDesc:
	ctxt "May use at Golden-"
	next "rod trade corner."
	done

StardustDesc:
	ctxt "Pretty, red sand."
	next "Sell high."
	done

StarPieceDesc:
	ctxt "A hunk of red gem."
	next "Sell very high."
	done

CharcoalDesc:
	ctxt "Powers up fire-"
	next "type moves. (Hold)"
	done

BerryJuiceDesc:
	ctxt "Restores #mon"
	next "HP by 20."
	done

ScopeLensDesc:
	ctxt "Raises critical"
	next "hit ratio. (Hold)"
	done

MetalCoatDesc:
	ctxt "Powers up steel-"
	next "type moves. (Hold)"
	done

DragonFangDesc:
	ctxt "Powers up dragon-"
	next "type moves. (Hold)"
	done

LeftoversDesc:
	ctxt "Restores HP during"
	next "battle. (Hold)"
	done

MysteryBerryDesc:
	ctxt "A self-restore"
	next "for PP. (Hold)"
	done

DragonScaleDesc:
	ctxt "A rare dragon-type"
	next "item."
	done

BerserkGeneDesc:
	ctxt "Boosts Attack but"
	next "causes confusion."
	done

SacredAshDesc:
	ctxt "Fully revives all"
	next "fainted #mon."
	done

DiveballDesc:
	ctxt "A ball for #mon"
	next "living in water."
	done

FastballDesc:
	ctxt "A ball for catch-"
	next "ing fast #mon."
	done

LightballDesc:
	ctxt "An odd, electrical"
	next "orb. (Hold)"
	done

FriendballDesc:
	ctxt "A ball that makes"
	next "#mon friendly."
	done

PolkadotBowDesc:
	ctxt "Powers up normal-"
	next "type moves. (Hold)"
	done

UpGradeDesc:
	ctxt "A mysterious box"
	next "made by Silph Co."
	done

BerryDesc:
	ctxt "A self-restore"
	next "item. (10HP, Hold)"
	done

GoldBerryDesc:
	ctxt "A self-restore"
	next "item. (30HP, Hold)"
	done

ParkballDesc:
	ctxt "The Provincial"
	next "Park ball."
	done

BrickPieceDesc:
	ctxt "A rare chunk of"
	next "tile."
	done

UnusedItemDesc:
	text "b&"
	done

CoalDesc:
	ctxt "A combustible"
	next "black rock."
	done

BicycleDesc:
	ctxt "A collapsible bike"
	next "for fast movement."
	done

OreDesc:
	ctxt "May contain a"
	next "valuable metal."
	done

BurgerDesc:
	ctxt "Restores #mon"
	next "HP by 80."
	done

FriesDesc:
	ctxt "Restores #mon"
	next "HP by 30."
	done

CoronetStoneDesc:
	ctxt "A stone found in"
	next "Mt. Coronet."
	done

TokenFinderDesc:
	ctxt "Checks for unseen"
	next "tokens nearby."
	done

HeartScaleDesc:
	ctxt "A pretty, heart-"
	next "shaped scale."
	done

RijonPassDesc:
	ctxt "Grants access to"
	next "the Rijon region."
	done

FossilCaseDesc:
	ctxt "A handy case for"
	next "#mon fossils."
	done

GoldEggDesc:
SilverEggDesc:
CrystalEggDesc:
RubyEggDesc:
SapphireEggDesc:
EmeraldEggDesc:
	ctxt "A very shiny and"
	next "mysterious egg."
	done

PrismKeyDesc:
	ctxt "A rainbow-emitting"
	next "transparent key."
	done

RedOrbDesc:
	ctxt "A red, glowing"
	next "orb from Hoenn."
	done

BlueOrbDesc:
	ctxt "A blue, glowing"
	next "orb from Hoenn."
	done

GreenOrbDesc:
	ctxt "A green, glowing"
	next "orb from Hoenn."
	done

SilkDesc:
	ctxt "Strong fiber made"
	next "by Caterpie."
	done

MansionKeyDesc:
	ctxt "Unlocks the Haun-"
	next "ted Mansion door."
	done

BedroomKeyDesc:
	ctxt "Unlocks Haunted"
	next "Mansion's bedroom."
	done

CuroShardDesc:
	ctxt "Purifies #mon"
	next "from mind control."
	done

MegaphoneDesc:
	ctxt "Powers up sound-"
	next "type moves. (Hold)"
	done

CigaretteDesc:
	ctxt "Powers up gas-"
	next "type moves. (Hold)"
	done

GiantRockDesc:
	ctxt "Large enough to"
	next "block moats."
	done

RedFluteDesc:
	ctxt "Snaps a #mon"
	next "out of infatuation"
	done

BlueFluteDesc:
	ctxt "Awakens a sleeping"
	next "#mon."
	done

YellowFluteDesc:
	ctxt "Snaps a #mon"
	next "out of confusion."
	done

BlackFluteDesc:
	ctxt "Deters wild"
	next "#mon."
	done

WhiteFluteDesc:
	ctxt "Lures wild"
	next "#mon."
	done

GreenFluteDesc:
	ctxt "Frees #mon from"
	next "being HP drained."
	done

OrangeFluteDesc:
	ctxt "Ends all weather"
	next "effects in battle."
	done

PurpleFluteDesc:
	ctxt "Clears any active"
	next "walls in battle."
	done

SootSackDesc:
	ctxt "A sack used to"
	next "hold volcanic ash."
	done

GoldTokenDesc:
	ctxt "Can be exchanged"
	next "for prizes."
	done

CageKeyDesc:
	ctxt "Used to unlock"
	next "jail cells."
	done

BurntBerryDesc:
	ctxt "An Oran Berry that"
	next "has been burnt."
	done

MoonStoneDesc:
FireStoneDesc:
ThunderStoneDesc:
WaterStoneDesc:
LeafStoneDesc:
SunStoneDesc:
DawnStoneDesc:
SullenStoneDesc:
ShinyStoneDesc:
DuskStoneDesc:
TradeStoneDesc:
	ctxt "Evolves certain"
	next "kinds of #mon."
	done

DynamiteDesc:
	ctxt "A highly explosive"
	next "red stick."
	done

GoldDustDesc:
	ctxt "Golden dust."
	next "Sell low."
	done

MiningPickDesc:
	ctxt "Used to mine"
	next "for items."
	done

TMCaseDesc:
	ctxt "Used to mine"
	next "for items."
	done

SafeGogglesDesc:
	ctxt "Immunity to weat-"
	next "her damage."
	done

RedJewelDesc:
BrownJewelDesc:
BlueJewelDesc:
WhiteJewelDesc:
PrismJewelDesc:
	ctxt "An ancient jewel"
	next "from Naljo Ruins."
	done

BigNuggetDesc:
	ctxt "A big nugget of"
	next "pure gold."
	done

HeatRockDesc:
	ctxt "Sunny Day lasts"
	next "eight turns."
	done

DampRockDesc:
	ctxt "Rain Dance lasts"
	next "eight turns."
	done

IcyRockDesc:
	ctxt "Hail lasts"
	next "eight turns."
	done

SmoothRockDesc:
	ctxt "Sandstorm lasts"
	next "eight turns."
	done

LightClayDesc:
	ctxt "Barrier moves last"
	next "eight turns."
	done

ShellBellDesc:
	ctxt "Restores HP after"
	next "striking the foe."
	done

KegofBeerDesc:
	ctxt "Alcohol that was"
	next "brewed in Rijon."
	done

GrassRingDesc:
	ctxt "Boosts Spcl.Def,"
	next "reduces Defense."
	done

FireRingDesc:
	ctxt "Boosts Defense,"
	next "reduces Spcl.Def."
	done

WaterRingDesc:
	ctxt "Boosts Attack,"
	next "reduces Evasion."
	done

ThunderRingDesc:
	ctxt "Boosts Spcl.Atk,"
	next "reduces Accuracy."
	done

MoonRingDesc:
	ctxt "Boosts Evasion,"
	next "reduces Speed."
	done

ShinyRingDesc:
	ctxt "Boosts Accuracy,"
	next "reduces Evasion."
	done

DawnRingDesc:
	ctxt "Boosts Speed,"
	next "reduces Accuracy."
	done

DuskRingDesc:
	ctxt "The effect of this"
	next "ring is unknown."
	done

ShinyBallDesc:
	ctxt "The caught #mon"
	next "becomes shiny."
	done

PoisonGuardDesc:
	ctxt "User can't get"
	next "poisoned. (Hold)"
	done

BurnGuardDesc:
	ctxt "User can't get"
	next "burned. (Hold)"
	done

FreezeGuardDesc:
	ctxt "User can't get"
	next "frozen. (Hold)"
	done

SleepGuardDesc:
	ctxt "User can't fall"
	next "asleep. (Hold)"
	done

ParlyzGuardDesc:
	ctxt "(Hold) User can't"
	next "get paralyzed."
	done

ConfuseGuardDesc:
	ctxt "User can't get"
	next "confused. (Hold)"
	done

MagmarizerDesc:
	ctxt "A box packed with"
	next "magma energy."
	done

ElectrizerDesc:
	ctxt "A box packed with"
	next "electric energy."
	done

PrismScaleDesc:
	ctxt "A shiny scale that"
	next "emits rainbows."
	done

DubiousDiscDesc:
	ctxt "Transparent device"
	next "with dubious data."
	done

RazorClawDesc:
	ctxt "Raises critical"
	next "hit ratio. (Hold)"
	done

RazorFangDesc:
	ctxt "Can cause the foe"
	next "to flinch. (Hold)"
	done

ProtectorDesc:
	ctxt "A stiff and heavy"
	next "protective item."
	done

OrngApricornDesc:
	ctxt "An orange"
	next "Apricorn."
	done

CyanApricornDesc:
	ctxt "A cyan Apricorn."
	done

GreyApricornDesc:
	ctxt "A grey Apricorn."
	done

PrplApricornDesc:
	ctxt "A purple Apricorn."
	done

ShnyApricornDesc:
	ctxt "A shiny Apricorn."
	done

PokeballCoreDesc:
	ctxt "A device used to"
	next "make #balls."
	done

MysteryTcktDesc:
	ctxt "Lets you fly to"
	next "the Mystery Zone."
	done

OrphanCardDesc:
	ctxt "Keeps track of"
	next "Orphan Points."
	done

QRReaderDesc:
	ctxt "Can decipher QR"
	next "codes."
	done

GasMaskDesc:
	ctxt "Protects from"
	next "deadly toxins."
	done

FakeIDDesc:
	ctxt "A fake Naljo"
	next "citizen ID."
	done

FluffyCoatDesc:
	ctxt "Protects you from"
	next "low temperatures."
	done

RoofCardDesc:
	ctxt "Allows access to"
	next "the prison roof."
	done

LabCardDesc:
	ctxt "Unlocks the Phlox"
	next "Lab's door."
	done

FerryTicketDesc:
	ctxt "A ferry ticket to"
	next "Route 86."
	done

GrappleHookDesc:
	ctxt "Useful for climbing"
	next "up high places."
	done

QuickBallDesc:
	ctxt "Easier to catch"
	next "on the first turn."
	done

DuskBallDesc:
	ctxt "Easier to catch"
	next "in caves or dark."
	done

RepeatBallDesc:
	ctxt "Easier to catch"
	next "if in the #dex."
	done

TimerBallDesc:
	ctxt "Easier to catch"
	next "as time goes on."
	done

CellCardDesc:
	ctxt "Opens ups a Phlox"
	next "Lab door."
	done

EagulouBallDesc:
	ctxt "The ball for the"
	next "Eagulou Park."
	done
	