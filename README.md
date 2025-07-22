# Just Fan Noise

A fan noise app built with Flutter.

## Building

### Pre-requisites
1. Install Flutter, either:

   i. Manually, by following the official instructions at https://flutter.dev/docs/get-started/install, or;

   ii. Automatically on Linux, using my script:
      (Always use caution when running scripts from the internet. This script should be fairly easy to understand if you're familiar with linux, but if you're unsure, follow the official instructions instead.)

      ```bash
      curl -s https://raw.githubusercontent.com/adil192/adil192-linux/main/bootstrap/install_flutter.sh | bash
      ```

2. Install the app's build dependencies with one of the following:
   ```bash
   # For Ubuntu and Debian-based distros
   sudo apt install libmpv-dev
   # For Fedora and RHEL-based distros
   sudo dnf install mpv-devel
   ```


### Download the assets

The fan sprite assets are not included in this repo due to licensing restrictions. You can get them in one of two ways:

   1. If you are me, you can clone the private repo by running `./scripts/get-assets.sh`.

   2. Otherwise, you can buy and download the assets from https://gamedeveloperstudio.itch.io/animated-electric-fans-game-asset-pack or https://www.gamedeveloperstudio.com/graphics/viewgraphic.php?item=146n4f419v416n8q83

   3. If you just want to contribute, the license permits me to share the assets directly with you under some restrictions (see the [full license](https://www.gamedeveloperstudio.com/license.php) for details).
   Please email me at adilhanney@disroot.org to request the assets.

When you're done, your `assets/images/fan-assets/` directory should look like this:

```
assets/images/fan-assets
├── fan_head_no_cover_01.png
├── fan_head_no_cover_02.png
├── fan_head_no_cover_03.png
├── fan_head_no_cover_04.png
├── fan_head_no_cover_05.png
├── fan_head_no_cover_06.png
├── fan_head_no_cover_off.png
└── LICENSE.md
```


### Build the app

You can build the app simply by running `flutter build {some-platform-here}`,<br/>
e.g. `flutter build linux` or `flutter build apk`.
