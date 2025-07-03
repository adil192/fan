#!/bin/bash

if [ ! -f "pubspec.yaml" ]; then
    echo "⚠ This script must be run from the root of the Flutter project."
    exit 2
fi

if [ -d "assets/fan-assets" ] && [ "$(ls -A assets/fan-assets)" ]; then
    echo "✔ Fan assets found."
else
    echo "⚠ Fan assets missing! Cloning from repository..."
    git clone https://github.com/adil192/fan-assets.git assets/fan-assets
    exit $?
fi
