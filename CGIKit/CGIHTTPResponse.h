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

+ (instancetype)responseWithException:(NSException *)exception;

@end
