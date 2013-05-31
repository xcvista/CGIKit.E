//
//  NSObject+CGISafeInvoke.h
//  CGIKit.E
//
//  Created by Maxthon Chan on 13-6-1.
//
//

#import <CGIKit/CGICommon.h>

@interface NSObject (CGISafeInvoke)

- (id)safelyPerformSelector:(SEL)selector, ...;

@end
