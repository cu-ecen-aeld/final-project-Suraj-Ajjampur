#!/bin/bash
# This init script checks for deepstream config dependencies and installs it.
# The check for input and output video is done in this script and the deepstream app is run


cd $(dirname $0)
if [ ! -d /data/cfg/deepstream ]; then
    echo "deepstream config directory doesn't exist, creating from defaults"
    mkdir -p /data/cfg/deepstream
    chmod -R 777 /data
fi
cp --no-clobber -r cfg-deepstream-default/* /data/cfg/deepstream/
mkdir -p /data/cfg/model
mkdir -p /input

# Define input video file path
input_file="/data/input/video.mp4"

# Check for the input video file
if [ ! -f "$input_file" ]; then
    echo "No default video found, starting capture"
    nvgstcapture-1.0 --mode=2 --camsrc=0 --cap-dev-node=0 --automate --capture-auto --file-name "$input_file"
    wait $!
    captured_file=$(ls ${input_file}_* | head -n 1)
    [ -f "$captured_file" ] && mv "$captured_file" "$input_file"
fi

# Create a symlink to the input video
ln -sf "$input_file" /input/video.mp4

if [ ! -d /output ]; then
    echo "No dedicated output mount found, using /data/output dir"
    mkdir -p /data/output
    ln -s /data/output /output
fi
echo "Setting up peoplenet model"
./setup-peoplenet.sh

cp --no-clobber -r cfg-model-default/* /data/cfg/model/

# The bai_deeppstream.txt file consists of configurations used for the application
./deepstream-app -c /data/cfg/deepstream/bai_deepstream.txt 2>&1 \
    | tee /data/output/deepstream_logs.txt
