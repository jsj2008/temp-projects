//
//  XYMyPartsViewController.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/21.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYMyPartsViewController.h"
#import "XYPartListTableView.h"
#import "XYMyPartsViewModel.h"
#import "HMSegmentedControl.h"
#import "XYPartRecordDetailViewController.h"
#import "XYPartsRecordsHeaderView.h"
#import "XYPartDeviceViewController.h"
#import "XYPartApplyRecordViewController.h"
#import "XYPartApplyViewController.h"

@interface XYMyPartsViewController ()<XYPartListTableViewDelegate,XYTableViewWebDelegate,XYMyPartsCallBackDelegate,XYPartsFlowSearchDelegate,XYPartDeviceDelegate>
//UI
@property(strong,nonatomic)HMSegmentedControl* segmentControl;
@property(strong,nonatomic)UIScrollView* scrollView;
@property(strong,nonatomic)XYPartListTableView* myPartsListView;
@property(strong,nonatomic)XYPartListTableView* applyListView;
@property(strong,nonatomic)XYPartListTableView* recordsListView;
@property(strong,nonatomic)XYPartListTableView* partsFlowListView;
@property(strong,nonatomic)XYPartsRecordsHeaderView* searchHeaderView;
@property(strong,nonatomic)XYPartsRecordsHeaderView* filtertimeHeaderView;
@property (strong,nonatomic) UIBarButtonItem* applyButtonItem;
//VM
@property(strong,nonatomic)XYMyPartsViewModel* viewModel;
@end

@implementation XYMyPartsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.recordsListView reloadData];
    if (self.isClaimPartsNotify) {
        self.segmentControl.selectedIndex = 2;
        [self onSegmentSelected:self.segmentControl];
    }
}

- (void)dealloc{
    self.viewModel.delegate = nil;
    [self.viewModel cancelAllRequests];
}

#pragma mark - override

- (void)initializeModelBinding{
    self.viewModel = [[XYMyPartsViewModel alloc]init];
    self.viewModel.delegate = self;
}

- (void)initializeUIElements{
    //导航
    self.navigationItem.title = @"我的配件";
    self.navigationItem.rightBarButtonItem = self.refreshButtonItem;
    [self shouldShowBackButton:true];
    self.automaticallyAdjustsScrollViewInsets = false;
    //列表
    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.myPartsListView];
    [self.scrollView addSubview:self.applyListView];
    [self.scrollView addSubview:self.recordsListView];
    [self.scrollView addSubview:self.partsFlowListView];
    //加载
    [self.myPartsListView refresh];
    [self.applyListView refresh];
    [self.recordsListView refresh];
    [self.partsFlowListView refresh];
}


#pragma mark - property
- (UIBarButtonItem*)refreshButtonItem{
    if (!_applyButtonItem) {
        _applyButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"申请" style:UIBarButtonItemStylePlain target:self action:@selector(goTOApplyVc)];
    }
    return _applyButtonItem;
}

- (HMSegmentedControl*)segmentControl{
    if (!_segmentControl) {
        _segmentControl = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"配件数量",@"申请记录",@"领取记录",@"配件流水"]];
        _segmentControl.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
        _segmentControl.backgroundColor = WHITE_COLOR;
        _segmentControl.tintColor = THEME_COLOR;
        [_segmentControl addTarget:self action:@selector(onSegmentSelected:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

- (UIScrollView*)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.segmentControl.frame.origin.y + _segmentControl.frame.size.height, SCREEN_WIDTH, SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT - (self.segmentControl.frame.origin.y + self.segmentControl.frame.size.height))];
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * [self.segmentControl.sectionTitles count], _scrollView.frame.size.height);
        _scrollView.backgroundColor = BACKGROUND_COLOR;
        _scrollView.pagingEnabled = true;
        _scrollView.scrollEnabled = false;
    }
    return _scrollView;
}

- (XYPartListTableView*)myPartsListView{
    if (!_myPartsListView) {
        _myPartsListView = [[XYPartListTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.bounds.size.height)];
        _myPartsListView.type = XYPartListViewTypeMyParts;
        [_myPartsListView setTableHeaderView:nil];
        _myPartsListView.backgroundColor = XY_COLOR(238,240,243);
        _myPartsListView.webDelegate = self;
        _myPartsListView.partListViewDelegate=self;
        _myPartsListView.tag=XYPartListViewTypeMyParts;
    }
    return _myPartsListView;
}

- (XYPartListTableView*)applyListView{
    if (!_applyListView) {
        _applyListView = [[XYPartListTableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.bounds.size.height)];
        _applyListView.type = XYPartListViewTypePartsApplyLog;
        [_applyListView setTableHeaderView:self.filtertimeHeaderView];
        _applyListView.backgroundColor = XY_COLOR(238,240,243);
        _applyListView.webDelegate = self;
        _applyListView.partListViewDelegate=self;
        _applyListView.tag=XYPartListViewTypePartsApplyLog;
        _applyListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _applyListView;
}

- (XYPartListTableView*)recordsListView{
    if (!_recordsListView) {
        _recordsListView = [[XYPartListTableView alloc]initWithFrame:CGRectMake(2*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.bounds.size.height)];
        _recordsListView.type = XYPartListViewTypeClaimRecords;
        [_recordsListView setTableHeaderView:nil];
        _recordsListView.backgroundColor = XY_COLOR(238,240,243);
        _recordsListView.webDelegate = self;
        _recordsListView.partListViewDelegate=self;
        _recordsListView.tag=XYPartListViewTypeClaimRecords;
    }
    return _recordsListView;
}

- (XYPartListTableView*)partsFlowListView{
    if(!_partsFlowListView){
        _partsFlowListView = [[XYPartListTableView alloc]initWithFrame:CGRectMake(3*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.bounds.size.height)];
        _partsFlowListView.type = XYPartListViewTypePartsFlow;
        [_partsFlowListView setTableHeaderView:self.searchHeaderView];
        _partsFlowListView.backgroundColor = XY_COLOR(238,240,243);
        _partsFlowListView.webDelegate = self;
        _partsFlowListView.partListViewDelegate=self;
        _partsFlowListView.tag= XYPartListViewTypePartsFlow;
    }
    return _partsFlowListView;
}

- (XYPartsRecordsHeaderView *)searchHeaderView {
    if(!_searchHeaderView){
        _searchHeaderView = [XYPartsRecordsHeaderView recordsHeaderView];
        _searchHeaderView.delegate = self;
        _searchHeaderView.startTimeField.text = XY_NOTNULL(self.viewModel.startTime, @"");
        _searchHeaderView.endTimeField.text = XY_NOTNULL(self.viewModel.endTime, @"");
        _searchHeaderView.partField.text = XY_NOTNULL(self.viewModel.partName, @"");
    }
    return _searchHeaderView;
}

-(XYPartsRecordsHeaderView *)filtertimeHeaderView {
    if(!_filtertimeHeaderView){
        _filtertimeHeaderView = [XYPartsRecordsHeaderView filtertimeView];
        _filtertimeHeaderView.delegate = self;
    }
    return _filtertimeHeaderView;
}

#pragma mark - segment 

- (void)onSegmentSelected:(id)sender{
    HMSegmentedControl* segControl = (HMSegmentedControl*)sender;
    self.scrollView.contentOffset = CGPointMake(segControl.selectedIndex * SCREEN_WIDTH,0);
}

#pragma mark - tableView action

- (void)tableView:(XYBaseTableView *)tableView loadData:(NSInteger)p{
    if ([tableView isEqual:self.myPartsListView]){
        [self.viewModel loadMyPartsList];
    }else if ([tableView isEqual:self.applyListView]){
        [self.viewModel loadApplyRecord:p startDate:self.viewModel.startTime_partApplyLog endDate:self.viewModel.endTime_partApplyLog];
    }else if ([tableView isEqual:self.recordsListView]){
        [self.viewModel loadClaimRecord:p];
    }else if([tableView isEqual:self.partsFlowListView]){
        [self.viewModel loadPartsFlow:p startDate:self.viewModel.startTime endDate:self.viewModel.endTime part:self.viewModel.partId];
    }
}

- (void)confirmClaimRecord:(NSString *)recordId bid:(XYBrandType)bid{
    [self showLoadingMask];
    [self.viewModel confirmClaimRecord:recordId bid:bid];
}

- (void)goToClaimRecordDetail:(XYPartRecordDto *)record{
    XYPartRecordDetailViewController* detailController = [[XYPartRecordDetailViewController alloc]init];
    detailController.recordDto = record;
    [self.navigationController pushViewController:detailController animated:true];
}

- (void)goToApplyRecordVc:(XYPartsApplyLogDto*)partsApplyLogDto{
    XYPartApplyRecordViewController* detailController = [[XYPartApplyRecordViewController alloc]init];
    detailController.partsApplyLogDto = partsApplyLogDto;
    [self.navigationController pushViewController:detailController animated:true];
}
#pragma mark - call back

- (void)onPartsLoaded:(NSArray*)parts success:(BOOL)success note:(NSString*)noteString{
    if (success) {
        [self.myPartsListView addListItems:parts isRefresh:true withTotalCount:[parts count]];
    }else{
        [self.myPartsListView onLoadingFailed];
        [self showToast:noteString];
    }
}

-(void)onApplyLoaded:(NSArray *)records total:(NSInteger)sum isRefresh:(BOOL)refresh success:(BOOL)success note:(NSString *)noteString{
    if (success) {
        [self.applyListView addListItems:records isRefresh:refresh withTotalCount:sum];
    }else{
        [self.applyListView onLoadingFailed];
        [self showToast:noteString];
    }
}

- (void)onRecordsLoaded:(NSArray*)records total:(NSInteger)sum isRefresh:(BOOL)refresh success:(BOOL)success note:(NSString*)noteString;{
    if (success) {
        [self.recordsListView addListItems:records isRefresh:refresh withTotalCount:sum];
    }else{
        [self.recordsListView onLoadingFailed];
        [self showToast:noteString];
    }
}

- (void)onPartsFlowLoaded:(NSArray *)records total:(NSInteger)sum isRefresh:(BOOL)refresh success:(BOOL)success note:(NSString *)noteString{
    if (success) {
        [self.partsFlowListView addListItems:records isRefresh:refresh withTotalCount:sum];
    }else{
        [self.partsFlowListView onLoadingFailed];
        [self showToast:noteString];
    }
}

- (void)onClaimingRecord:(NSString*)recordId success:(BOOL)success note:(NSString*)noteString{
    [self hideLoadingMask];
    if (!success) {//领取失败
        [self showToast:noteString?noteString:@"领取失败"];
        return;
    }
    //成功，遍历列表改状态
    for (XYPartRecordDto* record in self.recordsListView.dataList) {
        if ([record.id isEqualToString:recordId]) {
            record.is_receive = true;
            break;
        }
    }
    [self.recordsListView reloadData];
}

#pragma mark - flow

- (void)selectDate:(NSString *)dateStr type:(XYPartsFlowTimeType)type{
    switch (type) {
        case XYPartsFlowTimeTypeStart:
            self.viewModel.startTime = dateStr;
            break;
        case XYPartsFlowTimeTypeEnd:
            self.viewModel.endTime = dateStr;
            break;
        case XYPartsFlowTimeTypeStart_partApplyLog:
            self.viewModel.startTime_partApplyLog = dateStr;
            break;
        case XYPartsFlowTimeTypeEnd_partApplyLog:
            self.viewModel.endTime_partApplyLog = dateStr;
            break;

        default:
            break;
    }
}

- (void)selectPart{
    XYPartDeviceViewController* partDeviceViewController = [[XYPartDeviceViewController alloc]init];
    partDeviceViewController.delegate = self;
    [self.navigationController pushViewController:partDeviceViewController animated:true];
}

- (void)onPartSelected:(NSString*)partId name:(NSString*)name price:(NSString*)price num:(int)num{
    [self.navigationController popToViewController:self animated:true];
    self.viewModel.partId = partId;
    self.viewModel.partName = name;
    self.searchHeaderView.partField.text = XY_NOTNULL(self.viewModel.partName, @"");
}

-(void)onPartsSelected:(XYPartsSelectionDto *)partsSelection {
    [self.navigationController popToViewController:self animated:true];
    self.viewModel.partId = partsSelection.part_id;
    self.viewModel.partName = partsSelection.part_name;
    self.searchHeaderView.partField.text = XY_NOTNULL(self.viewModel.partName, @"");
}

- (void)doSearchPartsFlow{
    [self.partsFlowListView refresh];
}

-(void)doSearchPartsApplyLog {
    [self.applyListView refresh];
}

#pragma mark - public action

- (void)refreshRecordList{
    [self.recordsListView refresh];
}

-(void)goTOApplyVc {
    XYPartApplyViewController* applyViewController = [[XYPartApplyViewController alloc]init];
    [self.navigationController pushViewController:applyViewController animated:true];
}


@end
