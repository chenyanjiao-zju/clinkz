#!/bin/bash
#
# Install frpc to the client and manage it via systemd
#
# Maintainer: Xu Wang (wangxu298@whu.edu.cn)
# Please follow the format of PKGBUILD
#
# Sun Dec 6 2020

pkgname="frpc"
pkgver="0.34.3"
sources=(
			"https://github.com/fatedier/frp/releases/download/v${pkgver}/frp_0.34.3_linux_amd64.tar.gz"
		)
# TODO:
sha256sums=(
        'SKIP'
			)

prepare() {
	for i in `seq 1 ${#sources[@]}`; do
        local obj=${sources[$i]}
        echo "Getting $obj ..."
        curl -LJ0 $obj -o ${obj##*/}
        if [ $? -ne 0 ]; then
            echo "Error downloading ${obj##*/}"
            exit 1
        fi
        tocheck=$(sha256sum ${obj##*/} | awk '{print $1}')
        if [ $sha256sums[$i] != 'SKIP' ] && [ $tocheck != ${sha256sums[$i]} ]; then
            echo "Error checking sha256sum of ${obj##*/}"
            exit 1
        fi
    done
}

install() {
    if [ $(id -u) -ne 0 ]; then
        echo "Require root permission..."
        exit 1
    fi
    set -e
    tar -zxvf "frp_${pkgver}_linux_amd64.tar.gz"
    folder="frp_${pkgver}_linux_amd64"
    install -Dm755 ${folder}/frpc /usr/bin/frpc
    install -Dm644 ../config/frpc.ini.tempate /etc/frp/frpc.ini

# make frpc.service start at boot
    install -Dm644 ../server/systemd/frpc.service /lib/systemd/system/frpc.service
    install -Dm644 ../server/systemd/frp_start_post_notify.sh /etc/frp/frp_start_post_notify.sh
    install -Dm644 ../server/systemd/frp_stop_post_notify.sh /etc/frp/frp_stop_post_notify.sh
    systemctl enable frpc.service
}

main() {
    prepare
    install
}

main $@
