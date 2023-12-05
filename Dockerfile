# Use the official Flutter image as the base image
FROM ubuntu:latest
USER david

# Set the Android SDK version
ENV ANDROID_SDK_ZIP=commandlinetools-linux-10406996_latest.zip
ENV ANDROID_SDK_VERSION=32
ENV ANDROID_HOME=/usr/local/android-sdk

# Set environment variables for Flutter
ENV FLUTTER_ZIP=flutter_linux_3.16.2-stable.tar.xz
ENV FLUTTER_HOME=/usr/local/flutter
  
# Install necessary dependencies
RUN apt-get update && \
		apt-get install -y curl git unzip xz-utils zip libglu1-mesa openjdk-17-jdk wget && \
		rm -rf /var/lib/apt/lists/*
   
# Install Android SDK
COPY downloads/${ANDROID_SDK_ZIP} .
RUN unzip ${ANDROID_SDK_ZIP} && \
		rm ${ANDROID_SDK_ZIP} && \
		mkdir ${ANDROID_HOME} && \
		mv cmdline-tools ${ANDROID_HOME}/cmdline-tools
 
# Accept Android licenses
RUN yes | ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} --licenses

# Install Android SDK components
RUN ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} "platform-tools" "platforms;android-${ANDROID_SDK_VERSION}" "build-tools;${ANDROID_SDK_VERSION}.0.0" "cmdline-tools;latest"

# install Flutter
COPY downloads/${FLUTTER_ZIP} .
RUN tar xf ${FLUTTER_ZIP} && \
		rm ${FLUTTER_ZIP} && \
		mv flutter /usr/local
RUN git config --global --add safe.directory /usr/local/flutter

# Add Flutter to the PATH
ENV PATH=$FLUTTER_HOME/bin:$PATH

RUN flutter config --android-sdk ${ANDROID_HOME}
#RUN yes | flutter doctor --android-licenses
 
# Run Flutter doctor again to verify installation
RUN flutter doctor
 
RUN mkdir /workspace
