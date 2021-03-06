#!/bin/bash
## Install the basics

apt-get update
apt-get install -y  bash wget openssh-server gcc gfortran binutils build-essential \
	time libc6-dev libgcc-5-dev libopenmpi-dev openmpi-common \
	openmpi-bin openmpi-doc libatlas3-base libatlas-base-dev \
	libatlas-dev libatlas-doc make

##Install OpenMPI
mkdir -p $HOME
cd $HOME
wget 'https://www.open-mpi.org/software/ompi/v2.0/downloads/openmpi-2.0.2.tar.gz'
tar -xf openmpi-2.0.2.tar.gz
cd openmpi-2.0.2/
mkdir build
cd build
../configure --prefix=/usr/local

make clean
make all install

adduser --disabled-password --gecos "" mpirun && \
	echo "mpirun ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

#Set OpenMPI ENV
export LD_LIBRARY_PATH="/usr/local/lib"

##Make HPL-Benchmark
wget http://www.netlib.org/benchmark/hpl/hpl-2.2.tar.gz
tar -xvf hpl-2.2.tar.gz -C /usr/local/
mkdir -p /home/benchmark

cd /usr/local/hpl-2.2/
wget 'https://raw.githubusercontent.com/ArangoGutierrez/containers-benchs/master/linpack/HPL/defs_dockerfiles/singularity/Make.Linux' -O Make.Linux

sed -i 's|$(LN_S) $(TOPdir)/Make.$(arch) Make.inc|$(LN_S) /usr/local/hpl-2.2/Make.$(arch) Make.inc|' Make.top

make arch=Linux clean_arch_all
make arch=Linux

echo "Please check your LD_LIBRARY_PATH after running this script"
echo "It should be set to '/usr/local/lib'"
