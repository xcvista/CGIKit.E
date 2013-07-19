//
//  CGIFastApplication.m
//  CGIKit.E
//
//  Created by Maxthon Chan on 13-6-1.
//
//

#import "CGIFastApplication.h"
#import "fastcgi/fcgi_stdio.h"

const char *CGIFastApplicationName = "CGIFastApplication";

@implementation CGIFastApplication

- (void)run
{
    NSProcessInfo *proc = [NSProcessInfo processInfo];
    
    [self applicationDidStart];
    
    while (FCGI_Accept() >= 0)
    {
        NSDictionary *env = [proc environment];
        NSInteger length = [env[@"CONTENT_LENGTH"] integerValue];
        
        NSData *requestData = nil;
        
        if (length)
        {
            char *buf = malloc(length);
            if (!buf)
            {
                FCGI_SetExitStatus(1);
                continue;
            }
            fread(buf, 1, length, stdin);
            requestData = [[NSData alloc] initWithBytesNoCopy:buf length:length freeWhenDone:YES];
        }
        
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
        if ([responseData length] && !response[@"Content-Length"])
        {
            printf("Content-Length: %lu\n", [responseData length]);
        }
        putchar('\n');
        fflush(stdout);
        
        [self applicationWillWriteResponseData:responseData];
        fwrite((void *)[responseData bytes], 1, [responseData length], stdout);
    }
    
    [self applicationWillTerminate];
    
    exit(0);
}

@end
