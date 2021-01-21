#!/usr/bin/env sh

KLEE_BUILD_DIR=/home/vagrant/klee
KLEE_DEPS_DIR=/home/vagrant/klee_deps
LLVM_HOME=/usr/lib/llvm-9

mkdir $KLEE_BUILD_DIR
cd $KLEE_BUILD_DIR


#If you want to configure `KLEE` with another llvm version,
#following variables must be set.
#
#	-DLLVM_CONFIG_BINARY=<LLVM_CONFIG_BINARY>
#	-DLLVMCC=<PATH_TO_CLANG>
#	-DLLVMCXX=<PATH_TO_CLANG++>

cmake \
	-DCMAKE_BUILD_TYPE="Debug" \
	-DENABLE_SOLVER_STP=ON \
	-DENABLE_SOLVER_Z3=ON \
	-DENABLE_POSIX_RUNTIME=ON \
	-DENABLE_KLEE_UCLIBC=ON \
	-DKLEE_UCLIBC_PATH=$KLEE_DEPS_DIR/klee-uclibc \
	-DSTP_DIR=$KLEE_DEPS_DIR/stp/build \
	-DZ3_INCLUDE_DIRS=/home/vagrant/.local/include \
	-DZ3_LIBRARIES=/home/vagrant/.local/lib/libz3.so \
	-DENABLE_UNIT_TESTS=OFF \
	-DENABLE_SYSTEM_TESTS=OFF \
	-DLLVM_CONFIG_BINARY=$LLVM_HOME/bin/llvm-config \
	-DLLVMCC=$LLVM_HOME/bin/clang \
	-DLLVMCXX=$LLVM_HOME/bin/clang++ \
	-DKLEE_RUNTIME_BUILD_TYPE="Debug" \
	/vagrant
make

