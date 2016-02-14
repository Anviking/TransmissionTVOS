cryptopp-5.6.2-ios
==================

Crypto++ 5.6.2 (revision 541) built for ARMv7, ARMv7s, ARM64 (devices) and x86_64, i386 (simulators). The libraries were built using the iOS 7.0 SDK and LLVM libc++ runtime library (not the GNU libstdc++ runtime). The ZIP includes one common set of headers and one fat libcryptopp.a with the five architectures.

If you only want to include and link to Crypto++, then only download cryptopp-5.6.2-ios-7.0.zip. It has everything you need for an Xcode or command line project. Unzip the ZIP archive and place it in a convenient location. Use `unzip -a` to ensure CRLF are handled properly. `/usr/local/cryptopp-ios/` is a good location since it is world readable and write protected.

Note: while the Crypto++ library is mutli-arch, Xcode cannot currently create iOS 6 mutli-arch apps when the app contains both 32-bit and 64-bit components. For example, ARMv7 is 32-bit and ARM64 is 64-bit, so Xcode will not be able to create the fat binary. This is an Apple/Xcode limitation, and Apple claims it will be fixed soon. For details, see  http://lists.apple.com/archives/xcode-users/2013/Oct/msg00074.html.

The four images included in this collection show you how to configure an Xcode project using the files in the ZIP archive. The images are provided since you probably have a good idea of what you are doing. If you need detailed help, see the wiki page below.

The additional files provided in the set are used to update the standard Crypto++ distribution and build the fat libcryptopp.a. Place them in the same directory as Crypto++ source files (overwriting config.h and GNUmakefile as necessary), and then run `./build-for-ios.sh`. If you don't care about building libcryptopp.a yourself, then ignore the additional files. 

See http://www.cryptopp.com/wiki/iOS_(Command_Line) for details on how the environment was set, how the library was built and how to use the library in an Xcode project. If you have questions, then ask on the Crypto++ Users group at https://groups.google.com/forum/#!forum/cryptopp-users.
