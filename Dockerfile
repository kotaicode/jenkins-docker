FROM jenkins/jenkins:lts
# if we want to install via apt
USER root
RUN apt-get update
# basics
RUN apt-get install -y openssl

ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No

# install RVM, Ruby, and Bundler
ENV GPG_TTY $(tty)
RUN \curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
RUN \curl -L https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.3"
RUN /bin/bash -l -c "rvm use 2.3 --default"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

#golang
ENV LANG en_US.UTF-8
ENV GOVERSION 1.9.0
ENV GOROOT /opt/go
ENV GOPATH /root/.go

RUN cd /opt && wget https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz && \
    tar zxf go${GOVERSION}.linux-amd64.tar.gz && rm go${GOVERSION}.linux-amd64.tar.gz && \
    ln -s /opt/go/bin/go /usr/bin/ && \
    mkdir $GOPATH
# drop back to the regular jenkins user - good practice
USER jenkins
