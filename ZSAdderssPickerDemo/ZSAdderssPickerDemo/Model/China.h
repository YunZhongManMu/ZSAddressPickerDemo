//
//  China.h
//  ZSAdderssPickerDemo
//
//  Created by 周顺 on 16/7/27.
//  Copyright © 2016年 AIRWALK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Province.h"

@interface China : NSObject

/** 省份列表 */
@property (nonatomic, strong) NSMutableArray *provinceArray;

- (instancetype)initWithData:(NSData *)data;

- (Province *)findProvinceByName:(NSString *)name;

@end
