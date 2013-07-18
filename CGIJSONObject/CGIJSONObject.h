//
//  CGIJSONObject.h
//  CGIJSONKit
//
//  Created by Maxthon Chan on 13-5-21.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#ifndef CGIJSONKit_CGIJSONObject_h
#define CGIJSONKit_CGIJSONObject_h

#import <Foundation/Foundation.h>

#if !TARGET_OS_IPHONE
#import <CGIKit/CGIKit.h>
#endif

#import <CGIJSONObject/CGIPersistantObject.h>
#import <CGIJSONObject/CGIRemoteConnection.h>
#import <CGIJSONObject/CGIRemoteObject.h>
#if !TARGET_OS_IPHONE
#import <CGIJSONObject/CGIServerObject.h>
#endif
#import <CGIJSONObject/NSData+DCPersistance.h>
#import <CGIJSONObject/NSDate+DCPersistance.h>
#import <CGIJSONObject/NSURL+DCPersistance.h>

#endif
