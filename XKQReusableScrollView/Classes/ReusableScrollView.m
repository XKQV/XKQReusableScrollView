//
//  ReusableScrollView.m
//  ReusableScrollView
//
//  Created by 董志玮 on 2019/8/19.
//  Copyright © 2019 Zhiwei. All rights reserved.
//

#import "ReusableScrollView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ReusableScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableSet *reusableSet;
@property (nonatomic, assign) NSUInteger lastIndex;
@property (nonatomic, assign) NSInteger numberOfViews;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ReusableScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.reusableSet = [NSMutableSet new];
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subviewSelected)];
        [self.scrollView addGestureRecognizer:tap];
    }
    return self;
}

- (void)subviewSelected {
    NSInteger index = self.scrollView.contentOffset.x / kScreenWidth;
    if (self.delegate && [self.delegate respondsToSelector:@selector(reusableScrollView:didSelectSubviewAtIndex:)]) {
        [self.delegate reusableScrollView:self didSelectSubviewAtIndex:index];
    }
}

- (void)setDelegate:(id<ReusableScrollViewDelegate>)delegate {
    _delegate = delegate;
    [self numberOfSubviewsInScrollView];
    [self prepareViewsForBothEndsAtIndex:0];
    [self setupViewAtIndex:0];
}

- (void)reuseViewWithIndex:(NSInteger)index {
    for (__kindof UIView *view in self.reusableSet) {
        if (view.tag == -1) {
            continue;
        }
        if (view.tag < index - 2 || view.tag > index + 2) {
            view.tag = -1 ;
//            [view removeFromSuperview];
        }
    }
}

- (__kindof UIView *)dequeueReusableSubviewAtIndex:(NSUInteger)index {
    for (UIView *view in self.reusableSet) {
        if (view.tag == index) {
            return view;
        }
        if (view.tag == -1) {
            view.tag = index;
            return view;
        }
    }
    return nil;
}

- (__kindof UIView *)subviewAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(reusableScrollView:subviewAtIndex:)]) {
        UIView *view = [self.delegate reusableScrollView:self subviewAtIndex:index];
        view.tag = index;
        [self.reusableSet addObject:view];
        return view;
    }
    return nil;
}

- (void)numberOfSubviewsInScrollView {
    if ([self.delegate respondsToSelector:@selector(numberOfSubViewsInReusableScrollView:)]) {
        self.numberOfViews = [self.delegate numberOfSubViewsInReusableScrollView:self];
        self.scrollView.contentSize = CGSizeMake(kScreenWidth * self.numberOfViews, kScreenHeight - 64);
    }
}

- (void)prepareViewsForBothEndsAtIndex:(NSInteger)index {
    BOOL leftReady = index == 0 ? YES : NO;
    BOOL rightReady = index == self.numberOfViews - 1 ? YES : NO;
    if (!leftReady) {
        [self setupViewAtIndex:index - 1];
    }
    if (!rightReady) {
        [self setupViewAtIndex:index + 1];
    }
}

- (void)setupViewAtIndex:(NSInteger)index {
    [self reuseViewWithIndex:index];
    UIView *view = [self subviewAtIndex:index];
    view.frame = CGRectMake(kScreenWidth * index, 0, kScreenWidth, kScreenHeight - 64);
    [self.scrollView addSubview:view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / kScreenWidth;
    if (self.lastIndex == index) {
        return;
    }
    self.lastIndex = index;
    [self prepareViewsForBothEndsAtIndex:index];
    [self setupViewAtIndex:index];    
}

@end
