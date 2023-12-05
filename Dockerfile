# Use the official Flutter image as the base image
FROM ubuntu:latest
 
# Set the Android SDK version
ENV ANDROID_SDK_ZIP=sdk-tools-linux-4333796.zip
ENV ANDROID_SDK_VERSION=29

# Set environment variables for Flutter
ENV FLUTTER_HOME=/usr/local/flutter
ENV FLUTTER_VERSION=3.16.2
  
# Install necessary dependencies
RUN apt-get update && \
		apt-get install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget && \
		rm -rf /var/lib/apt/lists/*
   
# Install Android SDK
COPY downloads/${ANDROID_SDK_ZIP} .
RUN unzip ${ANDROID_SDK_ZIP} && \
		rm ${ANDROID_SDK_ZIP} && \
		mv tools /usr/local/android-sdk
 
# Add Android SDK to the PATH
ENV PATH=/usr/local/android-sdk/bin:$PATH
 

# Accept Android licenses
RUN yes | sdkmanager --licenses

# Install Android SDK components
RUN sdkmanager "platform-tools" "platforms;android-${ANDROID_SDK_VERSION}"

# install Flutter
COPY downloads/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz .
RUN tar xf flutter_linux_${FLUTTER_VERSION}-stable.tar.xz && \
		rm flutter_linux_${FLUTTER_VERSION}-stable.tar.xz && \
#	mv flutter /usr/local

# Add Flutter to the PATH
ENV PATH=$FLUTTER_HOME/bin:$PATH
 
# Set the Flutter SDK path
RUN flutter config --android-sdk /usr/local/android-sdk
 
# Run Flutter doctor again to verify installation
RUN flutter doctor
 
