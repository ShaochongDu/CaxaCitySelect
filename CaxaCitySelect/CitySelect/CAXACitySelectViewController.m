//
//  CAXACitySelectViewController.m
//  CaxaCitySelect
//
//  Created by Shaochong Du on 16/8/4.
//  Copyright © 2016年 Shaochong Du. All rights reserved.
//

#import "CAXACitySelectViewController.h"
#import "CAXAAreaModel.h"
#import "ListTableViewCell.h"

#define CAXAViewWidth self.view.bounds.size.width
#define CAXAViewHight self.view.bounds.size.height
#define CAXANavHeight 64    //  根据情况 是否为0或64

@interface CAXACitySelectViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *chinaAreaList;    //  全国省市数据
@property (nonatomic, strong) UITableView *provinceTableView;
@property (nonatomic, strong) UITableView *cityTableView;
@property (nonatomic, strong) UITableView *districtTableView;

@property (nonatomic, assign) NSInteger selectProvinceIndex;    //  当前选择的省份索引
@property (nonatomic, assign) NSInteger selectCityIndex;    //  当前选择的地市索引

@end

@implementation CAXACitySelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    [self setTableViews];
    
    [self loadDataFromFile:@"ChinaAreaList"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init table
/**
 *  初始化
 */
- (void)setTableViews
{
    self.selectProvinceIndex = 0;
    self.selectCityIndex = 0;
    
    self.provinceTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.provinceTableView.dataSource = self;
    self.provinceTableView.delegate = self;
    self.provinceTableView.showsVerticalScrollIndicator = NO;
    self.provinceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.provinceTableView];
    self.provinceTableView.tableFooterView = [[UIView alloc] init];
    
    self.cityTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.cityTableView.dataSource = self;
    self.cityTableView.delegate = self;
    self.cityTableView.showsVerticalScrollIndicator = NO;
    self.cityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.cityTableView];
    self.cityTableView.tableFooterView = [[UIView alloc] init];
    
    self.districtTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.districtTableView.dataSource = self;
    self.districtTableView.delegate = self;
    self.districtTableView.showsVerticalScrollIndicator = NO;
    self.districtTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.districtTableView];
    self.districtTableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - init data
- (void)loadDataFromFile:(NSString *)fileName
{
    //    NSString *str0 = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    //    NSArray *plistArray = [NSArray arrayWithContentsOfFile:str0];
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *plistArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    self.chinaAreaList = [NSMutableArray array];
    for (NSDictionary *provinceDic in plistArray) {
        CAXAAreaModel *provinceModel = [[CAXAAreaModel alloc] init];
        provinceModel.areaId = provinceDic[@"id"];
        provinceModel.areaName = provinceDic[@"name"];
        NSArray *cityArray = provinceDic[@"arealist"];
        NSMutableArray *cityModelArray = [NSMutableArray array];
        for (NSDictionary *cityDic in cityArray) {
            CAXAAreaModel *cityModel = [[CAXAAreaModel alloc] init];
            cityModel.areaId = cityDic[@"id"];
            cityModel.areaName = cityDic[@"name"];
            NSArray *countyArray = cityDic[@"arealist"];
            NSMutableArray *countryModelArray = [NSMutableArray array];
            for (NSDictionary *countryDic in countyArray) {
                CAXAAreaModel *countryModel = [[CAXAAreaModel alloc] init];
                countryModel.areaId = countryDic[@"id"];
                countryModel.areaName = countryDic[@"name"];
                [countryModelArray addObject:countryModel];
            }
            cityModel.areaList = countryModelArray;
            [cityModelArray addObject:cityModel];
        }
        provinceModel.areaList = cityModelArray;
        [self.chinaAreaList addObject:provinceModel];
    }
}

#pragma mark - 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.provinceTableView) {
        return self.chinaAreaList.count;
    } else if (tableView == self.cityTableView) {
        CAXAAreaModel *cityModel = self.chinaAreaList[self.selectProvinceIndex];
        return cityModel.areaList.count;
    } else if (tableView == self.districtTableView){
        CAXAAreaModel *cityModel = self.chinaAreaList[self.selectProvinceIndex];
        CAXAAreaModel *districtModel = cityModel.areaList[self.selectCityIndex];
        return districtModel.areaList.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.provinceTableView) {
        static NSString *cellIdentify = @"provinceTableView";
        ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ListTableViewCell" owner:self options:nil] lastObject];
        }
        CAXAAreaModel *provinceModel = self.chinaAreaList[indexPath.row];
        cell.titleLabel.text = provinceModel.areaName;
        return cell;
    } else if (tableView == self.cityTableView) {
        static NSString *cellIdentify = @"cityTableView";
        ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ListTableViewCell" owner:self options:nil] lastObject];
        }
        CAXAAreaModel *cityModel = self.chinaAreaList[self.selectProvinceIndex];
        CAXAAreaModel *model = cityModel.areaList[indexPath.row];
        cell.titleLabel.text = model.areaName;
        return cell;
    } else if (tableView == self.districtTableView) {
        static NSString *cellIdentify = @"districtTableView";
        ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ListTableViewCell" owner:self options:nil] lastObject];
        }
        CAXAAreaModel *cityModel = self.chinaAreaList[self.selectProvinceIndex];
        CAXAAreaModel *districtModel = cityModel.areaList[self.selectCityIndex];
        CAXAAreaModel *model = districtModel.areaList[indexPath.row];
        cell.titleLabel.text = model.areaName;
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.provinceTableView) {
        self.selectProvinceIndex = indexPath.row;
        
        CAXAAreaModel *cityModel = self.chinaAreaList[self.selectProvinceIndex];
        if (cityModel.areaList.count > 0) {
            //  具有下级列表
            self.provinceTableView.frame = CGRectMake(0, 0, CAXAViewWidth/2, CAXAViewHight);
            self.cityTableView.frame = CGRectMake(CAXAViewWidth/2, CAXANavHeight, CAXAViewWidth/2, CAXAViewHight-CAXANavHeight);
            self.districtTableView.frame = CGRectZero;
            
            [self.cityTableView reloadData];
        } else {
            if (self.citySelectBlock) {
                self.citySelectBlock(cityModel.areaId,cityModel.areaName,@"",@"");
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (tableView == self.cityTableView) {
        self.selectCityIndex = indexPath.row;
        
        CAXAAreaModel *cityModel = self.chinaAreaList[self.selectProvinceIndex];
        CAXAAreaModel *model = cityModel.areaList[indexPath.row];
        if (model.areaList.count > 0) {
            //  具有下级列表
            self.provinceTableView.frame = CGRectMake(0, 0, CAXAViewWidth/3, CAXAViewHight);
            self.cityTableView.frame = CGRectMake(CAXAViewWidth/3, CAXANavHeight, CAXAViewWidth/3, CAXAViewHight-CAXANavHeight);
            self.districtTableView.frame = CGRectMake(CAXAViewWidth/3*2, CAXANavHeight, CAXAViewWidth/3, CAXAViewHight-CAXANavHeight);
            
            [self.districtTableView reloadData];
        } else {
            if (self.citySelectBlock) {
                self.citySelectBlock(model.areaId,cityModel.areaName,model.areaName,@"");
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (tableView == self.districtTableView) {
        CAXAAreaModel *cityModel = self.chinaAreaList[self.selectProvinceIndex];
        CAXAAreaModel *districtModel = cityModel.areaList[self.selectCityIndex];
        CAXAAreaModel *model = districtModel.areaList[indexPath.row];
        if (model.areaList.count > 0) {
            //  具有下级列表
            NSLog(@"只对3级列表处理  其他不处理");
        } else {
            if (self.citySelectBlock) {
                self.citySelectBlock(model.areaId,cityModel.areaName,districtModel.areaName,model.areaName);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
