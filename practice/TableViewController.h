//
//  TableViewController.h
//  practice
//
//  Created by Jessie on 2018/2/6.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController
@property NSMutableArray *mediaList;
@property NSMutableArray *dataArray;
-(void)fetchData;
@end
