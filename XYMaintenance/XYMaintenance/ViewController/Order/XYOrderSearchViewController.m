//
//  XYOrderSearchViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/5.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYOrderSearchViewController.h"
#import "XYOrderSearchViewModel.h"
#import "XYOrderDetailViewController.h"
#import "XYOrderListCell.h"
#import "XYOrderSearchViewModel.h"
#import "XYOrderListTableView.h"

@interface XYOrderSearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,XYTableViewWebDelegate,XYOrderListTableViewDelegate,XYOrderSearchCallBackDelegate,XYOrderDetailDelegate>
//UI
@property(strong,nonatomic)UIView* titleBarView;
@property(strong,nonatomic)UISearchBar* searchBar;
@property(strong,nonatomic)UIButton* cancelButton;
@property(strong,nonatomic)XYOrderListTableView* resultTableView;
//@property(strong,nonatomic)UITableView* keywordsTableView;
//DATA
@property(strong,nonatomic)XYOrderSearchViewModel* viewModel;
@property(assign,nonatomic) BOOL isKeyboardVisible;

@end

@implementation XYOrderSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardDidShow)  name:UIKeyboardDidShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide)  name:UIKeyboardWillHideNotification object:nil];
    self.isKeyboardVisible = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // [self.navigationController setNavigationBarHidden:true animated:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[XYWidgetUtil imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationItem.title = @"";
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   // [self.navigationController setNavigationBarHidden:false animated:true];
    self.navigationController.navigationBar.backgroundColor = THEME_COLOR;
    [self.navigationController.navigationBar setBackgroundImage:[XYWidgetUtil imageWithColor:THEME_COLOR] forBarMetrics:UIBarMetricsDefault];
}

- (void)dealloc{
    self.viewModel.delegate = nil;
    [self.viewModel cancelAllRequests];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - override

- (void)initializeModelBinding{
    self.viewModel = [[XYOrderSearchViewModel alloc]init];
    self.viewModel.delegate = self;
}

- (void)initializeUIElements{
    
    self.navigationItem.hidesBackButton = true;
    [self shouldShowBackButton:false];
    self.view.backgroundColor = XY_COLOR(238,240,243);
    [self.titleBarView addSubview:self.searchBar];
    [self.titleBarView addSubview:self.cancelButton];
     self.navigationItem.titleView = self.titleBarView;
    [self.view addSubview:self.resultTableView];
    
    [self.searchBar becomeFirstResponder];
    self.resultTableView.hidden = true;
    
    
    //[_searchBar setImage:[UIImage imageNamed:@"bmk_bus"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
  // TTDEBUGLOG(@"%@", [self showViewHierarchy:_searchBar level:0]);
}

#pragma mark - property 

- (UIView*)titleBarView{
    if (!_titleBarView) {
        _titleBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        _titleBarView.backgroundColor = WHITE_COLOR;
    }
    return _titleBarView;
}

- (UISearchBar*)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 65, 30)];
        _searchBar.delegate = self;
 //       _searchBar.layer.masksToBounds = true;
//        _searchBar.layer.borderColor = WHITE_COLOR.CGColor;
//        _searchBar.layer.borderWidth = 1.0f;
        _searchBar.barTintColor = MOST_LIGHT_COLOR;
        _searchBar.placeholder = @"搜索订单号或手机号";
        _searchBar.keyboardType = UIKeyboardTypeNumberPad;
        
        for (UIView *view in _searchBar.subviews) {
            if ([view isKindOfClass:[UIView class]] && view.subviews.count > 0) {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }else if ([view isKindOfClass:[UIButton class]]) {
                UIButton *cancelButton = (UIButton*)view;
                [cancelButton setTitleColor:MOST_LIGHT_COLOR forState:UIControlStateNormal];
                break;
            }
        }
        for(UIView* subView in [[_searchBar.subviews lastObject] subviews]){
            if([subView isKindOfClass:[UITextField class]]) {
                subView.backgroundColor = XY_COLOR(234,236,240);
                ((UITextField*)subView).font = LARGE_TEXT_FONT;
            }else if ([subView isKindOfClass:[UIButton class]]) {
                UIButton *cancelButton = (UIButton*)subView;
                [cancelButton setTitleColor:MOST_LIGHT_COLOR forState:UIControlStateNormal];
                break;
            }
        }
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * done = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self action:@selector(doSearchWithKeyword)];
        [done setTitleTextAttributes:@{NSForegroundColorAttributeName:BLACK_COLOR} forState:UIControlStateNormal];
        NSArray *items = [NSArray arrayWithObjects:spacer, done, nil];
        [toolBar setItems:items animated:YES];
        _searchBar.inputAccessoryView = toolBar;
    }
    return _searchBar;
}

- (UIButton*)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 0, 65, 30)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [_cancelButton setTitleColor:MOST_LIGHT_COLOR forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(onCancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

//- (UITableView*)keywordsTableView{
//    if (!_keywordsTableView) {
//        _keywordsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.titleBarView.frame.origin.y + self.titleBarView.frame.size.height, ScreenWidth, 0)];
//        _keywordsTableView.backgroundColor = WHITE_COLOR;
//        _keywordsTableView.separatorColor = TABLE_DEVIDER_COLOR;
//        _keywordsTableView.delegate = self;
//        _keywordsTableView.dataSource = self;
//    }
//    return _keywordsTableView;
//}

- (XYOrderListTableView*)resultTableView{
    if (!_resultTableView) {
        _resultTableView = [[XYOrderListTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT)];
        _resultTableView.type = XYOrderListViewTypeSearch;
        _resultTableView.backgroundColor = XY_COLOR(238,240,243);
        _resultTableView.separatorColor = TABLE_DEVIDER_COLOR;
        _resultTableView.webDelegate = self;
        _resultTableView.orderTableViewDelegate = self;
        [_resultTableView enableDragToRefresh:false];
    }
    return _resultTableView;
}

//- (NSString *)showViewHierarchy:(UIView *)view level:(NSInteger)level
//{
//    NSMutableString * description = [NSMutableString string];
//    NSMutableString * indent = [NSMutableString string];
//    for (NSInteger i = 0; i < level; i++)
//    {
//        [indent appendString:@"  |"];
//    }
//    
//    [description appendFormat:@"\n%@%@", indent, [view description]];
//    for (UIView * item in view.subviews)
//    {
//        [description appendFormat:@"%@", [self showViewHierarchy:item level:level + 1]];
//    }
//    return [description copy];
//}


#pragma mark - 跳转逻辑

-(void)doSearchWithKeyword{
    if ([XYStringUtil isNullOrEmpty:self.searchBar.text]) {
        return;
    }
    [self doSearchWithKeyword:self.searchBar.text];
}

-(void)doSearchWithKeyword:(NSString*)keyword{
    [self.searchBar resignFirstResponder];
    [self showLoadingMask];
    [self.viewModel doSearchWithKeyword:keyword startPage:1];
}

- (void)goBack{
    [self.searchBar resignFirstResponder];
    [self.navigationController popToRootViewControllerAnimated:false];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.navigationController.navigationBar endEditing:false];
    [self.searchBar resignFirstResponder];
}


#pragma mark - searchbar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.resultTableView.hidden = true;
    [self.viewModel findKeywordsByString:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if ([XYStringUtil isNullOrEmpty:searchBar.text]) {
        return;
    }
    [self doSearchWithKeyword];
}

- (void)onCancelButtonClicked{
    [self.navigationController popViewControllerAnimated:false];
}

#pragma mark - tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel.keywordsList count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.textLabel.font = LARGE_TEXT_FONT;
            cell.textLabel.textColor = BLACK_COLOR;
        }
        
        cell.textLabel.text = [self.viewModel.keywordsList objectAtIndex:indexPath.row];
        return cell;
    
}

-(void)tableView:(XYBaseTableView*)tableView loadData:(NSInteger)p{
    [self showLoadingMask];
    [self.viewModel doSearchWithKeyword:self.searchBar.text startPage:p];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    [self doSearchWithKeyword:[self.viewModel.keywordsList objectAtIndex:indexPath.row]];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
        
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}

#pragma makr - orderList

- (void)goToAllOrderDetail:(NSString *)orderId type:(XYAllOrderType)type bid:(XYBrandType)bid{
    if (type == XYAllOrderTypeRepair) {
        [self goToOrderDetail:orderId bid:bid];
    }
}

- (void)goToOrderDetail:(NSString*)order bid:(XYBrandType)bid{
    XYOrderDetailViewController* orderDetailViewController = [[XYOrderDetailViewController alloc]initWithOrderId:order brand:bid];
    orderDetailViewController.delegate = self;
    [self.navigationController pushViewController:orderDetailViewController animated:true];
}

- (void)changeStatusOfOrder:(NSString*)orderId into:(XYOrderStatus)status bid:(XYBrandType)bid{
    
    if(status == XYOrderStatusCancelled){
        //弹框
    }else{
        [self showLoadingMask];
        [self.viewModel turnStateOfOrder:orderId into:status bid:bid];
    }
}

- (void)payByCashOfOrder:(NSString *)orderId bid:(XYBrandType)bid{
    [self showLoadingMask];
    [self.viewModel payOrderByCash:orderId bid:bid];
}

#pragma mark - call back

-(void)onKeywordsFound{

//    
//    [self.keywordsTableView reloadData];
}

-(void)onSearchResultLoaded:(NSArray *)resultList isRefresh:(BOOL)isRefresh totalCount:(NSInteger)totalCount{
    [self hideLoadingMask];
    self.resultTableView.hidden = false;
    [self.resultTableView addListItems:resultList isRefresh:isRefresh withTotalCount:totalCount];
}

- (void)onLoadingResultFailed:(NSString*)errorString{
    [self.resultTableView onLoadingFailed];
    [self hideLoadingMask];
    [self showToast:errorString];
}

-(void)onStatusOfOrder:(NSString *)orderId changedInto:(XYOrderStatus)status{
    [self.viewModel doSearchWithKeyword:self.searchBar.text startPage:1];
}

-(void)onStatusOfOrder:(NSString *)orderId changingFailed:(NSString*)errorString{
    [self hideLoadingMask];
    [self showToast:errorString];
}

-(void)onOrderPaidByCash:(NSString *)orderId
{
    [self.viewModel doSearchWithKeyword:self.searchBar.text startPage:1];
}

-(void)onOrderStatusChanged:(XYOrderBase *)order{
   [self.viewModel doSearchWithKeyword:self.searchBar.text startPage:1];
}


#pragma mark - keyboard

- (void)keyboardDidShow{
    _isKeyboardVisible = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = false;
}

- (void)keyboardDidHide{
    _isKeyboardVisible = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
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
