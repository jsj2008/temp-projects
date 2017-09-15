//
//  XYPICCRemarkViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 16/9/26.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYPICCRemarkViewController.h"
#import "UIPlaceHolderTextView.h"
#import "XYCancelReasonCell.h"

@interface XYPICCRemarkViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *remarkView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIView *saveView;

@property (strong, nonatomic) NSArray* selectionsArray;
@property (strong, nonatomic) NSString* selectedString;//当前选择

@end

@implementation XYPICCRemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self customizeRemarkView];
    [self splitRemark];
}

#pragma mark - override

- (void)initializeUIElements{
    //选择
    self.navigationItem.title = @"备注信息";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //如果把separatorStyle写在tableFooterView之后，在iOS8-上会crash......
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = self.footerView;
    //如果把separatorStyle写在tableFooterView之后，在iOS8-上会crash......
    self.saveButton.layer.cornerRadius = 20.0f;
    self.saveButton.layer.masksToBounds = true;
    [XYCancelReasonCell xy_registerTableView:self.tableView identifier:[XYCancelReasonCell defaultReuseId]];
    self.remarkView.userInteractionEnabled = self.editable;
    self.saveView.hidden = !self.editable;
}

- (IBAction)saveRemark:(id)sender {
    
    if ((!self.selectedString)) {
        [self showToast:@"请补充完整信息！"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(onRemarkSaved:remark:joint:)]) {
        [self.delegate onRemarkSaved:self.selectedString remark:self.remarkView.text joint:[XYStringUtil isNullOrEmpty:self.remarkView.text]?self.selectedString:[NSString stringWithFormat:@"%@-%@",self.selectedString,self.remarkView.text]];
    }
}

#pragma mark - property

- (NSArray*)selectionsArray{
    if (!_selectionsArray) {
        _selectionsArray = @[@"维修购买",@"新机购买",@"推广购买",@"二次购买"];
    }
    return _selectionsArray;
}

- (void)customizeRemarkView{
    //备注
    [self.remarkView _initialize];
    self.remarkView.placeholder = @"如有需要说明的情况请详细填写(100字内)";
    self.remarkView.maxInputNumber = 100;
    self.remarkView.font = [UIFont systemFontOfSize:15];
    self.remarkView.backgroundColor = [UIColor whiteColor];
    self.remarkView.layer.borderColor = XY_COLOR(204,204,204).CGColor;
    self.remarkView.layer.borderWidth = LINE_HEIGHT;
    self.remarkView.placeholderTextColor = XY_HEX(0xcccccc);
    self.remarkView.textColor = XY_HEX(0x333333);
}


#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.selectionsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 37;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYCancelReasonCell* cell = [tableView dequeueReusableCellWithIdentifier:[XYCancelReasonCell defaultReuseId]];
    cell.reasonLabel.text = self.selectionsArray[indexPath.row];
    [cell setXYSelected:[cell.reasonLabel.text isEqualToString:self.selectedString]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (!self.editable) {
        return;
    }
    self.selectedString = self.selectionsArray[indexPath.row];
    [self.tableView reloadData];
}

#pragma mark - action

- (void)splitRemark{//把 格式@“%@-%@” xx购买 备注详情 拆分开展示
    if (self.remark) {
        for (NSString* selection in self.selectionsArray) {
            if ([selection isEqualToString:self.remark]) {//只有选择项，没有备注
                self.selectedString = selection;
                [self.tableView reloadData];
                return;
            }
            else if ([self.remark hasPrefix:[NSString stringWithFormat:@"%@-",selection]]) {
                //都有
                NSRange range = [self.remark rangeOfString:[NSString stringWithFormat:@"%@-",selection]];
                self.selectedString = selection;
                [self.tableView reloadData];
                self.remarkView.text = [self.remark substringFromIndex:range.length];
                return;
            }
        }
        //finally
        self.remarkView.text = self.remark;//没有选项只有备注
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
