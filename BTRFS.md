# Btrfs + LUKS2 + Snapper Setup

## Partition Layout
Create partitions during Arch live environment before running bootstrap.sh.

```
/dev/sdX1 → EFI (512MB, FAT32)
/dev/sdX2 → swap (match RAM size)
/dev/sdX3 → LUKS2 container → Btrfs (remainder)
```

## LUKS2 Encryption
```bash
cryptsetup luksFormat --type luks2 /dev/sdX3
cryptsetup open /dev/sdX3 cryptroot
mkfs.btrfs /dev/mapper/cryptroot
```

## Subvolume Layout
```bash
mount /dev/mapper/cryptroot /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@var_log
btrfs subvolume create /mnt/@var_cache
umount /mnt
```

## Mount with Options
```bash
mount -o noatime,compress=zstd,subvol=@ /dev/mapper/cryptroot /mnt
mkdir -p /mnt/{home,.snapshots,var/log,var/cache,boot/efi}
mount -o noatime,compress=zstd,subvol=@home /dev/mapper/cryptroot /mnt/home
mount -o noatime,compress=zstd,subvol=@snapshots /dev/mapper/cryptroot /mnt/.snapshots
mount -o noatime,compress=zstd,subvol=@var_log /dev/mapper/cryptroot /mnt/var/log
mount -o noatime,compress=zstd,subvol=@var_cache /dev/mapper/cryptroot /mnt/var/cache
mount /dev/sdX1 /mnt/boot/efi
```

## Install GRUB
```bash
pacstrap /mnt base base-devel linux linux-firmware grub efibootmgr cryptsetup
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
```

## Configure mkinitcpio
Edit `/etc/mkinitcpio.conf` and add `encrypt` before `filesystems` in the HOOKS array:
```
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt filesystems fsck)
```
Then regenerate:
```bash
mkinitcpio -P
```

## Configure GRUB for LUKS
Get the UUID of the encrypted partition (not the mapper):
```bash
blkid /dev/sdX3
```

Add to `GRUB_CMDLINE_LINUX` in `/etc/default/grub`:
```
cryptdevice=UUID=<your-uuid>:cryptroot root=/dev/mapper/cryptroot
```
Then generate config:
```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

## Snapper
```bash
pacman -S snapper snap-pac grub-btrfs
snapper -c root create-config /
snapper -c home create-config /home
systemctl enable --now snapper-timeline.timer
systemctl enable --now snapper-cleanup.timer
systemctl enable --now grub-btrfsd
```

## Snapper Config Tweaks
Edit `/etc/snapper/configs/root` — suggested limits:
```
TIMELINE_MIN_AGE="1800"
TIMELINE_LIMIT_HOURLY="5"
TIMELINE_LIMIT_DAILY="7"
TIMELINE_LIMIT_WEEKLY="0"
TIMELINE_LIMIT_MONTHLY="0"
TIMELINE_LIMIT_YEARLY="0"
```

## Restoring from Snapshot
Snapshots are bootable via GRUB (grub-btrfs surfaces them automatically).
To permanently roll back:
```bash
# Boot into snapshot from GRUB, then:
sudo btrfs subvolume delete /@
sudo btrfs subvolume snapshot / /@
```
