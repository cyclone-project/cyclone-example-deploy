FROM ubuntu:14.04
MAINTAINER Erik Berdonces <e.berdoncesbonelo@campus.tu-berlin.de>

RUN apt-get update && apt-get install -y openssh-server wget
RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Install PAM module

# Expose ports 7000-8000
RUN wget -O - https://raw.githubusercontent.com/cyclone-project/cyclone-python-pam/master/setup.sh | sh
EXPOSE 7000-8000

# Add the custom configuration
ADD cyclone_config /lib/security/cyclone_config
ADD sshd /etc/pam.d/sshd

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
