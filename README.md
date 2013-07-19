# CGIKit.E

This is the version 5 of CGIKit, the new Objective-C Web development framework
based on stable Common Gateway Interface and FastCGI protocol.

## Modules

### CGIKit

`CGIKit` framework implements the CGI and FastCGI protocol. It also proveded a
simpler, rewrite-compatible FastCGI page multiplexer, CGIMethodApplication.

The code lifecycle management provided by `CGIApplication` and its concrete
subclasses are modeled after Cocoa application class, `NSApplication`.

### CGIJSONObject

`CGIJSONObject` provided a simple object persistance framework with JSON as data
persistance format. It is proved to be extremely simple to integrate with NoSQL
database products, like MongoDB.

### WebUIKit

`WebUIKit` is for writing web pages in Objective-C. It introduced the `.wib`
files - Web Interface Builder files, that compiles into Objective-C source code
and, when building an entire website, linked into a single, concrete FastCGI
application that requires URL Rewriting to work.

WebUIKit is largely modeled after ASP.net, which is in turn mimics Java EE.

## Copyright and License

Copyright &copy; 2011-2013 Maxthon T. Chan. All rights reserved.

You can freely use, reproduce, display, copy, modify, and distribute this
software, as long as the following conditions are met:

*   Your source code distribution shall always include the copyright notice
    above, this license and the disclaimer below.
*   Your binary distribution shall always reproduce the copyright notice above,
    this license and the disclaimer below appropriately.
*   You shall not identify your modified work the same work as this work, nor
    identify its author the author of this work, unless otherwise allowed.

THIS SOFTWARE IS FREE SOFTWARE DISTRIBUTED ON AN "AS-IS" BASIS. WE AUTHORS HOPE
IT TO BE AS USEFUL AND PRODUCTIVE AS POSSIBLE. HOWEVER THERE IS ABSOLUTELY NO
GUARANTEE NOR WARRANTY COME WITH THIS SOFTWARE WHATSOEVER, TO THE LIMIT
PERMITTED BY THE LAW. YOU USE THIS SOFTWARE ON YOUR OWN RISK.
