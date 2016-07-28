//
//  ViewController.m
//  ZSAdderssPickerDemo
//
//  Created by 周顺 on 16/7/27.
//  Copyright © 2016年 AIRWALK. All rights reserved.
//

#import "ViewController.h"
#import "ZSPickerView.h"

@interface ViewController ()<ZSPickerViewDelegate>

@property (nonatomic, strong) ZSPickerView *pickerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ZSPickerView *pickerView = [[ZSPickerView alloc] init];
    pickerView.delegate = self;
    _pickerView = pickerView;
}

- (IBAction)buttonClick:(id)sender {
    
    [_pickerView show];
}

#pragma mark - <ZSPickerViewDelegate>
- (void)popPicker:(ZSPickerView *)popPicker didSelectedAddress:(ChinaAddressModel *)address {
    
    NSLog(@"%@--%@--%@", address.province, address.city, address.country);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
