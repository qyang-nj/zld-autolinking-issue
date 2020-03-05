#!/bin/bash

SDK=iphonesimulator # macosx
SDK_PATH=$(xcrun --show-sdk-path --sdk iphonesimulator)

# Targeting ios12 or lower will end up linking with libSwiftCompatibility50 and libSwiftCompatibilityDynamicReplacements.
TARGET="x86_64-apple-ios12.0-simulator"

rm -rf Build
mkdir -p Build

# Build foo.o
xcrun swiftc \
    -frontend \
    -c \
    -sdk $SDK_PATH \
    -target $TARGET \
    -o Build/foo.o \
    -primary-file foo.swift \
    main.swift

# Generate foo.a
xcrun libtool -static -o Build/foo.a Build/foo.o

# Build main.o
xcrun swiftc -c -o Build/main.o -sdk $SDK_PATH -target x86_64-apple-ios13.0-simulator main.swift

# Build main excutable
xcrun clang Build/main.o Build/foo.a\
    -o Build/main \
    -all_load \
    -L "$SDK_PATH/usr/lib/swift" \
    -L "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/$SDK" \
    -target $TARGET \
    -isysroot $SDK_PATH \
    -fuse-ld=$(which zld)
# Comment out the above line to swtich back to default ld.
# To work around the issue, we need to append "-lswiftCompatibility50 -lswiftCompatibilityDynamicReplacements"

