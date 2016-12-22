	ctxt "Virtual" ; species name
	done
	dw 200, 720 ; height, weight

	db .page2 - .page1
.page1
	ctxt "This manmade"
	next "#mon evolved"
	next "from the latest"
	done
.page2
	ctxt "technology. It"
	next "may have unprog-"
	next "rammed reactions."
	done
