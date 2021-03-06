# version numbers (modify if needed)
libxc_version=4.3.4

# installation directory (modify!)
tgt=/appl/soft/phys/libxc/$libxc_version

# setup build environment
module load gcc/9.1.0
export CFLAGS="-O3 -ffast-math -funroll-loops -march=cascadelake -fPIC"

# get source code using git
#   git clone https://gitlab.com/libxc/libxc.git libxc-$libxc_version
#   cd libxc-$libxc_version
#   git checkout $libxc_version
#   autoconf
# OR from a release tar-ball
tar xvfz ~/libxc-${libxc_version}.tar.gz
cd libxc-${libxc_version}

# build
./configure --prefix=$tgt 2>&1 | tee loki-conf
make 2>&1 | tee loki-make
make install 2>&1 | tee loki-inst

# fix permissions
chmod -R g=u $tgt
chmod -R o+rX $tgt

