//
//  TWLevelProgressView.m
//  TWLevelProgressView
//
//  Created by HaKim on 2017/7/10.
//  Copyright © 2017年 haKim. All rights reserved.
//

#import "TWLevelProgressView.h"
#import "TWNormalLevelView.h"
#import "TWLastLevelView.h"

@interface TWLevelProgressView ()

// 进度条的contentView
@property (nonatomic, weak) UIView *contentView;

// level高度
@property (nonatomic, assign) CGFloat levleHeight;

// 普通的level块的宽度
@property (nonatomic, assign) CGFloat normalLevelWidth;

// 最后的level 与普通level之间的比例
@property (nonatomic, assign) CGFloat lastOneRate;

@property (nonatomic, strong) UIColor *progressColor;

@property (nonatomic, strong) NSMutableArray *normalLevels;

@property (nonatomic, weak) TWLastLevelView *lastLevelView;

// 进度条
@property (nonatomic, strong) CAShapeLayer *progressLayer;

// 指示块
@property (nonatomic, weak) UIView *indicateContentView;
@property (nonatomic, weak) CAShapeLayer *indicateLayer;

// 刻度
@property (nonatomic, weak) UIView *scaleContentView;
@property (nonatomic, strong) NSMutableArray *scales;

// 渐变
@property (nonatomic, weak) CAGradientLayer *gradientLayer;

// 最后一个进度条显示的宽度
@property (nonatomic, assign) CGFloat lastProgressWidth;

// 滑块的宽度
@property (nonatomic, assign) CGFloat slideWidth;

@property (nonatomic, assign) CGFloat animatedTime;

// 进度
@property (nonatomic, assign) CGFloat progress;

@end


@implementation TWLevelProgressView

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
    
    // 左边的圆角
    CGFloat corner = self.contentView.bounds.size.height / 2;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds
                                                   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft
                                                         cornerRadii:CGSizeMake(corner,corner)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.contentView.layer.mask = maskLayer;
    
    // 渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHex:0xe5e5e5].CGColor, (__bridge id)[UIColor colorWithHex:0xEFEFF4].CGColor];
    gradientLayer.locations = @[@0.9,@1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = self.contentView.bounds;
    
    [self.contentView.layer insertSublayer:gradientLayer atIndex:0];
    self.gradientLayer = gradientLayer;
    
    // 指示器(三角形)
    [self indicateLayer];
}

- (void)setLevelItemModels:(NSArray *)levelItemModels{
    if(!levelItemModels ||levelItemModels.count == 0) return;

    _levelItemModels = [levelItemModels copy];
    
    // level块的宽度
    self.normalLevelWidth = (kScreenWidth - 32) / (self.levelItemModels.count - 1 + 1.795);
    
    // 等级块
    [self setupNormalLevelView];
    
    // 刻度显示
    [self setupScales];
}

#pragma mark - help method
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    self.progress = progress;
    
    // 计算进度条位置
    __block CGFloat progressWidth = 0;
    
    [self.levelItemModels enumerateObjectsUsingBlock:^(id<TWLevelProgressViewDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(idx == self.levelItemModels.count - 1){
            // 最后一个
            progressWidth += self.lastProgressWidth;
            return;
        }
        
        if(self.progress >= obj.maxValue){
            progressWidth += self.normalLevelWidth;
            return;
        }
        
        CGFloat rate = (self.progress - obj.minValue) / (obj.maxValue - obj.minValue);
        progressWidth += (self.normalLevelWidth * rate);
        *stop = YES;
    }];
    
    
    CGRect rect = self.bounds;
    CGRect rect0 = CGRectMake(0, 0, 0, rect.size.height);
    CGRect rect1 = CGRectMake(0, 0, progressWidth, rect.size.height);
    
    UIBezierPath *end = [UIBezierPath bezierPathWithRect:rect1];
    
    self.progressLayer.path = end.CGPath;
    
    self.indicateLayer.position = CGPointMake(progressWidth - self.slideWidth / 2, 0);
    
    if(animated){
        self.animatedTime *= (progressWidth / CGRectGetWidth(self.contentView.bounds));
        self.animatedTime = (self.animatedTime > 0.6) ? : 0.6;
        
        UIBezierPath *start = [UIBezierPath bezierPathWithRect:rect0];
        CABasicAnimation *a = [CABasicAnimation animationWithKeyPath:@"path"];
        a.duration = self.animatedTime;
        a.fromValue = (__bridge id)start.CGPath;
        a.toValue = (__bridge id)end.CGPath;
        a.fillMode = kCAFillModeForwards;
        a.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        [self.progressLayer addAnimation:a forKey:nil];
        
        CABasicAnimation *indicatA = [CABasicAnimation animationWithKeyPath:@"position"];
        indicatA.duration = self.animatedTime;
        indicatA.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
        indicatA.toValue = [NSValue valueWithCGPoint:CGPointMake(progressWidth - self.slideWidth / 2, 0)];
        
        indicatA.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [self.indicateLayer addAnimation:indicatA forKey:nil];
    }
    
    // 跟新进度条状态，文字之类的,普通
    for (TWNormalLevelView *view in self.normalLevels) {
        view.progress = self.progress;
    }
    
    // 最后一个
    self.lastLevelView.progress = progress;
}


#pragma mark - UI

- (void)commonInit{
    self.backgroundColor = [UIColor colorWithHex:0xEFEFF6];
    
    self.lastOneRate = 1.795;
    
    self.levleHeight = 24;
    
    self.progressColor = [UIColor colorWithHex:0xaa8951];
    
    self.lastProgressWidth = 10;
    
    self.slideWidth = 9.0;
    
    self.animatedTime = 2.0;
    
    [self setupIndicateContentView];
    [self setupContentView];
    
    [self setScaleContentView];
}

// 指示块进度条
- (void)setupIndicateContentView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:view];
    self.indicateContentView = view;
    WeakSelf(weakSelf);
    [self.indicateContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf).with.offset(0);
        make.left.mas_equalTo(weakSelf).with.offset(16);
        make.right.mas_equalTo(weakSelf).with.offset(-16);
        make.height.mas_equalTo(6);
    }];
}

// 等级进度条
- (void)setupContentView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:view];
    self.contentView = view;
    WeakSelf(weakSelf);
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.indicateContentView.mas_bottom).with.offset(2);
        make.left.mas_equalTo(weakSelf.indicateContentView);
        make.right.mas_equalTo(weakSelf.indicateContentView);
        make.height.mas_equalTo(weakSelf.levleHeight);
    }];
    
    view.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
}

// 刻度
- (void)setScaleContentView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:view];
    self.scaleContentView = view;
    WeakSelf(weakSelf);
    [self.scaleContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf);
        make.left.mas_equalTo(weakSelf.indicateContentView);
        make.right.mas_equalTo(weakSelf.indicateContentView);
        make.height.mas_equalTo(12);
    }];
}

- (void)setupNormalLevelView{
    for(int i = 0;i < self.levelItemModels.count - 1; ++i){
        TWNormalLevelView *level = [self createNormalViewWithIndex:i];
        
        id<TWLevelProgressViewDelegate> levelModel = [self.levelItemModels objectAtIndex:i];
        
        level.levelModel = levelModel;
        
        [self.normalLevels addObject:level];
    }
    
    TWLastLevelView *last = [[TWLastLevelView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:last];
    self.lastLevelView = last;
    last.levelModel = [self.levelItemModels lastObject];
    
    UIView *pre = [self.normalLevels lastObject];
    
    WeakSelf(weakSelf);
    [last mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentView);
        make.bottom.mas_equalTo(weakSelf.contentView);
        make.left.mas_equalTo(pre.mas_right);
        make.right.mas_equalTo(weakSelf.contentView);
    }];
}

- (void)setupScales{
    for(int i = 0;i < 7; ++i){
        UILabel *scale = [self createScaleLabelWithIndex:i];
        [self.scales addObject:scale];
        
        id<TWLevelProgressViewDelegate> levelModel = nil;
        if(i == 0){
            levelModel = [self.levelItemModels objectAtIndex:i];
            scale.text = levelModel.minValueText;
            
        }else{
            levelModel = [self.levelItemModels objectAtIndex:i-1];
            scale.text = levelModel.maxValueText;
        }
    }
}

- (TWNormalLevelView*)createNormalViewWithIndex:(NSInteger)index{
    TWNormalLevelView *level = [[TWNormalLevelView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:level];
    
    WeakSelf(weakSelf);
    [level mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentView);
        make.bottom.mas_equalTo(weakSelf.contentView);
        make.left.mas_equalTo(weakSelf.contentView).with.offset(weakSelf.normalLevelWidth * index);
        make.width.mas_equalTo(weakSelf.normalLevelWidth);
    }];
    if(index == 0){
        level.leftNeedCorner = YES;
    }
    
    return level;
}

- (UILabel*)createScaleLabelWithIndex:(NSInteger)index{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithHex:0x666666];
    [self.scaleContentView addSubview:label];
    label.textAlignment = (index == 0) ? NSTextAlignmentLeft : NSTextAlignmentCenter;
    
    WeakSelf(weakSelf);
    
    TWNormalLevelView *preView = nil;
    if(index == 0){
        preView = [self.normalLevels objectAtIndex:0];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(preView);
            make.top.mas_equalTo(weakSelf.scaleContentView);
            make.bottom.mas_equalTo(weakSelf.scaleContentView);
        }];
    }else{
        preView = [self.normalLevels objectAtIndex:index - 1];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(preView.line);
            make.top.mas_equalTo(weakSelf.scaleContentView);
            make.bottom.mas_equalTo(weakSelf.scaleContentView);
        }];
    }
    
    return label;
}

#pragma mark - get & set method

- (NSMutableArray*)normalLevels{
    if(_normalLevels == nil){
        _normalLevels = [NSMutableArray array];
    }
    return _normalLevels;
}

- (NSMutableArray*)scales{
    if(_scales == nil){
        _scales = [NSMutableArray array];
    }
    return _scales;
}

- (CAShapeLayer*)progressLayer{
    if(_progressLayer == nil){
        CAShapeLayer *layer = [CAShapeLayer layer];
        
        CGRect rect = self.contentView.bounds;
        rect.size.width = 0;
        
        CGFloat corner = self.bounds.size.height / 2;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft
                                                         cornerRadii:CGSizeMake(corner, corner)];
        
        layer.fillColor = [UIColor orangeColor].CGColor;
        layer.path = path.CGPath;
        
        [self.contentView.layer insertSublayer:layer above:self.gradientLayer];
        self.progressLayer = layer;
    }
    return _progressLayer;
}

- (CAShapeLayer*)indicateLayer{
    if(_indicateLayer == nil){
        CAShapeLayer *layer = [CAShapeLayer layer];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(self.slideWidth, 0)];
        [path addLineToPoint:CGPointMake(self.slideWidth / 2, 6)];
        [path closePath];
        
        layer.fillColor = [UIColor orangeColor].CGColor;
        
        layer.path = path.CGPath;
        [self.indicateContentView.layer addSublayer:layer];
        self.indicateLayer = layer;
    }
    return _indicateLayer;
}

@end
