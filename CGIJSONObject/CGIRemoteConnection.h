//
//  CGIRemoteConnection.h
//  CGIJSONKit
//
//  Created by Maxthon Chan on 13-5-22.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const CGIHTTPErrorDomain __attribute__((weak));
extern NSString *const CGIRemoteConnectionServerRootKey; // = @"CGIRemoteConnectionServerRoot";

@interface CGIRemoteConnection : NSObject

@property NSString *serverRoot;

+ (instancetype)defaultRemoteConnection;

- (id)initWithServerRoot:(NSString *)serverRoot;

- (void)makeDefaultServerRoot;

- (NSData *)dataWithData:(NSData *)data
              fromMethod:(NSString *)method
                   error:(NSError *__autoreleasing *)error;

- (NSString *)userAgent;

- (NSMutableURLRequest *)URLRequestForMethod:(NSString *)method;

@end