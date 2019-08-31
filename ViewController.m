//
//  ViewController.m
//  ReusableView
//
//  Created by Zhiwei on 2019/8/10.
//  Copyright © 2019 Zhiwei. All rights reserved.
//

#import "ViewController.h"
#import "ReusableView.h"
#import "ReusableScrollView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<ReusableScrollViewDelegate>

@property (nonatomic, strong) ReusableScrollView *reusableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.reusableView = [[ReusableScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.reusableView.delegate = self;
    [self.view addSubview:self.reusableView];
    
}

- (UIView *)reusableScrollView:(ReusableScrollView *)reusableScrollView subviewAtIndex:(NSInteger)index {
    ReusableView *view = [reusableScrollView dequeueReusableSubviewAtIndex:index];
    if (!view) {
        view = [ReusableView new];
        view.tag = index;
        NSLog(@"view %ld is created",(long)view.tag);
    }
    view.label.text = [NSString stringWithFormat:@"address is %p \r page index is %ld", view, (long)index];
    return view;
}

-(NSInteger)numberOfSubViewsInReusableScrollView:(ReusableScrollView *)reusableScrollView {
    return 8;
}

- (void)reusableScrollView:(ReusableScrollView *)reusableScrollView didSelectSubviewAtIndex:(NSInteger)index {
    NSLog(@"selected index %ld", index);
}

@end
