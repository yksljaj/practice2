//
//  media.m
//  practice
//
//  Created by MikeBook on 2018/2/25.
//  Copyright © 2018年 Jessie. All rights reserved.
//
#import "media.h"
#import "ImageDownloader.h"
@implementation media

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        

        if ([dic valueForKey:@"productName"] !=[NSNull null]) {
            self.mediaTitle = [dic objectForKey:@"productName"];
             self.mediaPicUrl = [[[dic valueForKey:@"contentInfo"] valueForKey:@"metadata"][0] valueForKey:@"posterURL"];
            
                        //NSMutableArray *contentInfo=[dic valueForKey:@"contentInfo"];
//                        for(int j=0;j<[contentInfo count];j++){
//                            if([contentInfo[j] count]>1){
//                                NSString *temp=[[[dic valueForKey:@"contentInfo"][j] valueForKey:@"metadata"][0] valueForKey:@"posterURL"];
//                                self.mediaPicUrl = temp;
//                            }else{
//                                NSString *url=[[[dic valueForKey:@"contentInfo"][j] valueForKey:@"metadata"]valueForKey:@"posterURL"];
//                                self.mediaPicUrl = url;
//                            }
//                        }
                    }
        
        //从本地沙盒加载图像
        ImageDownloader * downloader = [[ImageDownloader alloc] init] ;
        self.mediaPic = [downloader loadLocalImage:_mediaPicUrl];
        
    }
    
    return self;
}

+ (NSMutableArray *)handleData:(NSData *)data;
{
    
    //解析数据
    NSError * error = nil;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSMutableArray * originalArray =[[dic objectForKey:@"recommendInfo"] valueForKey:@"mediaList"];
    
    //封装数据对象
    NSMutableArray * resultArray = [NSMutableArray array];
    
    for (int i=0 ;i<[originalArray count]; i++) {
#if 0
        NSDictionary * mediaDic = [originalArray objectAtIndex:i];
        media * item = [[media alloc] initWithDictionary:mediaDic];
        [resultArray addObject:item];
#else
        NSMutableArray *arr2 = [originalArray objectAtIndex:i];
        if (arr2 != [NSNull null]){
        for (int j = 0;j < [arr2 count] ; j++) {
            NSDictionary * mediaDic = [arr2 objectAtIndex:j];
            media * item = [[media alloc] initWithDictionary:mediaDic];
            [resultArray addObject:item];
        }
        }
#endif
    }
    
    
//    for(int i=0;i<[self.mediaList count];i++){
//        if ([self.mediaList[i] valueForKey:@"productName"] !=[NSNull null]) {
//            
//            NSMutableArray *contentInfo=[self.mediaList[i] valueForKey:@"contentInfo"];
//            for(int j=0;j<[contentInfo count];j++){
//                if([contentInfo[j] count]>1){
//                    NSString *temp=[[[self.mediaList[i] valueForKey:@"contentInfo"][j] valueForKey:@"metadata"][0] valueForKey:@"posterURL"];
//                    [arrImgUrl addObject:temp];
//                }else{
//                    NSMutableArray *url=[[[self.mediaList[i] valueForKey:@"contentInfo"][j] valueForKey:@"metadata"]valueForKey:@"posterURL"];
//                    [arrImgUrl addObjectsFromArray:url];
//                    
//                }
//            }
//        }
//    }
//    
//    [posterURL addObjectsFromArray:arrImgUrl];
    
    return resultArray;
    
}

@end
