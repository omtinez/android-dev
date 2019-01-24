[![Build Status](https://dev.azure.com/owahltinez/GitHubCI/_apis/build/status/omtinez.android-dev?branchName=master)](https://dev.azure.com/owahltinez/GitHubCI/_build/latest?definitionId=2&branchName=master)
[![](https://images.microbadger.com/badges/version/omtinez/android-dev.svg)](https://hub.docker.com/r/omtinez/android-dev)

# Android Developer Docker Image
Docker image for Android developers. Includes SDK, NDK and apktool.


## Build
To build the Docker image, simply run:
```sh
make build
```

Alternatively, you can instead type:
```sh
docker build . -t android-dev
```

## Usage
Once the image is built, you can log into the container by typing:
```sh
make run
```

Or the equivalent Docker command:
```sh
docker run -it android-dev
```

To build an Android app using this image, run the following command from the app's source directory:
```sh
docker run --rm -v "$PWD:/root/workspace" android-dev gradlew assembleDebug
```

If you want to keep the container around, you can do this:
```sh
# Start the container in the background and give it the name "my_container"
docker run --name my_container --rm -t -d -v "$PWD:/root/workspace" android-dev
# Run a command to build our Android app inside of my_container
docker exec my_container /bin/sh gradlew assembleDebug
# Do something else with my_container, for example copy the resulting APK file
```

## Docker Hub
This Docker image is available on [Docker Hub](https://hub.docker.com/r/omtinez/android-dev) using
automated builds. To use the pre-built image:
```sh
docker pull omtinez/android-dev
```
