//
//  CGIApplication.m
//  CGIKit.E
//
//  Created by Maxthon Chan on 13-6-1.
//
//

#import "CGIApplication.h"
#import "CGIHTTPRequest.h"
#import "CGIHTTPResponse.h"
#import "CGICommon_Private.h"

CGIConstantString(CGIApplicationException, @"info.maxchan.cgikit.exception");

id CGIApp = nil;

int CGIApplicationMain(int argc, const char **argv, const char *delegateClass, const char *applicationClass)
{
    @autoreleasepool
    {
        id delegate = [[objc_getClass(delegateClass) alloc] init];
        Class principalClass = objc_getClass(applicationClass);
        
        if (!principalClass)
            principalClass = [[NSBundle mainBundle] principalClass];
        if (!principalClass || ![principalClass isSubclassOfClass:[CGIApplication class]])
        {
            principalClass = [CGIApplication class];
        }
        
        if (!delegate)
        {
            [NSException raise:CGIApplicationException format:@"No delegate found."];
        }
        
        CGIApplication *app = [principalClass application];
        app.delegate = delegate;
        
        [app run];
    }
    
    exit(0);
}

@implementation CGIApplication

+ (instancetype)application
{
    if (!CGIApp)
        CGIApp = [[self alloc] init];
    return CGIApp;
}

- (void)run
{
    NSProcessInfo *proc = [NSProcessInfo processInfo];
    NSDictionary *env = [proc environment];
    
    [self applicationDidStart];
    
    NSFileHandle *_stdin = [NSFileHandle fileHandleWithStandardInput];
    
    NSInteger length = [env[@"CONTENT_LENGTH"] integerValue];
    
    NSData *requestData = (length) ? [_stdin readDataOfLength:length] : [NSData data];
    [self applicationDidReceiveRequestData:requestData];
    
    NSDictionary *response = nil;
    NSData *responseData = [self dataFromProcessingHTTPRequest:env requestData:requestData withResponse:&response];
    
    if (!response || !responseData)
    {
        [NSException raise:CGIApplicationException format:@"No response found."];
    }
    
    [self applicationWillWriteResponseHeader:response];
    for (NSString *key in response)
    {
        id value = response[key];
        if ([value isKindOfClass:[NSArray class]])
        {
            for (NSString *item in value)
            {
                printf("%s: %s\n", CGICSTR(key), CGICSTR(item));
            }
        }
        else
        {
            printf("%s: %s\n", CGICSTR(key), CGICSTR(value));
        }
    }
    putchar('\n');
    fflush(stdout);
    
    [self applicationWillWriteResponseData:responseData];
    NSFileHandle *_stdout = [NSFileHandle fileHandleWithStandardOutput];
    [_stdout writeData:responseData];
    
    exit(0);
}

- (void)applicationDidStart
{
    if ([self.delegate respondsToSelector:@selector(applicationDidStart:)])
        [self.delegate applicationDidStart:self];
}

- (void)applicationDidReceiveRequestData:(NSData *)data
{
    if ([self.delegate respondsToSelector:@selector(application:didReceiveRequestData:)])
        [self.delegate application:self didReceiveRequestData:data];
}

- (void)applicationWillWriteResponseData:(NSData *)data
{
    if ([self.delegate respondsToSelector:@selector(application:willWriteResponseData:)])
        [self.delegate application:self willWriteResponseData:data];
}

- (void)applicationWillWriteResponseHeader:(NSDictionary *)response
{
    if ([self.delegate respondsToSelector:@selector(application:willWriteResponseHeader:)])
        [self.delegate application:self willWriteResponseHeader:response];
}

- (NSData *)dataFromProcessingHTTPRequest:(NSDictionary *)request requestData:(NSData *)data withResponse:(NSDictionary *__autoreleasing *)response
{
    if ([self.delegate respondsToSelector:@selector(application:dataFromProcessingHTTPRequest:requestData:withResponse:)])
    {
        return [self.delegate application:self
            dataFromProcessingHTTPRequest:request
                              requestData:data
                             withResponse:response];
    }
    else
    {
        CGIHTTPRequest *_request = [[CGIHTTPRequest alloc] initWithRequestFields:request
                                                                           data:data];
        CGIHTTPResponse *_response = nil;
        
        @try
        {
            _response = [self responseFromProcessingRequest:_request];
        }
        @catch (NSException *exception)
        {
            _response = [CGIHTTPResponse responseWithException:exception];
        }
        
        if (response)
            *response = [NSDictionary dictionaryWithDictionary:_response.responseHeaders];
        
        return _response.responseData;
    }
}

- (CGIHTTPResponse *)responseFromProcessingRequest:(CGIHTTPRequest *)request
{
    return [self.delegate application:self responseFromProcessingRequest:request];
}

@end
