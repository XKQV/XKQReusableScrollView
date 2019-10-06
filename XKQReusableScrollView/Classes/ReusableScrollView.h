//
//  ReusableScrollView.h
//  ReusableScrollView
//
//  Created by 董志玮 on 2019/8/19.
//  Copyright © 2019 Zhiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ReusableScrollView;

@protocol ReusableScrollViewDataSource <NSObject>

- (__kindof UIView *)reusableScrollView:(ReusableScrollView *)reusableScrollView subviewAtIndex:(NSInteger)index;

- (NSInteger)numberOfSubViewsInReusableScrollView:(ReusableScrollView *)reusableScrollView;

@end

@protocol ReusableScrollViewDelegate<NSObject, UIScrollViewDelegate>

- (void)reusableScrollView:(ReusableScrollView *)reusableScrollView didSelectSubviewAtIndex:(NSInteger)index;

@end

@interface ReusableScrollView : UIView

@property (nonatomic, strong) id<ReusableScrollViewDelegate>delegate;
@property (nonatomic, strong) id<ReusableScrollViewDataSource>dataSource;

- (__kindof UIView *)dequeueReusableSubviewAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
