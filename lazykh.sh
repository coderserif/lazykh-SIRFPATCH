#!/bin/bash

read -p "Where is lazykh-main?: " CDD

cd $CDD

read -p "Where is the text file?: " TXTDIR
read -p "Where is the mp3 file?: " MP3DIR
read -p "Billboards? T or F: ?: " BOARD
read -p "Jiggly Transitions? T or F: ?: " JIGGLE
read -p "Keep frames? T or F: ?: " FRAMES


RESTXTDIR=$(echo $TXTDIR | sed 's/\.txt//')
RESMP3DIR=$(echo $MP3DIR | sed 's/\.mp3//')  

python3 code/gentleScriptWriter.py --input_file $RESTXTDIR

EVG=$(echo $RESTXTDIR"_g.txt")
JSON=$(echo $RESTXTDIR".json")

python3 gentle-final/align.py $MP3DIR $EVG -o $JSON


python3 code/scheduler.py --input_file $RESTXTDIR

if [ $BOARD == T ]; then
    python3 code/humanImager.py --input_file $RESTXTDIR
fi

read -p "If you have enable billboards, edit them if you wish. Otherwise, press enter."

python3 code/videoDrawer.py --input_file $RESTXTDIR --use_billboards $BOARD --jiggly_transitions $JIGGLE


python3 code/videoFinisher.py --input_file $RESTXTDIR --keep_frames $FRAMES

