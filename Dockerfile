FROM openjdk:8-jdk

LABEL Name=jonasled_android_sdk

ENV  ANDROID_COMPILE_SDK "29"
ENV  ANDROID_BUILD_TOOLS "29.0.2"
ENV  COMMANDLINE_TOOLS "6514223"
ENV ANDROID_HOME "/sdk"
ENV PATH "$PATH:${ANDROID_HOME}/tools"

#Make a complete system update. apt-utils is needed for configuring packages, so we need to install it
RUN apt update
RUN apt upgrade -y
RUN apt install -y wget tar unzip lib32stdc++6 lib32z1 vim-common xxd python python-pip python3 python3-pip curl
RUN curl -o android-sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-${COMMANDLINE_TOOLS}_latest.zip
RUN unzip -d android-sdk-linux android-sdk.zip > /dev/null
RUN mv android-sdk-linux/ ${ANDROID_HOME}
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} "platforms;android-${ANDROID_COMPILE_SDK}" >/dev/null
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} "platform-tools" >/dev/null
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} "build-tools;${ANDROID_BUILD_TOOLS}" >/dev/null
RUN mkdir -p $ANDROID_HOME/licenses/
RUN echo "8933bad161af4178b1185d1a37fbf41ea5269c55\nd56f5187479451eabf01fb78af6dfcb131a6481e\n24333f8a63b6825ea9c5514f83c2829b004d1fee" > $ANDROID_HOME/licenses/android-sdk-license
RUN echo "84831b9409646a918e30573bab4c9c91346d8abd\n504667f4c0de7af1a06de9f4b1727b84351f2910" > $ANDROID_HOME/licenses/android-sdk-preview-license
RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} --licenses  >/dev/null
RUN apt clean