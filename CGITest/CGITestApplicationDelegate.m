//
//  CGITestApplicationDelegate.m
//  CGIKit.E
//
//  Created by Maxthon Chan on 13-6-1.
//
//

#import "CGITestApplicationDelegate.h"

@implementation CGITestApplicationDelegate

- (NSData *)application:(CGIApplication *)application dataFromProcessingHTTPRequest:(NSDictionary *)request requestData:(NSData *)data withResponse:(NSDictionary *__autoreleasing *)response
{
    NSDictionary *resp = @{@"Content-Type": @"text/plain"};
    *response = resp;
    return [@"hello, world" dataUsingEncoding:NSUTF8StringEncoding];
}

@end
