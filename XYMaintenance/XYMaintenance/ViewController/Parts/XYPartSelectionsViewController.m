//
//  XYPartSelectionsViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 17/1/3.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYPartSelectionsViewController.h"
#import "XYPartSelectionCell.h"

@interface XYPartSelectionsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(assign,nonatomic) id<XYPartSelectionsDelegate> delegate;
@property(copy,nonatomic) NSString* deviceId;
@property(copy,nonatomic) NSString* faultId;
@property(copy,nonatomic) NSString* colorId;

@property(strong,nonatomic) UITableView* tableView;
@property(assign,nonatomic) BOOL isHideCellCountView;
@property(assign,nonatomic) BOOL isRequestData;
@end

@implementation XYPartSelectionsViewController

- (instancetype)initWithDevice:(NSString *)deviceId fault:(NSString *)faultId color:(NSString *)colorId delegate:(id<XYPartSelectionsDelegate>)delegate{
    if (self = [super init]) {
        self.deviceId = deviceId;
        self.faultId = faultId;
        self.colorId = colorId;
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self checkPreVc];
    if ([self isHttpRequest]) {
        [self getPlansArray];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override

- (void)initializeUIElements{
    self.navigationItem.title = @"选择配件";
    [self shouldShowBackButton:true];
    [self.view addSubview:self.tableView];
}

- (NSArray*)partsArray{
    if (!_partsArray) {
        _partsArray = [[NSMutableArray alloc]init];
    }
    return _partsArray;
}

- (UITableView*)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT)];
        _tableView.backgroundColor = WHITE_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:nil];
        [_tableView setTableHeaderView:nil];
        [XYPartSelectionCell xy_registerTableView:_tableView identifier:[XYPartSelectionCell defaultReuseId]];
    }
    return _tableView;
}

- (void)getPlansArray{
    [self showLoadingMask];
    __weak typeof(self) weakself = self;
    [[XYAPIService shareInstance]getPartsFlowSelectionsByDevice:self.deviceId fault:self.faultId color:self.colorId success:^(NSArray *partsList){
        weakself.partsArray = partsList;
        [weakself hideLoadingMask];
        [weakself.tableView reloadData];
    }errorString:^(NSString *errorString){
        [weakself hideLoadingMask];
        [weakself showToast:errorString];
    }];
}

- (BOOL)isHttpRequest {
    if (self.navigationController.viewControllers.count>=2) {
        UIViewController *preVc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        if ([NSStringFromClass([preVc class]) isEqualToString:@"XYPartApplyViewController"]) {
            self.isRequestData = NO;
        }else {
            self.isRequestData = YES;
        }
    }
    return self.isRequestData;
}

- (BOOL)checkPreVc {
    if (self.navigationController.viewControllers.count>=5) {
        UIViewController *myPartVc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-5];
        if ([NSStringFromClass([myPartVc class]) isEqualToString:@"XYMyPartsViewController"]) {
            self.isHideCellCountView = YES;
        }else {
            self.isHideCellCountView = NO;
        }
    }else {
        self.isHideCellCountView = NO;
    }
    return self.isHideCellCountView;
}
#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.partsArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYPartSelectionCell* cell = [tableView dequeueReusableCellWithIdentifier:[XYPartSelectionCell defaultReuseId]];
    XYPartsSelectionDto* dto = [self.partsArray objectAtIndex:indexPath.row];
    dto.count = dto.count ? dto.count : 1;
    dto.isHideCellCountView = self.isHideCellCountView;
    __weak __typeof(self)weakSelf = self;
    [cell setNumChangeBlock:^(NSInteger num) {
        dto.count = num;
        [weakSelf.tableView reloadData];
    }];
    [cell setData:dto];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [XYPartSelectionCell defaultHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    XYPartsSelectionDto* dto = [self.partsArray objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(onPartsSelected:)]) {
        [self.delegate onPartsSelected:dto];
    }
    !_onPartsSelectedBlock ?: _onPartsSelectedBlock(dto);
}


@end
