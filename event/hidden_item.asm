HiddenItemScript::
	opentext
	copybytetovar wCurSignpostItemID
	itemtotext 0, 0
	writetext .found_text
	giveitem ITEM_FROM_MEM
	iffalse .bag_full
	callasm SetMemEvent
	playwaitsfx SFX_ITEM
	itemnotify
	endtext

.bag_full
	buttonsound
	writetext .no_room_text
	endtext

.found_text
	; found @ !
	text_jump UnknownText_0x1bd321

.no_room_text
	; But   has no space left…
	text_jump UnknownText_0x1bd331
