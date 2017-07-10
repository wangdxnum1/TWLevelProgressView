//
//  UIColor+Utility.h
//  GushiJianghu
//
//  Created by Wang on 15/8/29.
//  Copyright (c) 2015年 com.jijinwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utility)

/**
 *  get UIColor with Hex string,like #ffffff
 *
 *  @param hexColor Hex string #ffffff
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString*)hexColor;

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHex:(int)hexValue;

@end
