//
//  ZSPickerView.m
//  UIPickerViewDemo
//
//  Created by 周顺 on 16/7/6.
//  Copyright © 2016年 AIRWALK. All rights reserved.
//

#import "ZSPickerView.h"
#import "China.h"

#define UISCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define UISCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width

#define kPickerViewHeight 250
#define kButtonWidth      70
#define kButtonHeight     40
#define kComponentHeight  40

@implementation ChinaAddressModel

@end


@interface ZSPickerView()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIPickerView *addressPickerView;

@property (strong, nonatomic) NSArray *province;  // 省
@property (strong, nonatomic) NSArray *city;      // 市
@property (strong, nonatomic) NSArray *country;  // 县

@property (nonatomic, copy) NSString *currentProvince; // 当前选择的省
@property (nonatomic, copy) NSString *currentCity;     // 当前选择的市
@property (nonatomic, copy) NSString *currentCountry; // 当前选择的县

@property (nonatomic, assign) BOOL isShow; // 是否正在显示

@property (nonatomic, strong) ChinaAddressModel *addressModel;

@property (nonatomic, strong) China *china;//地址模型
@end


@implementation ZSPickerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT);
        self.alpha = 0.0;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, UISCREEN_HEIGHT, UISCREEN_WIDTH, kPickerViewHeight)];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgView];

        [self loadAddressMessage];  // 加载地址
        [self configureUI];
        
    }
    return self;
}

#pragma mark -  Action

- (void)cancelButtonOnClick
{
    [self dismiss];
    if ([_delegate respondsToSelector:@selector(cancelAction)]) {
        [_delegate cancelAction];
    }
}

- (void)doneButtonOnClick
{
    [self dismiss];
    
    if ([_delegate respondsToSelector:@selector(popPicker:didSelectedAddress:)]) {
        [_delegate popPicker:self didSelectedAddress:self.addressModel];
    }
    
    if ([_delegate respondsToSelector:@selector(doneAction)]) {
        [_delegate doneAction];
    }
}


#pragma mark - Private Method

- (void)configureUI {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, kComponentHeight)];
    titleView.backgroundColor = [UIColor whiteColor];
    
    UIFont *font = [UIFont systemFontOfSize:16.0f];
    CGFloat buttonOffset = 10.0f;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(buttonOffset, 0, kButtonWidth, kButtonHeight);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor colorWithRed:81.0f / 255.0f green:81.0f / 255.0f blue:81.0f / 255.0f alpha:1] forState:UIControlStateNormal];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftButton.titleLabel.font = font;
    [leftButton addTarget:self action:@selector(cancelButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(self.frame.size.width - kButtonWidth - buttonOffset, 0, kButtonWidth, kButtonHeight);
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:255.0f/255.0f green:159.0f/255.0f blue:5.0f/255.0f alpha:1] forState:UIControlStateNormal];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightButton.titleLabel.font = font;
    [rightButton addTarget:self action:@selector(doneButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:rightButton];
    
    [self.bgView addSubview:titleView];
    
    // 创建picker view
    UIPickerView *addressPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, titleView.frame.size.height, UISCREEN_WIDTH, kPickerViewHeight - kButtonHeight)];
    addressPickerView.backgroundColor = [UIColor whiteColor];
    addressPickerView.delegate = self;
    addressPickerView.dataSource = self;
    addressPickerView.tag = 1;
    _addressPickerView = addressPickerView;
    [self.bgView addSubview:addressPickerView];
}

-(ChinaAddressModel *)addressModel {
    if (!_addressModel) {
        _addressModel = [[ChinaAddressModel alloc] init];
    }
    
    _addressModel.province = _currentProvince;
    _addressModel.city = _currentCity;
    _addressModel.country  = _currentCountry;
    
    return _addressModel;
}

// 加载地址信息
- (void)loadAddressMessage
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"province_data" ofType:@"xml"];
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    self.china = [[China alloc] initWithData:xmlData];
    
    _province = [[NSArray alloc] initWithArray:self.china.provinceArray];
    
    Province *province = [_province firstObject];
    _city = [[NSArray alloc] initWithArray:province.cityArray];
    
    City *city = [province.cityArray firstObject];
    _country = [[NSArray alloc] initWithArray:city.countryArray];
    
    _currentProvince = province.provinceName;
    _currentCity = city.cityName;
    _currentCountry = [_country firstObject];
    
//    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
//    
//    GDataXMLElement *rootElement = [doc rootElement];
//    
//    NSArray *provinces = [rootElement elementsForName:@"province"];
//    
//    NSMutableArray *provinceTmp = [NSMutableArray array];
//    NSMutableArray *cityTmp = [NSMutableArray array];
//    NSMutableArray *districtTmp = [NSMutableArray array];
//    
//    NSMutableDictionary *addressDict = [NSMutableDictionary dictionary];
//    
//    for (NSInteger i = 0; i < provinces.count; i++) {
//        
//        NSMutableDictionary *provinceDict = [NSMutableDictionary dictionary];
//        
//        GDataXMLElement *province = provinces[i];
//        NSString *provinceName = [[province attributeForName:@"name"] stringValue];
//        [provinceTmp addObject:provinceName];
//        
//        NSArray *citys = [province elementsForName:@"city"];
//        
//        NSMutableDictionary *cityDict = [NSMutableDictionary dictionary];
//        
//        for (NSInteger j = 0; j < citys.count; j++) {
//            
//            GDataXMLElement *city = citys[j];
//            NSString *cityName = [[city attributeForName:@"name"] stringValue];
//            if (i == 0) {
//                [cityTmp addObject:cityName];
//            }
//            
//            NSArray *districts = [city elementsForName:@"district"];
//            NSMutableArray *districtTems = [NSMutableArray array];
//            NSMutableDictionary *districtDict = [NSMutableDictionary dictionary];
//            
//            
//            for (NSInteger k = 0; k < districts.count; k++) {
//                GDataXMLElement *district = districts[k];
//                NSString *districtName = [[district attributeForName:@"name"] stringValue];
//                [districtTems addObject:districtName];
//                
//                if (i ==0 && j == 0) {
//                    [districtTmp addObject:districtName];
//                }
//            }
//            
//            [districtDict setObject:districtTems forKey:cityName];
//            
//            [cityDict setObject:districtDict forKey:[NSString stringWithFormat:@"%ld", (long)j]];
//        }
//        
//        [provinceDict setObject:cityDict forKey:provinceName];
//        
//        [addressDict setObject:provinceDict forKey:[NSString stringWithFormat:@"%ld", (long)i]];
//        
//    }
//    
//    _addressDictionary = [NSDictionary dictionaryWithDictionary:addressDict];
//    
//    _province = [[NSArray alloc] initWithArray:provinceTmp];
//    _city = [[NSArray alloc] initWithArray:cityTmp];
//    _district = [[NSArray alloc] initWithArray:districtTmp];
//    
//    _currentDictionary = @{@"province" : [_province firstObject], @"city" : [_city firstObject], @"district" : [_district firstObject]};
//    
//    
//    self.addressModel = [[ChinaAddressModel alloc] init];
//    self.addressModel.province = [_province firstObject];
//    self.addressModel.city = [_city firstObject];
//    self.addressModel.district  = [_district firstObject];
}

- (UILabel *)createCommonLabelForComponents
{
    UILabel *commonLabel = [[UILabel alloc] init];
    commonLabel.frame = CGRectMake(5, 0, (UISCREEN_WIDTH - 5 * 6 ) / 3.0, kComponentHeight);
    commonLabel.numberOfLines = 0;
    commonLabel.textAlignment = NSTextAlignmentCenter;
    commonLabel.textColor = [UIColor colorWithRed:81.0f / 255.0f green:81.0f / 255.0f blue:81.0f / 255.0f alpha:1];
    commonLabel.font = [UIFont systemFontOfSize:14];
    commonLabel.backgroundColor = [UIColor clearColor];
    return commonLabel;
}

#pragma mark - Public Method
- (void)show
{
    if (_isShow) {
        return ;
    }
    
    self.alpha = 1.0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    _isShow = YES;
    CGRect showFrame = self.bgView.frame;
    showFrame.origin.y -= kPickerViewHeight;
    [UIView animateWithDuration:0.3f animations:^{
        self.bgView.frame = showFrame;
    }];
}

- (void)dismiss
{
    if (!_isShow) {
        return ;
    }
    
    _isShow = NO;
    CGRect hideFrame = self.bgView.frame;
    hideFrame.origin.y += kPickerViewHeight;
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.bgView.frame = hideFrame;
        
    } completion:^(BOOL finished) {
        
        self.alpha = 0.0;
        [self removeFromSuperview];
    }];
}

#pragma mark - <UIPickerViewDataSource, UIPickerViewDelegate>

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return _province.count;
            break;
        case 1:
            return _city.count;
            break;
        case 2:
            return _country.count;
            break;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return kComponentHeight;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *itemLabel = [self createCommonLabelForComponents];
    if (component == 0) {
        
        Province *province = [_province objectAtIndex:row];
        
        itemLabel.text = province.provinceName;
        
    }else if (component == 1) {
        
        City *city = [_city objectAtIndex:row];
        
        itemLabel.text = city.cityName;
        
    }else {
        
        itemLabel.text = [_country objectAtIndex:row];
        
    }
    return itemLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        
        Province *province = [self.china.provinceArray objectAtIndex:row];
        _currentProvince = province.provinceName;
        _city = [[NSArray alloc] initWithArray:province.cityArray];
        
        City *city = [province.cityArray firstObject];
        _currentCity = city.cityName;
        _country = [[NSArray alloc] initWithArray:city.countryArray];
        
        _currentCountry = [_country firstObject];
        
        [_addressPickerView reloadComponent:1];
        [_addressPickerView reloadComponent:2];
        
        [_addressPickerView selectRow:0 inComponent:1 animated:YES];
        [_addressPickerView selectRow:0 inComponent:2 animated:YES];
        
    } else if (component == 1) {
        
        Province *province = [self.china findProvinceByName:_currentProvince];
        
        City *city = [province.cityArray objectAtIndex:row];
        _currentCity = city.cityName;
        _country = [[NSArray alloc] initWithArray:city.countryArray];
        _currentCountry = [_country firstObject];
        
        [_addressPickerView reloadComponent:2];
        
        [_addressPickerView selectRow:0 inComponent:2 animated: YES];
        
    } else if (component == 2) {
        
        _currentCountry = [_country objectAtIndex:row];
    }
    
    if ([_delegate respondsToSelector:@selector(popPicker:didSelectedAddress:)]) {
        [_delegate popPicker:self didSelectedAddress:self.addressModel];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self dismiss];
}

@end