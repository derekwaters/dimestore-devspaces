# dimestore-devspaces
Turning a RHEL box into a multi-container separated dev server

## Installing
1. Start with a RHEL box. You'll have podmansh available out of the box
2. Create a quadlet container definition for podmansh, either at a system level:

    `/etc/containers/systemd/podmansh.container`

    or at a per-user level:

    `/etc/containers/systemd/users/${USER_ID}/podmansh.container`

3. Use one of the included templates to define the contents of the file.
4. Now create a user on the RHEL box:

    `sudo useradd -s /usr/bin/podmansh <username>`

5. Change their password:

    `sudo passwd <username>`

6. Now ssh to the RHEL box with the new account. You will be running inside a container with access to the user's $HOME/data folder.

## What it does
1. The RemapUsers=keep-id ensures that uids used inside the container are the same as on the host, so that reads/writes to the mounted folder operate as the launching user.
2. In root mode, the container runs as the 'root' user inside the container, but maps to the launching user on the host.
3. In rootless mode, the container runs as the launching user from the host and does not have 'root' access to the container.

## Building images
Containerfile definitions are provided for more secured container images (this is a work in progress!)

For example, you can build the secured ansible-dev-tools image with:

`podman build -f build/secure-ansible-dev-tools.Containerfile -t my_image_repo/ansible-secure-dev-tools:latest`

`podman push my_image_repo/ansible-secure-dev-tools:latest`
