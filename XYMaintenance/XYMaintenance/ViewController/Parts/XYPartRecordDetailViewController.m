//
//  XYPartRecordDetailViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/24.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYPartRecordDetailViewController.h"
#import "SimpleAlignCell.h"
#import "XYPartCell.h"
#import "XYCustomButton.h"

@interface XYPartRecordDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray* titleArray;
@property (strong, nonatomic) IBOutlet UIView *partsFooterView;
@property (weak, nonatomic) IBOutlet UILabel *partsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderHeight;
@property (weak, nonatomic) IBOutlet XYCustomButton *confirmButton;


@end

@implementation XYPartRecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeUIElements{
   //导航
    self.navigationItem.title = @"详情";
    [self shouldShowBackButton:true];
    //table
    self.tableView.backgroundColor = WHITE_COLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource=self;
    self.tableView.rowHeight = 45;
    self.tableView.separatorColor= XY_HEX(0xeef1f5);
    [self.tableView setTableFooterView:self.partsFooterView];
    [SimpleAlignCell xy_registerTableView:self.tableView identifier:[SimpleAlignCell defaultReuseId]];
    [XYPartCell xy_registerTableView:self.tableView identifier:[XYPartCell defaultReuseId]];
    self.deviderHeight.constant = LINE_HEIGHT;
  
    self.titleArray = @[@{@"日期：":self.recordDto.recordTimeStr},@{@"批次：":self.recordDto.odd_number},@{@"来源仓库：":self.recordDto.city_name}];
    
    //TODO
    self.partsCountLabel.text = [NSString stringWithFormat:@"%@",@(self.recordDto.total_num)];
    
    //TODO
    [self.confirmButton setTitle:@"确认领取" forState:UIControlStateNormal];
    [self.confirmButton setTitle:@"已领取" forState:UIControlStateDisabled];
    [self.confirmButton setButtonEnable:!self.recordDto.is_receive];
    
    self.partsCountLabel.textColor = self.unitLabel.textColor = THEME_COLOR;
}



#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 3;
        case 1:
            return [self.recordDto.parts count];
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return LINE_HEIGHT;
    }
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return [XYWidgetUtil getSingleLineWithColor:XY_HEX(0xeef1f5)];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 45;
        case 1:
            return [XYPartCell defaultHeight];
        default:
            return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [self getSimpleCellByIndex:indexPath];
    }else if (indexPath.section == 1){
        return [self getPartsCellByIndex:indexPath];
    }
    return nil;
}

- (SimpleAlignCell*)getSimpleCellByIndex:(NSIndexPath*)path{
    SimpleAlignCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[SimpleAlignCell defaultReuseId]];
    cell.xyTextLabel.font = cell.xyDetailLabel.font = SIMPLE_TEXT_FONT;
    cell.xyTextLabel.textColor= MOST_LIGHT_COLOR;
    cell.xyDetailLabel.textColor=LIGHT_TEXT_COLOR;
    cell.xyIndicator.hidden=true;
    NSDictionary* titledic =  self.titleArray[path.row];
    cell.xyTextLabel.text = [titledic allKeys][0];
    cell.xyDetailLabel.text = XY_NOTNULL([titledic objectForKey:cell.xyTextLabel.text],@"");
    return cell;
}

- (XYPartCell*)getPartsCellByIndex:(NSIndexPath*)path{
    XYPartCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[XYPartCell defaultReuseId]];
    XYPartDto* part = [self.recordDto.parts objectAtIndex:path.row];
    [cell setClaimDetailData:part];
    return cell;
}


#pragma mark - action 

- (IBAction)confirmButtonClick:(id)sender {
    
    if(self.recordDto.is_receive){//已经领取过了
        [self.confirmButton setButtonEnable:false];
        return;
    }
    
    [self showLoadingMask];
    [[XYAPIService shareInstance] confirmClaiming:self.recordDto.id bid:self.recordDto.bid success:^{
        [self hideLoadingMask];
        self.recordDto.is_receive = true;
        [self.confirmButton setButtonEnable:false];
    } errorString:^(NSString *error) {
        [self hideLoadingMask];
        [self showToast:error?error:@"领取失败"];
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
