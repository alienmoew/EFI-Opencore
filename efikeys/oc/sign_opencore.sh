#!/bin/bash
# Copyright (c) 2021 by profzei
# Licensed under the terms of the GPL v3

LINK=https://github.com/acidanthera/OpenCorePkg/releases/download/0.9.9/OpenCore-0.9.9-RELEASE.zip
# https://github.com/acidanthera/OpenCorePkg/releases/download/0.9.9/OpenCore-0.9.9-RELEASE.zip
VERSION=0.9.9
# 0.9.9

# Download and unzip OpenCore
wget $LINK
unzip "OpenCore-${VERSION}-RELEASE.zip" "X64/*" -d "./Downloaded"
rm "OpenCore-${VERSION}-RELEASE.zip"

# Download HfsPlus
wget https://github.com/acidanthera/OcBinaryData/raw/master/Drivers/HfsPlus.efi -O ./Downloaded/X64/EFI/OC/Drivers/HfsPlus.efi

if [ -f "./ISK.key" ]; then
    echo "ISK.key was decrypted successfully"
fi

if [ -f "./ISK.pem" ]; then
    echo "ISK.pem was decrypted successfully"
fi

# Sign drivers by recursively looking for the .efi files in ./Downloaded directory
# Don't sign files that start with the dot, as this is metadata files
# Andrew Blitss's contribution
find ./Downloaded/X64/EFI/**/* -type f -name "*.efi" ! -name '.*' | cut -c 3- | xargs -I{} bash -c 'sbsign --key ISK.key --cert ISK.pem --output $(mkdir -p $(dirname "./Signed/{}") | echo "./Signed/{}") ./{}'

# Clean
rm -rf Downloaded
echo "Cleaned..."