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
            
            CollectionViewController *cvc=self.tabBarController.viewControllers[1];
            cvc.mediaList=self.mediaList;
            
            [self.tableView reloadData];
        });
        
    }];
    [dataTask resume];
}

-(void)refresh{
    [self.refreshControl endRefreshing];
     [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count=0;
    for(int i=0;i<[self.mediaList count];i++){
        if ([self.mediaList[i] valueForKey:@"productName"] !=[NSNull null]) {
            NSArray *pn=[self.mediaList[i] valueForKey:@"productName"];
            count+=[pn count];
            NSLog(@"row count:%d",count);
            
        }
        
    }
    NSLog(@"%d",count);
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
    
    // search offset at specific row
    long targetRow = indexPath.row;
    for(int i = 0 ; i <[self.mediaList count] ;i++) {
        if (targetRow < [self.mediaList[i] count]) {
            // cell is here
            cell.label.text = [self.mediaList[i] valueForKey:@"productName"][targetRow];
            //NSMutableArray *contentInfo = [self.mediaList[i] valueForKey:@"contentInfo"][targetRow][0];
            //NSLog(@"name: %@", [self.mediaList[i] valueForKey:@"productName"][targetRow]);
            //NSLog(@"info: %@", [self.mediaList[i] valueForKey:@"contentInfo"][targetRow][0]);
            //[[self.mediaList[i] valueForKey:@"contentInfo"][targetRow][0] valueForKey:@"metadata"];
            NSString *url=[[self.mediaList[i] valueForKey:@"contentInfo"][targetRow][0] valueForKeyPath:@"metadata.posterURL"];
            cell.imageview.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
            cell.imageview.layer.cornerRadius = 10;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 128;
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
