#!/bin/sh
set -x
  
# set some variables, so they're easy to adjust
TMPDIR=/var/tmp
BOOTSTRAP=/usr/local/hp-bootstrap
  
# these versions are current as of oct 3, 2014. if a lot of time has
# passed between then and the time you build this, you might want to
# verify they haven't been superseded by newer versions.
  
# haskell platform
HPVER="2014.2.0.0"
# glasgow haskell compiler
GHCVER="7.8.3"
# Cabal
CVER="1.20.0.2"
# cabal-install
CIVER="1.20.0.3"
  
# make sure some prerequisites are installed
RPMPKGS="gmp-devel mesa-libGL-devel mesa-libGLU-devel freeglut-devel"
rpm -q $RPMPKGS >/dev/null 2>&1 || sudo yum install $RPMPKGS
  
# grab the necessary archives
cd $TMPDIR
wget -c https://www.haskell.org/platform/download/${HPVER}/haskell-platform-${HPVER}-srcdist.tar.gz
wget -c http://www.haskell.org/ghc/dist/${GHCVER}/ghc-${GHCVER}-x86_64-unknown-linux-centos65.tar.bz2
wget -c http://www.haskell.org/cabal/release/cabal-${CVER}/Cabal-${CVER}.tar.gz
wget -c http://www.haskell.org/cabal/release/cabal-install-${CIVER}/cabal-install-${CIVER}.tar.gz
  
# decompress ghc and install it; we'll need the uncompressed
# ghc tarball when we build the Haskell Platform
cd $TMPDIR
tar xjf ghc-${GHCVER}-x86_64-unknown-linux-centos65.tar.bz2
cd ghc-${GHCVER}
./configure --prefix=$BOOTSTRAP
sudo make install
  
# clean up
cd $TMPDIR
/bin/rm -rf ghc-${GHCVER}
  
# put ghc in your PATH; we'll also use this path for cabal
# later on
export PATH=${BOOTSTRAP}/bin:$PATH
  
# decompress and install the Cabal library
tar xzf Cabal-${CVER}.tar.gz
cd Cabal-${CVER}
ghc -threaded --make Setup
./Setup configure --prefix=$BOOTSTRAP
./Setup build
sudo PATH=${BOOTSTRAP}/bin:$PATH ./Setup install
  
# clean up
cd $TMPDIR
/bin/rm -rf Cabal-${CVER}
  
# decompress and install cabal CLI tool
tar xzf cabal-install-${CIVER}.tar.gz
cd cabal-install-${CIVER}
sudo PATH=${BOOTSTRAP}/bin:$PATH PREFIX=$BOOTSTRAP ./bootstrap.sh --global
  
# clean up (requires root because "sudo bootstrap.sh" leaves
# root-owned build artifacts lying around)
cd $TMPDIR
sudo /bin/rm -rf cabal-install-${CIVER}
  
# run cabal update and install hscolour
sudo PATH=${BOOTSTRAP}/bin:$PATH ${BOOTSTRAP}/bin/cabal update
sudo PATH=${BOOTSTRAP}/bin:$PATH ${BOOTSTRAP}/bin/cabal install --global hscolour
  
# get rid of .cabal in root and build users home directory
sudo /bin/rm -rf /root/.cabal
/bin/rm -rf ${HOME}/.cabal
  
# decompress and install the Haskell Platform; this step may take
# a LONG time to complete, depending on the CPU and RAM available
tar xzf haskell-platform-${HPVER}-srcdist.tar.gz
cd haskell-platform-${HPVER}
./platform.sh ${TMPDIR}/ghc-${GHCVER}-x86_64-unknown-linux-centos65.tar.bz2

