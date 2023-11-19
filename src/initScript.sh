#!/bin/bash
cd $(dirname $0)
if [ ! -d /data/cfg/deepstream ]; then
    echo "deepstream config directory doesn't exist, creating from defaults"
    mkdir -p /data/cfg/deepstream
    chmod -R 777 /data
fi
cp --no-clobber -r cfg-deepstream-default/* /data/cfg/deepstream/
mkdir -p /data/cfg/model
mkdir -p /input

if [ ! -e /input/video.mp4 ]; then
    if [ ! -e /data/input/video.mp4 ]; then
       echo "No default video found at /input/video.mp4, copying sample as input"
       mkdir -p /data/input/
       cp /opt/nvidia/deepstream/deepstream/samples/streams/sample_1080p_h265.mp4 /data/input/video.mp4
    fi
    ln -s /data/input/video.mp4 /input/video.mp4
fi
if [ ! -d /output ]; then
    echo "No dedicated output mount found, using /data/output dir"
    mkdir -p /data/output
    ln -s /data/output /output
fi
echo "Setting up peoplenet model"
./setup-peoplenet.sh
cp --no-clobber -r cfg-model-default/* /data/cfg/model/
./deepstream-app -c /data/cfg/deepstream/bai_deepstream.txt 2>&1 \
    | tee /data/output/deepstream_logs.txt
