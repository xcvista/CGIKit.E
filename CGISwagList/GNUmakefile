include $(GNUSTEP_MAKEFILES)/common.make

TOOL_NAME := CGISwag

CGISwag_OBJC_FILES := CGISwagDelegate.m
CGISwag_C_FILES := main.c
CGISwag_VERSION := 5.0
CGISwag_CFLAGS := -fPIC -pedantic -fblocks
CGISwag_OBJCFLAGS := -fobjc-runtime=gnustep-1.7 -fobjc-nonfragile-abi -fobjc-arc -Xclang -fobjc-default-synthesize-properties
CGISwag_LDFLAGS := -lCGIKit

-include GNUmakefile.preamble

include $(GNUSTEP_MAKEFILES)/tool.make

-include GNUmakefile.postamble
