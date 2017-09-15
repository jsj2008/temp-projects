//
//  XYSelectColorViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/12.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYSelectColorViewController.h"
#import "SimpleAlignCell.h"
#import "XYSelectPlanDetailViewController.h"

@interface XYSelectColorViewController ()<UITableViewDataSource,UITableViewDelegate,XYSelectPlanDetailDelegate>
@property(strong,nonatomic) UITableView* tableView;
@property(strong,nonatomic) NSArray* colorArray;
@property(strong,nonatomic) XYColorDto* selectedColor;

@property(assign,nonatomic) id<XYSelectColorDelegate> delegate;
@property(strong,nonatomic)NSString* deviceId;
@property(strong,nonatomic)NSString* brandId;
@property(strong,nonatomic)NSString* faultId;
@property(assign,nonatomic)XYBrandType bid;

@property(strong,nonatomic)NSString* allowedColorId;//指定展示颜色，没指定则显示全部
@property(assign,nonatomic)XYOrderType orderStatus;
@end

@implementation XYSelectColorViewController


- (instancetype)initWithDevice:(NSString*)deviceId
                         brand:(NSString*)brandId
                         fault:(NSString*)faultId
                           bid:(XYBrandType)bid
                      delegate:(id<XYSelectColorDelegate>)delegate
                  allowedColor:(NSString*)allowedColorId
                     orderType:(XYOrderType)orderStatus{
    if (self = [super init]) {
        self.delegate = delegate;
        self.brandId = brandId;
        self.deviceId = deviceId;
        self.faultId = faultId;
        self.bid = bid;
        self.allowedColorId = allowedColorId;
        self.orderStatus = orderStatus;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getColors];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override

- (void)initializeUIElements{
    self.navigationItem.title = @"选择颜色";
    [self shouldShowBackButton:true];
    [self.view addSubview:self.tableView];
}

#pragma mark - property 

- (NSArray*)colorArray{
    if (!_colorArray) {
        _colorArray = [[NSArray alloc]init];
    }
    return _colorArray;
}

- (UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT)];
        _tableView.backgroundColor = WHITE_COLOR;
        _tableView.separatorColor = TABLE_DEVIDER_COLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:[XYWidgetUtil getSingleLineWithInset:15]];
        [_tableView setTableHeaderView:nil];
        [SimpleAlignCell xy_registerTableView:_tableView identifier:[SimpleAlignCell defaultReuseId]];
    }
    return _tableView;
}

- (void)getColors{
    
    [self showLoadingMask];
    self.tableView.hidden = true;
    __weak typeof(self) weakself = self;
    [[XYAPIService shareInstance] getColorByDeviceId:self.deviceId fault:self.faultId bid:self.bid  success:^(NSArray *colors){
        weakself.colorArray = [self processColors:colors];
        [weakself hideLoadingMask];
        [weakself.tableView reloadData];
        weakself.tableView.hidden = false;
    }errorString:^(NSString *e){
        [weakself hideLoadingMask];
        [weakself showToast:e];
    }];
}

- (NSArray*)processColors:(NSArray*)colors{
    if (![XYStringUtil isNullOrEmpty:self.allowedColorId]) {
        for (XYColorDto* dto in colors) {
            if ([dto.ColorId isEqualToString:self.allowedColorId]) {
                return [NSArray arrayWithObject:dto];
            }
        }
        return [NSArray array];
    }else{
        return colors;
    }
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.colorArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SimpleAlignCell* cell = [tableView dequeueReusableCellWithIdentifier:[SimpleAlignCell defaultReuseId]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.xyTextLabel.font = LARGE_TEXT_FONT;
    cell.xyTextLabel.textColor = BLACK_COLOR;
    cell.xyIndicator.hidden = false;
    XYColorDto* dto = [self.colorArray objectAtIndex:indexPath.row];
    cell.xyTextLabel.text = [NSString stringWithFormat:@" %@",dto.ColorName];
    cell.xyDetailLabel.text = @"";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    self.selectedColor = [self.colorArray objectAtIndex:indexPath.row];
    XYSelectPlanDetailViewController* planViewController = [[XYSelectPlanDetailViewController alloc]initWithDelegate:self device:self.deviceId brand:self.brandId fault:self.faultId color:self.selectedColor.ColorId orderType:self.orderStatus];
    [self.navigationController pushViewController:planViewController animated:true];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}

#pragma mark - delegate

- (void)onPlanDetailSelected:(NSString*)planId descrption:(NSString *)repairType{
    if ([self.delegate respondsToSelector:@selector(onColorSelected:colorId:planId:planName:)]) {
        [self.delegate onColorSelected:self.selectedColor.ColorName colorId:self.selectedColor.ColorId planId:planId planName:repairType];
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
