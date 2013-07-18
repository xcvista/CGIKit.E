//
//  CGIMethodApplication.h
//  CGIKit.E
//
//  Created by Maxthon Chan on 7/17/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#include <CGIKit/CGICommon.h>

CGIExtern const char *CGIMethodApplicationName;

#ifdef __OBJC__

#import <CGIKit/CGIFastApplication.h>

@class CGIMethodApplication, CGIHTTPRequest, CGIHTTPResponse;

@protocol CGIMethodApplicationDelegate <CGIApplicationDelegate>

@optional
- (NSString *)application:(CGIMethodApplication *)application methodFromRequest:(CGIHTTPRequest *)request;

@end

@protocol CGIMethod <NSObject>

+ (NSString *)methodName;

- (id)initWithRequest:(CGIHTTPRequest *)request;
- (CGIHTTPResponse *)responseFromProcessingObject;

@end

@interface CGIMethodApplication : CGIFastApplication

@property id<CGIMethodApplicationDelegate> delegate;

- (BOOL)addHandler:(Class)handler;
- (void)removeHandler:(Class)handler;
- (NSArray *)allHandlers;

- (NSString *)methodFromRequest:(CGIHTTPRequest *)request;

@end

#endif
