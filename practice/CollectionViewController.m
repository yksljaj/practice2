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
#import "detailViewController.h"
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
    
    if (@available(iOS 10.0, *)) {
        self.collectionView.refreshControl=refreshControl;
    } else {
        [self.collectionView addSubview:(refreshControl)];
    }
    
    
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
 return [self.mediaList count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int count=0;
    NSLog(@"getrow at section: %lu", section);
    if (section < [self.mediaList count]) {
        NSArray *pnArr = [self.mediaList[section] valueForKey:@"productName"];
        if (![pnArr isEqual:[NSNull null]]) {
            NSLog(@"    ==> section # %lu has %lu  productNames", section, (unsigned long)[pnArr count]);
            count = [pnArr count];
        } else {
            NSLog(@"    ==> section # %lu has null array", section);
        }
    }
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
    long targetSec = indexPath.section;
    NSLog(@"prepare cell @section: %lu, @row: %lu", targetSec, targetRow);
    cell.collectionLabel.text = [self.mediaList[targetSec] valueForKey:@"productName"][targetRow];
    NSString *url=[[self.mediaList[targetSec] valueForKey:@"contentInfo"][targetRow][0] valueForKeyPath:@"metadata.posterURL"];
    cell.collectionImageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    cell.collectionImageView.layer.cornerRadius = 10;
    
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    CustomCollectionViewCell *selectCell =[collectionView cellForItemAtIndexPath:indexPath];
    selectCell.backgroundColor = [UIColor lightGrayColor]; // highlight selection
    
    NSInteger rowCount = 0;
    for (NSInteger i = 0 ; i < indexPath.section; i ++) {
        rowCount += [collectionView numberOfItemsInSection:i];
    }
    rowCount=rowCount+indexPath.row;
    detailViewController *dvc=[[detailViewController alloc] initWithNibName:@"detailViewController" bundle:nil];
    long current_row=rowCount;
    dvc.current_row=current_row;
    dvc.mediaList=self.mediaList;
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *diddeselectedCell =[collectionView cellForItemAtIndexPath:indexPath];
    diddeselectedCell.backgroundColor = [UIColor clearColor];
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
