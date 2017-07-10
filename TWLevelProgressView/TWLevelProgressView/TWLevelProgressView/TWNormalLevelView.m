//
//  TWNormalLevelView.m
//  TWLevelProgressView
//
//  Created by HaKim on 2017/7/10.
//  Copyright © 2017年 haKim. All rights reserved.
//

#import "TWNormalLevelView.h"

@interface TWNormalLevelView ()

@property (nonatomic, weak) UILabel *levelLabel;

@property (nonatomic, assign) TWLevelItemType type;

@property (nonatomic, weak) UIView *line;

@end


@implementation TWNormalLevelView

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
    
    if(self.leftNeedCorner){
        CGFloat corner = self.bounds.size.height / 2;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                       byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft
                                                             cornerRadii:CGSizeMake(corner,corner)];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        
        maskLayer.frame = self.bounds;
        
        maskLayer.path = maskPath.CGPath;
        
        self.layer.mask = maskLayer;
    }
}

- (void)setLevelModel:(id<TWLevelProgressViewDelegate>)levelModel{
    _levelModel = levelModel;
    
    self.levelLabel.text = levelModel.levelText;
    
    [self layoutIfNeeded];
    [self setNeedsLayout];
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    // 根据进度，刷新自己状态
    [self updateType];
    
    [self updateStatusWithType];
}

#pragma mark - help method

- (void)updateStatusWithType{
    switch (self.type) {
        case TWLevelItemType_Default:
            self.levelLabel.textColor = [UIColor colorWithHex:0x999999];
            break;
        case TWLevelItemType_Current:
            self.levelLabel.textColor = [UIColor colorWithHex:0x3b384e];
            break;
        case TWLevelItemType_ToFull:
            self.levelLabel.textColor = [UIColor whiteColor];
            break;
        default:
            break;
    }
}

- (void)updateType{
    // 不在当前区间
    if(self.progress < self.levelModel.minValue){
        self.type = TWLevelItemType_Default;
        return;
    }
    
    // 超过自己最大区间
    if(self.progress >= self.levelModel.maxValue){
        self.type = TWLevelItemType_ToFull;
        return;
    }
    
    // 在自己的区间内
    CGFloat levelTextWidth = CGRectGetMaxX(self.levelLabel.frame);
    
    CGFloat progressWidth = CGRectGetWidth(self.bounds) * (self.progress - self.levelModel.minValue) / (self.levelModel.maxValue - self.levelModel.minValue);
    
    if(progressWidth >= levelTextWidth){
        self.type = TWLevelItemType_ToFull;
        return;
    }
    
    self.type = TWLevelItemType_Current;
}

#pragma mark - UI

- (void)commonInit{
    [self setupLine];
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
        make.centerX.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf);
        make.bottom.mas_equalTo(weakSelf);
    }];
}

- (void)setupLine{
    UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor whiteColor];
    [self addSubview:line];
    self.line = line;
    
    WeakSelf(weakSelf);
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf);
        make.bottom.mas_equalTo(weakSelf);
        make.right.mas_equalTo(weakSelf);
        make.width.mas_equalTo(kOnePixLine);
    }];
}


@end
