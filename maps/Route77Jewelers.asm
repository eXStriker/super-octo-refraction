Route77Jewelers_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route77JewelersSignpost1:
	jumptext Route77JewelersSignpost1_Text_18b87e

Route77JewelersSignpost2:
	jumptext Route77JewelersSignpost1_Text_18b87e

Route77JewelersNPC2:
	jumpstd jeweling

Route77JewelersNPC3:
	faceplayer
	checkevent EVENT_GIVEN_SOOT_SACK
	if_equal 1, Route77Jewelers_18853b
	faceplayer
	opentext
	writetext Route77Jewelers_188526_Text_18ba97
	waitbutton
	verbosegiveitem SOOT_SACK, 1
	setevent EVENT_GIVEN_SOOT_SACK
	closetext
	end

Route77JewelersNPC4:
	jumptextfaceplayer Route77JewelersNPC4_Text_18bb1f

Route77Jewelers_18853b:
	jumptextfaceplayer Route77Jewelers_18853b_Text_18bf4a

Route77JewelersSignpost1_Text_18b87e:
	ctxt "Recipes for making"
	line "rings:"

	para "Grass Ring:"

	para "Two Leaf Stones"
	line "25 ash."

	para "Fire Ring:"

	para "Two Fire Stones"
	line "25 ash."

	para "Water Ring:"

	para "Two Water Stones"
	line "50 ash."

	para "Thunder Ring:"

	para "Two Thunder Stones"
	line "50 ash."

	para "Shiny Ring:"

	para "Three Shiny Stones"
	line "75 ash."

	para "Dawn Ring:"

	para "Three Dawn Stones"
	line "75 ash."

	para "Dusk Ring:"

	para "Three Dusk Stones"
	line "100 ash."

	para "Moon Ring:"

	para "Three Moon Stones"
	line "100 ash."
	done

Route77JewelersNPC4_Text_18bb1f:
	ctxt "Ring Making can"
	line "be complicated."

	para "It costs elemental"
	line "stone or stones,"
	para "and ash for each"
	line "attempt."

	para "You can collect"
	line "ash by smelting"
	para "coal, or by"
	line "walking around"
	cont "Firelight Caverns."

	para "At level one,"
	line "you can only make"
	para "Grass Rings, but"
	line "as you get higher"
	para "in level, you'll"
	line "be able to make"
	cont "more rings."

	para "There are seven"
	line "different rings"
	para "you can make, and"
	line "each ring helps"
	para "your #mon a"
	line "different way in"
	cont "battle!"

	para "Or, you can make"
	line "batches of rings,"
	para "and sell them"
	line "for profit."

	para "Either way, ring"
	line "making can make"
	para "you broke, but"
	line "if you keep at"
	para "it, it's actually"
	line "possible to make"
	cont "a profit, too."
	done

Route77Jewelers_188526_Text_18ba97:
	ctxt "Funny."

	para "Wanting to make"
	line "rings without a"
	cont "Soot Sack."

	para "Well I have a"
	line "spare so go ahead"
	cont "and take mine."
	done

Route77Jewelers_18853b_Text_18bf4a:
	ctxt "Collect ash in"
	line "that by walking"
	para "around the Magma"
	line "Caverns, or by"
	cont "smelting coal!"
	done

Route77Jewelers_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $3, 2, ROUTE_77
	warp_def $7, $4, 2, ROUTE_77

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 4, 7, SIGNPOST_READ, Route77JewelersSignpost1
	signpost 4, 8, SIGNPOST_READ, Route77JewelersSignpost2

	;people-events
	db 3
	person_event SPRITE_ROCKER, 3, 5, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 8 + PAL_OW_BROWN, 0, 0, Route77JewelersNPC2, -1
	person_event SPRITE_ROCKER, 2, 9, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, Route77JewelersNPC3, -1
	person_event SPRITE_ROCKER, 7, 9, SPRITEMOVEDATA_00, 0, 0, -1, -1, 0, 0, 0, Route77JewelersNPC4, -1
