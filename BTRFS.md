# Btrfs + Snapper Setup

## Partition Layout
Create partitions during Arch live environment before running bootstrap.sh.

```
/dev/sdX1 → EFI (512MB, FAT32)
/dev/sdX2 → swap (match RAM size)
/dev/sdX3 → Btrfs (remainder)
```

## Subvolume Layout
```bash
mount /dev/sdX3 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@var_log
btrfs subvolume create /mnt/@var_cache
umount /mnt
```

## Mount with Options
```bash
mount -o noatime,compress=zstd,subvol=@ /dev/sdX3 /mnt
mkdir -p /mnt/{home,.snapshots,var/log,var/cache,boot/efi}
mount -o noatime,compress=zstd,subvol=@home /dev/sdX3 /mnt/home
mount -o noatime,compress=zstd,subvol=@snapshots /dev/sdX3 /mnt/.snapshots
mount -o noatime,compress=zstd,subvol=@var_log /dev/sdX3 /mnt/var/log
mount -o noatime,compress=zstd,subvol=@var_cache /dev/sdX3 /mnt/var/cache
mount /dev/sdX1 /mnt/boot/efi
```

## Install GRUB
```bash
pacstrap /mnt base base-devel linux linux-firmware grub efibootmgr
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
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
