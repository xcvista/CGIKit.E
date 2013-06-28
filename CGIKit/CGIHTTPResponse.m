//
//  CGIHTTPResponse.m
//  CGIKit.E
//
//  Created by Maxthon Chan on 6/27/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "CGIHTTPResponse.h"
#import "CGICommon.h"
#import <time.h>
#import <stdlib.h>
#import <string.h>

@implementation CGIHTTPResponse

- (id)init
{
    self = [super init];
    if (self) {
        self.responseHeaders = [NSMutableDictionary dictionaryWithCapacity:10];
        self.responseData = [NSMutableData data];
        
        self.responseHeaders[@"Status"] = @"200";
        self.responseHeaders[@"Content-Type"] = @"text/html; charset=utf8";

    }
    return self;
}

+ (instancetype)responseWithException:(NSException *)exception
{
    CGIHTTPResponse *response = [[self alloc] init];
    
    char buf[10] = {0};
    time_t _time = time(NULL);
    strftime(buf, 10, "%Y", localtime(&_time));
    
    response.responseHeaders[@"Status"] = @"500";
    response.responseData = [NSMutableData dataWithData:[CGISTR(@""
                                                                "<!DOCTYPE html>\n"
                                                                "<html>\n"
                                                                "<head>\n"
                                                                "<title>HTTP 500: %@</title>\n"
                                                                "</head>\n"
                                                                "<body>\n"
                                                                "<h1>%@: %@</h1>\n"
                                                                "<p>%@</p>\n"
                                                                "<pre>%@</pre>\n"
                                                                "<div>\n"
                                                                "<hr />\n"
                                                                "<address>&copy; %s CGIKit 5.0</address>\n"
                                                                "</div>\n"
                                                                "</body>\n"
                                                                "</html>\n",
                                                                [exception name],
                                                                NSStringFromClass([exception class]),
                                                                [exception name],
                                                                [exception reason],
                                                                [[exception callStackSymbols] componentsJoinedByString:@"\n"],
                                                                buf
                                                                ) dataUsingEncoding:NSUTF8StringEncoding]];
    
    return response;
}

+ (instancetype)responseWithData:(NSData *)data type:(NSString *)type
{
    CGIHTTPResponse *resp = [[self alloc] init];
    [resp.responseData setData:data];
    resp.responseHeaders[@"Content-Type"] = type;
    return resp;
}

+ (instancetype)responseWithRedirectionToAddress:(NSString *)target
{
    CGIHTTPResponse *resp = [[self alloc] init];
    resp.responseHeaders[@"Status"] = @302;
    resp.responseHeaders[@"Location"] = target;
    return resp;
}

@end
