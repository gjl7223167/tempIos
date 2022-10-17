//
//  HXPhotoDefine.h
//  微博照片选择
//
//  Created by 洪欣 on 2017/11/24.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#ifndef HXPhotoDefine_h
#define HXPhotoDefine_h

// 日志输出
#ifdef DEBUG
#define NSSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSSLog(...)
#endif


////底部的安全距离
#define kBottomSafeAreaHeight [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom
//顶部的安全距离
#define kTopMargin (kBottomSafeAreaHeight == 0 ? 0 : 24)
//状态栏高度
#define kStatusBarHeight (kBottomSafeAreaHeight == 0 ? 20 : 44)
//导航栏高度
#define kNavigationBarHeight (kBottomSafeAreaHeight == 0 ? 64 : 88)
//tabbar高度
#define kBottomMargin (kBottomSafeAreaHeight + 49)

#define iOS11_Later ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f)

#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

#define iOS9_Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)

#define iOS8_2Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.2f)

#endif /* HXPhotoDefine_h */
