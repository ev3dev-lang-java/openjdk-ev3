# OpenJDK for EV3
A custom build of OpenJDK 9 & 10 for EV3, a Lego Mindstorms programmable brick featuring a ARM926EJ-S CPU.

## Components
The output consists of these parts:
* JRI running on the EV3 - `jri-ev3.zip`
  * Stripped down version of Java -- a Java Runtime Image
  * Intended for normal users.
* Full JDK running on the EV3 - `jdk-ev3.zip`
  * Intended for Linux power users.
* EV3 jmods
  * They can be used for creating custom JRIs.
  * Intended for advanced users wanting to add additional OpenJDK modules.

## Building

0. Clone/download this repo to your computer.
1. Install [Docker](https://docs.docker.com/engine/installation/) for your operating system.
2. Build the jdk cross-compilation environment:
```sh
sudo docker build -t ev3dev-lang-java:jdk-stretch -f system/Dockerfile  system
sudo docker build -t ev3dev-lang-java:jdk-build   -f scripts/Dockerfile scripts
```
3. Run the newly prepared container. You have to mount a host directory to the the `/build` directory in the container,
otherwise the build would get discarded. The final build needs at least 6.5 GB of free space (in the build directory).
```
sudo docker run --rm -it -v <path on host, where the sources should be stored>:/build ev3dev-lang-java:jdk-build
```
4. Select the OpenJDK version you want to cross-compile (select only one):
```
export JDKVER=9      # OpenJDK 9 with ARM32 JIT
export JDKVER=9zero  # OpenJDK 9 with Zero interpreter
export JDKVER=10     # OpenJDK 10 with ARM32 JIT
export JDKVER=10zero # OpenJDK 10 with Zero interpreter
```
5. Before we can start the build process, Boot JDK must be downloaded:
```
./prepare.sh
```
6. Now we can download the OpenJDK sources:
```
./fetch.sh
```
7. The OpenJDK source tree should be ready. Now you can start the cross-build itself:
```
./build.sh
```
8. Create the zipped images:
```
./zip.sh
```
9. If the build was successful, JDK packages were created in `/build/jri-ev3.tar.gz`, `/build/jdk-ev3.tar.gz` and `/build/jmods.tar.gz`.
If you have mounted `/build`, you can access the files from the host.

## ~~JShell on the EV3~~

No longer supported. JShell backend on the EV3 is a huge overkill.
