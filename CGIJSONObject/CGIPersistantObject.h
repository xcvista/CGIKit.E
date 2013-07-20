/**
 @file      CGIPersistantObject.h
 @author    Maxthon Chan 
 @date      May. 21, 2013
 @copyright Copyright (c) 2013 muski. All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 @def       CGIPersistanceKeyClass
 
 此宏定义一个持久化对象类型的私有方法。此方法用于化解某些通过属性反射无法解析的
 属性类型，包括指定数组成员。
 
 @param     __key    需要制定类型的属性名。
 @param     __class  属性值的类型。
 @note      宏定义展开后包括一个对指定类的方法调用，因此需要导入该类的头文件。
 */
#define CGIPersistanceKeyClass(__key, __class) \
- (Class)classForKey ##__key { return [__class class]; }

/**
 @def       CGIIdentifierProperty
 
 定义对象标识符属性的方便宏。
 
 @note      在 Objective-C 中，你不能直接定义名为 \c id 的属性。因此这一宏定义试
            图通过一种不冒犯 Objective-C 编译器的方式来解决这一问题。
 */
#define CGIIdentifierProperty @property id ID

/**
 @def       CGIType
 
 返回一个包含对象类型编码的字符串对象。
 
 @param     type    被编码的类型。
 @note      此宏定义几乎只在 \c CGIJSONObjects 库内部使用。
 */
#define CGIType(type) @(@encode(type))

/**
 @brief     对象 JSON 持久化的基本协议。
 
 此协议声明基于 JSON 的对象持久化所需要的基本方法。
 
 @see       <NSCopying>
 @note      这个协议将来可能被删除，被 \c NSSecureCoding 和 \c CGIJSONKeyedCoder
            取代。
 */
@protocol CGIPersistantObject <NSObject, NSCoding, NSCopying>

/**
 从 JSON 持久化存储对象初始化对象。
 
 @param     persistance JSON 持久化存储对象。
 @return    如果初始化成功，返回初始化的对象；如果初始化失败，返回 \c nil 。
 */
- (id)initWithPersistanceObject:(id)persistance;

/**
 获取 JSON 持久化存储对象。
 
 @return    包括对象所有必要信息的 JSON 持久化存储对象。
 */
- (id)persistaceObject;

@end

/**
 @brief     基本可 JSON 持久化对象。
 
 为大多数可持久化对象提供基类。
 
 @note      这个类将来可能删除，被一个 NSObject 分类取代。
 */
@interface CGIPersistantObject : NSObject <CGIPersistantObject>

/**
 获得一个属性的类型。
 
 @return    属性值的类型。
 @note      一般来说，你不应该重写这一方法，而是尽量依赖属性反射检查，必要时使用
            \c CGIPersistanceKeyClass 宏补充说明。
 */
- (Class)classForKey:(NSString *)key;

@end

/**
 可持久化对象的生命周期管理。
 */
@interface CGIPersistantObject (CGIObjectLifetime)

/**
 当对象从 JSON 持久化对象中恢复时，此方法将被调用。
 */
- (void)awakeFromPersistance:(id)persistance;

@end

/**
 JSON 数据操作。
 */
@interface CGIPersistantObject (CGIJSONObject)

/**
 从 JSON 数据初始化对象。
 
 @param     data    欲解析的 JSON 数据。
 @param     error   如果解析失败，指针所指向的对象将被修改为错误的详细信息。您可
                    传入 \c NULL 屏蔽这一输出。
 @return    如果初始化成功，返回初始化的对象；如果初始化失败，返回 \c nil 。
 */
- (id)initWithJSONData:(NSData *)data error:(NSError **)error;

/**
 检查对象是否可以以 JSON 格式保存。
 
 @return    对象数据是否都可以以 JSON 格式保存。
 */
- (BOOL)canRepresentInJSON;

/**
 返回对象的 JSON 持久化数据。
 
 @param     error   如果持久化失败，指针所指向的对象将被修改为错误的详细信息。您
                    可传入 \c NULL 屏蔽这一输出。
 */
- (NSData *)JSONDataWithError:(NSError **)error;

@end

/**
 对象等价判断
 */
@interface CGIPersistantObject (CGIEquality)

@end