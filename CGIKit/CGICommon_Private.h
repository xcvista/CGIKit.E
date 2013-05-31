//
//  CGICommon_Private.h
//  CGIKit.E
//
//  Created by Maxthon Chan on 13-6-1.
//
//

#ifndef CGIKit_E_CGICommon_Private_h
#define CGIKit_E_CGICommon_Private_h

#ifdef CGIConstantString
#undef CGIConstantString
#endif
#define CGIConstantString(__name, __value) NSString *const __name = __value

#if !__has_feature(objc_arc)
#error This library have to be built with Objective-C ARC.
#endif

#if !__has_feature(blocks)
#error This library have to be built with Blocks.
#endif

#endif
