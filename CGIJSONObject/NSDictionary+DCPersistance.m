//
//  NSDictionary+DCPersistance.m
//  CGIKit.E
//
//  Created by Maxthon Chan on 7/19/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "NSDictionary+DCPersistance.h"

@implementation NSDictionary (DCPersistance)

- (id)initWithPersistanceObject:(id)persistance
{
    self = nil;
    return persistance;
}

- (id)persistaceObject
{
    NSMutableDictionary *target = [NSMutableDictionary dictionaryWithCapacity:[self count]];
    for (id key in self)
    {
        id value = self[key];
        if ([value conformsToProtocol:@protocol(CGIPersistantObject)])
            value = [value persistaceObject];
        target[[key description]] = value;
    }
    return [NSDictionary dictionaryWithDictionary:target];
}

@end
