//
//  CAXAAreaModel.h
//  DeYangCloud
//
//  Created by Caxa on 16/1/15.
//  Copyright © 2016年 X.T. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAXAAreaModel : NSObject

@property (nonatomic, copy) NSString *areaId;   //  地区标识
@property (nonatomic, copy) NSString *areaName;   //  地区名称
@property (nonatomic, strong) NSMutableArray *areaList; //  下级区域列表

@end
