# Latest Julia image
FROM julia:1.9-buster

# make for tests
RUN apt-get update && apt install -y make

# Make a working directory, as it would be binded with the current language one
RUN mkdir julia
WORKDIR julia
ADD . .

# Commands for docker run
CMD make clean && make ready
