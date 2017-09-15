//
//  XYSelectCityViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/17.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYSelectCityViewController.h"
#import "SimpleAlignCell.h"
#import "XYSelectAreaViewController.h"

@interface XYSelectCityViewController ()<UITableViewDataSource,UITableViewDelegate,XYSelectAreaDelegate>
@property(strong,nonatomic)UITableView* tableView;
@property(strong,nonatomic)NSDictionary* cityDict;
@property(strong,nonatomic)NSArray* cityArray;
@property(strong,nonatomic)NSString* cityName;
@property(strong,nonatomic)NSString* cityId;
@end

@implementation XYSelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getAllCities];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override

- (void)initializeData
{
    self.cityArray  = [[NSArray alloc]init];
}

- (void)initializeUIElements
{
    self.navigationItem.title = @"选择城市";
    [self shouldShowBackButton:true];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT)];
    _tableView.backgroundColor = WHITE_COLOR;
    _tableView.separatorColor = TABLE_DEVIDER_COLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setTableFooterView:[XYWidgetUtil getSingleLineWithInset:15]];
    [_tableView setTableHeaderView:nil];
    [SimpleAlignCell xy_registerTableView:_tableView identifier:[SimpleAlignCell defaultReuseId]];
    [self.view addSubview:_tableView];
}

-(void)getAllCities
{
    [self showLoadingMask];
    __weak typeof(self) weakself = self;
    
    [[XYAPIService shareInstance] getCityList:^(NSDictionary *cities)
    {
         if (cities!=nil)
         {
             self.cityDict = cities;
             self.cityArray  = [cities allValues];
         }
        
         [weakself hideLoadingMask];
         [_tableView reloadData];
     }
     errorString:^(NSString *e)
     {
         [weakself hideLoadingMask];
         [weakself showToast:e];
     }];
}



#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cityArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SimpleAlignCell* cell = [tableView dequeueReusableCellWithIdentifier:[SimpleAlignCell defaultReuseId]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.xyTextLabel.font = LARGE_TEXT_FONT;
    cell.xyTextLabel.textColor = BLACK_COLOR;
    cell.xyIndicator.hidden = false;
    
    cell.xyTextLabel.text = [self.cityArray objectAtIndex:indexPath.row];
    cell.xyDetailLabel.text = @"";
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    self.cityName = [self.cityArray objectAtIndex:indexPath.row];
    
    for (NSString* key in [self.cityDict allKeys]) {
        if ([[self.cityDict objectForKey:key] isEqualToString:self.cityName]) {
            self.cityId = key ;
            break;
        }
    }
    
    XYSelectAreaViewController* detailViewController = [[XYSelectAreaViewController alloc]initWithCityId:self.cityId];
    detailViewController.delegate = self;
    [self.navigationController pushViewController:detailViewController animated:true];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}

#pragma mark - action

-(void)onAreaSelected:(NSString*)areaId areaName:(NSString *)name
{
    if ([self.delegate respondsToSelector:@selector(onCitySelected:city:area:area:)]) {
        [self.delegate onCitySelected:self.cityId city:self.cityName area:areaId area:name];
    }
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
