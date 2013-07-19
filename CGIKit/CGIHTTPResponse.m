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

+ (NSString *)addressLine
{
    static NSString *address;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        char buf[10] = {0};
        time_t _time = time(NULL);
        strftime(buf, 10, "%Y", localtime(&_time));
        address = CGISTR(@"<address>Powered by CGIKit 5.1. &copy; %s.</address>\n", buf);
    });

    return address;
}

+ (instancetype)emptyResponse
{
    CGIHTTPResponse *resp = [[CGIHTTPResponse alloc] init];
    [resp.responseHeaders setDictionary:@{@"Status": @"204"}];
    return resp;
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
                                                                "%@"
                                                                "</div>\n"
                                                                "</body>\n"
                                                                "</html>\n",
                                                                [exception name],
                                                                NSStringFromClass([exception class]),
                                                                [exception name],
                                                                [exception reason],
                                                                [[exception callStackSymbols] componentsJoinedByString:@"\n"],
                                                                [self addressLine]
                                                                ) dataUsingEncoding:NSUTF8StringEncoding]];
    
    return response;
}

+ (instancetype)responseWithError:(NSError *)error
{
    return [self responseWithError:error statusCode:500];
}

+ (instancetype)responseWithError:(NSError *)error statusCode:(NSUInteger)statusCode
{
    CGIHTTPResponse *response = [[self alloc] init];
    
    char buf[10] = {0};
    time_t _time = time(NULL);
    strftime(buf, 10, "%Y", localtime(&_time));
    
    response.responseHeaders[@"Status"] = CGISTR(@"%ld", statusCode);
    response.responseData = [NSMutableData dataWithData:[CGISTR(@""
                                                                "<!DOCTYPE html>\n"
                                                                "<html>\n"
                                                                "<head>\n"
                                                                "<title>HTTP %lu: %@</title>\n"
                                                                "</head>\n"
                                                                "<body>\n"
                                                                "<h1>%@ %ld: %@</h1>\n"
                                                                "<p>%@</p>\n"
                                                                "<div>\n"
                                                                "<hr />\n"
                                                                "%@"
                                                                "</div>\n"
                                                                "</body>\n"
                                                                "</html>\n",
                                                                statusCode,
                                                                [error localizedDescription],
                                                                [error domain],
                                                                [error code],
                                                                [error localizedDescription],
                                                                [error localizedFailureReason],
                                                                [self addressLine]
                                                                ) dataUsingEncoding:NSUTF8StringEncoding]];
    
    return response;
}

+ (instancetype)responseWithData:(NSData *)data type:(NSString *)type
{
    return [self responseWithData:data type:type statusCode:200];
}

+ (instancetype)responseWithData:(NSData *)data type:(NSString *)type statusCode:(NSUInteger)statusCode
{
    CGIHTTPResponse *resp = [[self alloc] init];
    [resp.responseData setData:data];
    resp.responseHeaders[@"Content-Type"] = type;
    resp.responseHeaders[@"Status"] = CGISTR(@"%ld", statusCode);
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
