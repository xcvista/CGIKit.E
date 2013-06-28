//
//  CGIPersistantObject.m
//  CGIJSONKit
//
//  Created by Maxthon Chan on 13-5-21.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "CGIPersistantObject.h"
#import <CGIKit/CGIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>

@implementation CGIPersistantObject

- (id)initWithPersistanceObject:(id)persistance
{
    if ([persistance isKindOfClass:[NSDictionary class]])
    {
        if (self = [super init])
        {
            NSDictionary *dictionary = persistance;
            
            // Get a list of properties.
            unsigned int propertyCount = 0;
            objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
            
            if (properties)
            {
                // Enumerate all properties.
                
                for (unsigned int i = 0; i < propertyCount; i++)
                {
                    objc_property_t property = properties[i];
                    NSString *name = @(property_getName(property));         // Property name.
                    NSString *attr = @(property_getAttributes(property));   // Property attributes
                    NSString *type = @"@";
                    BOOL readonly = NO;
                    
                    // Check the property type.
                    NSArray *attrs = [attr componentsSeparatedByString:@","];
                    for (NSString *attribute in attrs)
                    {
                        if ([attribute hasPrefix:@"R"])
                        {
                            readonly = YES;
                        }
                    }
                    
                    id value = dictionary[name];                            // Find the value.
                    
                    if (!value && [name isEqualToString:@"ID"])
                    {
                        value = dictionary[@"id"];                          // ID is used instead of id.
                    }
                    
                    if (!readonly && value)
                    {
                        // Dispatching would require some tricks.
                        if ([type hasPrefix:CGIType(id)])                    // Objects. Special requirements is required.
                        {
                            Class class = [self classForKey:name];
                            id object = value;
                            
                            if (class && [class conformsToProtocol:@protocol(CGIPersistantObject)])
                            {
                                object = [[class alloc] initWithPersistanceObject:value];
                                if (object == value && [value isKindOfClass:[NSArray class]])
                                {
                                    NSArray *array = value;
                                    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[array count]];
                                    for (id item in array)
                                    {
                                        if ([item isKindOfClass:[NSDictionary class]])
                                        {
                                            [mutableArray addObject:[[class alloc] initWithPersistanceObject:item]];
                                        }
                                        else
                                        {
                                            [mutableArray addObject:item];
                                        }
                                    }
                                    object = [mutableArray copy];
                                }
                            }
                            value = object;
                        }
                        
                        @try
                        {
                            [self setValue:value forKey:name];
                        }
                        @catch (NSException *exception)
                        {
                            dbgprintf("WARNING: Cannot find property: %s", CGICSTR(name));
                        }
                    }
                }
                free(properties);
                properties = NULL;
            } // (properties)
            
            if ([self respondsToSelector:@selector(awakeFromPersistance:)])
            {
                [self awakeFromPersistance:persistance];
            }
            
        } // (self = [super init])
        return self;
    }
    else // ([persistance isKindOfClass:[NSDictionary class]])
    {
        return persistance;
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        
        // Get a list of properties.
        unsigned int propertyCount = 0;
        objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
        
        if (properties)
        {
            // Enumerate all properties.
            
            for (unsigned int i = 0; i < propertyCount; i++)
            {
                objc_property_t property = properties[i];
                NSString *name = @(property_getName(property));         // Property name.
                NSString *attr = @(property_getAttributes(property));   // Property attributes
                BOOL readonly = NO;
                
                // Check the property type.
                NSArray *attrs = [attr componentsSeparatedByString:@","];
                for (NSString *attribute in attrs)
                {
                    if ([attribute hasPrefix:@"R"])
                    {
                        readonly = YES;
                    }
                }
                
                id value = [aDecoder decodeObjectForKey:name];                            // Find the value.
                
                if (!readonly && value)
                {
                    @try
                    {
                        [self setValue:value forKey:name];
                    }
                    @catch (NSException *exception)
                    {
                        dbgprintf("WARNING: Cannot find property: %s", CGICSTR(name));
                    }
                }
            }
            free(properties);
            properties = NULL;
        } // (properties)
        
    } // (self = [super init])
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // Get a list of properties.
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    
    if (properties)
    {
        // Enumerate all properties.
        
        for (unsigned int i = 0; i < propertyCount; i++)
        {
            objc_property_t property = properties[i];
            NSString *name = @(property_getName(property)); // Property name.
            
#if defined(GNUSTEP)                                        // For GNUstep, this _end property is handled.
            if ([name hasPrefix:@"_end"])
                break;
#endif
            
            id value = nil;
            
            @try
            {
                value = [self valueForKey:name];            // Find the value, using KVO.
            }
            @catch (NSException *exception)
            {
                dbgprintf("WARNING: Cannot find key: %s", CGICSTR(name));
            }
            
            if (!value)
            {
                continue;                                   // Ignore null keys.
            }
            
            [aCoder encodeObject:value forKey:name];
        }
        free(properties);
        properties = NULL;
    }

}

- (id)init
{
    if (self = [super init])
    {
        if ([self respondsToSelector:@selector(awakeFromPersistance:)])
        {
            [self awakeFromPersistance:nil];
        }
    }
    return self;
}

- (id)persistaceObject
{
    // Get a list of properties.
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:propertyCount];
    
    if (properties)
    {
        // Enumerate all properties.
        
        for (unsigned int i = 0; i < propertyCount; i++)
        {
            objc_property_t property = properties[i];
            NSString *name = @(property_getName(property)); // Property name.
            
#if defined(GNUSTEP)                                        // For GNUstep, this _end property is handled.
            if ([name hasPrefix:@"_end"])
                break;
#endif
            
            id value = nil;
            
            @try
            {
                value = [self valueForKey:name];            // Find the value, using KVO.
            }
            @catch (NSException *exception)
            {
                dbgprintf("WARNING: Cannot find key: %s", CGICSTR(name));
            }
            
            if (!value)
            {
                continue;                                   // Ignore null keys.
            }
            
            if ([name isEqualToString:@"ID"])
            {
                name = @"id";                               // ID is used instead of id.
            }
            
            if ([value conformsToProtocol:@protocol(CGIPersistantObject)])
            {
                value = [value persistaceObject];
            }
            else if ([value isKindOfClass:[NSArray class]])
            {
                NSMutableArray *outputArray = [NSMutableArray arrayWithCapacity:[value count]];
                for (id object in value)
                {
                    if ([object conformsToProtocol:@protocol(CGIPersistantObject)])
                    {
                        [outputArray addObject:[object persistaceObject]];
                    }
                    else
                    {
                        [outputArray addObject:object];
                    }
                }
            }
            
            dictionary[name] = value;
        }
        free(properties);
        properties = NULL;
    }
    return dictionary;
}

- (Class)classForKey:(id)key
{
    objc_property_t objcProperty = class_getProperty([self class], CGICSTR(key));
    NSString *attributes = @(property_getAttributes(objcProperty));
    NSString *type = @"@";
    Class class = Nil;
    
    NSString *methodName = CGISTR(@"classForKey%@", key);
    SEL selector = NSSelectorFromString(methodName);
    if (selector && [self respondsToSelector:selector])
        class = objc_msgSend(self, selector);
    
    if (class)
        return class;
    
    NSArray *attrs = [attributes componentsSeparatedByString:@","];
    for (NSString *attribute in attrs)
    {
        if ([attribute hasPrefix:@"T"])
        {
            type = [attribute substringFromIndex:1];
        }
    }
    
    if ([type length] > 3)
    {
        NSString *className = [type substringWithRange:NSMakeRange(2, [type length] - 3)];
        class = NSClassFromString(className);
    }
    
    return class;
}

@end

@implementation CGIPersistantObject (CGIJSONObject)

- (id)initWithJSONData:(NSData *)data error:(NSError *__autoreleasing *)error
{
    NSError *err = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data
                                                options:0
                                                  error:&err];
    if (!object)
    {
        CGIAssignPointer(error, err);
        return nil;
    }
    
    return [self initWithPersistanceObject:object];
}

- (BOOL)canRepresentInJSON
{
    return [NSJSONSerialization isValidJSONObject:[self persistaceObject]];
}

- (NSData *)JSONDataWithError:(NSError *__autoreleasing *)error
{
    NSError *err = nil;
    NSDictionary *dict = [self persistaceObject];
    
    if (![self canRepresentInJSON])
    {
        CGIAssignPointer(error, [NSError errorWithDomain:NSPOSIXErrorDomain
                                                    code:EBADF
                                                userInfo:nil]);
        return nil;
    }
    
    if (!dict)
    {
        CGIAssignPointer(error, [NSError errorWithDomain:NSPOSIXErrorDomain
                                                    code:ENODATA
                                                userInfo:nil]);
        return nil;
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self persistaceObject]
                                                   options:0
                                                     error:&err];
    
    if (!data)
    {
        CGIAssignPointer(error, err);
        return nil;
    }
    
    return data;
}

- (NSString *)description
{
    if ([self respondsToSelector:@selector(ID)])
        return CGISTR(@"%@: %@", [super description], [self ID]);
    else
        return [super description];
}

@end

@implementation CGIPersistantObject (CGIEquality)

- (BOOL)isEqual:(id)object
{
    BOOL rv = NO;
    if ([self respondsToSelector:@selector(ID)] && [object respondsToSelector:@selector(ID)])
    {
        if ([[self ID] respondsToSelector:@selector(compare:)])
        {
            rv = [[self ID] compare:[object ID]] == NSOrderedSame;
        }
        else
        {
            rv = [[self ID] isEqual:[object ID]];
        }
    }
    else
        rv = [super isEqual:object];
    return rv;
}

@end
