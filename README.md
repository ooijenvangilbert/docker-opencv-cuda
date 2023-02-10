# docker-opencv-cuda

to build the image :
docker build -t opencv-cuda .

to create a container :
docker create -i -t -- entrypoint="/bin/bash" --name opencv-cuda opencv-cuda

-i = interactive mode => keeps the container running to do something on the command line
-t = short for tty, adds sudo terminal for interaction
entrypoint => start point, this opens the terminal in this case.
--name = is the container name
then add from what image this will be created

to create and run :
docker run --rm [image]
--rm = remove when done.
