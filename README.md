# lmd Linux

- Light and fast, all of the features but none of the cruft
- Easy on the eye desktop which gets out of your way and preserves vertical space
- Rolling and very up-to-date, yet stable
- Automatic updates with automatic system snapshots
- Based on Debian testing, use APT to install and manage packages
- More features to come


# Installation

1. Copy [this ISO image](https://drive.google.com/file/d/18ddvi3B6GkGRtDXTWwDPy9Y3swXzCkEE) to a USB
   stick and boot it.

2. Choose your location and language, connect to the internet (required, the image should have all
   the WiFi firmware you need, in case everything fails USB-tethering a smartphone always works),
   enter your real and user names, set your user password.

3. Partitioning
   1. UEFI (which you are most likely using) requires a bootable EFI System Partition. 40MB is
      enough but you may want to make it as large as 200MB if you want to use `fwupd`.
   2. Create a swap partition even if you think you don't need swap. Make it the size of your RAM in
      case you want to use it to hibernate. You should use the GiB notation (gibibyte) instead of GB
      (gigabyte) to get the exact size of your RAM when setting the size of your swap partition.
   3. After that, all you need is a single `/` partition using the rest of your drive. It must be
      `btrfs`, and I always use the `noatime` mount option. Do not create any other partitions;
      subvolumes are going to be automatically created.

4. Confirm your partitioning and you're all done. The rest of the process will take 5 to 20 minutes
   depending on your machine and internet connection. A lot of time will be spent showing "Running
   preseed", this is normal.


# On your first boot

Log in normally, then reboot immediately. There is a yet unidentified issue between Google Chrome
and GNOME Keyring which makes the former fail to start on the first login, and hang at system
shutdown. All will be fine after that.
