//
//  CGIHTTPRequest.m
//  CGIKit.E
//
//  Created by Maxthon Chan on 13-6-1.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "CGIHTTPRequest.h"

@implementation CGIHTTPRequest

- (id)initWithRequestFields:(NSDictionary *)request data:(NSData *)data
{
    if (self = [super init])
    {
        self.requestData = data;
        self.requestFields = request;
    }
    return self;
}

@end
