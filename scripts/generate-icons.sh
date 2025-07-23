#!/bin/bash

# Convert all svg to png
for svg_file in assets/icon/*.svg; do
  png_file="${svg_file%.svg}.png"
  rsvg-convert -o "$png_file" "$svg_file"
done

dart run icons_launcher:create
