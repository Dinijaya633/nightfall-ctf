FROM ubuntu:24.04

RUN apt-get update && \
    apt-get install -y openssh-server && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd

RUN useradd -m -s /bin/bash analyst && \
    echo "analyst:Nightfall123!" | chpasswd

RUN echo "NF06 challenge environment" > /home/analyst/README.txt

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]