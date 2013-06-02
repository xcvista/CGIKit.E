//
//  CGISwagDelegate.m
//  CGIKit.E
//
//  Created by Maxthon Chan on 13-6-1.
//
//

#import "CGISwagDelegate.h"

@implementation CGISwagDelegate

static inline NSString *__CGISizeString(unsigned long long size)
{
    NSArray *units = @[@" bytes", @"KiB", @"MiB", @"GiB", @"TiB", @"YiB", @"ZiB"];
    NSUInteger index = 0;
    for (index = 0; size >= 1024; size /= 1024, index++);
    return CGISTR(@"%llu%@", size, units[index]);
}

- (NSData *)application:(CGIApplication *)application dataFromProcessingHTTPRequest:(NSDictionary *)request requestData:(NSData *)data withResponse:(NSDictionary *__autoreleasing *)response
{
    NSString *path = [request[@"QUERY_STRING"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
        
        NSMutableString *content = [NSMutableString stringWithFormat:@"<!DOCTYPE html>\n\n<html>\n<head>\n<meta charset=\"utf-8\" />\n<title>%@</title>\n</head>\n<body>\n<h1>%@</h1><ul>\n", path, path];
        NSArray *paths = [[fm contentsOfDirectoryAtPath:root error:NULL] sortedArrayUsingSelector:@selector(localizedCompare:)];
        
        if (![path isEqualToString:@"/"])
        {
            [content appendFormat:@"<li><a href=\"?%@\" />../</a></li>", [path stringByDeletingLastPathComponent]];
        }
        
        for (NSString *file in paths)
        {
            NSString *target = [root stringByAppendingPathComponent:file];
            BOOL dir = NO;
            if ([fm fileExistsAtPath:target isDirectory:&dir])
            {
                NSDictionary *stat = [fm attributesOfItemAtPath:target error:NULL];
                if (dir)
                {
                    [content appendFormat:@"<li><a href=\"?%@\">%@/</a></li>\n", [target substringFromIndex:1], file];
                }
                else if ([@[@"jpg", @"png", @"gif"] containsObject:[file pathExtension]])
                {
                    [content appendFormat:@"<li><a href=\"%@\"><img src=\"%@\" style=\"max-height: 200px; max-width: 200px;\" alt=\"%@\" /></a>(%@ [%@])</li>\n", [target substringFromIndex:1], [target substringFromIndex:1], file, file, __CGISizeString([stat fileSize])];
                }
                else
                {
                    [content appendFormat:@"<li><a href=\"%@\">%@</a> [%@]</li>\n", [target substringFromIndex:1], file, __CGISizeString([stat fileSize])];
                }
            }
        }
        
        [content appendString:@"</li>\n<div>\n<hr />\n<address>CGIKit 5.0 - &copy; 2013 muski</address>\n</body>\n</html>\n"];
        
        NSDictionary *resp = @{@"Content-Type": @"text/html"};
        *response = resp;
        return [content dataUsingEncoding:NSUTF8StringEncoding];
    }
}

@end
