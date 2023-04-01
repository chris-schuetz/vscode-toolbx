#!/bin/bash
podman build . -t $USER/fedora-toolbox:latest
toolbox create -c fedora-toolbox-37 -i $USER/fedora-toolbox
