//
//  CGISwagDelegate.m
//  CGIKit.E
//
//  Created by Maxthon Chan on 13-6-1.
//
//

#import "CGISwagDelegate.h"

@implementation CGISwagDelegate

- (NSData *)application:(CGIApplication *)application dataFromProcessingHTTPRequest:(NSDictionary *)request requestData:(NSData *)data withResponse:(NSDictionary *__autoreleasing *)response
{
    NSString *path = request[@"QUERY_STRING"];
    if (![path length])
    {
        NSDictionary *resp = @{@"Status": @"301", @"Location": @"?/"};
        *response = resp;
        return [NSData data];
    }
    else
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *root = CGISTR(@".%@", path);
        
        NSMutableString *content = [NSMutableString stringWithFormat:@"<!DOCTYPE html>\n\n<html>\n<head>\n<meta charset=\"utf-8\" />\n<title>%@</title>\n</head>\n<body>\n<ul>\n", path];
        NSArray *paths = [fm contentsOfDirectoryAtPath:root error:NULL];
        for (NSString *file in paths)
        {
            NSString *target = [root stringByAppendingPathComponent:file];
            BOOL dir = NO;
            if ([fm fileExistsAtPath:target isDirectory:&dir])
            {
                if (dir)
                {
                    [content appendFormat:@"<li><a href=\"?%@\">%@/</a></li>\n", [target substringFromIndex:1], file];
                }
                else if ([@[@"jpg", @"png", @"gif"] containsObject:[file pathExtension]])
                {
                    [content appendFormat:@"<li><a href=\"%@\"><img href=\"%@\" /></a></li>\n", [target substringFromIndex:1], target];
                }
                else
                {
                    [content appendFormat:@"<li><a href=\"%@\">%@</a></li>\n", [target substringFromIndex:1], file];
                }
            }
        }
        
        NSDictionary *resp = @{@"Content-Type": @"text/html"};
        *response = resp;
        return [content dataUsingEncoding:NSUTF8StringEncoding];
    }
}

@end
