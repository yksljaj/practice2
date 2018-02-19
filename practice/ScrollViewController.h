//
//  ScrollViewController.h
//  practice
//
//  Created by Jessie on 2018/2/14.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollViewController : UIViewController<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property long current_row;
@property NSMutableArray *mediaList;
@end
