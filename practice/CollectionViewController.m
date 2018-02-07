//
//  CollectionViewController.m
//  practice
//
//  Created by Jessie on 2018/2/6.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "CollectionViewController.h"
#import "CustomCollectionViewCell.h"
#import "TableViewController.h"
@interface CollectionViewController ()

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib=[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.collectionView.refreshControl=refreshControl;
    
}

-(void)refresh:(UIRefreshControl *)sender{
    TableViewController *vc= [[TableViewController alloc]init];
    [vc fetchData];
    [self.collectionView reloadData];
    [sender endRefreshing];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
 return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell=(CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    if(cell == nil){
        UINib *nib=[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil];
        [collectionView registerNib:nib forCellWithReuseIdentifier:@"Cell"];
        cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    }
    
    long targetRow = indexPath.row;
    for(int i = 0 ; i <[self.mediaList count] ;i++) {
        if (targetRow < [self.mediaList[i] count]) {
            // cell is here
            cell.collectionLabel.text = [self.mediaList[i] valueForKey:@"productName"][targetRow];
            //NSMutableArray *contentInfo = [self.mediaList[i] valueForKey:@"contentInfo"][targetRow][0];
            //NSLog(@"name: %@", [self.mediaList[i] valueForKey:@"productName"][targetRow]);
            //NSLog(@"info: %@", [self.mediaList[i] valueForKey:@"contentInfo"][targetRow][0]);
            //[[self.mediaList[i] valueForKey:@"contentInfo"][targetRow][0] valueForKey:@"metadata"];
            NSString *url=[[self.mediaList[i] valueForKey:@"contentInfo"][targetRow][0] valueForKeyPath:@"metadata.posterURL"];
            cell.collectionImageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
            cell.collectionImageView.layer.cornerRadius = 10;
            //NSLog(@"url: %@",[[[self.mediaList[i] valueForKey:@"contentInfo"][targetRow][0] valueForKey:@"metadata"] valueForKey:@"posterURL"]);
            //NSLog(@"url: %@",[[self.mediaList[i] valueForKey:@"contentInfo"][targetRow][0] valueForKeyPath:@"metadata.posterURL"]);
            //NSLog(@"url: %@", [contentInfo valueForKeyPath:@"metadata.posterURL"]);
            break;
        } else {
            targetRow -= [self.mediaList[i] count];
        }
        if (targetRow < 0 ) {
            NSLog(@"\ncannot find suitable row\n");
        }
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    size = CGSizeMake(100, 150);
    return size;
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
#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
