//
//  TWLastLevelView.h
//  TWLevelProgressView
//
//  Created by HaKim on 2017/7/10.
//  Copyright © 2017年 haKim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWCommonMacro.h"

@interface TWLastLevelView : UIView

@property (nonatomic, strong) id<TWLevelProgressViewDelegate> levelModel;

@property (nonatomic, assign) CGFloat progress;

@end
