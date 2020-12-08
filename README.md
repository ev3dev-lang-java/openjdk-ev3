# OpenJDK for ev3dev-lang-java
Custom build of OpenJDK providing Java support for ev3dev on the following devices:

* LEGO Mindstorms EV3, featuring a ARM926EJ-S CPU

Builds for older boards should work on newer boards, the performance might just be a bit lower.

## Build Status

| OpenJDK version   | Platform | Type    | VM     | ev3dev-stretch          | ev3dev-buster           |
|-------------------|----------|---------|--------|-------------------------|-------------------------|
| OpenJDK 9         | EV3      | x86→ARM | C1 JIT | [archived][archive]     | N/A                     |
| OpenJDK 10        | EV3      | x86→ARM | C1 JIT | [archived][archive]     | N/A                     |
| OpenJDK 11        | EV3      | ARM→ARM | C1 JIT | [![-> jenkins][1]][2]   | [![-> jenkins][3]][4]   |
| OpenJDK 12        | EV3      | ARM→ARM | C1 JIT | [![-> jenkins][5]][6]   | [![-> jenkins][7]][8]   |
| OpenJDK 13        | EV3      | ARM→ARM | C1 JIT | [![-> jenkins][9]][10]  | [![-> jenkins][11]][12] |
| OpenJDK 14        | EV3      | ARM→ARM | C1 JIT | [![-> jenkins][17]][18] | [![-> jenkins][19]][20] |
| OpenJDK 15        | EV3      | ARM→ARM | C1 JIT | [![-> jenkins][21]][22] | [![-> jenkins][23]][24] |
| OpenJDK tip (dev) | EV3      | ARM→ARM | C1 JIT | [![-> jenkins][13]][14] | [![-> jenkins][15]][16] |

[1]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/job/stretch-11/badge/icon
[2]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/job/stretch-11/
[3]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/job/buster-11/badge/icon
[4]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/job/buster-11/

[5]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/job/stretch-12/badge/icon
[6]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/job/stretch-12/
[7]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/job/buster-12/badge/icon
[8]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/job/buster-12/

[9]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/job/stretch-13/badge/icon
[10]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/job/stretch-13/
[11]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/job/buster-13/badge/icon
[12]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/job/buster-13/

[13]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/job/stretch-bleeding/badge/icon
[14]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/job/stretch-bleeding/
[15]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/job/buster-bleeding/badge/icon
[16]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/job/buster-bleeding/

[17]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/job/stretch-14/badge/icon
[18]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/job/stretch-14/
[19]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/job/buster-14/badge/icon
[20]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/job/buster-14/

[21]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/job/stretch-15/badge/icon
[22]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/job/stretch-15/
[23]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/job/buster-15/badge/icon
[24]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/job/buster-15/


[archive]: https://github.com/ev3dev-lang-java/openjdk-ev3-archive


## Overview & documentation

See [Docs](docs/openjdk-ev3-maintainer-manual.docx)


## Components
The build process produces these files:

| Name  | File name       | Summary           | Where it runs | Who is it for     | What is it useful for                           |
|-------|-----------------|-------------------|---------------|-------------------|-------------------------------------------------|
| JRI   | `jri-ev3.zip`   | Minimal runtime   | Brick         | Java developer    | Running Java programs on ev3dev.                |
| JDK   | `jdk-ev3.zip`   | Full JDK          | Brick         | ev3dev power user | Compiling Java programs directly on the brick.  |
| JMODs | `jmods-ev3.zip` | Runtime modules   | Developer PC  | both              | Creating custom JRIs.                           |

_JRI stands for "Java Runtime Image". The term itself is not specific to this project,
it is equivalent to [Modular Run-Time Image](https://openjdk.java.net/jeps/220).
To see which modules are included in our case, take a look at the `JRI_MODULES` variable in `scripts/config.sh`._

## Building locally

1. Install [Docker](https://docs.docker.com/engine/installation/) for your operating system.
2. Follow this script:
```bash
# define parameters
TARGET_WORKSPACE="$(pwd)/build" # 10 GB of free space should be sufficient, probably less
TARGET_DEBIAN_VERSION="stretch" # stretch or buster
TARGET_OPENJDK_VERSION="11" # 9, 10, 12, 13, 14 - retired, may not be working
                            # 11, 15 - most likely working
                            # loom or tip - experimental, may be broken

# clone repository
git clone https://github.com/ev3dev-lang-java/openjdk-ev3.git
cd openjdk-ev3

# prepare working directory
mkdir -p "$TARGET_WORKSPACE"
chmod -R 777 "$TARGET_WORKSPACE" # docker may not share UID with the current user

# build base system container
docker build --build-arg DEBIAN_RELEASE="$TARGET_DEBIAN_VERSION" \
             --build-arg ARCH="armel" \
             --tag "ev3dev-lang-java:jdk-cross-$TARGET_DEBIAN_VERSION" \
             --file ./system/Dockerfile.cross \
             ./system

# on top of that, create a build scripts container
docker build --build-arg commit="$(git rev-parse HEAD)" \
             --build-arg extra="Manual build by $(whoami)" \
             --build-arg DEBIAN_RELEASE="$TARGET_DEBIAN_VERSION" \
             --build-arg BUILD_TYPE="cross" \
             --tag "ev3dev-lang-java:jdk-cross-build" \
             ./scripts

# now run the build
docker run --rm \
           --interactive \
           --tty \
           --volume "$TARGET_WORKSPACE:/build" \
           --env JDKVER="$TARGET_OPENJDK_VERSION" \
           --env JDKVM="client" \
           --env JDKPLATFORM="ev3" \
           --env JDKDEBUG="release" \
           --env AUTOBUILD="1" \
           ev3dev-lang-java:jdk-cross-build

# finally, make workspace accessible for all users (i.e. current one too) and list files in its root
chmod -R 777 "$TARGET_WORKSPACE"
# and list the output directory (now it should contain three *-ev3.tar.gz files)
ls "$TARGET_WORKSPACE"
```
