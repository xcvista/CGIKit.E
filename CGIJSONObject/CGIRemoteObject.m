//
//  CGIRemoteObject.m
//  CGIJSONKit
//
//  Created by Maxthon Chan on 13-5-22.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "CGIRemoteObject.h"
#import "CGIRemoteConnection.h"
#import <objc/message.h>
#import <objc/runtime.h>

id objc_retain(id);

@implementation CGIRemoteObject

- (id)init
{
    if (self = [super init])
    {
        [self setConnection:[CGIRemoteConnection defaultRemoteConnection]];
    }
    return self;
}

- (id)initWithConnection:(CGIRemoteConnection *)connection
{
    if (self = [super init])
    {
        [self setConnection:connection];
    }
    return self;
}

- (id)initWithPersistanceObject:(id)persistanceObject connection:(CGIRemoteConnection *)connection
{
    if ([persistanceObject isKindOfClass:[NSDictionary class]])
    {
        if (self = [super initWithPersistanceObject:persistanceObject])
        {
            [self setConnection:connection];
        }
        return self;
    }
    else
    {
        return persistanceObject;
    }
}

- (void)setConnection:(CGIRemoteConnection *)connection
{
    @synchronized (_connection)
    {
        _connection = connection;
    }
}

- (CGIRemoteConnection *)connection
{
    @synchronized (_connection)
    {
        return _connection;
    }
}

- (Class)classForMethod:(SEL)method
{
    NSMutableString *methodName = [NSStringFromSelector(method) mutableCopy];
    [methodName replaceOccurrencesOfString:@":"
                                withString:@""
                                   options:0
                                     range:NSMakeRange(0, [methodName length])];
    
    NSString *queryMethodName = CGISTR(@"classForMethod%@", methodName);
    SEL querySelector = NSSelectorFromString(queryMethodName);
    Class class = Nil;
    
    if ([self respondsToSelector:querySelector])
        class = objc_msgSend(self, querySelector);
    
    return class;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if ([self respondsToSelector:aSelector])
        return [super methodSignatureForSelector:aSelector];
    else
    {
        return [NSMethodSignature signatureWithObjCTypes:"@@:"];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL method = [anInvocation selector];
    Class class = [self classForMethod:method];
    id value = nil;
    
    if (!_connection)
    {
        [NSException raise:@"CGINoConnectionException" format:@"I am not connected."];
    }
    
    do
    {
        NSMutableString *methodName = [NSStringFromSelector(method) mutableCopy];
        [methodName replaceOccurrencesOfString:@":"
                                    withString:@""
                                       options:0
                                         range:NSMakeRange(0, [methodName length])];
        if ([methodName hasPrefix:@"_"])
        {
            [methodName deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        else
        {
            [methodName replaceCharactersInRange:NSMakeRange(0, 1)
                                      withString:[[methodName substringToIndex:1] uppercaseString]];
        }
        
        NSError *error = nil;
        NSData *uplinkData = [self JSONDataWithError:&error];
        
        if (!uplinkData)
        {
            value = error;
            break;
        }
        error = nil;
        
        
        
        NSData *downlinkData = [_connection dataWithData:uplinkData
                                              fromMethod:methodName
                                                   error:&error];
        
        if (!downlinkData)
        {
            value = error;
            break;
        }
        error = nil;
        
        id downlinkObject = [NSJSONSerialization JSONObjectWithData:downlinkData
                                                            options:0
                                                              error:&error];
        
        if (!downlinkObject)
        {
            value = error;
            break;
        }
        error = nil;
        
        value = downlinkObject;
        if (class && [class conformsToProtocol:@protocol(CGIPersistantObject)])
        {
            if ([downlinkObject isKindOfClass:[NSDictionary class]])
            {
                value = [[class alloc] initWithPersistanceObject:downlinkObject];
            }
            else if ([downlinkObject isKindOfClass:[NSArray class]])
            {
                NSArray *array = downlinkObject;
                NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[array count]];
                for (id item in array)
                {
                    if ([item isKindOfClass:[NSDictionary class]])
                    {
                        [mutableArray addObject:[[class alloc] initWithPersistanceObject:item]];
                    }
                    else
                    {
                        NSLog(@"WARNING: Object typed %@ occured in array asking for objects typed %@.",
                              NSStringFromClass([item class]),
                              NSStringFromClass(class)
                              );
                        [mutableArray addObject:item];
                    }
                }
                value = [mutableArray copy];
            }
        }
        
    } while (0);
    
    if (value) objc_retain(value);
    [anInvocation setReturnValue:&value];
}

@end

@implementation CGIRemoteObject (CGIAwakeFromPersistance)

- (void)awakeFromPersistance:(id)persistance
{
    self.connection = [CGIRemoteConnection defaultRemoteConnection];
}

@end
