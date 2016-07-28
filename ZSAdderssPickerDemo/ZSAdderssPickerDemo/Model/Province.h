//
//  Province.h
//  ZSAdderssPickerDemo
//
//  Created by 周顺 on 16/7/27.
//  Copyright © 2016年 AIRWALK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

@interface Province : NSObject

/** 省份名字 */
@property (nonatomic, copy) NSString *provinceName;

/** 城市列表 */
@property (nonatomic, strong) NSMutableArray *cityArray;

- (instancetype)initWithElement:(GDataXMLElement *)element;


@end
