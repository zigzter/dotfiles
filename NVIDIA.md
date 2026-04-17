# NVIDIA + Hyprland (DANGERDOOM)

## Kernel Parameters
Add to GRUB_CMDLINE_LINUX in `/etc/default/grub`:
```
nvidia_drm.modeset=1 nvidia_drm.fbdev=1
```
Then regenerate:
```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

## Modules
Add to `/etc/mkinitcpio.conf` MODULES array:
```
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt filesystems fsck)
```
Then regenerate:
```bash
mkinitcpio -P
```

## Environment Variables
Add to `/etc/environment` or your Hyprland config:
```
LIBVA_DRIVER_NAME=nvidia
__GLX_VENDOR_LIBRARY_NAME=nvidia
GBM_BACKEND=nvidia-drm
__NV_PRIME_RENDER_OFFLOAD=1
NVD_BACKEND=direct
ELECTRON_OZONE_PLATFORM_HINT=auto
```

## Hyprland Config
Add to `hyprland.conf`:
```
env = LIBVA_DRIVER_NAME,nvidia
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = GBM_BACKEND,nvidia-drm
env = __NV_PRIME_RENDER_OFFLOAD,1
env = NVD_BACKEND,direct
env = ELECTRON_OZONE_PLATFORM_HINT,auto

cursor {
    no_hardware_cursors = true
}
```

## Pacman Hook (prevents mkinitcpio from being out of sync after driver updates)
Create `/etc/pacman.d/hooks/nvidia.hook`:
```ini
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia
Target=linux

[Action]
Description=Updating NVIDIA module in initcpio
Depends=mkinitcpio
When=PostTransaction
Exec=/usr/bin/mkinitcpio -P
```

## Verify
```bash
nvidia-smi
hyprctl monitors  # should show your display
```
