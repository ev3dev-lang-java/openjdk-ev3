pipeline {
    agent {
        label '( linux || sw.os.linux ) && ( x64 || x86_64 || x86 || hw.arch.x86 ) && ( docker || sw.tool.docker ) && !test'
    }
    stages {
        stage('Prepare environment') {
            steps {
                checkout scm
                sh "rm -rf    /home/jenkins/workspace/" + JOB_NAME + "/build"
                sh "mkdir -p  /home/jenkins/workspace/" + JOB_NAME + "/build"
                sh "chmod 777 /home/jenkins/workspace/" + JOB_NAME + "/build"
            }
        }
        stage('Build cross image') {
            steps {
                script {
                    try {
                        sh "docker logout"
                    } catch (err) {}
                }
                sh "docker build -t ev3dev-lang-java:jdk-stretch -f system/Dockerfile." + DOCKER_ARCH + " system "
                sh "docker build -t ev3dev-lang-java:jdk-build -f scripts/Dockerfile scripts "
            }
        }
        stage("JDK download") {
            steps {
                sh "docker run --rm -v /home/jenkins/workspace/" + JOB_NAME + "/build:/build \
                    -e JDKVER='" + JDKVER_VALUE + "' -e JDKVM='" + JDKVM_VALUE + "' -e JDKPLATFORM='" + JDKPLATFORM_VALUE + "' -e AUTOBUILD='1' \
                    ev3dev-lang-java:jdk-build /opt/jdkcross/prepare.sh"
                sh "docker run --rm -v /home/jenkins/workspace/" + JOB_NAME + "/build:/build \
                    -e JDKVER='" + JDKVER_VALUE + "' -e JDKVM='" + JDKVM_VALUE + "' -e JDKPLATFORM='" + JDKPLATFORM_VALUE + "' -e AUTOBUILD='1' \
                    ev3dev-lang-java:jdk-build /opt/jdkcross/fetch.sh"
            }
        }
        stage("JDK build") {
            steps {
                sh "docker run --rm -v /home/jenkins/workspace/" + JOB_NAME + "/build:/build \
                    -e JDKVER='" + JDKVER_VALUE + "' -e JDKVM='" + JDKVM_VALUE + "' -e JDKPLATFORM='" + JDKPLATFORM_VALUE + "' -e AUTOBUILD='1' \
                    ev3dev-lang-java:jdk-build /opt/jdkcross/build.sh"
            }
        }
        stage("JDK packaging") {
            steps {
                sh "docker run --rm -v /home/jenkins/workspace/" + JOB_NAME + "/build:/build \
                    -e JDKVER='" + JDKVER_VALUE + "' -e JDKVM='" + JDKVM_VALUE + "' -e JDKPLATFORM='" + JDKPLATFORM_VALUE + "' -e AUTOBUILD='1' \
                    ev3dev-lang-java:jdk-build /opt/jdkcross/zip.sh"

                archiveArtifacts artifacts: 'build/jri-'   + JDKPLATFORM_VALUE + '.tar.gz', fingerprint: true
                archiveArtifacts artifacts: 'build/jdk-'   + JDKPLATFORM_VALUE + '.tar.gz', fingerprint: true
                archiveArtifacts artifacts: 'build/jmods-' + JDKPLATFORM_VALUE + '.tar.gz', fingerprint: true
            }
        }
    }
    post {
        always {
            script {
                try {
                    sh "docker rmi ev3dev-lang-java:jdk-build 2>/dev/null"
                } catch (err) {}
                try {
                    sh "docker rmi ev3dev-lang-java:jdk-stretch 2>/dev/null"
                } catch (err) {}
                try {
                    cleanWs()
                } catch (err) {}
            }
        }
    }
}
