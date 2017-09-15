//
//  XYRecyleSignViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 16/7/6.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYRecyleSignViewController.h"
#import "AFBrushBoard.h"
#import "XYOrderDetailTopCell.h"
#import "XYRecyclePaymentViewController.h"
#import "UIImageView+YYWebImage.h"

@interface XYRecyleSignViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet AFBrushBoard *signBoardView;
@property (weak, nonatomic) IBOutlet UIButton *protocolButton;
@property (weak, nonatomic) IBOutlet UIButton *rewriteButton;
@end

@implementation XYRecyleSignViewController

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
    if (self.viewModel.orderDetail.sign_url) {
        [self.signBoardView yy_setImageWithURL:[NSURL URLWithString:self.viewModel.orderDetail.sign_url] options:YYWebImageOptionHandleCookies];
    }
}

#pragma mark - override

- (void)initializeUIElements{
    self.navigationItem.title = @"用户签名";
    //tableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = TABLE_DEVIDER_COLOR;
    self.tableView.scrollEnabled = false;
    [self.tableView setTableHeaderView:nil];
    [self.tableView setTableFooterView:[XYWidgetUtil getSingleLineWithColor:XY_COLOR(194,205,218)]];
    [XYOrderDetailTopCell xy_registerTableView:self.tableView identifier:[XYOrderDetailTopCell defaultReuseId]];
    //签名板
    self.signBoardView.layer.borderColor = TABLE_DEVIDER_COLOR.CGColor;
    self.signBoardView.layer.borderWidth = LINE_HEIGHT;
    [self.signBoardView updateUI];
    
    [self.protocolButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    [self.rewriteButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    
}


#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self getTopCell];
}


#pragma mark - cell

- (XYOrderDetailTopCell*)getTopCell{
    XYOrderDetailTopCell* topCell = [self.tableView dequeueReusableCellWithIdentifier:[XYOrderDetailTopCell defaultReuseId]];
    topCell.selectionStyle = UITableViewCellSelectionStyleNone;
    topCell.orderIdLabel.text = XY_NOTNULL(self.viewModel.orderDetail.mould_name, @"回收设备");
    topCell.statusLabel.text = [NSString stringWithFormat:@"最终回收价格：￥%@",@(self.viewModel.orderDetail.price)];
    return topCell;
}

- (IBAction)rewriteButtonClicked:(id)sender {
     self.viewModel.orderDetail.sign_url = nil;
    [self.signBoardView cleanBtnDidClick];
}


- (IBAction)nextStep:(id)sender {
    
//    if (!self.signBoardView.image) { 可以不签
//        [self showToast:@"请用户签名！"];
//        return;
//    }
    
    if ([XYStringUtil isNullOrEmpty:self.viewModel.orderDetail.sign_url] && self.signBoardView.image) {
        NSData* imageData = UIImageJPEGRepresentation(self.signBoardView.image,0.9);
        [self uploadImage:imageData];
    }else{
        [self goToConfirmPage];
    }
}

- (void)uploadImage:(NSData*)imgData{
    [self showLoadingMask];
    __weak __typeof(self)weakSelf = self;
    [[XYAPIService shareInstance]uploadImage:imgData type:XYPictureTypeUserSign parameters:@{@"user_name":XY_NOTNULL(self.viewModel.orderDetail.user_name, [XYAPPSingleton sharedInstance].currentUser.Name)} success:^(NSString *url){
        weakSelf.viewModel.orderDetail.sign_url = url;
        [weakSelf hideLoadingMask];
        [weakSelf goToConfirmPage];
    } errorString:^(NSString *error) {
        [weakSelf hideLoadingMask];
        [weakSelf showToast:error];
    }];
}


- (void)goToConfirmPage{
    XYRecyclePaymentViewController* payViewController = [[XYRecyclePaymentViewController alloc]init];
    payViewController.viewModel = self.viewModel;
    [self.navigationController pushViewController:payViewController animated:true];
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
