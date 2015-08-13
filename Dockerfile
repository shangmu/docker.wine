# This image is for running Windows programs with actual GUI,
# without using VNC.
# If there's no need to actually see the GUI, something like Xvfb
# can be used instead.

# To build the docker image, use a command line like this:
# docker build -t wine .

#FROM ubuntu
FROM ubuntu14.04

# wine needs i386 to to run i386 binaries
RUN dpkg --add-architecture i386
RUN apt-get update 
RUN apt-get install -y wine1.6


# xeyes testing
RUN apt-get install -y x11-apps

#ADD . /build


# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer

RUN echo "alias ll='ls -al'" >> $HOME/.bashrc

#RUN winetricks mfc42


#avoid having to set up a proper .Xauthority file.
# -v $HOME/.Xauthority:/home/developer/.Xauthority:ro

#ENV DISPLAY :0
#XSOCK=/tmp/.X11-unix/X0
#docker run -v $XSOCK:$XSOCK:ro wine xeyes


# "-e DISPLAY" is equivalent of "-e DISPLAY=$DISPLAY"

#docker run -it --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro \


# Credit:
# http://golangcloud.blogspot.com/2014/06/run-x11-application-inside-docker.html
# http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/
# http://stackoverflow.com/questions/16296753/can-you-run-gui-apps-in-a-docker-container
