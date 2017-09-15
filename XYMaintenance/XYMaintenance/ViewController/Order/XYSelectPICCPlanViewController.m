//
//  XYSelectPICCPlanViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 16/6/4.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYSelectPICCPlanViewController.h"
#import "SimpleAlignCell.h"

@interface XYSelectPICCPlanViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView* tableView;
@property(strong,nonatomic)NSArray* planArray;
@property(copy,nonatomic)NSString* companyId;
@end


@implementation XYSelectPICCPlanViewController

- (id)initWithCompanyId:(NSString *)companyId{
    
    if (self = [super init]){
        _companyId = [companyId copy];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getPlansArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 

- (void)initializeUIElements{
    self.navigationItem.title = @"选择保险业务";
    [self shouldShowBackButton:true];
    [self.view addSubview:self.tableView];
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

#pragma mark - action

- (void)getPlansArray{
    [self showLoadingMask];
    __weak typeof(self) weakself = self;
    
    [[XYAPIService shareInstance]getPICCPlanList:self.companyId success:^(NSArray *plans) {
        weakself.planArray = plans?plans:[NSArray array];
        [weakself hideLoadingMask];
        [self.tableView reloadData];
    } errorString:^(NSString *err) {
        [weakself hideLoadingMask];
        [weakself showToast:err];
    }];

}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.planArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SimpleAlignCell* cell = [tableView dequeueReusableCellWithIdentifier:[SimpleAlignCell defaultReuseId]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.xyTextLabel.font = LARGE_TEXT_FONT;
    cell.xyTextLabel.textColor = BLACK_COLOR;
    cell.xyIndicator.hidden = false;
    XYPICCPlan* plan = [self.planArray objectAtIndex:indexPath.row];
    cell.xyTextLabel.text = XY_NOTNULL(plan.name, @"");
    cell.xyDetailLabel.text = @"";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    XYPICCPlan* plan = [self.planArray objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(onPlanSelected:planName:)]) {
        [self.delegate onPlanSelected:plan.id planName:plan.name];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
