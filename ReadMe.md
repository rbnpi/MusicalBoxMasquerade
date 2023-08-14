# MusicalBoxMasquerade

## plays the automaton tune Masquerade fatured in Phantom.

The code is contained in Sonic Pi. It holds lists of the notes and durations, and plays them by looking up appropriate samples of Musical Box notes (13 available) and adjusting the relative pitch (rpitch) of the samples so that between them they cover the midi note range 52 to 103. As supplied the tune covers the range 69 to 100, so it can be transposed in range -17 to +3 if you wish.

To make it more realistic the performance starts by playing a sample recording of a musical box being wound up. This feature can be siwtched off if desired in the config lines near the start of the program. The fairly short tune can be repeated as desired by altering a parameter "repeats". On the penultimate repeat the program uses the built-in link tempo mechanism in Sonic Pi to slowly reduce the tempo, as if the spring were to be losing power. Normally a musical box just stops when the spring's energy is expended. However there is an option to fade out which can be selected in the user settings near the start of the program.

I am producing this as a repository so that the folder of samples can be easily included to enable users to have a complete system.

You should locate the samples in a suitable position on your computer and then adjust the path in the program where indicated.

Robin Newman, August 2023