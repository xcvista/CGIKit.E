//
//  CGIServerObject.m
//  CGIKit.E
//
//  Created by Maxthon Chan on 7/17/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "CGIServerObject.h"

@implementation CGIServerObject
{
    CGIHTTPRequest *_request;
}

+ (NSString *)methodName
{
    return nil;
}

- (id)initWithRequest:(CGIHTTPRequest *)request
{
    if ([request.requestData length])
    {
        self = [super initWithJSONData:request.requestData error:NULL];
    }
    else
    {
        self = [super init];
    }
    
    if (self)
    {
        _request = request;
    }
    return self;
}

- (CGIHTTPResponse *)responseFromProcessingObject
{
    id<CGIPersistantObject> object = [self objectFromProcessingRequest:_request];
    NSError *err = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:[object persistaceObject]
                                                   options:0
                                                     error:&err];
    if (!data)
    {
        return [CGIHTTPResponse responseWithError:err];
    }
    else
    {
        return [CGIHTTPResponse responseWithData:data type:@"application/json"];
    }
}

- (id<CGIPersistantObject>)objectFromProcessingRequest:(CGIHTTPRequest *)request
{
    return nil;
}

@end
