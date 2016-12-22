; Game Boy hardware interrupts

SECTION "vblank",ROM0[$40]
	jp VBlank

_InitSpriteAnimStruct::
	jpba InitSpriteAnimStruct_IDToBuffer

SECTION "lcd",ROM0[$48]
	jp LCD

PrintNum::
	jpba _PrintNum

SECTION "timer",ROM0[$50]
	scf
	reti

PlayStereoCry::
	call PlayStereoCry2
	jp WaitSFX

SECTION "serial",ROM0[$58]
	jp Serial

UpdateTimePals::
	jpba _UpdateTimePals

; 485

SECTION "joypad",ROM0[$60]
	reti
