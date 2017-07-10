//
//  TWNormalLevelView.h
//  TWLevelProgressView
//
//  Created by HaKim on 2017/7/10.
//  Copyright © 2017年 haKim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWCommonMacro.h"

@interface TWNormalLevelView : UIView

@property (nonatomic, strong) id<TWLevelProgressViewDelegate> levelModel;

@property (nonatomic, assign) CGFloat progress;

// 外界用的两个属性，待优化
@property (nonatomic, assign) BOOL leftNeedCorner;
@property (nonatomic, weak,readonly) UIView *line;

@end
