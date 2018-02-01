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
            
            for(int j=0;j<[contentInfo count];j++){
                //NSLog(@"%d",[contentInfo[i] count]);
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
    
    //NSArray *imageUrl=[[_mediaList valueForKey:@"contentInfo"]valueForKey:@"metadata"];
    
    //NSMutableArray *metadata=[[_mediaList valueForKey:@"contentInfo"]valueForKey:@"metadata"];
    // NSLog(@"metadata:%@",metadata);
    
    //CIImage *image=[CIImage imageWithContentsOfURL:[posterURL objectAtIndex:indexPath.row]];
    cell.imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                 [NSURL URLWithString:[posterURL objectAtIndex:indexPath.row]]]];
    NSLog(@"url:%@",[posterURL objectAtIndex:indexPath.row]);
    cell.label.text=[pn objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
