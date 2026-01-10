IMAGE_PATH=ghcr.io/saltscratch/giddy-blue
IMAGE_TAG=latest
rpm-ostree rebase ostree-image-signed:docker://$IMAGE_PATH:$IMAGE_TAG
systemctl reboot
