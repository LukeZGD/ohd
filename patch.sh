#!/bin/bash
# This is basically just a copy of https://gist.github.com/jakeajames/b44d8db345769a7149e97f5e155b3d46
# but for Home Depot jailbreak, this allows jailbreaking 8.x A5(X)

cd "$(dirname "$0")"

if [ $# != 1 ]; then
    echo "Usage: $0 /path/to/input_ipa"
    exit 1
fi

if ! [ -f $1 ]; then
    echo "'$1' does not exist"
    exit 1
fi

hash="190fab61a76f56397ff70c5c9bcf2a5171c56641"
if [ $(uname) == "Darwin" ]; then
    hash_local="$(shasum -a 1 $1 | awk '{print $1}')"
else
    hash_local="$(sha1sum $1 | awk '{print $1}')"
fi
if [ $hash_local != "$hash" ]; then
    echo "'$1' SHA1sum mismatch. Expected $hash, got $hash_local"
    echo "Your copy of the .ipa may be corrupted or incomplete."
    exit 1
fi

output="HomeDepot-patched.ipa"
if [ -f $output ]; then
    echo "'$output' already exists"
    exit 1
fi

echo "Setting up environment"
mkdir /tmp/unpacked_homedepot
if [ $? != 0 ]; then
    echo "mkdir create temporary directory"
    exit 1
fi

echo "Extracting"
unzip $1 -d /tmp/unpacked_homedepot > /dev/null
if [ $? != 0 ]; then
    echo "can't unzip '$1'"
    rm -rf /tmp/unpacked_homedepot
    exit 1
fi

echo "Patching"

# replaces: wall.supplies/offsets
# with:     lukezgd.github.io/ohd
printf '\x6C\x75\x6B\x65\x7A\x67\x64\x2E\x67\x69\x74\x68\x75\x62\x2E\x69\x6F\x2F\x6F\x68\x64' | dd of='/tmp/unpacked_homedepot/Payload/Home Depot.app/Home Depot' bs=1 seek=486669 count=21 conv=notrunc
cp Info.plist '/tmp/unpacked_homedepot/Payload/Home Depot.app/Info.plist'

echo "Compressing"

CD=$(pwd)
cd /tmp/unpacked_homedepot

if [[ "$output" = /* ]]; then
    zip -r $output Payload/ > /dev/null
else
    zip -r "$CD/$output" Payload/ > /dev/null
fi

if [ $? != 0 ]; then
    echo "can't zip '$1'"
    rm -rf /tmp/unpacked_homedepot
    cd - > /dev/null
    exit 1
fi

cd - > /dev/null
rm -rf /tmp/unpacked_homedepot
echo "Done. Output is $output"
