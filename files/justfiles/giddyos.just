[private]
default:
    @just --list

# Post-install setup
[group('Install')]
giddyos-post-install: giddyos-configure-git giddyos-mount-drives giddyos-download-horizon-client && giddyos-install-horizon-client

# Download Horizon Client
[group('Install')]
giddyos-download-horizon-client:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Downloading Horizon Client..."
    wget -O /tmp/horizon-client.rpm https://download3.omnissa.com/software/CART26FQ4_LIN64_RPMPKG_2512/Omnissa-Horizon-Client-2512-8.17.0-20187591429.x64.rpm
    echo "Horizon Client download complete."

# Install Horizon Client
[group('Install')]
giddyos-install-horizon-client:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Installing Horizon Client..."
    sudo rpm-ostree install /tmp/horizon-client.rpm

# Mount drives
[group('Setup')]
giddyos-mount-drives:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Mounting drives..."

    sudo mkdir /mnt/games
    sudo su -c "echo '/dev/disk/by-label/games /mnt/games auto nosuid,nodev,nofail,x-gvfs-show 0 0' >> /etc/fstab"
    sudo systemctl daemon-reload
    sudo mount -a

# Setup Git
[group('Setup')]
giddyos-setup-git:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Setting up Git config..."

    # Ask for Git username and email
    read -p "Enter your Git username: " git_username
    read -p "Enter your Git email: " git_email

    # Configure Git
    git config --global user.name "$git_username"
    git config --global user.email "$git_email"

    echo "Git setup complete"
