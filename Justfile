#!/usr/bin/env -S just --justfile
# shellcheck disable=SC1008
# shellcheck disable=SC1083

IMG_NAME := "localhost/mkosi"
CONTAINER_NAME := "mkosi"

_default:
    @just --list

fmt:
    just --unstable --fmt

clean:
    sudo rm -rvf -- ./mkosi.output/{*,.*}

setup:
    #!/usr/bin/env bash
    set -exo pipefail
    while read -r con_name; do
        if [[ $con_name == "{{ CONTAINER_NAME }}" ]]; then
            echo >&2 "Seems container {{ CONTAINER_NAME }} already exists"
            exit 1
        fi
    done < <(podman container ls --all --format '{{{{.Names}}')
    container=$(buildah from fedora)
    buildah run "$container" -- dnf install -y \
        git \
        /usr/bin/mkfs.erofs \
        /usr/share/distribution-gpg-keys \
        btrfs-progs \
        cpio \
        openssl \
        systemd \
        systemd-udev \
        systemd-ukify \
        zstd
    buildah copy "$container" /etc/sub{u,g}id /etc
    buildah commit --rm "$container" {{ IMG_NAME }}
    distrobox create --init --image {{ IMG_NAME }} --name {{ CONTAINER_NAME }}
