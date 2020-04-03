## Integration with AdoptOpenJDK Jenkins

To automate the build process, the project uses the AdoptOpenJDK
Jenkins CI hosted at [ci.adoptopenjdk.net][adopt1] for its builds.
The [ev3dev tab][adopt2] is dedicated to jobs of this project.

The integration is based on Jenkins Pipelines. In the root of the
repository, there is a Jenkinsfile describing the build steps & nodes
where it can run. It handles the following actions:
 1. Docker container image building
    - This is a prerequisite of the OpenJDK build.
      Docker pipelines integration is used to build the container.
 2. OpenJDK build
    - This builds the Java binary archives. However, Jenkinsfile bypasses
      the autorun.sh script and runs the build phases directly.
      By doing that, it is possible to have a separate Jenkins pipeline
      stages for our phases.
 3. Artifact upload
    - This uploads the binary archives to the Jenkins master, where they
      are made available for download by the Internet.
 4. Cleanup
    - As the build workspace & container images take quite a lot of space,
      it is necessary to remove them after the build finishes
      (whether successfully or not).

The Jenkinsfile expects to be given some parameters.
At the time of writing, the following parameters exist:
 * `JDKVM_VALUE` - sets the JVM JIT to be used. See `JDKVM` for config.sh.
 * `JDKVER_VALUE` - sets the JDK version to be built. See `JDKVER` for config.sh.
 * `JDKPLATFORM_VALUE` - sets the target platform. See `JDKPLATFORM` for config.sh.
 * `DOCKER_ARCH` - target arch. It should match the platform. Currently only `armel`.
 * `DEBIAN` - Debian release - can be set to `stretch` or `buster`.
 * `BUILD_TYPE` - either `cross` or `native` - sets the build model (x86>ARM vs ARM>ARM)
 * `DISABLED` - with this enabled, the build will always do nothing and
                it will always succeed. This is useful for cleanup of old jobs.

There parameters can be forced to specific values for individual jobs
by using single-choice "choice parameter".

Currently all configured builds reside in the [`eljbuild`][eljbuild] folder.
Except for JDK9 & JDK10, they all represent the ARMv8->ARM compilation
path for the given Debian & JDK versions.

To create a new Jenkins job, simply create a copy of an existing job and
then customize the job parameters.

[adopt1]: https://ci.adoptopenjdk.net/
[adopt2]: https://ci.adoptopenjdk.net/view/ev3dev/
[eljbuild]: https://ci.adoptopenjdk.net/view/ev3dev/job/eljbuild/
