//
//  CGITestApplicationDelegate.m
//  CGIKit.E
//
//  Created by Maxthon Chan on 13-6-1.
//
//

#import "CGITestApplicationDelegate.h"

@interface CGITestApplicationDelegate ()

@property NSUInteger number;

@end

@implementation CGITestApplicationDelegate

- (CGIHTTPResponse *)application:(CGIApplication *)application
   responseFromProcessingRequest:(CGIHTTPRequest *)request
{
    CGIHTTPResponse *response = [[CGIHTTPResponse alloc] init];
    response.responseHeaders[@"Content-Type"] = @"application/json";
    [response.responseData setData:[NSJSONSerialization dataWithJSONObject:@{@"number": @(self.number++)}
                                                                   options:0
                                                                     error:NULL]];
    return response;
}

@end
