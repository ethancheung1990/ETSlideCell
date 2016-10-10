//
//  ETSlideButtonItem.h
//  MyProject
//
//  Created by Ethan on 16/8/16.
//  Copyright © 2016年 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ETSlideCell;

typedef void(^SlideButtonActionBlock)(ETSlideCell *c);

@interface ETSlideButtonItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, assign) CGFloat minWidth;
@property (nonatomic, assign) CGFloat maxWidth;

@property (nonatomic, copy) SlideButtonActionBlock actionBlock;

@end
