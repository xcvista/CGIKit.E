//
//  NSURL+DCPersistance.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-24.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "NSURL+DCPersistance.h"

@implementation NSURL (DCPersistance)

- (id)initWithPersistanceObject:(id)persistance
{
    if ([persistance isKindOfClass:[NSString class]])
    {
        return [self initWithString:persistance];
    }
    else
    {
        self = nil;
        return persistance;
    }
}

- (id)persistaceObject
{
    return [self absoluteString];
}

@end
