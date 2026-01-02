IMAGE_PATH=ghcr.io/saltscratch/giddyos
IMAGE_TAG=latest
rpm-ostree rebase ostree-image-signed:docker://$IMAGE_PATH:$IMAGE_TAG
systemctl reboot
