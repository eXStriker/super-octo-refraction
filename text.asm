INCLUDE "includes.asm"

SECTION "Pokedex Entries 001-064", ROMX, BANK[POKEDEX_ENTRIES_1]
PokedexEntries1:: INCLUDE "data/pokedex/entries_1.asm"

SECTION "Pokedex Entries 065-254", ROMX, BANK[POKEDEX_ENTRIES_2]
PokedexEntries2:: INCLUDE "data/pokedex/entries_2.asm"
PokedexEntries3:: INCLUDE "data/pokedex/entries_3.asm"
PokedexEntries4:: INCLUDE "data/pokedex/entries_4.asm"

SECTION "Text 1", ROMX, BANK[TEXT_1]
INCLUDE "text/common_1.ctf"

SECTION "Text 2", ROMX, BANK[TEXT_2]
INCLUDE "text/common_2.ctf"

SECTION "Text 3", ROMX, BANK[TEXT_3]
INCLUDE "text/common_3.ctf"

SECTION "Text 4", ROMX, BANK[TEXT_4]
INCLUDE "text/common_4.ctf"

SECTION "Text 5", ROMX, BANK[TEXT_5]
INCLUDE "text/common_5.ctf"

SECTION "Text 6", ROMX, BANK[TEXT_6]
INCLUDE "text/common_6.ctf"

SECTION "Text 7", ROMX, BANK[TEXT_7]
INCLUDE "text/common_7.ctf"

SECTION "Text 8", ROMX, BANK[TEXT_8]
INCLUDE "text/common_8.ctf"

SECTION "Text 9", ROMX, BANK[TEXT_9]
INCLUDE "text/common_9.ctf"

SECTION "Text 10", ROMX, BANK[TEXT_10]
INCLUDE "text/common_10.ctf"

SECTION "Standard Text", ROMX, BANK[TEXT_STANDARD]
INCLUDE "text/stdtext.ctf"

SECTION "Judge Text", ROMX, BANK[TEXT_JUDGE]
INCLUDE "text/judge.ctf"
