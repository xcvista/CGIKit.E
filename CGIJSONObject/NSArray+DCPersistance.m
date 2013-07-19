//
//  NSArray+DCPersistance.m
//  CGIKit.E
//
//  Created by Maxthon Chan on 7/19/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "NSArray+DCPersistance.h"

@implementation NSArray (DCPersistance)

- (id)initWithPersistanceObject:(id)persistance
{
    self = nil;
    return persistance;
}

- (id)persistaceObject
{
    NSMutableArray *pers = [NSMutableArray arrayWithCapacity:[self count]];
    
    for (id object in self)
    {
        id o = object;
        if ([object conformsToProtocol:@protocol(CGIPersistantObject)])
        {
            o = [object persistaceObject];
        }
        [pers addObject:o];
    }
    
    return [NSArray arrayWithArray:pers];
}

@end
