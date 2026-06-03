## Gentoo installation

# Warm up!

This guide assume you use GUI live cd

First change gentoo password:

```
sudo su
passwd gentoo
```

Go to kde settings and set correct time and date.

# Paritioning

Partition the disk with cfdisk!

Format the unified Boot/ESP partition (Give it 1GB or 2GB to hold kernels comfortably):

```bash
mkfs.vfat /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2
```

```bash
mount -o noatime -m /dev/nvme0n1p2 /mnt/gentoo
mount -m /dev/nvme0n1pX /mnt/gentoo/boot
```

# Boot-strapping

Then enter the directory:

```
cd /mnt/gentoo
links https://www.gentoo.org/downloads/mirrors/
```

Go to download section then pick the first option (stage 3 openrc):

Then press enter, save it, then unpack:

```
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner
```

Now we edit the make.conf file:

```
vim etc/portage/make.conf
```

For `i7-12700h` chipset:

```
COMMON_FLAGS="-march=alderlake -O2 -pipe"
CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"
FCFLAGS="${COMMON_FLAGS}"
FFLAGS="${COMMON_FLAGS}"
EMERGE_DEFAULT_OPTS="--verbose --ask --update --deep --newuse"
# Enable the official Gentoo binary repository
EMERGE_DEFAULT_OPTS="${EMERGE_DEFAULT_OPTS} --usepkg=y --getbinpkg=y --binpkg-respect-use=y"
FEATURES="${FEATURES} getbinpkg"
BINPKG_FORMAT="gpkg"
MAKEOPTS="-j16 -l14"
USE="nftables X alsa pipewire sound-server opus pulseaudio elogind fcitx5 dbus -systemd -gnome -kde -wayland -aqua -coreaudio -cups -dvd -dvdr -cdr -emboss -doc -test -man -handbook -examples -gtk-doc -vala -nls -semantic-desktop -geolocation"

# X11:
ACCEPT_LICENSE="* -@EULA NVIDIA-r1"
VIDEO_CARDS="intel nvidia"
INPUT_DEVICES="libinput"

# CPU Specific Flags: 
# You can generate the exact string later using 'app-portage/cpuid2cpuflags'
#CPU_FLAGS_X86="aes avx avx2 f16c fma3 mmx mmxext pclmul popcnt rdrand sha sse sse2 sse3 sse4_1 sse4_2 ssse3"
LC_MESSAGES=C.UTF-8
GRUB_PLATFORMS="efi-64"
```

Ensure networking works:

```
cp --dereference /etc/resolv.conf etc/
```

# Chroot

Mounting the fs:

```
mount --types proc /proc proc 
mount --rbind /sys sys
mount --make-rslave sys
mount --rbind /dev dev
mount --make-rslave dev
mount --bind /run run
mount --make-slave run
```

Chroot:

```
chroot . /bin/bash
source /etc/profile
```

```
mkdir -p /var/tmp/portage && mount -t tmpfs -o size=12G,nodev,nosuid,noatime tmpfs /var/tmp/portage
```

Set up timezone:

```
ln -sf ../usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
```

Set up locale:

```
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
```

Uncomment en_US then:

```
locale-gen
```

set syswide locale:

```
eselect locale list
```

```
eselect locale set 4
env-update && source /etc/profile
```

```
emerge-webrsync
emerge --sync
```

Select profile (desktop stable):

```
eselect profile list
eselect profile set 3
```

Because as of now, circular dependency happens between tiff and webp, temporarily disable webp and tiff for now:

```
USE="-webp" emerge -1v media-libs/tiff
USE="-tiff" emerge -1v media-libs/libwebp
```

And install base system:

```
emerge -vauDN @world
```

## Install the kernel

Group license compliance for firmware and define the kernel layout infrastructure explicitly:

```bash
mkdir -p /etc/portage/package.license
echo "sys-kernel/linux-firmware @BINARY-REDISTRIBUTABLE" > /etc/portage/package.license/firmware
echo "sys-kernel/installkernel dracut" > /etc/portage/package.use/kernel
```

Install firmware stacks and the pre-compiled kernel in one single transaction

```bash
emerge -q sys-kernel/linux-firmware sys-firmware/sof-firmware sys-kernel/installkernel sys-kernel/gentoo-kernel-bin neovim
```

Set up user session stuff:

```bash
echo "net-misc/networkmanager -iwd wifi" >> /etc/portage/package.use/networkmanager
echo -e "media-video/pipewire sound-server pipewire-alsa pulseaudio\nmedia-sound/pulseaudio -daemon" >> /etc/portage/package.use/audio
echo "app-i18n/fcitx-unikey ~amd64" >> /etc/portage/package.accept_keywords/fcitx-unikey
echo "media-video/obs-studio ~amd64" >> /etc/portage/package.accept_keywords/obs
```

```bash
emerge -q networkmanager wpa_supplicant sys-apps/dbus elogind dev-vcs/git fastfetch media-video/pipewire media-video/wireplumber sys-auth/polkit x11-base/xorg-drivers x11-drivers/nvidia-drivers x11-base/xorg-server x11-apps/xrandr xdg-utils cwm flameshot slock x11-misc/xclip xdg-desktop-portal-gtk fcitx fcitx-configtool fcitx-gtk fcitx-unikey doas light sys-apps/lm-sensors playerctl app-containers/podman pulsemixer tailscale p7zip unrar unzip zip imv mpv obs-studio firefox-bin fish ghostty sys-boot/grub efibootmgr
```

```bash
rc-update add NetworkManager default
rc-update add dbus default
rc-update add elogind boot
```

( You can launch audio with `gentoo-pipewire-launcher` script)

## Generate fstab

Set up fstab:

```
echo "UUID=$(blkid -s UUID -o value /dev/nvme0n1p1)  /boot  vfat  noatime,umask=0077,fmask=0177  0 2" >> /etc/fstab
echo "UUID=$(blkid -s UUID -o value /dev/nvme0n1p2)  /  ext4  noatime,defaults  0 1" >> /etc/fstab
echo "tmpfs /var/tmp/portage tmpfs size=12G,nodev,nosuid,noatime 0 0" >> /etc/fstab
```

## User related

Setup hostname:

```
echo 'hostname="serein"' > /etc/conf.d/hostname
```

Set up hosts:

nvim /etc/hosts

```
127.0.0.1       localhost serein
::1             localhost serein
```

Set root password:

```
passwd
```

Set user:

```
useradd -mG wheel,users,audio,video,render,portage,input,kvm -s /bin/bash nixuris
passwd nixuris
```

Set up other tools:

```bash
```

```
echo "permit persist keepenv :wheel" > /etc/doas.conf
chsh -s $(which fish)
chsh -s $(which fish) nixuris
```

Add this to /etc/default/grub:

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash nvidia-drm.modeset=1"
```

Then:

```
grub-install --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg
```

Exit chroot:

```
exit
umount -R /mnt/gentoo
```

## POST INSTALL

GURU PKGS:

```bash
app-eselect/eselect-repository
```
```bash
eselect repository enable guru
emaint sync -r guru
```
```bash
echo '*/*::guru ~amd64' > /etc/portage/package.accept_keywords/guru
```

```bash
emerge -q yazi bluetuith
```
