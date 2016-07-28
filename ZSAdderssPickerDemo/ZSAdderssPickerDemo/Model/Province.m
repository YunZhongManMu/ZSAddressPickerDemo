//
//  Province.m
//  ZSAdderssPickerDemo
//
//  Created by 周顺 on 16/7/27.
//  Copyright © 2016年 AIRWALK. All rights reserved.
//

#import "Province.h"

@implementation Province

- (instancetype)initWithElement:(GDataXMLElement *)element {
    if (self = [super init]) {
        [self parseElement:element];
    }
    return self;
}

- (void)parseElement:(GDataXMLElement *)element {
    if (!element) return;
    
    self.provinceName = [[element attributeForName:@"name"] stringValue];
    
    NSArray *citys = [element elementsForName:@"city"];
    
    for (GDataXMLElement *cityElement in citys) {
        
        City *province = [[City alloc] initWithElement:cityElement];
        
        [self.cityArray addObject:province];
    }
}

- (NSMutableArray *)cityArray {
    if (!_cityArray) {
        _cityArray = [NSMutableArray array];
    }
    return _cityArray;
}

@end
