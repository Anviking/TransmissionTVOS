#! /bin/sh

# Update the config.h and GNUmakefile before running this script.
# The updated config.h and GNUmakefile are available with this Github project.
# Place setenv.ios.sh and build-for-ios.sh next to the makefile.
# Verify the install path used at Step 8 below.
# Run ./build-for-ios.sh

# First, build ARMv7
echo "****************************************"
. ./setenv-ios.sh armv7
make clean
make static
mkdir armv7
\cp libcryptopp.a armv7/libcryptopp.a

# Second, build ARMv7s
echo "****************************************"
. ./setenv-ios.sh armv7s
make clean
make static
mkdir armv7s
\cp libcryptopp.a armv7s/libcryptopp.a

# Third, build ARM64
echo "****************************************"
. ./setenv-ios.sh arm64
make clean
make static
mkdir arm64
\cp libcryptopp.a arm64/libcryptopp.a

# Fourth, build i386 (32-bit simulators)
echo "****************************************"
. ./setenv-ios.sh i386
make clean
make static
mkdir i386
\cp libcryptopp.a i386/libcryptopp.a

# Fifth, build x86_64 (64-bit simulators)
echo "****************************************"
. ./setenv-ios.sh x86_64
make clean
make static
mkdir x86_64
\cp libcryptopp.a x86_64/libcryptopp.a

# Sixth, create the fat library
echo "****************************************"
make clean
lipo -create armv7/libcryptopp.a armv7s/libcryptopp.a arm64/libcryptopp.a i386/libcryptopp.a x86_64/libcryptopp.a -output ./libcryptopp.a

# Seventh, verify the four architectures are present
echo "****************************************"
xcrun -sdk iphoneos lipo -info libcryptopp.a

# Eighth, remove unneeded artifacts
echo "****************************************"
rm *.so *.exe *.dylib

# Ninth, install the library
echo "****************************************"
read -p "Press [ENTER] to install, or [CTRL]+C to quit"

sudo make install PREFIX=/usr/local/cryptopp-ios
