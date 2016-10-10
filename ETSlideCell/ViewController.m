//
//  ViewController.m
//  ETSlideCell
//
//  Created by Ethan on 16/10/10.
//  Copyright © 2016年 ethan. All rights reserved.
//

#import "ViewController.h"
#import "ETSlideCell.h"
#import "ETSlideButtonItem.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[ETSlideCell class] forCellReuseIdentifier:@"234"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETSlideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"234"];
    cell.textLabel.text = @"111";
    NSMutableArray *array = [NSMutableArray new];
    ETSlideButtonItem *item0 = [ETSlideButtonItem new];
    item0.title = @"删除";
    item0.minWidth = 70;
    item0.backgroundColor = [UIColor redColor];
    item0.titleColor = [UIColor whiteColor];
    item0.actionBlock = ^(ETSlideCell *c) {
        NSLog(@"删除");
    };
    ETSlideButtonItem *item1 = [ETSlideButtonItem new];
    item1.title = @"确认";
    item1.minWidth = 70;
    item1.backgroundColor = [UIColor blueColor];
    item1.titleColor = [UIColor whiteColor];
    item1.actionBlock = ^(ETSlideCell *c) {
        NSLog(@"确认");
    };
    [array addObject:item0];
    [array addObject:item1];
    cell.items = array;
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
