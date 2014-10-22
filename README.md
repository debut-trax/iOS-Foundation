iOS-Foundation
==============

Foundation macros and code used in all debut trax iOS projects


dtFoundation.h
--------------
A base set of macros that go in all our apps that include the following:
   * Wil Shipleys superb [IsEmpty](http://blog.wilshipley.com/2005/10/pimp-my-code-interlude-free-code.html) macro.
   * Floating point number comparison macros.
   * iOS version checking macros.


dtUI.h
------
A set of macros that go in all our apps that use UIKit that include the following:
   * Macros to convert from hex red, green, blue (and optional alpha) values to UIColor.
   * Macros to convert from web hex strings of RGB and RGBA values to UIColor.
   * Easy checking for presence of a Retina display.


dtCoreData.*
------------
A class that extends NSManagedObjectContext to add a criticalErrorHandler for Core Data.  

The error handler logs Core Data errors with as much information as it can, including a developer supplied comment on the attempted operation that failed, then quits the app cleanly.


Requirements
------------
* iOS 7.0 and above


Copyright
---------
All code is released under the BSD-3 license, see LICENSE file for more details.


Contact
-------
If you are using any of this foundation code in your projects and have any suggestions or questions:

Daniel Wright, <daniel@debut-trax.co.nz>
