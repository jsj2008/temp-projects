//
//  XYRepairSelectionsViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 16/7/18.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYRepairSelectionsViewController.h"
#import "XYOrderDetailTopCell.h"
#import "XYRepairDetailCell.h"

@interface XYRepairSelectionsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (copy, nonatomic) NSString* orderId;
@property (copy, nonatomic) NSString* orderNumber;
@property (assign, nonatomic) BOOL isAfterSale;
@property (assign, nonatomic) XYBrandType bid;

@property (strong,nonatomic) NSArray* titleArray;
@property (strong,nonatomic) NSArray* paramArray;
@property (strong,nonatomic) XYRepairSelections* selections;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation XYRepairSelectionsViewController

- (instancetype)initWithOrderId:(NSString*)orderId
                       orderNum:(NSString*)orderNumber
                            bid:(XYBrandType)bid
                    isAfterSale:(BOOL)afterSale{
   
    if (self = [super init]) {
        self.orderId = orderId;
        self.bid = bid;
        self.orderNumber = orderNumber;
        self.isAfterSale = afterSale;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getRepairSelections];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override

- (void)initializeData{
    self.titleArray = [XYRepairSelections repairSelectionTitlesArray];
    self.paramArray = [XYRepairSelections repairSelectionParamsArray];
}

- (void)initializeUIElements{
   
    self.navigationItem.title = @"维修信息";
    
    //tableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setTableFooterView:[XYWidgetUtil getSingleLine]];
    [XYOrderDetailTopCell xy_registerTableView:self.tableView identifier:[XYOrderDetailTopCell defaultReuseId]];
}

#pragma mark - property 

- (XYRepairSelections*)selections{
    if (!_selections) {
        _selections = [[XYRepairSelections alloc]init];
    }
    return _selections;
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return [self.titleArray count];
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return LINE_HEIGHT;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [XYWidgetUtil getSingleLineWithColor:XY_COLOR(194,205,218)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 45;
        case 1:
            return [XYRepairDetailCell defaultHeight];
        default:
            break;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [self getTopCell];
    }
    return [self getSegCellByIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark - cell

- (XYOrderDetailTopCell*)getTopCell{
    XYOrderDetailTopCell* topCell = [self.tableView dequeueReusableCellWithIdentifier:[XYOrderDetailTopCell defaultReuseId]];
    topCell.selectionStyle = UITableViewCellSelectionStyleNone;
    topCell.orderIdLabel.text = [NSString stringWithFormat:@"订单号：%@",(self.bid == XYBrandTypeMeizu)?self.orderNumber:self.orderId];
    topCell.statusLabel.text = self.isAfterSale?@"关联订单":@"";
    return topCell;
}

- (XYOrderDetailTopCell*)getSegCellByIndexPath:(NSIndexPath*)indexPath{
    XYOrderDetailTopCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[XYOrderDetailTopCell defaultReuseId]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.orderIdLabel.text = [NSString stringWithFormat:@" %@",[self.titleArray objectAtIndex:indexPath.row]];
    cell.statusLabel.text = XY_NOTNULL([self.selections valueForKey:[self.paramArray objectAtIndex:indexPath.row]], @"未知");
    return cell;
}

#pragma mark - action 

- (void)getRepairSelections{
    [self showLoadingMask];
    __weak __typeof__(self) weakSelf = self;
    [[XYAPIService shareInstance] getRepairSelections:self.orderId bid:self.bid success:^(XYRepairSelections *selections) {
        [weakSelf hideLoadingMask];
        weakSelf.selections = selections;
        [weakSelf.tableView reloadData];
    } errorString:^(NSString *error) {
        [weakSelf hideLoadingMask];
        [weakSelf showToast:error];
    }];
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
