//
//  collectViewController.h
//  practice
//
//  Created by Jessie on 2018/1/31.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface collectViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectview;
@property NSMutableArray *mediaList;
@end
