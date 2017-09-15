//
//  XYSelectPICCAgencyViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 16/6/5.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYSelectPICCAgencyViewController.h"
#import "SimpleAlignCell.h"
#import "XYSelectPICCPlanViewController.h"


@interface XYSelectPICCAgencyViewController ()<UITableViewDataSource,UITableViewDelegate,XYSelectPICCPlanDelegate>
@property(strong,nonatomic)UITableView* tableView;
@property(strong,nonatomic)NSArray* agencyArray;
@property(strong,nonatomic)NSString* agencyName;
@property(strong,nonatomic)NSString* agencyId;
@end

@implementation XYSelectPICCAgencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getAllCompanies];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override

- (void)initializeUIElements{
    self.navigationItem.title = @"选择保险公司";
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

- (void)getAllCompanies{
    
    [self showLoadingMask];
    __weak typeof(self) weakself = self;
    
    [[XYAPIService shareInstance]getPICCCompanyList:^(NSArray *companies) {
        weakself.agencyArray = companies?companies:[NSArray array];
        [weakself hideLoadingMask];
        [weakself.tableView reloadData];
    } errorString:^(NSString *err) {
        [weakself hideLoadingMask];
        [weakself showToast:err];
    }];
}



#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.agencyArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SimpleAlignCell* cell = [tableView dequeueReusableCellWithIdentifier:[SimpleAlignCell defaultReuseId]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.xyTextLabel.font = LARGE_TEXT_FONT;
    cell.xyTextLabel.textColor = BLACK_COLOR;
    cell.xyIndicator.hidden = false;
    XYPICCCompany* company = [self.agencyArray objectAtIndex:indexPath.row];
    cell.xyTextLabel.text = XY_NOTNULL(company.name, @"");
    cell.xyDetailLabel.text = @"";
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    XYPICCCompany* company = [self.agencyArray objectAtIndex:indexPath.row];
    self.agencyName = company.name;
    self.agencyId = company.id;
    
    XYSelectPICCPlanViewController* planViewController = [[XYSelectPICCPlanViewController alloc]initWithCompanyId:self.agencyId];
    planViewController.delegate = self;
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

#pragma mark - action

- (void)onPlanSelected:(NSString*)planId planName:(NSString *)name{
    if ([self.delegate respondsToSelector:@selector(onAgencySelected:agency:plan:plan:)]) {
        [self.delegate onAgencySelected:self.agencyId agency:(NSString*)self.agencyName plan:planId plan:name];
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
