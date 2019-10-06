//
//  ImageView.m
//  XKQReusableScrollView_Example
//
//  Created by XKQ on 2019/10/6.
//  Copyright © 2019 XKQ. All rights reserved.
//

#import "ImageView.h"

@interface ImageView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ImageView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    return _imageView;
}

- (void)updateImageViewWithImage:(NSString *)name {
    self.imageView.image = [UIImage imageNamed:name];
    
}

@end
