FROM ev3dev-lang-java:jdk-stretch

# copy build patches & scripts
COPY *.patch *.sh /opt/jdkcross/
RUN chmod +x /opt/jdkcross/*.sh

# this directory should be mounted
VOLUME /build

USER compiler
WORKDIR /opt/jdkcross
CMD ["/opt/jdkcross/autorun.sh"]
