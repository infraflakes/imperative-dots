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
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner -C /mnt/gentoo
```

Now we edit the make.conf file:

```
vim /mnt/gentoo/etc/portage/make.conf
```

```
COMMON_FLAGS="-march=native -O2 -pipe"
CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"
FCFLAGS="${COMMON_FLAGS}"
FFLAGS="${COMMON_FLAGS}"
# Enable the official Gentoo binary repository
EMERGE_DEFAULT_OPTS="${EMERGE_DEFAULT_OPTS} --usepkg=y --getbinpkg=y"
FEATURES="${FEATURES} getbinpkg"
BINPKG_FORMAT="gpkg"
MAKEOPTS="-j16 -l14"
USE="X alsa pipewire sound-server pulseaudio elogind fcitx5 dbus -systemd -gnome -kde -wayland -aqua -coreaudio -cups -dvd -dvdr -cdr -emboss -doc -test -man -handbook -examples -gtk-doc -introspection -vala -nls -semantic-desktop -geolocation"

# Video Drivers:
VIDEO_CARDS="iris nvidia"

# CPU Specific Flags: 
# You can generate the exact string later using 'app-portage/cpuid2cpuflags'
#CPU_FLAGS_X86="aes avx avx2 f16c fma3 mmx mmxext pclmul popcnt rdrand sha sse sse2 sse3 sse4_1 sse4_2 ssse3"
LC_MESSAGES=C.UTF-8
```

Ensure networking works:

```
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
```

# Chroot

Mounting the fs:

```
mount --types proc /proc /mnt/gentoo/proc 
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run
mount --make-slave /mnt/gentoo/run
```

Chroot:

```
chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) ${PS1}
emerge-webrsync
emerge --sync --quiet
```

Select profile:

```
eselect profile list
eselect profile set 3
```

Because as of now, circular dependency happens between tiff and webp, temporarily disable webp and tiff for now:

```
USE="-webp" emerge -1v media-libs/tiff
```

And install base system:

```
emerge -vauDN @world
```

Install text editor for easier time (I love nvim):

```
emerge -q neovim
```

Set up timezone:

```
ln -sf ../usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
```

Set up locale:

```
nvim /etc/locale.gen
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
env-update && source /etc/profile && export PS1="(chroot) ${PS1}"
```

## Install the kernel

Group license compliance for firmware and define the kernel layout infrastructure explicitly:

```bash
echo "sys-kernel/linux-firmware @BINARY-REDISTRIBUTABLE" > /etc/portage/package.license/firmware
echo "sys-kernel/installkernel dracut" > /etc/portage/package.use/kernel
```

Install firmware stacks and the pre-compiled kernel in one single transaction

```bash
emerge -q sys-kernel/linux-firmware sys-firmware/sof-firmware sys-kernel/installkernel sys-kernel/gentoo-kernel-bin
```

## Generate fstab
Set up fstab:

```
echo "UUID=$(blkid -s UUID -o value /dev/nvme0n1p1)  /boot  vfat  noatime,umask=0077,fmask=0177  0 2" >> /etc/fstab
echo "UUID=$(blkid -s UUID -o value /dev/nvme0n1p2)  /  ext4  noatime,defaults  0 1" >> /etc/fstab
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

Set up network:

```
echo "net-misc/networkmanager -iwd wifi" >> /etc/portage/package.use/networkmanager
emerge -q net-misc/networkmanager net-wireless/wpa_supplicant
rc-update add NetworkManager default
```

Set root password:

```
passwd
```

Set user:

```
useradd -mG wheel,users,audio,video,portage,input,kvm -s /bin/bash nixuris
passwd nixuris
```

Set up doas:

```
emerge -q doas
echo "permit persist keepenv :wheel" > /etc/doas.conf
```

Set up GRUB:

```
echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
emerge -q sys-boot/grub efibootmgr fastfetch
grub-install --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg
```

Exit chroot:

```
exit
umount -R /mnt/gentoo
```
