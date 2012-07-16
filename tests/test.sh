#!/bin/bash

for x in `find . -type f -regex .*\.d`; do
    echo $x;

    rdmd -debug -gc -gs -I.. -L-lffi $x;
done;
