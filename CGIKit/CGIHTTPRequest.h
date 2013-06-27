//
//  CGIHTTPRequest.h
//  CGIKit.E
//
//  Created by Maxthon Chan on 13-6-1.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGIHTTPRequest : NSObject

@property NSDictionary *requestFields;
@property NSData *requestData;

- (id)initWithRequestFields:(NSDictionary *)request data:(NSData *)data;

@end
