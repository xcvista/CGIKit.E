//
//  CGIHTTPResponse.h
//  CGIKit.E
//
//  Created by Maxthon Chan on 6/27/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGIHTTPResponse : NSObject

@property NSMutableDictionary *responseHeaders;
@property NSMutableData *responseData;

+ (NSString *)addressLine;

+ (instancetype)responseWithException:(NSException *)exception;
+ (instancetype)responseWithError:(NSError *)error;
+ (instancetype)responseWithData:(NSData *)data type:(NSString *)type;
+ (instancetype)responseWithRedirectionToAddress:(NSString *)target;

@end
