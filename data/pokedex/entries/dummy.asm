	text "???" ; species name
	done
	dw 10, 10 ; height, weight
		
	db .page2 - .page1
.page1
	ctxt "Huh?"
	done
.page2
	text_jump .page1
