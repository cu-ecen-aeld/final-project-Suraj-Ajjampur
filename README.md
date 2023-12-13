Project Teammembers:

- Aamir Suhail Burhan

- Suraj Ajjampur

This is the Application Code Repository. The links below for the Project overview and the Yocto codebase.

# Yocto Build Repository
https://github.com/cu-ecen-aeld/final-project-aasu8675

# Project Overview
https://github.com/cu-ecen-aeld/final-project-Suraj-Ajjampur/wiki/Project-Overview

# Project Schedule
https://github.com/cu-ecen-aeld/final-project-Suraj-Ajjampur/wiki/Project-Schedule

# Project Issues
https://github.com/cu-ecen-aeld/final-project-aasu8675/issues

https://github.com/cu-ecen-aeld/final-project-Suraj-Ajjampur/issues

# Building the Application Code
Pre-requisites: 
* Connect the wifi dongle on the Jetson Nano and ensure you have a wireless network connection established
* Connect the buzzer/GPIO_Device to Pin 12 & GND on the 40-Pin Header

Perform the steps given below to build the application code:

1. Open a terminal and run the step given below:
```
vi /etc/docker/daemon.json
```
2. Modify the docker runtime file at /etc/docker/daemon.json to look like this:
```
{
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    },
    "default-runtime" : "nvidia"
}
```

3. Run the command given below to allow the docker to pick up the configuration:
```
systemctl restart docker
```
4. Clone this repository by using the command given below:
```
git clone https://github.com/cu-ecen-aeld/final-project-Suraj-Ajjampur.git
```
5. Build and Run the docker container by running the following commands:
```
cd final-project-Suraj-Ajjampur
./docker/build.sh
./docker/run.sh
```

Note: The run.sh might need to be re-executed untill you see something like the picture below on your terminal:
```
**PERF:  4.50 (6.53)
Frame Number = 8 of Stream = 0,   LineCrossing Cumulative peds = 0 LineCrossing Cumulative lane1 = 0 LineCrossing Current Frame peds = 0 LineCrossing Current Frame lane1 = 0
Frame Number = 9 of Stream = 0,   LineCrossing Cumulative peds = 0 LineCrossing Cumulative lane1 = 0 LineCrossing Current Frame peds = 0 LineCrossing Current Frame lane1 = 0
Frame Number = 10 of Stream = 0,   LineCrossing Cumulative peds = 0 LineCrossing Cumulative lane1 = 0 LineCrossing Current Frame peds = 0 LineCrossing Current Frame lane1 = 0
Frame Number = 11 of Stream = 0,   LineCrossing Cumulative peds = 0 LineCrossing Cumulative lane1 = 0 LineCrossing Current Frame peds = 0 LineCrossing Current Frame lane1 = 0
Frame Number = 12 of Stream = 0,   LineCrossing Cumulative peds = 0 LineCrossing Cumulative lane1 = 0 LineCrossing Current Frame peds = 0 LineCrossing Current Frame lane1 = 0
**PERF:  4.83 (5.79)
```

6. Examine the output
- While the video gets processed, if the LineCrossing Cumulative peds count is greater than 0, a buzzer sound would be heard showcasing an alert for the scenario.
- Open the video present at "data-default/output/video.mp4". And you should see a video like this:
  
![image](https://github.com/cu-ecen-aeld/final-project-Suraj-Ajjampur/assets/123521880/647261d4-1b81-4bb6-9690-403f23b6a564)


# Demo Video Wiki Page
https://github.com/cu-ecen-aeld/final-project-Suraj-Ajjampur/wiki/Suraj's-Final-Project-Video

https://github.com/cu-ecen-aeld/final-project-aasu8675/wiki/Aamir's-Final-Project-Video


