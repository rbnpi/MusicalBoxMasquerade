#A note about the Samples

All of the musical box note sampleds were recorded by me from a small musical box I had which played Brahs Lullaby. I turned the handle very slowly whilst recording and got about 60 samples of notes, many duplicated at different stages of the piece. From the samples I produced some 13 distinct samples and I identified their pitches by comparison with synths plaing in Sonic Pi. I did this back in 2016 for a differnt project playing "Dance of the Wooden Soldiers", also found on musical boxes.
Since doing the masquarade project, I have revisted the samples and done some noise reduction on them, and also normalised them as the volume was rather low. I have added these to the subfolder normalised, and also added a copy of the windingUp sample which I downloaded from freesound.org and was by user wutzl. It was orginally a .wav file but I converted it to .flac format. It has a Creative Commons Attribution 3.0 licence, and the orginal filename was `110959_wutzl_spieluhr-aufziehen.wav`

All of my Musical Box samples have a Creative Commons 0 licence (CC0). YOu are free to use or modify them as you wish.

## using the new normalised samles

If you wish to try the new samples, you just ahve to modify the path in line 20 to point to the new normalised folder. Also you should change the amp: 3 to amp: 1 in line 59 as shwon below. This allows for the higher amplitude of teh normalised recordings.

`sample path,nlist[nv-52][1],rpitch: nlist[nv-52][2],amp: 1,pan: pan`

Robin Newman, August 2023