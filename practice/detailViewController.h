//
//  detailViewController.h
//  practice
//
//  Created by Jessie on 2018/2/7.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailViewController : UIViewController<UIScrollViewDelegate>
//@property (strong, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property long current_row;
@property NSMutableArray *mediaList;
@end
