#!/bin/bash
podman build . -t $USER/fedora-toolbox:latest
toolbox create -c fedora-toolbox-38 -i $USER/fedora-toolbox
