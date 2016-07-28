//
//  ZSPickerView.h
//  UIPickerViewDemo
//
//  Created by 周顺 on 16/7/6.
//  Copyright © 2016年 AIRWALK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChinaAddressModel : NSObject

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *country;

@end

@class ZSPickerView;

@protocol ZSPickerViewDelegate <NSObject>

@optional

- (void)popPicker:(ZSPickerView *)popPicker didSelectedAddress:(ChinaAddressModel *)address;

- (void)cancelAction;
- (void)doneAction;

@end

@interface ZSPickerView : UIView

@property (nonatomic, assign) id <ZSPickerViewDelegate> delegate;

- (void)show;

@end
