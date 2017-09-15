//
//  XYRankViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 16/2/19.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYRankViewController.h"
#import "HMSegmentedControl.h"
#import "XYRankCell.h"
#import "SDTrackTool.h"


@interface XYRankViewController ()<UITableViewDelegate,UITableViewDataSource,XYTableViewWebDelegate>
@property(strong,nonatomic) XYBaseTableView* tableView;
@property(strong,nonatomic) HMSegmentedControl* segControl;
@property(strong,nonatomic) XYRankDto* myRankDto;
@property(strong,nonatomic) XYPromotionRankDto* myPromotionRankDto;
@property(strong,nonatomic) NSArray* segTitleArray;

@end

@implementation XYRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.segControl setSelectedIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - override

- (void)initializeUIElements{
    self.navigationItem.title = @"排行榜";
    [self.view addSubview:self.segControl];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = self.tableView.backgroundColor;
    [self.tableView setHidden:true];
}

#pragma mark - property

- (NSArray*)segTitleArray{
    if (!_segTitleArray) {
        _segTitleArray = @[@"今日全国",@"今日城市",@"本月全国",@"本月城市",@"城市地推",@"个人地推"];
    }
    return _segTitleArray;
}

- (HMSegmentedControl*)segControl{
    if (!_segControl) {
        _segControl = [[HMSegmentedControl alloc]initWithSectionTitles:self.segTitleArray];
        _segControl.font = SMALL_TEXT_FONT;
        _segControl.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
        _segControl.backgroundColor = WHITE_COLOR;
        _segControl.tintColor = THEME_COLOR;
        [_segControl addTarget:self action:@selector(onSegmentSelected:) forControlEvents:UIControlEventValueChanged];
    }
    return _segControl;
}

- (XYBaseTableView*)tableView{
    if (!_tableView) {
        _tableView = [[XYBaseTableView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT - 45)];
        _tableView.backgroundColor = XY_HEX(0xeef0f3);
        _tableView.separatorColor = XY_HEX(0xeef0f3);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.webDelegate = self;
        [XYRankCell xy_registerTableView:_tableView identifier:[XYRankCell defaultReuseId]];
    }
    return _tableView;
}

#pragma mark - segment

- (void)onSegmentSelected:(id)sender{
    [self showLoadingMask];
    [self.tableView refresh];
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        XYRankingListType type = (XYRankingListType)self.segControl.selectedIndex;
        switch (type) {
            case XYRankingListTypeTodayCountry:
            case XYRankingListTypeTodayCity:
            case XYRankingListTypeMonthCountry:
            case XYRankingListTypeMonthCity:
                return self.myRankDto?1:0;
                break;
            case XYRankingListTypePromotionCity:
            case XYRankingListTypePromotionPerson:
                return self.myPromotionRankDto?1:0;
            default:
                break;
        }
    }else{
        return [self.tableView.dataList count];
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isKindOfClass:[XYBaseTableView class]]){
        XYRankCell* cell = [tableView dequeueReusableCellWithIdentifier:[XYRankCell defaultReuseId]];
        XYRankingListType type = (XYRankingListType)self.segControl.selectedIndex;
        switch (type) {
                //订单排行
            case XYRankingListTypeTodayCountry:
            case XYRankingListTypeTodayCity:
            case XYRankingListTypeMonthCountry:
            case XYRankingListTypeMonthCity:
                [self configRankCell:cell indexPath:indexPath];
                break;
                //地推排行
            case XYRankingListTypePromotionCity:
            case XYRankingListTypePromotionPerson:
                [self configPromotionCell:cell indexPath:indexPath type:type];
                break;
            default:
                break;
        }
        return cell;
    }
    return nil;
}

- (void)configRankCell:(XYRankCell*)cell indexPath:(NSIndexPath*)path{
    if (path.section == 0) {
        [cell setRankData:self.myRankDto];
    }else{
        NSObject *obj = [self.tableView.dataList objectAtIndex:path.row];
        if (![obj isKindOfClass:[XYRankDto class]]) {
            return;
        }
        XYRankDto* dto = [self.tableView.dataList objectAtIndex:path.row];
        [cell setRankData:dto];
    }
}

- (void)configPromotionCell:(XYRankCell*)cell indexPath:(NSIndexPath*)indexPath type:(XYRankingListType)type{
    if (indexPath.section == 0) {
        [cell setPromotionData:self.myPromotionRankDto type:type];
    }else{
        NSObject *obj = [self.tableView.dataList objectAtIndex:indexPath.row];
        if (![obj isKindOfClass:[XYPromotionRankDto class]]) {
            return;
        }
        XYPromotionRankDto* dto = [self.tableView.dataList objectAtIndex:indexPath.row];
        dto.key = indexPath.row + 1;
        [cell setPromotionData:dto type:type];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [XYRankCell defaultHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (section == 0)? 0:10;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [[UIView alloc]init];
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,10)];
    view.backgroundColor = XY_HEX(0xeef0f3);
    return view;
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
    XYRankingListType type = (XYRankingListType)self.segControl.selectedIndex;
    switch (type) {
        //订单排行
        case XYRankingListTypeTodayCountry:
        case XYRankingListTypeTodayCity:
        case XYRankingListTypeMonthCountry:
        case XYRankingListTypeMonthCity:
            [self loadRankList:p type:type];
            break;
        //地推排行
        case XYRankingListTypePromotionCity:
        case XYRankingListTypePromotionPerson:
            [self loadPromotionRankList:p type:type];
            break;
        default:
            break;
    }
    
}

- (void)loadRankList:(NSInteger)page type:(XYRankingListType)type{
    //一次性获取整个列表 服务端同事表示无法分页 orz  @chenr
    __weak typeof(self) weakself = self;
    [[XYAPIService shareInstance]getRankList:page
                                        type:type
                                     success:^(XYRankDto *myRank, NSArray *newsList, NSInteger sum) {
        [weakself hideLoadingMask];
        weakself.myRankDto = myRank;
        [weakself.tableView addListItems:newsList isRefresh:(page==1) withTotalCount:sum];
        //更新今日我的排名
        if (weakself.segControl.selectedIndex == XYRankingListTypeTodayCountry) {
            if ([weakself.delegate respondsToSelector:@selector(onMyRankLoaded:)]) {
                [weakself.delegate onMyRankLoaded:myRank];
            }
        }
        [weakself.tableView setHidden:false];
    } errorString:^(NSString *error) {
        [weakself hideLoadingMask];
        if (page==1) {
            [weakself.tableView addListItems:nil isRefresh:true withTotalCount:0];
        }else{
            [weakself.tableView onLoadingFailed];
        }
        [weakself showToast:error];
    }];
}

//地推排行
- (void)loadPromotionRankList:(NSInteger)page type:(XYRankingListType)type{
    //可以分页
    __weak typeof(self) weakself = self;
    [[XYAPIService shareInstance]getPromotionRankList:page
                                        type:type
                                     success:^(XYPromotionRankDto *myRank, NSArray *newsList, NSInteger sum) {
       [weakself hideLoadingMask];
       weakself.myPromotionRankDto = myRank;
       [weakself.tableView addListItems:newsList isRefresh:(page==1) withTotalCount:sum];
       [weakself.tableView setHidden:false];
    } errorString:^(NSString *error) {
       [weakself hideLoadingMask];
       if (page==1) {
          [weakself.tableView addListItems:nil isRefresh:true withTotalCount:0];
       }else{
          [weakself.tableView onLoadingFailed];
       }
       [weakself showToast:error];
    }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView){
        CGFloat sectionHeaderHeight = 10;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
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
