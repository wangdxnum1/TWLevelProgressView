//
//  ViewController.m
//  TWLevelProgressView
//
//  Created by HaKim on 2017/7/10.
//  Copyright © 2017年 haKim. All rights reserved.
//

#import "ViewController.h"
#import "TWLevelProgressView.h"
#import "TWCommonMacro.h"
#import "TWLevelTestModel.h"

@interface ViewController ()

@property (nonatomic, weak) TWLevelProgressView *levelView;

@property (nonatomic, strong) NSMutableArray *levles;

@property (nonatomic, assign) CGFloat progress;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self commonInit];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setupProgress:(UIButton *)sender {
    self.progress = arc4random() % 101;
    [self.levelView setProgress:self.progress animated:YES];
}

#pragma mark  - UI
- (void)commonInit{
    // level view
    [self setupLevleView];
}

- (void)setupLevleView{
    TWLevelProgressView *levelView = [[TWLevelProgressView alloc] init];
    [self.view addSubview:levelView];
    self.levelView = levelView;
    
    WeakSelf(weakSelf);
    [self.levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).with.offset(100);
        make.left.equalTo(weakSelf.view).with.offset(0);
        make.right.equalTo(weakSelf.view).with.offset(0);
        make.height.mas_equalTo(54);
    }];
    
    
    // 设置等级块
    self.levelView.levelItemModels = self.levles.copy;
}

#pragma mark get & set method

- (NSMutableArray*)levles{
    if(_levles == nil){
        TWLevelTestModel *m1 = [[TWLevelTestModel alloc] init];
        m1.minValue = 0;
        m1.maxValue = 2;
        m1.minValueText = @"0";
        m1.maxValueText = @"2";
        m1.levelText = @"普通";
        
        TWLevelTestModel *m2 = [[TWLevelTestModel alloc] init];
        m2.minValue = 2;
        m2.maxValue = 5;
        m2.minValueText = @"2";
        m2.maxValueText = @"5";
        m2.levelText = @"V1";
        
        
        TWLevelTestModel *m3 = [[TWLevelTestModel alloc] init];
        m3.minValue = 5;
        m3.maxValue = 10;
        m3.minValueText = @"5";
        m3.maxValueText = @"10";
        m3.levelText = @"V2";
        
        
        TWLevelTestModel *m4 = [[TWLevelTestModel alloc] init];
        m4.minValue = 10;
        m4.maxValue = 25;
        m4.minValueText = @"10";
        m4.maxValueText = @"25";
        m4.levelText = @"V3";
        
        TWLevelTestModel *m5 = [[TWLevelTestModel alloc] init];
        m5.minValue = 25;
        m5.maxValue = 50;
        m5.minValueText = @"25";
        m5.maxValueText = @"50";
        m5.levelText = @"V4";
        
        TWLevelTestModel *m6 = [[TWLevelTestModel alloc] init];
        m6.minValue = 50;
        m6.maxValue = 100;
        m6.minValueText = @"50";
        m6.maxValueText = @"100";
        m6.levelText = @"V5";
        
        TWLevelTestModel *m7 = [[TWLevelTestModel alloc] init];
        m7.minValue = 100;
        m7.maxValue = 0; // 表示无限大
        m7.minValueText = @"100";
        m7.levelText = @"V7";
        
        
        _levles = @[m1,m2,m3,m4,m5,m6,m7].mutableCopy;
    }
    return _levles;
}

@end
