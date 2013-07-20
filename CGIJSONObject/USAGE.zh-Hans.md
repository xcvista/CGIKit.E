# CGIJSONObject 在客户端的使用方法

> 如果内容不完整，请移步：
> <https://github.com/xcvista/CGIKit.E/blob/master/CGIJSONObject/USAGE.zh-Hans.md>

`CGIJSONObject` 是一个 Objective-C 对象交互与持久化库。通过充分利用运行时特性，
实现了几乎不用额外代码的持久化对象设计方式，适用于开发速度要求高的场合。持久化对
象可以进一步转换为 JSON 或 Apple 属性表格式，并加以保存或传输。

# 定义持久化对象

持久化对象的基类是 `CGIPersistatObject`，实现 `CGIPersistatObject` 协议。该类包
含一套通过属性反射，无需代码实现对象持久化的机制。

## 基本使用

创建可持久化对象的过程是继承 `CGIPersistatObject` 类，然后在其中定义属性。属性类
型可以是 C 基本数据类型或任何实现 `CGIPersistatObject` 协议的类。

样例代码：

    @interface CGITestObject : CGIPersistantObject
    
    @property NSString *name;
    @property double gender;
    @property NSUInteger count;
    
    @end
    
    @implementation CGITestObject
    
    // 此处无需代码。

    @end

上述代码在持久化时得到一个包含所有属性值的 JSON 持久化对象，例如：

    {
        "name": "John Appleseed",
        "gender": 1.0,
        "count": 500
    }

## 进阶使用

在某些情况下，属性反射可能无效，例如当属性值为某对象的数组时。此时，可以用宏
`CGIPersistanceKeyClass` 指定。此宏指定的对象类型优先于属性反射得到的类型，但若
持久化对象对应键数据类型为数组，则该指定类型视作对数组成员的类型指定。

同时，你也可以通过该宏，通过将属性类型指定为 `Nil`，防止该属性被持久化。

样例代码：

    @interface CGITestObject : CGIPersistantObject
    
    @property NSString *name;
    @property NSArray *dates;
    @property id local;
    
    @end
    
    @implementation CGITestObject
    
    CGIPersistanceKeyClass(count, NSDate);  // 指定了 count 属性的类型。
    CGIPersistanceKeyClass(local, Nil);     // 阻止了 local 属性被持久化。

    @end

# 定义远程方法调用

远程方法调用适用于和远程服务器通过 HTTP POST JSON 对象交换方式进行通信。其基类是
`CGIRemoteObject`。该类继承自 `CGIPersistantObject`，并包含一套通过方法转发和反
射，调用远程方法的机制。通过指定 HTTPS 服务器基地址，可以兼容 SSL。

在定义远程方法时，远程方法的参数以参数名作为属性名，形式参照持久化对象。远程方法
以其方法名称作为本地定义的方法名称，不带参数。返回类型可以是 任何实现
`CGIPersistatObject` 协议的类。

由于方法反射的限制，你必须用类似属性类型制定的形式，使用 `CGIRemoteMethodClass`
宏指定方法的返回值。声明远程方法后，不应提供方法实现，以免方法转发失效。

样例代码：

    @interface CGITestRequest : CGIRemoteObject
    
    @property NSString *sender;
    @property NSArray *searchTerms;
    
    - (CGITestResponse *)search;    // 不带参数。
    
    @end
    
    @implementation CGITestObject
    
    CGIPersistanceKeyClass(searchTerms, NSString);
    CGIRemoteMethodClass(search, CGITestResponse);  // 指定 search 方法返回类型

    @end
    