
puts note(:e7),note(:f7),note(:fs7),note(:g7)
##| stop

#Musical Box masquerade played in Phantom of The Opera
#coded for Sonic Pi by Robin Newman August 2023
#utilises 13 samples of musical box notes which are used to cover the midi range 52 - 103
#by calculating which sample to use and what rpitch value to apply to it.
#this is done by means of a list with entries midi number,
#sample offset in folder and rpitch value to apply.
#the notes for the tune and accompaniment parts are stored in lists a1 and a2
#corresponding durations in b1 and b2

######### adjust next four lines as required ###########
path="~/Desktop/Samples/MusicalBox/MusicalBox" #path to sample folder. Adjust as necessary
repeats = 6 #no of "play throughs" of the tune
shift = 0 #transpose shift. For this tune range +3 down to -17 will work
windup = true #set to false to miss out box winding up sample
######### end of user adjustable items ###############

#nlist calculates which sample to play and at what rate, for note midi range 52 to 103
nlist=[
  [52,0,-22],[53,0,-21],[54,0,-20],[55,0,-19],[56,0,-18],
  [57,0,-17],[58,0,-16],[59,0,-15],[60,0,-14],[61,0,-13],
  [62,0,-12],[63,0,-11],[64,0,-10],[65,0,-9],[66,0,-8],
  [67,0,-7],[68,0,-6],[69,0,-5],[70,0,-4],[71,0,-3],
  [72,0,-2],[73,0,-1],[74,0,0],[75,0,1],[76,0,2],
  [77,1,-2],[78,1,-1],[79,1,0],[80,2,-1],[81,2,0],
  [82,3,-1],[83,3,0],[84,4,0],[85,5,-1],[86,5,0],
  [87,5,1],[88,5,2],[89,5,3],[90,6,-3],[91,6,-2],
  [92,6,-1],[93,6,0],[94,7,-1],[95,7,0],[96,8,0],
  [97,9,-1],[98,9,0],[99,9,1],[100,10,0],[101,10,1],
[102,11,0],[103,12,0]]

#data of notes and durations for the tune (minus first note which is played separately)
a1=[:Cs7,:D7,:E7,:r,:D7,:Cs7,:B6,:A6,:B6,:Cs7,:B6,:r,:A6,:D6,:D6,:r,:A6,:Fs6,:A6,:A6,:Fs6,:A6,:Fs6,:E6,:Fs6,:Cs6,:A5,:B5,:Cs6,:D6,:E6]
b1=[0.5,0.5,4.0,1.0,0.5,0.5,0.5,0.5,0.5,0.5,2.0,0.5,1.0,0.5,2.0,0.5,1.0,0.5,1.0,0.5,0.5,1.5,0.5,1.5,0.5,1.0,1.5,0.5,0.5,0.5,1.0]
a2=[:E5,:A5,[:E5,:Cs6],[:A4,:B5],:E5,[:B5,:Gs6],:Fs5,[:A4,:Fs5],:D5,:Fs5,:D5,:A4,:D5,:Fs5,:E5,:D5,:A4,:D5,:Fs5,:E5,:D5,[:A4,:Cs5],:E5,:A5,:Gs5,:Fs5,:A4,:E5,:Fs5,:A5,:B5,[:A4,:Cs6]]
b2=[1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.5,0.5,0.5,0.5,1.0]


#this function selects and plays a sample given an input midi number and pan setting
define :plmb do |n,pan=0| #function to play a note: looks up note info in array to get sample and rpitch value
  if n !=:r then
    nv=note(n)
    puts 'note value: ',nv
    puts "sample offset in folder: ",nlist[nv-52][1]
    puts "rpitch value: ",nlist[nv-52][2]
    sample path,nlist[nv-52][1],rpitch: nlist[nv-52][2],amp: 3,pan: pan
  end
end

#this function plays correspnding note and duration lists with a transpose paramter and pan setting
define :plarray do |n,d,shift,pan=0| #function to play array of notes and durations. Shift is transpose quantity
  n.zip(d).each do |n,d|
    if n!=:r then
      #adjustto play chords if required
      if n.respond_to?('each') #i.e. is a chord if responds
        n.each do |nv|
          plmb(nv+shift,pan)
        end
      else
        plmb(n+shift,pan)
      end
    end
    sleep d
  end
end

#this function calculates the total beat duration of a list of duration values
define :dototal do |d|
  total =0
  d.each do |v|
    total += v
  end
  return total
end

define :playWindup do
  wu= path+"/windingUp.flac" #winding up the musical box sample
  sample wu
  sleep sample_duration wu
end

#use the link system to allow for easy tempo reduction as the musical box slows down
use_bpm :link
set_link_bpm! 130 #starting value
sleep 1

duration = dototal b1 #total number of beats

with_fx :reverb, room: 0.5,mix: 0.6 do #add a little reverb
  playWindup if windup
  with_fx :level,amp: 1 do |v| #use fx_level to make musical box get quieter as ti runs down
    set :v,v #save control pointer
    at [duration*(repeats-2)] do #tempo drops as musical box runs down
      sp=current_bpm
      30.times do #loop reduces the tempo slowly
        sleep rt(1)
        sp -= 1
        set_link_bpm! sp
      end
    end
    
    #play first two notes together. (thereafter on repeats there are three notes in this chord)
    
    plmb :e6+shift, -0.5
    plmb :a4+shift, 0.5
    sleep 1 #duration of first chord)
    
    repeats.times do |i| #repeat the tune the number of times required
      #reduce the volume on the last repeat (index starts from zero so repeats - 2)
      control get(:v),amp: 0, amp_slide: 2.5*duration if i == repeats - 2
      in_thread do
        plarray a1,b1,shift,-0.5 #higher notes panned left
      end
      #2nd part not in a thread so sets duration before next repeat
      plarray a2,b2,shift,0.5 #lower notes accompaniment panned right
    end #repeat
  end #fade out
end#reverb
