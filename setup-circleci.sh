#!/bin/bash

cd Elm-Platform/master
cp ../../* .
cabal sandbox init --sandbox ..
cabal configure
cabal install --only-dependencies
cabal build

