//
//  CGIRemoteObject.h
//  CGIJSONKit
//
//  Created by Maxthon Chan on 13-5-22.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONObject/CGIPersistantObject.h>

#define CGIRemoteMethodClass(__method, __class) \
- (Class)classForMethod ##__method { return [__class class]; }

@class CGIRemoteConnection;

@interface CGIRemoteObject : CGIPersistantObject
{
    CGIRemoteConnection *__weak _connection;
}

- (CGIRemoteConnection *)connection;
- (void)setConnection:(CGIRemoteConnection *)connection;

- (id)initWithConnection:(CGIRemoteConnection *)connection;
- (id)initWithPersistanceObject:(id)persistanceObject connection:(CGIRemoteConnection *)connection;

- (Class)classForMethod:(SEL)method;

@end
