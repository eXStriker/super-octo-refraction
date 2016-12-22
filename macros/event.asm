	enum_start

	enum scall_command
scall: macro
	db scall_command
	dw \1 ; pointer
	endm

	enum farscall_command
farscall: macro
	db farscall_command
	dba \1
	endm

	enum ptcall_command
ptcall: macro
	db ptcall_command
	dw \1 ; pointer
	endm

	enum jump_command
jump: macro
	db jump_command
	dw \1 ; pointer
	endm

	enum farjump_command
farjump: macro
	db farjump_command
	dba \1
	endm

	enum ptjump_command
ptjump: macro
	db ptjump_command
	dw \1 ; pointer
	endm

	enum if_equal_command
if_equal: macro
	db if_equal_command
	db \1 ; byte
	dw \2 ; pointer
	endm

	enum if_not_equal_command
if_not_equal: macro
	db if_not_equal_command
	db \1 ; byte
	dw \2 ; pointer
	endm

	enum iffalse_command
iffalse: macro
	db iffalse_command
	dw \1 ; pointer
	endm

	enum iftrue_command
iftrue: macro
	db iftrue_command
	dw \1 ; pointer
	endm

	enum if_greater_than_command
if_greater_than: macro
	db if_greater_than_command
	db \1 ; byte
	dw \2 ; pointer
	endm

	enum if_less_than_command
if_less_than: macro
	db if_less_than_command
	db \1 ; byte
	dw \2 ; pointer
	endm

	enum jumpstd_command
jumpstd: macro
	db jumpstd_command
	db \1 ; predefined_script
	endm

	enum callstd_command
callstd: macro
	db callstd_command
	db \1 ; predefined_script
	endm

	enum callasm_command
callasm: macro
	db callasm_command
	dba \1
	endm

	enum special_command
special: macro
	db special_command
	db (\1Special - SpecialsPointers) / 3
	endm

add_special: MACRO
\1Special::
	dba \1
ENDM

	enum ptcallasm_command
ptcallasm: macro
	db ptcallasm_command
	dw \1 ; asm
	endm

	enum checkmaptriggers_command
checkmaptriggers: macro
	db checkmaptriggers_command
	map \1 ; map
	endm

	enum domaptrigger_command
domaptrigger: macro
	db domaptrigger_command
	map \1 ; map
	db \2 ; trigger_id
	endm

	enum checktriggers_command
checktriggers: macro
	db checktriggers_command
	endm

	enum dotrigger_command
dotrigger: macro
	db dotrigger_command
	db \1 ; trigger_id
	endm

	enum writebyte_command
writebyte: macro
	db writebyte_command
	db \1 ; value
	endm

	enum addvar_command
addvar: macro
	db addvar_command
	db \1 ; value
	endm

	enum random_command
random: macro
	db random_command
	IF _NARG == 1
		db \1 ; input
	ELSE
		db 0
	ENDC
	endm

	enum readarrayhalfword_command
readarrayhalfword: macro
	db readarrayhalfword_command
	db \1 ; array entry index
	endm

	enum copybytetovar_command
copybytetovar: macro
	db copybytetovar_command
	dw \1 ; address
	endm

	enum copyvartobyte_command
copyvartobyte: macro
	db copyvartobyte_command
	dw \1 ; address
	endm

	enum loadvar_command
loadvar: macro
	db loadvar_command
	dw \1 ; address
	db \2 ; value
	endm

	enum checkcode_command
checkcode: macro
	db checkcode_command
	db \1 ; variable_id
	endm

	enum writevarcode_command
writevarcode: macro
	db writevarcode_command
	db \1 ; variable_id
	endm

	enum writecode_command
writecode: macro
	db writecode_command
	db \1 ; variable_id
	db \2 ; value
	endm

	enum giveitem_command
giveitem: macro
	db giveitem_command
	db \1 ; item
if _NARG == 2
	db \2 ; quantity
else
	db 1
endc
	endm

	enum takeitem_command
takeitem: macro
	db takeitem_command
	db \1 ; item
if _NARG == 2
	db \2 ; quantity
else
	db 1
endc
	endm

	enum checkitem_command
checkitem: macro
	db checkitem_command
	db \1 ; item
	endm

	enum givemoney_command
givemoney: macro
	db givemoney_command
	db \1 ; account
	dt \2 ; money
	endm

	enum takemoney_command
takemoney: macro
	db takemoney_command
	db \1 ; account
	dt \2 ; money
	endm

	enum checkmoney_command
checkmoney: macro
	db checkmoney_command
	db \1 ; account
	dt \2 ; money
	endm

	enum givecoins_command
givecoins: macro
	db givecoins_command
	dw \1 ; coins
	endm

	enum takecoins_command
takecoins: macro
	db takecoins_command
	dw \1 ; coins
	endm

	enum checkcoins_command
checkcoins: macro
	db checkcoins_command
	dw \1 ; coins
	endm

	enum writehalfword_command
writehalfword: macro
	db writehalfword_command
	dw \1 ; halfword to store
	endm

	enum pushhalfword_command
pushhalfword: macro
	db pushhalfword_command
	dw \1 ; halfword to push
	endm

	enum pushhalfwordvar_command
pushhalfwordvar: macro
	db pushhalfwordvar_command
	endm

	enum checktime_command
checktime: macro
	db checktime_command
	db \1 ; time
	endm

checkmorn EQUS "checktime 1 << MORN"
checkday  EQUS "checktime 1 << DAY"
checknite EQUS "checktime 1 << NITE"

	enum checkpoke_command
checkpoke: macro
	db checkpoke_command
	db \1 ; pkmn
	endm

	enum givepoke_command
givepoke: macro
	db givepoke_command
	db \1 ; pokemon
	db \2 ; level
	if _NARG >= 3
	db \3 ; item
	if _NARG >= 4
	db \4 ; trainer
	if \4
	dw \5 ; trainer_name_pointer
	dw \6 ; pkmn_nickname
	endc
	else
	db 0
	endc
	else
	db NO_ITEM, 0
	endc
	endm

	enum giveegg_command
giveegg: macro
	db giveegg_command
	db \1 ; pkmn
	db \2 ; level
	endm

	enum givefossil_command
givefossil: macro
	db givefossil_command
	endm

	enum takefossil_command
takefossil: macro
	db takefossil_command
	endm

	enum checkevent_command
checkevent: macro
	db checkevent_command
	dw \1 ; event_flag
	endm

	enum clearevent_command
clearevent: macro
	db clearevent_command
	dw \1 ; event_flag
	endm

	enum setevent_command
setevent: macro
	db setevent_command
	dw \1 ; event_flag
	endm

	enum checkflag_command
checkflag: macro
	db checkflag_command
	dw \1 ; engine_flag
	endm

	enum clearflag_command
clearflag: macro
	db clearflag_command
	dw \1 ; engine_flag
	endm

	enum setflag_command
setflag: macro
	db setflag_command
	dw \1 ; engine_flag
	endm

	enum wildon_command
wildon: macro
	db wildon_command
	endm

	enum wildoff_command
wildoff: macro
	db wildoff_command
	endm

	enum warpmod_command
warpmod: macro
	db warpmod_command
	db \1 ; warp_id
	map \2 ; map
	endm

	enum blackoutmod_command
blackoutmod: macro
	db blackoutmod_command
	map \1 ; map
	endm

	enum warp_command
warp: macro
	db warp_command
	map \1 ; map
	db \2 ; x
	db \3 ; y
	endm

	enum readmoney_command
readmoney: macro
	db readmoney_command
	db \1 ; account
	db \2 ; memory
	endm

	enum readcoins_command
readcoins: macro
	db readcoins_command
	db \1 ; memory
	endm

	enum RAM2MEM_command
RAM2MEM: macro
	db RAM2MEM_command
	db \1 ; memory
	endm

	enum pokenamemem_command
pokenamemem: macro
	db pokenamemem_command
	db \1 ; pokemon
	db \2 ; memory
	endm

	enum itemtotext_command
itemtotext: macro
	db itemtotext_command
	db \1 ; item
	db \2 ; memory
	endm

	enum mapnametotext_command
mapnametotext: macro
	db mapnametotext_command
	db \1 ; memory
	endm

	enum trainertotext_command
trainertotext: macro
	db trainertotext_command
	db \1 ; trainer_id
	db \2 ; trainer_group
	db \3 ; memory
	endm

	enum stringtotext_command
stringtotext: macro
	db stringtotext_command
	dw \1 ; text_pointer
	db \2 ; memory
	endm

	enum itemnotify_command
itemnotify: macro
	db itemnotify_command
	endm

	enum pocketisfull_command
pocketisfull: macro
	db pocketisfull_command
	endm

	enum opentext_command
opentext: macro
	db opentext_command
	endm

	enum refreshscreen_command
refreshscreen: macro
	db refreshscreen_command
	endm

	enum closetext_command
closetext: macro
	db closetext_command
	endm

	enum cmdwitharrayargs_command
cmdwitharrayargs: macro
	db cmdwitharrayargs_command
	db \1 ; skip offset (for script conditionals)
	endm

customarraycmd: macro
	db \1_command ; command
	db \2 ; length
	shift
; just do a hardcode for now
	if _NARG == 2
		db (\2 - 1)
		db $00
	else
		if _NARG == 3
			db (\3 - 1) << 2 | (\2 - 1)
			db $00
		else
			if _NARG == 4
				db (\4 - 1) << 4 | (\3 - 1) << 2 | (\2 - 1)
				db $00
			else
				if _NARG == 5
					db (\5 - 1) << 6 | (\4 - 1) << 4 | (\3 - 1) << 2 | (\2 - 1)
					db $00
				else
					if _NARG == 6
						db (\5 - 1) << 6 | (\4 - 1) << 4 | (\3 - 1) << 2 | (\2 - 1)
						db (\6 - 1)
					else
						if _NARG == 7
							db (\5 - 1) << 6 | (\4 - 1) << 4 | (\3 - 1) << 2 | (\2 - 1)
							db (\7 - 1) << 2 | (\6 - 1)
						else
							if _NARG == 8
								db (\5 - 1) << 6 | (\4 - 1) << 4 | (\3 - 1) << 2 | (\2 - 1)
								db (\8 - 1) << 4 | (\7 - 1) << 2 | (\6 - 1)
							else
								db (\5 - 1) << 6 | (\4 - 1) << 4 | (\3 - 1) << 2 | (\2 - 1)
								db (\9 - 1) << 6 | (\8 - 1) << 4 | (\7 - 1) << 2 | (\6 - 1)
							endc
						endc
					endc
				endc
			endc
		endc
	endc
	endm
	
	enum farwritetext_command
farwritetext: macro
	db farwritetext_command
	dba \1
	endm

	enum writetext_command
writetext: macro
	db writetext_command
	dw \1 ; text_pointer
	endm

	enum repeattext_command
repeattext: macro
	db repeattext_command
	endm

	enum yesorno_command
yesorno: macro
	db yesorno_command
	endm

	enum loadmenudata_command
loadmenudata: macro
	db loadmenudata_command
	dw \1 ; data
	endm

	enum closewindow_command
closewindow: macro
	db closewindow_command
	endm

	enum jumptextfaceplayer_command
jumptextfaceplayer: macro
	db jumptextfaceplayer_command
	dw \1 ; text_pointer
	endm

	enum farjumptext_command
farjumptext: macro
	db farjumptext_command
	if "\1" == "-1"
		db \1
		dw -1
	else
		dba \1
	endc
	endm

	enum jumptext_command
jumptext: macro
	db jumptext_command
	dw \1 ; text_pointer
	endm

	enum waitbutton_command
waitbutton: macro
	db waitbutton_command
	endm

	enum buttonsound_command
buttonsound: macro
	db buttonsound_command
	endm

	enum pokepic_command
pokepic: macro
	db pokepic_command
	db \1 ; pokemon
	endm

	enum closepokepic_command
closepokepic: macro
	db closepokepic_command
	endm

	enum _2dmenu_command
_2dmenu: macro
	db _2dmenu_command
	endm

	enum verticalmenu_command
verticalmenu: macro
	db verticalmenu_command
	endm

	enum scrollingmenu_command
scrollingmenu: macro
	db scrollingmenu_command
	db \1 ; flags
	endm

	enum randomwildmon_command
randomwildmon: macro
	db randomwildmon_command
	endm

	enum loadmemtrainer_command
loadmemtrainer: macro
	db loadmemtrainer_command
	endm

	enum loadwildmon_command
loadwildmon: macro
	db loadwildmon_command
	if _NARG == 2
		db \1 ; pokemon
		db \2 ; level
	else
		if _NARG > 2
			db \1 ; pokemon
			db \2 | $80 ; level, additional data flag
			db \3 ; item
			if _NARG > 3
				db \4 ; move 1
			else
				db $00
			endc
			if _NARG > 4
				db \5 ; move 2
			else
				db $00
			endc
			if _NARG > 5
				db \6 ; move 3
			else
				db $00
			endc
			if _NARG > 6
				db \7 ; move 4
			else
				db $00
			endc
		endc
	endc
	endm

	enum loadtrainer_command
loadtrainer: macro
	db loadtrainer_command
	db \1 ; trainer_group
	db \2 ; trainer_id
	endm

	enum startbattle_command
startbattle: macro
	db startbattle_command
	endm

	enum reloadmapafterbattle_command
reloadmapafterbattle: macro
	db reloadmapafterbattle_command
	endm

	enum catchtutorial_command
catchtutorial: macro
	db catchtutorial_command
	db \1 ; byte
	endm

	enum trainertext_command
trainertext: macro
	db trainertext_command
	db \1 ; which_text
	endm

	enum trainerflagaction_command
trainerflagaction: macro
	db trainerflagaction_command
	db \1 ; action
	endm

	enum winlosstext_command
winlosstext: macro
	db winlosstext_command
	dw \1 ; win_text_pointer
	dw \2 ; loss_text_pointer
	endm

	enum scripttalkafter_command
scripttalkafter: macro
	db scripttalkafter_command
	endm

	enum end_if_just_battled_command
end_if_just_battled: macro
	db end_if_just_battled_command
	endm

	enum check_just_battled_command
check_just_battled: macro
	db check_just_battled_command
	endm

	enum setlasttalked_command
setlasttalked: macro
	db setlasttalked_command
	db \1 ; person
	endm

	enum applymovement_command
applymovement: macro
	db applymovement_command
	db \1 ; person
	dw \2 ; data
	endm

	enum applymovement2_command
applymovement2: macro
	db applymovement2_command
	dw \1 ; data
	endm

	enum faceplayer_command
faceplayer: macro
	db faceplayer_command
	endm

	enum faceperson_command
faceperson: macro
	db faceperson_command
	db \1 ; person1
	db \2 ; person2
	endm

	enum variablesprite_command
variablesprite: macro
	db variablesprite_command
	db \1 - SPRITE_VARS ; byte
	db \2 ; sprite
	endm

	enum disappear_command
disappear: macro
	db disappear_command
	db \1 ; person
	endm

	enum appear_command
appear: macro
	db appear_command
	db \1 ; person
	endm

	enum follow_command
follow: macro
	db follow_command
	db \1 ; person2
	db \2 ; person1
	endm

	enum stopfollow_command
stopfollow: macro
	db stopfollow_command
	endm

	enum moveperson_command
moveperson: macro
	db moveperson_command
	db \1 ; person
	db \2 ; x
	db \3 ; y
	endm

	enum writepersonxy_command
writepersonxy: macro
	db writepersonxy_command
	db \1 ; person
	endm

	enum loademote_command
loademote: macro
	db loademote_command
	db \1 ; bubble
	endm

	enum showemote_command
showemote: macro
	db showemote_command
	db \1 ; bubble
	db \2 ; person
	db \3 ; time
IF _NARG >= 4
	db \4 ; flag
ELSE
	db 1
ENDC
	endm

	enum spriteface_command
spriteface: macro
	db spriteface_command
	db \1 ; person
	db \2 ; facing
	endm

	enum follownotexact_command
follownotexact: macro
	db follownotexact_command
	db \1 ; person2
	db \2 ; person1
	endm

	enum earthquake_command
earthquake: macro
	db earthquake_command
	db \1 ; param
	endm

	enum changemap_command
changemap: macro
	db changemap_command
	db \1 ; map_bank
	dw \2 ; map_data_pointer
	endm

	enum changeblock_command
changeblock: macro
	db changeblock_command
	db \1 ; x
	db \2 ; y
	db \3 ; block
	endm

	enum reloadmap_command
reloadmap: macro
	db reloadmap_command
	endm

	enum reloadmappart_command
reloadmappart: macro
	db reloadmappart_command
	endm

	enum writecmdqueue_command
writecmdqueue: macro
	db writecmdqueue_command
	dw \1 ; queue_pointer
	endm

	enum delcmdqueue_command
delcmdqueue: macro
	db delcmdqueue_command
	db \1 ; byte
	endm

	enum playmusic_command
playmusic: macro
	db playmusic_command
	dw \1 ; music_pointer
	endm

	enum encountermusic_command
encountermusic: macro
	db encountermusic_command
	endm

	enum musicfadeout_command
musicfadeout: macro
	db musicfadeout_command
	dw \1 ; music
	db \2 ; fadetime
	endm

	enum playmapmusic_command
playmapmusic: macro
	db playmapmusic_command
	endm

	enum dontrestartmapmusic_command
dontrestartmapmusic: macro
	db dontrestartmapmusic_command
	endm

	enum cry_command
cry: macro
	db cry_command
	db \1 ; cry_id
	endm

	enum playsound_command
playsound: macro
	db playsound_command
	dw \1 ; sound_pointer
	endm

	enum waitsfx_command
waitsfx: macro
	db waitsfx_command
	endm

	enum warpsound_command
warpsound: macro
	db warpsound_command
	endm

	enum passtoengine_command
passtoengine: macro
	db passtoengine_command
	db \1 ; data_pointer
	endm

	enum newloadmap_command
newloadmap: macro
	db newloadmap_command
	db \1 ; which_method
	endm

	enum pause_command
pause: macro
	db pause_command
	db \1 ; length
	endm

	enum deactivatefacing_command
deactivatefacing: macro
	db deactivatefacing_command
	db \1 ; time
	endm

	enum priorityjump_command
priorityjump: macro
	db priorityjump_command
	dw \1 ; pointer
	endm

	enum warpcheck_command
warpcheck: macro
	db warpcheck_command
	endm

	enum ptpriorityjump_command
ptpriorityjump: macro
	db ptpriorityjump_command
	dw \1 ; pointer
	endm

	enum return_command
return: macro
	db return_command
	endm

	enum end_command
end: macro
	db end_command
	endm

	enum reloadandreturn_command
reloadandreturn: macro
	db reloadandreturn_command
	db \1 ; which_method
	endm

	enum end_all_command
end_all: macro
	db end_all_command
	endm

	enum pokemart_command
pokemart: macro
	db pokemart_command
	db \1 ; dialog_id
	db \2 ; mart_id
	endm

	enum elevator_command
elevator: macro
	db elevator_command
	dw \1 ; floor_list_pointer
	endm

	enum trade_command
trade: macro
	db trade_command
	db \1 ; trade_id
	endm

	enum pophalfwordvar_command
pophalfwordvar: macro
	db pophalfwordvar_command
	endm

	enum swaphalfword_command
swaphalfword: macro
	db swaphalfword_command
	dw \1 ; halfword to swap hScriptHalfwordVar with
	endm

	enum swaphalfwordvar_command
swaphalfwordvar: macro
	db swaphalfwordvar_command
	endm

	enum pushbyte_command
pushbyte: macro
	db pushbyte_command
	db \1 ; byte
	endm

	enum fruittree_command
fruittree: macro
	db fruittree_command
	db \1 ; tree_id
	endm

	enum swapbyte_command
swapbyte: macro
	db swapbyte_command
	db \1 ; byte
	endm

	enum loadarray_command
loadarray: macro
	db loadarray_command
	dw \1 ; array pointer
	if _NARG == 2
		db \2 ; array size
	else
		db \1EntrySizeEnd - \1
	endc
	endm

	enum verbosegiveitem_command
verbosegiveitem: macro
	db verbosegiveitem_command
	db \1 ; item
if _NARG == 2
	db \2 ; quantity
else
	db 1
endc
	endm

	enum verbosegiveitem2_command
verbosegiveitem2: macro
	db verbosegiveitem2_command
	db \1 ; item
	db \2 ; var
	endm

	enum swarm_command
swarm: macro
	db swarm_command
	db \1 ; flag
	map \2 ; map
	endm

	enum halloffame_command
halloffame: macro
	db halloffame_command
	endm

	enum credits_command
credits: macro
	db credits_command
	endm

	enum warpfacing_command
warpfacing: macro
	db warpfacing_command
	db \1 ; facing
	map \2 ; map
	db \3 ; x
	db \4 ; y
	endm

	enum battletowertext_command
battletowertext: macro
	db battletowertext_command
	db \1 ; memory
	endm

	enum landmarktotext_command
landmarktotext: macro
	db landmarktotext_command
	db \1 ; id
	db \2 ; memory
	endm

	enum trainerclassname_command
trainerclassname: macro
	db trainerclassname_command
	db \1 ; id
	db \2 ; memory
	endm

	enum name_command
name: macro
	db name_command
	db \1 ; type
	db \2 ; id
	db \3 ; memory
	endm

	enum wait_command
wait: macro
	db wait_command
	db \1 ; duration
	endm

	enum loadscrollingmenudata_command
loadscrollingmenudata: macro
	db loadscrollingmenudata_command
	dw \1
	endm

;Prism Custom
	enum backupcustchar_command
backupcustchar: macro
	db backupcustchar_command
	endm

	enum restorecustchar_command
restorecustchar: macro
	db restorecustchar_command
	endm

	enum giveminingEXP_command
giveminingEXP: macro
	db giveminingEXP_command
	endm

	enum givesmeltingEXP_command
givesmeltingEXP: macro
	db givesmeltingEXP_command
	endm

	enum givejewelingEXP_command
givejewelingEXP: macro
	db givejewelingEXP_command
	endm

	enum giveballmakingEXP_command
giveballmakingEXP: macro
	db giveballmakingEXP_command
	endm

	enum givetm_command
givetm: macro
	db givetm_command
	db \1 ; TM
	endm

	enum checkash_command
checkash: macro
	db checkash_command
	endm

	enum itemplural_command
itemplural: macro
	db itemplural_command
	db \1 ; string buffer
	endm

	enum pullvar_command
pullvar: macro
	db pullvar_command
	endm

	enum setplayersprite_command
setplayersprite: macro
	db setplayersprite_command
	db \1 ; character model index (0-5)
	endm

	enum setplayercolor_command
setplayercolor: macro
	db setplayercolor_command
	db \1
if \1 == 0
	RGB \2, \3, \4 ; clothes
	db \5 ; race
endc
	endm

	enum loadsignpost_command
loadsignpost: macro
	db loadsignpost_command
	IF _NARG == 2
		dw AddSignpostHeader
	ELSE
		dw \1
	endc
	endm

signpostheader: macro
	if \1 == 0
		db \1
	else
		if \1 >= TX_COMPRESSED
			db \1 + 1
		else
			db \1
		endc
	endc
	endm

	enum checkpokemontype_command ;Check if the selected Pokemon is part type or has a move of the type.
checkpokemontype: macro
	db checkpokemontype_command
	db \1 ;type
	endm

	enum giveorphanpoints_command
giveorphanpoints: macro
	db giveorphanpoints_command
	dw \1 ; totalpoints
	endm

	enum takeorphanpoints_command
takeorphanpoints: macro
	db takeorphanpoints_command
	dw \1 ; totalpoints
	endm

	enum checkorphanpoints_command
checkorphanpoints: macro
	db checkorphanpoints_command
	dw \1 ; totalpoints
	endm

	enum startmirrorbattle_command
startmirrorbattle: macro
	db startmirrorbattle_command
	endm

	enum comparevartobyte_command
comparevartobyte: macro
	db comparevartobyte_command
	dw \1
	endm

	enum backupsecondpokemon_command
backupsecondpokemon: macro
	db backupsecondpokemon_command
	endm

	enum restoresecondpokemon_command
restoresecondpokemon: macro
	db restoresecondpokemon_command
	endm

	enum vartohalfwordvar_command
vartohalfwordvar: macro
	db vartohalfwordvar_command
	endm

	enum pullhalfwordvar_command
pullhalfwordvar: macro
	db pullhalfwordvar_command
	endm

	enum divideop_command
divideop: macro
	db divideop_command
	db \1 ; operation, what value to return
	IF \1 < 2
		db \2 ; hard value
	ENDC
	endm

	enum givearcadetickets_command
givearcadetickets: macro
	db givearcadetickets_command
	dt \1
	endm

	enum takearcadetickets_command
takearcadetickets: macro
	db takearcadetickets_command
	dt \1
	endm

	enum checkarcadetickets_command
checkarcadetickets: macro
	db checkarcadetickets_command
	dt \1
	endm

	enum checkarcadehighscore_command
checkarcadehighscore: macro
	db checkarcadehighscore_command
	dq \1
	endm

	enum checkarcademaxround_command
checkarcademaxround: macro
	db checkarcademaxround_command
	dw \1
	endm

	enum switch_command
switch: macro
	db switch_command
	db \1
	endm

	enum multiplyvar_command
multiplyvar: macro
	db multiplyvar_command
	db \1
	endm

	enum showFX_command
showFX: macro
	db showFX_command
	dw \1
	dw \2
	endm

	enum minpartylevel_command
minpartylevel: macro
	db minpartylevel_command
	endm

	enum jumptable_command
scriptjumptable: macro
	db jumptable_command
	dw \1
	endm

	enum anonjumptable_command
anonjumptable: macro
	db anonjumptable_command
	endm

	enum givebattlepoints_command
givebattlepoints: macro
	db givebattlepoints_command
	dw \1
	endm

	enum takebattlepoints_command
takebattlepoints: macro
	db takebattlepoints_command
	endm

	enum checkbattlepoints_command
checkbattlepoints: macro
	db checkbattlepoints_command
	endm

	enum playwaitsfx_command
playwaitsfx: macro
	db playwaitsfx_command
	dw \1
	endm

	enum scriptstartasm_command
scriptstartasm: macro
	db scriptstartasm_command
	endm

scriptstopasm: macro
	; This is not a command; this simply closes a scriptstartasm so that the script continues right after this macro
	ld hl, .asmend\@
	ret
.asmend\@
	endm

	enum copystring_command
copystring: macro
	db copystring_command
	db \1
	endm

	enum endtext_command
endtext: macro
	db endtext_command
	endm

	enum pushvar_command
pushvar: macro
	db pushvar_command
	endm

	enum popvar_command
popvar: macro
	db popvar_command
	endm

	enum swapvar_command
swapvar: macro
	db swapvar_command
	endm

	enum getweekday_command
getweekday: macro
	db getweekday_command
	endm

	enum milosswitch_command
milosswitch: macro
	db milosswitch_command
	dw \1 ; event flag
	dw \2 ; iffalse
	dw \3 ; iftrue
	endm
	
	enum qrcode_command
qrcode: macro
	db qrcode_command
	db \1 ; code ID
	endm

then_command EQU scriptstartasm_command ;we can't use scriptstartasm with conditionals, so...

	enum selse_command
selse: macro
	db selse_command
	endm
	
	enum sendif_command
sendif: macro
	db sendif_command
	endm
	
	enum siffalse_command
	enum siftrue_command
	enum sifgt_command
	enum siflt_command
	enum sifeq_command
	enum sifne_command
sif: macro
parameterized_if_command = 1
if_parameter_offset = 0
if ("\1" == "=") || ("\1" == "==")
	db sifeq_command
else
if ("\1" == "!=") || ("\1" == "<>")
	db sifne_command
else
if ("\1" == ">")
	db sifgt_command
else
if ("\1" == "<")
	db siflt_command
else
if ("\1" == ">=")
if_parameter_offset = -1
	db sifgt_command
else
if ("\1" == "<=")
if_parameter_offset = 1
	db siflt_command
else
if ("\1" == "true")
parameterized_if_command = 0
	db siftrue_command
else
if ("\1" == "false")
parameterized_if_command = 0
	db siffalse_command
else
	fail "Invalid condition to sif"
endc
endc
endc
endc
endc
endc
endc
endc
if parameterized_if_command
	db (\2) + if_parameter_offset
	if _NARG == 3
		if "\3" == "then"
			db then_command
		endc
	endc
else
	if _NARG == 2
		if "\2" == "then"
			db then_command
		endc
	endc
endc
	endm

	enum readarray_command
readarray: macro
	db readarray_command
	db \1 ; index within array
	endm

	enum givetmnomessage_command
givetmnomessage: macro
	db givetmnomessage_command
	db \1
	endm
	
	enum findpokemontype_command
findpokemontype: macro
	db findpokemontype_command
	db \1
	endm
	
	enum startpokeonly_command
startpokeonly: macro
	db startpokeonly_command
	map \1
	db \2
	endm
	
	enum endpokeonly_command
endpokeonly: macro
	db endpokeonly_command
	map \1
	db \2
	endm
	
	enum readhalfwordbyindex_command
readhalfwordbyindex: macro
	db readhalfwordbyindex_command
	dw \1
	endm
