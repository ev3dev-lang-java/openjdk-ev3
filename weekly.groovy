def jobs = [:]
for (int i = 9; i <= 11; i++) {
    int idx1 = i

    jobs["ev3-jdk${idx1}"] = {
        int idx2 = idx1
        stage ("Build JDK${idx2} for EV3") {
            build job: "openjdk${idx2}_build_ev3_linux",
                  parameters: [string(name: "DOCKER_ARCH", value: "armel"),
                               string(name: "JDKVER_VALUE", value: "${idx2}"),
                               string(name: "JDKVM_VALUE", value: "client"),
                               string(name: "JDKPLATFORM_VALUE", value: "ev3")]
        }
    }
}

jobs["rpi3-jdk10"] = {
    stage ("Build JDK10 for RPi3") {
        build job: "openjdk10_build_rpi3_linux",
              parameters: [string(name: "DOCKER_ARCH", value: "armhf"),
                           string(name: "JDKVER_VALUE", value: "10"),
                           string(name: "JDKVM_VALUE", value: "client"),
                           string(name: "JDKPLATFORM_VALUE", value: "rpi3")]
    }
}

parallel jobs
