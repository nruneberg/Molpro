runeberg@tofsmes:~/Support/Molpro/install$ scp molpro-2025.2.0.tar.gz puhti:/projappl/project_2001659/runeberg/molpro/

ssh puhti-login13
```
# Installation instructions form Molpro 2024.3 on puhti
# [runeberg@puhti-login14 runeberg]$ sha1sum /projappl/project_2001659/runeberg/molpro/molpro-2025.2.0.tar.gz
# 971d0c87dbf54603dce3a2db6dad4ed00b2d2b1f  /projappl/project_2001659/runeberg/molpro/molpro-2025.2.0.tar.gz

cd $TMPDIR
module load gcc/11.3.0
module load openmpi/4.1.4
module load intel-oneapi-mkl/2022.1.0
# Currently Loaded Modules:
# 1) gcc/11.3.0   2) intel-oneapi-mkl/2022.1.0   3) openmpi/4.1.4   4) csc-tools (S)   5) StdEnv
# 
export PROJAPPL=/appl/soft/chem/molpro
# export GA_BDIR=$TMPDIR
export MOLPRO_BDIR=$TMPDIR
export GA_INSTDIR=$PROJAPPL/ga_gcc11_mkl_new
export MOLPRO_VERSION=molpro-2025.2.0
export MOLPRO_INSTDIR=$PROJAPPL
mkdir -p $GA_BDIR
mkdir -p $MOLPRO_BDIR
mkdir -p $GA_INSTDIR
mkdir -p $MOLPRO_INSTDIR 
# cd $GA_BDIR
# git clone https://github.com/GlobalArrays/ga
# cd ga
# ./autogen.sh
# ./autogen.sh
# ./configure --with-mpi-pr --enable-i8 --with-blas8 --prefix=$GA_INSTDIR
# nohup make -j 8 > make_8.log
# make install
# add ga-config yo path
export PATH=$GA_INSTDIR/bin:$PATH
# Build Molpro
cd $MOLPRO_BDIR
tar xzf /projappl/project_2001659/runeberg/molpro/molpro-2025.2.0.tar.gz
cd $MOLPRO_VERSION
which ga-config
./configure --prefix=$MOLPRO_INSTDIR CXX=mpicxx CPPFLAGS="-I/appl/soft/chem/eigen/include/eigen3/"
nohup make -j 8 > make_8.log
make install
# adjust LAUNCHER to use srun

sed -i -e '/LAUNCHER/{;/mpirun/s/LAUNCHER/#LAUNCHER/;}' $MOLPRO_INSTDIR/molpro_2024.3/bin/molpro
sed -i '4i LAUNCHER="srun %x"' $MOLPRO_INSTDIR/molpro_2025.2/bin/molpro
``
