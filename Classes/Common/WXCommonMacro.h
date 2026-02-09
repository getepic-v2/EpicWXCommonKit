//
//  WXCommonMacro.h
//  Pods
//
//  Created by TAL on 2026/2/5.
//

#ifndef WXCommonMacro_h
#define WXCommonMacro_h

#define WeakObj(obj)                autoreleasepool{} __weak __typeof(obj) obj##Weak = obj;

#define kAppScheme @"xesscienceexercise"

#endif /* WXCommonMacro_h */
