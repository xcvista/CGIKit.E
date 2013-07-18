//
//  CGIMethodApplication.m
//  CGIKit.E
//
//  Created by Maxthon Chan on 7/17/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "CGIMethodApplication.h"
#import "CGIHTTPRequest.h"
#import "CGIHTTPResponse.h"

const char *CGIMethodApplicationName = "CGIMethodApplication";

@interface CGIMethodApplication ()

@property NSMutableDictionary *methods;

@end

@implementation CGIMethodApplication

@dynamic delegate;

- (id)init
{
    self = [super init];
    if (self) {
        self.methods = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BOOL)addHandler:(Class)handler
{
    if ([handler conformsToProtocol:@protocol(CGIMethod)])
    {
        NSString *name = [handler methodName];
        if (name)
        {
            self.methods[name] = handler;
            return YES;
        }
    }
    return NO;
}

- (void)removeHandler:(Class)handler
{
    if ([handler conformsToProtocol:@protocol(CGIMethod)])
    {
        NSString *name = [handler methodName];
        if (name)
        {
            [self.methods removeObjectForKey:name];
        }
    }
}

- (NSArray *)allHandlers
{
    return [self.methods allValues];
}

- (NSString *)methodFromRequest:(CGIHTTPRequest *)request
{
    if ([self.delegate respondsToSelector:@selector(application:methodFromRequest:)])
    {
        return [self.delegate application:self methodFromRequest:request];
    }
    else
    {
        return request.requestFields[@"QUERY_STRING"];
    }
}

- (CGIHTTPResponse *)responseFromProcessingRequest:(CGIHTTPRequest *)request
{
    CGIHTTPResponse *response = nil;
    
    if ([self.delegate respondsToSelector:@selector(application:responseFromProcessingRequest:)])
    {
        response = [self.delegate application:self responseFromProcessingRequest:request];
    }
    
    NSString *method = nil;
    
    if (!response)
    {
        method = [self methodFromRequest:request];
        if (!method)
            return [CGIHTTPResponse responseWithError:[NSError errorWithDomain:NSPOSIXErrorDomain
                                                                          code:ENOSYS
                                                                      userInfo:nil]];
        
        Class class = self.methods[method];
        id<CGIMethod> object = [[class alloc] initWithRequest:request];
        response = [object responseFromProcessingObject];
    }
    
    if (!response)
    {
        [self doesNotRecognizeSelector:NSSelectorFromString(method)];
    }
    
    return response;
}

@end
