#!/usr/bin/env bash
# capture.sh <perfil> <ancho> <alto> <densidad>
set -u
S=/tmp/claude-1000/-home-sazar-Documents-chords/8b0d1e24-674a-47e0-a2b1-877d7935a0f6/scratchpad
P=$1; W=$2; H=$3; D=$4; OUT=$S/raw/$P; mkdir -p $OUT
adb shell wm size ${W}x${H}; adb shell wm density $D; sleep 2
$S/prep.sh
adb shell am force-stop app.chords.chords; adb shell am start -n app.chords.chords/.MainActivity >/dev/null; sleep 5
cx=$((W/2)); y1=$((H*78/100)); y2=$((H*30/100))
up(){ for _ in $(seq $1); do adb shell input swipe $cx $y1 $cx $y2 500; done; sleep 1.2; }
shot(){ adb exec-out screencap -p > $OUT/$1.png; }
go(){ $S/go.sh "chords://chords$1"; sleep 2.2; }
go "/learn"; go "/"; shot 01_home
go "/jam?prog=blues12&key=9"; shot 10_jam_setup
up 3; $S/tap_text.sh "A tocar" >/dev/null; sleep 7.2; shot 02_jam
$S/tap_text.sh "^Terminar|Detener" >/dev/null; sleep 1
go "/jam?song=cielito"; up 3; $S/tap_text.sh "A tocar" >/dev/null; sleep 9.5; shot 11_jam_song
$S/tap_text.sh "^Terminar|Detener" >/dev/null; sleep 1
go "/learn/scales?scale=pentatonicMinor&key=9"; up ${SCALE_UP:-2}; $S/tap_text.sh "^1 ?$" >/dev/null; sleep 1.5; shot 03_scales
go "/learn/theory"; shot 04_theory
go "/songs/detail?id=cielito"; shot 05_song
go "/chords/detail?id=G-maj"; shot 06_chord
go "/chords?genre=Country"; shot 07_library
go "/game"; shot 08_games
go "/learn/genre?id=country"; shot 09_genre
go "/songs"; shot 12_songs
go "/chords/history"; shot 13_history
go "/learn/genres"; shot 14_genres
go "/learn"; shot 15_learn
go "/game/play?kind=keyChord"; $S/tap_text.sh "^Empezar" >/dev/null; sleep 2
python3 - <<'PY'
import sys; sys.argv=['x']
exec(open('/tmp/claude-1000/-home-sazar-Documents-chords/8b0d1e24-674a-47e0-a2b1-877d7935a0f6/scratchpad/solve_one.py').read())
PY
sleep 1.3; shot 16_game
echo done $P
