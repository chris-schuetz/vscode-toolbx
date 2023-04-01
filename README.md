# vscode-toolbx
In this repo you can find the Dockerfile and associated scripts I am using to setup my development environment.
It creates a [toolbx](https://containertoolbx.org/) environment with [Visual Studio Code](https://code.visualstudio.com/) that is able to run [devcontainers](https://containers.dev/) on [Fedora Kinoite](https://kinoite.fedoraproject.org/).

## Use
!! PLEASE CHECK THE SCRIPTS YOURSELF, BEFORE USING THEM! THERE WAS NO IN-DEPTH TESTING!!

You can configure the packages that will be installed into the toolbx by adding a package per line to the 'extra-packages' file.
Create the image with the create script
```
/.create.sh
```
Entering the toolbx is done as usual
```
toolbox enter
```
From inside the toolbx environment you can now start Visual Studio Code.
```
code
```

## devcontainer.json
There are some important configurations that need to be made in order for devcontainers to play nice with Fedora Kinoite. The template.devcontainer.json in this repo should get you started.

## Limitations
- "Clone Repository in Container Volume" doesn't work. I currently clone repos manually on the command line, then open the folder in code and "Reopen in Container".
- When a container was created and is reused in a subsequent start of VS Code, the wayland socket isn't handled properly. The script 'cleanupWaylandSockets.sh' tries to correct the problem, though it needs to be executed manually every time the issue occurs.

## Resources
The following resources helped immensely:
- The general idea was heavily inspired by this [comment](https://github.com/microsoft/vscode-remote-release/issues/7802).
- The host-runner script was taken from this [comment](https://github.com/containers/toolbox/issues/145#issuecomment-582040463).
- How to create a toolbx image was explained in this [blog](https://www.cogitri.dev/posts/12-fedora-toolbox/). I also took the handling of extra packages from there.
- Using a volume declaration via runArgs to setup the Z-flag for SELinux was taken from this [comment](https://github.com/microsoft/vscode-remote-release/issues/1333#issuecomment-898260126)
- Some details about podman and user namespaces can be found [here](https://www.redhat.com/sysadmin/rootless-podman-user-namespace-modes)
