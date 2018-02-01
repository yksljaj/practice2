//
//  tabbarController.m
//  practice
//
//  Created by Jessie on 2018/1/30.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "tabbarController.h"
#import "ViewController.h"
@interface tabbarController ()

@end

@implementation tabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mediaList=[NSMutableArray new];
    NSURL *url=[NSURL URLWithString:@"http://stg.render.ott.hinet.net/chtvideoApi/getRecommend.do?version=1.3&categoryId=/%E9%A6%96%E9%A0%81"];
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session=[NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error ==nil){
            NSString *html=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",html);
        }else{
            NSLog(@"下載錯誤:%@",error);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            //get Product name
            self.mediaList=[[jsonObj objectForKey:@"recommendInfo"] valueForKey:@"mediaList"];
            
           
            //get product image
            
            //NSURL *imageUrl=[NSURL URLWithString:[[[[[[[jsonObj objectForKey:@"recommendInfo"] objectAtIndex:0] objectForKey:@"mediaList"] valueForKey:@"contentInfo"] objectAtIndex:0]objectForKey:@"metadata"]valueForKey:@"posterURL"]];
            //NSLog(@"%@",imageUrl);
            ViewController *vc=self.viewControllers[0];
            vc.mediaList=[NSMutableArray arrayWithArray:self.mediaList];
            //NSLog(@"%@",vc.pn);
            [vc.tableview reloadData];
            
        });
        
    }];
    [dataTask resume];
    
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
