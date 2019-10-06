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
#import "ImageView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<ReusableScrollViewDelegate, ReusableScrollViewDataSource>

@property (nonatomic, strong) ReusableScrollView *reusableScrollView;
@property (nonatomic, strong) ReusableScrollView *reusableImageView;
@property (nonatomic, strong) NSArray *imageArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageArray = @[@"1",@"2",@"3",@"4",@"5"];
    // Do any additional setup after loading the view.
    self.reusableScrollView = [[ReusableScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, (kScreenHeight - 64) / 2)];
    self.reusableScrollView.delegate = self;
    self.reusableScrollView.dataSource = self;
    [self.view addSubview:self.reusableScrollView];
    
    self.reusableImageView = [[ReusableScrollView alloc] initWithFrame:CGRectMake(0, 64 + (kScreenHeight - 64) / 2 + 10, kScreenWidth, (kScreenHeight - 64) / 2 - 10)];
    self.reusableImageView.delegate = self;
    self.reusableImageView.dataSource = self;
    [self.view addSubview:self.reusableImageView];
    
    
}

- (UIView *)reusableScrollView:(ReusableScrollView *)reusableScrollView subviewAtIndex:(NSInteger)index {
    if ([reusableScrollView isEqual:self.reusableScrollView]) {
        ReusableView *view = [reusableScrollView dequeueReusableSubviewAtIndex:index];
        if (!view) {
            view = [ReusableView new];
            view.tag = index;
            NSLog(@"view %ld is created",(long)view.tag);
        }
        view.label.text = [NSString stringWithFormat:@"address is %p \r page index is %ld", view, (long)index];
        return view;
    } else {
        ImageView *view = [reusableScrollView dequeueReusableSubviewAtIndex:index];
        if (!view && index < self.imageArray.count) {
            view = [[ImageView alloc] initWithFrame:self.reusableImageView.frame];
            view.tag = index;
            NSLog(@"view %ld is created",(long)view.tag);
        }
        [view updateImageViewWithImage:self.imageArray[index]];
        return view;
    }
    
}

-(NSInteger)numberOfSubViewsInReusableScrollView:(ReusableScrollView *)reusableScrollView {
    if ([reusableScrollView isEqual:self.reusableScrollView]) {
        return 8;
    } else {
        return self.imageArray.count;
    }
}

- (void)reusableScrollView:(ReusableScrollView *)reusableScrollView didSelectSubviewAtIndex:(NSInteger)index {
    NSLog(@"selected index %ld", index);
}

@end
