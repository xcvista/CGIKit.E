include $(GNUSTEP_MAKEFILES)/common.make

TOOL_NAME := CGIHello

CGIHello_OBJC_FILES := CGITestApplicationDelegate.m
CGIHello_C_FILES := main.c
CGIHello_VERSION := 5.0
CGIHello_CFLAGS := -fPIC -pedantic -fblocks
CGIHello_OBJC_FLAGS := -fobjc-arc -Xclang -fobjc-default-synthesized-properties
CGIHello_LDFLAGS := -lCGIKit

-include GNUmakefile.preamble

include $(GNUSTEP_MAKEFILES)/tool.make

-include GNUmakefile.postamble
