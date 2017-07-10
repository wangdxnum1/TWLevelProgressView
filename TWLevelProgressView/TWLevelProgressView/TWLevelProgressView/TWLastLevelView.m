//
//  TWLastLevelView.m
//  TWLevelProgressView
//
//  Created by HaKim on 2017/7/10.
//  Copyright © 2017年 haKim. All rights reserved.
//

#import "TWLastLevelView.h"

@interface TWLastLevelView ()

@property (nonatomic, weak) UILabel *levelLabel;

@end

@implementation TWLastLevelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat offset = self.bounds.size.width * 0.215;
    
    CGFloat middleOffset = (self.bounds.size.width - self.levelLabel.bounds.size.width) / 2;
    
    offset = MIN(offset, middleOffset);
    
    WeakSelf(weakSelf);
    [self.levelLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).with.offset(offset);
    }];
}

- (void)setLevelModel:(id<TWLevelProgressViewDelegate>)levelModel{
    _levelModel = levelModel;
    
    self.levelLabel.text = levelModel.levelText;
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    if(progress >= self.levelModel.minValue){
        self.levelLabel.textColor = [UIColor colorWithHex:0x3b384e];
    }else{
        self.levelLabel.textColor = [UIColor colorWithHex:0x999999];
    }
}

#pragma mark - UI

- (void)commonInit{
    [self setupLevelLabel];
}

- (void)setupLevelLabel{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithHex:0x999999];
    label.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:label];
    self.levelLabel = label;
    WeakSelf(weakSelf);
    
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf);
        make.bottom.mas_equalTo(weakSelf);
    }];
}


@end
