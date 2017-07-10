//
//  TWCommonMacro.h
//  TWLevelProgressView
//
//  Created by HaKim on 2017/7/10.
//  Copyright © 2017年 haKim. All rights reserved.
//

#ifndef TWCommonMacro_h
#define TWCommonMacro_h

#import "TWLevelProgressViewDelegate.h"
#import "Masonry.h"
#import "UIColor+Utility.h"

#define WeakSelf(weakSelf)      __weak __typeof(&*self)weakSelf = self;
#define kOnePixLine         (1.0/[UIScreen mainScreen].scale)

//device screen size
#define kScreenWidth               [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight              [[UIScreen mainScreen] bounds].size.height

// 每一格level的状态
typedef NS_ENUM(NSInteger, TWLevelItemType) {
    TWLevelItemType_Default, // 默认状态，即没有进度
    TWLevelItemType_Current, // 在当前区间内，但是内有超过文字的右边界
    TWLevelItemType_ToFull,  // 超过文字的右边界
};



#endif /* TWCommonMacro_h */
