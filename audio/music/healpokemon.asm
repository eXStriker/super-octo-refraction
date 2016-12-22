Music_HealPokemon: ; f0697
	channelcount 4
	channel 5, Music_HealPokemon_Ch1
	channel 6, Music_HealPokemon_Ch2
	channel 7, Music_HealPokemon_Ch3
	channel 8, Music_HealPokemon_Ch4
; f06a0

Music_HealPokemon_Ch1: ; f06a0
	togglesfx
	sfxpriorityon
	tempo 144
	volume $77
	dutycycle $2
	tone $0001
	notetype $c, $81
	note __, 2
	slidepitchto 1, 4, __
	note B_, 2
	slidepitchto 1, 5, E_
	note B_, 2
	slidepitchto 1, 4, E_
	note E_, 2
	note __, 4
	slidepitchto 1, 3, __
	note E_, 4
	slidepitchto 1, 4, __
	note B_, 4
	sfxpriorityoff
	endchannel
; f06c4

Music_HealPokemon_Ch2: ; f06c4
	togglesfx
	dutycycle $2
	notetype $c, $c3
	octave 4
	note B_, 4
	note B_, 4
	note B_, 2
	note G#, 2
	notetype $c, $c4
	octave 5
	note E_, 8
	endchannel
; f06d4

Music_HealPokemon_Ch3: ; f06d4
	togglesfx
	notetype $c, $10
	octave 4
	note E_, 2
	note __, 2
	note E_, 2
	note __, 2
	note E_, 2
	note G#, 2
	note E_, 6
	note __, 2
	endchannel

Music_HealPokemon_Ch4:
	togglesfx
	togglenoise $3
	notetype $c
	note __, 16
	note __, 4
	endchannel
; f06e1
