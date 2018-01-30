//
//  ViewController.m
//  practice
//
//  Created by Jessie on 2018/1/30.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    
    productName=[NSMutableArray new];
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
        NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"%@",jsonObj);
        NSDictionary *recommendInfo =[jsonObj objectForKey:@"recommendInfo"];
        
        for(NSDictionary *count in recommendInfo){
            NSString *mediaList=[count objectForKey:@"mediaList"];
            //NSLog(@"%@",mediaList);
            for(NSDictionary *count1 in mediaList){
                NSString *pn=[count1 objectForKey:@"productName"];
                [productName addObject:pn];
    
            }
        }
        NSLog(@"%@",productName);
        [_tableview reloadData];
        }];
    [dataTask resume];
    
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [productName count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
   cell.productNameLabel.text=[productName objectAtIndex:indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
