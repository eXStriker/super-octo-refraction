	ctxt "Continent" ; species name
	done
	dw 1106, 20944 ; height, weight

	db .page2 - .page1
.page1
	ctxt "This legendary"
	next "#mon is said to"
	next "represent the land"
	done
.page2
	ctxt "It went to sleep"
	next "after dueling"
	next "Kyogre."
	done
