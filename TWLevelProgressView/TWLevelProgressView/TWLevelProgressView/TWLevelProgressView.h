//
//  TWLevelProgressView.h
//  TWLevelProgressView
//
//  Created by HaKim on 2017/7/10.
//  Copyright © 2017年 haKim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWLevelProgressView : UIView

@property (nonatomic, strong) NSArray *levelItemModels;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
