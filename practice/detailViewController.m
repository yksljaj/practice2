//
//  detailViewController.m
//  practice
//
//  Created by Jessie on 2018/2/7.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "detailViewController.h"

@interface detailViewController ()

@end

@implementation detailViewController

-(void)viewDidAppear:(BOOL)animated{
    CGSize size=CGSizeZero;
    CGPoint current_origin=CGPointMake(self.detailScrollView.bounds.origin.x,self.detailScrollView.bounds.origin.y);
    CGRect rect=CGRectMake(0, 0, self.detailScrollView.bounds.size.width, self.detailScrollView.bounds.size.height);
    UIImageView *lastOne=nil;
    NSMutableArray *pn=[NSMutableArray new];
    NSMutableArray *posterURL=[NSMutableArray new];
    for(int i=0;i<[self.mediaList count];i++){
        if ([self.mediaList[i] valueForKey:@"productName"] !=[NSNull null]) {
            NSMutableArray *temp=[self.mediaList[i] valueForKey:@"productName"];
            [pn addObjectsFromArray:temp];
            
            NSMutableArray *contentInfo=[self.mediaList[i] valueForKey:@"contentInfo"];
            for(int j=0;j<[contentInfo count];j++){
                if([contentInfo[j] count]>1){
                    NSString *temp=[[[self.mediaList[i] valueForKey:@"contentInfo"][j] valueForKey:@"metadata"][0] valueForKey:@"posterURL"];
                    [posterURL addObject:temp];
                }else{
                    NSMutableArray *url=[[[self.mediaList[i] valueForKey:@"contentInfo"][j] valueForKey:@"metadata"]valueForKey:@"posterURL"];
                    [posterURL addObjectsFromArray:url];
                    
                }
            }
        }
    }
    
    for(int i = 0; i < [posterURL count]; i++)
    {
        if(![posterURL[i] isEqualToString:@""]){
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                  [NSURL URLWithString:[posterURL objectAtIndex:i]]]];
        
            UIImageView *temp=[[UIImageView alloc] initWithImage:image];
            [posterURL replaceObjectAtIndex:i withObject: temp];
        }else{
            UIImageView *temp=[[UIImageView alloc] initWithFrame:self.view.bounds];
            [posterURL replaceObjectAtIndex:i withObject: temp];
        }
    }
    
    
    for(UIImageView *p in posterURL){
        p.contentMode=UIViewContentModeScaleAspectFit;
        if(!lastOne){
            p.frame=rect;
        }else{
            p.frame=CGRectOffset(lastOne.frame, lastOne.frame.size.width, 0);
        }
        
        lastOne=p;
        size=CGSizeMake(size.width + p.frame.size.width, rect.size.height);
        [self.detailScrollView addSubview:p];
        
    }
    self.detailScrollView.contentSize=size;
    
    CGPoint position;
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        if((current_origin.x)!=(self.current_row*375)&&((current_origin.x)!=0)){
            position=CGPointMake((current_origin.x), 0);
        }else{
            position = CGPointMake(375*(self.current_row), 0);
        }
    }else{
        if((current_origin.x)!=(self.current_row*667)&&((current_origin.x)!=0)){
            position=CGPointMake((current_origin.x), 0);
        }else{
            position = CGPointMake(667*(self.current_row), 0);
        }
    }
    [self.detailScrollView setContentOffset:position animated:NO];
    
}
    - (void)viewDidLoad {
        [super viewDidLoad];
    
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
