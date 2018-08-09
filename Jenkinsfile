pipeline {
    agent {
        label '( linux || sw.os.linux ) && ( x64 || x86_64 || x86 || hw.arch.x86 ) && ( docker || sw.tool.docker ) && !test'
    }
    stages {
        stage('checkout') {
            steps {
                checkout scm
            }
        }
        stage('Prepare environment') {
            steps {
                sh "rm -rf    /home/jenkins/workspace/" + JOB_NAME + "/build"
                sh "mkdir -p  /home/jenkins/workspace/" + JOB_NAME + "/build"
                sh "chmod 777 /home/jenkins/workspace/" + JOB_NAME + "/build"
                // do not cache to save space
                sh "rm /home/jenkins/workspace/" + JOB_NAME + "/openjdk-9.0.4_linux-x64_bin.tar.gz"
                sh "rm /home/jenkins/workspace/" + JOB_NAME + "/openjdk-10_linux-x64_bin.tar.gz"
                //sh "cd /home/jenkins/workspace/" + JOB_NAME + " && wget -nv -N https://download.java.net/java/GA/jdk9/9.0.4/binaries/openjdk-9.0.4_linux-x64_bin.tar.gz"
                //sh "cd /home/jenkins/workspace/" + JOB_NAME + " && wget -nv -N https://download.java.net/java/GA/jdk10/10/binaries/openjdk-10_linux-x64_bin.tar.gz"
                //sh "cp /home/jenkins/workspace/" + JOB_NAME + "/openjdk-9.0.4_linux-x64_bin.tar.gz /home/jenkins/workspace/" + JOB_NAME + "/build/"
                //sh "cp /home/jenkins/workspace/" + JOB_NAME + "/openjdk-10_linux-x64_bin.tar.gz /home/jenkins/workspace/" + JOB_NAME + "/build/"
            }
        }
        stage('Build cross-compilation OS') {
            steps {
                script {
                    try {
                        sh "docker logout"
                    } catch (err) {}
                }
                sh "docker build -t ev3dev-lang-java:jdk-stretch -f system/Dockerfile." + DOCKER_ARCH + " system "
            }
        }
        stage("Build cross-compilation environment") {
            steps {
                sh "docker build -t ev3dev-lang-java:jdk-build -f scripts/Dockerfile scripts "
            }
        }
        stage("Build") {
            steps {
                sh "docker run --rm -v /home/jenkins/workspace/" + JOB_NAME + "/build:/build -e JDKVER='" + JDKVER_VALUE + "' -e JDKVM='" + JDKVM_VALUE + "' -e JDKPLATFORM='" + JDKPLATFORM_VALUE + "' -e AUTOBUILD='1' ev3dev-lang-java:jdk-build"
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
                    sh "rm -rf /home/jenkins/workspace/" + JOB_NAME + "/build/jdk"
                } catch (err) {}
            }
        }
    }
}
