# `lmd` Linux

Not Lmd, nor LMD. Just `lmd`.

- Light and fast, all of the features but none of the cruft
- Easy on the eye desktop which stays out of your way and preserves vertical space
- Rolling and very up-to-date, yet stable
- Automatic updates, with automatic system snapshots you can easily select at boot
- Based on Debian testing, use APT to install and manage packages
- More features to come


# Installation

lmd Linux multiboots just fine. Make sure to install it last for best results.

1. Copy [this ISO image](https://drive.google.com/file/d/18ddvi3B6GkGRtDXTWwDPy9Y3swXzCkEE) to a USB
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
   depending on your machine and internet connection. A lot of time will be spent showing "Running
   preseed...", this is normal, it's when the `lmd` magic happens.


# On your first boot

Log in normally, then reboot immediately. There is a yet unidentified issue between Google Chrome
and GNOME Keyring which makes the system hang at shutdown. All will be fine after that.


# Optional packages

## Google Chrome

Chrome comes pre-installed but is optional. You can remove it with:

```shell
sudo apt purge google-chrome-stable```
```

Compositing is disabled in `lmd` for performance reasons and also because it's mostly useless. New
versions of Chrome have a bug with compositing disabled which you can fix by disabling the new (and
not great) desktop design. Just go to `chrome://flags`, search for "Chrome Refresh 2023", and simply
disable it.


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

`lmd` comes with a powerful gaming setup, not installed by default because it's fairly heavy. To
install it, run:

```shell
curl lmd-linux.github.io/gaming | sudo bash
```

A number of tools and configurations, some not available elsewhere, are installed to make gaming
faster and better. Among them (not an exhaustive list):


## MangoHud

Default hotkeys are `Left_Shift+Equal` to toggle the HUD and `Left_Shift+Minus` to cycle through the
various FPS limit values.


## Steam installer

Click on the Steam Installer entry in your desktop menu to automatically install and setup Steam.

If you want to use MangoHud and/or GameMode in a game, click on the cog icon to the right of the
game page, select Properties, and in the General tab add one of these in the LAUNCH OPTIONS box:

```shell
mangohud %command%
gamemoderun %command%
gamemoderun mangohud %command%
```


## Heroic

Use it for Epic, GOG, Amazon Prime as well as manually installed games. You can enable and configure
MangoHud, GameMode and gamescope in the UI. You can also download and manage Wine GE and Proton GE
versions, or choose the Wine version provided by `lmd` as a backup. You can even integrate all your
games into Steam in case you want to use its Big Picture Mode as a launcher for example.


## Retroarch

Comes with some basic pre-configuration. Don't forget to go into the Online Updater in the main
menu, and run all the Update utilities (Core Info Files, Controller Profiles, etc…). Also, make sure
to run the Core System Files Downloader after installing cores that require extra assets.
