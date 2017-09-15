//
//  XYPartApplyViewController.m
//  XYMaintenance
//
//  Created by lisd on 2017/3/12.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYPartApplyViewController.h"
#import "XYPartApplicationCell.h"
#import "XYPartApplyQuotaView.h"
#import "XYPartApplicationSubmitView.h"
#import "XYPartDeviceViewController.h"
#import "XYPartSelectionsViewController.h"
#import "XYPartApplicationViewModel.h"
#import "HttpCache.h"
#import "XYPartsRecordsHeaderView.h"

static NSString * const kXYPartApplicationCell = @"XYPartApplicationCell";
@interface XYPartApplyViewController ()<UITableViewDataSource, UITableViewDelegate, XYPartDeviceDelegate,SWTableViewCellDelegate, XYPartApplicationBackDelegate, XYPartApplyViewControllerDelegate>

@property (weak, nonatomic) IBOutlet XYBaseTableView *tableView;
@property (weak, nonatomic)  XYPartApplyQuotaView *headerView;
@property (weak, nonatomic)  XYPartApplicationSubmitView *submitView;
@property (strong, nonatomic) XYPartApplicationViewModel *viewModel;
@end

@implementation XYPartApplyViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMainUI];
    [self initTableView];
    [self initHeaderView];
    [self initSubmitView];
    [self initializeModelBinding];
    [self getPartAmount];
    self.viewModel.dataArr = (NSMutableArray*)[[HttpCache sharedInstance] objectForKey:cache_partSelection];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateSubmitView];
}

- (void)dealloc {
    [[HttpCache sharedInstance] setObject:self.viewModel.dataArr forKey:cache_partSelection];
}

#pragma mark - InitUI
- (void)initMainUI {
    self.title = @"申请配件";
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(selectPart)];
    self.navigationItem.rightBarButtonItem = addButtonItem;
    [self shouldShowBackButton:YES];
}

- (void)initTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:kXYPartApplicationCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kXYPartApplicationCell];
}

- (void)initHeaderView {
    CGRect headerFrame = CGRectMake(0, 0, SCREEN_WIDTH, 85);
    //套一层view，因为header Frame 存在系统问题
    UIView *tempView = [[UIView alloc] initWithFrame:headerFrame];
    [tempView setBackgroundColor:[UIColor clearColor]];
    //header
    XYPartApplyQuotaView *headerView = [[XYPartApplyQuotaView alloc] init];
    self.headerView = headerView;
    self.headerView.frame = headerFrame;
    [tempView addSubview:self.headerView];
    
    [self.tableView setTableHeaderView:tempView];
}

- (void)initSubmitView {
    XYPartApplicationSubmitView *submitView = [[XYPartApplicationSubmitView alloc] init];
    self.submitView = submitView;
    self.submitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-60, SCREEN_WIDTH, 60)];
    [containerView addSubview:self.submitView];
    self.submitView.delegate = self;
    [self.view addSubview:containerView];
}

#pragma mark - InitVM
- (void)initializeModelBinding{
    self.viewModel = [[XYPartApplicationViewModel alloc]init];
    self.viewModel.delegate = self;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYPartApplicationCell *cell = [tableView dequeueReusableCellWithIdentifier:kXYPartApplicationCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.partsSelection = self.viewModel.dataArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark - XYPartDeviceDelegate
-(void)onPartsSelected:(XYPartsSelectionDto *)partsSelection {
    [self.navigationController popToViewController:self animated:true];
    [self.viewModel.dataArr addObject:partsSelection];
    [self.tableView reloadData];
    [self updateSubmitView];
}

#pragma mark - SWTableViewCellDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    switch (index) {
        case 0:
        {
            XYPartSelectionsViewController *partSelectionsVc = [[XYPartSelectionsViewController alloc] init];
            partSelectionsVc.partsArray = [NSArray arrayWithObject:self.viewModel.dataArr[indexPath.row]];
            [partSelectionsVc setOnPartsSelectedBlock:^(XYPartsSelectionDto *partsSelection) {
                [self.navigationController popToViewController:self animated:true];
                NSLog(@"来了");
                self.viewModel.dataArr[indexPath.row] = partsSelection;
                [self.tableView reloadData];
                [self updateSubmitView];
            }];
            [self.navigationController pushViewController:partSelectionsVc animated:YES];
            break;
        }
        case 1:
        {
            [self.viewModel.dataArr removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [self updateSubmitView];
            break;
        }
        default:
            break;
    }
}

#pragma mark - XYPartApplicationBackDelegate
-(void)onPartAmountLoaded:(BOOL)success partsAmountDto:(XYPartsAmountDto *)partsAmountDto noteString:(NSString *)noteString {
    if (success) {
        self.headerView.partAmount = partsAmountDto;
    }else{
        [self showToast:noteString];
    }
}

#pragma mark - XYPartApplyViewControllerDelegate
-(void)onSubmitButtonClicked {
    if (!self.viewModel.dataArr.count) {
        [self showToast:@"请添加配件"];
        return;
    }
    [self showLoadingMask];
    [[XYAPIService shareInstance] submitParts:self.viewModel.dataArr success:^{
        [self.viewModel.dataArr removeAllObjects];
        [self.tableView reloadData];
        [self updateSubmitView];
        [self hideLoadingMask];
        [self showToast:@"提交成功"];
    } errorString:^(NSString *err) {
        [self hideLoadingMask];
        [self showToast:err];
    }];
}

#pragma mark - Private methods
- (void)selectPart {
    XYPartDeviceViewController *partDeviceViewController = [[XYPartDeviceViewController alloc] init];
    partDeviceViewController.delegate = self;
    [self.navigationController pushViewController:partDeviceViewController animated:YES];
}

- (void)getPartAmount {
    [self.viewModel loadPartAmountData];
}

-(void)updateSubmitView {
    CGFloat totalPrice = 0;
    for (XYPartsSelectionDto *partSelection in self.viewModel.dataArr) {
        CGFloat partTotalPrice = partSelection.count * [partSelection.master_avg_price floatValue];
        totalPrice += partTotalPrice;
    }
    self.submitView.totalPriceLabel.text = [NSString stringWithFormat:@"总额：¥%.2f", totalPrice];
}

@end
