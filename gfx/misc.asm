SECTION "Misc GFX", ROMX, BANK[MISC_GFX]
; Various misc graphics here.

GFX_f89b0:: INCBIN "gfx/unknown/0f89b0.2bpp"
ShinyIcon:: INCBIN "gfx/stats/shiny.2bpp"
GFX_f8aa0:: INCBIN "gfx/unknown/0f8aa0.2bpp"
EnemyHPBarBorderGFX:: INCBIN "gfx/battle/enemy_hp_bar_border.1bpp"
HPExpBarBorderGFX:: INCBIN "gfx/battle/hp_exp_bar_border.1bpp"
ExpBarGFX:: INCBIN "gfx/battle/expbar.2bpp"
TownMapGFX:: INCBIN "gfx/misc/town_map.2bpp.lz"
TextBoxSpaceGFX:: INCBIN "gfx/frames/space.2bpp"
MapEntryFrameGFX:: INCBIN "gfx/frames/map_entry_sign.2bpp"
GFX_f9424:: INCBIN "gfx/unknown/0f9424.2bpp"
Footprints:: INCBIN "gfx/misc/footprints.1bpp"
CopyrightGFX:: INCBIN "gfx/misc/copyright.2bpp"

Section "End GFX", ROMX, BANK[END_GFX]
TheEndGFX:: INCBIN "gfx/credits/theend.2bpp"
