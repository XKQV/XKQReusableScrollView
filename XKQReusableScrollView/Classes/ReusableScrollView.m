//
//  ReusableScrollView.m
//  ReusableScrollView
//
//  Created by 董志玮 on 2019/8/19.
//  Copyright © 2019 Zhiwei. All rights reserved.
//

#import "ReusableScrollView.h"

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
        _reusableSet = [NSMutableSet new];
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subviewSelected)];
        [_scrollView addGestureRecognizer:tap];
    }
    return self;
}

- (void)setDelegate:(id<ReusableScrollViewDelegate>)delegate {
    _delegate = delegate;
}

- (void)setDataSource:(id<ReusableScrollViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self numberOfSubviewsInScrollView];
    [self prepareViewsForBothEndsAtIndex:0];
    [self setupViewAtIndex:0];
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

- (void)reuseViewWithIndex:(NSInteger)index {
    for (__kindof UIView *view in self.reusableSet) {
        if (view.tag == -1) {
            continue;
        }
        if (view.tag < index - 2 || view.tag > index + 2) {
            view.tag = -1 ;
        }
    }
}

- (void)setupViewAtIndex:(NSInteger)index {
    [self reuseViewWithIndex:index];
    UIView *view = [self subviewAtIndex:index];
    view.frame = CGRectMake(self.frame.size.width * index, 0, self.frame.size.width, self.frame.size.height);
    [self.scrollView addSubview:view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / self.frame.size.width;
    if (self.lastIndex == index) {
        return;
    }
    self.lastIndex = index;
    [self prepareViewsForBothEndsAtIndex:index];
    [self setupViewAtIndex:index];
}

#pragma mark - ReusableScrollViewDataSource

- (__kindof UIView *)subviewAtIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(reusableScrollView:subviewAtIndex:)]) {
        UIView *view = [self.dataSource reusableScrollView:self subviewAtIndex:index];
        view.tag = index;
        [self.reusableSet addObject:view];
        return view;
    }
    return nil;
}

- (void)numberOfSubviewsInScrollView {
    if ([self.dataSource respondsToSelector:@selector(numberOfSubViewsInReusableScrollView:)]) {
        self.numberOfViews = [self.dataSource numberOfSubViewsInReusableScrollView:self];
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width * self.numberOfViews, self.frame.size.height);
    }
}

#pragma mark - ReusableScrollViewDelegate

- (void)subviewSelected {
    NSInteger index = self.scrollView.contentOffset.x / self.frame.size.width;
    if (self.delegate && [self.delegate respondsToSelector:@selector(reusableScrollView:didSelectSubviewAtIndex:)]) {
        [self.delegate reusableScrollView:self didSelectSubviewAtIndex:index];
    }
}


@end
