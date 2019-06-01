// OpenJDK Jenkins build pipeline

// docker linux build machine
node('( linux || sw.os.linux ) && ( x64 || x86_64 || x86 || hw.arch.x86 ) && ( docker || sw.tool.docker ) && !( test || ci.role.test )') {

    // our docker images
    def osImage
    def bldImage
    //def pkgImage

    // prepare run parameters
    String mountParams = "-v ${env.WORKSPACE}/build:/build"
    String envParams = "-e JDKVER=${params.JDKVER_VALUE} -e JDKVM=${params.JDKVM_VALUE} -e JDKPLATFORM=${params.JDKPLATFORM_VALUE} -e AUTOBUILD=1"

    try {
        // clean and prepare
        cleanWs()
        checkout scm
        sh "mkdir -p  ${env.WORKSPACE}/build && chmod 777 ${env.WORKSPACE}/build"

        // do the docker build stuff
        stage("Docker build") {
            def commit = sh(returnStdout: true, script: "git rev-parse HEAD").trim()
            def infoArg = ""
            infoArg += " --build-arg commit=\"$commit\""
            infoArg += " --build-arg extra=\"Jenkins ${env.JOB_NAME}#${env.BUILD_NUMBER} with Debian ${params.DEBIAN}\""
            infoArg += " --build-arg DEBIAN_RELEASE=${params.DEBIAN}"
            osImage  = docker.build("ev3dev-lang-java:jdk-${params.DEBIAN}", "${infoArg} -f system/${params.DEBIAN}/Dockerfile.${params.DOCKER_ARCH} ./system/${params.DEBIAN}")
            bldImage = docker.build("ev3dev-lang-java:jdk-build",            "${infoArg} -f scripts/Dockerfile                                       ./scripts")
         // pkgImage = docker.build("ev3dev-lang-java:jdk-package",          "${infoArg} -f packaging/Dockerfile                                     ./packaging")
        }
        stage("JDK download") {
            bldImage.inside("${mountParams} ${envParams}") {
                sh "/opt/jdkcross/prepare.sh"
                sh "/opt/jdkcross/fetch.sh"
            }
            archiveArtifacts artifacts: "build/metadata", fingerprint: true
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

        //stage("JDK debpkg") {
        //    sh "docker run --rm ${mountParams} ev3dev-lang-java:jdk-package"
        //    archiveArtifacts artifacts: "build/debian.zip", fingerprint: false
        //}
    } finally {
        stage ('Cleanup') {
            // clean up workspace
            //pkgImage.inside("${mountParams}") {
            //    try { sh "sudo rm -rf /build/*" } catch(err) {}
            //}
            bldImage.inside("${mountParams}") {
                try { sh "sudo rm -rf /build/*" } catch(err) {}
            }
            try { sh "rm -rf ${env.WORKSPACE}/build" } catch(err) {}

            // clean up docker images
            //try { sh "docker rmi ${pkgImage.id} 2>/dev/null" } catch (err) {}
            try { sh "docker rmi ${bldImage.id} 2>/dev/null" } catch (err) {}
            try { sh "docker rmi ${osImage.id} 2>/dev/null"  } catch (err) {}
            cleanWs()
        }
    }
}
