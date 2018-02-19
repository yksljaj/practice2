//
//  ScrollViewController.m
//  practice
//
//  Created by Jessie on 2018/2/14.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "ScrollViewController.h"

@interface ScrollViewController ()
{
    UIImageView *imageview;
    int zoomflag;
}
@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int i=0;
    
    
    
    UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    
    //self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(375*20,0,375, 554)];
    self.scrollView.delegate =self;
    self.scrollView.showsVerticalScrollIndicator=NO;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.contentSize =CGSizeMake(375,554);
    self.scrollView.minimumZoomScale =0.5;
    self.scrollView.maximumZoomScale =5.0;
    [self.scrollView setZoomScale:1.0];
    
    imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,375, 554)];
    NSString *imageName = [posterURL objectAtIndex:i];
    imageview.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
    
    
    imageview.userInteractionEnabled =YES;
    imageview.tag = i+1;
    [imageview addGestureRecognizer:doubleTap];
    [self.scrollView addSubview:imageview];
    zoomflag=0;
    
    //顯示點擊的圖片
    CGPoint current_origin=CGPointMake(self.scrollView.bounds.origin.x,self.scrollView.bounds.origin.y);
    CGPoint position;
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        if((current_origin.x)!=(self.current_row*375)&&((current_origin.x)!=0)){
            position=CGPointMake((current_origin.x), 0);
        }else{
            position = CGPointMake(375*self.current_row, 0);
        }
    }else{
        if((current_origin.x)!=(self.current_row*667)&&((current_origin.x)!=0)){
            position=CGPointMake((current_origin.x), 0);
        }else{
            position = CGPointMake(667*(self.current_row), 0);
        }
    }
    [self.scrollView setContentOffset:position animated:NO];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int currentPage = (scrollView.contentOffset.x / scrollView.frame.size.width);
    
    // display the image and maybe +/-1 for a smoother scrolling
    // but be sure to check if the image already exists, you can
    // do this very easily using tags
    if ([scrollView viewWithTag:(currentPage + 1)]) {
        return;
    } else {
        // view is missing, create it and set its tag to currentPage+1
        UIImageView *iv = [[UIImageView alloc] initWithFrame:
                           CGRectMake((currentPage + 1) * scrollView.frame.size.width,
                                      0,
                                      scrollView.frame.size.width,
                                      scrollView.frame.size.height)];
        iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",
                                        currentPage + 1]];
        iv.tag = currentPage + 1;
        [sv addSubview:iv];
    }
    
    /**
     * using your paging numbers as tag, you can also clean the UIScrollView
     * from no longer needed views to get your memory back
     * remove all image views except -1 and +1 of the currently drawn page
     */
    for (int i = 0; i < 50; i++) {
        if ((i < (currentPage - 1) || i > (currentPage + 1)) &&
            [scrollView viewWithTag:(i + 1)]) {
            [[scrollView viewWithTag:(i + 1)] removeFromSuperview];
        }
    }
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
        [(UIScrollView*)gesture.view.superview setZoomScale:1.0 animated:YES];
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
