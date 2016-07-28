//
//  City.m
//  ZSAdderssPickerDemo
//
//  Created by 周顺 on 16/7/27.
//  Copyright © 2016年 AIRWALK. All rights reserved.
//

#import "City.h"

@implementation City

- (instancetype)initWithElement:(GDataXMLElement *)element {
    if (self = [super init]) {
        [self parseElement:element];
    }
    return self;
}

- (void)parseElement:(GDataXMLElement *)element {
    if (!element) return;
    
    self.cityName = [[element attributeForName:@"name"] stringValue];
    
    NSArray *countrys = [element elementsForName:@"district"];
    
    for (GDataXMLElement *countryElement in countrys) {
        
        NSString *countryName = [[countryElement attributeForName:@"name"] stringValue];
        
        [self.countryArray addObject:countryName];
    }
}

-(NSMutableArray *)countryArray {
    if (!_countryArray) {
        _countryArray = [NSMutableArray array];
    }
    return _countryArray;
}

@end
