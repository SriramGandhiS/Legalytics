#!/bin/bash
# Install Flutter SDK for Vercel builds

echo "Installing Flutter..."
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

echo "Flutter version:"
flutter doctor -v

echo "Building web project..."
flutter clean
flutter build web --release

echo "Build accomplished!"
