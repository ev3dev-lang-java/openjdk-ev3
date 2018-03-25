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

## JShell on the EV3

### Usage

First, you have to either [add](https://askubuntu.com/a/4833) your pubkey to the EV3 brick's authorized_keys,
or set the [SSH_ASKPASS](https://unix.stackexchange.com/a/83991) environment variable. Then, run a script from
the amd64 JDK on your computer: `bin/jshell-launch.sh <ssh args>`, where `<ssh args>` is an address with an optinal
port-specifying flag. The options are just added to the SSH command line and aren't sanitized in any way.

### Theory

We've managed to run JShell in a kind of "split-mode". The compiler part runs on your powerful computer,
whether the not-so-demanding execution is done on the brick. This was almost supported out of the box - 
the default JShell configuration already uses JDI transport. The only issue is that it does not provide an
intuitive way to connect to a remote host. JShell always launches a new JVM process in the JDI mode.

Our hack relies on replacing the agent in the VM started by JShell. The new dummy agent just
writes the port number it was supposed to connect to a file `/tmp/jshellargs`. Then, if you make
`jshellargs` a UNIX pipe, you can very easily pass the port to another application.

JShell on your computer is the listening side of the JDWP channel. To reuse the existing remote agent,
which is used in the local JDI mode, we tunnel a chosen port over the SSH session. SSH connects to the 
JShell listening socket and itself listens on the remote side. Then, the last task is to run the
JShell JDI agent on the remote side, which is handled by SSH as well.

## Building

0. Clone/download this repo to your computer.
1. Install [Docker](https://docs.docker.com/engine/installation/) for your operating system.
2. Adjust the JAVA_VERSION variable in `build/config.sh` to match the current OpenJDK tip: [OpenJDK 9 updates](http://hg.openjdk.java.net/jdk-updates/jdk9u/)
3. Build the jdk9 cross-compilation environment:
```sh
sudo docker build -t ev3dev-lang-java:jdk-stretch -f build/Dockerfile.system  build
sudo docker build -t ev3dev-lang-java:jdk-build   -f build/Dockerfile.scripts build
```
4. Run the newly prepared container. You have to mount a host directory to the the `/build` directory in the container,
otherwise the build would get discarded. The final build needs at least 6.5 GB of free space (in the build directory).
```
sudo docker run --rm -it -v <path on host, where the sources should be stored>:/build ev3dev-lang-java:jdk-build
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
