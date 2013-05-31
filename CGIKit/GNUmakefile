include $(GNUSTEP_MAKEFILES)/common.make

FRAMEWORK_NAME := CGIKit

CGIKit_HEADER_FILES := CGIKit.h CGICommon.h CGIApplication.h
CGIKit_OBJC_FILES := NSObject+CGISafeInvoke.m CGIApplication.m
CGIKit_VERSION := 5.0
CGIKit_CURRENT_VERSION_NAME := E
CGIKit_CFLAGS := -fPIC -pedantic -fblocks
CGIKit_OBJC_FLAGS := -fobjc-arc -Xclang -fobjc-default-synthesized-properties

-include GNUmakefile.preamble

include $(GNUSTEP_MAKEFILES)/framework.make

-include GNUmakefile.postamble
