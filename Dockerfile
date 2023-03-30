FROM ubuntu:20.04

# cmake installation
RUN apt-get -y update
RUN UBUNTU_FRONTEND=noninteractive apt-get -yq install cmake
RUN apt-get -y update
RUN apt-get -yq install build-essential
RUN apt -yq install cmake g++ libprotobuf-dev protobuf-compiler # may be apt-get

# some linux tools installation
RUN apt-get -y install git
RUN apt-get -y install wget
RUN apt-get -y install make
RUN apt-get -y install valgrind

# install dynamorio project (for .so build)
RUN git clone https://github.com/DynamoRIO/dynamorio.git

# install dynamorio release (for bin64/drrun call)
RUN wget https://github.com/DynamoRIO/dynamorio/releases/download/release_9.0.1/DynamoRIO-Linux-9.0.1.tar.gz
RUN tar -xvzf DynamoRIO-Linux-9.0.1.tar.gz

# install some repo for testing installation
RUN git clone https://github.com/fmtlib/fmt.git

COPY . .

ENTRYPOINT ["bash", "./run.sh"]
