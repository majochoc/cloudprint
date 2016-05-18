#!/bin/bash
FILENAME=`basename $1`
DIRNAME=`dirname $1`
/nodejs/bin/node /usr/local/podbot/index.js $1 $FILENAME $DIRNAME
