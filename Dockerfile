# Dockerfile

FROM  phusion/baseimage:0.9.17

MAINTAINER  Author Name <philippe.gosse@sogeti.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list

# 1. Update the package repository, apt-get est un gestionnaire de paquets en console.
RUN apt-get -y update

# 2. Install python-software-properties. Gère les dépôts depuis lesquels vous installez des logiciels
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q python-software-properties software-properties-common

ENV JAVA_VER 8
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# 3.Install Oracle Java 8
#
# apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C2518248EEA14886 && : 
# Lors d'ajout des dépôts ppa à notre distribution afin de bénéficier de version supérieure de certains logiciels, pour éviter un message d'erreur.
# Pass advanced options to gpg. With adv --recv-key you can e.g. download key from keyservers directly into the the trusted set of keys.
#
# apt-get update : Mise à jour dépôts
#
# apt-get install -y --force-yes --no-install-recommends oracle-java${JAVA_VER}-installer oracle-java${JAVA_VER}-set-default :
# install java 8
#
# apt-get clean : L'option clean, option radicale, supprime la totalité des paquets présents dans /var/cache/apt/archives. 
#
# rm -rf /var/cache/oracle-jdk${JAVA_VER}-installer : supresssion de l'installer

RUN echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list && \
    echo 'deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C2518248EEA14886 && \
    apt-get update && \
    echo oracle-java${JAVA_VER}-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections && \
    apt-get install -y --force-yes --no-install-recommends oracle-java${JAVA_VER}-installer oracle-java${JAVA_VER}-set-default && \
    apt-get clean && \
    rm -rf /var/cache/oracle-jdk${JAVA_VER}-installer

RUN update-java-alternatives -s java-8-oracle

RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> ~/.bashrc

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/sbin/my_init"]
