#!/bin/bash
# Installation instructions form Molpro 2024.3 on Mahti
# [runeberg@puhti-login14 runeberg]$ sha1sum /projappl/project_2001659/runeberg/molpro/molpro-2024.3.0.tar.gz
# aa2899756e2a8c0ca9f4e4c5c3aaae78ae14eaf1  /projappl/project_2001659/runeberg/molpro/molpro-2024.3.0.tar.gz
cd $TMPDIR
module load gcc/11.2.0
module load openmpi/4.1.2
module load .unsupported
module load intel-oneapi-mkl/2021.4.0
export PROJAPPL=/appl/soft/chem/molpro
export GA_BDIR=$TMPDIR
export MOLPRO_BDIR=$TMPDIR
export GA_INSTDIR=$PROJAPPL/ga_gcc11_mkl_new
export MOLPRO_VERSION=molpro-2024.3.0
export MOLPRO_INSTDIR=$PROJAPPL
export EIGEN_BDIR=$TMPDIR
export EIGEN_INSTDIR=$PROJAPPL/../eigen
mkdir -p $GA_BDIR
mkdir -p $MOLPRO_BDIR
mkdir -p $GA_INSTDIR
mkdir -p $MOLPRO_INSTDIR
cd $GA_BDIR
git clone https://github.com/GlobalArrays/ga
cd ga
./autogen.sh
./autogen.sh
./configure --with-mpi-pr --enable-i8 --with-blas8 --prefix=$GA_INSTDIR
nohup make -j 8 &> make_8.log&
make install
#add ga-config yo path
export PATH=$GA_INSTDIR/bin:$PATH

# 
wget https://gitlab.com/libeigen/eigen/-/archive/3.3.9/eigen-3.3.9.tar
tar xf eigen-3.3.9.tar 
cd eigen-3.3.9
mkdir build 
cd build 
export EIGEN_INSTDIR=$PROJAPPL/../eigen
mkdir $EIGEN_INSTDIR
cmake ../ -DCMAKE_INSTALL_PREFIX=$EIGEN_INSTDIR
make install
# Build Molpro
cd $MOLPRO_BDIR
tar xzf /projappl/project_2001659/runeberg/molpro/molpro-2024.3.0.tar.gz
cd $MOLPRO_VERSION
which ga-config

./configure --prefix=$MOLPRO_INSTDIR CXX=mpicxx CPPFLAGS="-I/appl/soft/chem/eigen/include/eigen3/"
nohup make -j 8 > make_8.log
make install
# adjust LAUNCHER to use srun

sed -i -e '/LAUNCHER/{;/mpiexec/s/LAUNCHER/#LAUNCHER/;}' $MOLPRO_INSTDIR/molpro_2024.3/bin/molpro
sed -i '4i LAUNCHER="srun %x"' $MOLPRO_INSTDIR/molpro_2024.3/bin/molpro
