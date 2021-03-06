//
//  CGIRemoteObject.h
//  CGIJSONKit
//
//  Created by Maxthon Chan on 13-5-22.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONObject/CGIPersistantObject.h>

/**
 @def       CGIRemoteMethodClass
 
 此宏定义一个远程方法返回类型的私有方法。方法反射无法获知其返回值。
 
 @param     __key    需要制定类型的属性名。
 @param     __class  属性值的类型。
 @note      宏定义展开后包括一个对指定类的方法调用，因此需要导入该类的头文件。
 */
#define CGIRemoteMethodClass(__method, __class) \
- (Class)classForMethod ##__method { return [__class class]; }

@class CGIRemoteConnection;

/**
 @brief     远程方法调用请求对象基类。
 
 本类包装一个远程方法调用。
 */
@interface CGIRemoteObject : CGIPersistantObject

- (CGIRemoteConnection *)connection;
- (void)setConnection:(CGIRemoteConnection *)connection;

- (id)initWithConnection:(CGIRemoteConnection *)connection;
- (id)initWithPersistanceObject:(id)persistanceObject connection:(CGIRemoteConnection *)connection;

- (Class)classForMethod:(SEL)method;

@property NSData *downlinkData;

- (NSString*) stringForDownlinkData;

@end
