//
// Copyright (c) 2014, Debut Trax Ltd  -  http://debut-trax.com
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright
//   notice, this list of conditions and the following disclaimer.
//
// * Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
//
// * Neither the name of Debut Trax Ltd nor the names of its contributors
//   may be used to endorse or promote products derived from this software
//   without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//
//  dtUI.h (build 1.0.1)
//
//  The common UI macros used in all debut trax Ltd iOS applications.
//
//  Change History:
//  1.0.0   01/03/2011      Initial Release
//  1.0.1   05/11/2013      Update IS_RETINA to use correct Apple endorsed method
//                          now iOS 3.2 and original iPads are a distant memory.
//


// Macros to create UIColors from seperate 8 bit web hex values
//  Usage:
//   UIColor *myColor = UIColorFromRedGreenBlue(0xF0, 0xEF, 0xE5);
//   UIColor *myAlphaColor = UIColorFromRedGreenBlueAlpha(0xF0, 0xEF, 0xE5, 0xFF);
//
#define UIColorFromRedGreenBlue(r,g,b)              [UIColor colorWithRed:((r)/255.0) green:((g)/255.0) blue:((b)/255.0) alpha:1.0]
#define UIColorFromRedGreenBlueAlpha(r,g,b,a)       [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]


// Macros to create UIColors from 6 digit web hex values
//  Usage:
//   UIColor *myColor = UIColorFromRGB(0xF0EFE5);
//   UIColor *myAlphaColor = UIColorFromRGBA(0xF0EFE5FF);
//
#define UIColorFromRGB(RGBhex)                      [UIColor colorWithRed:(((float)((RGBhex & 0xFF0000) >> 16))/255.0) green:(((float)((RGBhex & 0xFF00) >> 8))/255.0) blue:(((float)(RGBhex & 0xFF))/255.0) alpha:1.0]
#define UIColorFromRGBA(RGBAhex)                    [UIColor colorWithRed:(((float)((RGBAhex & 0xFF000000) >> 24))/255.0) green:(((float)((RGBAhex & 0xFF0000) >> 16))/255.0) blue:(((float)((RGBAhex & 0xFF00) >> 8))/255.0) alpha:(((float)(RGBAhex & 0xFF))/255.0)]


// Macro to determine if we have a retina display
//  Usage:
//   if (IS_RETINA)
//
#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(scale:selector:)] && ([UIScreen mainScreen].scale == 2.0))

// Macro to determine if we have a retina display (retro version for less than iOS 7 apps)
// Tests that we have iOS 4.0 or above (by checking that displayLinkWithTarget is implemented) and that mainscreen.scale is 2.0.
// We have to test if we are on iOS 4.0 or above because iOS 3.2 which shipped with the original iPads incorrectly implements scale for apps running in 2x mode.
// #define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))
