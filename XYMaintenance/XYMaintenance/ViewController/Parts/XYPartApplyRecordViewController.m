//
//  XYPartApplyRecordViewController.m
//  XYMaintenance
//
//  Created by lisd on 2017/3/13.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYPartApplyRecordViewController.h"
#import "XYApplyRecordCell.h"
#import "XYPartsApplyRecordsHeaderView.h"
#import "XYAPIService+V10API.h"

static NSString * const kXYApplyRecordCell = @"XYApplyRecordCell";
@interface XYPartApplyRecordViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) XYPartsApplyRecordsHeaderView *headerView;
@property (strong, nonatomic) NSArray *dataArr;

@end

@implementation XYPartApplyRecordViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMainUI];
    [self initTableView];
    [self initHeaderView];
    [self loadData];
}

#pragma mark - InitUI
- (void)initMainUI {
    self.title = @"申请记录";
    [self shouldShowBackButton:true];
}
- (void)initTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:kXYApplyRecordCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kXYApplyRecordCell];
}

- (void)initHeaderView {
    CGRect headerFrame = CGRectMake(0, 0, SCREEN_WIDTH, 85);
    //套一层view，因为header Frame 存在系统问题
    UIView *tempView = [[UIView alloc] initWithFrame:headerFrame];
    [tempView setBackgroundColor:[UIColor clearColor]];
    //header
    XYPartsApplyRecordsHeaderView *headerView = [[XYPartsApplyRecordsHeaderView alloc] init];
    self.headerView = headerView;
    self.headerView.frame = headerFrame;
    self.headerView.partApplyLogDto = self.partsApplyLogDto;
    [tempView addSubview:self.headerView];
    
    [self.tableView setTableHeaderView:tempView];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XYApplyRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:kXYApplyRecordCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.partApplyLogDetailDto = self.dataArr[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark - Private methods
- (void)loadData {
    __weak typeof(self) weakself = self;
    [self showLoadingMask];
    [[XYAPIService shareInstance] getPartsApplyLogDetailByApplyLogId:self.partsApplyLogDto.id success:^(NSArray *partsLogDetailList, NSInteger sum) {
        [weakself hideLoadingMask];
        weakself.dataArr =  partsLogDetailList;
        [weakself.tableView reloadData];
    } errorString:^(NSString *err) {
        [weakself hideLoadingMask];
        [weakself showToast:err];
    }];
}

@end
