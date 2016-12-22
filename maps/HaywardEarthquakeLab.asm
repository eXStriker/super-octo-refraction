HaywardEarthquakeLab_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

HaywardEarthquakeLabNPC1:
	jumptextfaceplayer HaywardEarthquakeLabNPC1Text

HaywardEarthquakeLabNPC2:
	jumptextfaceplayer HaywardEarthquakeLabNPC2Text

HaywardEarthquakeLabNPC1Text:

	ctxt "When an earthquake"
	line "is about to hit,"
	para "we send a warning"
	line "to everybody so"
	para "they can get"
	line "somewhere safe."

	para "Unfortunately we"
	line "can't detect them"
	para "as quickly as"
	line "other natural"
	cont "disasters."
	done

HaywardEarthquakeLabNPC2Text:
	ctxt "People buried some"
	line "strange orbs in"
	cont "Naljo."

	para "While buried, the"
	line "Orbs powers flowed"
	para "through the plates"
	line "for several miles."

	para "After they were"
	line "dug up, the plates"
	para "were without their"
	line "powers."

	para "The sudden loss of"
	line "the Orb's power"
	para "caused the plates"
	line "to shift, which"
	para "caused very large"
	line "earthquakes."

	para "The first orb was"
	line "found five years"
	cont "ago."

	para "This triggered an"
	line "earthquake up in"
	cont "Johto."

	para "Goldenrod City was"
	line "destroyed, but I"

	para "hear they're almost"
	line "done rebuilding"
	cont "everything."
	done

HaywardEarthquakeLab_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def 7, 2, 3, HAYWARD_CITY
	warp_def 7, 3, 3, HAYWARD_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_SCIENTIST, 3, 6, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, HaywardEarthquakeLabNPC1, -1
	person_event SPRITE_SCIENTIST, 5, 2, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_RED, 0, 0, HaywardEarthquakeLabNPC2, -1
