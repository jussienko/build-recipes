# target directory for installation
tgt=$USERAPPL/appl/python/3.7.3-cuda

# fetch source code
git clone https://github.com/python/cpython
cd cpython

# checkout correct version
git checkout v3.7.3

# setup build environment
module load gcc/8.3.0
module load cuda/10.1.168
module load mpich/3.3.1
module load intel-mkl/2019.0.4
export CFLAGS='-mavx512f -O3'
export CFLAGS="$CFLAGS -I/appl/spack/install-tree/gcc-9.1.0/libffi-3.2.1-5jujit/lib/libffi-3.2.1/include/"
export FFLAGS=$CFLAGS
export CPPFLAGS=$CFLAGS
export LDFLAGS=-L/appl/spack/install-tree/gcc-9.1.0/libffi-3.2.1-5jujit/lib64
export TCL_ROOT=/appl/spack/install-tree/gcc-9.1.0/tcl-8.6.8-ukn7zh
export TK_ROOT=/appl/spack/install-tree/gcc-9.1.0/tk-8.6.8-qnfbzv
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$TCL_ROOT/lib:$TK_ROOT/lib"
export TCL_LIBRARY=$TCL_ROOT/lib/tcl8.6
export TK_LIBRARY=$TK_ROOT/lib/tk8.6

# build and install
./configure --prefix=$tgt --enable-shared --disable-ipv6 --with-tcltk-includes="-I$TCL_ROOT/include -I$TK_ROOT/include" --with-tcltk-libs="-L$TCL_ROOT/lib -L$TK_ROOT/lib -ltcl8.6 -ltk8.6" 2>&1 | tee loki-conf
make 2>&1 | tee loki-make
make install 2>&1 | tee loki-inst
cd ..

# setup load script
sed -e "s|<BASE>|$tgt|g" -e "s|<TCLTK>|$TCL_ROOT/lib:$TK_ROOT/lib|g" -e "s|<TCLLIB>|$TCL_LIBRARY|g" -e "s|<TKLIB>|$TK_LIBRARY|g" load.sh > $tgt/load.sh

# install pip
source $tgt/load.sh
python3 -m ensurepip
pip3 install --upgrade pip

# fix permissions
chmod -R g=u $tgt
chmod -R o+rX $tgt

