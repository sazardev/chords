#!/usr/bin/env bash
# rec.sh : graba clips cortos del recorrido por la app (1080x1920).
S=/tmp/claude-1000/-home-sazar-Documents-chords/8b0d1e24-674a-47e0-a2b1-877d7935a0f6/scratchpad
V=$S/video/clips; mkdir -p $V
go(){ $S/go.sh "chords://chords$1"; sleep ${2:-2}; }
rec(){ # rec <nombre> <segundos> ; acciones en $3 (función)
  adb shell screenrecord --bit-rate 16000000 --time-limit $2 /sdcard/$1.mp4 & local pid=$!
  sleep 0.6; $3; wait $pid; adb pull /sdcard/$1.mp4 $V/$1.mp4 >/dev/null; adb shell rm /sdcard/$1.mp4; }
a_home(){ sleep 1.2; adb shell input swipe 540 1450 540 700 1600; sleep 1.2; adb shell input swipe 540 1450 540 800 1400; }
a_chord(){ sleep 1; $S/tap_text.sh "Escuchar acorde" >/dev/null; sleep 3; }
a_scales(){ sleep .8; $S/tap_text.sh "^2 ?$" >/dev/null; sleep 1.4; $S/tap_text.sh "^3 ?$" >/dev/null; sleep 1.4; $S/tap_text.sh "^Grados" >/dev/null; sleep 1.5; }
a_wait(){ sleep 7; }
a_theory(){ sleep 1; adb shell input swipe 540 1500 540 500 2200; sleep 1.5; }
a_game(){ sleep 1.2; python3 $S/solve_one.py; sleep 2; }
a_genres(){ sleep 1; adb shell input swipe 540 1500 540 500 2000; sleep 1.5; }
a_songs(){ sleep 1; adb shell input swipe 540 1500 540 600 2000; sleep 1.5; }

go "/learn"; go "/"; adb shell input swipe 540 700 540 1500 300; sleep 1; rec home 5 a_home
go "/chords/detail?id=G-maj"; rec chord 5 a_chord
go "/learn/scales?scale=pentatonicMinor&key=9"; adb shell input swipe 540 1500 540 700 600; adb shell input swipe 540 1500 540 900 600; sleep 1; $S/tap_text.sh "^1 ?$" >/dev/null; sleep 1; rec scales 6 a_scales
go "/jam?prog=rockClassic&key=4"; for i in 1 2 3; do adb shell input swipe 540 1500 540 500 300; done; sleep 1; $S/tap_text.sh "A tocar" >/dev/null; sleep 4.5; rec jam 8 a_wait; $S/tap_text.sh "^Terminar" >/dev/null; sleep 1
go "/jam?song=cielito"; for i in 1 2 3; do adb shell input swipe 540 1500 540 500 300; done; sleep 1; $S/tap_text.sh "A tocar" >/dev/null; sleep 6; rec jamsong 8 a_wait; $S/tap_text.sh "^Terminar" >/dev/null; sleep 1
go "/songs"; rec songs 5 a_songs
go "/learn/theory"; rec theory 5 a_theory
go "/game/play?kind=keyChord"; $S/tap_text.sh "^Empezar" >/dev/null; sleep 2; rec game 5 a_game
go "/learn/genres"; rec genres 5 a_genres
ls -la $V
