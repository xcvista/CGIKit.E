//
//  CGIFastApplication.h
//  CGIKit.E
//
//  Created by Maxthon Chan on 13-6-1.
//
//

#ifndef _CGIKIT_CGIFASTAPPLICATION_H_
#define _CGIKIT_CGIFASTAPPLICATION_H_

#include <CGIKit/CGICommon.h>

CGIExtern const char *CGIFastApplicationName;

#ifdef __OBJC__

#import <CGIKit/CGIApplication.h>

/**
 * Fast CGI application (UNIX socket). Good for web apps.
 */

@interface CGIFastApplication : CGIApplication

@end

#endif // defined(__OBJC__)

#endif // !defined(_CGIKIT_CGIFASTAPPLICATION_H_)