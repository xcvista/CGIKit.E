include $(GNUSTEP_MAKEFILES)/common.make

FRAMEWORK_NAME := CGIKit

CGIKit_HEADER_FILES := CGIKit.h CGICommon.h CGIApplication.h CGIFastApplication.h CGIHTTPRequest.h CGIHTTPResponse.h
CGIKit_OBJC_FILES := CGIApplication.m CGIFastApplication.m CGIHTTPRequest.m CGIHTTPResponse.m
CGIKit_C_FILES := CGICommon.c
CGIKit_VERSION := 5.0
CGIKit_CURRENT_VERSION_NAME := E
CGIKit_CFLAGS := -fPIC -pedantic -fblocks
CGIKit_OBJCFLAGS := -fobjc-runtime=gnustep-1.7 -fobjc-nonfragile-abi -fobjc-arc -Xclang -fobjc-default-synthesize-properties

-include GNUmakefile.preamble

include $(GNUSTEP_MAKEFILES)/framework.make

-include GNUmakefile.postamble

after-install::
	ldconfig
