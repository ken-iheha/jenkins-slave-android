FROM thedrhax/android-sdk:latest

MAINTAINER Ken Leung <ken.leung@infinitus-int.com>

ENV JENKINS_SLAVE_ROOT="/home/user/jenkins-slave"

USER root

# Install some useful packages
RUN apt-get update \
 && apt-get install -y qemu-kvm qemu-utils bridge-utils sudo socat android-tools-adb lib32stdc++6 lib32z1 ia32-libs\
 && apt-get clean \
 && rm -rf /var/lib/apt/lists /var/cache/apt

USER user

RUN mkdir -p "$JENKINS_SLAVE_ROOT"

# Slave settings
ENV JENKINS_MASTER_USERNAME="jenkins" \
    JENKINS_MASTER_PASSWORD="jenkins" \
    JENKINS_MASTER_URL="http://jenkins:8080/" \
    JENKINS_SLAVE_MODE="exclusive" \
    JENKINS_SLAVE_NAME="swarm-$RANDOM" \
    JENKINS_SLAVE_WORKERS="1" \
    JENKINS_SLAVE_LABELS="" \
    AVD=""

# Install Jenkins slave (swarm)
ADD swarm.jar /
ADD entrypoint.sh /

ENTRYPOINT /entrypoint.sh
