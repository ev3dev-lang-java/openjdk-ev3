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
The build process produces these files:

| Name  | File name       | Summary           | Where it runs | Who is it for     | What is it useful for                           |
|-------|-----------------|-------------------|---------------|-------------------|-------------------------------------------------|
| JRI   | `jri-ev3.zip`   | Minimal runtime   | Brick         | Java developer    | Running Java programs on ev3dev.                |
| JDK   | `jdk-ev3.zip`   | Full JDK          | Brick         | ev3dev power user | Compiling Java programs directly on the brick.  |
| JMODs | `jmods-ev3.zip` | Runtime precursor | Developer PC  | both              | Creating runtime images with more Java modules. |

_JRI stands for "Java Runtime Image". The term itself is not specific to this project,
it is equivalent to [Modular Run-Time Image](https://openjdk.java.net/jeps/220).
To see which modules are included in our case, take a look at the jlink commandline in `scripts/zip.sh`._

## Building

0. Clone this repository.
1. Install [Docker](https://docs.docker.com/engine/installation/) for your operating system.
2. Build the base cross-compilation image:
```sh
sudo docker build -t ev3dev-lang-java:jdk-stretch -f system/Dockerfile.armel system
```
3. Build the image with OpenJDK cross-compilation scripts:
```sh
sudo docker build -t ev3dev-lang-java:jdk-build   -f scripts/Dockerfile scripts
```
Next steps depend on whether you want to navigate the build yourself, or if you want the build to run automatically.

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
export JDKVM=client     # Use full ARM32 JIT
export JDKVM=minimal    # Use minimal ARM32 JIT (https://openjdk.java.net/jeps/148)
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


## LeJOS support

LeJOS is not supported. To create a build, it is needed to build Java dependencies
for the old LEGO-provided rootfs. Also, the rootfs build compiler is needed for building OpenJDK itself.
[linux-devkit](https://github.com/mindboards/ev3sources/tree/master/extra/linux-devkit) + CodeSourcery GCC could be used for the cross-compilation.
