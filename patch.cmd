@echo off

echo %1

if "%1" == "" (
    echo Usage: patch.cmd /path/to/input_ipa
    echo Drag the ipa to patch.cmd to produce a patched ipa
    pause >nul
    exit
)

set hash=190fab61a76f56397ff70c5c9bcf2a5171c56641
certutil -hashfile %1 SHA1 > hash
< hash (
    set /p line1=
    set /p hash_local=
)
del hash
if not "%hash_local%" == "%hash%" (
    echo SHA1sum mismatch. Expected %hash%, got %hash_local%
    echo Your copy of the .ipa may be corrupted or incomplete.
    pause >nul
    exit
)

echo Setting up environment
md unpacked_homedepot

echo Extracting
tar -xf %1 -C unpacked_homedepot

echo Patching
del "unpacked_homedepot\Payload\Home Depot.app\Info.plist"
copy Info.plist "unpacked_homedepot\Payload\Home Depot.app\Info.plist"
rem Below you can see a lazy way of patching: using bspatch lol
move "unpacked_homedepot\Payload\Home Depot.app\Home Depot" HomeDepot
bspatch HomeDepot "unpacked_homedepot\Payload\Home Depot.app\Home Depot" HomeDepot.patch
del HomeDepot

echo Compressing
move unpacked_homedepot\Payload Payload
rd /s /q unpacked_homedepot
tar -acf HomeDepot-patched.zip Payload
move HomeDepot-patched.zip HomeDepot-patched.ipa
rd /s /q Payload

echo Done. Output is HomeDepot-patched.ipa
pause >nul
