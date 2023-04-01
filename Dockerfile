FROM registry.fedoraproject.org/fedora-toolbox:37

# The host-runner scrupt can run commands on the host system
COPY host-runner /usr/local/bin/
RUN chmod +x /usr/local/bin/host-runner

# Create a symbolic link to enable using podman inside toolbx
# Other programs can be enabled inside toolbx in the same way
RUN ln -s /usr/local/bin/host-runner /usr/local/bin/podman

# Import MS repository key, for VS Code repository
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc

# Add VS Code repository to yum
COPY vscode.repo /etc/yum.repos.d/

# Update dnf, the exit 0 is necessary because dnf check-update
# will exit with an error code 100, if there are any updates available.
RUN dnf check-update; exit 0

# Install extra packages by adding them to the extra-packages file
# Add the packages one package per line
COPY extra-packages /
RUN dnf -y install $(<extra-packages)
RUN rm /extra-packages
