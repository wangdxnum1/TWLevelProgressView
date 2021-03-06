//
//  TWLevelTestModel.h
//  TWLevelProgressView
//
//  Created by HaKim on 2017/7/10.
//  Copyright © 2017年 haKim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWLevelProgressViewDelegate.h"

@interface TWLevelTestModel : NSObject<TWLevelProgressViewDelegate>

@property (nonatomic, assign) CGFloat minValue;

@property (nonatomic, assign) CGFloat maxValue;

@property (nonatomic, copy) NSString *levelText;

@property (nonatomic, copy) NSString *minValueText;

@property (nonatomic, copy) NSString *maxValueText;

@end
