//
//  XYPromotionBonusViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 16/6/20.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYPromotionBonusViewController.h"
#import "XYBonusCell.h"
#import "XYAPIService+V5API.h"
#import "SDTrackTool.h"

@interface XYPromotionBonusViewController ()<UITableViewDataSource,UITableViewDelegate,XYTableViewWebDelegate>
@property(assign,nonatomic)XYBonusListType type;
@property(strong,nonatomic)XYBaseTableView* tableView;
@end

@implementation XYPromotionBonusViewController

- (instancetype)initWithType:(XYBonusListType)type{
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showLoadingMask];
    [self.tableView refresh];
}

- (void)initializeUIElements{
    switch (self.type) {
        case XYBonusListTypeToday:
            self.navigationItem.title = @"今日提成";
            [SDTrackTool logEvent:@"PAGE_EVENT_XYPromotionBonusViewController_TODAY"];
            break;
        case XYBonusListTypeMonth:
            self.navigationItem.title = @"本月提成";
            [SDTrackTool logEvent:@"PAGE_EVENT_XYPromotionBonusViewController_MONTH"];
            break;
        case XYBonusListTypeTotal:
            self.navigationItem.title = @"历史提成";
            [SDTrackTool logEvent:@"PAGE_EVENT_XYPromotionBonusViewController_TOTAL"];
            break;
        default:
            self.type = XYBonusListTypeToday;
            self.navigationItem.title = @"今日提成";
            [SDTrackTool logEvent:@"PAGE_EVENT_XYPromotionBonusViewController_TODAY"];
            break;
    }
    [self.view addSubview:self.tableView];
}

- (XYBaseTableView*)tableView{
    if (!_tableView) {
        _tableView = [[XYBaseTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT)];
        _tableView.backgroundColor = XY_COLOR(238,240,243);
        _tableView.separatorColor = TABLE_DEVIDER_COLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.webDelegate = self;
        [_tableView setTableHeaderView:nil];
        [_tableView setTableFooterView:[XYWidgetUtil getSingleLineWithInset:15]];
        [XYBonusCell xy_registerTableView:_tableView identifier:[XYBonusCell defaultIdentifier]];
    }
    return _tableView;
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableView.dataList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYBonusCell* cell = [tableView dequeueReusableCellWithIdentifier:[XYBonusCell defaultIdentifier]];
    XYPromotionBonusDetail* dto = [self.tableView.dataList objectAtIndex:indexPath.row];
    [cell setPromotionBonusData:dto];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [XYBonusCell getHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(XYBaseTableView *)tableView loadData:(NSInteger)p{
    [self getDataOfPage:p];
}


- (void)getDataOfPage:(NSInteger)page{
    __weak __typeof(self)weakSelf = self;
    [[XYAPIService shareInstance]getPromotionBonusList:self.type page:page success:^(NSArray *bonusList,NSInteger sum) {
        [weakSelf hideLoadingMask];
        [weakSelf.tableView addListItems:bonusList isRefresh:true withTotalCount:sum];
        [weakSelf.tableView reloadData];
    } errorString:^(NSString *error) {
        [weakSelf.tableView onLoadingFailed];
        [weakSelf hideLoadingMask];
        [weakSelf showToast:error];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

