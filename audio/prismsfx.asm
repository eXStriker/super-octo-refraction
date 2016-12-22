SFX_TCG2Diddly5:
	channelcount 2
	channel 5, SFX_TCG2Diddly5_Ch1
	channel 6, SFX_TCG2Diddly5_Ch2

SFX_TCG2Diddly5_Ch1:
	togglesfx
	sfxpriorityon
	notetype1 10
	notetype0 1
	octave 2
	note B_, 2
	inc_octave
	note D_, 3
	note G_, 3
	dec_octave
	note B_, 3
	inc_octave
	note D_, 2
	note G_, 3
	note B_, 3
	note D_, 3
	note G_, 2
	note B_, 3
	inc_octave
	note D_, 3
	dec_octave
	note G_, 3
	note B_, 2
	inc_octave
	note D_, 3
	note G_, 3
	note B_, 3
	note B_, 3
	sfxpriorityoff
	endchannel

SFX_TCG2Diddly5_Ch2:
	togglesfx
	notetype1 10
	notetype0 1
	octave 3
	note G_, 2
	note B_, 3
	inc_octave
	note D_, 3
	note G_, 3
	dec_octave
	note B_, 2
	inc_octave
	note D_, 3
	note G_, 3
	note B_, 3
	note D_, 2
	note G_, 3
	note B_, 3
	inc_octave
	note D_, 3
	dec_octave
	note G_, 2
	note B_, 3
	inc_octave
	note D_, 3
	note G_, 3
	note G_, 3
	endchannel

SFX_PinballEvolutionFanfareHeader:
	channelcount 3
	channel 5, SFX_PinballEvolutionFanfare_Ch5
	channel 6, SFX_PinballEvolutionFanfare_Ch6
	channel 7, SFX_PinballEvolutionFanfare_Ch7

SFX_PinballEvolutionFanfare_Ch5:
    togglesfx
	sfxpriorityon
	tempo 112
	volume $77
	dutycycle $03
	vibrato $09, $34
	forceoctave 7
	notetype $08, $a3
	octave 3
	note C_, 4
	intensity $78
	octave 2
	note C_, 2
	intensity $a3
	note A#, 4
	intensity $78
	note C_, 2
	intensity $a3
	note A_, 4
	intensity $78
	note C_, 2
	intensity $38
	octave 3
	note C_, 1
	intensity $48
	note D_, 1
	intensity $58
	note E_, 1
	intensity $68
	note F_, 1
	intensity $78
	note G_, 1
	intensity $88
	note A_, 1
	intensity $91
	note D_, 1
	note __, 1
	note D_, 1
	note __, 1
	note D_, 1
	note __, 1
	note C#, 1
	note __, 1
	note C_, 1
	note __, 1
	octave 2
	note A#, 1
	note __, 1
	intensity $85
	octave 3
	note C_, 12
	note __, 1
	sfxpriorityoff
	endchannel

SFX_PinballEvolutionFanfare_Ch6:
	togglesfx
	dutycycle $03
	vibrato $09, $34
	forceoctave 7
	notetype $08, $b8
	octave 3
	note A_, 4
	intensity $28
	note A_, 2
	intensity $b8
	note F_, 4
	intensity $28
	note F_, 2
	intensity $b8
	note C_, 4
	intensity $28
	note C_, 2
	note __, 6
	intensity $98
	note A#, 1
	intensity $28
	note A#, 1
	intensity $b8
	note A#, 1
	intensity $28
	note A#, 1
	intensity $b8
	note A#, 1
	intensity $28
	note A#, 1
	intensity $b8
	note G_, 1
	intensity $28
	note G_, 1
	intensity $b8
	note G_, 1
	intensity $28
	note G_, 1
	intensity $b8
	note A#, 1
	intensity $28
	note A#, 1
	intensity $b5
	note A_, 12
	note __, 1
	endchannel

SFX_PinballEvolutionFanfare_Ch7:
	togglesfx
	forceoctave 7
	notetype $08, $22
	octave 1
	note F_, 2
	note __, 2
	note A_, 2
	note F_, 2
	note __, 2
	note A#, 2
	note F_, 2
	note __, 2
	note A_, 2
	note F_, 2
	note __, 2
	note A_, 2
	note A#, 2
	note __, 2
	octave 2
	note D_, 1
	note __, 1
	note C#, 2
	note __, 2
	note F_, 1
	note __, 1
	note F_, 12
	note __, 1
	endchannel
