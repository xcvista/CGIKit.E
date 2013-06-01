//
//  CGIFastApplication.m
//  CGIKit.E
//
//  Created by Maxthon Chan on 13-6-1.
//
//

#import "CGIFastApplication.h"

@implementation CGIFastApplication

- (void)run
{
    NSProcessInfo *proc = [NSProcessInfo processInfo];
    NSArray *args = [proc arguments];
    NSDictionary *env = [proc environment];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *pipeName = nil;
    if ([args count] > 2)
        pipeName = args[1];
    else
        pipeName = @"/tmp/CGIFastSocket";
    
    BOOL dir = NO;
    BOOL exist = [fm fileExistsAtPath:pipeName isDirectory:&dir];
    if (!exist || dir)
    {
        
    }
}

@end
