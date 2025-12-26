# Windows Bootloader Fixer v8.1.10
Fixes the Windows bootloader.

## Notes
- Allows you to fix Windows bootloaders for legacy BIOS and both legacy BIOS and UEFI (MBR) or UEFI (GPT).
- This batch file does not support fixing the bootloader for Windows To Go installations.
- This batch file cannot fix the bootloader of an online Windows installation.
- You may have to reconfigure other boot configurations.
- You may lose the Windows Recovery Environment when fixing the bootloader. You can do an in-place upgrade to get back the Windows Recovery Environment. You may want to delete the Windows Recovery Environment partition before doing the in-place upgrade to prevent extra unusable Windows Recovery Environments.
- This batch file may clear your auto-mount points.
