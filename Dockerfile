FROM ubuntu:bionic
LABEL MAINTANER Oscar Wahltinez <oscar@wahltinez.org>

# Versions
ENV ANDROID_API_LEVEL 28
ENV ANDROID_BUILD_TOOLS_VERSION 28.0.3
ENV ANDROID_SDK_VERSION 4333796
ENV APKTOOL_VERSION 2.3.4

# Env variables
ENV HOME /root
ENV ANDROID_HOME ${HOME}/.android
ENV DEBIAN_FRONTEND noninteractive

# Root certificates update and deps
RUN apt-get update -yq && \
    apt-get install -yq ca-certificates tzdata qt5-default openjdk-8-jdk wget unzip git && \
    update-ca-certificates

# Add i386 arch support
RUN dpkg --add-architecture i386 && \
    apt-get update -yq && \
    apt-get install -yq libncurses5:i386 libc6:i386 libstdc++6:i386 lib32gcc1 lib32ncurses5 lib32z1 zlib1g:i386

# Download and install Android SDK
WORKDIR ${ANDROID_HOME}
ENV SDK_URL https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_VERSION}.zip
RUN wget ${SDK_URL} --output-document=android-sdk-tools.zip --quiet && \
    unzip android-sdk-tools.zip && \
    rm -f android-sdk-tools.zip
ENV ANDROID_SDK_ROOT $ANDROID_HOME
ENV PATH $PATH:$ANDROID_HOME/emulator
ENV PATH $PATH:$ANDROID_HOME/tools/bin
ENV PATH $PATH:$ANDROID_HOME/platform-tools

# Add repositories for Android SDK and update
RUN touch ${ANDROID_HOME}/repositories.cfg
RUN yes | sdkmanager --licenses > /dev/null && \
    sdkmanager "extras;google;m2repository" && \
    sdkmanager "extras;android;m2repository" && \
    sdkmanager --update

# Install platform tools and build tools
RUN yes | sdkmanager "platform-tools" && \
    yes | sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}"

# Install the latest platform SDK
RUN yes | sdkmanager "platforms;android-${ANDROID_API_LEVEL}"

# Install the latest NDK
RUN yes | sdkmanager "ndk-bundle"

# Create Android virtual devices
ENV AVD_PACKAGE_X86 "system-images;android-${ANDROID_API_LEVEL};google_apis;x86"
ENV AVD_PACKAGE_ARM "system-images;android-${ANDROID_API_LEVEL};google_apis;armeabi-v7a"
# RUN yes | sdkmanager "${AVD_PACKAGE_X86}" "${AVD_PACKAGE_ARM}" > /dev/null
# RUN echo no | avdmanager create avd -f -n emulator_x86 -k "${AVD_PACKAGE_X86}"
# RUN echo no | avdmanager create avd -f -n emulator_arm -k "${AVD_PACKAGE_ARM}"

# Install apktool
ENV APKTOOL_URL https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_${APKTOOL_VERSION}.jar
ADD ${APKTOOL_URL} /opt/apktool/apktool.jar

# Start in the workspace
ADD .bashrc ${HOME}/.bashrc
WORKDIR ${HOME}/workspace
ENTRYPOINT ["/bin/bash"]
