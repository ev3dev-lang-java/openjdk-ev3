FROM ev3dev-lang-java:jdk-stretch

# copy build patches & scripts
COPY *.patch *.sh /opt/jdkcross/
COPY lejos/       /opt/jdkcross/lejos/
RUN chmod +x /opt/jdkcross/*.sh /opt/jdkcross/lejos/*.sh

# this directory should be mounted
VOLUME /build

USER compiler
WORKDIR /opt/jdkcross
CMD ["/bin/bash"] ["--login"]
