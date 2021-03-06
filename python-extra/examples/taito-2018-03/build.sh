### Python (extra) modules installation script for Sisu (/Taito)
###   uses PYTHONUSERBASE to bundle all modules into a separate location
###   away from the base python installation

# load Python
PYTHONHOME=/appl/nano/gpaw/python/2.7.13
source $PYTHONHOME/load.sh
# or if no module exists:
#   source $PYTHONHOME/load.sh

# installation directory (modify!)
tgt=$PYTHONHOME/bundle/2018-03

# version numbers (modify if needed)
numpy_version=1.14.2
scipy_version=1.0.1
ase_version=3.16.0
libsci_version=16.11.1

# setup build environment
module purge
module load gcc/4.9.3
module load mkl/11.3.0
module load intelmpi/5.1.1
module load git
export CC=cc
export FC=f77
export CXX=CC
export CFLAGS='-fPIC -march=sandybridge -mtune=haswell -O3 -fopenmp'
export FFLAGS='-fPIC -march=sandybridge -mtune=haswell -O3 -fopenmp'

# use --user to install modules
export PYTHONUSERBASE=$tgt
mkdir -p $PYTHONUSERBASE/lib/python2.7/site-packages

# cython + mpi4py
pip install --user cython
pip install --user mpi4py

# numpy
git clone git://github.com/numpy/numpy.git numpy-$numpy_version
cd numpy-$numpy_version
git checkout v$numpy_version
# with MKL (for Taito):
sed -e "s|<MKLROOT>|$MKLROOT|g" ../setup/site.cfg-taito-template >| site.cfg
# or w/ libsci (for Sisu):
#   sed -e 's/<ARCH>/haswell/g' -e "s/<LIBSCI>/$libsci_version/g" ../setup/site.cfg-sisu-template >| site.cfg
python setup.py build -j 4 install --user 2>&1 | tee loki-inst
cd ..

# scipy
git clone git://github.com/scipy/scipy.git scipy-$scipy_version
cd scipy-$scipy_version
git checkout v$scipy_version
python setup.py build -j 4 install --user 2>&1 | tee loki-inst
cd ..

# ase
git clone https://gitlab.com/ase/ase.git ase-$ase_version
cd ase-$ase_version
git checkout $ase_version
patch setup.py ../setup/patch-ase.diff
python setup.py install --user 2>&1 | tee loki-inst
cd ..

# fix permissions
chmod -R g+rwX $tgt
chmod -R o+rX $tgt

