# openjdk-9-ev3
A custom build of OpenJDK 9 for EV3, a Lego Mindstorms programmable brick featuring a ARM926EJ-S CPU.

## Components
The output consists of these parts:
* JRE running on the EV3 - `jre-ev3.zip`
  * Stripped down version -- a runtime image
* JDK built for the EV3 - `jdk-ev3.zip`
  * Basically the full build
* [Official OpenJDK linux-amd64](http://jdk.java.net/9/) with EV3 jmods
  * Only a stripped down version -- also a runtime image
  * It can be used for creating custom JRE images. For this, jlink and the ev3 jmods are included.
  * It has `javac` (jdk.compiler module).
  * JShell remote launcher (hackish, linux-only) is available.


## Building

0. Clone/download this repo to your computer.
1. Install [Docker](https://docs.docker.com/engine/installation/) for your operating system.
2. Adjust the JAVA_VERSION variable in `build/config.sh` to match the current OpenJDK tip: [OpenJDK 9 updates](http://hg.openjdk.java.net/jdk-updates/jdk9u/)
3. Build the jdk9 cross-compilation environment:
```sh
sudo docker build -t ev3dev-lang-java:jdk9-system -f build/Dockerfile.system  build
sudo docker build -t ev3dev-lang-java:jdk9-build  -f build/Dockerfile.scripts build
```
4. Run the newly prepared container. You have to mount a host directory to the the `/build` directory in the container,
otherwise the build would get discarded. The final build needs at least 6.5 GB of free space (in the build directory).
```
sudo docker run --rm -it -v <path on host, where the sources should be stored>:/build ev3dev-lang-java:jdk9-build
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
8. If the build was successful, JDK9 packages were created in `/build/jre-ev3.zip`, `/build/jdk-ev3.zip` and `/build/jdk-pc.zip`.
If you have mounted `/build`, you can access the files from the host.
