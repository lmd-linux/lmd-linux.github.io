# `lmd` Linux

Not Lmd, nor LMD. Just `lmd`.

- Light and fast, all of the features but none of the cruft
- Easy on the eye desktop which stays out of your way and preserves vertical space
- Rolling and very up-to-date, yet stable
- Automatic updates, with automatic system snapshots you can easily select at boot
- Based on Debian testing, use APT to install and manage packages
- More features to come


# Installation

`lmd` Linux multiboots just fine. Make sure to install it last for best results.

1. Copy [this ISO image](https://drive.google.com/file/d/1UEJ5a6xcU3RaSL5abFUbCUy7QUY_4UrJ) to a USB
   stick and boot it.

2. Choose your location and language, connect to the internet (required, the image should have all
   the WiFi firmware you need, in case everything fails USB-tethering a smartphone always works),
   enter your real and user names, set your user password.

3. Select manual partitioning.
   1. UEFI (which you are most likely using) requires a bootable EFI System Partition. 40MB is
      enough, but you may have to make it as large as 200MB if you want to use `fwupd`. You do not
      need to create an additional EFI System Partition if one already exists because you're
      installing next to another Windows or Linux OS.
   2. Create a swap partition even if you think you don't need it. Make it the size of your RAM in
      case you want to use it to hibernate. You should use the GiB notation (gibibyte) instead of GB
      (gigabyte) to get the exact size of your RAM when setting the size of your swap partition.
   3. After that, all you need is a single `/` partition using the rest of your drive. It must be
      `btrfs`, and using the `noatime` mount option is recommended. Do not create any other
      partitions; subvolumes are going to be automatically created.

4. Confirm your partitioning and you're all done. The rest of the process will take 5 to 20 minutes
   depending on your machine and internet connection. **A very long time may be spent showing
   "Running preseed...", this is normal**, it's when the `lmd` magic happens so please just be
   patient.


# On your first boot

Log in normally, then reboot immediately. There is a yet unidentified issue between Google Chrome
and GNOME Keyring which makes the system hang at shutdown. All will be fine after that.


# Optional packages

## Google Chrome

Chrome comes pre-installed but is optional. You can remove it with:

```shell
sudo apt purge google-chrome-stable
```


## `lmd-japanese-input`

Tools, fonts and configuration for Japanese input. The default key combination for cycling through
input methods is `Super+Space`. The Super key is sometimes called the Windows key.

Install with:

```shell
sudo apt install lmd-japanese-input
```

Then log out and back in.


## `intel-undervolt`

Undervolt Intel CPU Core generations 6th to 10th and some others. Note that using the daemon mode
to set a performance hint may conflict with `tlp` which is automatically installed by `lmd` Linux on
laptops.

Install with:

```shell
sudo apt install intel-undervolt
```

Reboot, read the [instructions](https://github.com/lmd-linux/intel-undervolt/blob/master/README.md),
then edit `/etc/intel-undervolt.conf` to increase your undervolt little by little.


## `lmd-nomitigations`

Disable CPU and i915 vulnerability mitigations. This is not recommended for use in most situations.
Only install this package if you know exactly what you're doing because it has serious security
implications.

Install with:

```shell
sudo apt install lmd-nomitigations
```

Then reboot.


# Gaming

`lmd` linux comes with a sophisticated gaming setup allowing you to play almost all your Steam,
Epic. GOG or Amazon Prime games. They may even play faster than on Windows. To install it, paste the
following in a terminal:

```shell
curl -L lmd-linux.github.io/gaming | sudo bash
```

If you have an Nvidia GPU please refer to the
[NVIDIA Proprietary Driver instructions for Debian]( https://wiki.debian.org/NvidiaGraphicsDrivers).
The latest drivers for AMD and Intel GPUS, whether discrete or integrated, are already installed.

This will automatically install a number of tools and low-level configurations, some of them not
available anywhere else, as well as the following packages:


## MangoHud — https://github.com/flightlessmango/MangoHud

Default hotkeys are `Left_Shift+Equal` to toggle the HUD and `Left_Shift+Minus` to cycle through the
various FPS limit values.


## Steam installer — https://store.steampowered.com

Click on the Steam Installer entry in your desktop menu to automatically install and setup the Steam
client..

If you want to use MangoHud and/or GameMode in a Steam game, click on the cog icon to the right of the
game page, select Properties, and in the General tab add one of these in the LAUNCH OPTIONS box:

```shell
mangohud gamemoderun %command%
mangohud --dlsym gamemoderun %command%
gamemoderun %command%
```

The first one should almost always work. Very rarely you will have to add `--dlsym` like on the
second line. And even more rarely, you will have to disable MangoHud entirely like on the third
line.

If you have an old device with partial or broken support you will also often have to prefix each of
these lines with `PROTON_USE_WINED2D=1`, for example:

```PROTON_USE_WINED3D=1 mangohud gamemoderun %command%```


## Heroic — https://heroicgameslauncher.com

Use it for Epic, GOG, Amazon Prime as well as manually installed games. You can enable and configure
MangoHud, GameMode and gamescope in the UI. You can also download and manage Wine GE and Proton GE
versions, or choose the Wine version provided by `lmd` as a backup. You can even integrate all your
games into Steam in case you want to use its Big Picture Mode as a launcher for example.


## Retroarch — https://www.retroarch.com

Comes with some basic pre-configuration. Don't forget to go into the Online Updater in the main
menu, and run all the Update utilities (Core Info Files, Controller Profiles, etc…). Also, make sure
to run the Core System Files Downloader after installing cores that require extra assets.
