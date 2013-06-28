//
//  CGICommon.h
//  CGIKit.E
//
//  Created by Maxthon Chan on 13-6-1.
//
//

#ifndef CGIKit_E_CGICommon_h
#define CGIKit_E_CGICommon_h

// C++-safe C code

#ifdef __cplusplus
#define CGIBeginDecls extern "C" {
#define CGIEndDecls }
#defint CGIExtern extern "C"
#else
#define CGIBeginDecls
#define CGIEndDecls
#define CGIExtern extern
#endif

// Feature detection

#ifndef __has_builtin                   // Optional of course.
#define __has_builtin(x) 0              // Compatibility with non-clang compilers.
#endif
#ifndef __has_feature                   // Optional of course.
#define __has_feature(x) 0              // Compatibility with non-clang compilers.
#endif
#ifndef __has_extension
#define __has_extension __has_feature   // Compatibility with pre-3.0 compilers.
#endif
#ifndef __has_attribute                 // Optional of course.
#define __has_attribute(x) 0            // Compatibility with non-clang compilers.
#endif

// Headers

#ifdef __cplusplus

#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <cstdarg>
#include <cstring>

#else

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>

#endif

#include <unistd.h>
#include <sys/types.h>

// C-safe Objective-C code

#include <objc/runtime.h>

#ifdef __OBJC__

#import <Foundation/Foundation.h>

#define CGIClass @class

#else

#define CGIClass typedef struct objc_object

#endif

// Manual retain/release fallback

#ifdef GNUSTEP

#include <objc/objc-arc.h>          // GNUstep have a header file for this.

#else

CGIBeginDecls

CGIExtern id objc_retain(id);       // Have to declare on OS X
CGIExtern void objc_release(id);    // Ditto

CGIEndDecls

#endif

#if __has_feature(objc_arc) || __has_feature(objc_gc)
#define CGIReturnAutoreleased(x) (x)
#else
#define CGIReturnAutoreleased(x) [(x) autorelease]
#endif

#if !__has_feature(objc_instancetype)
typedef id instancetype;
#endif

#if __has_feature(objc_arc_weak)
#define CGIWeakProperty weak
#define CGIWeak __weak
#else
#define CGIWeakProperty assign
#define CGIWeak __unsafe_inretained
#endif

#ifndef __OBJC__

CGIClass NSObject;
CGIClass NSString;

#endif

#ifdef CGIConstantString
#undef CGIConstantString
#endif
#define CGIConstantString(__name, __value) CGIExtern NSString *const __name

// Convenience methods

#if __has_attribute(always_inline)
#define CGIInline inline __attribute__((always_inline))
#else
#define CGIInline inline
#endif

#if __has_attribute(noreturn)
#define CGINoReturn __attribute__((noreturn))
#else
#define CGINoReturn
#endif

#ifdef __OBJC__

static CGIInline NSString *CGISTRv(NSString *format, va_list args) __attribute__((format(__NSString__, 1, 0)));
static CGIInline NSString *CGISTRv(NSString *format, va_list args)
{
    NSString *string = [[NSString alloc] initWithFormat:format arguments:args];
    return CGIReturnAutoreleased(string);
}

static CGIInline const char *CGICSTR(NSString *string)
{
    return [string cStringUsingEncoding:NSUTF8StringEncoding];
}

static CGIInline NSString *CGISTR(NSString *format, ...) __attribute__((format(__NSString__, 1, 2)));
static CGIInline NSString *CGISTR(NSString *format, ...)
{
    va_list args;
    va_start(args, format);
    NSString *string = CGISTRv(format, args);
    va_end(args);
    
    return string;
}

static CGIInline void CGILogv(NSString *format, va_list args) __attribute__((format(__NSString__, 1, 0)));
static CGIInline void CGILogv(NSString *format, va_list args)
{
    fprintf(stderr, "%s\n", CGICSTR(CGISTRv(format, args)));
}

static CGIInline void CGILog(NSString *format, ...) __attribute__((format(__NSString__, 1, 2)));
static CGIInline void CGILog(NSString *format, ...)
{
    va_list args;
    va_start(args, format);
    CGILogv(format, args);
    va_end(args);
}

#define CGIAssignPointer(_ptr, _val) do { typeof(_ptr) ptr = (_ptr); if (ptr) *ptr = (_val); } while (0)

#endif

#ifdef DEBUG
#define dbgprintf(...) fprintf(stderr, __VA_ARGS__)
#else
#define dbgprintf(...)
#endif

#endif
