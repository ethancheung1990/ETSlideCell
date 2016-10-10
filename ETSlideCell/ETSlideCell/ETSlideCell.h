//
//  ETSlideCell.h
//  MyProject
//
//  Created by Ethan on 14-4-10.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ETSlideButtonItem;

@interface ETSlideCell : UITableViewCell

@property (nonatomic, copy) NSArray<ETSlideButtonItem*> *items;

@end