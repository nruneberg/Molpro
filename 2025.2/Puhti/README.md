```
runeberg@tofsmes:~/Support/Molpro/install$ scp molpro-2025.2.0.tar.gz puhti:/projappl/project_2001659/runeberg/molpro/

ssh puhti-login13

[runeberg@puhti-login13 molpro]$ cat /appl/soft/chem/molpro/build_molpro_2025.2_puhti.sh
#!/bin/bash
# Installation instructions form Molpro 2025.2 on puhti
# [runeberg@puhti-login14 runeberg]$ sha1sum /projappl/project_2001659/runeberg/molpro/molpro-2025.2.0.tar.gz
# 971d0c87dbf54603dce3a2db6dad4ed00b2d2b1f   /projappl/project_2001659/runeberg/molpro/molpro-2025.2.0.tar.gz
cd $TMPDIR
module load gcc/13.2.0
module load openmpi/5.0.5
module load intel-oneapi-mkl/2024.0.0

# Currently Loaded Modules:
# 1) gcc/11.3.0   2) intel-oneapi-mkl/2022.1.0   3) openmpi/4.1.4   4) csc-tools (S)   5) StdEnv
# 
export PROJAPPL=/appl/soft/chem/molpro
export GA_BDIR=$TMPDIR
export MOLPRO_BDIR=$TMPDIR
export GA_INSTDIR=$PROJAPPL/ga_gcc13_mkl_new
export MOLPRO_VERSION=molpro-2025.2.0
export MOLPRO_INSTDIR=$PROJAPPL
mkdir -p $GA_BDIR
mkdir -p $MOLPRO_BDIR
mkdir -p $GA_INSTDIR
mkdir -p $MOLPRO_INSTDIR 
# Can be commented out if a working GA is already available
cd $GA_BDIR
git clone https://github.com/GlobalArrays/ga
cd ga
./autogen.sh
./autogen.sh
./configure --with-mpi-pr --enable-i8 --with-blas8 --prefix=$GA_INSTDIR
make -j 8 > make_build.log 2>&1
if [ $? -ne 0 ]; then
  echo "GA build failed. See make_build.log for details."
  exit 1
fi
make install > make_install.log 2>&1
if [ $? -ne 0 ]; then
  echo "GA install failed. See make_install.log for details."
  exit 1
fi
#add ga-config yo path
export PATH=$GA_INSTDIR/bin:$PATH
# Build Molpro
cd $MOLPRO_BDIR
tar xzf /projappl/project_2001659/runeberg/molpro/molpro-2025.2.0.tar.gz
cd $MOLPRO_VERSION
which ga-config
./configure --prefix=$MOLPRO_INSTDIR CXX=mpicxx CPPFLAGS="-I/appl/soft/chem/eigen/include/eigen3/"
make -j 8 > make_build.log 2>&1
if [ $? -ne 0 ]; then
  echo "Molpro build failed. See make_build.log for details."
  exit 1
fi
make install > make_install.log 2>&1
if [ $? -ne 0 ]; then
  echo "Molpro install failed. See make_install.log for details."
  exit 1
fi
# Replace mpirun with srun in Molpro launch script
sed -i -e '/LAUNCHER=.*mpiexec/s/^/## /'  $MOLPRO_INSTDIR/molpro_2025.2/bin/molpro
sed -i '2i LAUNCHER="srun %x"' $MOLPRO_INSTDIR/molpro_2025.2/bin/molpro



```

