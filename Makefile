SYMROOT = .
XCODE_PATH=$(shell xcode-select -p)
SDK_ROOT=$(XCODE_PATH)/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk
CSU_VERSION=85
VPATH=Csu-$(CSU_VERSION)
CC=$(XCODE_PATH)/usr/bin/gcc
ARCH_CFLAGS= -arch armv7 -arch armv7s -arch arm64 -isysroot $(SDK_ROOT)
OS_MIN_V2= -miphoneos-version-min=2.0
OS_MIN_V3= -miphoneos-version-min=2.0

INTERMEDIATE_FILES = crt1.v2.o crt1.v3.o gcrt1.o dylib1.v2.o bundle1.v1.o lazydylib1.o

all: $(INTERMEDIATE_FILES)

$(SYMROOT)/crt1.v1.o: start.s crt.c dyld_glue.s 
	$(CC) -r $(ARCH_CFLAGS) -Os $(OS_MIN_V1) -mdynamic-no-pic -nostdlib -keep_private_externs $^ -o $@  -DCRT -DOLD_LIBSYSTEM_SUPPORT

$(SYMROOT)/crt1.v2.o: start.s crt.c dyld_glue.s 
	$(CC) -r $(ARCH_CFLAGS) -Os $(OS_MIN_V2) -nostdlib -keep_private_externs $^ -o $@  -DCRT

$(SYMROOT)/crt1.v3.o: start.s crt.c
	$(CC) -r $(ARCH_CFLAGS) -Os $(OS_MIN_V3) -nostdlib -keep_private_externs $^ -o $@  -DADD_PROGRAM_VARS 


$(SYMROOT)/gcrt1.o: start.s crt.c dyld_glue.s 
	$(CC) -r $(ARCH_CFLAGS) -Os $(OS_MIN_V1) -nostdlib -keep_private_externs $^ -o $@  -DGCRT  -DOLD_LIBSYSTEM_SUPPORT


$(SYMROOT)/dylib1.v1.o: dyld_glue.s icplusplus.c
	$(CC) -r $(ARCH_CFLAGS) -Os $(OS_MIN_V1) -nostdlib -keep_private_externs $^ -o $@  -DCFM_GLUE

$(SYMROOT)/dylib1.v2.o: dyld_glue.s
	$(CC) -r $(ARCH_CFLAGS) -Os $(OS_MIN_V2) -nostdlib -keep_private_externs $^ -o $@  -DCFM_GLUE
		

$(SYMROOT)/bundle1.v1.o: dyld_glue.s
	$(CC) -r $(ARCH_CFLAGS) -Os $(OS_MIN_V1) -nostdlib -keep_private_externs $^ -o $@ 


$(SYMROOT)/lazydylib1.o: lazy_dylib_helper.s lazy_dylib_loader.c 
	$(CC) -r $(ARCH_CFLAGS) -Os -nostdlib -keep_private_externs $^ -o $@ 


clean:
	rm -f $(INTERMEDIATE_FILES)

install: all
	@echo Installing libs in iPhone SDK
	cp crt1.v2.o	$(SDK_ROOT)/usr/lib/crt1.o
	cp dylib1.v2.o	$(SDK_ROOT)/usr/lib/dylib1.o
	cp bundle1.v1.o	$(SDK_ROOT)/usr/lib/bundle1.o
	cp lazydylib1.o	$(SDK_ROOT)/usr/lib/lazydylib1.o
	cp gcrt1.o		$(SDK_ROOT)/usr/lib/gcrt1.o
