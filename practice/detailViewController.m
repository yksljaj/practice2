//
//  detailViewController.m
//  practice
//
//  Created by Jessie on 2018/2/7.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "detailViewController.h"

@interface detailViewController ()
{
    NSMutableArray *posterURL;
    int zoomflag;
}
@end

@implementation detailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _detailScrollView.delegate =self;
   // self.view.backgroundColor = [UIColor whiteColor];
    posterURL=[NSMutableArray new];
    
    //find poster URL
    for(int i=0;i<[self.mediaList count];i++){
        if ([self.mediaList[i] valueForKey:@"productName"] !=[NSNull null]) {
            
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
    
    _detailScrollView.contentSize =CGSizeMake([posterURL count]*375,554);
    
    //implement slide and pinch
    for(int i = 0; i < [posterURL count]; i++){
        UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        
        UIScrollView *pinchScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(375*i,0,375, 554)];
        pinchScrollView.delegate =self;
        pinchScrollView.contentSize =CGSizeMake(375,554);
        pinchScrollView.minimumZoomScale =1.0;
        pinchScrollView.maximumZoomScale =3.0;
        [pinchScrollView setZoomScale:1.0];
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,375, 554)];
        NSString *imageName = [posterURL objectAtIndex:i];
        imageview.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
        
        
        imageview.userInteractionEnabled =YES;
        imageview.tag = i+1;
        [imageview addGestureRecognizer:doubleTap];
        [pinchScrollView addSubview:imageview];
        [self.detailScrollView addSubview:pinchScrollView];
        zoomflag=0;
    }
    
    //顯示點擊的圖片
    CGPoint current_origin=CGPointMake(self.detailScrollView.bounds.origin.x,self.detailScrollView.bounds.origin.y);
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


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    for (UIView *p in scrollView.subviews){
        return p;
    }
    return nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView ==self.detailScrollView){
        
        CGFloat x = scrollView.contentOffset.x;
        if (x==-333){
    
        }
        else {
            //            offset = x;
            for (UIScrollView *s in scrollView.subviews){
                if ([s isKindOfClass:[UIScrollView class]]){
                    [s setZoomScale:1.0]; //scrollView每滑动一次将要出现的图片较正常时候图片的倍数（将要出现的图片显示的倍数）
                }
            }
        }
    }
}

-(void)handleDoubleTap:(UIGestureRecognizer *)gesture{
    if(zoomflag==0){
    float enlarge = [(UIScrollView*)gesture.view.superview zoomScale] * 3.0;//每次双击放大倍数
    CGRect zoomRect = [self zoomRectForScale:enlarge withCenter:[gesture locationInView:gesture.view]];
    [(UIScrollView*)gesture.view.superview zoomToRect:zoomRect animated:YES];
        zoomflag=1;
    }else{
        [(UIScrollView*)gesture.view.superview setZoomScale:1.0];
        //CGRect zoomRect = [self zoomRectForScale:shrink withCenter:];
    //[(UIScrollView*)gesture.view.superview zoomToRect:zoomRect animated:YES];
        zoomflag=0;
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center{
    CGRect zoomRect;
    zoomRect.size.height =self.view.frame.size.height / scale;
    zoomRect.size.width  =self.view.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
    
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
