//
//  ViewController.h
//  practice
//
//  Created by Jessie on 2018/1/30.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *productName;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;



@end

