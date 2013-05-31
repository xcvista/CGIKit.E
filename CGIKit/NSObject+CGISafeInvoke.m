//
//  NSObject+CGISafeInvoke.m
//  CGIKit.E
//
//  Created by Maxthon Chan on 13-6-1.
//
//

#import "NSObject+CGISafeInvoke.h"
#import "CGICommon_Private.h"

@implementation NSObject (CGISafeInvoke)

- (id)safelyPerformSelector:(SEL)selector, ...
{
    if ([self respondsToSelector:selector])
    {
        NSMethodSignature *sig = [self methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        [invocation setTarget:self];
        [invocation setSelector:selector];
        
        va_list args;
        va_start(args, selector);
        
        for (NSUInteger i = 2; i < [sig numberOfArguments]; i++)
        {
            NSString *type = @([sig getArgumentTypeAtIndex:i]);
            if ([@[CGIEncode(signed char), CGIEncode(unsigned char),
                   CGIEncode(signed short), CGIEncode(unsigned short),
                   CGIEncode(signed int), CGIEncode(unsigned int)] containsObject:type])
            {
                int buf = va_arg(args, int);
                [invocation setArgument:&buf atIndex:i];
            }
            else if ([@[CGIEncode(signed long), CGIEncode(unsigned long)] containsObject:type])
            {
                long buf = va_arg(args, long);
                [invocation setArgument:&buf atIndex:i];
            }
            else if ([@[CGIEncode(signed long long), CGIEncode(unsigned long long)] containsObject:type])
            {
                long long buf = va_arg(args, long long);
                [invocation setArgument:&buf atIndex:i];
            }
            else if ([@[CGIEncode(float), CGIEncode(double)] containsObject:type])
            {
                double buf = va_arg(args, double);
                [invocation setArgument:&buf atIndex:i];
            }
            else if ([CGIEncode(id) isEqualToString:type])
            {
                id buf = va_arg(args, id);
                [invocation setArgument:&buf atIndex:i];
            }
        }
        
        va_end(args);
        
        [invocation invoke];
        
        void *buffer = malloc([sig methodReturnLength]);
        [invocation getReturnValue:buffer];
        
        if (!strcmp([sig methodReturnType], @encode(id)))
        {
            return *(id __strong *)buffer;
        }
        else
        {
            return [NSValue valueWithBytes:buffer objCType:[sig methodReturnType]];
        }
    }
    else
    {
        return nil;
    }
}

@end
