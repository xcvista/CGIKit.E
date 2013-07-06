/**
 @file      CGIPersistantObject.h
 @author    Maxthon Chan 
 @date      May. 21, 2013
 @copyright Copyright (c) 2013 muski. All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 @def       CGIPersistanceKeyClass
 
 Macro defining a method that indicates type of property when property
 introspection does not work or is not reliable.
 
 @param     __key    Name of the key.
 @param     __class  Name of the class.
 */
#define CGIPersistanceKeyClass(__key, __class) \
- (Class)classForKey ##__key { return [__class class]; }

/**
 @def       CGIIdentifierProperty
 
 Convenience macro defining an identifier property.
 
 @note      You cannot define a property with name `id` directly, as it is a
            keyword in Objective-C programming language. Instead, you can use
            this macro.
 */
#define CGIIdentifierProperty @property id ID

/**
 @def       CGIType
 
 Returns the Objective-C type ID in an NSString for a given type. This macro is
 mostly for internal use.
 
 @param     type    Type to be encoded.
 */
#define CGIType(type) @(@encode(type))

/**
 @brief     Basic protocol for objects that support persistance.
 
 This protocol defines basic methods that is required for JSON persistance.
 
 @see       <NSCopying>
 @note      This protocol will probably go away as JSON persistance framework is
            subject to a rewrite, using @c NSSecureCoding as its basis.
 */
@protocol CGIPersistantObject <NSObject, NSCoding, NSCopying>

/**
 Initialize the object from JSON persistance object.
 
 @param     persistance JSON persistance object
 @return    Object initialized with data recovered from JSON persistance upon
            success, nil upon failure.
 */
- (id)initWithPersistanceObject:(id)persistance;

/**
 Obtain a JSON persistance object.
 
 @return    JSON-capable object that contains all needed data from the object.
 */
- (id)persistaceObject;

@end

/**
 @brief     Object with JSON persistance.
 
 This is the base class for (almost) all objects that is encoded as key-value
 pairs.
 */
@interface CGIPersistantObject : NSObject <CGIPersistantObject>

/**
 Obtain the class for a certain key.
 
 @return    Class for the value of the key.
 @note      Generally you does not need to override this method. Use
            `CGIPersistanceKeyClass()` macro instead.
 */
- (Class)classForKey:(NSString *)key;

@end

/**
 Object lifetime.
 */
@interface CGIPersistantObject (CGIObjectLifetime)

/**
 This method is called after an object is restored from persistance.
 */
- (void)awakeFromPersistance:(id)persistance;

@end

/**
 JSON persistance
 */
@interface CGIPersistantObject (CGIJSONObject)

/**
 Initialize an object with JSON data.
 
 @param     data    JSON data to be parsed.
 @param     error   [out] Returns the details of error. Pass @c NULL to suppress
                    this output.
 @return    Initialized object with contents of data if succeed, @c nil if fail.
 */
- (id)initWithJSONData:(NSData *)data error:(NSError **)error;

- (BOOL)canRepresentInJSON;
- (NSData *)JSONDataWithError:(NSError **)error;

@end

@interface CGIPersistantObject (CGIEquality)

@end