# OpenJDK 10 for EV3
A custom build of OpenJDK 10 for EV3, a Lego Mindstorms programmable brick featuring a ARM926EJ-S CPU.

## Components
The output consists of these parts:
* JRE running on the EV3 - `jre-ev3.zip`
  * Stripped down version -- a runtime image
* JDK built for the EV3 - `jdk-ev3.zip`
  * Basically the full build
* EV3 jmods
  * It can be used for creating custom JRE images.

## Building

0. Clone/download this repo to your computer.
1. Install [Docker](https://docs.docker.com/engine/installation/) for your operating system.
2. Adjust the JAVA_VERSION variable in `build/config.sh` to match the current OpenJDK tip: [OpenJDK 10 updates](http://hg.openjdk.java.net/jdk-updates/jdk10u/)
3. Build the jdk cross-compilation environment:
```sh
sudo docker build -t ev3dev-lang-java:jdk10-stretch -f build/Dockerfile.system  build
sudo docker build -t ev3dev-lang-java:jdk10-build   -f build/Dockerfile.scripts build
```
4. Run the newly prepared container. You have to mount a host directory to the the `/build` directory in the container,
otherwise the build would get discarded. The final build needs at least 6.5 GB of free space (in the build directory).
```
sudo docker run --rm -it -v <path on host, where the sources should be stored>:/build ev3dev-lang-java:jdk10-build
```
5. Let's fetch the OpenJDK sources:
```
./fetch.sh
```
6. The OpenJDK source tree should be ready. Now you can start the cross-build itself:
```
./build.sh
```
7. Create the zipped images:
```
./zip.sh
```
8. If the build was successful, JDK packages were created in `/build/jre-ev3.zip`, `/build/jdk-ev3.zip` and `/build/jdk-pc.zip`.
If you have mounted `/build`, you can access the files from the host.

## ~~JShell on the EV3~~

No longer supported. JShell backend on the EV3 is a huge overkill.
