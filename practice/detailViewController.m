//
//  detailViewController.m
//  practice
//
//  Created by Jessie on 2018/2/7.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "detailViewController.h"
#define space 40

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
    int pageNum;
    int pageTag;
    int scrollflag;
    float pageOffset;
     int prevPage;
}
@end

@implementation detailViewController


-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"w:%f",self.view.frame.size.width);
    NSLog(@"h:%f",self.view.frame.size.height);
    
    BOOL isPortrait = self.interfaceOrientation == UIInterfaceOrientationPortrait;
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
    statusBarHeight = (isPortrait ? statusBarSize.height : statusBarSize.width);
    
    navH=self.navigationController.navigationBar.frame.size.height;
    tabH=self.tabBarController.tabBar.frame.size.height;
    detailScrollView.delegate =self;
    
    CGRect scrollViewFrame = detailScrollView.frame;
    scrollViewFrame.size.width += space;
    detailScrollView.frame = scrollViewFrame;
    
    detailScrollView.contentSize =CGSizeMake([posterURL count]*(detailScrollView.frame.size.width),detailScrollView.frame.size.height-statusBarHeight-navH-tabH);
    //顯示點擊的圖片
    
    NSLog(@"w:%f",self.view.frame.size.width);
    NSLog(@"h:%f",self.view.frame.size.height);
    
    CGPoint current_origin=CGPointMake(detailScrollView.bounds.origin.x,detailScrollView.bounds.origin.y);
    CGPoint position;
    
    if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) ||
        [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown || [[UIDevice currentDevice] orientation] == UIDeviceOrientationUnknown || [[UIDevice currentDevice] orientation] == UIDeviceOrientationFaceUp)
    {
        if((current_origin.x)!=(self.current_row*(self.view.frame.size.width+40))&&((current_origin.x)!=0)){
            position=CGPointMake((current_origin.x), -(statusBarHeight+navH));
        }else{
            position = CGPointMake((self.view.frame.size.width+40)*self.current_row, -(statusBarHeight+navH));
            [self createPinchScrollView:detailScrollView atPage:self.current_row];
        }
    }else{
        if((current_origin.x)!=(self.current_row*self.view.frame.size.width)&&((current_origin.x)!=0)){
            position=CGPointMake((current_origin.x), -(statusBarHeight+navH));
        }else{
            position = CGPointMake(self.view.frame.size.width*(self.current_row),-(statusBarHeight+navH));
        }
    }
    [detailScrollView setContentOffset:position animated:NO];
    NSLog(@"start pos: %.2f", position.x);
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //detailScrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //detailScrollView.bounds=self.view.frame;
    NSLog(@"w:%f",self.view.frame.size.width);
    NSLog(@"h:%f",self.view.frame.size.height);
    
    NSMutableArray *arrImgUrl = [NSMutableArray new];
    posterURL=[NSMutableArray new];
   // detailScrollView.itemspacing
    //detailScrollView.pagingEnabled=NO;
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
    
    //    for(int j=0;j<1;j++){
    //
    //        [posterURL addObjectsFromArray:arrImgUrl];
    //
    //    }
    
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
    static NSInteger temp = 0;
    static NSInteger p=0;
    CGFloat pageWidth = _scrollView.frame.size.width;
    float fractionalPage = _scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    NSLog(@"page:%ld",(long)page);
    if (temp != page) {
        p=floor(temp);
        temp = page;
        /* Page did change */
    }
    NSLog(@"previousPage:%ld",(long)p);
    prevPage=p;
    
    
    const int MAX_SEARCH_INVALID_VIEW_REGION =1000;
    pageOffset = ((float)_scrollView.contentOffset.x/(float)_scrollView.frame.size.width);
    pageNum = (_scrollView.contentOffset.x/_scrollView.frame.size.width);
    
    if(_scrollView.tag!=0) {
        return;
    }
    
    
    if((pageOffset - pageNum >FLT_EPSILON)
       && ((pageOffset - pageNum) <0.5f)){
        pageNum++;
        //NSLog(@"viewIsScrolling, pageNum: %d",pageNum);
        
        
    }else{
        
    }
    
    //p=pageNum;
    
    pageTag = pageNum +1;
    
    NSLog(@"page offset: %.2f, scrollview position: %.2f _scrollView.tagID: %ld %d %d", pageOffset, _scrollView.contentOffset.x, (long)_scrollView.tag,pageNum,prevPage);
    if([_scrollView viewWithTag:(pageTag)] || pageNum>=posterURL.count) {
        NSLog(@"ZZ: view tag #%3d exist",pageTag);
        return;
    }
    else{
        // view is missing, create it and set its tag to currentPage+1
        NSLog(@"ZZ: view tag #%3d ismissing, need to create that", pageTag);
        [self createPinchScrollView:_scrollView atPage:pageNum];
    }
    
    for (int i=0; i < MAX_SEARCH_INVALID_VIEW_REGION; i++ ) {
        if((i < (pageNum-1) || i > (pageNum+1)) && [_scrollView viewWithTag:(i+1)] ) {
            [[_scrollView viewWithTag:(i+1)] removeFromSuperview];
            NSLog(@"ZZ: \t\t\t\tdelete view tag #%3d", i+1);
        }
    }
    
}

-(void)createPinchScrollView:(UIScrollView *)_srcScrollView atPage:(int)pageNumber {
    
    UIScrollView *tmpPinchView;
    UIImageView *tmpImgView;
    tmpPinchView = [[UIScrollView alloc]initWithFrame:
                    CGRectMake((pageNumber)*_srcScrollView.frame.size.width,
                               0,
                               (_srcScrollView.frame.size.width-space),
                               _srcScrollView.frame.size.height)];
    //CGSize size=tmpPinchView;
    tmpPinchView.delegate =self;
    tmpPinchView.showsVerticalScrollIndicator=NO;
    tmpPinchView.showsHorizontalScrollIndicator=NO;
    tmpPinchView.pagingEnabled=NO;
    
    tmpPinchView.contentSize =CGSizeMake(self.view.frame.size.width,self.view.frame.size.height-statusBarHeight-navH-tabH);
    
    
    
    tmpImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,(self.view.frame.size.width), self.view.frame.size.height-statusBarHeight-navH-tabH)];
    NSString *imageName = [posterURL objectAtIndex:pageNumber];
    tmpImgView.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
    CGSize imageViewSize = tmpImgView.bounds.size;
    CGSize scrollViewSize = tmpPinchView.bounds.size;
    if(imageViewSize.width){
        double widthScale = scrollViewSize.width / imageViewSize.width;
        double heightScale = scrollViewSize.height / imageViewSize.height;
        tmpPinchView.minimumZoomScale =MIN(widthScale, heightScale);
        tmpPinchView.maximumZoomScale =5.0;
        [tmpPinchView setZoomScale:1.0];
    }
    
    tmpImgView.userInteractionEnabled =YES;
    
    UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.cancelsTouchesInView = NO;
    [doubleTap setNumberOfTapsRequired:2];
    [tmpImgView addGestureRecognizer:doubleTap];
    [tmpPinchView addSubview:tmpImgView];
    tmpPinchView.tag =pageNumber+1;
    [_srcScrollView addSubview:tmpPinchView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    for (UIView *p in scrollView.subviews){
        return p;
    }
    return nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    NSLog(@"scrollViewDidEndDragging");
    if (decelerate) {


        for (UIScrollView *s in scrollView.subviews){
            if ([s isKindOfClass:[UIScrollView class]]){
                [s setZoomScale:1.0 animated:YES]; //scrollView每滑动一次将要出现的图片较正常时候图片的倍数（将要出现的图片显示的倍数）
            }
        }
    }else{
        NSLog(@"no decelerate");

    }

    CGPoint point=scrollView.contentOffset;
    NSLog(@"%f,%f",point.x,point.y);

}

//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    static int pre;
//}
//
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView{
//
//    float pageWidth=_scrollView.frame.size.width;
//    float currentPage =floor((_scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
//    bool isDiffPage = false;
//    NSLog(@"current:%f  prev:%d",currentPage,prevPage);
//    if(_scrollView == detailScrollView)
//    {
//
//        if(currentPage != prevPage)
//        {
//            isDiffPage = true;
//            for (UIScrollView *s in _scrollView.subviews){
//                if ([s isKindOfClass:[UIScrollView class]]){
//                    [s setZoomScale:1.0]; //scrollView每滑动一次将要出现的图片较正常时候图片的倍数（将要出现的图片显示的倍数）
//                }
//            }
//
//        }
//
//
//        //zoomflag=0;
//        NSLog(@"end dec page: %.2f, isDiffPage: %d", currentPage, isDiffPage);
//    }
//}

    
    
    -(void)handleDoubleTap:(UIGestureRecognizer *)gesture{
        
        if ([(UIScrollView*)gesture.view.superview zoomScale] > [(UIScrollView*)gesture.view.superview minimumZoomScale]) {
            [(UIScrollView *)gesture.view.superview setZoomScale:[(UIScrollView*)gesture.view.superview minimumZoomScale]  animated: true];
        } else {
            
            float enlarge = [(UIScrollView*)gesture.view.superview maximumZoomScale];//每次双击放大倍数
            CGRect zoomRect = [self zoomRectForScale:enlarge withCenter:[gesture locationInView:gesture.view]];
            [(UIScrollView*)gesture.view.superview zoomToRect:zoomRect animated:YES];
            //[(UIScrollView *)gesture.view.superview setZoomScale:[(UIScrollView*)gesture.view.superview maximumZoomScale]  animated: true];
        }
//        if(zoomflag==0){
//            NSLog(@"%f",self.view.frame.size.height);
//            NSLog(@"%f",self.view.frame.size.width);
//
//            float enlarge = [(UIScrollView*)gesture.view.superview zoomScale] * 5.0;//每次双击放大倍数
//            CGRect zoomRect = [self zoomRectForScale:enlarge withCenter:[gesture locationInView:gesture.view]];
//            [(UIScrollView*)gesture.view.superview zoomToRect:zoomRect animated:YES];
//            zoomflag=1;
//        }else{
//            [(UIScrollView*)gesture.view.superview setZoomScale:1.0 animated:YES];
//            zoomflag=0;
//        }
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
