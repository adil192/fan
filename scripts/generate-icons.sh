#!/bin/bash

# Convert all svg to png
for svg_file in assets/icon/*.svg; do
  png_file="${svg_file%.svg}.png"
  echo "Rasterizing $svg_file..."
  rsvg-convert -o "$png_file" "$svg_file"
done
echo

# Use the flutter_launcher_icons package to generate icons as a starting point
echo "Generating icons with flutter_launcher_icons..."
dart run flutter_launcher_icons
echo

# Re-generate android icons because flutter_launcher_icons' are pixelated
echo "Replacing android icons"
function replace_android_drawables() {
  local size=$1
  local sizeName=$2
  echo "Resizing logo_android_fg.svg to ${sizeName} (${size}x${size})"
  rsvg-convert -o "android/app/src/main/res/drawable-${sizeName}/ic_launcher_foreground.png" assets/icon/logo_android_fg.svg -w $size -h $size
  echo "Resizing logo_android_mono.svg to ${sizeName} (${size}x${size})"
  rsvg-convert -o "android/app/src/main/res/drawable-${sizeName}/ic_launcher_monochrome.png" assets/icon/logo_android_mono.svg -w $size -h $size
}
replace_android_drawables 108 mdpi
replace_android_drawables 162 hdpi
replace_android_drawables 216 xhdpi
replace_android_drawables 324 xxhdpi
replace_android_drawables 432 xxxhdpi
function replace_android_mipmap() {
  local size=$1
  local sizeName=$2
  echo "Resizing logo.png to ${sizeName} (${size}x${size})"
  rsvg-convert -o "android/app/src/main/res/mipmap-${sizeName}/ic_launcher.png" assets/icon/logo.svg -w $size -h $size
}
replace_android_mipmap 48 mdpi
replace_android_mipmap 72 hdpi
replace_android_mipmap 96 xhdpi
replace_android_mipmap 144 xxhdpi
replace_android_mipmap 192 xxxhdpi
echo

echo "Replacing iOS icons"
function replace_ios_icon() {
  local size=$1
  local sizeName=$2
  # ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png
  echo "Resizing logo_ios.svg to ${sizeName} (${size}x${size})"
  rsvg-convert -o "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-${sizeName}.png" assets/icon/logo_ios.svg -w $size -h $size
}
replace_ios_icon 20 20x20@1x
replace_ios_icon 40 20x20@2x
replace_ios_icon 60 20x20@3x
replace_ios_icon 29 29x29@1x
replace_ios_icon 58 29x29@2x
replace_ios_icon 87 29x29@3x
replace_ios_icon 40 40x40@1x
replace_ios_icon 80 40x40@2x
replace_ios_icon 120 40x40@3x
replace_ios_icon 50 50x50@1x
replace_ios_icon 100 50x50@2x
replace_ios_icon 57 57x57@1x
replace_ios_icon 114 57x57@2x
replace_ios_icon 120 60x60@2x
replace_ios_icon 180 60x60@3x
replace_ios_icon 72 72x72@1x
replace_ios_icon 144 72x72@2x
replace_ios_icon 76 76x76@1x
replace_ios_icon 152 76x76@2x
replace_ios_icon 167 83.5x83.5@2x
replace_ios_icon 1024 1024x1024@1x
echo

echo All done!
