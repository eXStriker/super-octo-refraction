item_attribute: MACRO
; (ignored, reserved for item name), price, held effect, parameter, property, pocket, field menu, battle menu
	dw \2
	db \3, \4, \5, \6
	dn \7, \8
ENDM


ItemAttributes:
	item_attribute Master Ball,      0, HELD_NONE,               0, CANT_SELECT,             BALL,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute Ultra Ball,    1200, HELD_NONE,               0, CANT_SELECT,             BALL,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute BrightPowder,    10, HELD_BRIGHTPOWDER,      20, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Great Ball,     600, HELD_NONE,               0, CANT_SELECT,             BALL,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute # Ball,         200, HELD_NONE,               0, CANT_SELECT,             BALL,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute Coal,            50, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Bicycle,          0, HELD_NONE,               0, CANT_TOSS,               KEY_ITEM, ITEMMENU_CLOSE,   ITEMMENU_NOUSE
	item_attribute Moon Stone,    2100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_NOUSE
	item_attribute Antidote,       100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Burn Heal,      250, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Ice Heal,       250, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Awakening,      250, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Parlyz Heal,    200, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Full Restore,  3000, HELD_NONE,              -1, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Max Potion,    2500, HELD_NONE,              -1, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Hyper Potion,  1200, HELD_NONE,             200, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Super Potion,   700, HELD_NONE,              50, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Potion,         300, HELD_NONE,              20, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Escape Rope,    550, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_CLOSE,   ITEMMENU_NOUSE
	item_attribute Repel,          350, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_CURRENT, ITEMMENU_NOUSE
	item_attribute Max Elixir,    4500, HELD_NONE,              -1, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Fire Stone,    2100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_NOUSE
	item_attribute ThunderStone,  2100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_NOUSE
	item_attribute Water Stone,   2100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_NOUSE
	item_attribute Poison Guard,  5000, HELD_PREVENT_POISON,     0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute HP Up,         9800, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_NOUSE
	item_attribute Protein,       9800, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_NOUSE
	item_attribute Iron,          9800, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_NOUSE
	item_attribute Carbos,        9800, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_NOUSE
	item_attribute Lucky Punch,     10, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Calcium,       9800, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_NOUSE
	item_attribute Rare Candy,    4800, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_NOUSE
	item_attribute X Accuracy,     950, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute Leaf Stone,    2100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_NOUSE
	item_attribute Metal Powder,    10, HELD_METAL_POWDER,      10, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Nugget,       10000, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute # Doll,        1000, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute Full Heal,      600, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Revive,        1500, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Max Revive,    4000, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Guard Spec.,    700, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute Super Repel,    500, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_CURRENT, ITEMMENU_NOUSE
	item_attribute Max Repel,      700, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_CURRENT, ITEMMENU_NOUSE
	item_attribute Dire Hit,       650, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute Burn Guard,    5000, HELD_PREVENT_BURN,       0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Fresh Water,    200, HELD_NONE,              50, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Soda Pop,       300, HELD_NONE,              60, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Lemonade,       350, HELD_NONE,              80, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute X Attack,       500, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute Freeze Guard,  5000, HELD_PREVENT_FREEZE,     0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute X Defend,       550, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute X Speed,        350, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute X Special,      350, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute Coin Case,        0, HELD_NONE,               0, CANT_TOSS,               KEY_ITEM, ITEMMENU_CURRENT, ITEMMENU_NOUSE
	item_attribute TokenFinder,      0, HELD_NONE,               0, CANT_TOSS,               KEY_ITEM, ITEMMENU_CLOSE,   ITEMMENU_NOUSE
	item_attribute Heart Scale,    100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Exp. Share,    3000, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Old Rod,          0, HELD_NONE,               0, CANT_TOSS,               KEY_ITEM, ITEMMENU_CLOSE,   ITEMMENU_NOUSE
	item_attribute Good Rod,         0, HELD_NONE,               0, CANT_TOSS,               KEY_ITEM, ITEMMENU_CLOSE,   ITEMMENU_NOUSE
	item_attribute Silver Leaf,   1000, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Super Rod,        0, HELD_NONE,               0, CANT_TOSS,               KEY_ITEM, ITEMMENU_CLOSE,   ITEMMENU_NOUSE
	item_attribute PP Up,         9800, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_NOUSE
	item_attribute Ether,         1200, HELD_NONE,              10, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Max Ether,     2000, HELD_NONE,              -1, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Elixir,        3000, HELD_NONE,              10, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Cage Card 1,      0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_CLOSE,   ITEMMENU_NOUSE
	item_attribute Rijon Pass,       0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Ferry Ticket,     0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Cage Card 2,      0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Cage Card 3,      0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Cage Card 4,      0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Moomoo Milk,    900, HELD_NONE,             100, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Quick Claw,     100, HELD_QUICK_CLAW,        60, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Pecha Berry,     10, HELD_HEAL_POISON,        0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Gold Leaf,     1000, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Soft Sand,      100, HELD_GROUND_BOOST,      20, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Sharp Beak,     100, HELD_FLYING_BOOST,      20, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Cheri Berry,     10, HELD_HEAL_PARALYZE,      0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Aspear Berry,    10, HELD_HEAL_FREEZE,        0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Rawst Berry,     10, HELD_HEAL_BURN,          0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Poison Barb,    100, HELD_POISON_BOOST,      20, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute King's Rock,    100, HELD_FLINCH,             0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Persim Berry,    10, HELD_HEAL_CONFUSION,     0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_PARTY
	item_attribute Chesto Berry,    10, HELD_HEAL_SLEEP,         0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Red Apricorn,   200, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute TinyMushroom,   500, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Big Mushroom,  5000, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute SilverPowder,   100, HELD_BUG_BOOST,         20, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Blu Apricorn,   200, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Sleep Guard,   5000, HELD_PREVENT_SLEEP,      0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Amulet Coin,    100, HELD_AMULET_COIN,       10, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Ylw Apricorn,   200, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Grn Apricorn,   200, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Cleanse Tag,    200, HELD_CLEANSE_TAG,        0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Mystic Water,   100, HELD_WATER_BOOST,       20, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute TwistedSpoon,   100, HELD_PSYCHIC_BOOST,     20, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Wht Apricorn,   200, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Blackbelt,      100, HELD_FIGHTING_BOOST,    20, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Blk Apricorn,   200, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute PrzGuard,      5000, HELD_PREVENT_CONFUSE,    0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Pnk Apricorn,   200, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute BlackGlasses,   100, HELD_DARK_BOOST,        20, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute SlowpokeTail,  9800, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Pink Bow,       100, HELD_FAIRY_BOOST,       20, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Stick,          200, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Smoke Ball,     200, HELD_ESCAPE,             0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute NeverMeltIce,   100, HELD_ICE_BOOST,         20, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Magnet,         100, HELD_ELECTRIC_BOOST,    20, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Lum Berry,       10, HELD_HEAL_STATUS,        0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Pearl,         1400, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Big Pearl,     7200, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Everstone,      200, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Spell Tag,      100, HELD_GHOST_BOOST,       20, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Silver Egg,       0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Crystal Egg,      0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Ruby Egg,         0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Miracle Seed,   100, HELD_GRASS_BOOST,       20, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Gold Egg,         0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Focus Band,     200, HELD_FOCUS_BAND,        30, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute ConfuseGuard,  5000, HELD_PREVENT_CONFUSE,    0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute EnergyPowder,   500, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Energy Root,    800, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Heal Powder,    450, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Revival Herb,  2800, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Hard Stone,     100, HELD_ROCK_BOOST,        20, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Lucky Egg,      200, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Emerald Egg,      0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_CLOSE,   ITEMMENU_NOUSE
	item_attribute Prism Key,        0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_CLOSE,   ITEMMENU_NOUSE
	item_attribute Red Orb,          0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_CLOSE,   ITEMMENU_NOUSE
	item_attribute Green Orb,        0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_CLOSE,   ITEMMENU_NOUSE
	item_attribute Stardust,      1800, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Starpiece,     4900, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Mansion Key,      0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Blue Orb,         0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Sapphire Egg,     0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Curo Shard,       0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, ITEM,     ITEMMENU_CLOSE,   ITEMMENU_NOUSE
	item_attribute Bedroom Key,      0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Charcoal,      9800, HELD_FIRE_BOOST,        20, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Berry Juice,    100, HELD_BERRY,             20, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Scope Lens,     200, HELD_CRITICAL_UP,        0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Megaphone,      100, HELD_SOUND_BOOST,       20, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Cigarette,      100, HELD_GAS_BOOST,         20, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Metal Coat,     100, HELD_STEEL_BOOST,       20, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Dragon Fang,    100, HELD_DRAGON_BOOST,      20, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Cage Card 5,      0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Leftovers,      200, HELD_LEFTOVERS,         10, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Cage Card 6,      0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Eagulou Ball,   100, HELD_NONE,               0, CANT_SELECT,             BALL,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute Giant Rock,       0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Leppa Berry,     10, HELD_RESTORE_PP,        -1, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Dragon Scale,  2100, HELD_NONE,              20, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Berserk Gene,   200, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Blue Flute,      50, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute X Sp.Def,       350, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute Cage Key,         0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Sacred Ash,     200, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_CLOSE,   ITEMMENU_NOUSE
	item_attribute (unused $9d), $9999, HELD_NONE,               0, 0,                       ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Gold Token,       0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute (unused $9f), $9999, HELD_NONE,               0, 0,                       ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Dive Ball,     1000, HELD_NONE,               0, CANT_SELECT,             BALL,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute Fast Ball,      150, HELD_NONE,               0, CANT_SELECT,             BALL,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute (unused $a2), $9999, HELD_NONE,               0, 0,                       ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Light Ball,     100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Friend Ball,    150, HELD_NONE,               0, CANT_SELECT,             BALL,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute (unused $a5), $9999, HELD_NONE,               0, 0,                       ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute (unused $a6), $9999, HELD_NONE,               0, 0,                       ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Burnt Berry,      0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, ITEM,     ITEMMENU_CURRENT, ITEMMENU_NOUSE
	item_attribute Sullen Stone,  2100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_NOUSE
	item_attribute Sun Stone,     2100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_NOUSE
	item_attribute Polkadot Bow,   100, HELD_NORMAL_BOOST,      20, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Dynamite,         0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, ITEM,     ITEMMENU_CURRENT, ITEMMENU_NOUSE
	item_attribute Up-Grade,      2100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Oran Berry,      10, HELD_BERRY,             10, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Sitrus Berry,    10, HELD_BERRY,             30, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Dawn Stone,    2100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_NOUSE
	item_attribute Gold Dust,      400, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Park Ball,        0, HELD_NONE,               0, CANT_SELECT,             BALL,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute (unused $b2),     0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Shiny Stone,   2100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_NOUSE
	item_attribute Brick Piece,     50, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Red Flute,       50, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute Yellow Flute,    50, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute Black Flute,     50, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_CURRENT, ITEMMENU_NOUSE
	item_attribute White Flute,     50, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_CURRENT, ITEMMENU_NOUSE
	item_attribute Green Flute,     50, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute Orange Flute,    50, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute Soot Sack,        0, HELD_NONE,               0, CANT_TOSS,               KEY_ITEM, ITEMMENU_CURRENT, ITEMMENU_NOUSE
	item_attribute Purple Flute,    50, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute (unused $bd),    50, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Mining Pick,    500, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute TM Case,          0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, TM_HM,    ITEMMENU_PARTY,   ITEMMENU_NOUSE
	item_attribute Safe Goggles,  2000, HELD_SAFE_GOGGLES,       0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Red Jewel,        0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Blue Jewel,       0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Brown Jewel,      0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute White Jewel,      0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Prism Jewel,      0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Big Nugget,   30000, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Heat Rock,     2000, HELD_HEAT_ROCK,          0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Damp Rock,     2000, HELD_DAMP_ROCK,          0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Smooth Rock,   2000, HELD_SMOOTH_ROCK,        0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Icy Rock,      2000, HELD_ICY_ROCK,           0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Light Clay,    2000, HELD_LIGHT_CLAY,         0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Shell Bell,    2000, HELD_SHELL_BELL,         0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Keg of Beer,    200, HELD_NONE,              50, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Fire Ring,      100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Grass Ring,     100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Water Ring,     100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Thunder Ring,   100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Shiny Ring,     100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Dawn Ring,      100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Dusk Ring,      100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Moon Ring,      100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Dusk Stone,    2100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_NOUSE
	item_attribute (unused $d7), $9999, HELD_NONE,               0, 0,                       ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Trade Stone,   2100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_NOUSE
	item_attribute Shiny Ball,    1000, HELD_NONE,               0, CANT_SELECT,             BALL,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute Ore,            100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Burger,         500, HELD_NONE,              40, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute CoronetStone,  2100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_NOUSE
	item_attribute Fries,          250, HELD_NONE,              30, CANT_SELECT,             ITEM,     ITEMMENU_PARTY,   ITEMMENU_PARTY
	item_attribute Fossil Case,      0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_CURRENT, ITEMMENU_NOUSE
	item_attribute Silk,           250, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Magmarizer,    2100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Electirizer,   2100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Prism Scale,    250, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Dubious Disc,  2100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Razor Claw,    2100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Razor Fang,    2100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Protector,     2100, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute OrngApricorn,   200, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute CyanApricorn,   200, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute GreyApricorn,   200, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute PrplApricorn,   200, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute ShnyApricorn,   200, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute #BallCore,       50, HELD_NONE,               0, CANT_SELECT,             ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Mystery Tckt,     0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Orphan Card,      0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_CURRENT, ITEMMENU_NOUSE
	item_attribute QR Scanner,       0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Gas Mask,         0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Fake ID,          0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Fluffy Coat,      0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Roof Card,        0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Lab Card,         0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Grapple Hook,     0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Quick Ball,    1000, HELD_NONE,               0, CANT_SELECT,             BALL,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute Dusk Ball,     1000, HELD_NONE,               0, CANT_SELECT,             BALL,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute Repeat Ball,   1000, HELD_NONE,               0, CANT_SELECT,             BALL,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute Timer Ball,    1000, HELD_NONE,               0, CANT_SELECT,             BALL,     ITEMMENU_NOUSE,   ITEMMENU_CLOSE
	item_attribute Magnet Pass,      0, HELD_NONE,               0, CANT_SELECT | CANT_TOSS, KEY_ITEM, ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute (unused $fb), $9999, HELD_NONE,               0, 0,                       ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute (unused $fc), $9999, HELD_NONE,               0, 0,                       ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute (unused $fd), $9999, HELD_NONE,               0, 0,                       ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
	item_attribute Fossil,       $9999, HELD_NONE,               0, 0,                       ITEM,     ITEMMENU_NOUSE,   ITEMMENU_NOUSE
