//
//  GroupDetailsTableViewController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/10/24.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "GroupDetailsTableViewController.h"

@interface GroupDetailsTableViewController ()

@end

@implementation GroupDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
}


-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    NSLog(@"%@",dataArray);
    dispatch_async(dispatch_get_main_queue(), ^{
         [self.tableView reloadData];
    });

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

@end
