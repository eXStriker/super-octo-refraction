SECTION "Effect Commands", ROMX[$4000], BANK[EFFECT_COMMANDS]

INCLUDE "battle/effect_commands.asm"

INCLUDE "battle/damage.asm"

SECTION "Enemy Trainers", ROMX[$4000], BANK[ENEMY_TRAINERS]

INCLUDE "trainers/get_trainer_data.asm"
INCLUDE "trainers/attributes.asm"
INCLUDE "trainers/read_party.asm"
INCLUDE "trainers/trainer_pointers.asm"
INCLUDE "trainers/trainers.asm"

SECTION "Battle Core", ROMX[$4000], BANK[BATTLE_CORE]

INCLUDE "battle/core.ctf"
INCLUDE "battle/effect_command_pointers.asm"
