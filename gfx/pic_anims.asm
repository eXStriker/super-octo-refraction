SECTION "Pic Animations", ROMX, BANK[PIC_ANIMS]

; Pic animations are assembled in 3 parts:

; Top-level animations:
; 	frame #, duration: Frame 0 is the original pic (no change)
; 	setrepeat #:       Sets the number of times to repeat
; 	dorepeat #:        Repeats from command # (starting from 0)
; 	end

; Bitmasks:
;	Layered over the pic to designate affected tiles

; Frame definitions:
;	first byte is the bitmask used for this frame
;	following bytes are tile ids mapped to each bit in the mask

; Main animations (played everywhere)
INCLUDE "gfx/pics/anim_pointers.asm"
INCLUDE "gfx/pics/anims.asm"

; Extra animations, appended to the main animation
; Used in the status screen (blinking, tail wags etc.)
INCLUDE "gfx/pics/extra_pointers.asm"
INCLUDE "gfx/pics/extras.asm"

; Bitmasks
INCLUDE "gfx/pics/bitmask_pointers.asm"
INCLUDE "gfx/pics/bitmasks.asm"

INCLUDE "gfx/pics/frame_pointers.asm"

SECTION "Pic Animation Frames 1", ROMX, BANK[PIC_ANIM_FRAMES_1]

INCLUDE "gfx/pics/anim_frames_1.asm"

SECTION "Pic Animation Frames 2", ROMX, BANK[PIC_ANIM_FRAMES_2]

INCLUDE "gfx/pics/anim_frames_2.asm"

SECTION "Pic Animation Frames 3", ROMX, BANK[PIC_ANIM_FRAMES_3]

INCLUDE "gfx/pics/anim_frames_3.asm"
