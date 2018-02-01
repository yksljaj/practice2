//
//  collectViewController.m
//  practice
//
//  Created by Jessie on 2018/1/31.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "collectViewController.h"
#import "CollectionViewCell.h"
@interface collectViewController ()
{
    NSMutableArray *list;
}
@end

@implementation collectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    list=[NSMutableArray  new];
    [list addObject:@"1"];
    [list addObject:@"2"];
    [list addObject:@"3"];
    [list addObject:@"4"];
    [list addObject:@"5"];
    [list addObject:@"6"];
}


-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [list count];
}

-(nonnull UICollectionViewCell *) collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.label.text=[list objectAtIndex:indexPath.row];
    
    return  cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
