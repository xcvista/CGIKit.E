//
//  CGIRemoteConnection.h
//  CGIJSONKit
//
//  Created by Maxthon Chan on 13-5-22.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

extern NSString *const CGIHTTPErrorDomain __attribute__((weak));
extern NSString *const CGIRemoteConnectionServerRootKey; // = @"CGIRemoteConnectionServerRoot";

@interface CGIRemoteConnection : NSObject

@property NSURL *serverRoot;

+ (instancetype)defaultRemoteConnection;

- (id)initWithServerRoot:(NSURL *)serverRoot;

- (void)makeDefaultServerRoot;

- (NSData *)dataWithData:(NSData *)data
              fromMethod:(NSString *)method
                   error:(NSError *__autoreleasing *)error;

- (NSString *)userAgent;

- (NSMutableURLRequest *)URLRequestForMethod:(NSString *)method;

@end
