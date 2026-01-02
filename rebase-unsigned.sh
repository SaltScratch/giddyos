IMAGE_PATH=ghcr.io/saltscratch/giddyos
IMAGE_TAG=latest
rpm-ostree rebase ostree-unverified-registry:$IMAGE_PATH:$IMAGE_TAG
systemctl reboot
