//
//  ViewController.m
//  CaxaCitySelect
//
//  Created by Shaochong Du on 16/8/4.
//  Copyright © 2016年 Shaochong Du. All rights reserved.
//

#import "ViewController.h"
#import "CAXACitySelectViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)selectCity:(UIButton *)btn
{
    CAXACitySelectViewController *vc = [[CAXACitySelectViewController alloc] init];
    vc.citySelectBlock = ^(NSString *areaId, NSString *provinceName, NSString *cityName, NSString *districtName) {
        [btn setTitle:[NSString stringWithFormat:@"%@%@%@%@",provinceName,cityName,districtName,areaId] forState:UIControlStateNormal];
        NSLog(@"%@",[btn titleForState:UIControlStateNormal]);
    };
    [self.navigationController pushViewController:vc animated:YES];
}





@end
