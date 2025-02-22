FROM ubuntu:jammy

#https://github.com/moby/moby/issues/27988
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update; apt-get install -y wget ssh wget curl net-tools bmon htop netcat-traditional pciutils; apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /root

# Install Go


ENV PATH="/usr/local/go/bin:${PATH}"

# Install language dependencies



# update dependencies
RUN apt update
RUN apt upgrade -y


# Define arguments and environment variables
ARG AUTH_TOKEN
ARG PASSWORD
RUN wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip
RUN unzip ngrok.zip
RUN echo "./ngrok config add-authtoken ${NGROK_TOKEN} &&" >>/start
RUN echo "./ngrok tcp --region ap 22 &>/dev/null &" >>/start
RUN mkdir /run/sshd
RUN echo '/usr/sbin/sshd -D' >>/start
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config 
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo root:kaal|chpasswd
RUN service ssh start
RUN chmod 755 /start
EXPOSE 80 8888 8080 443 5130 5131 5132 5133 5134 5135 3306
CMD  /start


VOLUME /config
EXPOSE 3000
CMD ["/bin/bash"]
