# openjdk-9-ev3
A custom Build of OpenJDK 9 Sources for EV3, a Lego Mindstorms Brick using ARM Soft Float

## Building

1. Install [Docker](https://docs.docker.com/engine/installation/) for your operating system.
2. Build the jdk9 cross-compilation environment:
```sh
sudo docker build -t ev3dev-lang-java:jdk9-system -f Dockerfile.system  build
sudo docker build -t ev3dev-lang-java:jdk9-build  -f Dockerfile.scripts build
```
3. Run the newly prepared container. We recommend mounting a host directory to the the `/build` directory in the container. At least 2 GB of free space will be needed.
```
sudo docker run -it -v <path on host, where the sources should be stored>:/build ev3dev-lang-java:jdk9-build
```
4. Let's fetch the OpenJDK sources:
```
./fetch.sh
```
5. The OpenJDK source tree should be ready. Now you can start the cross-build itself:
```
./build.sh
```
6. If the build has successfully finished, JDK9 images are created in
`/build/jdk9u/build/linux-arm-normal-client-release/images`.
If you have mounted something to `/build`, you can also use
`<path on host, where the sources should be stored>/jdk9u/build/linux-arm-normal-client-release/images`.
