//
//  XYEditPartsSourceViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/19.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYEditPartsSourceViewController.h"
#import "XYPartInfoCell.h"
#import "XYEditSelectCell.h"
#import "SimpleEditCell.h"
#import "XYCustomButton.h"
#import "XYAPIService.h"

@interface XYEditPartsSourceViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)XYEditSelectCell* warehouseSelectCell;
@property (strong,nonatomic)SimpleEditCell* priceEditCell;
@property (weak, nonatomic) IBOutlet XYCustomButton *submitButton;
@property (assign,nonatomic) BOOL selectedBillType;

@end

@implementation XYEditPartsSourceViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - mark

-(void)initializeUIElements{
    //导航栏
    self.navigationItem.title = @"配件来源";
    [self shouldShowBackButton:true];
    //主视图
    self.tableView.scrollEnabled=false;
    self.tableView.backgroundColor = WHITE_COLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource=self;
    self.tableView.separatorColor= XY_HEX(0xeef1f5);
    [self.tableView setTableFooterView:[XYWidgetUtil getSingleLine]];
    [XYPartInfoCell xy_registerTableView:self.tableView identifier:[XYPartInfoCell defaultIdentifier]];
    [XYEditSelectCell xy_registerTableView:self.tableView identifier:[XYEditSelectCell defaultReuseId]];
    [SimpleEditCell xy_registerTableView:self.tableView identifier:[SimpleEditCell defaultReuseId]];
    //data
    self.selectedBillType = self.order.bill_type;
    [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
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
            return 2;
        default:
            return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return [XYPartInfoCell getHeight];
        case 1:
            return 45;
        default:
            return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (section==1)?LINE_HEIGHT:0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return (section==1)?[XYWidgetUtil getSingleLine]:[[UIView alloc]init];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return [self getPartInfoCell];
    }else if(indexPath.section==1){
        if (indexPath.row==0) {
            return [self getSelectCell];
        }else if(indexPath.row==1){
            return [self getEditCell];
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section==1&&indexPath.row==0) {
        [self showWareHouseActionSheet];
    }else if(indexPath.section==1&&indexPath.row==1){
        if (self.selectedBillType) {
            [self.priceEditCell startEditing];
        }
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

-(XYPartInfoCell*)getPartInfoCell{
    XYPartInfoCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[XYPartInfoCell defaultIdentifier]];
    cell.partNameLabel.text = XY_NOTNULL(self.order.partName, @"");
    cell.partIdLabel.text = XY_NOTNULL(self.order.partNumber, @"");
    return cell;
}

-(XYEditSelectCell*)getSelectCell{
    if (!_warehouseSelectCell) {
        _warehouseSelectCell = [self.tableView dequeueReusableCellWithIdentifier:[XYEditSelectCell defaultReuseId]];
        _warehouseSelectCell.xyTitleLabel.textColor = LIGHT_TEXT_COLOR;
        _warehouseSelectCell.xyContentLabel.textColor = BLACK_COLOR;
        _warehouseSelectCell.xyTitleLabel.text = @"选择仓库名：";
        _warehouseSelectCell.xyContentLabel.text = XY_NOTNULL(self.order.wareHouseString, @"");
    }
    return _warehouseSelectCell;
}

-(SimpleEditCell*)getEditCell{
    if (!_priceEditCell) {
        _priceEditCell = [self.tableView dequeueReusableCellWithIdentifier:[SimpleEditCell defaultReuseId]];
        _priceEditCell.inputField.text = [NSString stringWithFormat:@"%.2f",self.order.external_price];
        _priceEditCell.xyTitleLabel.textColor = LIGHT_TEXT_COLOR;
        [_priceEditCell setEditType:XYSimpleEditCellTypePartMoney];
        _priceEditCell.xyTitleLabel.text = @"添加价格：";
    }
    return _priceEditCell;
}

- (void)showWareHouseActionSheet{
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"内仓",@"外仓",nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    self.selectedBillType=buttonIndex;
    self.warehouseSelectCell.xyContentLabel.text = (self.selectedBillType)?@"外仓":@"内仓";
    if (!self.selectedBillType) {
        self.priceEditCell.inputField.text = @"";
    }
    [self.tableView reloadData];
}

- (IBAction)doSubmit:(id)sender {
    [self showLoadingMask];
    __weak typeof(self) weakself = self;
    [[XYAPIService shareInstance]doEditPartSource:self.order.id house:self.selectedBillType price:[self.priceEditCell.inputField.text floatValue] success:^{
        [weakself hideLoadingMask];
        weakself.order.bill_type = self.selectedBillType;
        weakself.order.wareHouseString=(self.selectedBillType)?@"外仓":@"内仓";
        weakself.order.external_price = [self.priceEditCell.inputField.text floatValue];
        [weakself.delegate onPartsSourceEdited];
        [weakself.navigationController popViewControllerAnimated:true];
    } errorString:^(NSString *erro) {
        [weakself hideLoadingMask];
        [weakself showToast:erro];
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
