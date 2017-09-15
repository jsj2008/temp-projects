//
//  XYNoticeViewController.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/20.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYNoticeViewController.h"
#import "XYNoticeViewModel.h"
#import "XYNoticeCell.h"
#import "AppDelegate.h"
#import "XYRootViewController.h"
#import "XYWidgetUtil.h"
#import "XYOrderDetailViewController.h"

@interface XYNoticeViewController ()<UITableViewDelegate,UITableViewDataSource,XYTableViewWebDelegate,XYNoticeCallBackDelegate,SWTableViewCellDelegate>
{
    XYBaseTableView* _tableView;
    XYNoticeViewModel* _viewModel;
}
@end

@implementation XYNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    _viewModel.delegate = nil;
    [_viewModel cancelAllRequests];
}

#pragma mark - override

- (void)initializeModelBinding
{
    _viewModel = [[XYNoticeViewModel alloc]init];
    _viewModel.delegate = self;
}

- (void)initializeUIElements
{
    self.navigationItem.title = @"消息通知";
    [self shouldShowBackButton:true];
    
    _tableView = [[XYBaseTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT)];
    _tableView.backgroundColor = WHITE_COLOR;
    _tableView.separatorColor = TABLE_DEVIDER_COLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.webDelegate = self;
    [_tableView setTableHeaderView:nil];
    [_tableView setTableFooterView:[XYWidgetUtil getSingleLineWithInset:15]];
    [self.view addSubview:_tableView];
    
    [_tableView refresh];
}


#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isKindOfClass:[XYBaseTableView class]])
    {
       return [((XYBaseTableView*)tableView).dataList count];
    }
    
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = [XYNoticeCell defaultReuseId];
    
    XYNoticeCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellIdentifier owner:self options:nil]lastObject];
        NSMutableArray *rightUtilityButtons = [[NSMutableArray alloc]init];
        [rightUtilityButtons sw_addUtilityButtonWithColor:MOST_LIGHT_COLOR title:@"删除"];
        cell.rightUtilityButtons = rightUtilityButtons;
        cell.delegate = self;
    }
    
    if ([tableView isKindOfClass:[XYBaseTableView class]])
    {
        [cell setData:[((XYBaseTableView*)tableView).dataList objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [XYNoticeCell defaultHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
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

- (void)tableView:(XYBaseTableView *)tableView loadData:(NSInteger)nextStartIndex
{
    [self showLoadingMask];
    [_viewModel loadNotices:nextStartIndex];
}

#pragma mark - swipe cell delegate

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    XYNoticeDto* dto = [_tableView.dataList objectAtIndex:indexPath.row];
    [_tableView removeListItem:dto];
    [_tableView reloadData];
    [_viewModel deleteNotice:dto.orderId];
    [cell hideUtilityButtonsAnimated:YES];
}

#pragma mark - call back

-(void)onNoticesLoaded:(NSArray *)array totalCount:(NSInteger)totalCount isRefresh:(BOOL)isRefresh
{
    [self hideLoadingMask];
    [_tableView addListItems:array isRefresh:true withTotalCount:totalCount];
}

-(void)onNoticeLoadingFailed:(NSString *)errorString
{
    [self hideLoadingMask];
    [_tableView onLoadingFailed];
    [self showToast:errorString];
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
