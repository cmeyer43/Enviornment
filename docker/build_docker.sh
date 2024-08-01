#!/bin/bash

tag=test-docker:1
image=test-docker-1.tar

docker build -t $tag .

echo to save:
echo docker save -o $image $tag

exit 0
