//
//  detailViewController.m
//  practice
//
//  Created by Jessie on 2018/2/7.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "detailViewController.h"
#define WIDTH_PAGE 414
#define HEIGHT_PAGE 623
@interface detailViewController ()
{
    NSMutableArray *posterURL;
    int zoomflag;
    UIScrollView *pinchScrollView;
    UIImageView *imageview;
    IBOutlet UIScrollView *detailScrollView;
    CGFloat statusBarHeight;
    CGFloat navH;
    CGFloat tabH;
}
@end

@implementation detailViewController

//- (id)initWithCoder:(NSCoder *)aDecoder{
//    self = [super initWithCoder:aDecoder];
//
//    if (self) {
//        NSString *nibName = NSStringFromClass([self class]);
//        UINib *nib = [UINib nibWithNibName:detailViewController bundle:nil];
//        [nib instantiateWithOwner:self options:nil];
//        //Add the view loaded from the nib into self.
//        [self addSubview:self.view];
//    }
//    return self;
//}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"w:%f",self.view.frame.size.width);
    NSLog(@"h:%f",self.view.frame.size.height);
    
    BOOL isPortrait = self.interfaceOrientation == UIInterfaceOrientationPortrait;
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
    statusBarHeight = (isPortrait ? statusBarSize.height : statusBarSize.width);
    
    navH=self.navigationController.navigationBar.frame.size.height;
    tabH=self.tabBarController.tabBar.frame.size.height;
    detailScrollView.delegate =self;
    detailScrollView.contentSize =CGSizeMake([posterURL count]*self.view.frame.size.width,self.view.frame.size.height-statusBarHeight-navH-tabH);
    //顯示點擊的圖片
    
    CGPoint current_origin=CGPointMake(detailScrollView.bounds.origin.x,detailScrollView.bounds.origin.y);
    CGPoint position;
    
    if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) ||
        [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown || [[UIDevice currentDevice] orientation] == UIDeviceOrientationUnknown || [[UIDevice currentDevice] orientation] == UIDeviceOrientationFaceUp)
    {
        if((current_origin.x)!=(self.current_row*self.view.frame.size.width)&&((current_origin.x)!=0)){
            position=CGPointMake((current_origin.x), 0);
        }else{
            position = CGPointMake(self.view.frame.size.width*self.current_row, 0);
        }
    }else{
        if((current_origin.x)!=(self.current_row*667)&&((current_origin.x)!=0)){
            position=CGPointMake((current_origin.x), 0);
        }else{
            position = CGPointMake(667*(self.current_row), 0);
        }
    }
    [detailScrollView setContentOffset:position animated:NO];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //detailScrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //detailScrollView.bounds=self.view.frame;
    NSLog(@"w:%f",self.view.frame.size.width);
    NSLog(@"h:%f",self.view.frame.size.height);
    
    NSMutableArray *arrImgUrl = [NSMutableArray new];
    posterURL=[NSMutableArray new];
    
    
    //find poster URL
    
    for(int i=0;i<[self.mediaList count];i++){
        if ([self.mediaList[i] valueForKey:@"productName"] !=[NSNull null]) {
            
            NSMutableArray *contentInfo=[self.mediaList[i] valueForKey:@"contentInfo"];
            for(int j=0;j<[contentInfo count];j++){
                if([contentInfo[j] count]>1){
                    NSString *temp=[[[self.mediaList[i] valueForKey:@"contentInfo"][j] valueForKey:@"metadata"][0] valueForKey:@"posterURL"];
                    [arrImgUrl addObject:temp];
                }else{
                    NSMutableArray *url=[[[self.mediaList[i] valueForKey:@"contentInfo"][j] valueForKey:@"metadata"]valueForKey:@"posterURL"];
                    [arrImgUrl addObjectsFromArray:url];
                    
                }
            }
        }
    }
    
    [posterURL addObjectsFromArray:arrImgUrl];
    
    for(int j=0;j<0;j++){
        
        [posterURL addObjectsFromArray:arrImgUrl];
        
    }
    
    NSLog(@"poster count: %ld", (unsigned long)posterURL.count);
    
    
    
    
//    //implement slide and pinch
//    for(int i = 0; i < 20; i++){
//        UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
//        [doubleTap setNumberOfTapsRequired:2];
//
//        pinchScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(375*20,0,375, 554)];
//        pinchScrollView.delegate =self;
//        pinchScrollView.showsVerticalScrollIndicator=NO;
//        pinchScrollView.showsHorizontalScrollIndicator=NO;
//        pinchScrollView.contentSize =CGSizeMake(375,554);
//        pinchScrollView.minimumZoomScale =0.5;
//        pinchScrollView.maximumZoomScale =5.0;
//        [pinchScrollView setZoomScale:1.0];
//
//        imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,375, 554)];
//        NSString *imageName = [posterURL objectAtIndex:i];
//        imageview.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
//
//
//        imageview.userInteractionEnabled =YES;
//        imageview.tag = i+1;
//        [imageview addGestureRecognizer:doubleTap];
//        [pinchScrollView addSubview:imageview];
//        [self.detailScrollView addSubview:pinchScrollView];
//        zoomflag=0;
//    }
    
    zoomflag=0;
    
}



-(void)scrollViewDidScroll:(UIScrollView *)_scrollView {
    const int MAX_SEARCH_INVALID_VIEW_REGION =1000;
    float pageOffset = ((float)_scrollView.contentOffset.x/(float)_scrollView.frame.size.width);
    float p=_scrollView.frame.size.width;
    float h=_scrollView.frame.size.height;
    int pageNum = (_scrollView.contentOffset.x/_scrollView.frame.size.width);
    NSLog(@"scrollview contentoffset x:%f",_scrollView.contentOffset.x);
    NSLog(@"scrollview framesize width:%f",_scrollView.frame.size.width);
    
    if((pageOffset - pageNum >FLT_EPSILON)
         && ((pageOffset - pageNum) <0.5f))
        pageNum++;
   int pageTag = pageNum +1;
    //NSLog(@"viewIsScrolling, pageNum: %d",pageNum);

    NSLog(@"page offset: %.2f, scrollview position: %.2f _scrollView.tagID: %ld", pageOffset, _scrollView.contentOffset.x, (long)_scrollView.tag);
    if(_scrollView.tag!=0) {
        return;
    }
    if([_scrollView viewWithTag:(pageTag)] ) {
    NSLog(@"ZZ: view tag #%3d exist",pageTag);
        return;
    }
    else{
        // view is missing, create it and set its tag to currentPage+1
        NSLog(@"ZZ: view tag #%3d ismissing, need to create that", pageTag);
#if 1
        UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        UIScrollView *tmpPinchView = [[UIScrollView alloc]initWithFrame:
                                           CGRectMake((pageNum)*_scrollView.frame.size.width,
                                                                     0,
                                                                     _scrollView.frame.size.width,
                                                                     _scrollView.frame.size.height)];
        //CGSize size=tmpPinchView;
        tmpPinchView.delegate =self;
        tmpPinchView.showsVerticalScrollIndicator=NO;
        tmpPinchView.showsHorizontalScrollIndicator=NO;
        tmpPinchView.contentSize =CGSizeMake(self.view.frame.size.width,self.view.frame.size.height-statusBarHeight-navH-tabH);
        tmpPinchView.minimumZoomScale =0.5;
        tmpPinchView.maximumZoomScale =5.0;
        [tmpPinchView setZoomScale:1.0];
        
        UIImageView *tmpImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height-statusBarHeight-navH-tabH)];
        NSString *imageName = [posterURL objectAtIndex:pageNum];
        tmpImgView.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
      
        tmpImgView.userInteractionEnabled =YES;
        [tmpImgView addGestureRecognizer:doubleTap];
        [tmpPinchView addSubview:tmpImgView];
        tmpPinchView.tag =pageTag;
        [_scrollView addSubview:tmpPinchView];
#endif
    }
   
    for (int i=0; i < MAX_SEARCH_INVALID_VIEW_REGION; i++ ) {
        if((i < (pageNum-1) || i > (pageNum+1)) && [_scrollView viewWithTag:(i+1)] ) {
            [[_scrollView viewWithTag:(i+1)] removeFromSuperview];
            NSLog(@"ZZ: \t\t\t\tdelete view tag #%3d", i+1);
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    for (UIView *p in scrollView.subviews){
        return p;
    }
    return nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView ==detailScrollView){
        
        CGFloat x = scrollView.contentOffset.x;
        if (x==-300){
            
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
