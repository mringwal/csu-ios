# Fix newer Xcode to build armv7 target for iOS Deployment Target 2.0+

When setting the iOS Deployment Target to be lower than 6.0, Xcode's gcc will fail with the error

	ld: library not found for -lcrt1.3.1.o

It is possible to copy this file and others from an older Xcode version to get it working, but that's not always an option.

This project provides a minimal Makefile to build and install the missing files in the current Xcode installation. It uses Csu-85 for the build.

## How to use
	
	sudo make install

## References

Csu-85 from https://opensource.apple.com/tarballs/Csu/

