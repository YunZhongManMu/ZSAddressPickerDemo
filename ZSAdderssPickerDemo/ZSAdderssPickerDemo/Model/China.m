//
//  China.m
//  ZSAdderssPickerDemo
//
//  Created by 周顺 on 16/7/27.
//  Copyright © 2016年 AIRWALK. All rights reserved.
//

#import "China.h"

@implementation China

- (Province *)findProvinceByName:(NSString *)name {
    for (Province *province in self.provinceArray) {
        if ([province.provinceName isEqualToString:name]) {
            return province;
        }
    }
    return nil;
}

- (instancetype)initWithData:(NSData *)data {
    if (self = [super init]) {
        [self parse:data];
    }
    return self;
}

- (void)parse:(NSData *)data {
    if (!data) return;
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    GDataXMLElement *rootElement = [doc rootElement];
    
    NSArray *provinces = [rootElement elementsForName:@"province"];
    
    for (GDataXMLElement *provinceElement in provinces) {
        
        Province *province = [[Province alloc] initWithElement:provinceElement];
        
        [self.provinceArray addObject:province];
    }
}

- (NSMutableArray *)provinceArray {
    if (!_provinceArray) {
        _provinceArray = [NSMutableArray array];
    }
    return _provinceArray;
}

@end
