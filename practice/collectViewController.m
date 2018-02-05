//
//  collectViewController.m
//  practice
//
//  Created by Jessie on 2018/1/31.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "collectViewController.h"
#import "CustomCollectionViewCell.h"
@interface collectViewController ()
{
    NSMutableArray *list;
    NSMutableArray *pn;
}
@end

@implementation collectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib=[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil];
    [_collectview registerNib:nib forCellWithReuseIdentifier:@"Cell"];
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
    int count=0;
    for(int i=0;i<[self.mediaList count];i++){
        if ([self.mediaList[i] valueForKey:@"productName"] !=[NSNull null]) {
            NSArray *pn=[self.mediaList[i] valueForKey:@"productName"];
            count+=[pn count];
        }
        
    }
    NSLog(@"%d",count);
    return count;
}

-(nonnull UICollectionViewCell *) collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    static NSString *identifier=@"Cell";
    CustomCollectionViewCell *cell=[_collectview dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if(cell == nil){
        UINib *nib=[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil];
        [_collectview registerNib:nib forCellWithReuseIdentifier:identifier];
        cell=[_collectview dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    }
    
    pn=[NSMutableArray new];
    NSMutableArray *posterURL=[NSMutableArray new];
    for(int i=0;i<[self.mediaList count];i++){
        if ([self.mediaList[i] valueForKey:@"productName"] !=[NSNull null]) {
            NSMutableArray *temp=[self.mediaList[i] valueForKey:@"productName"];
            [pn addObjectsFromArray:temp];
            
            NSMutableArray *contentInfo=[self.mediaList[i] valueForKey:@"contentInfo"];
            
            for(int j=0;j<[contentInfo count];j++){
                if([contentInfo[j] count]>1){
                    NSString *test=[[[self.mediaList[i] valueForKey:@"contentInfo"][j] valueForKey:@"metadata"][0] valueForKey:@"posterURL"];
                    NSLog(@"test:%@",test);
                    [posterURL addObject:test];
                }else{
                    NSMutableArray *url=[[[self.mediaList[i] valueForKey:@"contentInfo"][j] valueForKey:@"metadata"]valueForKey:@"posterURL"];
                    [posterURL addObjectsFromArray:url];
                    
                }
            }
        }
    }
    
    cell.collectionImageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                           [NSURL URLWithString:[posterURL objectAtIndex:indexPath.row]]]];
    cell.collectionImageView.layer.cornerRadius = 10;
    cell.collectionLabel.text=[pn objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    size = CGSizeMake(100, 150);
    return size;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView  layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edge = UIEdgeInsetsMake(20, 20, 0, 20);
    return edge;
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
