//
//  CAXACitySelectViewController.h
//  CaxaCitySelect
//
//  Created by Shaochong Du on 16/8/4.
//  Copyright © 2016年 Shaochong Du. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^citySelectBlock)(NSString *areaId, NSString *provinceName, NSString *cityName, NSString *districtName);

@interface CAXACitySelectViewController : UIViewController

@property (nonatomic, copy) citySelectBlock citySelectBlock;

@end
