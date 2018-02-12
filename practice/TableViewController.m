//
//  TableViewController.m
//  practice
//
//  Created by Jessie on 2018/2/6.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "TableViewController.h"
#import "CustomTableCell.h"
#import "CollectionViewController.h"
#import "detailViewController.h"
@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mediaList=[NSMutableArray new];
    [self fetchData];
    self.refreshControl=[UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    
}

-(void)fetchData{
    NSURL *url=[NSURL URLWithString:@"http://stg.render.ott.hinet.net/chtvideoApi/getRecommend.do?version=1.3&categoryId=/%E9%A6%96%E9%A0%81"];
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session=[NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error ==nil){
            NSString *html=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //NSLog(@"%@",html);
        }else{
            NSLog(@"下載錯誤:%@",error);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            self.mediaList=[[jsonObj objectForKey:@"recommendInfo"] valueForKey:@"mediaList"];
            
            //pass data to collectionViewController
            UINavigationController *navcvc=self.navigationController.parentViewController.childViewControllers[1];
            CollectionViewController *cvc=navcvc.viewControllers[0];
            cvc.mediaList=self.mediaList;
            
            [self.tableView reloadData];
        });
        
    }];
    [dataTask resume];
}

-(void)refresh{
    [self fetchData];
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.mediaList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier=@"Cell";
    CustomTableCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        UINib *nib=[UINib nibWithNibName:@"CustomTableCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    long targetRow = indexPath.row;
    long targetSec = indexPath.section;
    //NSLog(@"prepare cell @section: %lu, @row: %lu", targetSec, targetRow);
    cell.label.text = [self.mediaList[targetSec] valueForKey:@"productName"][targetRow];
    NSString *url=[[self.mediaList[targetSec] valueForKey:@"contentInfo"][targetRow][0] valueForKeyPath:@"metadata.posterURL"];
    cell.imageview.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    cell.imageview.layer.cornerRadius = 10;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 128;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger rowCount = 0;
    for (NSInteger i = 0 ; i < indexPath.section; i ++) {
        rowCount += [tableView numberOfRowsInSection:i];
    }
    rowCount=rowCount+indexPath.row;
    detailViewController *dvc=[[detailViewController alloc] initWithNibName:@"detailViewController" bundle:nil];
    dvc.current_row=rowCount;
    dvc.mediaList=self.mediaList;
    [self.navigationController pushViewController:dvc animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
