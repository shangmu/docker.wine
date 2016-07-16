# docker.wine

Run GUI (or GUI-less) Windows programs inside a Docker container with Wine, with actual GUI
(unlike some other half-baked solutions only for situations where you don't need graphical interaction),
and without using VNC or other heavy-weight remote desktop solutions.

-----

The dockerfile here provides three ways to properly set up the user on the dockerized enviroment 
in order to easily share the host system/user's graphical display. Modify it to your needs to 
build your own docker image.

It also installs Xvfb so you can use it to run certain programs without actually seeing the GUI if you so choose.

Of course Wine is included in the build.

====

The .sh shell script is a helper for starting such a container without having to manually type in
the necessary arguments to use the host's display.

