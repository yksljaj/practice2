//
//  media.h
//  practice
//
//  Created by MikeBook on 2018/2/25.
//  Copyright © 2018年 Jessie. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface media : NSObject

@property (nonatomic,copy) NSString * mediaTitle;
@property (nonatomic,copy) NSString * mediaPicUrl;
@property (nonatomic,retain) UIImage * mediaPic; //  存储每个新闻自己的image对象
- (id)initWithDictionary:(NSDictionary *)dic;
+ (NSMutableArray *)handleData:(NSData *)data;  
@end
