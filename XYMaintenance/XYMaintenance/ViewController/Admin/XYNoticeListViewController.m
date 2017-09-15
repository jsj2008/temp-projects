//
//  XYNoticeListViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 16/2/19.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYNoticeListViewController.h"
#import "XYNoticeDetailViewController.h"
#import "XYNewsCell.h"
#import "HMSegmentedControl.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "SDTrackTool.h"

static const CGFloat SegControlH = 45.0f;
@interface XYNoticeListViewController ()<UITableViewDataSource,UITableViewDelegate,XYTableViewWebDelegate>
@property(strong,nonatomic)XYBaseTableView* tableView;
@property(strong,nonatomic)HMSegmentedControl* segControl;
@property(strong,nonatomic)NSArray* segTitleArray;
@property(strong,nonatomic)NSArray* newsSorts;
@property(copy,nonatomic)NSString* categoryId;
@property(copy,nonatomic)NSMutableDictionary* totalNewsDic;
@end

@implementation XYNoticeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self getNewsSortList];
}

- (void)refreshNoticeList{
    [self.segControl setSelectedIndex:0];
}

#pragma mark - initilize

- (void)initializeUIElements{
    self.navigationItem.title = @"公告";
    self.view.backgroundColor = XY_HEX(0xeef0f3);
    [self.view addSubview:self.tableView];
}

#pragma mark - property
- (NSArray*)segTitleArray{
    if (!_segTitleArray) {
        NSMutableArray *titles = [[NSMutableArray alloc] init];
        if (self.newsSorts.count) {
            for (XYNewsSortDto *newsSort in self.newsSorts) {
                [titles addObject:newsSort.name];
            }
            _segTitleArray = [titles copy];
        }else {
            _segTitleArray = @[@"全部公告"];
        }
    }
    return _segTitleArray;
}

-(NSMutableDictionary *)totalNewsDic {
    if (!_totalNewsDic) {
        _totalNewsDic = [[NSMutableDictionary alloc] init];
    }
    return _totalNewsDic;
}

-(NSArray *)newsSorts {
    if (!_newsSorts) {
        _newsSorts = [[NSArray alloc] init];
    }
    return _newsSorts;
}

- (HMSegmentedControl*)segControl{
    if (!_segControl) {
        _segControl = [[HMSegmentedControl alloc]initWithSectionTitles:self.segTitleArray];
        for (int i=0; i<self.newsSorts.count; i++) {
            XYNewsSortDto *newsSort = self.newsSorts[i];
            [_segControl setRedSpot:newsSort.isNew  forIndex:i];
        }
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
        _tableView = [[XYBaseTableView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT-SegControlH)];
        _tableView.backgroundColor = XY_HEX(0xeef0f3);
        _tableView.separatorColor = XY_HEX(0xeef0f3);
        [_tableView setTableFooterView:[[UIView alloc]init]];
        [XYNewsCell xy_registerTableView:_tableView identifier:[XYNewsCell defaultReuseId]];
        _tableView.webDelegate = self;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

#pragma mark - request
- (void)getNewsSortList {
    __weak typeof(self) weakself = self;
    [[XYAPIService shareInstance] getNewsSortList:^(NSArray *newsSortList, NSInteger sum) {
        self.newsSorts = newsSortList;
        if (self.newsSorts.count) {
            [self.view addSubview:self.segControl];
            [self.segControl setSelectedIndex:0];
        }else {
            self.categoryId = nil;
            [self showToast:@"暂无公告"];
            self.tableView.scrollEnabled = NO;
        }
    } errorString:^(NSString *error) {
        [weakself.tableView onLoadingFailed];
        [weakself showToast:error];
    }];
}

#pragma mark - segment

- (void)onSegmentSelected:(id)sender{
    
    HMSegmentedControl *segControl = (HMSegmentedControl *)sender;
    NSInteger index = segControl.selectedIndex;
    XYNewsSortDto *newSort  = self.newsSorts[index];
    self.categoryId = newSort.Id;
    if ([self.totalNewsDic objectForKey:self.categoryId]) {
        //内存加载数据
        NSArray *newsList = self.totalNewsDic[self.categoryId];
        [self.tableView addListItems:newsList isRefresh:(YES) withTotalCount:newsList.count];
    }else {
        //请求数据
        [self showLoadingMask];
        [self.tableView refresh];
    }
}

#pragma mark - tableView
- (void)tableView:(XYBaseTableView*)tableView loadData:(NSInteger)p{
    
    __weak typeof(self) weakself = self;
    [[XYAPIService shareInstance] getNewsList:p categoryId:self.categoryId success:^(NSArray *newsList, NSInteger sum) {
        [self hideLoadingMask];
        [weakself.tableView addListItems:newsList isRefresh:(p==1) withTotalCount:sum];
        if (![XYStringUtil isNullOrEmpty:self.categoryId]) {
            [self.totalNewsDic setValue:newsList forKey:self.categoryId];
        }
        
    } errorString:^(NSString *error) {
        [self hideLoadingMask];
        [weakself.tableView onLoadingFailed];
        [weakself showToast:error];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tableView.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYNewsDto* newsDto = self.tableView.dataList[indexPath.row];
    return [tableView fd_heightForCellWithIdentifier:[XYNewsCell defaultReuseId] cacheByKey:newsDto.id configuration:^(XYNewsCell* cell) {
        [cell setData:newsDto];
    }];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYNewsCell* cell = [tableView dequeueReusableCellWithIdentifier:[XYNewsCell defaultReuseId]];
    XYNewsDto* newsDto = self.tableView.dataList[indexPath.row];
    [cell setData:newsDto];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    XYNewsDto* newsDto = self.tableView.dataList[indexPath.row];
    XYNoticeDetailViewController* detailViewController = [[XYNoticeDetailViewController alloc]init];
    detailViewController.noticeId = newsDto.id;
    detailViewController.linkUrl = newsDto.link;
    detailViewController.view_count = newsDto.view_count;
    [self.navigationController pushViewController:detailViewController animated:true];
}


@end
