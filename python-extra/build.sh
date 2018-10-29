### Continue directly after ../scalable-python/kommand
###   i.e. $tgt points to the install dir of Scalable Python

# volatile version numbers
numpy_version=1.13.3
scipy_version=0.19.1
ase_version=3.15.0
libsci_version=16.11.1

# load Scalable Python
source $tgt/load.sh
export CFLAGS="-fPIC $CFLAGS -fopenmp"
export FFLAGS="-fPIC $FFLAGS -fopenmp"

# isolate modules using PYTHONUSERBASE
export PYTHONUSERBASE=$tgt/bundle/2017-10
mkdir -p $PYTHONUSERBASE/lib/python2.7/site-packages

# cython + mpi4py
pip install --user cython
pip install --user mpi4py

# numpy
git clone git://github.com/numpy/numpy.git numpy-$numpy_version
cd numpy-$numpy_version
git checkout v$numpy_version
sed -e "s|<MKLROOT>|$MKLROOT|g" ../setup/site.cfg-taito-template > site.cfg
# or w/ libsci:
#  sed -e 's/<ARCH>/haswell/g' -e "s/<LIBSCI>/$libsci_version/g" ../setup/site.cfg-sisu-template >| site.cfg
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
python setup.py install --user 2>&1 | tee loki-inst
cd ..

# fix permissions
chmod -R g+rwX $tgt
chmod -R o+rX $tgt
