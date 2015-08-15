# "-e DISPLAY" is equivalent of "-e DISPLAY=$DISPLAY"
docker run -it --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
"$@"
