//
//  CGIServerObject.m
//  CGIKit.E
//
//  Created by Maxthon Chan on 7/17/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "CGIServerObject.h"

@implementation CGIServerObject

+ (NSString *)methodName
{
    return nil;
}

- (id)initWithRequest:(CGIHTTPRequest *)request
{
    if (self = [super initWithJSONData:request.requestData
                                 error:NULL])
    {
        // I have nothing?
    }
    return self;
}

- (CGIHTTPResponse *)responseFromProcessingObject
{
    return [CGIHTTPResponse responseWithError:[NSError errorWithDomain:NSPOSIXErrorDomain
                                                                  code:ENOSYS
                                                              userInfo:nil]];
}

@end
