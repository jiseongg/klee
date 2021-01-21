#!/usr/bin/env sh

#### /vagrant/bootstrap.sh - install system-wide program

apt-get update

DEBIAN_FRONTEND=noninteractive apt-get install -y \
	build-essential cmake \
	python3 python3-pip \
	gcc-multilib g++-multilib \
	git vim

# llvm
DEBIAN_FRONTEND=noninteractive apt-get install -y \
	curl libcap-dev libncurses5-dev python-minimal \
	python-pip unzip libtcmalloc-minimal4 \
	libgoogle-perftools-dev libsqlite3-dev doxygen

DEBIAN_FRONTEND=noninteractive apt-get install -y \
	clang-9 llvm-9 llvm-9-dev llvm-9-tools

# stp dependencies
DEBIAN_FRONTEND=noninteractive apt-get install -y \
	bison flex libboost-all-dev python perl zlib1g-dev minisat

# klee experiment dependencies
pip3 install wllvm

cat /vagrant/bash_profile >> /home/vagrant/.bashrc
