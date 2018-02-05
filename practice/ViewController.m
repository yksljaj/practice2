//
//  ViewController.m
//  practice
//
//  Created by Jessie on 2018/1/30.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableCell.h"
@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSLog(@"pn2:%@",self.mediaList);
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"Cell";
    CustomTableCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        UINib *nib=[UINib nibWithNibName:@"CustomTableCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    NSMutableArray *pn=[NSMutableArray new];
    NSMutableArray *posterURL=[NSMutableArray new];
    for(int i=0;i<[self.mediaList count];i++){
        if ([self.mediaList[i] valueForKey:@"productName"] !=[NSNull null]) {
            NSMutableArray *temp=[self.mediaList[i] valueForKey:@"productName"];
            [pn addObjectsFromArray:temp];
            
            NSMutableArray *contentInfo=[self.mediaList[i] valueForKey:@"contentInfo"];
            NSLog(@"cellForRow count:%d",i);
            for(int j=0;j<[contentInfo count];j++){
                NSLog(@"cellForRow B count:%d",i);
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
    

    cell.imageview.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                 [NSURL URLWithString:[posterURL objectAtIndex:indexPath.row]]]];
    cell.imageview.layer.cornerRadius = 10;
    cell.label.text=[pn objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 128;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
