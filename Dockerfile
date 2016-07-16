# This image is for running Windows programs with actual GUI,
# without using VNC.
# If there's no need to actually see the GUI, something like Xvfb
# can be used instead.

# To build the docker image, use a command line like this:
# docker build -t wine .

#FROM ubuntu
FROM ubuntu:14.04

# no error msg for initing dialog from package installs
#ENV DEBIAN_FRONTEND noninteractive

# wine needs i386 to to run i386 binaries
RUN dpkg --add-architecture i386
RUN apt-get update

# Wine 1.6
#RUN apt-get install -y wine1.6

# Wine 1.7
RUN apt-get install -y software-properties-common && add-apt-repository -y ppa:ubuntu-wine/ppa
RUN add-apt-repository ppa:ubuntu-x-swat/x-updates
	# not strictly necessary
RUN apt-get update
RUN apt-get install -y wine1.7

RUN apt-get install -y xvfb

# xeyes testing
RUN apt-get install -y x11-apps

#RUN apt-get purge -y software-properties-common
#RUN apt-get autoclean -y

#ADD . /build

# Reset the modified ENV
#ENV DEBIAN_FRONTEND=""

# Set up a user matching your UID on the host system.
# ( Alternative Approach:
#   If you don't mind making available the same set of accounts as the
#   host system, we can skip this and run the container with
#   "--volume /etc/passwd:/etc/passwd:ro --user $UID" instead
#   [we may also mount /etc/group to be complete]. and handle $HOME somehow
# )
# (This makes life easier. Running with different UID would require
#  --net=host and mounting .Xauthority file on ubuntu14.04.)

# Replace 1000 with your user / group id on your host system
RUN useradd -u 1000 -d /home/developer -m -s /bin/bash developer
#RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer

ENV HOME /home/developer
# If we didn't create a user from above:
# RUN mkdir $HOME
# RUN chmod 777 $HOME

RUN echo "alias ll='ls -al'" >> $HOME/.bashrc


#ENV WINEPREFIX /home/developer/.wine
#ENV WINEARCH win32
#ENV WINEDEBUG -all

# "sleep 5" fixes various problems, including %ProgramFiles% not staying and failing to create window in "&& xvfb-run ..."
RUN winecfg && wine cmd.exe /c echo '%ProgramFiles%' && sleep 5

#RUN xvfb-run -a winetricks -q corefonts
#RUN xvfb-run -a winetricks -q mfc42


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
