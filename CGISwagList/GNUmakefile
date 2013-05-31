include $(GNUSTEP_MAKEFILES)/common.make

TOOL_NAME := CGISwag

CGIHello_OBJC_FILES := CGISwagDelegate.m
CGIHello_C_FILES := main.c
CGIHello_VERSION := 5.0
CGIHello_CFLAGS := -fPIC -pedantic -fblocks
CGIHello_OBJCFLAGS := -fobjc-runtime=gnustep-1.7 -fobjc-nonfragile-abi -fobjc-arc -Xclang -fobjc-default-synthesize-properties
CGIHello_LDFLAGS := -lCGIKit

-include GNUmakefile.preamble

include $(GNUSTEP_MAKEFILES)/tool.make

-include GNUmakefile.postamble
