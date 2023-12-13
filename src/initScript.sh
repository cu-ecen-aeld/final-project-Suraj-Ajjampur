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

# Define the directory and file name
input_dir="/data/input"
input_file="video.mp4"

# Create the directory if it doesn't exist
mkdir -p "$input_dir"

# Check if the default video file exists
if [ ! -f "${input_dir}/${input_file}" ]; then
    echo "No default video found at ${input_dir}/${input_file}, starting capture"

    # Start capturing the video with nvgstcapture-1.0
    nvgstcapture-1.0 --mode=2 --camsrc=0 --cap-dev-node=0 --automate --capture-auto --file-name "${input_dir}/${input_file}" &

    # Wait for the capture process to complete
    wait $!

    # Find the captured file with the pattern and rename it
    captured_file=$(ls ${input_dir}/${input_file}* | head -n 1)
    if [ -f "$captured_file" ]; then
        echo "Captured file found: $captured_file"
        # Only rename the file if it does not already have the correct name
        if [ "$captured_file" != "${input_dir}/${input_file}" ]; then
            mv "$captured_file" "${input_dir}/${input_file}"
        fi
    else
        echo "The captured file was not found."
    fi
else
    echo "Default video already exists at ${input_dir}/${input_file}"
fi

# Create a symlink to the input video if it doesn't already exist
if [ ! -L "/input/${input_file}" ]; then
    ln -s "${input_dir}/${input_file}" "/input/${input_file}"
fi

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
