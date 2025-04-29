#!/bin/bash

# Clean the project
flutter clean

# Get dependencies
flutter pub get

# Build for web
flutter build web --release

# The build output will be in the build/web directory 