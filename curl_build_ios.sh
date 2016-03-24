#!/bin/sh
# mrnuku, 2016

export IPHONEOS_DEPLOYMENT_TARGET="7.0"

export CC="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang"
export CPPFLAGS="-fembed-bitcode -D__IPHONE_OS_VERSION_MIN_REQUIRED=${IPHONEOS_DEPLOYMENT_TARGET%%.*}0000"

# DEVICE
# armv7, armv7s, arm64 (aarch64-apple-darwin)

export CFLAGS="-arch armv7 -pipe -Os -fembed-bitcode -gdwarf-2 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk -I.. -DHAVE_SOCKET -DHAVE_FCNTL_O_NONBLOCK"
export LDFLAGS="-arch armv7 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"
./configure --disable-shared --enable-static --host="armv7-apple-darwin" --prefix=/usr-iphone/local --with-darwinssl --enable-threaded-resolver
make -j `sysctl -n hw.logicalcpu_max`
cp lib/.libs/libcurl.a ../libcurl-armv7.a
cp include/curl/curlbuild.h ../curlbuild-armv7.h
make clean

export CFLAGS="-arch armv7s -pipe -Os -fembed-bitcode -gdwarf-2 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk -I.. -DHAVE_SOCKET -DHAVE_FCNTL_O_NONBLOCK"
export LDFLAGS="-arch armv7s -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"
./configure --disable-shared --enable-static --host="armv7s-apple-darwin" --prefix=/usr-iphone/local --with-darwinssl --enable-threaded-resolver
make -j `sysctl -n hw.logicalcpu_max`
cp lib/.libs/libcurl.a ../libcurl-armv7s.a
cp include/curl/curlbuild.h ../curlbuild-armv7s.h
make clean

export CFLAGS="-arch arm64 -pipe -Os -fembed-bitcode -gdwarf-2 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk -I.. -DHAVE_SOCKET -DHAVE_FCNTL_O_NONBLOCK"
export LDFLAGS="-arch arm64 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"
./configure --disable-shared --enable-static --host="aarch64-apple-darwin" --prefix=/usr-iphone/local --with-darwinssl --enable-threaded-resolver
make -j `sysctl -n hw.logicalcpu_max`
cp lib/.libs/libcurl.a ../libcurl-arm64.a
cp include/curl/curlbuild.h ../curlbuild-arm64.h
make clean

# SIMULATOR
# i386, x86_64

export CFLAGS="-arch i386 -pipe -Os -fembed-bitcode -gdwarf-2 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk -I.. -DHAVE_SOCKET -DHAVE_FCNTL_O_NONBLOCK"
export LDFLAGS="-arch i386 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk"
./configure --disable-shared --enable-static --host="i386-apple-darwin" --prefix=/usr-iphone/local --with-darwinssl --enable-threaded-resolver
make -j `sysctl -n hw.logicalcpu_max`
cp lib/.libs/libcurl.a ../libcurl-i386.a
cp include/curl/curlbuild.h ../curlbuild-i386.h
make clean

export CFLAGS="-arch x86_64 -pipe -Os -fembed-bitcode -gdwarf-2 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk -I.. -DHAVE_SOCKET -DHAVE_FCNTL_O_NONBLOCK"
export LDFLAGS="-arch x86_64 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk"
./configure --disable-shared --enable-static --host="x86_64-apple-darwin" --prefix=/usr-iphone/local --with-darwinssl --enable-threaded-resolver
make -j `sysctl -n hw.logicalcpu_max`
cp lib/.libs/libcurl.a ../libcurl-x86_64.a
cp include/curl/curlbuild.h ../curlbuild-x86_64.h
make clean

# MAKE UNIVERSAL STATIC LIB

lipo -create -output ../libcurl-ios.a ../libcurl-*
