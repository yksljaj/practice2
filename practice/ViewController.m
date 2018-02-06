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
    
//    NSMutableArray *pn=[NSMutableArray new];
//    NSMutableArray *posterURL=[NSMutableArray new];
//    for(int i=0;i<[self.mediaList count];i++){
//        if ([self.mediaList[i] valueForKey:@"productName"] !=[NSNull null]) {
//            NSMutableArray *temp=[self.mediaList[i] valueForKey:@"productName"];
//            [pn addObjectsFromArray:temp];
//
//            NSMutableArray *contentInfo=[self.mediaList[i] valueForKey:@"contentInfo"];
//            NSLog(@"cellForRow count:%d",i);
//            for(int j=0;j<[contentInfo count];j++){
//                NSLog(@"cellForRow B count:%d",i);
//                if([contentInfo[j] count]>1){
//                    NSString *test=[[[self.mediaList[i] valueForKey:@"contentInfo"][j] valueForKey:@"metadata"][0] valueForKey:@"posterURL"];
//                    NSLog(@"test:%@",test);
//                    [posterURL addObject:test];
//                }else{
//                  NSMutableArray *url=[[[self.mediaList[i] valueForKey:@"contentInfo"][j] valueForKey:@"metadata"]valueForKey:@"posterURL"];
//                    [posterURL addObjectsFromArray:url];
//
//                }
//            }
//        }
//    }
    

    //cell.imageview.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                 //[NSURL URLWithString:[posterURL objectAtIndex:indexPath.row]]]];
    //cell.imageview.layer.cornerRadius = 10;
    //cell.label.text=[pn objectAtIndex:indexPath.row];
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
