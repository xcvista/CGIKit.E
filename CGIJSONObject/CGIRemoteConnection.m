//
//  CGIRemoteConnection.m
//  CGIJSONKit
//
//  Created by Maxthon Chan on 13-5-22.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "CGIRemoteConnection.h"
#if !TARGET_OS_IPHONE
#import <CGIKit/CGIKit.h>
#else
#import "CGICommon.h"
#endif

CGIRemoteConnection *__defaultRemoteConnection;

NSString *const CGIHTTPErrorDomain __attribute__((weak)) = @"info.maxchan.error.http";
NSString *const CGIRemoteConnectionServerRootKey = @"CGIRemoteConnectionServerRoot";

@implementation CGIRemoteConnection

+ (instancetype)defaultRemoteConnection
{
    @synchronized (__defaultRemoteConnection)
    {
        if (!__defaultRemoteConnection)
            __defaultRemoteConnection = [[self alloc] init];
        return __defaultRemoteConnection;
    }
}

- (void)makeDefaultServerRoot
{
    @synchronized (__defaultRemoteConnection)
    {
        __defaultRemoteConnection = self;
    }
}

- (id)init
{
    return [self initWithServerRoot:nil];
}

- (id)initWithServerRoot:(NSString *)serverRoot
{
    if (self = [super init])
    {
        if (!serverRoot)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *root = [defaults objectForKey:CGIRemoteConnectionServerRootKey];
            serverRoot = [NSURL URLWithString:root];
        }
        self.serverRoot = serverRoot;
        self.onError = ^(NSError* err, NSURLRequest* req){};
    }
    return self;
}

- (NSMutableURLRequest *)URLRequestForMethod:(NSString *)method
{
    if (!self.serverRoot)
    {
        [NSException raise:@"CGINotReadyException" format:@"No server root is provided."];
    }
    
    NSURL *methodURL = [NSURL URLWithString:CGISTR(self.serverRoot, method)];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:methodURL];
    [request setValue:[self userAgent]
   forHTTPHeaderField:@"User-Agent"];
    
    return request;
}

- (NSData *)dataWithData:(NSData *)data
              fromMethod:(NSString *)method
                   error:(NSError *__autoreleasing *)error
{
    NSMutableURLRequest *request = [self URLRequestForMethod:method];
    if (self.timeoutSeconds) {
        request.timeoutInterval = [self.timeoutSeconds doubleValue];
    }
    if ([data length])
    {
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:data];
        
        [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    }
    
    NSError *err = nil;
    NSHTTPURLResponse *response = nil;
    
#if defined(GNUSTEP)
    NSLog(@"Outgoing: %@ to %@, Data: [%@], info %@",
          [request HTTPMethod],
          [[request URL] absoluteString],
          [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding],
          [request allHTTPHeaderFields]
          );
#endif
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&err];
    
#if defined(GNUSTEP)
    NSLog(@"Incoming: status %ld, Data: [%@], info: %@",
          [response statusCode],
          [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding],
          [response allHeaderFields]
          );
#endif
    
    if (![responseData length])
    {
        CGIAssignPointer(error, err);
        self.onError(err, request);
        return nil;
    }
    
    if ([response statusCode] >= 400)
    {
        NSLog(@"HTTP status %3d from method %@", (int32_t)[response statusCode], method);
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey:
                                       [NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]],
                                   };
        err = [NSError errorWithDomain:CGIHTTPErrorDomain
                                  code:[response statusCode]
                              userInfo:userInfo];
        CGIAssignPointer(error, err);
        self.onError(err, request);
        return nil;
    }
    return responseData;
}

- (NSString *)userAgent
{
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    NSDictionary *OSNames = @{
                              @(NSWindowsNTOperatingSystem):    @"Windows NT",
                              @(NSWindows95OperatingSystem):    @"Windows 9x",
                              @(NSSolarisOperatingSystem):      @"Solaris",
                              @(NSHPUXOperatingSystem):         @"HP UX",
                              @(NSMACHOperatingSystem):         @"OS X",
                              @(NSSunOSOperatingSystem):        @"Sun OS",
                              @(NSOSF1OperatingSystem):         @"OSF 1",
#if defined(GNUSTEP)                                            // GNUstep constants.
                              @(GSGNULinuxOperatingSystem):     @"GNU/Linux",
                              @(GSBSDOperatingSystem):          @"BSD",
                              @(GSBeOperatingSystem):           @"BeOS",
                              @(GSCygwinOperatingSystem):       @"Windows/Cygwin"
#endif
                              };
    if (self.customUserAgent) {
        return self.customUserAgent;
    } else {
        return CGISTR(@"CGIJSONRemoteObject/4.1; CGIKit/2.0; %@; %@",
               OSNames[@([processInfo operatingSystem])],
               [processInfo operatingSystemVersionString]
               );
    }
}


@end
