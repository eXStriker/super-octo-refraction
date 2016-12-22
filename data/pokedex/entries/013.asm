	ctxt "Bell" ; species name
	done
	dw 008, 13 ; height, weight

	db .page2 - .page1
.page1
	ctxt "It emits cries by"
	next "agitating an orb" 
	next "in its throat."
	done
.page2
	ctxt "Each time it hops,"
	next "it makes a ringing" 
	next "sound."
	done
