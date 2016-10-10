//
//  ETSlideCell.m
//  MyProject
//
//  Created by Ethan on 14-4-10.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import "ETSlideCell.h"
#import "ETSlideButtonItem.h"

#define WHOLE_TIME 0.3f
#define MAX_BUFFER_WIDTH 70.0f

@interface ETSlideCell()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIView *slideView;

@property (nonatomic, assign) CGFloat maxSlideWidth;

@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIView *buttonContent;
@property (nonatomic, strong) UIView *buttonContentOverlay;
@property (nonatomic, strong) UIView *overlay;

@property (nonatomic, strong) UIPanGestureRecognizer *closePan;
@property (nonatomic, strong) UITapGestureRecognizer *closeTap;
@property (nonatomic, strong) UILongPressGestureRecognizer *closeLongPress;

@property (nonatomic, strong) UIPanGestureRecognizer *slidePan;

@end

@implementation ETSlideCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.slideView = self.contentView;
        
        self.closePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_closeCellIfNeed:)];
        self.closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_closeCellIfNeed:)];
        self.closeLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_closeCellIfNeed:)];
        self.closeLongPress.minimumPressDuration = 0.1;
        self.closeLongPress.delegate = self;
        
        self.slidePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_pan:)];
        self.slidePan.delegate = self;
        [self.slideView addGestureRecognizer:self.slidePan];
        
        [self.overlay addSubview:self.buttonContentOverlay];
        [self.buttonContentOverlay addSubview:self.buttonContent];
        
    }
    
    return self;
}

#pragma mark - Private

- (void)_addButtonIfNeed {

    if (!self.overlay.superview) {
        
        self.maxSlideWidth = 0;
        
        self.overlay.frame = self.bounds;
        [self insertSubview:self.overlay belowSubview:self.slideView];
        
        __block CGFloat x = 0;
        [self.items enumerateObjectsUsingBlock:^(ETSlideButtonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.exclusiveTouch = YES;
            button.backgroundColor = obj.backgroundColor;
            [button setTitle:obj.title forState:UIControlStateNormal];
            [button setImage:obj.icon forState:UIControlStateNormal];
            button.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            button.titleLabel.font = obj.font ? : [UIFont systemFontOfSize:16.0f];
            [button setTitleColor:obj.titleColor forState:UIControlStateNormal];
            [button addTarget:self action:@selector(_buttonTap:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = idx;
            [self.buttons addObject:button];
            [self.buttonContent addSubview:button];
            
            CGSize size = [obj.title sizeWithFont:button.titleLabel.font];
            CGFloat imageWidth = obj.icon.size.width * [UIScreen mainScreen].scale;
            
            CGFloat width = size.width + imageWidth + 30;
            if (obj.minWidth > 0) {
                width = MAX(width, obj.minWidth);
            }
            if (obj.maxWidth) {
                width = MIN(width, obj.maxWidth);
            }
            self.maxSlideWidth += width;
            button.frame = CGRectMake(x, 0, width, self.buttonContent.height);
            
            x += button.width;
            
        }];
        self.buttonContentOverlay.frame = CGRectMake(self.overlay.width, 0, 0, self.overlay.height);
        self.buttonContent.frame = CGRectMake(self.buttonContentOverlay.width - self.maxSlideWidth, 0, self.maxSlideWidth, self.buttonContentOverlay.height);
    }
    
}

- (void)_changeState:(CGFloat)distance {
    if (distance > 0) {
        [self _close];
    } else {
        [self _open];
    }
}

- (void)_finishState {
    if (-self.slideView.left > self.maxSlideWidth/2) {
        [self _open];
    } else {
        [self _close];
    }
}

- (void)_open {
    
    if (self.slideView.left == -self.maxSlideWidth) {
        self.isOpen = YES;
        self.overlay.hidden = NO;
        return;
    }
    CGFloat distance = self.maxSlideWidth + self.slideView.left;
    if (distance < 0) {
        distance = MAX_BUFFER_WIDTH;
    }
    CGFloat time = distance/self.maxSlideWidth*WHOLE_TIME;
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.slideView.left = -self.maxSlideWidth;
        
        self.buttonContentOverlay.frame = CGRectMake(self.overlay.width + self.slideView.left, 0, -self.slideView.left, self.overlay.height);
        self.buttonContent.frame = CGRectMake(self.buttonContentOverlay.width - self.maxSlideWidth, 0, self.maxSlideWidth, self.buttonContentOverlay.height);
        
    } completion:^(BOOL finished) {
        self.isOpen = YES;
    }];
}

- (void)_close {
    
    [self.viewcontroller.view removeGestureRecognizer:self.closeLongPress];
    [self.viewcontroller.view removeGestureRecognizer:self.closeTap];
    [self.viewcontroller.view removeGestureRecognizer:self.closePan];
    
    if (self.slideView.left == 0) {
        self.isOpen = NO;
        self.overlay.hidden = YES;
        return;
    }
    CGFloat time = (-self.slideView.left)/self.maxSlideWidth*WHOLE_TIME;
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.slideView.left = 0;
        
        self.buttonContentOverlay.frame = CGRectMake(self.overlay.width + self.slideView.left, 0, -self.slideView.left, self.overlay.height);
        self.buttonContent.frame = CGRectMake(self.buttonContentOverlay.width - self.maxSlideWidth, 0, self.maxSlideWidth, self.buttonContentOverlay.height);
        
    } completion:^(BOOL finished) {
        self.isOpen = NO;
        self.overlay.hidden = YES;
    }];
}

#pragma mark - Selector

- (void)_buttonTap:(UIButton*)button {
    NSUInteger index = button.tag;
    ETSlideButtonItem *item = [self.items objectOrNilAtIndex:index];
    if (item.actionBlock) {
        item.actionBlock(self);
    }
    [self _close];
}

- (void)_closeCellIfNeed:(UIGestureRecognizer*)g {
    if (self.isOpen) {
        [self _close];
    }
}

- (void)_pan:(UIPanGestureRecognizer*)g {
    [self sendSubviewToBack:self.overlay];
    if (self.overlay.hidden) {
        self.overlay.hidden = NO;
    }

    CGPoint distance = [g translationInView:self.slideView];
    CGPoint velocity = [g velocityInView:self.slideView];
    
    if (g.state == UIGestureRecognizerStateBegan && self.slideView.left == 0) {
        if (self.isSelected) {
            self.selected = NO;
        }
        [self.viewcontroller.view addGestureRecognizer:self.closeLongPress];
        [self.viewcontroller.view addGestureRecognizer:self.closeTap];
        [self.viewcontroller.view addGestureRecognizer:self.closePan];
        [self _addButtonIfNeed];
    }

    if (g.state != UIGestureRecognizerStateEnded) {
        
        CGFloat x = (MAX_BUFFER_WIDTH + self.slideView.left + self.maxSlideWidth)/MAX_BUFFER_WIDTH;
        x = MIN(MAX(0, x), 1);
        self.slideView.left = -MAX(MIN(-(self.slideView.left + distance.x*x), self.maxSlideWidth + MAX_BUFFER_WIDTH), 0);
        
        self.buttonContentOverlay.frame = CGRectMake(self.overlay.width + self.slideView.left, 0, -self.slideView.left, self.overlay.height);
        self.buttonContent.frame = CGRectMake(self.buttonContentOverlay.width - self.maxSlideWidth, 0, self.maxSlideWidth, self.buttonContentOverlay.height);
        
    } else {
        if (fabs(velocity.x) > 1000) {
            [self _changeState:velocity.x];
        } else {
            [self _finishState];
        }
    }
    
    [g setTranslation:CGPointZero inView:self.slideView];
}

#pragma mark - GestureRecognizer Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.slidePan) {
        CGPoint distance = [self.slidePan translationInView:self.slideView];
        if (fabs(distance.y) > 0 || [self.slidePan locationInView:self.slideView].x < 30) {
            return NO;
        }
        
        return !self.isEditing;
    } else if (gestureRecognizer == self.closeLongPress) {
        CGPoint point = [self.closeLongPress locationInView:self.buttonContent];
        if (point.x >= 0 && point.y >= 0) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Getter & Setter

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray new];
    }
    return _buttons;
}

- (UIView *)buttonContent {
    if (!_buttonContent) {
        _buttonContent = [UIView new];
    }
    return _buttonContent;
}

- (UIView *)buttonContentOverlay {
    if (!_buttonContentOverlay) {
        _buttonContentOverlay = [UIView new];
        _buttonContentOverlay.layer.masksToBounds = YES;
    }
    return _buttonContentOverlay;
}

- (UIView *)overlay {
    if (!_overlay) {
        _overlay = [UIView new];
    }
    return _overlay;
}

- (void)setItems:(NSArray<ETSlideButtonItem *> *)items {
    _items = items;
    if (self.overlay.superview) {
        [self.buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.buttons removeAllObjects];
        [self.overlay removeFromSuperview];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
