//
//  CGIApplication.m
//  CGIKit.E
//
//  Created by Maxthon Chan on 13-6-1.
//
//

#import "CGIApplication.h"
#import "CGICommon_Private.h"
#import "NSObject+CGISafeInvoke.h"

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
    id delegate = self.delegate;
    NSProcessInfo *proc = [NSProcessInfo processInfo];
    NSDictionary *env = [proc environment];
    
    [delegate safelyPerformSelector:@selector(applicationDidStart:), self];
    
    NSFileHandle *_stdin = [NSFileHandle fileHandleWithStandardInput];
    
    NSInteger length = [env[@"CONTENT_LENGTH"] integerValue];
    
    NSData *requestData = (length) ? [_stdin readDataOfLength:length] : [NSData data];
    [delegate safelyPerformSelector:@selector(application:didReceiveRequestData:), self, requestData];
    
    NSDictionary *response = nil;
    NSData *responseData = [delegate application:self
                   dataFromProcessingHTTPRequest:env
                                     requestData:requestData
                                    withResponse:&response];
    
    if (!response || !responseData)
    {
        [NSException raise:CGIApplicationException format:@"No response found."];
    }
    
    [delegate safelyPerformSelector:@selector(application:willWriteResponseHeader:), self, response];
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
    
    [delegate safelyPerformSelector:@selector(application:willWriteResponseData:), self, responseData];
    NSFileHandle *_stdout = [NSFileHandle fileHandleWithStandardOutput];
    [_stdout writeData:responseData];
    
    exit(0);
}

@end
