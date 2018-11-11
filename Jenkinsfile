// OpenJDK Jenkins build pipeline

// docker linux build machine
node('( linux || sw.os.linux ) && ( x64 || x86_64 || x86 || hw.arch.x86 ) && ( docker || sw.tool.docker ) && !test') {

    // our docker images
    def osImage
    def bldImage
    def pkgImage

    try {
        // clean and prepare
        cleanWs()
        checkout scm
        sh "mkdir -p  ${env.WORKSPACE}/build && chmod 777 ${env.WORKSPACE}/build"

        // do the docker build stuff
        stage("Docker build") {
            osImage  = docker.build("ev3dev-lang-java:jdk-stretch", "-f system/Dockerfile.${params.DOCKER_ARCH} ./system")
            bldImage = docker.build("ev3dev-lang-java:jdk-build",   "-f scripts/Dockerfile                      ./scripts")
            pkgImage = docker.build("ev3dev-lang-java:jdk-package", "-f packaging/Dockerfile                    ./packaging")
        }

        // prepare run parameters
        String mountParams = "-v ${env.WORKSPACE}/build:/build"
        String envParams = "-e JDKVER=${params.JDKVER_VALUE} -e JDKVM=${params.JDKVM_VALUE} -e JDKPLATFORM=${params.JDKPLATFORM_VALUE} -e AUTOBUILD=1"

        stage("JDK download") {
            bldImage.inside("${mountParams} ${envParams}") {
                sh "/opt/jdkcross/prepare.sh"
                sh "/opt/jdkcross/fetch.sh"
            }
        }

        stage("JDK build") {
            bldImage.inside("${mountParams} ${envParams}") {
                sh "/opt/jdkcross/build.sh"
            }
        }

        stage("JDK tarpkg") {
            bldImage.inside("${mountParams} ${envParams}") {
                sh "/opt/jdkcross/zip.sh"
            }
            archiveArtifacts artifacts: "build/jri-${params.JDKPLATFORM_VALUE}.tar.gz",   fingerprint: true
            archiveArtifacts artifacts: "build/jdk-${params.JDKPLATFORM_VALUE}.tar.gz",   fingerprint: true
            archiveArtifacts artifacts: "build/jmods-${params.JDKPLATFORM_VALUE}.tar.gz", fingerprint: true
        }

        stage("JDK debpkg") {
            sh "docker run --rm ${mountParams} ev3dev-lang-java:jdk-package"
            archiveArtifacts artifacts: "build/debian.zip", fingerprint: false
        }
    } finally {
        stage ('Cleanup') {
            try {
                sh "docker rmi ${pkgImage.id} 2>/dev/null"
            } catch (err) {}
            try {
                sh "docker rmi ${bldImage.id} 2>/dev/null"
            } catch (err) {}
            try {
                sh "docker rmi ${osImage.id} 2>/dev/null"
            } catch (err) {}
            cleanWs()
        }
    }
}
