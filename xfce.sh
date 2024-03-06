#! /bin/sh

TARGET_VOLUME="$(mount | grep ' /target ' | cut -d ' ' -f 1)"
DEB_SOURCE="deb http://deb.debian.org/debian"

# Enable BTRFS compression
mount -o remount,compress=zstd:3 /target
btrfs filesystem defragment -r -czstd -f /

# Create @home subvolume
mount "${TARGET_VOLUME}" /mnt
cd /mnt
btrfs subvolume create "@home"
USERNAME="$(ls -1 /target/home)"
rm -rf /target/home/*
cd

# Switch apt sources
cat << EOF > /target/etc/apt/sources.list
${DEB_SOURCE} testing main contrib non-free non-free-firmware
${DEB_SOURCE}-security testing-security main contrib non-free non-free-firmware
${DEB_SOURCE} testing-updates main contrib non-free non-free-firmware
EOF

# Add lmd repository
cat << EOF > /target/etc/apt/sources.list.d/lmd.list
deb https://lmd-linux.github.io/ stable main
EOF

# Add lmd and Google keys
wget -O /target/etc/apt/trusted.gpg.d/lmd.gpg lmd-linux.github.io/lmd.gpg
wget -O /target/tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

# Work around bug in Debian installer which tries and fails to set legacy time zones
TIMEZONE="$(sed -n "s/.*ignoring invalid time zone '\([^']*\)'.*/\1/p" /var/log/syslog)"
if [[ -n "${TIMEZONE}" ]]; then
    echo "${TIMEZONE}" > /target/tmp/timezone
fi

# Add post-instal script to run in target
cat << EOF > /target/tmp/post-install.sh
#! /bin/bash
apt-get update -y
apt-mark auto '*' > /dev/null
if [[ -f "/tmp/timezone" ]]; then
    apt-get install -y tzdata-legacy
    ln -sf "/usr/share/zoneinfo/\$(cat /tmp/timezone)" /etc/localtime
fi
apt-mark manual '*firmware*' '*microcode*'
laptop-detect && apt-get install -y tlp
apt-get install -y lmd-xfce
apt-get install -y /tmp/chrome.deb
apt-get purge -y ibus termit tilix xterm yelp zutty
apt autopurge -y
rm -rf /etc/network
sed 's/[ \t]\+/ /g' -i /etc/fstab
sed '/ \/ btrfs /{p;s/^\([^ ]*\) \/ \(.*\)rootfs/\1 \/home \2home/;}' -i /etc/fstab
sed 's/subvol=/compress=zstd:3,subvol=/' -i /etc/fstab
env | grep '^LANG=' > /etc/locale.conf
EOF

# Run post-install script in target chroot
chmod +x /target/tmp/post-install.sh
in-target --pass-stdout /tmp/post-install.sh > /target/var/log/lmd-install.log

# Copy skel files to existing user home
cp -rf /target/etc/skel "/mnt/@home/${USERNAME}"
chown -R 1000:1000 "/mnt/@home/${USERNAME}"
chmod -R go-w "/mnt/@home/${USERNAME}"
umount /mnt

# Copy skel files to root
rm -rf /target/root
cp -rf /target/etc/skel /target/root
chown -R 0:0 /target/root
chmod -R go-w /target/root

# Cleanup
cd /target/tmp
rm -rf -- ..?* .[!.]* *

# Save install syslog to target
cp /var/log/syslog /target/var/log/lmd-install.syslog
