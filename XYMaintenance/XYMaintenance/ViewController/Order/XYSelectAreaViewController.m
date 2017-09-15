//
//  XYSelectAreaViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/17.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYSelectAreaViewController.h"
#import "XYAPIService.h"
#import "SimpleAlignCell.h"

@interface XYSelectAreaViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(copy,nonatomic)NSString* cityId;
@property(strong,nonatomic)NSDictionary* areaDict;
@property(strong,nonatomic)NSArray* areaArray;
@property(strong,nonatomic)UITableView* tableView;
@end

@implementation XYSelectAreaViewController

-(id)initWithCityId:(NSString*)cityId
{
    if (self = [super init]){
        _cityId = [cityId copy];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override

-(void)initializeUIElements
{
    self.navigationItem.title = @"选择地区";
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
    
    [self getAreasArray];
}

-(void)getAreasArray
{
    [self showLoadingMask];
     __weak typeof(self) weakself = self;
    [[XYAPIService shareInstance] getDistrictList:self.cityId success:^(NSDictionary *areas)
     {
         if (areas!=nil)
         {
             self.areaDict = areas;
             self.areaArray  = [areas allValues];
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
    return [self.areaArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SimpleAlignCell* cell = [tableView dequeueReusableCellWithIdentifier:[SimpleAlignCell defaultReuseId]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.xyTextLabel.font = LARGE_TEXT_FONT;
    cell.xyTextLabel.textColor = BLACK_COLOR;
    cell.xyIndicator.hidden = true;
    
    cell.xyTextLabel.text = [self.areaArray objectAtIndex:indexPath.row];
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
    
    NSString* areaName = [self.areaArray objectAtIndex:indexPath.row];
    NSString* areaId = nil;
    for (NSString* key in [self.areaDict allKeys]) {
        if ([[self.areaDict objectForKey:key] isEqualToString:areaName]) {
            areaId = [key copy];
            break;
        }
    }
    if ([self.delegate respondsToSelector:@selector(onAreaSelected:areaName:)]) {
        [self.delegate onAreaSelected:areaId areaName:areaName];
    }
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
