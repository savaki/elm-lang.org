#!/bin/bash

# build the elm website as per instructions 
#
#   https://github.com/elm-lang/elm-lang.org
#

cd Elm-Platform/master
cp ../../* .
cabal sandbox init --sandbox ..
cabal configure
cabal install --only-dependencies
cabal build

