# Makefile for FusionKit on Linux using GNUstep.

ifeq ($(shell uname -s),Darwin)

$(error Use Xcode to build on OS X.)

endif

ifeq ($(GNUSTEP_MAKEFILES),)
 GNUSTEP_MAKEFILES := $(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
  ifeq ($(GNUSTEP_MAKEFILES),)
    $(warning )
    $(warning Unable to obtain GNUSTEP_MAKEFILES setting from gnustep-config!)
    $(warning Perhaps gnustep-make is not properly installed,)
    $(warning so gnustep-config is not in your PATH.)
    $(warning )
    $(warning Your PATH is currently $(PATH))
    $(warning )
  endif
endif

# Common command line args.
include $(GNUSTEP_MAKEFILES)/common.make

FRAMEWORK_NAME += CGIJSONObject

# FusionKit
CGIJSONObject_OBJC_FILES += CGIPersistantObject.m
CGIJSONObject_HEADER_FILES += CGIPersistantObject.h CGIJSONObject.h CGICommon.h
CGIJSONObject_HEADER_FILES_INSTALL_DIR += CGIJSONObject
CGIJSONObject_LANGUAGES += en
CGIJSONObject_CURRENT_VERSION_NAME := D
CGIJSONObject_VERSION := 4.1
CGIJSONObject_LDFLAGS :=

# Option include to set any additional variables
-include GNUmakefile.preamble

# Include in the rules for making libraries
include $(GNUSTEP_MAKEFILES)/framework.make

# Option include to define any additional rules
-include GNUmakefile.postamble

