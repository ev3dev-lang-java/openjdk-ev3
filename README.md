# OpenJDK for ev3dev-lang-java
Custom build of OpenJDK providing Java support for ev3dev on the following devices:

* LEGO Mindstorms EV3, featuring a ARM926EJ-S CPU

Builds for older boards should work on newer boards, the performance might just be a bit lower.

## Build Status

| OpenJDK version  | Platform | VM     | Status                               |
|------------------|----------|--------|--------------------------------------|
| OpenJDK 9        | EV3      | C1 JIT | [![openjdk9_build_ev3_linux][1]][2]  |
| OpenJDK 10       | EV3      | C1 JIT | [![openjdk10_build_ev3_linux][3]][4] |
| OpenJDK 11       | EV3      | C1 JIT | [![openjdk11_build_ev3_linux][5]][6] |
| OpenJDK 12 (dev) | EV3      | C1 JIT | [![openjdk12_build_ev3_linux][7]][8] |

[1]: https://ci.adoptopenjdk.net/view/ev3dev/job/openjdk9_build_ev3_linux/badge/icon
[2]: https://ci.adoptopenjdk.net/view/ev3dev/job/openjdk9_build_ev3_linux/
[3]: https://ci.adoptopenjdk.net/view/ev3dev/job/openjdk10_build_ev3_linux/badge/icon
[4]: https://ci.adoptopenjdk.net/view/ev3dev/job/openjdk10_build_ev3_linux/
[5]: https://ci.adoptopenjdk.net/view/ev3dev/job/openjdk11_build_ev3_linux/badge/icon
[6]: https://ci.adoptopenjdk.net/view/ev3dev/job/openjdk11_build_ev3_linux/
[7]: https://ci.adoptopenjdk.net/view/ev3dev/job/openjdk12_build_ev3_linux/badge/icon
[8]: https://ci.adoptopenjdk.net/view/ev3dev/job/openjdk12_build_ev3_linux/


## Components
The output consists of these parts:
* JRI for the brick - `jri-*.zip`
  * Stripped down version of Java -- a Java Runtime Image
  * Intended for normal users.
* Full JDK running on the brick - `jdk-*.zip`
  * Intended for Linux power users.
* Brick jmods - `jmods-*.zip`
  * They can be used for creating custom JRIs.
  * Intended for advanced users wanting to add additional OpenJDK modules.

## Building

0. Clone/download this repo to your computer.
1. Install [Docker](https://docs.docker.com/engine/installation/) for your operating system.
2. Build the jdk cross-compilation OS:
```sh
sudo docker build -t ev3dev-lang-java:jdk-stretch -f system/Dockerfile.armel system
```
3. Build the jdk cross-compilation environment:
```sh
sudo docker build -t ev3dev-lang-java:jdk-build   -f scripts/Dockerfile scripts
```
### Semi-manual build
4. Run the newly prepared container. You have to mount a host directory to the the `/build` directory in the container,
otherwise the build would get discarded. The final build needs at least 6.5 GB of free space (in the build directory).
```
sudo docker run --rm -it -v $BUILD_DIRECTORY:/build ev3dev-lang-java:jdk-build
```
Please change the `$BUILD_DIRECTORY` to a valid path.

5. Select the OpenJDK version and VM you want to cross-compile (select only one for each variable):
```
export JDKVER=9         # OpenJDK 9
export JDKVER=10        # OpenJDK 10
export JDKVER=11        # OpenJDK 11
export JDKVER=12        # OpenJDK 12
export JDKVM=zero       # Use Zero interpreter
export JDKVM=client     # Use ARM32 JIT
export JDKPLATFORM=ev3  # Use EV3  build flags
```
6. Before we can start the build process, Boot JDK must be downloaded:
```
./prepare.sh
```
7. Now we can download the OpenJDK sources:
```
./fetch.sh
```
8. The OpenJDK source tree should be ready. Now you can start the cross-build itself:
```
./build.sh
```
9. Create the zipped images:
```
./zip.sh
```
10. If the build was successful, JDK packages were created in `/build/jri-ev3.tar.gz`, `/build/jdk-ev3.tar.gz` and `/build/jmods.tar.gz`.
If you have mounted `/build`, you can access the files from the host.

### Automatic build
4. Run the newly prepared container. You have to mount a host directory to the the `/build` directory in the container,
otherwise the build would get discarded. The final build needs at least 6.5 GB of free space (in the build directory).
```
sudo docker run --rm -v $BUILD_DIRECTORY:/build -e JDKVER='X' -e JDKVM='Y' -e JDKPLATFORM='Z' -e AUTOBUILD='yes' ev3dev-lang-java:jdk-build
```
For values of `X`, `Y` and `Z` see above. Please change the `$BUILD_DIRECTORY` to a valid path.

5. If the build was successful, JDK packages were created in `$BUILD_DIRECTORY/jri-ev3.tar.gz`, `$BUILD_DIRECTORY/jdk-ev3.tar.gz` and `$BUILD_DIRECTORY/jmods.tar.gz`.


## ~~JShell on the EV3~~

No longer supported. JShell backend on the EV3 is a huge overkill.


## ~~OpenJDK for leJOS~~

LeJOS has probably reached its EOL. It is not a priority anymore to support it.
[linux-devkit](https://github.com/mindboards/ev3sources/tree/master/extra/linux-devkit) + CodeSourcery GCC could be used for cross-compilation of it.
