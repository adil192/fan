#!/bin/bash

# Convert logo svg to png
SVG_PATH="assets/icon/logo.svg"
PNG_PATH="assets/icon/logo.png"
rsvg-convert -o $PNG_PATH $SVG_PATH

dart run icons_launcher:create
