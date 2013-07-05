//
//  CGIPersistantObject.h
//  CGIJSONKit
//
//  Created by Maxthon Chan on 13-5-21.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CGIPersistanceKeyClass(__key, __class) \
- (Class)classForKey ##__key { return [__class class]; }
#define CGIIdentifierProperty @property id ID
#define CGIType(type) @(@encode(type))

@protocol CGIPersistantObject <NSObject, NSCoding, NSCopying>

- (id)initWithPersistanceObject:(id)persistance;
- (id)persistaceObject;

@end

@interface CGIPersistantObject : NSObject <CGIPersistantObject>

- (Class)classForKey:(NSString *)key;

@end

@interface CGIPersistantObject (CGIObjectLifetime)

- (void)awakeFromPersistance:(id)persistance;

@end

@interface CGIPersistantObject (CGIJSONObject)

- (id)initWithJSONData:(NSData *)data error:(NSError **)error;

- (BOOL)canRepresentInJSON;
- (NSData *)JSONDataWithError:(NSError **)error;

@end

@interface CGIPersistantObject (CGIIdentifier)

- (id)ID;

@end

@interface CGIPersistantObject (CGIEquality)

- (BOOL)isEqual:(id)object;

@end