FROM openjdk:11-jre
MAINTAINER github.com/dmikhev

# Base packages
RUN apt-get -y update && \
    apt-get -y install --no-install-recommends \
      wget \
      apt-utils \
      git \
      unzip \
      curl \
      gnupg \
      libgtk2.0-bin \
      libcanberra-gtk-module \
      libx11-xcb1 \
      libva-glx1 \
      libgl1-mesa-glx \
      libgl1-mesa-dri \
      libgconf-2-4 \
      libasound2 \
      libxss1 \
      default-jre

# Neo4j
RUN wget -nv -O - https://debian.neo4j.org/neotechnology.gpg.key | apt-key add - && \
    echo 'deb http://debian.neo4j.org/repo stable/' > /etc/apt/sources.list.d/neo4j.list && \
    apt-get -y update && \
    apt-get install -y neo4j

# BloodHound
RUN wget https://github.com/BloodHoundAD/BloodHound/releases/download/2.2.1/BloodHound-linux-x64.zip -nv -P /tmp && \
    unzip /tmp/BloodHound-linux-x64.zip -d /opt/ && \
    mkdir /data && \
    chmod +x /opt/BloodHound-linux-x64/BloodHound

# BloodHound Config
COPY config/*.json /root/.config/bloodhound/

# Start
RUN echo '#!/usr/bin/env bash\n\
    service neo4j start\n\
    echo "Starting ..."\n\
    if [ ! -e /opt/.ready ]; then touch /opt/.ready\n\
    echo "First run takes some time"; sleep 5\n\
    until $(curl -s -H "Content-Type: application/json" -X POST -d {\"password\":\"blood\"} --fail -u neo4j:neo4j http://127.0.0.1:7474/user/neo4j/password); do sleep 4; done; fi\n\
    cp -n /opt/BloodHound-linux-x64/resources/app/Ingestors/SharpHound.* /data\n\
    echo "\e[92m*** Log in with bolt://127.0.0.1:7687 (neo4j:blood) ***\e[0m"\n\                                                                                                                                                                                                   sleep 7; /opt/BloodHound-linux-x64/BloodHound 2>/dev/null\n' > /opt/run.sh &&\                                                                                                                                                                                                 chmod +x /opt/run.sh


# Clean up
RUN apt-get clean &&\
    apt-get clean autoclean &&\
    apt-get autoremove -y &&\
    rm -rf /tmp/* &&\
    rm -rf /var/lib/{apt,dpkg,cache,log}/


WORKDIR /data
CMD ["/opt/run.sh"]
