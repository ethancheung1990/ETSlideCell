//
//  ETSlideButtonItem.m
//  MyProject
//
//  Created by Ethan on 16/8/16.
//  Copyright © 2016年 ethan. All rights reserved.
//

#import "ETSlideButtonItem.h"

@implementation ETSlideButtonItem

- (UIColor *)titleColor {
    if (!_titleColor) {
        return [UIColor whiteColor];
    }
    return _titleColor;
}

@end
